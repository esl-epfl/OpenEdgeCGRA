// Copyright 2022 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

module peripheral_regs
  import cgra_pkg::*;
  import reg_pkg::*;
(
  input  logic                           clk_i,
  input  logic                           rst_ni,
  input  logic                           acc_ack_i,
  input  logic [       N_SLOTS_LOG2-1:0] c_id_req_clear_i,
  input  logic [              N_COL-1:0] col_stall_i,
  input  reg_req_t                       reg_req_i,
  output reg_rsp_t                       reg_rsp_o,
  input  logic [              N_COL-1:0] acc_req_i,
  input  logic [              N_COL-1:0] acc_end_i,
  output logic [              N_COL-1:0] col_status_o,
  output logic [KER_CONF_N_REG_LOG2-1:0] core_ker_id_o [0:N_SLOTS-1],
  output logic [           DP_WIDTH-1:0] core_rd_ptr_o [0:N_SLOTS-1][0:MAX_COL_REQ-1],
  output logic [           DP_WIDTH-1:0] core_wr_ptr_o [0:N_SLOTS-1][0:MAX_COL_REQ-1]
);

  import cgra_reg_pkg::*;

  cgra_reg2hw_t reg2hw;
  cgra_hw2reg_t hw2reg;

  logic [N_COL-1:0] col_status;
  logic perf_cnt_en;
  logic perf_cnt_reset;

  assign col_status_o = col_status;

  assign perf_cnt_en    = reg2hw.perf_cnt_enable.q;
  assign perf_cnt_reset = reg2hw.perf_cnt_reset.q;


  // Columns' read and write pointers
  always_comb
  begin
    core_ker_id_o[0]    = reg2hw.slot0_ker_id.q[KER_CONF_N_REG_LOG2-1:0];
    core_ker_id_o[1]    = reg2hw.slot1_ker_id.q[KER_CONF_N_REG_LOG2-1:0];

    core_rd_ptr_o[0][0] = reg2hw.slot0_ptr_in_c0.q;
    core_wr_ptr_o[0][0] = reg2hw.slot0_ptr_out_c0.q;
    core_rd_ptr_o[0][1] = reg2hw.slot0_ptr_in_c1.q;
    core_wr_ptr_o[0][1] = reg2hw.slot0_ptr_out_c1.q;
    core_rd_ptr_o[0][2] = reg2hw.slot0_ptr_in_c2.q;
    core_wr_ptr_o[0][2] = reg2hw.slot0_ptr_out_c2.q;
    core_rd_ptr_o[0][3] = reg2hw.slot0_ptr_in_c3.q;
    core_wr_ptr_o[0][3] = reg2hw.slot0_ptr_out_c3.q;

    core_rd_ptr_o[1][0] = reg2hw.slot1_ptr_in_c0.q;
    core_wr_ptr_o[1][0] = reg2hw.slot1_ptr_out_c0.q;
    core_rd_ptr_o[1][1] = reg2hw.slot1_ptr_in_c1.q;
    core_wr_ptr_o[1][1] = reg2hw.slot1_ptr_out_c1.q;
    core_rd_ptr_o[1][2] = reg2hw.slot1_ptr_in_c2.q;
    core_wr_ptr_o[1][2] = reg2hw.slot1_ptr_out_c2.q;
    core_rd_ptr_o[1][3] = reg2hw.slot1_ptr_in_c3.q;
    core_wr_ptr_o[1][3] = reg2hw.slot1_ptr_out_c3.q;
  end

  // Reset/update performance counters
  assign hw2reg.perf_cnt_total_kernels.de = perf_cnt_reset | (perf_cnt_en & acc_ack_i);
  assign hw2reg.perf_cnt_total_kernels.d  = perf_cnt_reset == 1'b1 ? '0 : reg2hw.perf_cnt_total_kernels.q + 1;
  // Column 0
  assign hw2reg.perf_cnt_c0_active_cycles.de = perf_cnt_reset | (perf_cnt_en & (col_status[0] | acc_req_i[0]));
  assign hw2reg.perf_cnt_c0_active_cycles.d  = perf_cnt_reset == 1'b1 ? '0 : reg2hw.perf_cnt_c0_active_cycles.q + 1;
  assign hw2reg.perf_cnt_c0_stall_cycles.de = perf_cnt_reset | (perf_cnt_en & col_stall_i[0]);
  assign hw2reg.perf_cnt_c0_stall_cycles.d  = perf_cnt_reset == 1'b1 ? '0 : reg2hw.perf_cnt_c0_stall_cycles.q + 1;
  // Column 1
  assign hw2reg.perf_cnt_c1_active_cycles.de = perf_cnt_reset | (perf_cnt_en & (col_status[1] | acc_req_i[1]));
  assign hw2reg.perf_cnt_c1_active_cycles.d  = perf_cnt_reset == 1'b1 ? '0 : reg2hw.perf_cnt_c1_active_cycles.q + 1;
  assign hw2reg.perf_cnt_c1_stall_cycles.de = perf_cnt_reset | (perf_cnt_en & col_stall_i[1]);
  assign hw2reg.perf_cnt_c1_stall_cycles.d  = perf_cnt_reset == 1'b1 ? '0 : reg2hw.perf_cnt_c1_stall_cycles.q + 1;
  // Column 2
  assign hw2reg.perf_cnt_c2_active_cycles.de = perf_cnt_reset | (perf_cnt_en & (col_status[2] | acc_req_i[2]));
  assign hw2reg.perf_cnt_c2_active_cycles.d  = perf_cnt_reset == 1'b1 ? '0 : reg2hw.perf_cnt_c2_active_cycles.q + 1;
  assign hw2reg.perf_cnt_c2_stall_cycles.de = perf_cnt_reset | (perf_cnt_en & col_stall_i[2]);
  assign hw2reg.perf_cnt_c2_stall_cycles.d  = perf_cnt_reset == 1'b1 ? '0 : reg2hw.perf_cnt_c2_stall_cycles.q + 1;
  // Column 3
  assign hw2reg.perf_cnt_c3_active_cycles.de = perf_cnt_reset | (perf_cnt_en & (col_status[3] | acc_req_i[3]));
  assign hw2reg.perf_cnt_c3_active_cycles.d  = perf_cnt_reset == 1'b1 ? '0 : reg2hw.perf_cnt_c3_active_cycles.q + 1;
  assign hw2reg.perf_cnt_c3_stall_cycles.de = perf_cnt_reset | (perf_cnt_en & col_stall_i[3]);
  assign hw2reg.perf_cnt_c3_stall_cycles.d  = perf_cnt_reset == 1'b1 ? '0 : reg2hw.perf_cnt_c3_stall_cycles.q + 1;
  // Disable reset
  assign hw2reg.perf_cnt_reset.de = perf_cnt_reset;
  assign hw2reg.perf_cnt_reset.d  = '0;

  // Clear kernel ID request
  assign hw2reg.slot0_ker_id.de = acc_ack_i | ~c_id_req_clear_i;
  assign hw2reg.slot0_ker_id.d  = '0;
  assign hw2reg.slot1_ker_id.de = acc_ack_i | c_id_req_clear_i;
  assign hw2reg.slot1_ker_id.d  = '0;

  // Update CGRA column status:
  // 0 - Column is free
  // 1 - Column is used
  assign col_status = reg2hw.col_status.q;
  assign hw2reg.col_status.de = ((|acc_req_i) & acc_ack_i) | (|acc_end_i);
  assign hw2reg.col_status.d  = ((|acc_req_i) & acc_ack_i) == 1'b1 ? (col_status | acc_req_i) : (col_status & ~acc_end_i);

  cgra_reg_top #(
      .reg_req_t(reg_req_t),
      .reg_rsp_t(reg_rsp_t)
  ) cgra_reg_top_i (
      .clk_i,
      .rst_ni,
      .reg_req_i,
      .reg_rsp_o,
      .reg2hw,
      .hw2reg,
      .devmode_i(1'b1)
  );

endmodule
