// Copyright 2022 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

module conf_reg_file
  import cgra_pkg::*;
(
  input  logic                         clk_i,
  input  logic                         rst_i,
  input  logic                         ce_i,
  input  logic [      INSTR_WIDTH-1:0] instr_i,
  input  logic [RCS_NUM_CREG_LOG2-1:0] global_pc_i,
  input  logic                         we_i,
  input  logic                         re_i,
  output logic [      INSTR_WIDTH-1:0] conf_o
);

  logic [RCS_NUM_CREG-1:0][INSTR_WIDTH-1:0] conf_mem;

  // Read instruction output register
  always_ff @(posedge clk_i)
  begin
    if (rst_i == 1'b1) begin
      conf_o <= 32'h00000000;
    end else if (re_i && ce_i) begin
      conf_o <= conf_mem[global_pc_i];
    end
  end

  // Write instruction to register file
  always_ff @(posedge clk_i)
  begin
    if (we_i & ce_i) begin
      conf_mem[global_pc_i] <= instr_i;
    end
  end

endmodule
