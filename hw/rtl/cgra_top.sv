// Copyright 2022 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

module cgra_top
  import cgra_pkg::*;
  import reg_pkg::*;
(
  input  logic                           clk_i,
  input  logic                           rst_ni,
  // APB interface
  input  reg_req_t                       reg_req_i,
  output reg_rsp_t                       reg_rsp_o,
  // AHB Master port
  output logic [                 MP-1:0] tcdm_req_o,
  output logic [ DATA_BUS_ADD_WIDTH-1:0] tcdm_add_o [0:MP-1],
  output logic [                 MP-1:0] tcdm_wen_o,
  output logic [                  4-1:0] tcdm_be_o [0:MP-1],
  output logic [DATA_BUS_DATA_WIDTH-1:0] tcdm_wdata_o [0:MP-1],
  input  logic [                 MP-1:0] tcdm_gnt_i,
  input  logic [DATA_BUS_DATA_WIDTH-1:0] tcdm_rdata_i [0:MP-1],
  input  logic [                 MP-1:0] tcdm_r_valid_i,
  // AHB Slave port
  input  logic                           cm_req_i,
  input  logic [ DATA_BUS_ADD_WIDTH-1:0] cm_add_i,
  input  logic                           cm_we_i,
  input  logic [                  4-1:0] cm_be_i,
  input  logic [DATA_BUS_DATA_WIDTH-1:0] cm_wdata_i,
  output logic                           cm_gnt_o,
  output logic                           cm_rvalid_o,
  // Context memory decoder to actual SRAM macro
  input  logic                           clk_mem_cg_i,
  output logic                           clk_mem_en_o,
  output logic [              N_ROW-1:0] cm_row_req_o,
  output logic                           cm_we_o,
  output logic [  IMEM_N_LINES_LOG2-1:0] cm_addr_o,
  input  logic [        INSTR_WIDTH-1:0] rcs_cmem_rdata_i [0:N_ROW-1],
  // CGRA interrupts
  output logic [            N_SLOTS-1:0] evt_o
);

  logic [              N_COL-1:0] rcs_data_req_s;
  logic [              N_COL-1:0] rcs_data_wen_s;
  logic [              N_COL-1:0] rcs_data_ind_s;
  logic [           DP_WIDTH-1:0] rcs_data_add_s [0:N_COL-1];
  logic [           DP_WIDTH-1:0] rcs_data_wdata_s [0:N_COL-1];
  logic [           DP_WIDTH-1:0] rcs_data_rdata_s [0:N_COL-1];
  logic [              N_COL-1:0] rcs_data_gnt_s;
  logic [              N_COL-1:0] rcs_data_rvalid_s;
  logic [              N_COL-1:0] data_stall_s ;
  logic [KER_CONF_N_REG_LOG2-1:0] ker_id_req_s;
  logic [              N_COL-1:0] acc_end_s;
  logic [         KMEM_WIDTH-1:0] kmem_word_s;
  logic [              N_COL-1:0] rcs_col_e_s;
  logic [              N_COL-1:0] rcs_conf_we_s;
  logic [              N_COL-1:0] rcs_conf_re_s;
  logic [              N_COL-1:0] acc_req_s;
  logic                           acc_ack_s;
  logic [  RCS_NUM_CREG_LOG2-1:0] rcs_pc_s [0:N_COL-1];
  logic [              N_COL-1:0] rcs_rst_col_s;
  logic [              N_COL-1:0] rcs_pc_e_s;
  logic [              N_COL-1:0] col_start_s;
  logic [              N_COL-1:0] rcs_conf_ack_s;
  logic [              N_COL-1:0] rcs_br_req_s ;
  logic [  RCS_NUM_CREG_LOG2-1:0] rcs_br_add_s [0:N_COL-1];
  logic [              N_COL-1:0] rcs_stall_s;
  logic [RC_INSTR_N_REG_LOG2-1:0] imem_radd_s;
  logic [              N_COL-1:0] rcs_exec_end_s;
  logic [              N_COL-1:0] col_acc_map_s [0:N_COL-1];
  logic [           DP_WIDTH-1:0] rd_ptr_s [0:MAX_COL_REQ-1];
  logic [           DP_WIDTH-1:0] wr_ptr_s [0:MAX_COL_REQ-1];
  logic                           imem_gnt_ctrl_s;
  logic                           imem_rvalid_ctrl_s;
  logic                           rcs_conf_req_s;

  // Print message everytime CGRA periph regs are accessed for profiling
  // pragma translate_off
  longint cc_count;
  always @(posedge clk_i or negedge rst_ni) begin
    if (rst_ni == 1'b0) begin
      cc_count <= 0;
    end else begin
      if (reg_req_i.valid == 1'b1 && reg_rsp_o.ready == 1'b1 && reg_req_i.addr[N_PERIPH_REGS_LOG2+2-1:2] == CGRA_APB_REG_STATE) begin
        $display("[CGRA] %t : GLOBAL CLOCK-CYCLE COUNTER: %l", $time, cc_count);
      end
      cc_count <= cc_count + 1;
    end
  end
  // pragma translate_on

  logic [N_COL-1:0] clk_rcs_cg;

  `ifndef VERILATOR
    // Activate the clock of a column when it is active only
    generate
      for (genvar j=0; j<N_COL; j++) begin : rcs_col_cg_gen
        cgra_clock_gate clk_gate_rcs_col_i (
          .clk_i     ( clk_i ),
          .test_en_i ( 1'b0 ),
          .en_i      ( rcs_col_e_s[j] ),
          .clk_o     ( clk_rcs_cg[j] )
        ); 
      end
    endgenerate
  `else
    // The verilator simulator fails to properly schedule the event when two registers
    // are control by an original clk signal and a clock gated signal. Probably a problem
    // in the event scheduling in v4.2 (this might be solved in v5). For now we use this
    // trick to make sure input data and internal clock signal to the CGRA are updated
    // at the same delta cycle. This is not a problem with all simulators. For example,
    // modelsim correctly simulates this design without this trick.
    assign clk_rcs_cg[0] = clk_i;
    assign clk_rcs_cg[1] = clk_i;
    assign clk_rcs_cg[2] = clk_i;
    assign clk_rcs_cg[3] = clk_i;
  `endif


  //---------------------------------------------------------------------
  //
  // Component(s) mapping
  //
  //---------------------------------------------------------------------

  synchronizer cgra_synchronizer_i (
    .clk_i            ( clk_i            ),
    .rst_ni           ( rst_ni           ),
    .acc_ack_i        ( acc_ack_s        ),
    .acc_end_i        ( acc_end_s        ),
    .conf_word_i      ( kmem_word_s      ),
    .col_start_i      ( col_start_s      ),
    .col_stall_i      ( data_stall_s     ),
    .reg_req_i        ( reg_req_i        ),
    .reg_rsp_o        ( reg_rsp_o        ),
    .acc_req_o        ( acc_req_s        ),
    .ker_id_req_o     ( ker_id_req_s     ),
    .rd_ptr_o         ( rd_ptr_s         ),
    .wr_ptr_o         ( wr_ptr_s         ),
    .col_acc_map_o    ( col_acc_map_s    ),
    .evt_o            ( evt_o            )
  );

  cgra_controller cgra_ctrl_i (
    .clk_i              ( clk_i              ),
    .rst_ni             ( rst_ni             ),
    .acc_req_i          ( acc_req_s          ),
    .imem_gnt_ctrl_i    ( imem_gnt_ctrl_s    ),
    .imem_rvalid_ctrl_i ( imem_rvalid_ctrl_s ),
    .kmem_rdata_i       ( kmem_word_s        ),
    .ker_id_req_i       ( ker_id_req_s       ),
    .data_stall_i       ( data_stall_s       ),
    .rcs_br_req_i       ( rcs_br_req_s       ),
    .rcs_br_add_i       ( rcs_br_add_s       ),
    .rcs_stall_i        ( rcs_stall_s        ),
    .rcs_exec_end_i     ( rcs_exec_end_s     ),
    .rcs_conf_we_o      ( rcs_conf_we_s      ),
    .rcs_conf_re_o      ( rcs_conf_re_s      ),
    .rcs_pc_e_o         ( rcs_pc_e_s         ),
    .rcs_pc_o           ( rcs_pc_s           ),
    .col_e_o            ( rcs_col_e_s        ),
    .rcs_rst_col_o      ( rcs_rst_col_s      ),
    .rcs_conf_ack_o     ( rcs_conf_ack_s     ),
    .imem_radd_o        ( imem_radd_s        ),
    .rcs_conf_req_o     ( rcs_conf_req_s     ),
    .col_start_o        ( col_start_s        ),
    .acc_ack_o          ( acc_ack_s          ),
    .acc_end_o          ( acc_end_s          )
  );

  cgra_rcs cgra_rcs_i
  (
    .clk_i            ( clk_rcs_cg        ),
    .rst_col_i        ( rcs_rst_col_s     ),
    .rcs_conf_we_i    ( rcs_conf_we_s     ),
    .rcs_conf_re_i    ( rcs_conf_re_s     ),
    .rcs_col_pc_i     ( rcs_pc_s          ),
    .rcs_conf_words_i ( rcs_cmem_rdata_i  ),
    .rcs_pc_e_i       ( rcs_pc_e_s        ),
    .data_rdata_i     ( rcs_data_rdata_s  ),
    .data_gnt_i       ( rcs_data_gnt_s    ),
    .data_rvalid_i    ( rcs_data_rvalid_s ),
    .col_acc_map_i    ( col_acc_map_s     ),
    .data_req_o       ( rcs_data_req_s    ),
    .data_wen_o       ( rcs_data_wen_s    ),
    .data_ind_o       ( rcs_data_ind_s    ),
    .data_add_o       ( rcs_data_add_s    ),
    .data_wdata_o     ( rcs_data_wdata_s  ),
    .rcs_br_req_o     ( rcs_br_req_s      ),
    .rcs_br_add_o     ( rcs_br_add_s      ),
    .rcs_stall_o      ( rcs_stall_s       ),
    .exec_end_o       ( rcs_exec_end_s    )
  );

  data_bus_handler cgra_data_handler_i
  (
    .clk_i             ( clk_i             ),
    .rst_ni            ( rst_ni            ),
    .rcs_data_req_i    ( rcs_data_req_s    ),
    .rcs_data_wen_i    ( rcs_data_wen_s    ),
    .rcs_data_ind_i    ( rcs_data_ind_s    ),
    .rcs_data_add_i    ( rcs_data_add_s    ),
    .rcs_data_wdata_i  ( rcs_data_wdata_s  ),
    .rd_ptr_i          ( rd_ptr_s          ),
    .wr_ptr_i          ( wr_ptr_s          ),
    .bus_data_gnt_i    ( tcdm_gnt_i        ),
    .bus_data_rdata_i  ( tcdm_rdata_i      ),
    .bus_r_valid_i     ( tcdm_r_valid_i    ),
    .col_start_i       ( col_start_s       ),
    .col_conf_ack_i    ( rcs_conf_ack_s    ),
    .col_acc_map_i     ( col_acc_map_s     ),
    .bus_data_req_o    ( tcdm_req_o        ),
    .bus_data_add_o    ( tcdm_add_o        ),
    .bus_data_wen_o    ( tcdm_wen_o        ),
    .bus_data_be_o     ( tcdm_be_o         ),
    .bus_data_wdata_o  ( tcdm_wdata_o      ),
    .rcs_data_rdata_o  ( rcs_data_rdata_s  ),
    .rcs_data_gnt_o    ( rcs_data_gnt_s    ),
    .rcs_data_rvalid_o ( rcs_data_rvalid_s ),
    .data_stall_o      ( data_stall_s      )
  );

  context_memory_decoder cgra_context_memory_decoder_i
  (
    .clk_i              ( clk_i              ),
    .rst_ni             ( rst_ni             ),
    .clk_mem_cg_i       ( clk_mem_cg_i       ),
    .clk_mem_en_o       ( clk_mem_en_o       ),
    .cm_req_i           ( cm_req_i           ),
    .cm_add_i           ( cm_add_i           ),
    .cm_we_i            ( cm_we_i            ),
    .cm_be_i            ( cm_be_i            ),
    .cm_wdata_i         ( cm_wdata_i         ),
    .cm_gnt_o           ( cm_gnt_o           ),
    .cm_rvalid_o        ( cm_rvalid_o        ),
    .rcs_conf_req_i     ( rcs_conf_req_s     ),
    .imem_radd_i        ( imem_radd_s        ),
    .kmem_radd_i        ( ker_id_req_s       ),
    .imem_gnt_ctrl_o    ( imem_gnt_ctrl_s    ),
    .imem_rvalid_ctrl_o ( imem_rvalid_ctrl_s ),
    .kmem_rdata_o       ( kmem_word_s        ),
    .cm_row_req_o       ( cm_row_req_o       ),
    .cm_we_o            ( cm_we_o            ),
    .cm_addr_o          ( cm_addr_o          )
  );

endmodule
