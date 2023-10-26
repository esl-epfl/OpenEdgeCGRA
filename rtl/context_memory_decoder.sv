// Copyright 2022 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

module context_memory_decoder
  import cgra_pkg::*;
(
  input  logic                           clk_i,
  input  logic                           rst_ni,

  input  logic                           clk_mem_cg_i,
  output logic                           clk_mem_en_o,

  input  logic                           cm_req_i,
  input  logic [ DATA_BUS_ADD_WIDTH-1:0] cm_add_i,
  input  logic                           cm_we_i,
  input  logic [                  4-1:0] cm_be_i,
  input  logic [DATA_BUS_DATA_WIDTH-1:0] cm_wdata_i,
  output logic                           cm_gnt_o,
  output logic                           cm_rvalid_o,

  input  logic                           rcs_conf_req_i,
  input  logic [  IMEM_N_LINES_LOG2-1:0] imem_radd_i,
  input  logic [KER_CONF_N_REG_LOG2-1:0] kmem_radd_i,

  output logic                           imem_gnt_ctrl_o,
  output logic                           imem_rvalid_ctrl_o,
  output logic [         KMEM_WIDTH-1:0] kmem_rdata_o,

  output logic [              N_ROW-1:0] cm_row_req_o,
  output logic                           cm_we_o,
  output logic [  IMEM_N_LINES_LOG2-1:0] cm_addr_o
);

  logic [ KMEM_WIDTH-1:0] ker_conf_mem [0:KER_CONF_N_REG-1];

  // Use to select which bank to write to.
  logic [ N_MEM_BANKS_LOG2-1:0] bk_sel;
  logic [IMEM_N_LINES_LOG2-1:0] w_bk_add;

  logic [N_ROW-1:0] cm_row_req;
  logic [IMEM_N_LINES_LOG2-1:0] cm_addr;
  logic cm_we;
  logic cmem_rvalid_out;
  logic cmem_gnt_ctrl;
  logic cmem_rvalid_ctrl;

  assign cm_row_req_o = cm_row_req;
  assign cm_we_o      = cm_we;
  assign cm_addr_o    = cm_addr;

  assign clk_mem_en_o = cm_req_i | rcs_conf_req_i;

  // Only connect bank 0 for debugging, but reading is not needed from outside
  // Access always granted
  assign cm_gnt_o    = 1'b1;
  assign cm_rvalid_o = cmem_rvalid_out;

  assign bk_sel   = cm_add_i[WR_INSTR_ADD_LEN-1+2:WR_INSTR_ADD_LEN-N_MEM_BANKS_LOG2+2];
  assign w_bk_add = cm_add_i[WR_INSTR_ADD_LEN-N_MEM_BANKS_LOG2-1+2:2];

  assign kmem_rdata_o = ker_conf_mem[kmem_radd_i];

  assign imem_gnt_ctrl_o = cmem_gnt_ctrl;
  assign imem_rvalid_ctrl_o = cmem_rvalid_ctrl;

  // Request mux
  always_comb
  begin
    cm_row_req = '0; //4'b0000;
    cm_addr = '0;
    cm_we = 1'b0;
    cmem_gnt_ctrl = 1'b0;

    if (cm_req_i == 1'b1) begin
      cm_addr = w_bk_add;
      cm_we = cm_we_i;

      for (int i=0; i<N_ROW; i++) begin
        if (bk_sel == i) begin
          cm_row_req[i] = 1'b1;
          break;
        end
      end

    end else if (rcs_conf_req_i == 1'b1) begin
      cm_row_req = '1;
      cm_addr = imem_radd_i;
      cm_we = 1'b0;
      cmem_gnt_ctrl = 1'b1;
    end
  end

  // Rvalid to CGRA controller generation
  always_ff @(posedge clk_i, negedge rst_ni)
  begin
    if (rst_ni == 1'b0) begin
      cmem_rvalid_ctrl <= 1'b0;
    end else begin
      if (cmem_gnt_ctrl == 1'b1) begin
        cmem_rvalid_ctrl <= 1'b1;
      end else begin
        cmem_rvalid_ctrl <= 1'b0;
      end
    end
  end

  // Rvalid to slave resp output port
  always_ff @(posedge clk_i, negedge rst_ni)
  begin
    if (rst_ni == 1'b0) begin
      cmem_rvalid_out <= 1'b0;
    end else begin
      if (cm_req_i == 1'b1) begin
        cmem_rvalid_out <= 1'b1;
      end else begin
        cmem_rvalid_out <= 1'b0;
      end
    end
  end

  // WRITE OPERATION INSUTRCTIONS
  always_ff @(posedge clk_mem_cg_i)
  begin
    if (bk_sel == N_ROW) begin
      ker_conf_mem[w_bk_add[KER_CONF_N_REG_LOG2-1:0]] <= cm_wdata_i[KMEM_WIDTH-1:0];
    end
  end
    
endmodule
