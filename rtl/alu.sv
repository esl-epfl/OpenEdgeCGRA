// Copyright 2022 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

module alu
  import cgra_pkg::*;
(
  input  logic [         DP_WIDTH-1:0] operand_a_i,
  input  logic [         DP_WIDTH-1:0] operand_b_i,
  input  logic [       ALU_N_FLAG-1:0] flag_i,
  input  logic [CGRA_ALU_OP_WIDTH-1:0] alu_op_i,
  output logic [         DP_WIDTH-1:0] alu_res_o,
  output logic [       ALU_N_FLAG-1:0] flag_o,
  output logic                         br_req_o,
  output logic [RCS_NUM_CREG_LOG2-1:0] br_add_o,
  output logic                         alu_stall_o
);

  import cgra_pkg::*;

  logic [DP_WIDTH-1:0] operand_a_rev;
  logic [  DP_WIDTH:0] operand_b_neg;

  // bit reverse operand_a for left shifts and bit counting
  generate
    genvar k;
    for(k = 0; k < 32; k++)
    begin : g_revloop
      assign operand_a_rev[k] = operand_a_i[31-k];
    end
  endgenerate

  /////////////////////////////////////
  //      _       _     _            //
  //     / \   __| | __| | ___ _ __  //
  //    / _ \ / _` |/ _` |/ _ \ '__| //
  //   / ___ \ (_| | (_| |  __/ |    //
  //  /_/   \_\__,_|\__,_|\___|_|    //
  //                                 //
  /////////////////////////////////////

  logic                adder_e;                // zeroing inputs if not used
  logic                adder_op_b_negate;
  logic [  DP_WIDTH:0] adder_in_a, adder_in_b;
  logic [DP_WIDTH+1:0] adder_result_full;
  logic [DP_WIDTH-1:0] adder_result;

  // logic                fxp_mult_e;      // rounding fxp_mult
  logic [  DP_WIDTH:0] fxp_mult_scaled; // extra decimal bit for rounding

  always_comb
  begin
    adder_e      = 1'b0;
    adder_op_b_negate = 1'b0;
    // fxp_mult_e        = 1'b0;

    unique case (alu_op_i)
      CGRA_ALU_SSUB,
      CGRA_ALU_BEQ,
      CGRA_ALU_BNE,
      CGRA_ALU_BLT,
      CGRA_ALU_BGE: begin
        adder_e      = 1'b1;
        adder_op_b_negate = 1'b1;
      end

      CGRA_ALU_SADD,
      CGRA_ALU_JUMP: adder_e = 1'b1;

      // // With rounding for CGRA_ALU_FXPMUL
      // CGRA_ALU_FXPMUL: begin
      //   adder_e = 1'b1;
      //   fxp_mult_e   = 1'b1;
      // end

      default: ; // default case to suppress unique warning
    endcase
  end

  // prepare operand a
  // Without rounding for CGRA_ALU_FXPMUL
  assign adder_in_a    = adder_e ? {operand_a_i,1'b1} : '0;
  // // With rounding for CGRA_ALU_FXPMUL
  // assign adder_in_a    = fxp_mult_e ? fxp_mult_scaled : {operand_a_i,1'b1};

  // prepare operand b
  assign operand_b_neg = adder_e ? {operand_b_i,1'b0} ^ {33{adder_op_b_negate}} : '0;

  // Without rounding for CGRA_ALU_FXPMUL
  assign adder_in_b    = operand_b_neg;
  // // With rounding for CGRA_ALU_FXPMUL
  // assign adder_in_b    = fxp_mult_e ? 1 : operand_b_neg;

  // actual adder
  assign adder_result_full = $unsigned(adder_in_a) + $unsigned(adder_in_b);

  assign adder_result      = adder_result_full[DP_WIDTH:1];

  ////////////////////////////////////////////////////////////////
  //  __  __ _   _ _   _____ ___ ____  _     ___ _____ ____     //
  // |  \/  | | | | | |_   _|_ _|  _ \| |   |_ _| ____|  _ \    //
  // | |\/| | | | | |   | |  | || |_) | |    | ||  _| | |_) |   //
  // | |  | | |_| | |___| |  | ||  __/| |___ | || |___|  _ <    //
  // |_|  |_|\___/|_____|_| |___|_|   |_____|___|_____|_| \_\   //
  //                                                            //
  ////////////////////////////////////////////////////////////////

  logic                  mult_e;               // zeroing inputs if not used
  logic                  fxp_mult_e;               // zeroing inputs if not used
  logic [  DP_WIDTH-1:0] mult_in_a, mult_in_b;
  logic [2*DP_WIDTH-1:0] mult_result_full;
  logic [  DP_WIDTH-1:0] mult_result;
  logic [  DP_WIDTH-1:0] fxp_mult_result;

  logic [           DP_WIDTH-1:0] operand_a_mult;
  logic [           DP_WIDTH-1:0] operand_b_mult;

  // Use dummy read module ports to easily find multiplier input operands during asic flow
  generate
    for(genvar j=0; j<DP_WIDTH; j++) begin : mult_read_gen
      read alu_mult_opa_i (
        .d_i (operand_a_i[j]),
        .d_o (operand_a_mult[j])
      );
      read alu_mult_opb_i (
        .d_i (operand_b_i[j]),
        .d_o (operand_b_mult[j])
      );
    end
  endgenerate

  always_comb
  begin
    mult_e     = 1'b0;
    fxp_mult_e = 1'b0;

    unique case (alu_op_i)
      CGRA_ALU_SMUL  : mult_e     = 1'b1;
      CGRA_ALU_FXPMUL: fxp_mult_e = 1'b1;

      default: ; // default case to suppress unique warning
    endcase
  end

  assign mult_in_a = (mult_e || fxp_mult_e) ? operand_a_mult : '0;
  assign mult_in_b = (mult_e || fxp_mult_e) ? operand_b_mult : '0;

  // actual multiplier
  assign mult_result_full = $signed(mult_in_a) * $signed(mult_in_b);
  assign mult_result      = mult_e ? mult_result_full[DP_WIDTH-1:0] : '0;

  localparam NBIT_DEC = 15;
  localparam NBIT_INT = 16;
  // localparam SIGN_BIT = 1;

  assign fxp_mult_scaled = mult_result_full[NBIT_INT+2*NBIT_DEC:NBIT_DEC-1];

  // Without rounding
  assign fxp_mult_result = fxp_mult_e ? fxp_mult_scaled[DP_WIDTH:1] : '0;
  // // With rounding
  // assign fxp_mult_result = adder_result_full[DP_WIDTH:1];

  ////////////////////////////////////////
  //  ____  _   _ ___ _____ _____       //
  // / ___|| | | |_ _|  ___|_   _|      //
  // \___ \| |_| || || |_    | |        //
  //  ___) |  _  || ||  _|   | |        //
  // |____/|_| |_|___|_|     |_|        //
  //                                    //
  ////////////////////////////////////////

  logic                     shift_e;            // zeroing inputs if not used
  logic                     shift_left;         // should we shift left
  logic [DP_WIDTH_LOG2-1:0] shift_amt;          // amount of shift, to the right
  logic [     DP_WIDTH-1:0] shift_op_a;         // input of the shifter
  logic [     DP_WIDTH  :0] shift_op_a_33b;     // For shift right arithmetic
  logic [     DP_WIDTH  :0] shift_right_result_signed;
  logic [     DP_WIDTH  :0] shift_right_result_33b;
  logic [     DP_WIDTH-1:0] shift_result;
  logic [     DP_WIDTH-1:0] shift_right_result;
  logic [     DP_WIDTH-1:0] shift_left_result;
  logic                     shift_arithmetic;

  assign shift_arithmetic = (alu_op_i == CGRA_ALU_SRA);

  always_comb
  begin
    shift_e = 1'b0;

    unique case (alu_op_i)
      CGRA_ALU_SLL,
      CGRA_ALU_SRL,
      CGRA_ALU_SRA: shift_e = 1'b1;

      default: ; // default case to suppress unique warning
    endcase
  end

  assign shift_amt  = shift_e ? operand_b_i[DP_WIDTH_LOG2-1:0] : '0;
  assign shift_left = (alu_op_i == CGRA_ALU_SLL);

  // choose the bit reversed or the normal input for shift operand a
  always_comb
  begin
    if (shift_e == 1'b1 && shift_left == 1'b0) begin
      shift_op_a = operand_a_i;
    end else if (shift_e == 1'b1 && shift_left == 1'b1) begin
      shift_op_a = operand_a_rev;
    end else begin
      shift_op_a = '0;
    end
  end
  
  assign shift_op_a_33b = {shift_arithmetic & shift_op_a[DP_WIDTH-1], shift_op_a};

  assign shift_right_result_signed = $signed(shift_op_a_33b) >>> shift_amt[DP_WIDTH_LOG2-1:0];
  assign shift_right_result_33b    = $unsigned(shift_right_result_signed);
  assign shift_right_result        = shift_right_result_33b[DP_WIDTH-1:0];

  // bit reverse the shift_right_result for left shifts
  genvar       j;
  generate
    for(j = 0; j < DP_WIDTH; j++)
    begin : g_resrevloop
      assign shift_left_result[j] = shift_right_result[31-j];
    end
  endgenerate

  assign shift_result = shift_left ? shift_left_result : shift_right_result;

  //////////////////////////////////////////////////////////////////
  //   ____ ___  __  __ ____   _    ____  ___ ____   ___  _   _   //
  //  / ___/ _ \|  \/  |  _ \ / \  |  _ \|_ _/ ___| / _ \| \ | |  //
  // | |  | | | | |\/| | |_) / _ \ | |_) || |\___ \| | | |  \| |  //
  // | |__| |_| | |  | |  __/ ___ \|  _ < | | ___) | |_| | |\  |  //
  //  \____\___/|_|  |_|_| /_/   \_\_| \_\___|____/ \___/|_| \_|  //
  //                                                              //
  //////////////////////////////////////////////////////////////////

  logic is_equal;
  logic is_greater_equal;  // handles both signed and unsigned forms
  logic br_req_s;
  logic cmp_result_mux;
  logic cmp_result;

  assign is_equal = (adder_result == '0);

  // Is greater equal
  always_comb
  begin
    if ((operand_a_i[DP_WIDTH-1] ^ operand_b_i[DP_WIDTH-1]) == 0)
      is_greater_equal = (adder_result[DP_WIDTH-1] == 0);
    else
      is_greater_equal = ~operand_a_i[DP_WIDTH-1];
  end

  // generate comparison result
  always_comb
  begin
    cmp_result_mux = 1'b0;

    unique case (alu_op_i)
      CGRA_ALU_BEQ : cmp_result_mux = is_equal;
      CGRA_ALU_BNE : cmp_result_mux = (~is_equal);
      CGRA_ALU_BGE : cmp_result_mux = is_greater_equal;
      CGRA_ALU_BLT : cmp_result_mux = (~is_greater_equal);
      CGRA_ALU_JUMP: cmp_result_mux = 1'b1; // always jump

      default: ; // default case to suppress unique warning
    endcase
  end

  assign cmp_result = cmp_result_mux;
  assign br_req_s   = cmp_result;

  ////////////////////////////////////////////////
  //  ____  _ _     __  __             _        //
  // | __ )(_) |_  |  \/  | __ _ _ __ (_)_ __   //
  // |  _ \| | __| | |\/| |/ _` | '_ \| | '_ \  //
  // | |_) | | |_  | |  | | (_| | | | | | |_) | //
  // |____/|_|\__| |_|  |_|\__,_|_| |_|_| .__/  //
  //                                    |_|     //
  ////////////////////////////////////////////////

  logic                bit_manip_e;
  logic [DP_WIDTH-1:0] bit_manip_res;
  logic [DP_WIDTH-1:0] and_res;
  logic [DP_WIDTH-1:0] or_res;
  logic [DP_WIDTH-1:0] xor_res;
  logic [DP_WIDTH-1:0] bit_manip_in_a, bit_manip_in_b;

  always_comb
  begin
    bit_manip_e = 1'b0;

    unique case (alu_op_i)
      CGRA_ALU_LAND,
      CGRA_ALU_LOR,
      CGRA_ALU_LXOR,
      CGRA_ALU_LNAND,
      CGRA_ALU_LNOR,
      CGRA_ALU_LNXOR: bit_manip_e = 1'b1;

      default: ; // default case to suppress unique warning
    endcase
  end

  assign bit_manip_in_a = bit_manip_e ? operand_a_i : '0;
  assign bit_manip_in_b = bit_manip_e ? operand_b_i : '0;

  assign and_res = bit_manip_in_a & bit_manip_in_b;
  assign or_res  = bit_manip_in_a | bit_manip_in_b;
  assign xor_res = bit_manip_in_a ^ bit_manip_in_b;

  always_comb
  begin
    bit_manip_res = '0;

    unique case (alu_op_i)
      CGRA_ALU_LAND:  bit_manip_res = and_res;
      CGRA_ALU_LOR:   bit_manip_res = or_res;
      CGRA_ALU_LXOR:  bit_manip_res = xor_res;
      CGRA_ALU_LNAND: bit_manip_res = ~and_res;
      CGRA_ALU_LNOR:  bit_manip_res = ~or_res;
      CGRA_ALU_LNXOR: bit_manip_res = ~xor_res;

      default: ; // default case to suppress unique warning
    endcase
  end

  ///////////////////////////////////////////////////////////////////////////
  //   ____ ___  _   _ _____ ____   ___  _        ____ _    __ __      __  //
  //  / ___/ _ \| \ | |_   _|  _ \ / _ \| |      |  __| |  / _ \ \    /  / //
  // | |  | | | |  \| | | | | |_) | | | | |      | |_ | | | | | | \/\/  /  //
  // | |__| |_| | |\  | | | |  _ <| |_| | |__    |  _|| |_| |_| \      /   //
  //  \____\___/|_| \_| |_| \_| \_\\___/|____|   |_|  |____\___/ \_/\_/    //
  //                                                                       //
  ///////////////////////////////////////////////////////////////////////////

  logic                ctrl_flow_e;
  logic [DP_WIDTH-1:0] ctrl_flow_res;
  logic                sign_flag;
  logic                zero_flag;
  logic [DP_WIDTH-1:0] ctrl_flow_in_a, ctrl_flow_in_b;

  assign sign_flag = flag_i[1] & ctrl_flow_e;
  assign zero_flag = flag_i[0] & ctrl_flow_e;

  always_comb
  begin
    ctrl_flow_e = 1'b0;

    unique case (alu_op_i)
      CGRA_ALU_BSFA,
      CGRA_ALU_BZFA:ctrl_flow_e = 1'b1;

      default: ; // default case to suppress unique warning
    endcase
  end

  assign ctrl_flow_in_a = ctrl_flow_e ? operand_a_i : '0;
  assign ctrl_flow_in_b = ctrl_flow_e ? operand_b_i : '0;

  always_comb
  begin
    ctrl_flow_res = ctrl_flow_in_a;

    unique case (alu_op_i)
      CGRA_ALU_BSFA: ctrl_flow_res = sign_flag ? ctrl_flow_in_a : ctrl_flow_in_b;
      CGRA_ALU_BZFA: ctrl_flow_res = zero_flag ? ctrl_flow_in_a : ctrl_flow_in_b;

      default: ; // default case to suppress unique warning
    endcase
  end

  ////////////////////////////////////////////////////////
  //   ____                 _ _     __  __              //
  //  |  _ \ ___  ___ _   _| | |_  |  \/  |_   ___  __  //
  //  | |_) / _ \/ __| | | | | __| | |\/| | | | \ \/ /  //
  //  |  _ <  __/\__ \ |_| | | |_  | |  | | |_| |>  <   //
  //  |_| \_\___||___/\__,_|_|\__| |_|  |_|\__,_/_/\_\  //
  //                                                    //
  ////////////////////////////////////////////////////////

  always_comb
  begin
    alu_res_o   = '0;

    unique case (alu_op_i)
      // Adder operations
      CGRA_ALU_SADD, CGRA_ALU_SSUB,
      CGRA_ALU_JUMP: alu_res_o = adder_result;

      // Multiplier operation
      CGRA_ALU_SMUL: alu_res_o = mult_result;

      // Shift operations
      CGRA_ALU_SLL, CGRA_ALU_SRA,
      CGRA_ALU_SRL: alu_res_o = shift_result;

      // Bit manip operations
      CGRA_ALU_LAND,
      CGRA_ALU_LOR,
      CGRA_ALU_LXOR,
      CGRA_ALU_LNAND,
      CGRA_ALU_LNOR,
      CGRA_ALU_LNXOR: alu_res_o = bit_manip_res;

      // Control flow operations
      CGRA_ALU_BSFA,
      CGRA_ALU_BZFA: alu_res_o = ctrl_flow_res;
      // CGRA_ALU_MV: alu_res_o = ctrl_flow_res;

      // FXP multiplication operation
      CGRA_ALU_FXPMUL: alu_res_o = fxp_mult_result;

      // Comparison operations
      CGRA_ALU_BEQ,
      CGRA_ALU_BNE,
      CGRA_ALU_BGE,
      CGRA_ALU_BLT: alu_res_o = {{(DP_WIDTH-1){1'b0}}, cmp_result};

      default: ; // default case to suppress unique warning
    endcase
  end

  assign flag_o      = {alu_res_o[DP_WIDTH-1], ~(|alu_res_o)};
  assign br_req_o    = br_req_s;
    assign br_add_o    = alu_op_i == CGRA_ALU_JUMP ? adder_result[RCS_NUM_CREG_LOG2-1:0] : '0;
  assign alu_stall_o = (alu_op_i == CGRA_ALU_SMUL || alu_op_i == CGRA_ALU_FXPMUL) ? 1'b1 : '0;

endmodule
