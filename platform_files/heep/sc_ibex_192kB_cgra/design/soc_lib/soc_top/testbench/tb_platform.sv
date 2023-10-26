
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
// Author:         Simone Machetti - simone.machetti@epfl.ch                  //
//                                                                            //
// Additional contributions by:                                               //
//                 Benoît Denkinger benoit.denkinger@epfl.ch                  //
//                                                                            //
// Design Name:    tb_platform                                                //
//                                                                            //
// Project Name:   HealWear-V                                                 //
//                                                                            //
// Language:       SystemVerilog                                              //
//                                                                            //
// Description:    SoC testbench.                                             //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////


`timescale 1ns/1ps

`define CLK_PERIOD        12.5ns
`define HALF_CLK_PERIOD   6.25ns

`define CGRA_AND_EVENT_UNIT


`define SRAM_FILE                   "../../mem/init_sram.mem"
`define OUT_FILE                    "../../mem/debug.mem"

`ifdef CGRA_AND_EVENT_UNIT
`define CGRA_N_ROWS                 4
`define CGRA_INSTR_WIDTH            32
`define CGRA_RC_INSTR_N_REG         128
`define CGRA_KMEM_WIDTH             15
`define CGRA_KER_CONF_N_REG         16
`define CGRA_BITSTREAM_FILENAME     "$IPS_ROOT/cgra/mem/cgra_imem.bit"
`define CGRA_KER_MEM_FILENAME       "$IPS_ROOT/cgra/mem/cgra_kmem.bit"
`endif


task save_results;
begin

  int fd;
  int rWord;
  
  fd = $fopen(`OUT_FILE, "w");

// LAST kB data memory for debugging
`ifdef RTL_SIM 
  for (rWord=7936; rWord<8192; rWord++) begin
    $fdisplay(fd, "%d", tb_platform.soc_top_i.ram_top_i.sram_bank_gen[5].sram_block_i.sram_8192x32_i.uut.mem_core_array[rWord]);
  end
`endif

`ifdef NETLIST_SIM
  for (rWord=7936; rWord<8192; rWord++) begin
    $fdisplay(fd, "%d", tb_platform.soc_top_i.ram_top_i.sram_bank_gen_5__sram_block_i.sram_8192x32_i.uut.mem_core_array[rWord]);
  end
`endif

end
endtask


task init_ram;
begin

  int rWord;

  logic [31:0] PRELOAD_SRAM [0:(6*8192)-1];

  $readmemh(`SRAM_FILE, PRELOAD_SRAM);

`ifdef RTL_SIM
  // Initialize SRAM
  for (rWord=0; rWord<8192; rWord++) begin
    tb_platform.soc_top_i.ram_top_i.sram_bank_gen[0].sram_block_i.sram_8192x32_i.uut.mem_core_array[rWord] = PRELOAD_SRAM[rWord+(0*8192)];
  end
  for (rWord=0; rWord<8192; rWord++) begin
    tb_platform.soc_top_i.ram_top_i.sram_bank_gen[1].sram_block_i.sram_8192x32_i.uut.mem_core_array[rWord] = PRELOAD_SRAM[rWord+(1*8192)];
  end
  for (rWord=0; rWord<8192; rWord++) begin
    tb_platform.soc_top_i.ram_top_i.sram_bank_gen[2].sram_block_i.sram_8192x32_i.uut.mem_core_array[rWord] = PRELOAD_SRAM[rWord+(2*8192)];
  end
  for (rWord=0; rWord<8192; rWord++) begin
    tb_platform.soc_top_i.ram_top_i.sram_bank_gen[3].sram_block_i.sram_8192x32_i.uut.mem_core_array[rWord] = PRELOAD_SRAM[rWord+(3*8192)];
  end
  for (rWord=0; rWord<8192; rWord++) begin
    tb_platform.soc_top_i.ram_top_i.sram_bank_gen[4].sram_block_i.sram_8192x32_i.uut.mem_core_array[rWord] = PRELOAD_SRAM[rWord+(4*8192)];
  end
  for (rWord=0; rWord<8192; rWord++) begin
    tb_platform.soc_top_i.ram_top_i.sram_bank_gen[5].sram_block_i.sram_8192x32_i.uut.mem_core_array[rWord] = PRELOAD_SRAM[rWord+(5*8192)];
  end
`endif

`ifdef NETLIST_SIM
  // Initialize SRAM
  for (rWord=0; rWord<8192; rWord++) begin
    tb_platform.soc_top_i.ram_top_i.sram_bank_gen_0__sram_block_i.sram_8192x32_i.uut.mem_core_array[rWord] = PRELOAD_SRAM[rWord+(0*8192)];
  end
  for (rWord=0; rWord<8192; rWord++) begin
    tb_platform.soc_top_i.ram_top_i.sram_bank_gen_1__sram_block_i.sram_8192x32_i.uut.mem_core_array[rWord] = PRELOAD_SRAM[rWord+(1*8192)];
  end
  for (rWord=0; rWord<8192; rWord++) begin
    tb_platform.soc_top_i.ram_top_i.sram_bank_gen_2__sram_block_i.sram_8192x32_i.uut.mem_core_array[rWord] = PRELOAD_SRAM[rWord+(2*8192)];
  end
  for (rWord=0; rWord<8192; rWord++) begin
    tb_platform.soc_top_i.ram_top_i.sram_bank_gen_3__sram_block_i.sram_8192x32_i.uut.mem_core_array[rWord] = PRELOAD_SRAM[rWord+(3*8192)];
  end
  for (rWord=0; rWord<8192; rWord++) begin
    tb_platform.soc_top_i.ram_top_i.sram_bank_gen_4__sram_block_i.sram_8192x32_i.uut.mem_core_array[rWord] = PRELOAD_SRAM[rWord+(4*8192)];
  end
  for (rWord=0; rWord<8192; rWord++) begin
    tb_platform.soc_top_i.ram_top_i.sram_bank_gen_5__sram_block_i.sram_8192x32_i.uut.mem_core_array[rWord] = PRELOAD_SRAM[rWord+(5*8192)];
  end
`endif

end
endtask


`ifdef CGRA_AND_EVENT_UNIT

`ifdef RTL_SIM
task init_cgra_mem;
begin

  int rWord;

  logic [`CGRA_INSTR_WIDTH-1:0] PRELOAD_CGRA_IMEM [0:`CGRA_N_ROWS*`CGRA_RC_INSTR_N_REG-1];
  logic [ `CGRA_KMEM_WIDTH-1:0] PRELOAD_KER       [0:`CGRA_KER_CONF_N_REG-1];
  $readmemb(`CGRA_BITSTREAM_FILENAME, PRELOAD_CGRA_IMEM);
  $readmemb(`CGRA_KER_MEM_FILENAME, PRELOAD_KER);

  for (rWord=0; rWord<`CGRA_RC_INSTR_N_REG; rWord++) begin
    tb_platform.soc_top_i.cgra_top_wrapper_i.cgra_top_i.cgra_instr_mem_i.instr_mem[0][rWord] = PRELOAD_CGRA_IMEM[rWord];
  end
  for (rWord=0; rWord<`CGRA_RC_INSTR_N_REG; rWord++) begin
    tb_platform.soc_top_i.cgra_top_wrapper_i.cgra_top_i.cgra_instr_mem_i.instr_mem[1][rWord] = PRELOAD_CGRA_IMEM[rWord+1*`CGRA_RC_INSTR_N_REG];
  end
  for (rWord=0; rWord<`CGRA_RC_INSTR_N_REG; rWord++) begin
    tb_platform.soc_top_i.cgra_top_wrapper_i.cgra_top_i.cgra_instr_mem_i.instr_mem[2][rWord] = PRELOAD_CGRA_IMEM[rWord+2*`CGRA_RC_INSTR_N_REG];
  end
  for (rWord=0; rWord<`CGRA_RC_INSTR_N_REG; rWord++) begin
    tb_platform.soc_top_i.cgra_top_wrapper_i.cgra_top_i.cgra_instr_mem_i.instr_mem[3][rWord] = PRELOAD_CGRA_IMEM[rWord+3*`CGRA_RC_INSTR_N_REG];
  end
  for (rWord=0; rWord<`CGRA_KER_CONF_N_REG; rWord++) begin
    tb_platform.soc_top_i.cgra_top_wrapper_i.cgra_top_i.cgra_instr_mem_i.ker_conf_mem[rWord] = PRELOAD_KER[rWord];
  end

end
endtask
`endif

`endif


module tb_platform #(
);


  /////////////////////////
  // Signals declaration //
  /////////////////////////

  logic             rstn;
  logic             clk;

`ifdef CGRA_AND_EVENT_UNIT
  logic [9:0]       cgra_bridge_addr;
  logic [31:0]      cgra_bridge_wdata;
  logic             cgra_bridge_we;

`ifdef NETLIST_SIM
  int rWord;

  logic [`CGRA_INSTR_WIDTH-1:0] PRELOAD_INSTR_0 [0:`CGRA_RC_INSTR_N_REG-1];
  logic [`CGRA_INSTR_WIDTH-1:0] PRELOAD_INSTR_1 [0:`CGRA_RC_INSTR_N_REG-1];
  logic [`CGRA_INSTR_WIDTH-1:0] PRELOAD_INSTR_2 [0:`CGRA_RC_INSTR_N_REG-1];
  logic [`CGRA_INSTR_WIDTH-1:0] PRELOAD_INSTR_3 [0:`CGRA_RC_INSTR_N_REG-1];
  logic [ `CGRA_KMEM_WIDTH-1:0] PRELOAD_KER [0:`CGRA_KER_CONF_N_REG-1];
`endif

`endif

  int               exit_status     = 1;
//  int               gen_clk_period  = 12.5;  // 80MHz


  ///////////////////////
  // UUT instantiation //
  ///////////////////////

`ifdef CGRA_AND_EVENT_UNIT
  soc_top soc_top_i (
    .rstn_i               ( rstn                ),
    .clk_i                ( clk                 ),
    .cgra_bridge_addr_i   ( cgra_bridge_addr    ),
    .cgra_bridge_wdata_i  ( cgra_bridge_wdata   ),
    .cgra_bridge_we_i     ( cgra_bridge_we      )
  );
`else
  soc_top soc_top_i (
    .rstn_i               ( rstn                ),
    .clk_i                ( clk                 )
  );
`endif


  /////////////////////////////////////////
  // Reset, mem init and clock processes //
  /////////////////////////////////////////

  // Reset and mem init
  initial begin

    $timeformat(-9,3," ns",10);

    rstn   = 1'b0;
    init_ram;

`ifdef CGRA_AND_EVENT_UNIT

`ifdef RTL_SIM
    init_cgra_mem;
`endif

`ifdef NETLIST_SIM
    $readmemb(`CGRA_INSTR_MEM0_FILENAME, PRELOAD_INSTR_0);
    $readmemb(`CGRA_INSTR_MEM1_FILENAME, PRELOAD_INSTR_1);
    $readmemb(`CGRA_INSTR_MEM2_FILENAME, PRELOAD_INSTR_2);
    $readmemb(`CGRA_INSTR_MEM3_FILENAME, PRELOAD_INSTR_3);
    $readmemb(`CGRA_KER_MEM_FILENAME, PRELOAD_KER);

    cgra_bridge_we = 1'b1;
    for (rWord=0; rWord<`CGRA_RC_INSTR_N_REG; rWord++) begin
      cgra_bridge_addr  = rWord;
      cgra_bridge_wdata = PRELOAD_INSTR_0[rWord];
      #(`CLK_PERIOD);
    end
    for (rWord=0; rWord<`CGRA_RC_INSTR_N_REG; rWord++) begin
      cgra_bridge_addr  = rWord+`CGRA_RC_INSTR_N_REG;
      cgra_bridge_wdata = PRELOAD_INSTR_1[rWord];
      #(`CLK_PERIOD);
    end
    for (rWord=0; rWord<`CGRA_RC_INSTR_N_REG; rWord++) begin
      cgra_bridge_addr  = rWord+2*`CGRA_RC_INSTR_N_REG;
      cgra_bridge_wdata = PRELOAD_INSTR_2[rWord];
      #(`CLK_PERIOD);
    end
    for (rWord=0; rWord<`CGRA_RC_INSTR_N_REG; rWord++) begin
      cgra_bridge_addr  = rWord+3*`CGRA_RC_INSTR_N_REG;
      cgra_bridge_wdata = PRELOAD_INSTR_3[rWord];
      #(`CLK_PERIOD);
    end
    for (rWord=0; rWord<`CGRA_KER_CONF_N_REG; rWord++) begin
      cgra_bridge_addr  = rWord+4*`CGRA_RC_INSTR_N_REG;
      cgra_bridge_wdata = PRELOAD_KER[rWord];
      #(`CLK_PERIOD);
    end
    cgra_bridge_addr    = 10'h000;
    cgra_bridge_wdata   = 32'h00000000;
    cgra_bridge_we      = 1'b0;
`endif

`endif

    #(`CLK_PERIOD*10);
    #(25);
    rstn = 1'b1;
  end

  integer cc_count;

  always_ff @(negedge clk, negedge rstn)
  begin
    if (rstn == 1'b0) begin
      cc_count <= 0;
    end else begin
      cc_count <= cc_count+1;
      // Print timing info for vcd_config.tcl file
      // if (tb_platform.soc_top_i.cgra_top_wrapper_i.periph_data_gnt_o == 1'b1 && 
      //     tb_platform.soc_top_i.cgra_top_wrapper_i.periph_data_addr_i[N_PERIPH_REGS_LOG2+2-1:2] == CGRA_APB_REG_STATE) begin
      if (tb_platform.soc_top_i.cgra_top_wrapper_i.periph_data_gnt_o == 1'b1 && 
          tb_platform.soc_top_i.cgra_top_wrapper_i.periph_data_addr_i[5+2-1:2] == 31) begin
        $display("TBENCH : CGRA STATE READ at %t (%d clock-cycles)", $time, cc_count);
      end
    end
  end

  // Clock generator
  always begin

    if (rstn == 1'b1) begin
      clk = 1'b0;
      #(`HALF_CLK_PERIOD);
      clk = 1'b1;
      #(`HALF_CLK_PERIOD); 

      // Last data word for simulation end
      `ifdef RTL_SIM
          if(tb_platform.soc_top_i.ram_top_i.sram_bank_gen[5].sram_block_i.sram_8192x32_i.uut.mem_core_array[8191] == 1) begin
            exit_status = 0;
            save_results;
            $display("\nDone!\n");
            $stop;
          end
      `endif

      `ifdef NETLIST_SIM
          if(tb_platform.soc_top_i.ram_top_i.sram_bank_gen_5__sram_block_i.sram_8192x32_i.uut.mem_core_array[8191] == 1) begin
            exit_status = 0;
            save_results;
            $display("\nDone!\n");
            $stop;
          end
      `endif
    end else begin
      clk = 1'b0;
      #(`HALF_CLK_PERIOD);
    end

  end
  

endmodule
