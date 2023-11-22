// Copyright 2022 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

module cgra_controller
  import cgra_pkg::*;
(
  input  logic                            clk_i,
  input  logic                            rst_ni,
  input  logic [               N_COL-1:0] acc_req_i,
  input  logic                            imem_gnt_ctrl_i,
  input  logic                            imem_rvalid_ctrl_i,
  input  logic [          KMEM_WIDTH-1:0] kmem_rdata_i,
  input  logic [ KER_CONF_N_REG_LOG2-1:0] ker_id_req_i,

  input  logic [               N_COL-1:0] data_stall_i,
  input  logic [               N_COL-1:0] rcs_br_req_i,
  input  logic [   RCS_NUM_CREG_LOG2-1:0] rcs_br_add_i [0:N_COL-1],
  input  logic [               N_COL-1:0] rcs_stall_i,
  input  logic [               N_COL-1:0] rcs_exec_end_i,
  output logic [               N_COL-1:0] rcs_conf_we_o,
  output logic [               N_COL-1:0] rcs_conf_re_o,
  output logic [               N_COL-1:0] rcs_pc_e_o,
  output logic [   RCS_NUM_CREG_LOG2-1:0] rcs_pc_o [0:N_COL-1],
  output logic [               N_COL-1:0] col_e_o,
  output logic [               N_COL-1:0] rcs_rst_col_o,
  output logic [               N_COL-1:0] rcs_conf_ack_o,

  output logic [   IMEM_N_LINES_LOG2-1:0] imem_radd_o,
  output logic                            rcs_conf_req_o,
  // To synchronizer
  output logic [               N_COL-1:0] col_start_o,
  output logic                            acc_ack_o,
  output logic [               N_COL-1:0] acc_end_o
);

  parameter GLOB_FSM_IDLE     = 2'b00;
  parameter GLOB_FSM_RCS_CONF = 2'b01;
  parameter GLOB_FSM_DONE     = 2'b10;
  // parameter GLOB_FSM_XXX      = 'x;


  parameter RCS_FSM_RESET = 3'b000;
  parameter RCS_FSM_IDLE  = 3'b001;
  parameter RCS_FSM_CONF  = 3'b010;
  parameter RCS_FSM_SYNCH = 3'b011;
  parameter RCS_FSM_EXEC  = 3'b100;
  parameter RCS_FSM_DONE  = 3'b101;
  // parameter RCS_FSM_XXX   = 'x;

  // FSMs VARIABLES
  logic [2-1:0] ctrl_fsm_state, ctrl_fsm_n_state;
  logic [3-1:0] rcs_fsm_state [0:N_COL-1];
  logic [3-1:0] rcs_fsm_n_state [0:N_COL-1];

  // RCS SIGNALS CONTROLLED BY FSM
  logic [               N_COL-1:0] rcs_conf_ack;
  logic [               N_COL-1:0] rcs_stall;
  logic [               N_COL-1:0] rcs_conf_we;
  logic [               N_COL-1:0] rcs_conf_req;
  logic [               N_COL-1:0] rcs_conf_re;
  logic [               N_COL-1:0] rcs_pc_rst;
  logic [               N_COL-1:0] rcs_pc_e;
  // RCS SIGNALS
  logic [   RCS_NUM_CREG_LOG2-1:0] rcs_pc [0:N_COL-1];
  logic [               N_COL-1:0] rcs_conf_end;
  logic [               N_COL-1:0] rcs_conf_end_reg;
  logic [               N_COL-1:0] rcs_req_end;
  logic [               N_COL-1:0] rcs_req_end_reg;
  logic [   RCS_NUM_CREG_LOG2-1:0] rcs_row_n_instr_s;
  logic [   IMEM_N_LINES_LOG2-1:0] rcs_imem_start_add;
  logic [               N_COL-1:0] rcs_start_s;
  logic                            rcs_load_conf_add;

  // 2 bits require to stall for 3 cycles
  logic [                   2-1:0] dp_stall_reg [0:N_COL-1];


  logic [   IMEM_N_LINES_LOG2-1:0] imem_radd_s;
  logic [ KER_CONF_N_REG_LOG2-1:0] col_ker_id [0:N_COL-1];
  logic                            all_col_conf_end;
  logic                            any_conf_e;
  
  genvar j;

  // TO INSTRUCTION MEMORY / CMEM
  assign imem_radd_o    = imem_radd_s;
  assign rcs_conf_req_o = |rcs_conf_req;

  // TO RCS MODULES
  assign rcs_conf_we_o  = rcs_conf_we;
  assign rcs_conf_re_o  = rcs_conf_re;
  assign rcs_pc_e_o     = rcs_pc_e;
  assign rcs_pc_o       = rcs_pc;
  assign rcs_rst_col_o  = rcs_pc_rst;
  assign rcs_conf_ack_o = rcs_conf_ack;

  always_comb
  begin
    if((rcs_conf_ack & acc_req_i) == acc_req_i && ctrl_fsm_state == GLOB_FSM_RCS_CONF) begin
      all_col_conf_end = 1'b1;
    end else begin
      all_col_conf_end = 1'b0;
    end  
  end

  //---------------------------------------------------------------------
  //
  // SEQUENTIAL BLOCK OF CONTROLLER FSM
  //
  //---------------------------------------------------------------------
  
  // GLOBAL CONTROLLER FSM

  always_ff @(posedge clk_i or negedge rst_ni)
  begin
    if (rst_ni == 1'b0) begin
      ctrl_fsm_state <= GLOB_FSM_IDLE;
    end else begin
      if (ctrl_fsm_state != ctrl_fsm_n_state) begin
        ctrl_fsm_state <= ctrl_fsm_n_state;
      end
    end
  end

  //---------------------------------------------------------------------
  //
  // SEQUENTIAL BLOCK OF COLUMN FSMs
  //
  //---------------------------------------------------------------------

  generate
    for(j=0; j<N_COL; j++) begin : col_fsm_gen

      always_ff @(posedge clk_i, negedge rst_ni)
      begin
        if (rst_ni == 1'b0) begin
          rcs_fsm_state[j] <= RCS_FSM_RESET;
        end else begin
          if (rcs_fsm_state[j] != rcs_fsm_n_state[j]) begin
            rcs_fsm_state[j] <= rcs_fsm_n_state[j];
          end
        end
      end

      // Store kernel ID to skip configuration during next request
      always_ff @(posedge clk_i, negedge rst_ni)
      begin
        if (rst_ni == 1'b0) begin
          col_ker_id[j] <= '0;
        end else begin
          if (all_col_conf_end == 1'b1 && acc_req_i[j] == 1'b1) begin
            col_ker_id[j] <= ker_id_req_i;
          end
        end
      end

      // Register to stop DMA and RCS/MUX configuration
      always_ff @(posedge clk_i, negedge rst_ni)
      begin
        if (rst_ni == 1'b0) begin
          rcs_conf_end_reg[j]  <= 1'b0;
        end else begin
          // RCS control
          if (rcs_pc_rst[j] == 1'b1) begin
            rcs_conf_end_reg[j] <= 1'b0;
          end else if (rcs_conf_end[j] == 1'b1 && rcs_fsm_state[j] == RCS_FSM_CONF) begin
            rcs_conf_end_reg[j] <= 1'b1;
          end
        end
      end

      // Register to stop request configuration word to CMEM for the RCs
      always_ff @(posedge clk_i, negedge rst_ni)
      begin
        if (rst_ni == 1'b0) begin
          rcs_req_end_reg[j]  <= 1'b0;
        end else begin
          // RCS control
          if (rcs_pc_rst[j] == 1'b1) begin
            rcs_req_end_reg[j] <= 1'b0;
          end else if (rcs_req_end[j] == 1'b1 && rcs_fsm_state[j] == RCS_FSM_CONF) begin
            rcs_req_end_reg[j] <= 1'b1;
          end
        end
      end

      // Stall the RCs for 3 cycles uring multiplication
      // Register set to 2 by default
      // When rc_stall_i is one
      //   cycle 0: dp_stall_reg == 2'b10
      //   cycle 1: dp_stall_reg == 2'b01
      //   cycle 2: dp_stall_reg == 2'b00 ==> clear to resume from RCs datapath side
      //   cycle 3 to ...: wait global stall is not assert before reseting dp_stall_reg to 2
      always_ff @(posedge clk_i, negedge rst_ni)
      begin
        if (rst_ni == 1'b0) begin
          dp_stall_reg[j]  <= 2'b10;
        end else begin
          // RCS control
          if (rcs_pc_rst[j] == 1'b1 || (dp_stall_reg[j] == 2'b00 && rcs_pc_e[j] == 1'b1)) begin
            dp_stall_reg[j] <= 2'b10;
          end else if (rcs_stall_i[j] == 1'b1 && dp_stall_reg[j] != 2'b00) begin
            dp_stall_reg[j] <= dp_stall_reg[j] - 1'b1;
          end
        end
      end
    end
  endgenerate

  ///////////////////////////////////////////////////////////
  //   _____ _______ _____  _         ______ _____ __  __  //
  //  / ____|__   __|  __ \| |       |  ____/ ____|  \/  | //
  // | |       | |  | |__) | |       | |__ | (___ | \  / | //
  // | |       | |  |  _  /| |       |  __| \___ \| |\/| | //
  // | |____   | |  | | \ \| |____   | |    ____) | |  | | //
  //  \_____|  |_|  |_|  \_|______|  |_|   |_____/|_|  |_| //
  //                                                       //
  ///////////////////////////////////////////////////////////
  always_comb
  begin
    ctrl_fsm_n_state  = 2'bXX;
    rcs_start_s       = '0;
    rcs_load_conf_add = 1'b0;
    acc_ack_o         = 1'b0;

    unique case (ctrl_fsm_state)

      GLOB_FSM_IDLE:
      begin
        if (acc_req_i != 0) begin
          ctrl_fsm_n_state  = GLOB_FSM_RCS_CONF;
          rcs_load_conf_add = 1'b1;
        end else begin
          ctrl_fsm_n_state = GLOB_FSM_IDLE;
        end
      end
      // RCS configuration
      GLOB_FSM_RCS_CONF:
      begin
        for (int i=0; i<N_COL; i++) begin
          if (acc_req_i[i] == 1'b1 && rcs_conf_ack[i] == 1'b0) begin
              rcs_start_s[i] = 1'b1;
            break;
          end
        end

        if (all_col_conf_end == 1'b1) begin
          ctrl_fsm_n_state = GLOB_FSM_DONE;
          acc_ack_o = 1'b1;
        end else begin
          ctrl_fsm_n_state = GLOB_FSM_RCS_CONF;
          acc_ack_o = 1'b0;
        end
      end

      GLOB_FSM_DONE: // one wait cycle for synch between modules - really needed ?
      begin
        ctrl_fsm_n_state = GLOB_FSM_IDLE;
      end

      default: ctrl_fsm_n_state = 2'bXX; // default case to suppress unique warning
    endcase
  end

  //////////////////////////////////////////////////
  //  _____   _____  _____   ______ _____ __  __  //
  // |  __ \ / ____|/ ____| |  ____/ ____|  \/  | //
  // | |__) | |    | (___   | |__ | (___ | \  / | //
  // |  _  /| |     \___ \  |  __| \___ \| |\/| | //
  // | | \ \| |____ ____) | | |    ____) | |  | | //
  // |_|  \_\\_____|_____/  |_|   |_____/|_|  |_| //
  //                                              //
  //////////////////////////////////////////////////
  always_comb
  begin
    for (int i=0; i<N_COL; i++) begin

      // Create a single-cycle spike to the data_handler module to store the data pointer
      col_start_o[i] = rcs_fsm_state[i] == RCS_FSM_IDLE ? rcs_start_s[i] : 1'b0;

      // Un-comment to allow stalling from RCs' ALU
      // rcs_stall[i]  = 1'b0;
      rcs_stall[i]  = rcs_stall_i[i] & (|dp_stall_reg[i]);

      rcs_fsm_n_state[i] = 3'bXXX;
      
      rcs_conf_ack[i] = 1'b0;
      col_e_o[i]      = 1'b1;
      rcs_conf_we[i]  = 1'b0;
      rcs_conf_req[i] = 1'b0;
      rcs_conf_re[i]  = 1'b0;
      rcs_pc_rst[i]   = 1'b0;
      rcs_pc_e[i]     = 1'b0;
      acc_end_o[i]    = 1'b0;

      unique case (rcs_fsm_state[i])

        RCS_FSM_RESET:
        begin
          rcs_fsm_n_state[i] = RCS_FSM_IDLE;
          rcs_pc_rst[i]      = 1'b1;
        end
        // Wait column start signal from the global controller
        RCS_FSM_IDLE:
        begin
          col_e_o[i] = 1'b0;
          // Wait request from cgra controller
          if (rcs_start_s[i] == 1'b1) begin
            rcs_fsm_n_state[i] = RCS_FSM_CONF;
          end else begin
            rcs_fsm_n_state[i] = RCS_FSM_IDLE;
          end
        end
        // Copy the configuration words to the RCS
        RCS_FSM_CONF:
          // Jump to synchronization phase when configuration is done
          if (rcs_conf_end_reg[i] == 1'b1 || col_ker_id[i] == ker_id_req_i) begin
            rcs_fsm_n_state[i] = RCS_FSM_SYNCH;
            rcs_pc_rst[i]      = 1'b1;
          end else begin
            rcs_fsm_n_state[i] = RCS_FSM_CONF;

            rcs_conf_we[i] = 1'b1;

            if (rcs_req_end_reg[i] == 1'b0) begin
              rcs_conf_req[i] = 1'b1;
            end

            if (imem_rvalid_ctrl_i == 1'b1) begin
              rcs_pc_e[i]    = 1'b1;
            end
          end
        // Synchronization state for multi-column kernels
        RCS_FSM_SYNCH:
        begin
          rcs_conf_ack[i] = 1'b1;

          // Wait for all columns to be configured and synch signal from dma
          if (all_col_conf_end == 1'b1) begin
            rcs_fsm_n_state[i] = RCS_FSM_EXEC;
          end else begin
            rcs_fsm_n_state[i] = RCS_FSM_SYNCH;
          end
        end

        RCS_FSM_EXEC:
        begin
          rcs_conf_re[i] = 1'b1;

          if (rcs_exec_end_i[i]  == 1'b1) begin
            rcs_pc_e[i] = 1'b0;
          end else begin
            rcs_pc_e[i] = ~(rcs_stall[i] | data_stall_i[i]);
          end

          if (rcs_exec_end_i[i]  == 1'b1 && rcs_stall[i] == 1'b0 && data_stall_i[i] == 1'b0) begin
            rcs_fsm_n_state[i] = RCS_FSM_DONE;
          end else begin
            rcs_fsm_n_state[i] = RCS_FSM_EXEC;
          end
        end

        RCS_FSM_DONE:
        begin
          // reset now otherwise next conf_word can generate rd/wr request with possible unknown value
          rcs_pc_rst[i]      = 1'b1;
          rcs_fsm_n_state[i] = RCS_FSM_IDLE;
          acc_end_o[i]       = 1'b1;
        end

        default: rcs_fsm_n_state[i] = 3'bXXX; // default case to suppress unique warning
      endcase
    end
  end

  //---------------------------------------------------------------------
  //
  // CONFIGRATION ADDRESS GENERATION AND CONTROL
  //
  //---------------------------------------------------------------------

  // RCS kernel configuration
  assign rcs_row_n_instr_s  = kmem_rdata_i[  RCS_N_INSTR_HB:RCS_N_INSTR_LB];
  assign rcs_imem_start_add = kmem_rdata_i[RCS_IMEM_ADD_HB:RCS_IMEM_ADD_LB];

  always_comb
  begin
    // RCS end of configuration detection
    for (int i=0; i<N_COL; i++) begin
      rcs_conf_end[i] = (rcs_pc[i] == rcs_row_n_instr_s) ? 1'b1 : 1'b0;
    end
  end

  always_comb
  begin
    // CMEM conf. worr request end detection
    for (int i=0; i<N_COL; i++) begin
      rcs_req_end[i] = ((rcs_pc[i] == (rcs_row_n_instr_s-1)) && imem_gnt_ctrl_i == 1'b1) ? 1'b1 : 1'b0;
    end
  end

  // Enable address incrementation if RCS are being configured
  assign any_conf_e = (|rcs_conf_we) & imem_gnt_ctrl_i;

  // Address counter to read configuration memory
  // RCs
  always_ff @(posedge clk_i, negedge rst_ni)
  begin
    if (rst_ni == 1'b0) begin
      imem_radd_s <= '0;
    end else begin
      if (rcs_load_conf_add == 1'b1) begin
        imem_radd_s <= rcs_imem_start_add;
      end else if (any_conf_e == 1'b1) begin
        imem_radd_s <= imem_radd_s + 1;
      end
    end
  end

  //---------------------------------------------------------------------
  //
  // Components mapping
  //
  //---------------------------------------------------------------------

  generate
    for(j=0; j<N_COL; j++) begin : rcs_pc_gen
      program_counter #(
        .CNT_N_BITS ( RCS_NUM_CREG_LOG2 )
      ) rcs_pc_i
      (
        .clk_i     ( clk_i           ),
        .rst_ni    ( rst_ni          ),
        .restart_i ( rcs_pc_rst[j]   ),
        .pc_e_i    ( rcs_pc_e[j]     ),
        .br_req_i  ( rcs_br_req_i[j] ),
        .br_add_i  ( rcs_br_add_i[j] ),
        .pc_o      ( rcs_pc[j]       )
      );
    end
  endgenerate

endmodule
