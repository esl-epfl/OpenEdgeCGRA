// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

`timescale 1ns/1ps

import cgra_config_pkg::*;

`define NULL 0

// Clock definition in ns
`define CLK_PERIOD        12.5ns
`define HALF_CLK_PERIOD   6.25ns

// // Uncomment to not skip the long idle part at the beginning (useful to measure CGRA idle power)
// `define CGRA_IDLE_EXE

`define MEM_INSTR_CGRA cgra_tb.i_dut.cgra_instr_mem_i.instr_mem
`define MEM_KERN_CGRA cgra_tb.i_dut.cgra_instr_mem_i.ker_conf_mem

// import cgra_package::*;

module cgra_tb;

  logic                  clk, clk_tmp;
  logic                  rst, rst_tmp;
  logic                  test_mode;
  // TCDM Master port
  logic [4-1:0]          tcdm_req;
  logic [4-1:0]          tcdm_gnt;
  logic [4-1:0] [32-1:0] tcdm_add;
  logic [4-1:0]          tcdm_wen;
  logic [4-1:0] [4 -1:0] tcdm_be;
  logic [4-1:0] [32-1:0] tcdm_wdata;
  logic [4-1:0] [32-1:0] tcdm_rdata;
  logic [4-1:0]          tcdm_r_valid;
  // Peripheral interface TO THE REGISTERS
  logic                  periph_req, periph_req_tmp;
  logic                  periph_gnt;
  logic         [31  :0] periph_add;
  logic                  periph_wen;
  logic         [3   :0] periph_be;
  logic         [31  :0] periph_wdata;
  logic         [ID-1:0] periph_id;
  logic         [31  :0] periph_rdata;
  logic                  periph_r_valid;
  logic         [ID-1:0] periph_r_id;
  // CGRA events
  logic [N_CORES-1:0]    s_evt;
  // CGRA RAM ports
  logic [WR_INSTR_ADD_LEN-1:0] instr_add_s;
  logic [     INSTR_WIDTH-1:0] instr_wdata_s;
  logic           instr_we_s;

  logic [4-1:0] gnt_synch = '0;

  reg [2-1 : 0] state_loop_req_synch;

  real time_t, time_prev = 0.0;
  integer initialization = 1, reach_execution = 0, last_step_ran = 0, ready2resume = 1, steps_skip = 0;

  //=================================================================================//
  //===============================   CHOOSE KERNEL   ===============================//
  //=================================================================================//

  // time is in ns
  // file handler
  integer log_file = $fopen("mylogfile", "r");

  //=================================================================================//

  integer next_line, i;

  string line, str;
  integer data_in[21];

  task cgra_mem_init;
  begin
    ////////////////////////////////////////////////////////////////////////////////////////////
    // CGRA V2
    // -0 otherwise it overflows and for loop never ends
    reg [RC_INSTR_N_REG_LOG2-0:0] w;
    reg [KER_CONF_N_REG_LOG2-0:0] w_k;

    reg [INSTR_WIDTH-1:0] PRELOAD_INSTR_0 [0:RC_INSTR_N_REG-1];
    reg [INSTR_WIDTH-1:0] PRELOAD_INSTR_1 [0:RC_INSTR_N_REG-1];
    reg [INSTR_WIDTH-1:0] PRELOAD_INSTR_2 [0:RC_INSTR_N_REG-1];
    reg [INSTR_WIDTH-1:0] PRELOAD_INSTR_3 [0:RC_INSTR_N_REG-1];

    reg [INSTR_WIDTH-1:0] PRELOAD_KER [0:KER_CONF_N_REG-1];

    // Loading bootloader memory
    $display("Init: Preloading CGRA INSTRUCTIONS MEMORY from file %s", CGRA_INSTR_MEM0_FILENAME);
    $readmemb(CGRA_INSTR_MEM0_FILENAME, PRELOAD_INSTR_0);
    $display("Init: Preloading CGRA INSTRUCTIONS MEMORY from file %s", CGRA_INSTR_MEM1_FILENAME);
    $readmemb(CGRA_INSTR_MEM1_FILENAME, PRELOAD_INSTR_1);
    $display("Init: Preloading CGRA INSTRUCTIONS MEMORY from file %s", CGRA_INSTR_MEM2_FILENAME);
    $readmemb(CGRA_INSTR_MEM2_FILENAME, PRELOAD_INSTR_2);
    $display("Init: Preloading CGRA INSTRUCTIONS MEMORY from file %s", CGRA_INSTR_MEM3_FILENAME);
    $readmemb(CGRA_INSTR_MEM3_FILENAME, PRELOAD_INSTR_3);

    $display("Init: Preloading CGRA KERNEL MEMORY from file %s", CGRA_KER_MEM_FILENAME);
    $readmemb(CGRA_KER_MEM_FILENAME, PRELOAD_KER);


    clk = 0;
    rst = 1;
    instr_add_s   = '0;
    instr_wdata_s = '0;
    instr_we_s    = '0;
    #100ns
    rst = 0;
  
    `ifndef NETLIST_SIM

      for (w=0; w<RC_INSTR_N_REG; w=w+1) begin
        `MEM_INSTR_CGRA[0][w] = PRELOAD_INSTR_0[w];
      end
      for (w=0; w<RC_INSTR_N_REG; w=w+1) begin
        `MEM_INSTR_CGRA[1][w] = PRELOAD_INSTR_1[w];
      end
      for (w=0; w<RC_INSTR_N_REG; w=w+1) begin
        `MEM_INSTR_CGRA[2][w] = PRELOAD_INSTR_2[w];
      end
      for (w=0; w<RC_INSTR_N_REG; w=w+1) begin
        `MEM_INSTR_CGRA[3][w] = PRELOAD_INSTR_3[w];
      end

      for (w_k=0; w_k<KER_CONF_N_REG; w_k=w_k+1) begin
        // $display("%h", PRELOAD_KER[w_k]);
       `MEM_KERN_CGRA[w_k] = PRELOAD_KER[w_k];
      end


    `else

      instr_we_s = 1;

      // MEM BANK 1 -- INSTRUCTIONS 1
      for (w = 0; w < RC_INSTR_N_REG; w = w + 1) begin
        instr_wdata_s = PRELOAD_INSTR_0[w];
        if(^instr_wdata_s === 1'bX) begin
          instr_wdata_s = 0;
        end
        #(`HALF_CLK_PERIOD-2ns)
        clk = 0;
        #`HALF_CLK_PERIOD
        clk = 1;
        #2ns
        instr_add_s += 1;
      end
      // MEM BANK 2 -- INSTRUCTIONS 2
      for (w = 0; w < RC_INSTR_N_REG; w = w + 1) begin
        instr_wdata_s = PRELOAD_INSTR_1[w];
        if(^instr_wdata_s === 1'bX) begin
          instr_wdata_s = 0;
        end
        #(`HALF_CLK_PERIOD-2ns)
        clk = 0;
        #`HALF_CLK_PERIOD
        clk = 1;
        #2ns
        instr_add_s += 1;
      end
      // MEM BANK 3 -- INSTRUCTIONS 3
      for (w = 0; w < RC_INSTR_N_REG; w = w + 1) begin
        instr_wdata_s = PRELOAD_INSTR_2[w];
        if(^instr_wdata_s === 1'bX) begin
          instr_wdata_s = 0;
        end
        #(`HALF_CLK_PERIOD-2ns)
        clk = 0;
        #`HALF_CLK_PERIOD
        clk = 1;
        #2ns
        instr_add_s += 1;
      end
      // MEM BANK 4 -- INSTRUCTIONS 4
      for (w = 0; w < RC_INSTR_N_REG; w = w + 1) begin
        instr_wdata_s = PRELOAD_INSTR_3[w];
        if(^instr_wdata_s === 1'bX) begin
          instr_wdata_s = 0;
        end
        #(`HALF_CLK_PERIOD-2ns)
        clk = 0;
        #`HALF_CLK_PERIOD
        clk = 1;
        #2ns
        instr_add_s += 1;
      end
      // MEM BANK 5 -- KERNEL CONF
      for (w_k = 0; w_k < KER_CONF_N_REG; w_k = w_k + 1) begin
        instr_wdata_s = PRELOAD_KER[w_k];
        if(^instr_wdata_s === 1'bX) begin
          instr_wdata_s = 0;
        end
        #(`HALF_CLK_PERIOD-2ns)
        clk = 0;
        #`HALF_CLK_PERIOD
        clk = 1;
        #2ns
        instr_add_s += 1;
      end
    `endif

    instr_we_s    = '0;
    instr_wdata_s = '0;
    clk = 0;
    #10ns;
  end
  endtask

  initial begin
    // Init ROM
    // cgra_mem_init();

    // log_file = $fopen("../HDL/TBENCH/sig_log.out", "r");
    if (log_file == `NULL) begin
      $display("log_file handle was NULL");
      $stop;
    end

    if($fgets(line,log_file)) begin
        // $display("%s", line);
        $sscanf(line,"%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d", data_in[0], data_in[1], data_in[2], data_in[3], data_in[4], data_in[5], data_in[6], data_in[7], data_in[8], data_in[9], data_in[10], data_in[11], data_in[12], data_in[13], data_in[14], data_in[15], data_in[16], data_in[17], data_in[18], data_in[19], data_in[20]);
        // $display("%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d", data_in[0], data_in[1], data_in[2], data_in[3], data_in[4], data_in[5], data_in[6], data_in[7], data_in[8], data_in[9], data_in[10], data_in[11], data_in[12], data_in[13], data_in[14], data_in[15], data_in[16], data_in[17], data_in[18], data_in[19], data_in[20]);
        time_prev    = data_in[0];
        clk          = data_in[1];
        rst          = data_in[2];
        periph_req   = data_in[3];
        periph_add   = data_in[4];
        periph_wen   = data_in[5];
        periph_be    = data_in[6];
        periph_wdata = data_in[7];
        periph_id    = data_in[8];

        tcdm_gnt[0]  = data_in[9];
        tcdm_rdata[0]   = data_in[10];
        tcdm_r_valid[0] = data_in[11];

        tcdm_gnt[1]  = data_in[12];
        tcdm_rdata[1]   = data_in[13];
        tcdm_r_valid[1] = data_in[14];

        tcdm_gnt[2]  = data_in[15];
        tcdm_rdata[2]   = data_in[16];
        tcdm_r_valid[2] = data_in[17];

        tcdm_gnt[3]  = data_in[18];
        tcdm_rdata[3]   = data_in[19];
        tcdm_r_valid[3] = data_in[20];
    end
  end

  always
  begin

    if (initialization) begin
      cgra_mem_init();
      initialization = 0;
    end
    else if($fgets(line,log_file)) begin

      $sscanf(line,"%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d", data_in[0], data_in[1], data_in[2], data_in[3], data_in[4], data_in[5], data_in[6], data_in[7], data_in[8], data_in[9], data_in[10], data_in[11], data_in[12], data_in[13], data_in[14], data_in[15], data_in[16], data_in[17], data_in[18], data_in[19], data_in[20]);

      time_t  = data_in[0];


      clk_tmp = data_in[1];
      rst_tmp = data_in[2];
      periph_req_tmp = data_in[3];
      // rst = rst_tmp;

      // #(time_t-time_prev-0.2ns);
      // time_prev = time_t;

      if((reach_execution || rst_tmp || (last_step_ran && !clk_tmp))) begin // run if exec reached, reset and if clk is going low

        rst = rst_tmp;

        // Check if signal change between clock change, don't remove time
        if (clk != clk_tmp) begin
          #(time_t-time_prev-0.2ns);
        end else begin
          #(time_t-time_prev);
        end

        if (!ready2resume) begin
          for (i = 0; i < steps_skip; i++) begin
            clk = !clk;
            #`HALF_CLK_PERIOD;
            clk = !clk;
            #`HALF_CLK_PERIOD;
          end
        end

        // Try to bypass beginning until first request from the cores
        clk = clk_tmp;
        #0.2ns;
          
        periph_req   = data_in[3];
        periph_add   = data_in[4];
        periph_wen   = data_in[5];
        periph_be    = data_in[6];
        periph_wdata = data_in[7];
        periph_id    = data_in[8];


//            if (gnt_synch[0] == 1) begin
//              tcdm_gnt[0]  = data_in[9];
//            end else begin
//              if (data_in[9] == 0) begin
//                gnt_synch[0] = 1;
//                tcdm_gnt[0]  = data_in[9];
//              end else begin
//                tcdm_gnt[0]  = 0;
//              end
//            end

        tcdm_gnt[0]  = data_in[9];
        tcdm_rdata[0]   = data_in[10];
        tcdm_r_valid[0] = data_in[11];


//            if (gnt_synch[1] == 1) begin
//              tcdm_gnt[1]  = data_in[12];
//            end else begin
//              if (data_in[12] == 0) begin
//                gnt_synch[1] = 1;
//                tcdm_gnt[1]  = data_in[12];
//              end else begin
//                tcdm_gnt[1]  = 0;
//              end
//            end

        tcdm_gnt[1]  = data_in[12];
        tcdm_rdata[1]   = data_in[13];
        tcdm_r_valid[1] = data_in[14];


//            if (gnt_synch[2] == 1) begin
//              tcdm_gnt[2]  = data_in[15];
//            end else begin
//              if (data_in[15] == 0) begin
//                gnt_synch[2] = 1;
//                tcdm_gnt[2]  = data_in[15];
//              end else begin
//                tcdm_gnt[2]  = 0;
//              end
//            end

        tcdm_gnt[2]  = data_in[15];
        tcdm_rdata[2]   = data_in[16];
        tcdm_r_valid[2] = data_in[17];


//            if (gnt_synch[3] == 1) begin
//              tcdm_gnt[3]  = data_in[18];
//            end else begin
//              if (data_in[18] == 0) begin
//                gnt_synch[3] = 1;
//                tcdm_gnt[3]  = data_in[18];
//              end else begin
//                tcdm_gnt[3]  = 0;
//              end
//            end

        tcdm_gnt[3]  = data_in[18];
        tcdm_rdata[3]   = data_in[19];
        tcdm_r_valid[3] = data_in[20];

        last_step_ran = 1;
        steps_skip = 0;
        ready2resume = 1;

      end else begin

        // #0.2ns;
        last_step_ran = 0;
        steps_skip = steps_skip + 1;

        // Skip the correct number of step to keep synchronization with CGRA
        if (steps_skip == 8) begin
          ready2resume = 1;
          steps_skip = 0;
        end else begin
          ready2resume = 0;
        end

        // ACTIVE SEQUENCE
        if (periph_req_tmp == 1'b1) begin
          reach_execution = 1;
        end

        `ifdef CGRA_IDLE_EXE
        // TO SEE CGRA IDLE TIME
        reach_execution = 1;
        `endif

      end

      time_prev = time_t;

    end
    else begin $stop; end
  end

  // time clk rst periph_req periph_add periph_wen periph_be periph_wdata periph_id tcdm_gnt tcdm_rdata tcdm_r_valid

  cgra_top i_dut
  (
    .clk_i            ( clk            ),
    .rst_i            ( rst            ),
    // Peripheral interface TO THE REGISTERS
    .periph_req_i     ( periph_req     ),
    .periph_enable_i  ( 1'b1           ),
    .periph_add_i     ( periph_add     ),
    .periph_wen_i     ( periph_wen     ),
    .periph_be_i      ( periph_be      ),
    .periph_wdata_i   ( periph_wdata   ),
    .periph_id_i      ( periph_id      ),
    .periph_gnt_o     ( periph_gnt     ),
    .periph_rdata_o   ( periph_rdata   ),
    .periph_r_valid_o ( periph_r_valid ),
    .periph_r_id_o    ( periph_r_id    ),
    // TCDM Master port
    .tcdm_req_o       ( tcdm_req       ),
    .tcdm_add_o       ( tcdm_add       ),
    .tcdm_wen_o       ( tcdm_wen       ),
    .tcdm_be_o        ( tcdm_be        ),
    .tcdm_wdata_o     ( tcdm_wdata     ),
    .tcdm_gnt_i       ( tcdm_gnt       ),
    .tcdm_rdata_i     ( tcdm_rdata     ),
    .tcdm_r_valid_i   ( tcdm_r_valid   ),
    .instr_waddr_i    ( instr_add_s    ),
    .instr_wdata_i    ( instr_wdata_s  ),
    .instr_we_i       ( instr_we_s     ),
    .evt_o            ( s_evt          )
  );

endmodule
