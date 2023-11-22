// Copyright 2023 EPFL
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

module cgra_rcs
  import cgra_pkg::*;
(
  input  logic [            N_COL-1:0] clk_i,
  input  logic [            N_COL-1:0] rst_col_i,
  input  logic [            N_COL-1:0] rcs_conf_we_i,
  input  logic [            N_COL-1:0] rcs_conf_re_i,
  input  logic [RCS_NUM_CREG_LOG2-1:0] rcs_col_pc_i [0:N_COL-1],
  input  logic [      INSTR_WIDTH-1:0] rcs_conf_words_i [0:N_ROW-1],
  input  logic [            N_COL-1:0] rcs_pc_e_i,
  input  logic [         DP_WIDTH-1:0] data_rdata_i [0:N_COL-1],
  input  logic [            N_COL-1:0] data_gnt_i,
  input  logic [            N_COL-1:0] data_rvalid_i,
  input  logic [            N_COL-1:0] col_acc_map_i [0:N_COL-1],
  output logic [            N_COL-1:0] data_req_o,
  output logic [            N_COL-1:0] data_wen_o,
  output logic [            N_COL-1:0] data_ind_o,
  output logic [         DP_WIDTH-1:0] data_add_o [0:N_COL-1],
  output logic [         DP_WIDTH-1:0] data_wdata_o [0:N_COL-1],
  output logic [   RC_CONST_WIDTH-1:0] add_inc_o [0:N_COL-1],
  output logic [            N_COL-1:0] rcs_br_req_o,
  output logic [RCS_NUM_CREG_LOG2-1:0] rcs_br_add_o [0:N_COL-1],
  output logic [            N_COL-1:0] rcs_stall_o,
  output logic [            N_COL-1:0] exec_end_o
);

  logic [   N_COL-1:0] rcs_ex_end [0:N_ROW-1];
  logic [   N_COL-1:0] rcs_stall_s [0:N_ROW-1];
  logic [   N_COL-1:0] rcs_nop_s [0:N_ROW-1];
  logic [   N_COL-1:0] rc_stall_col;
  logic [   N_ROW-1:0] rcs_br_req_row_s [0:N_COL-1];
  logic [   N_COL-1:0] rcs_br_req_row_merged_s;
  logic [   N_COL-1:0] rcs_br_req_col_merged_s [0:N_COL-1];
  logic [   N_COL-1:0] rcs_exec_end_col_merged;
  logic [   N_COL-1:0] rc_stall_comb;
  logic [   N_COL-1:0] rcs_br_req [0:N_ROW-1];
  logic [   N_COL-1:0] exec_end_s;
  logic [   N_COL-1:0] data_req_s [0:N_ROW-1];
  logic [   N_COL-1:0] data_wen_s [0:N_ROW-1];
  logic [   N_COL-1:0] data_ind_s [0:N_ROW-1];
  logic [DP_WIDTH-1:0] data_add_s [0:N_ROW-1][0:N_COL-1];
  logic [DP_WIDTH-1:0] data_wdata_s [0:N_ROW-1][0:N_COL-1];
  logic [RC_CONST_WIDTH-1:0] add_inc_s [0:N_ROW-1][0:N_COL-1];
  logic [DP_WIDTH-1:0] rcs_wdata_s [0:N_COL-1];

  logic [  DP_WIDTH-1:0] rcs_res [0:N_ROW-1][0:N_COL-1];
  logic [  DP_WIDTH-1:0] rcs_res_reg [0:N_ROW-1][0:N_COL-1];
  logic [  DP_WIDTH-1:0] rcs_res_reg_temp [0:N_ROW-1][0:N_COL-1];
  logic [ALU_N_FLAG-1:0] rcs_flag [0:N_ROW-1][0:N_COL-1];
  logic [ALU_N_FLAG-1:0] rcs_flag_reg [0:N_ROW-1][0:N_COL-1];
  logic [ALU_N_FLAG-1:0] rcs_flag_reg_temp [0:N_ROW-1][0:N_COL-1];

  logic [RCS_NUM_CREG_LOG2-1:0] rcs_br_add [0:N_ROW-1][0:N_COL-1];

  logic [   N_ROW-1:0] data_req_gnt_mask [0:N_COL-1];
  logic [   N_ROW-1:0] gnt_demux [0:N_COL-1];
  logic [   N_ROW-1:0] data_req_rvalid_mask [0:N_COL-1];
  logic [   N_ROW-1:0] rvalid_demux [0:N_COL-1];
  logic [   N_ROW-1:0] gnt_mask [0:N_COL-1];
  logic [   N_ROW-1:0] rvalid_mask [0:N_COL-1];

  logic [-1:N_COL][  DP_WIDTH-1:0] rcs_mesh_res [-1:N_ROW];
  logic [-1:N_COL][ALU_N_FLAG-1:0] rcs_mesh_flag [-1:N_ROW];

  // i,k are usually for the rows and j,l for the columns
  genvar i,j;

  assign rcs_stall_o = rc_stall_comb;
  assign exec_end_o = exec_end_s;

  assign data_wdata_o = rcs_wdata_s;

  always_comb
  begin
    for (int l=0; l<N_COL; l++) begin
      // Merge rows branch request
      rcs_br_req_row_merged_s[l] = '0;
      for (int k=0; k<N_ROW; k++) begin
        rcs_br_req_row_s[l][k] = rcs_br_req[k][l];
        rcs_br_req_row_merged_s[l] |= rcs_br_req[k][l];
      end
      // Capture execution end signal
      rcs_exec_end_col_merged[l] = '0;
      for (int k=0; k<N_ROW; k++) begin
        rcs_exec_end_col_merged[l] |= rcs_ex_end[k][l];
      end
      // RCs stall capture
      rc_stall_col[l] = '0;
      for (int k=0; k<N_ROW; k++) begin
        rc_stall_col[l] |= rcs_stall_s[k][l];
      end
    end
  end

  always_comb
  begin
    for (int l=0; l<N_COL; l++) begin
      // Combine the stall for multi-columns kernel
      rc_stall_comb[l] = |(rc_stall_col & col_acc_map_i[l]);
      // Branch cols request for multi-cols kernels
      rcs_br_req_col_merged_s[l] = rcs_br_req_row_merged_s & col_acc_map_i[l];
    end
  end

  // Only let the execution end signal go through if there is not branch request and check if signal should be propagated to other columns
  always_comb
  begin
    for (int l=0; l<N_COL; l++) begin
      exec_end_s[l] = |(rcs_exec_end_col_merged & ~rcs_br_req_o & col_acc_map_i[l]);
    end
  end

  // Maintain request high as long as one RC is not served
  always_comb
  begin
    for (int l=0; l<N_COL; l++) begin
      data_req_o[l] = |data_req_gnt_mask[l];
    end
  end

  // Select which request to grant
  generate // generate is used to create separated statement blocks
    for (j=0; j<N_COL; j++) begin : gnt_demux_gen
      always_comb
      begin
        gnt_demux[j] = '0;
        // for each row
        for (int k=0; k<N_ROW; k++) begin
          if (data_req_gnt_mask[j][k] == 1'b1 && data_gnt_i[j] == 1'b1) begin
            gnt_demux[j][k] = 1'b1;
            break;
          end
        end
      end
    end : gnt_demux_gen
  endgenerate

  // Select which request to forward rvalid (only for read wen=1)
  generate // generate is used to create separated statement blocks
    for (j=0; j<N_COL; j++) begin : rvalid_demux_gen
      always_comb
      begin
        rvalid_demux[j] = '0;
        // for each row
        for (int k=0; k<N_ROW; k++) begin
          if (data_req_rvalid_mask[j][k] == 1'b1 && data_wen_s[k][j] == 1'b1 && data_rvalid_i[j] == 1'b1) begin
            rvalid_demux[j][k] = 1'b1;
            break;
          end
        end
      end
    end : rvalid_demux_gen
  endgenerate

  // Mask data request of an RC once it is granted
  always_comb
  begin
    for (int l=0; l<N_COL; l++) begin
      for (int m=0; m<N_ROW; m++) begin
        // mask the request once it is granted
        data_req_gnt_mask[l][m] = data_req_s[m][l] & gnt_mask[l][m];
      end
    end
  end

  // Mask data request of an RC once data is read
  always_comb
  begin
    for (int l=0; l<N_COL; l++) begin
      for (int m=0; m<N_ROW; m++) begin
        // mask the request once data is read
        data_req_rvalid_mask[l][m] = data_req_s[m][l] & rvalid_mask[l][m];
      end
    end
  end

  // Generate gnt mask
  generate // generate is used to create separated statement blocks
    for (j=0; j<N_COL; j++) begin : gnt_mask_gen
      always_ff @(posedge clk_i[j])
      begin
        if (rst_col_i[j] == 1'b1 || rcs_pc_e_i[j] == 1'b1) begin // reset at start and every new instruction
          for (int k=0; k<N_ROW; k++) begin
            gnt_mask[j][k] <= 1'b1;
          end
        end else begin
          for (int k=0; k<N_ROW; k++) begin
            if (gnt_demux[j][k] == 1'b1) begin
              gnt_mask[j][k] <= 1'b0;
            end
          end
        end
      end
    end : gnt_mask_gen
  endgenerate

  // Generate rvalid mask
  generate // generate is used to create separated statement blocks
    for (j=0; j<N_COL; j++) begin : rvalid_mask_gen
      always_ff @(posedge clk_i[j])
      begin
        if (rst_col_i[j] == 1'b1 || rcs_pc_e_i[j] == 1'b1) begin // reset at start and every new instruction
          for (int k=0; k<N_ROW; k++) begin
            rvalid_mask[j][k] <= 1'b1;
          end
        end else begin
          for (int k=0; k<N_ROW; k++) begin
            if (rvalid_demux[j][k] == 1'b1) begin
              rvalid_mask[j][k] <= 1'b0;
            end
          end
        end
      end
    end : rvalid_mask_gen
  endgenerate

  // Register between RCs
  generate // generate is used to create separated statement blocks
    for (j=0; j<N_COL; j++) begin : reg_gen
      always_ff @(posedge clk_i[j])
      begin
        if (rst_col_i[j] == 1'b1) begin
          for (int k=0; k<N_ROW; k++) begin
            rcs_res_reg[k][j]  <= '0;
            rcs_flag_reg[k][j] <= '0;
            rcs_res_reg_temp[k][j]  <= '0;
            rcs_flag_reg_temp[k][j] <= '0;
          end
        end else begin
          for (int k=0; k<N_ROW; k++) begin
            if (rcs_pc_e_i[j] == 1'b0) begin // PC enable is low
              if (rvalid_demux[j][k] == 1'b1) begin // If the data is ready, copy it to a temproary buffer
                rcs_res_reg_temp[k][j]  <= data_rdata_i[j];
                rcs_flag_reg_temp[k][j] <= {data_rdata_i[j][DP_WIDTH-1], ~(|data_rdata_i[j])};
              end
            end else begin // PC enable is high
              if (data_req_s[k][j] == 1'b0) begin
                if (rcs_nop_s[k][j] == 1'b0) begin
                  rcs_res_reg[k][j]  <= rcs_res[k][j];
                  rcs_flag_reg[k][j] <= rcs_flag[k][j];
                end
              end else begin  // Read data instruction
                if (rcs_nop_s[k][j] == 1'b0) begin
                  if (rvalid_demux[j][k] == 1'b1) begin // If the data is ready, copy it straight away.
                    rcs_res_reg[k][j]  <= data_rdata_i[j];
                    rcs_flag_reg[k][j] <= {data_rdata_i[j][DP_WIDTH-1], ~(|data_rdata_i[j])};
                  end else begin  // If the data is not ready, it was ready before, so copy the temp buffer.
                    // This is necessary as some special cases require it.
                    rcs_res_reg[k][j]  <= rcs_res_reg_temp[k][j];
                    rcs_flag_reg[k][j] <= rcs_flag_reg_temp[k][j];
                  end
                end
              end
            end
          end
        end
      end
    end
  endgenerate

  generate // generate is used to create separated statement blocks
    for (j=0; j<N_COL; j++) begin : data_req_gen

      always_comb begin
        // for each row
        data_add_o[j] = '0; // default value
        for (int k=0; k<N_ROW; k++) begin
          if (data_req_gnt_mask[j][k] == 1'b1) begin
            if (data_ind_s[k][j] == 1'b1) begin
              // LWI or SWI
              data_add_o[j] = data_add_s[k][j];
            end else begin
              // LWD or SWD
              add_inc_o[j]  = add_inc_s[k][j];
            end
            break;
          end
        end
      end

      always_comb begin
        // for each row
        rcs_wdata_s[j] = '0; // default value
        for (int k=0; k<N_ROW; k++) begin
          if (data_req_gnt_mask[j][k] == 1'b1 && data_wen_s[k][j] == 1'b0) begin
            rcs_wdata_s[j] = data_wdata_s[k][j];
            break;
          end
        end
      end

      always_comb begin
        // for each row
        data_wen_o[j] = '0; // default value
        data_ind_o[j] = '0; // default value
        for (int k=0; k<N_ROW; k++) begin
          if (data_req_gnt_mask[j][k] == 1'b1) begin
            data_wen_o[j] = data_wen_s[k][j];
            data_ind_o[j] = data_ind_s[k][j];
            break;
          end
        end
      end
    end
  endgenerate

  logic [N_COL-1:0] one_hot_encoding_col;
  logic [N_ROW-1:0] one_hot_encoding_row;

  // Branch request
  always_comb
  begin

    for (int l=0; l<N_COL; l++) begin

      rcs_br_req_o[l] = 1'b0;
      rcs_br_add_o[l] = '0;
      one_hot_encoding_col = {{(N_COL-1){1'b0}}, 1'b1};
      one_hot_encoding_row = {{(N_ROW-1){1'b0}}, 1'b1};

      for (int k=0; k<N_COL; k++) begin
        if (rcs_br_req_col_merged_s[l] == one_hot_encoding_col) begin
          for (int n=0; n<N_ROW; n++) begin
            if (rcs_br_req_row_s[k] == one_hot_encoding_row) begin
              rcs_br_req_o[l]  = 1'b1;
              rcs_br_add_o[l] = rcs_br_add[n][k];
              break;
            end
            one_hot_encoding_row = one_hot_encoding_row << 1;
          end
          break;
        end
        one_hot_encoding_col = one_hot_encoding_col << 1;
      end
    end
  end

  //---------------------------------------------------------------------
  //
  // CGRA torus connection array use to easily connect all cells
  //
  //---------------------------------------------------------------------

  always_comb
  begin
    // RCs data result connections
    for (int k=0; k<N_ROW; k++) begin
      for (int l=0; l<N_COL; l++) begin
        rcs_mesh_res[k][l] = rcs_res_reg[k][l];
      end
    end
    for (int k=0; k<N_ROW; k++) begin
      rcs_mesh_res[k][-1] = rcs_res_reg[k][N_COL-1];
      rcs_mesh_res[k][N_COL] = rcs_res_reg[k][0];
    end
    for (int l=0; l<N_COL; l++) begin
      rcs_mesh_res[-1][l] = rcs_res_reg[N_ROW-1][l];
      rcs_mesh_res[N_ROW][l] = rcs_res_reg[0][l];
    end

    // RCs flag result connections
    for (int k=0; k<N_ROW; k++) begin
      for (int l=0; l<N_COL; l++) begin
        rcs_mesh_flag[k][l] = rcs_flag_reg[k][l];
      end
    end
    for (int k=0; k<N_ROW; k++) begin
      rcs_mesh_flag[k][-1] = rcs_flag_reg[k][N_COL-1];
      rcs_mesh_flag[k][N_COL] = rcs_flag_reg[k][0];
    end
    for (int l=0; l<N_COL; l++) begin
      rcs_mesh_flag[-1][l] = rcs_flag_reg[N_ROW-1][l];
      rcs_mesh_flag[N_ROW][l] = rcs_flag_reg[0][l];
    end
  end

  //---------------------------------------------------------------------
  //
  // Components mapping
  //
  //---------------------------------------------------------------------

  //  Example: 4x4 CGRA
  //  N_ROW x N_COL        col_0          col_1         col_2           col_3
  //
  //  RC1 / row_0      LTRC(0,0) ---- TRC (0,1) ---- TRC (0,2) ---- RTRC(0,3)
  //                       |              |              |              |
  //  RC2 / row_1      LRC (1,0) ---- CRC (1,1) ---- CRC (1,2) ---- RRC (1,3)
  //                       |              |              |              |
  //  RC3 / row_2      LRC (2,0) ---- CRC (2,1) ---- CRC (2,2) ---- RRC (2,3)
  //                       |              |              |              |
  //  RC4 / row_3      LBRC(3,0) ---- BRC (3,1) ---- BRC (3,2) ---- RBRC(3,3)

  generate
    for (i=0; i<N_ROW; i++) begin : rc_row_gen
      for (j=0; j<N_COL; j++) begin : rc_col_gen
        reconfigurable_cell rc_i (
          //                               [ROW][COL]
          .clk_i         (            clk_i     [j  ] ),
          .rst_rc_i      (       rst_col_i      [j  ] ),
          .conf_rdata_i  ( rcs_conf_words_i[i  ]      ),
          .data_rdata_i  (     data_rdata_i     [j  ] ),
          .data_rvalid_i (     rvalid_demux[j  ][i  ] ),
          .conf_we_i     (    rcs_conf_we_i     [j  ] ),
          .conf_re_i     (    rcs_conf_re_i     [j  ] ),
          .global_pc_i   (     rcs_col_pc_i     [j  ] ),
          .pc_en_i       (       rcs_pc_e_i     [j  ] ),
          .own_res_i     (     rcs_mesh_res[i  ][j  ] ),
          .left_res_i    (     rcs_mesh_res[i  ][j-1] ),
          .right_res_i   (     rcs_mesh_res[i  ][j+1] ),
          .top_res_i     (     rcs_mesh_res[i-1][j  ] ),
          .bottom_res_i  (     rcs_mesh_res[i+1][j  ] ),
          .own_flag_i    (    rcs_mesh_flag[i  ][j  ] ),
          .left_flag_i   (    rcs_mesh_flag[i  ][j-1] ),
          .right_flag_i  (    rcs_mesh_flag[i  ][j+1] ),
          .top_flag_i    (    rcs_mesh_flag[i-1][j  ] ),
          .bottom_flag_i (    rcs_mesh_flag[i+1][j  ] ),
          .result_o      (          rcs_res[i  ][j  ] ),
          .flag_o        (         rcs_flag[i  ][j  ] ),
          .br_req_o      (       rcs_br_req[i  ][j  ] ),
          .br_add_o      (       rcs_br_add[i  ][j  ] ),
          .data_req_o    (       data_req_s[i  ][j  ] ),
          .data_wen_o    (       data_wen_s[i  ][j  ] ),
          .data_ind_o    (       data_ind_s[i  ][j  ] ),
          .data_add_o    (       data_add_s[i  ][j  ] ),
          .data_wdata_o  (     data_wdata_s[i  ][j  ] ),
          .add_inc_o     (        add_inc_s[i  ][j  ] ),
          .rc_stall_o    (      rcs_stall_s[i  ][j  ] ),
          .rc_nop_o      (        rcs_nop_s[i  ][j  ] ),
          .exec_end_o    (       rcs_ex_end[i  ][j  ] )
        );
      end
    end
  endgenerate

endmodule
