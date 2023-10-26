// Copyright 2022 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

module context_memory
  import cgra_pkg::*;
(
  input  logic                           clk_i,
  input  logic                           rst_ni,
  input  logic                           cm_cg_i,
  input  logic                           cm_set_retentive_i,
  input  logic [              N_ROW-1:0] cm_row_req_i,
  input  logic                           cm_we_i,
  input  logic [  IMEM_N_LINES_LOG2-1:0] cm_addr_i,
  input  logic [DATA_BUS_DATA_WIDTH-1:0] cm_wdata_i,
  output logic [        INSTR_WIDTH-1:0] rcs_cmem_rdata_o [0:N_ROW-1]
);

  generate
    for (genvar j=0; j<N_ROW; j++) begin : sram_macro_gen
      // CGRA context memories (one per row)
      cgra_sram_wrapper #(
        .NumWords (IMEM_N_LINES),
        .DataWidth(32'd32)
      ) cgra_ram0_i (
        .clk_i  (cm_cg_i),
        .rst_ni (rst_ni),
        .req_i  (cm_row_req_i[j]),
        .we_i   (cm_we_i),
        .addr_i (cm_addr_i),
        .wdata_i(cm_wdata_i),
        .be_i   (4'b1111),
        .set_retentive_i (cm_set_retentive_i),
        // output ports
        .rdata_o(rcs_cmem_rdata_o[j])
      );
    end
  endgenerate
    
endmodule
