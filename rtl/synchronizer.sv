// Copyright 2022 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

module synchronizer
  import cgra_pkg::*;
  import reg_pkg::*;
(
  input  logic                           clk_i,
  input  logic                           rst_ni,
  input  logic                           acc_ack_i,
  input  logic [              N_COL-1:0] acc_end_i,
  input  logic [         KMEM_WIDTH-1:0] conf_word_i,
  input  logic [              N_COL-1:0] col_start_i,
  input  logic [              N_COL-1:0] col_stall_i,
  input  reg_req_t                       reg_req_i,
  output reg_rsp_t                       reg_rsp_o,
  output logic [              N_COL-1:0] acc_req_o,
  output logic [KER_CONF_N_REG_LOG2-1:0] ker_id_req_o,
  output logic [           DP_WIDTH-1:0] rd_ptr_o [0:MAX_COL_REQ-1],
  output logic [           DP_WIDTH-1:0] wr_ptr_o [0:MAX_COL_REQ-1],
  output logic [              N_COL-1:0] col_acc_map_o [0:N_COL-1],
  output logic [            N_SLOTS-1:0] evt_o
);

  typedef enum logic [2-1:0] { SYNC_FSM_LOOP_REQ  = 2'b00, 
                               SYNC_FSM_READ_CONF = 2'b01,
                               SYNC_FSM_FIND_COL  = 2'b10,
                               SYNC_FSM_WAIT_ACK  = 2'b11,
                               SYNC_FSM_XXX       = 'x   } sync_fsm_state_typ;

  sync_fsm_state_typ sync_fsm_state, sync_fsm_n_state;

  logic                           pending_req_s;
  logic [       N_SLOTS_LOG2-1:0] req_loop_cnt;
  logic [KER_CONF_N_REG_LOG2-1:0] ker_id_req_s;
  logic [              N_COL-1:0] map_ready [0:N_COL-1];
  logic [              N_COL-1:0] col_map_sel [0:N_COL-1];
  logic [              N_COL-1:0] col_status_reg;
  logic [              N_COL-1:0] acc_req_reg;
  logic [              N_COL-1:0] acc_req_mapped;
  logic [KER_CONF_N_REG_LOG2-1:0] conf_w_add_reg;
  logic [              N_COL-1:0] ker_col_req_s;
  logic [              N_COL-1:0] ker_col_req_reg;
  logic [       N_SLOTS_LOG2-1:0] c_id_exec [0:N_COL-1];
  logic [KER_CONF_N_REG_LOG2-1:0] core_ker_id_req_s [0:N_SLOTS-1];
  logic [              N_COL-1:0] col_acc_map_reg [0:N_COL-1];
  logic [           DP_WIDTH-1:0] core_rd_ptr_s [0:N_SLOTS-1][0:MAX_COL_REQ-1];
  logic [           DP_WIDTH-1:0] core_wr_ptr_s [0:N_SLOTS-1][0:MAX_COL_REQ-1];

  genvar j;

  assign ker_id_req_s = core_ker_id_req_s[req_loop_cnt];

  assign ker_id_req_o = conf_w_add_reg;
  assign ker_col_req_s = conf_word_i[KER_N_COL_HB:KER_N_COL_LB];

  // Create all the possible mapping solutions
  always_comb begin : col_map_sel_process
    // First possible mapping is given by ker_col_req_reg
    col_map_sel[0] = ker_col_req_reg;
    // The other possible mappings are derived from it.
    for (int i=1; i<N_COL; i++) begin
      col_map_sel[i][0] = col_map_sel[i-1][N_COL-1];
      for (int k=1; k<N_COL; k++) begin
        col_map_sel[i][k] = col_map_sel[i-1][k-1];
      end
    end
  end

  // Check which mapping are actually possible
  always_comb begin : map_ready_process
    for (int i=0; i<N_COL; i++) begin
      map_ready[i] = ~col_status_reg & col_map_sel[i];
    end
  end

  assign acc_req_o     = acc_req_reg;
  assign col_acc_map_o = col_acc_map_reg;

  ///////////////////////////////////////////////////////////////////////
  //
  // Pending request detection logic
  //
  ///////////////////////////////////////////////////////////////////////
  always_comb
  begin

    pending_req_s = 1'b0;
    
    for (int i=0; i<N_SLOTS; i++) begin
      pending_req_s = pending_req_s|(|core_ker_id_req_s[i]);
    end
  end

  ///////////////////////////////////////////////////////////////////////
  //
  // Synchronizer FSM
  //
  ///////////////////////////////////////////////////////////////////////
  always_comb
  begin

    sync_fsm_n_state = SYNC_FSM_XXX;
    acc_req_mapped   = '0;

    unique case (sync_fsm_state)

      SYNC_FSM_LOOP_REQ:
      begin
        if ((|ker_id_req_s) == 1'b1) begin
          sync_fsm_n_state = SYNC_FSM_READ_CONF;
        end else begin
          sync_fsm_n_state = SYNC_FSM_LOOP_REQ;
        end
      end

      SYNC_FSM_READ_CONF:
      begin
        sync_fsm_n_state = SYNC_FSM_FIND_COL;
      end

      // wait free column(s) to map the acceleration
      SYNC_FSM_FIND_COL:
      begin
        for (int i=0; i<N_COL; i++) begin
          if (map_ready[i] == col_map_sel[i]) begin
            acc_req_mapped   = col_map_sel[i];
            sync_fsm_n_state = SYNC_FSM_WAIT_ACK;
            break;
          end
        end
      end

      SYNC_FSM_WAIT_ACK:
      begin
        if(acc_ack_i == 1'b1) begin
          sync_fsm_n_state = SYNC_FSM_LOOP_REQ;
        end else begin
          sync_fsm_n_state = SYNC_FSM_WAIT_ACK;
        end
      end

      default: sync_fsm_n_state = SYNC_FSM_XXX;
    endcase  
  end

  ///////////////////////////////////////////////////////////////////////
  //
  // Synchronizer flip-flops
  //
  ///////////////////////////////////////////////////////////////////////

  always_ff @(posedge clk_i, negedge rst_ni)
  begin
    if(rst_ni == 1'b0) begin
      req_loop_cnt    <= '0;
      sync_fsm_state  <= SYNC_FSM_LOOP_REQ;
      conf_w_add_reg  <= '0;
      ker_col_req_reg <= '0;
      acc_req_reg     <= '0;    
    end else begin
      if (sync_fsm_n_state == SYNC_FSM_LOOP_REQ && pending_req_s == 1'b1) begin
        req_loop_cnt <= req_loop_cnt + 1;
      end

      sync_fsm_state <= sync_fsm_n_state;

      if (sync_fsm_n_state == SYNC_FSM_READ_CONF) begin
        conf_w_add_reg <= ker_id_req_s;
      end

      if (sync_fsm_state == SYNC_FSM_READ_CONF) begin
        ker_col_req_reg <= ker_col_req_s;
      end

      if (sync_fsm_n_state == SYNC_FSM_WAIT_ACK && sync_fsm_state == SYNC_FSM_FIND_COL) begin
        rd_ptr_o <= core_rd_ptr_s[req_loop_cnt];
        wr_ptr_o <= core_wr_ptr_s[req_loop_cnt];
      end

      if (sync_fsm_n_state == SYNC_FSM_WAIT_ACK && sync_fsm_state == SYNC_FSM_FIND_COL) begin
        acc_req_reg <= acc_req_mapped;
      end else if (acc_ack_i == 1'b1) begin
        acc_req_reg <= '0;
      end
    end
  end

  // Register to know for each column if it is used in a multi-column kernel
  generate
    for (j=0; j<N_COL; j++) begin : col_map_reg_gen
      always_ff @(posedge clk_i or negedge rst_ni)
      begin
        if (rst_ni == 1'b0) begin
          col_acc_map_reg[j] <= 0;
        end else begin
          if (col_start_i[j] == 1'b1) begin
            col_acc_map_reg[j] <= acc_req_reg;
          end
        end
      end
    end
  endgenerate

  ///////////////////////////////////////////////////////////////////////
  //
  // Process to keep update the col status (if running or finished)
  //
  ///////////////////////////////////////////////////////////////////////

  always_ff @(posedge clk_i, negedge rst_ni)
  begin
    if(rst_ni == 1'b0) begin
      c_id_exec <= '{default: '0};
    end else begin
      for (int i=0; i<N_COL; i++) begin : sync_status
        if (acc_req_reg[i] == 1'b1) begin
          c_id_exec[i] <= req_loop_cnt;
        end
      end
    end
  end

  ///////////////////////////////////////////////////////////////////////
  //
  // Process to wake up correct core  when CGRA finished its execution
  //
  ///////////////////////////////////////////////////////////////////////

  always_comb
  begin
    evt_o = '0;

    for (int i=0; i<N_SLOTS; i++) begin : evt_out
      if (acc_end_i[i] == 1'b1) begin
        evt_o[c_id_exec[i]] = 1'b1;
      end
    end
  end

  ////////////////////////////////////////////////////////////////////////
  //
  // Component(s) mapping
  //
  ////////////////////////////////////////////////////////////////////////

  peripheral_regs peripheral_regs_i
  (
    .clk_i              ( clk_i              ),
    .rst_ni             ( rst_ni             ),
    .acc_ack_i          ( acc_ack_i          ),
    .c_id_req_clear_i   ( req_loop_cnt       ),
    .col_stall_i        ( col_stall_i        ),
    .reg_req_i          ( reg_req_i          ),
    .acc_req_i          ( acc_req_reg        ),
    .acc_end_i          ( acc_end_i          ),
    .col_status_o       ( col_status_reg     ),
    .reg_rsp_o          ( reg_rsp_o          ),
    .core_ker_id_o      ( core_ker_id_req_s  ),
    .core_rd_ptr_o      ( core_rd_ptr_s      ),
    .core_wr_ptr_o      ( core_wr_ptr_s      )
  );

endmodule
