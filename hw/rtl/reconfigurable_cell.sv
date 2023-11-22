// Copyright 2022 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

module reconfigurable_cell
import cgra_pkg::*;
(
  input  logic                         clk_i,
  input  logic                         rst_rc_i,
  input  logic [      INSTR_WIDTH-1:0] conf_rdata_i,
  input  logic [         DP_WIDTH-1:0] data_rdata_i,
  input  logic                         data_rvalid_i,
  input  logic                         conf_we_i,
  input  logic                         conf_re_i,
  input  logic [RCS_NUM_CREG_LOG2-1:0] global_pc_i,
  input  logic                         pc_en_i,
  input  logic [         DP_WIDTH-1:0] own_res_i,
  input  logic [         DP_WIDTH-1:0] left_res_i,
  input  logic [         DP_WIDTH-1:0] right_res_i,
  input  logic [         DP_WIDTH-1:0] top_res_i,
  input  logic [         DP_WIDTH-1:0] bottom_res_i,
  input  logic [       ALU_N_FLAG-1:0] own_flag_i,
  input  logic [       ALU_N_FLAG-1:0] left_flag_i,
  input  logic [       ALU_N_FLAG-1:0] right_flag_i,
  input  logic [       ALU_N_FLAG-1:0] top_flag_i,
  input  logic [       ALU_N_FLAG-1:0] bottom_flag_i,
  output logic [         DP_WIDTH-1:0] result_o,
  output logic [       ALU_N_FLAG-1:0] flag_o,
  output logic                         br_req_o,
  output logic [RCS_NUM_CREG_LOG2-1:0] br_add_o,
  output logic                         data_req_o,
  output logic                         data_wen_o,
  output logic                         data_ind_o,
  output logic [         DP_WIDTH-1:0] data_add_o,
  output logic [         DP_WIDTH-1:0] data_wdata_o,
  output logic [   RC_CONST_WIDTH-1:0] add_inc_o,
  output logic                         rc_stall_o,
  output logic                         rc_nop_o,
  output logic                         exec_end_o
);

  logic [INSTR_WIDTH-1:0] conf_rdata_s;
  logic                   dp_stall_s;
  logic                   ce_conf_s;
  logic                   ce_dp_s;

  assign rc_stall_o = dp_stall_s;
  assign ce_conf_s  = pc_en_i;
  assign ce_dp_s    = pc_en_i & conf_re_i;

  conf_reg_file rc_conf_registers
  (
    .clk_i       ( clk_i        ),
    .rst_i       ( rst_rc_i     ),
    .ce_i        ( ce_conf_s    ),
    .instr_i     ( conf_rdata_i ),
    .global_pc_i ( global_pc_i  ),
    .we_i        ( conf_we_i    ),
    .re_i        ( conf_re_i    ),
    .conf_o      ( conf_rdata_s )
  );

  datapath rc_datapath
  (
    .clk_i         ( clk_i          ),
    .rst_i         ( rst_rc_i       ),
    .ce_i          ( ce_dp_s        ),
    .conf_rdata_i  ( conf_rdata_s   ),
    .data_rdata_i  ( data_rdata_i   ),
    .data_rvalid_i ( data_rvalid_i  ),
    .own_res_i     ( own_res_i      ),
    .left_res_i    ( left_res_i     ),
    .right_res_i   ( right_res_i    ),
    .top_res_i     ( top_res_i      ),
    .bottom_res_i  ( bottom_res_i   ),
    .own_flag_i    ( own_flag_i     ),
    .left_flag_i   ( left_flag_i    ),
    .right_flag_i  ( right_flag_i   ),
    .top_flag_i    ( top_flag_i     ),
    .bottom_flag_i ( bottom_flag_i  ),
    .conf_re_i     ( conf_re_i      ),
    .result_o      ( result_o       ),
    .flag_o        ( flag_o         ),
    .br_req_o      ( br_req_o       ),
    .br_add_o      ( br_add_o       ),
    .data_req_o    ( data_req_o     ),
    .data_wen_o    ( data_wen_o     ),
    .data_ind_o    ( data_ind_o     ),
    .data_add_o    ( data_add_o     ),
    .data_wdata_o  ( data_wdata_o   ),
    .add_inc_o     ( add_inc_o      ),
    .dp_stall_o    ( dp_stall_s     ),
    .rc_nop_o      ( rc_nop_o       ),
    .exec_end_o    ( exec_end_o     )
  );

endmodule
