// Copyright 2022 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

module reg_file
  import cgra_pkg::*;
#(
  parameter REGFILE_DEPTH = 4,
  parameter REGFILE_NSEL  = $clog2(REGFILE_DEPTH),
  parameter REGFILE_WIDTH = 32
)
(
  input  logic                     clk_i,
  input  logic                     rst_i,
  input  logic                     ce_i,
  input  logic                     we_i,
  input  logic [ REGFILE_NSEL-1:0] wsel_i,
  input  logic [REGFILE_WIDTH-1:0] reg_i,
  output logic [REGFILE_WIDTH-1:0] regs_o [0:REGFILE_DEPTH-1]
);

  logic [REGFILE_WIDTH-1:0] reg_file_mem [0:REGFILE_DEPTH-1];

  assign regs_o = reg_file_mem;

  always_ff @(posedge clk_i)
  begin
    if (rst_i == 1'b1) begin
      reg_file_mem <= '{default:'0};
    end
    else if (we_i & ce_i) begin
      reg_file_mem[wsel_i] <= reg_i;
    end
  end

endmodule
