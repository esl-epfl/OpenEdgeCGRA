////////////////////////////////////////////////////////////////////////////////
//                                                                            //
// Author:         Simone Machetti - simone.machetti@epfl.ch                  //
//                                                                            //
// Additional contributions by:                                               //
//                 Name Surname - email (affiliation if not ESL)              //
//                                                                            //
// Design Name:    soc_top                                                    //
//                                                                            //
// Project Name:   HealWear-V                                                 //
//                                                                            //
// Language:       SystemVerilog                                              //
//                                                                            //
// Description:    SoC top level module.                                      //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////


`define IBEX
// `define RISCV

`define CGRA_AND_EVENT_UNIT


module soc_top
#(

`ifdef IBEX
  parameter bit                         PMPEnable                                 = 0,
  parameter int unsigned                PMPGranularity                            = 0,
  parameter int unsigned                PMPNumRegions                             = 4,
  parameter int unsigned                MHPMCounterNum                            = 0,
  parameter int unsigned                MHPMCounterWidth                          = 40,
  parameter bit                         RV32E                                     = 0,
  parameter bit                         RV32M                                     = 1,
  parameter int unsigned                DmHaltAddr                                = 32'h1A110800,
  parameter int unsigned                DmExceptionAddr                           = 32'h1A110808,
`endif

`ifdef RISCV
  // riscv_core parameters
  parameter                             N_EXT_PERF_COUNTERS                       =  0,
  parameter                             INSTR_RDATA_WIDTH                         = 32,
  parameter                             PULP_SECURE                               =  0,
  parameter                             N_PMP_ENTRIES                             = 16,
  parameter                             USE_PMP                                   =  1,
  parameter                             PULP_CLUSTER                              =  0,
  parameter                             FPU                                       =  0,
  parameter                             Zfinx                                     =  0,
  parameter                             FP_DIVSQRT                                =  0,
  parameter                             SHARED_FP                                 =  0,
  parameter                             SHARED_DSP_MULT                           =  0,
  parameter                             SHARED_INT_MULT                           =  0,
  parameter                             SHARED_INT_DIV                            =  0,
  parameter                             SHARED_FP_DIVSQRT                         =  0,
  parameter                             WAPUTYPE                                  =  0,
  parameter                             APU_NARGS_CPU                             =  3,
  parameter                             APU_WOP_CPU                               =  6,
  parameter                             APU_NDSFLAGS_CPU                          = 15,
  parameter                             APU_NUSFLAGS_CPU                          =  5,
  parameter                             DM_HaltAddress                            = 32'h1A110800,
`endif

  // ram parameters
  // parameter int unsigned                Numb32KBIramBlocks                        = 1,
  // parameter int unsigned                Numb32KBDramBlocks                        = 5,
  parameter int unsigned                Numb32KBsramBlocks                        = 6,

  // bus parameters
`ifdef CGRA_AND_EVENT_UNIT
  parameter int unsigned                n_masters                                 = 6, // proc. instr, proc. data, CGRA 4x
  parameter int unsigned                n_slaves                                  = 8  // SRAM banks 6x, CGRA ctrl regs, event unit
  // parameter [31:0]                      BaseAddress_dram                          = 32'h00008000,
  // parameter [31:0]                      MaskAddress_dram                          = 32'hFFFF8000,
  // parameter [31:0]                      BaseAddress_cgra                          = 32'h50000000,
  // parameter [31:0]                      MaskAddress_cgra                          = 32'hFFFFFF80,
  // parameter [31:0]                      BaseAddress_event_unit                    = 32'h60000000,
  // parameter [31:0]                      MaskAddress_event_unit                    = 32'hFFFFFFC0,
  // parameter [31:0]                      BaseAddresses[0:n_slaves-1]               = {BaseAddress_dram, BaseAddress_cgra, BaseAddress_event_unit},
  // parameter [31:0]                      MaskAddresses[0:n_slaves-1]               = {MaskAddress_dram, MaskAddress_cgra, MaskAddress_event_unit}
`else 
  parameter int unsigned                n_masters                                 = 2, // proc. instr, proc. data
  parameter int unsigned                n_slaves                                  = 6  // SRAM banks 6x
  // parameter [31:0]                      BaseAddress_dram                          = 32'h00008000, // 32'h00040000,
  // parameter [31:0]                      MaskAddress_dram                          = 32'hFFFF8000, // 32'hFFFC0000,
  // parameter [31:0]                      BaseAddresses[0:n_slaves-1]               = {BaseAddress_dram},
  // parameter [31:0]                      MaskAddresses[0:n_slaves-1]               = {MaskAddress_dram}
`endif
)
(
`ifdef CGRA_AND_EVENT_UNIT
  input                                 clk_i,
  input                                 rstn_i,
  input     [9:0]                       cgra_bridge_addr_i,
  input     [31:0]                      cgra_bridge_wdata_i,
  input                                 cgra_bridge_we_i
`else
  input                                 clk_i,
  input                                 rstn_i
`endif
);

  /////////////////////////
  // Signals declaration //
  /////////////////////////

  // core <--> iram
  wire                                  ram_instr_req;
  wire                                  ram_instr_gnt;
  wire                                  ram_instr_rvalid;
  wire   [31:0]                         ram_instr_addr;
  wire   [31:0]                         ram_instr_rdata;

  // masters <--> bus
  wire                                  m_req[0:n_masters-1];
  wire                                  m_gnt[0:n_masters-1];
  wire                                  m_rvalid[0:n_masters-1];
  wire                                  m_we[0:n_masters-1];
  wire   [3:0]                          m_be[0:n_masters-1];
  wire   [31:0]                         m_addr[0:n_masters-1];
  wire   [31:0]                         m_wdata[0:n_masters-1];
  wire   [31:0]                         m_rdata[0:n_masters-1];

  // Master[0] is processor instruction so no data write
  assign m_we[0] = '0;
  assign m_be[0] = '0;
  assign m_wdata[0] = '0;

  // bus <--> slaves
  wire                                  s_en[0:n_slaves-1];
  wire                                  s_gnt[0:n_slaves-1];
  wire                                  s_rvalid[0:n_slaves-1];
  wire                                  s_we[0:n_slaves-1];
  wire   [3:0]                          s_be[0:n_slaves-1];
  wire   [31:0]                         s_addr[0:n_slaves-1];
  wire   [31:0]                         s_wdata[0:n_slaves-1];
  wire   [31:0]                         s_rdata[0:n_slaves-1];

`ifdef CGRA_AND_EVENT_UNIT
  // event_unit --> core
  wire                                  dis_clk_core;

  // cgra --> event_unit
  wire                                  cgra_int;
`else
  wire                                  dis_clk_core                              = 1'b0;
`endif

`ifdef IBEX
  // ibex_core <--> to_be_defined
  wire                                  test_en                                   = 1'b0;
  wire   [9:0]                          ram_cfg                                   = 10'h000;
  wire   [31:0]                         hart_id                                   = 32'h00000000;
  wire   [31:0]                         boot_addr                                 = 32'h00000000;
  wire                                  instr_err                                 = 1'b0;
  wire                                  data_err                                  = 1'b0;
  wire                                  irq_software;
  wire                                  irq_timer;
  wire                                  irq_external;
  wire   [14:0]                         irq_fast;
  wire                                  irq_nm;
  wire                                  irq_ack;
  wire   [3:0]                          irq_ack_id;
  wire                                  debug_req                                 = 1'b0;
  wire   [127:0]                        crash_dump;
  wire                                  fetch_enable                              = 1'b1;
  wire                                  alert_minor;
  wire                                  alert_major;
  wire                                  core_sleep;
`endif

`ifdef RISCV
  // riscv_core <--> to_be_defined
  wire                                  clock_en;
  wire                                  test_en                                   = 1'b0;
  wire                                  fregfile_disable;
  wire   [31:0]                         boot_addr                                 = 32'h00000080;
  wire   [3:0]                          core_id                                   = "0000";
  wire   [5:0]                          cluster_id                                = "000000";
  wire                                  apu_master_req;
  wire                                  apu_master_ready;
  wire                                  apu_master_gnt;
  wire   [APU_NARGS_CPU-1:0][31:0]      apu_master_operands;
  wire   [APU_WOP_CPU-1:0]              apu_master_op;
  wire   [WAPUTYPE-1:0]                 apu_master_type;
  wire   [APU_NDSFLAGS_CPU-1:0]         apu_master_flags_out;
  wire                                  apu_master_valid;
  wire   [31:0]                         apu_master_result;
  wire   [APU_NUSFLAGS_CPU-1:0]         apu_master_flags_in;
  wire                                  irq;
  wire   [4:0]                          irq_id_in;
  wire                                  irq_ack;
  wire   [4:0]                          irq_id_out;
  wire                                  irq_sec;
  wire                                  sec_lvl;
  wire                                  debug_req                                 = 1'b0;
  wire                                  fetch_enable                              = 1'b1;
  wire                                  core_busy;
  wire   [N_EXT_PERF_COUNTERS-1:0]      ext_perf_counters;
`endif


  ///////////////////////////
  // Modules instantiation //
  ///////////////////////////

`ifdef IBEX
  ibex_core #(
    .PMPEnable                          ( PMPEnable                                     ),
    .PMPGranularity                     ( PMPGranularity                                ),
    .PMPNumRegions                      ( PMPNumRegions                                 ),
    .MHPMCounterNum                     ( MHPMCounterNum                                ),
    .MHPMCounterWidth                   ( MHPMCounterWidth                              ),
    .RV32E                              ( RV32E                                         ),
    .RV32M                              ( RV32M                                         ),
    .DmHaltAddr                         ( DmHaltAddr                                    ),
    .DmExceptionAddr                    ( DmExceptionAddr                               )
  ) ibex_core_i (
    .clk_i                              ( clk_i                                         ),
    .rst_ni                             ( rstn_i                                        ),
    .test_en_i                          ( test_en                                       ),
    .hart_id_i                          ( hart_id                                       ),
    .boot_addr_i                        ( boot_addr                                     ),
    .instr_req_o                        ( m_req[0]                                      ),
    .instr_gnt_i                        ( m_gnt[0]                                      ),
    .instr_rvalid_i                     ( m_rvalid[0]                                   ),
    .instr_addr_o                       ( m_addr[0]                                     ),
    .instr_rdata_i                      ( m_rdata[0]                                    ),
    .instr_err_i                        ( instr_err                                     ),
    .data_req_o                         ( m_req[1]                                      ),
    .data_gnt_i                         ( m_gnt[1]                                      ),
    .data_rvalid_i                      ( m_rvalid[1]                                   ),
    .data_we_o                          ( m_we[1]                                       ),
    .data_be_o                          ( m_be[1]                                       ),
    .data_addr_o                        ( m_addr[1]                                     ),
    .data_wdata_o                       ( m_wdata[1]                                    ),
    .data_rdata_i                       ( m_rdata[1]                                    ),
    .data_err_i                         ( data_err                                      ),
    .irq_software_i                     ( irq_software                                  ),
    .irq_timer_i                        ( irq_timer                                     ),
    .irq_external_i                     ( irq_external                                  ),
    .irq_fast_i                         ( irq_fast                                      ),
    .irq_nm_i                           ( irq_nm                                        ),
    .irq_ack_o                          ( irq_ack                                       ),
    .irq_ack_id_o                       ( irq_ack_id                                    ),
    .debug_req_i                        ( debug_req                                     ),
    .fetch_enable_i                     ( fetch_enable                                  ),
    .core_sleep_o                       ( core_sleep                                    ),
    .clk_gat_core_i                     ( dis_clk_core & ~m_rvalid[0] & ~m_gnt[0]       )
  );
`endif

`ifdef RISCV
  riscv_core #(
    .N_EXT_PERF_COUNTERS                ( N_EXT_PERF_COUNTERS                           ),
    .INSTR_RDATA_WIDTH                  ( INSTR_RDATA_WIDTH                             ),
    .PULP_SECURE                        ( PULP_SECURE                                   ),
    .N_PMP_ENTRIES                      ( N_PMP_ENTRIES                                 ),
    .USE_PMP                            ( USE_PMP                                       ),
    .PULP_CLUSTER                       ( PULP_CLUSTER                                  ),
    .FPU                                ( FPU                                           ),
    .Zfinx                              ( Zfinx                                         ),
    .FP_DIVSQRT                         ( FP_DIVSQRT                                    ),
    .SHARED_FP                          ( SHARED_FP                                     ),
    .SHARED_DSP_MULT                    ( SHARED_DSP_MULT                               ),
    .SHARED_INT_MULT                    ( SHARED_INT_MULT                               ),
    .SHARED_INT_DIV                     ( SHARED_INT_DIV                                ),
    .SHARED_FP_DIVSQRT                  ( SHARED_FP_DIVSQRT                             ),
    .WAPUTYPE                           ( WAPUTYPE                                      ),
    .APU_NARGS_CPU                      ( APU_NARGS_CPU                                 ),
    .APU_WOP_CPU                        ( APU_WOP_CPU                                   ),
    .APU_NDSFLAGS_CPU                   ( APU_NDSFLAGS_CPU                              ),
    .APU_NUSFLAGS_CPU                   ( APU_NUSFLAGS_CPU                              ),
    .DM_HaltAddress                     ( DM_HaltAddress                                )
  ) riscv_core_i (
    .clk_i                              ( clk_i                                         ),
    .rst_ni                             ( rstn_i                                        ),
    .clock_en_i                         ( clock_en                                      ),
    .test_en_i                          ( test_en                                       ),
    .fregfile_disable_i                 ( fregfile_disable                              ),
    .boot_addr_i                        ( boot_addr                                     ),
    .core_id_i                          ( core_id                                       ),
    .cluster_id_i                       ( cluster_id                                    ),
    .instr_req_o                        ( ram_instr_req                                 ),
    .instr_gnt_i                        ( ram_instr_gnt                                 ),
    .instr_rvalid_i                     ( ram_instr_rvalid                              ),
    .instr_addr_o                       ( ram_instr_addr                                ),
    .instr_rdata_i                      ( ram_instr_rdata                               ),
    .data_req_o                         ( m_req[1]                                      ),
    .data_gnt_i                         ( m_gnt[1]                                      ),
    .data_rvalid_i                      ( m_rvalid[1]                                   ),
    .data_we_o                          ( m_we[1]                                       ),
    .data_be_o                          ( m_be[1]                                       ),
    .data_addr_o                        ( m_addr[1]                                     ),
    .data_wdata_o                       ( m_wdata[1]                                    ),
    .data_rdata_i                       ( m_rdata[1]                                    ),
    .apu_master_req_o                   ( apu_master_req                                ),
    .apu_master_ready_o                 ( apu_master_ready                              ),
    .apu_master_gnt_i                   ( apu_master_gnt                                ),
    .apu_master_operands_o              ( apu_master_operands                           ),
    .apu_master_op_o                    ( apu_master_op                                 ),
    .apu_master_type_o                  ( apu_master_type                               ),
    .apu_master_flags_o                 ( apu_master_flags_out                          ),
    .apu_master_valid_i                 ( apu_master_valid                              ),
    .apu_master_result_i                ( apu_master_result                             ),
    .apu_master_flags_i                 ( apu_master_flags_in                           ),
    .irq_i                              ( irq                                           ),
    .irq_id_i                           ( irq_id_in                                     ),
    .irq_ack_o                          ( irq_ack                                       ),
    .irq_id_o                           ( irq_id_out                                    ),
    .irq_sec_i                          ( irq_sec                                       ),
    .sec_lvl_o                          ( sec_lvl                                       ),
    .debug_req_i                        ( debug_req                                     ),
    .fetch_enable_i                     ( fetch_enable                                  ),
    .core_busy_o                        ( core_busy                                     ),
    .ext_perf_counters_i                ( ext_perf_counters                             ),
    .clk_gat_core_i                     ( dis_clk_core & ~m_rvalid[0] & ~m_gnt[0]       )
  );
`endif

  ram_top #(
    .N_BANKS ( Numb32KBsramBlocks )
  ) ram_top_i (
    .clk_i         ( clk_i                            ),
    .rstn_i        ( rstn_i                           ),
    .data_req_i    ( s_en[0:Numb32KBsramBlocks-1]     ),
    .data_gnt_o    ( s_gnt[0:Numb32KBsramBlocks-1]    ),
    .data_rvalid_o ( s_rvalid[0:Numb32KBsramBlocks-1] ),
    .data_we_i     ( s_we[0:Numb32KBsramBlocks-1]     ),
    .data_be_i     ( s_be[0:Numb32KBsramBlocks-1]     ),
    .data_addr_i   ( s_addr[0:Numb32KBsramBlocks-1]   ),
    .data_wdata_i  ( s_wdata[0:Numb32KBsramBlocks-1]  ),
    .data_rdata_o  ( s_rdata[0:Numb32KBsramBlocks-1]  )
  );

`ifdef CGRA_AND_EVENT_UNIT
  cgra_top_wrapper cgra_top_wrapper_i (
    .clk_i                              ( clk_i                                         ),
    .rstn_i                             ( rstn_i                                        ),
    .master_0_data_req_o                ( m_req[2]                                      ),
    .master_0_data_gnt_i                ( m_gnt[2]                                      ),
    .master_0_data_rvalid_i             ( m_rvalid[2]                                   ),
    .master_0_data_we_o                 ( m_we[2]                                       ),
    .master_0_data_be_o                 ( m_be[2]                                       ),
    .master_0_data_addr_o               ( m_addr[2]                                     ),
    .master_0_data_wdata_o              ( m_wdata[2]                                    ),
    .master_0_data_rdata_i              ( m_rdata[2]                                    ),
    .master_1_data_req_o                ( m_req[3]                                      ),
    .master_1_data_gnt_i                ( m_gnt[3]                                      ),
    .master_1_data_rvalid_i             ( m_rvalid[3]                                   ),
    .master_1_data_we_o                 ( m_we[3]                                       ),
    .master_1_data_be_o                 ( m_be[3]                                       ),
    .master_1_data_addr_o               ( m_addr[3]                                     ),
    .master_1_data_wdata_o              ( m_wdata[3]                                    ),
    .master_1_data_rdata_i              ( m_rdata[3]                                    ),
    .master_2_data_req_o                ( m_req[4]                                      ),
    .master_2_data_gnt_i                ( m_gnt[4]                                      ),
    .master_2_data_rvalid_i             ( m_rvalid[4]                                   ),
    .master_2_data_we_o                 ( m_we[4]                                       ),
    .master_2_data_be_o                 ( m_be[4]                                       ),
    .master_2_data_addr_o               ( m_addr[4]                                     ),
    .master_2_data_wdata_o              ( m_wdata[4]                                    ),
    .master_2_data_rdata_i              ( m_rdata[4]                                    ),
    .master_3_data_req_o                ( m_req[5]                                      ),
    .master_3_data_gnt_i                ( m_gnt[5]                                      ),
    .master_3_data_rvalid_i             ( m_rvalid[5]                                   ),
    .master_3_data_we_o                 ( m_we[5]                                       ),
    .master_3_data_be_o                 ( m_be[5]                                       ),
    .master_3_data_addr_o               ( m_addr[5]                                     ),
    .master_3_data_wdata_o              ( m_wdata[5]                                    ),
    .master_3_data_rdata_i              ( m_rdata[5]                                    ),
    .periph_data_req_i                  ( s_en[6]                                       ),
    .periph_data_gnt_o                  ( s_gnt[6]                                      ),
    .periph_data_rvalid_o               ( s_rvalid[6]                                   ),
    .periph_data_we_i                   ( s_we[6]                                       ),
    .periph_data_be_i                   ( s_be[6]                                       ),
    .periph_data_addr_i                 ( s_addr[6]                                     ),
    .periph_data_wdata_i                ( s_wdata[6]                                    ),
    .periph_data_rdata_o                ( s_rdata[6]                                    ),
    .cgra_ram_addr_i                    ( cgra_bridge_addr_i                            ),
    .cgra_ram_wdata_i                   ( cgra_bridge_wdata_i                           ),
    .cgra_ram_we_i                      ( cgra_bridge_we_i                              ),
    .cgra_int_line_o                    ( cgra_int                                      )
  );

  event_unit event_unit_i (
    .clk_i                              ( clk_i                                         ),
    .rstn_i                             ( rstn_i                                        ),
    .data_req_i                         ( s_en[7]                                       ),
    .data_gnt_o                         ( s_gnt[7]                                      ),
    .data_rvalid_o                      ( s_rvalid[7]                                   ),
    .data_we_i                          ( s_we[7]                                       ),
    .data_be_i                          ( s_be[7]                                       ),
    .data_addr_i                        ( s_addr[7]                                     ),
    .data_wdata_i                       ( s_wdata[7]                                    ),
    .data_rdata_o                       ( s_rdata[7]                                    ),
    .dis_clk_core_o                     ( dis_clk_core                                  ),
    .cgra_int_i                         ( cgra_int                                      )
  );
`endif

  bus_top #(
    .N_MASTERS                          ( n_masters                                     ),
    .N_SLAVES                           ( n_slaves                                      )
  ) bus_top_i (
    .clk_i                              ( clk_i                                         ),
    .rstn_i                             ( rstn_i                                        ),
    .m_req_i                            ( m_req                                         ),
    .m_gnt_o                            ( m_gnt                                         ),
    .m_rvalid_o                         ( m_rvalid                                      ),
    .m_we_i                             ( m_we                                          ),
    .m_be_i                             ( m_be                                          ),
    .m_addr_i                           ( m_addr                                        ),
    .m_wdata_i                          ( m_wdata                                       ),
    .m_rdata_o                          ( m_rdata                                       ),
    .s_gnt_i                            ( s_gnt                                         ),
    .s_rvalid_i                         ( s_rvalid                                      ),
    .s_we_o                             ( s_we                                          ),
    .s_be_o                             ( s_be                                          ),
    .s_addr_o                           ( s_addr                                        ),
    .s_wdata_o                          ( s_wdata                                       ),
    .s_rdata_i                          ( s_rdata                                       ),
    .s_req_o                            ( s_en                                          )
  );


endmodule
