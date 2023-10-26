
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
// Author:         Benoît Denkinger - benoit.denkinger@epfl.ch                //
//                                                                            //
// Additional contributions by:                                               //
//                 Simone Machetti - simone.machetti@epfl.ch                  //
//                                                                            //
// Design Name:    cgra_top_wrapper                                           //
//                                                                            //
// Project Name:   HealWear-V                                                 //
//                                                                            //
// Language:       SystemVerilog                                              //
//                                                                            //
// Description:    CGRA top level wrapper module.                             //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////


`timescale 1ns/100ps

import cgra_config_pkg::*;

module cgra_top_wrapper
(
  input  logic                            clk_i,
  input  logic                            rstn_i,

  // AHB Master
  output logic                            master_0_data_req_o,
  input  logic                            master_0_data_gnt_i,
  input  logic                            master_0_data_rvalid_i,
  output logic                            master_0_data_we_o,
  output logic [                  4-1:0]  master_0_data_be_o,
  output logic [ DATA_BUS_ADD_WIDTH-1:0]  master_0_data_addr_o,
  output logic [DATA_BUS_DATA_WIDTH-1:0]  master_0_data_wdata_o,
  input  logic [DATA_BUS_DATA_WIDTH-1:0]  master_0_data_rdata_i,

  output logic                            master_1_data_req_o,
  input  logic                            master_1_data_gnt_i,
  input  logic                            master_1_data_rvalid_i,
  output logic                            master_1_data_we_o,
  output logic [                  4-1:0]  master_1_data_be_o,
  output logic [ DATA_BUS_ADD_WIDTH-1:0]  master_1_data_addr_o,
  output logic [DATA_BUS_DATA_WIDTH-1:0]  master_1_data_wdata_o,
  input  logic [DATA_BUS_DATA_WIDTH-1:0]  master_1_data_rdata_i,

  output logic                            master_2_data_req_o,
  input  logic                            master_2_data_gnt_i,
  input  logic                            master_2_data_rvalid_i,
  output logic                            master_2_data_we_o,
  output logic [                  4-1:0]  master_2_data_be_o,
  output logic [ DATA_BUS_ADD_WIDTH-1:0]  master_2_data_addr_o,
  output logic [DATA_BUS_DATA_WIDTH-1:0]  master_2_data_wdata_o,
  input  logic [DATA_BUS_DATA_WIDTH-1:0]  master_2_data_rdata_i,

  output logic                            master_3_data_req_o,
  input  logic                            master_3_data_gnt_i,
  input  logic                            master_3_data_rvalid_i,
  output logic                            master_3_data_we_o,
  output logic [                  4-1:0]  master_3_data_be_o,
  output logic [ DATA_BUS_ADD_WIDTH-1:0]  master_3_data_addr_o,
  output logic [DATA_BUS_DATA_WIDTH-1:0]  master_3_data_wdata_o,
  input  logic [DATA_BUS_DATA_WIDTH-1:0]  master_3_data_rdata_i,

  // APB interface
  input  logic                            periph_data_req_i,
  output logic                            periph_data_gnt_o,
  output logic                            periph_data_rvalid_o,
  input  logic                            periph_data_we_i,
  input  logic [                  4-1:0]  periph_data_be_i,
  input  logic [   PERIPH_ADD_WIDTH-1:0]  periph_data_addr_i,
  input  logic [  PERIPH_DATA_WIDTH-1:0]  periph_data_wdata_i,
  output logic [  PERIPH_DATA_WIDTH-1:0]  periph_data_rdata_o,

  // Instructions memory port
  input  logic [   WR_INSTR_ADD_LEN-1:0]  cgra_ram_addr_i,
  input  logic [DATA_BUS_DATA_WIDTH-1:0]  cgra_ram_wdata_i,
  input  logic                            cgra_ram_we_i,

  // interrupt
  output logic                            cgra_int_line_o
);

  logic                                   cg_clk;

  logic [                 ID-1:0]         periph_id;
  logic [                 ID-1:0]         periph_r_id;

  logic [                 MP-1:0]         tcdm_req;
  logic [ DATA_BUS_ADD_WIDTH-1:0]         tcdm_add [0:MP-1];
  logic [                 MP-1:0]         tcdm_wen;
  logic [                  4-1:0]         tcdm_be [0:MP-1];
  logic [DATA_BUS_DATA_WIDTH-1:0]         tcdm_wdata [0:MP-1];
  logic [                 MP-1:0]         tcdm_gnt;
  logic [DATA_BUS_DATA_WIDTH-1:0]         tcdm_rdata [0:MP-1];
  logic [                 MP-1:0]         tcdm_r_valid;

  logic [ DATA_BUS_ADD_WIDTH-1:0]         imem_wadd;
  logic [DATA_BUS_DATA_WIDTH-1:0]         imem_wdata;
  logic                                   imem_we;

  logic [            N_CORES-1:0]         cgra_evt;

  // Needed to have the clock swithing at same delta-cycle for all the modules
  // clkgate_cell u_clk_gate (
  //   .clk_i                                ( clk_i                  ),
  //   .test_en_i                            ( 1'b0                   ),
  //   .en_i                                 ( 1'b1                 ),
  //   .clk_gated_o                          ( cg_clk                 )
  // );
  assign cg_clk = clk_i;

  // Not used
  assign periph_id = '0;

  // MP 0
  assign master_0_data_req_o              = tcdm_req[0];
  assign master_0_data_addr_o             = tcdm_add[0];
  assign master_0_data_we_o               = ~tcdm_wen[0];
  assign master_0_data_be_o               = tcdm_be[0];
  assign master_0_data_wdata_o            = tcdm_wdata[0];
  assign tcdm_gnt[0]                      = master_0_data_gnt_i;
  assign tcdm_rdata[0]                    = master_0_data_rdata_i;
  assign tcdm_r_valid[0]                  = master_0_data_rvalid_i;

  // MP 1
  assign master_1_data_req_o              = tcdm_req[1];
  assign master_1_data_addr_o             = tcdm_add[1];
  assign master_1_data_we_o               = ~tcdm_wen[1];
  assign master_1_data_be_o               = tcdm_be[1];
  assign master_1_data_wdata_o            = tcdm_wdata[1];
  assign tcdm_gnt[1]                      = master_1_data_gnt_i;
  assign tcdm_rdata[1]                    = master_1_data_rdata_i;
  assign tcdm_r_valid[1]                  = master_1_data_rvalid_i;

  // MP 2
  assign master_2_data_req_o              = tcdm_req[3];
  assign master_2_data_addr_o             = tcdm_add[2];
  assign master_2_data_we_o               = ~tcdm_wen[2];
  assign master_2_data_be_o               = tcdm_be[2];
  assign master_2_data_wdata_o            = tcdm_wdata[2];
  assign tcdm_gnt[2]                      = master_2_data_gnt_i;
  assign tcdm_rdata[2]                    = master_2_data_rdata_i;
  assign tcdm_r_valid[2]                  = master_2_data_rvalid_i;

  // MP 3
  assign master_3_data_req_o              = tcdm_req[3];
  assign master_3_data_addr_o             = tcdm_add[3];
  assign master_3_data_we_o               = ~tcdm_wen[3];
  assign master_3_data_be_o               = tcdm_be[3];
  assign master_3_data_wdata_o            = tcdm_wdata[3];
  assign tcdm_gnt[3]                      = master_3_data_gnt_i;
  assign tcdm_rdata[3]                    = master_3_data_rdata_i;
  assign tcdm_r_valid[3]                  = master_3_data_rvalid_i;

  // all request merged for now
  assign cgra_int_line_o                  = |cgra_evt;

  cgra_top cgra_top_i
  (
    .clk_i                                ( cg_clk                 ),
    .rst_ni                               ( rstn_i                 ),
    // APB interface
    .periph_enable_i                      ( 1'b1                   ),
    .periph_req_i                         ( periph_data_req_i      ),
    .periph_add_i                         ( periph_data_addr_i     ),
    .periph_wen_i                         ( ~periph_data_we_i      ),
    .periph_be_i                          ( periph_data_be_i       ),
    .periph_wdata_i                       ( periph_data_wdata_i    ),
    .periph_gnt_o                         ( periph_data_gnt_o      ),
    .periph_rdata_o                       ( periph_data_rdata_o    ),
    .periph_r_valid_o                     ( periph_data_rvalid_o   ),
    .periph_id_i                          ( periph_id              ),
    .periph_r_id_o                        ( periph_r_id            ),
    // AHB Master port
    .tcdm_req_o                           ( tcdm_req               ),
    .tcdm_add_o                           ( tcdm_add               ),
    .tcdm_wen_o                           ( tcdm_wen               ),
    .tcdm_be_o                            ( tcdm_be                ),
    .tcdm_wdata_o                         ( tcdm_wdata             ),
    .tcdm_gnt_i                           ( tcdm_gnt               ),
    .tcdm_rdata_i                         ( tcdm_rdata             ),
    .tcdm_r_valid_i                       ( tcdm_r_valid           ),
    // CGRA CONF. mem port
    .imem_wadd_i                          ( cgra_ram_addr_i        ),
    .imem_wdata_i                         ( cgra_ram_wdata_i       ),
    .imem_we_i                            ( cgra_ram_we_i          ),
    // CGRA interrupts
    .evt_o                                ( cgra_evt               )
  );


endmodule
