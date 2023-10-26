#
# CGRA Functionality test instructions
#

ker_col_needed = 4
ker_num_instr  = 32

ker_conf_words[ker_next_id] = get_bin(int(pow(2,ker_col_needed))-1,CGRA_N_COL) +\
                                get_bin(ker_start_add, CGRA_IMEM_NL_LOG2) +\
                                get_bin(ker_num_instr-1, RCS_NUM_CREG_LOG2)

# Save current start address
start_add     = ker_start_add
# Update start address and ID for next kernel
ker_start_add = ker_start_add + ker_num_instr*ker_col_needed
ker_next_id   = ker_next_id+1

# Used for multi-column kernels
k = ker_num_instr

#################################################################################################
############################################## RC0 ##############################################
#################################################################################################

# COLUMN-0
rcs_instructions[0][start_add+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "-"]
rcs_instructions[0][start_add+ 1] = [   "-",    "-",    "LWD", "R1",    "-", "-"]
rcs_instructions[0][start_add+ 2] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+ 3] = [ "RCB",   "R2",   "SADD", "R2",    "-", "-"]
rcs_instructions[0][start_add+ 4] = [  "R2",  "RCT",   "SSUB", "R3",    "-", "-"]
rcs_instructions[0][start_add+ 5] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[0][start_add+ 6] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+ 7] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+ 8] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[0][start_add+ 9] = [ "IMM",   "R2",   "SMUL", "R2",    "-", "144"]
rcs_instructions[0][start_add+10] = [ "RCT", "SELF", "FXPMUL", "R3",    "-", "-"]
rcs_instructions[0][start_add+11] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[0][start_add+12] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+13] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+14] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[0][start_add+15] = [  "R3",   "R2",    "SRT", "R2",    "-", "-"]
rcs_instructions[0][start_add+16] = [  "R2",  "IMM",    "SLT", "R3",    "-", "2"]
rcs_instructions[0][start_add+17] = ["ZERO",  "IMM",   "SADD", "R2",    "-", "-16"]
rcs_instructions[0][start_add+18] = [  "R2",  "IMM",    "SRA", "R2",    "-", "3"]
rcs_instructions[0][start_add+19] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+20] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[0][start_add+21] = [  "R2",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+22] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[0][start_add+23] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[0][start_add+24] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+25] = ["ZERO",  "IMM",   "BSFA", "R2", "SELF", "-1"]
rcs_instructions[0][start_add+26] = [  "R3",  "IMM",   "BZFA", "R3",  "RCB",  "1"]
rcs_instructions[0][start_add+27] = rcs_nop_instr
rcs_instructions[0][start_add+28] = [ "IMM", "ZERO",   "SADD", "R3",  "RCB", "-7"] # move
rcs_instructions[0][start_add+29] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+30] = rcs_nop_instr
rcs_instructions[0][start_add+31] = [   "-",    "-",   "EXIT",  "-",    "-", "-"]

# COLUMN-1
rcs_instructions[0][start_add+k+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "-"]
rcs_instructions[0][start_add+k+ 1] = [   "-",    "-",    "LWD", "R1",    "-", "-"]
rcs_instructions[0][start_add+k+ 2] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+k+ 3] = [ "RCB",   "R2",   "SADD", "R2",    "-", "-"]
rcs_instructions[0][start_add+k+ 4] = [  "R2",  "RCT",   "SSUB", "R3",    "-", "-"]
rcs_instructions[0][start_add+k+ 5] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[0][start_add+k+ 6] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+k+ 7] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+k+ 8] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[0][start_add+k+ 9] = [ "IMM",   "R2",   "SMUL", "R2",    "-", "144"]
rcs_instructions[0][start_add+k+10] = [ "RCT", "SELF", "FXPMUL", "R3",    "-", "-"]
rcs_instructions[0][start_add+k+11] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[0][start_add+k+12] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+k+13] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+k+14] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[0][start_add+k+15] = [  "R3",   "R2",    "SRT", "R2",    "-", "-"]
rcs_instructions[0][start_add+k+16] = [  "R2",  "IMM",    "SLT", "R3",    "-", "2"]
rcs_instructions[0][start_add+k+17] = ["ZERO",  "IMM",   "SADD", "R2",    "-", "-16"]
rcs_instructions[0][start_add+k+18] = [  "R2",  "IMM",    "SRA", "R2",    "-", "3"]
rcs_instructions[0][start_add+k+19] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+k+20] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[0][start_add+k+21] = [  "R2",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+k+22] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[0][start_add+k+23] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[0][start_add+k+24] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+k+25] = ["ZERO",  "IMM",   "BSFA", "R2", "SELF", "-1"]
rcs_instructions[0][start_add+k+26] = [  "R3",  "IMM",   "BZFA", "R3",  "RCB",  "1"]
rcs_instructions[0][start_add+k+27] = rcs_nop_instr
rcs_instructions[0][start_add+k+28] = [ "IMM", "ZERO",   "SADD", "R3",  "RCB", "-7"] # move
rcs_instructions[0][start_add+k+29] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+k+30] = rcs_nop_instr
rcs_instructions[0][start_add+k+31] = [ "IMM", "ZERO",   "SADD", "R3",    "-", "-13"] # move

# COLUMN-2
rcs_instructions[0][start_add+2*k+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "-"]
rcs_instructions[0][start_add+2*k+ 1] = [   "-",    "-",    "LWD", "R1",    "-", "-"]
rcs_instructions[0][start_add+2*k+ 2] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+2*k+ 3] = [ "RCB",   "R2",   "SADD", "R2",    "-", "-"]
rcs_instructions[0][start_add+2*k+ 4] = [  "R2",  "RCT",   "SSUB", "R3",    "-", "-"]
rcs_instructions[0][start_add+2*k+ 5] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[0][start_add+2*k+ 6] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+2*k+ 7] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+2*k+ 8] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[0][start_add+2*k+ 9] = [ "IMM",   "R2",   "SMUL", "R2",    "-", "144"]
rcs_instructions[0][start_add+2*k+10] = [ "RCT", "SELF", "FXPMUL", "R3",    "-", "-"]
rcs_instructions[0][start_add+2*k+11] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[0][start_add+2*k+12] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+2*k+13] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+2*k+14] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[0][start_add+2*k+15] = [  "R3",   "R2",    "SRT", "R2",    "-", "-"]
rcs_instructions[0][start_add+2*k+16] = [  "R2",  "IMM",    "SLT", "R3",    "-", "2"]
rcs_instructions[0][start_add+2*k+17] = ["ZERO",  "IMM",   "SADD", "R2",    "-", "-16"]
rcs_instructions[0][start_add+2*k+18] = [  "R2",  "IMM",    "SRA", "R2",    "-", "3"]
rcs_instructions[0][start_add+2*k+19] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+2*k+20] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[0][start_add+2*k+21] = [  "R2",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+2*k+22] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[0][start_add+2*k+23] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[0][start_add+2*k+24] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+2*k+25] = ["ZERO",  "IMM",   "BSFA", "R2", "SELF", "-1"]
rcs_instructions[0][start_add+2*k+26] = [  "R3",  "IMM",   "BZFA", "R3",  "RCB",  "1"]
rcs_instructions[0][start_add+2*k+27] = rcs_nop_instr
rcs_instructions[0][start_add+2*k+28] = [ "IMM", "ZERO",   "SADD", "R3",  "RCB", "-7"] # move
rcs_instructions[0][start_add+2*k+29] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+2*k+30] = rcs_nop_instr
rcs_instructions[0][start_add+2*k+31] = rcs_nop_instr

# COLUMN-3
rcs_instructions[0][start_add+3*k+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "-"]
rcs_instructions[0][start_add+3*k+ 1] = [   "-",    "-",    "LWD", "R1",    "-", "-"]
rcs_instructions[0][start_add+3*k+ 2] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+3*k+ 3] = [ "RCB",   "R2",   "SADD", "R2",    "-", "-"]
rcs_instructions[0][start_add+3*k+ 4] = [  "R2",  "RCT",   "SSUB", "R3",    "-", "-"]
rcs_instructions[0][start_add+3*k+ 5] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[0][start_add+3*k+ 6] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+3*k+ 7] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+3*k+ 8] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[0][start_add+3*k+ 9] = [ "IMM",   "R2",   "SMUL", "R2",    "-", "144"]
rcs_instructions[0][start_add+3*k+10] = [ "RCT", "SELF", "FXPMUL", "R3",    "-", "-"]
rcs_instructions[0][start_add+3*k+11] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[0][start_add+3*k+12] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+3*k+13] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+3*k+14] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[0][start_add+3*k+15] = [  "R3",   "R2",    "SRT", "R2",    "-", "-"]
rcs_instructions[0][start_add+3*k+16] = [  "R2",  "IMM",    "SLT", "R3",    "-", "2"]
rcs_instructions[0][start_add+3*k+17] = ["ZERO",  "IMM",   "SADD", "R2",    "-", "-16"]
rcs_instructions[0][start_add+3*k+18] = [  "R2",  "IMM",    "SRA", "R2",    "-", "3"]
rcs_instructions[0][start_add+3*k+19] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+3*k+20] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[0][start_add+3*k+21] = [  "R2",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+3*k+22] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[0][start_add+3*k+23] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[0][start_add+3*k+24] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+3*k+25] = ["ZERO",  "IMM",   "BSFA", "R2", "SELF", "-1"]
rcs_instructions[0][start_add+3*k+26] = [  "R3",  "IMM",   "BZFA", "R3",  "RCB",  "1"]
rcs_instructions[0][start_add+3*k+27] = rcs_nop_instr
rcs_instructions[0][start_add+3*k+28] = [ "IMM", "ZERO",   "SADD", "R3",  "RCB", "-7"] # move
rcs_instructions[0][start_add+3*k+29] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+3*k+30] = rcs_nop_instr
rcs_instructions[0][start_add+3*k+31] = rcs_nop_instr


#################################################################################################
############################################## RC1 ##############################################
#################################################################################################

# COLUMN-0
rcs_instructions[1][start_add+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "-"]
rcs_instructions[1][start_add+ 1] = [   "-",    "-",    "LWD", "R1",    "-", "-"]
rcs_instructions[1][start_add+ 2] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+ 3] = [ "RCB",   "R2",   "SADD", "R2",    "-", "-"]
rcs_instructions[1][start_add+ 4] = [  "R2",  "RCT",   "SSUB", "R3",    "-", "-"]
rcs_instructions[1][start_add+ 5] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[1][start_add+ 7] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+ 6] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+ 8] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[1][start_add+ 9] = [ "IMM",   "R2",   "SMUL", "R2",    "-", "-12"]
rcs_instructions[1][start_add+10] = [ "RCT", "SELF", "FXPMUL", "R3",    "-", "-"]
rcs_instructions[1][start_add+11] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[1][start_add+12] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+13] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+14] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[1][start_add+15] = [  "R3",   "R2",    "SRT", "R2",    "-", "-"]
rcs_instructions[1][start_add+16] = [  "R2",  "IMM",    "SLT", "R3",    "-", "2"]
rcs_instructions[1][start_add+17] = ["ZERO",  "IMM",   "SADD", "R2",    "-", "32"]
rcs_instructions[1][start_add+18] = [  "R2",  "IMM",    "SRA", "R2",    "-", "2"]
rcs_instructions[1][start_add+19] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+20] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[1][start_add+21] = [  "R2",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+22] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[1][start_add+23] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[1][start_add+24] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+25] = ["ZERO",  "IMM",   "BZFA", "R2", "SELF", "-1"]
rcs_instructions[1][start_add+26] = [  "R3",  "IMM",   "BSFA", "R3",  "RCB",  "1"]
rcs_instructions[1][start_add+27] = rcs_nop_instr
rcs_instructions[1][start_add+28] = [ "IMM", "ZERO",   "SADD", "R3",  "RCB", "-7"] # move
rcs_instructions[1][start_add+29] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+30] = rcs_nop_instr
rcs_instructions[1][start_add+31] = rcs_nop_instr

# COLUMN-1
rcs_instructions[1][start_add+k+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "-"]
rcs_instructions[1][start_add+k+ 1] = [   "-",    "-",    "LWD", "R1",    "-", "-"]
rcs_instructions[1][start_add+k+ 2] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+k+ 3] = [ "RCB",   "R2",   "SADD", "R2",    "-", "-"]
rcs_instructions[1][start_add+k+ 4] = [  "R2",  "RCT",   "SSUB", "R3",    "-", "-"]
rcs_instructions[1][start_add+k+ 5] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[1][start_add+k+ 7] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+k+ 6] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+k+ 8] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[1][start_add+k+ 9] = [ "IMM",   "R2",   "SMUL", "R2",    "-", "-12"]
rcs_instructions[1][start_add+k+10] = [ "RCT", "SELF", "FXPMUL", "R3",    "-", "-"]
rcs_instructions[1][start_add+k+11] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[1][start_add+k+12] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+k+13] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+k+14] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[1][start_add+k+15] = [  "R3",   "R2",    "SRT", "R2",    "-", "-"]
rcs_instructions[1][start_add+k+16] = [  "R2",  "IMM",    "SLT", "R3",    "-", "2"]
rcs_instructions[1][start_add+k+17] = ["ZERO",  "IMM",   "SADD", "R2",    "-", "32"]
rcs_instructions[1][start_add+k+18] = [  "R2",  "IMM",    "SRA", "R2",    "-", "2"]
rcs_instructions[1][start_add+k+19] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+k+20] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[1][start_add+k+21] = [  "R2",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+k+22] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[1][start_add+k+23] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[1][start_add+k+24] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+k+25] = ["ZERO",  "IMM",   "BZFA", "R2", "SELF", "-1"]
rcs_instructions[1][start_add+k+26] = [  "R3",  "IMM",   "BSFA", "R3",  "RCB",  "1"]
rcs_instructions[1][start_add+k+27] = rcs_nop_instr
rcs_instructions[1][start_add+k+28] = [ "IMM", "ZERO",   "SADD", "R3",  "RCB", "-7"] # move
rcs_instructions[1][start_add+k+29] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+k+30] = rcs_nop_instr
rcs_instructions[1][start_add+k+31] = rcs_nop_instr

# COLUMN-2
rcs_instructions[1][start_add+2*k+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "-"]
rcs_instructions[1][start_add+2*k+ 1] = [   "-",    "-",    "LWD", "R1",    "-", "-"]
rcs_instructions[1][start_add+2*k+ 2] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+2*k+ 3] = [ "RCB",   "R2",   "SADD", "R2",    "-", "-"]
rcs_instructions[1][start_add+2*k+ 4] = [  "R2",  "RCT",   "SSUB", "R3",    "-", "-"]
rcs_instructions[1][start_add+2*k+ 5] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[1][start_add+2*k+ 7] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+2*k+ 6] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+2*k+ 8] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[1][start_add+2*k+ 9] = [ "IMM",   "R2",   "SMUL", "R2",    "-", "-12"]
rcs_instructions[1][start_add+2*k+10] = [ "RCT", "SELF", "FXPMUL", "R3",    "-", "-"]
rcs_instructions[1][start_add+2*k+11] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[1][start_add+2*k+12] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+2*k+13] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+2*k+14] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[1][start_add+2*k+15] = [  "R3",   "R2",    "SRT", "R2",    "-", "-"]
rcs_instructions[1][start_add+2*k+16] = [  "R2",  "IMM",    "SLT", "R3",    "-", "2"]
rcs_instructions[1][start_add+2*k+17] = ["ZERO",  "IMM",   "SADD", "R2",    "-", "32"]
rcs_instructions[1][start_add+2*k+18] = [  "R2",  "IMM",    "SRA", "R2",    "-", "2"]
rcs_instructions[1][start_add+2*k+19] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+2*k+20] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[1][start_add+2*k+21] = [  "R2",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+2*k+22] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[1][start_add+2*k+23] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[1][start_add+2*k+24] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+2*k+25] = ["ZERO",  "IMM",   "BZFA", "R2", "SELF", "-1"]
rcs_instructions[1][start_add+2*k+26] = [  "R3",  "IMM",   "BSFA", "R3",  "RCB",  "1"]
rcs_instructions[1][start_add+2*k+27] = rcs_nop_instr
rcs_instructions[1][start_add+2*k+28] = [ "IMM", "ZERO",   "SADD", "R3",  "RCB", "-7"] # move
rcs_instructions[1][start_add+2*k+29] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+2*k+30] = rcs_nop_instr
rcs_instructions[1][start_add+2*k+31] = rcs_nop_instr

# COLUMN-3
rcs_instructions[1][start_add+3*k+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "-"]
rcs_instructions[1][start_add+3*k+ 1] = [   "-",    "-",    "LWD", "R1",    "-", "-"]
rcs_instructions[1][start_add+3*k+ 2] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+3*k+ 3] = [ "RCB",   "R2",   "SADD", "R2",    "-", "-"]
rcs_instructions[1][start_add+3*k+ 4] = [  "R2",  "RCT",   "SSUB", "R3",    "-", "-"]
rcs_instructions[1][start_add+3*k+ 5] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[1][start_add+3*k+ 7] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+3*k+ 6] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+3*k+ 8] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[1][start_add+3*k+ 9] = [ "IMM",   "R2",   "SMUL", "R2",    "-", "-12"]
rcs_instructions[1][start_add+3*k+10] = [ "RCT", "SELF", "FXPMUL", "R3",    "-", "-"]
rcs_instructions[1][start_add+3*k+11] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[1][start_add+3*k+12] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+3*k+13] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+3*k+14] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[1][start_add+3*k+15] = [  "R3",   "R2",    "SRT", "R2",    "-", "-"]
rcs_instructions[1][start_add+3*k+16] = [  "R2",  "IMM",    "SLT", "R3",    "-", "2"]
rcs_instructions[1][start_add+3*k+17] = ["ZERO",  "IMM",   "SADD", "R2",    "-", "32"]
rcs_instructions[1][start_add+3*k+18] = [  "R2",  "IMM",    "SRA", "R2",    "-", "2"]
rcs_instructions[1][start_add+3*k+19] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+3*k+20] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[1][start_add+3*k+21] = [  "R2",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+3*k+22] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[1][start_add+3*k+23] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[1][start_add+3*k+24] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+3*k+25] = ["ZERO",  "IMM",   "BZFA", "R2", "SELF", "-1"]
rcs_instructions[1][start_add+3*k+26] = [  "R3",  "IMM",   "BSFA", "R3",  "RCB",  "1"]
rcs_instructions[1][start_add+3*k+27] = rcs_nop_instr
rcs_instructions[1][start_add+3*k+28] = [ "IMM", "ZERO",   "SADD", "R3",  "RCB", "-7"] # move
rcs_instructions[1][start_add+3*k+29] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+3*k+30] = rcs_nop_instr
rcs_instructions[1][start_add+3*k+31] = rcs_nop_instr

#################################################################################################
############################################## RC2 ##############################################
#################################################################################################

# COLUMN-0
rcs_instructions[2][start_add+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "-"]
rcs_instructions[2][start_add+ 1] = [   "-",    "-",    "LWD", "R1",    "-", "-"]
rcs_instructions[2][start_add+ 2] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[2][start_add+ 3] = [ "RCB",   "R2",   "SADD", "R2",    "-", "-"]
rcs_instructions[2][start_add+ 4] = [  "R2",  "RCT",   "SSUB", "R3",    "-", "-"]
rcs_instructions[2][start_add+ 5] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[2][start_add+ 6] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[2][start_add+ 7] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+ 8] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[2][start_add+ 9] = [ "IMM",   "R2",   "SMUL", "R2",    "-", "1033"]
rcs_instructions[2][start_add+10] = [ "RCT", "SELF", "FXPMUL", "R3",    "-", "-"]
rcs_instructions[2][start_add+11] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[2][start_add+13] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+12] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[2][start_add+14] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[2][start_add+15] = [  "R3",   "R2",    "SRT", "R2",    "-", "-"]
rcs_instructions[2][start_add+16] = [  "R2",  "IMM",    "SLT", "R3",    "-", "2"]
rcs_instructions[2][start_add+17] = ["ZERO",  "IMM",   "SADD", "R2",    "-", "1854"]
rcs_instructions[2][start_add+18] = [  "R2",  "IMM",    "SRA", "R2",    "-", "0"]
rcs_instructions[2][start_add+19] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+20] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[2][start_add+21] = [  "R2",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+22] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[2][start_add+23] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[2][start_add+24] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[2][start_add+25] = ["ZERO",  "IMM",   "BSFA", "R2", "SELF", "-1"]
rcs_instructions[2][start_add+26] = [  "R3",  "IMM",   "BZFA", "R3",  "RCB",  "1"]
rcs_instructions[2][start_add+27] = rcs_nop_instr
rcs_instructions[2][start_add+28] = [ "IMM", "ZERO",   "SADD", "R3",  "RCB", "-7"] # move
rcs_instructions[2][start_add+29] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+30] = rcs_nop_instr
rcs_instructions[2][start_add+31] = rcs_nop_instr

# COLUMN-1
rcs_instructions[2][start_add+k+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "-"]
rcs_instructions[2][start_add+k+ 1] = [   "-",    "-",    "LWD", "R1",    "-", "-"]
rcs_instructions[2][start_add+k+ 2] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[2][start_add+k+ 3] = [ "RCB",   "R2",   "SADD", "R2",    "-", "-"]
rcs_instructions[2][start_add+k+ 4] = [  "R2",  "RCT",   "SSUB", "R3",    "-", "-"]
rcs_instructions[2][start_add+k+ 5] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[2][start_add+k+ 6] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[2][start_add+k+ 7] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+k+ 8] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[2][start_add+k+ 9] = [ "IMM",   "R2",   "SMUL", "R2",    "-", "1033"]
rcs_instructions[2][start_add+k+10] = [ "RCT", "SELF", "FXPMUL", "R3",    "-", "-"]
rcs_instructions[2][start_add+k+11] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[2][start_add+k+13] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+k+12] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[2][start_add+k+14] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[2][start_add+k+15] = [  "R3",   "R2",    "SRT", "R2",    "-", "-"]
rcs_instructions[2][start_add+k+16] = [  "R2",  "IMM",    "SLT", "R3",    "-", "2"]
rcs_instructions[2][start_add+k+17] = ["ZERO",  "IMM",   "SADD", "R2",    "-", "1854"]
rcs_instructions[2][start_add+k+18] = [  "R2",  "IMM",    "SRA", "R2",    "-", "0"]
rcs_instructions[2][start_add+k+19] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+k+20] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[2][start_add+k+21] = [  "R2",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+k+22] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[2][start_add+k+23] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[2][start_add+k+24] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[2][start_add+k+25] = ["ZERO",  "IMM",   "BSFA", "R2", "SELF", "-1"]
rcs_instructions[2][start_add+k+26] = [  "R3",  "IMM",   "BZFA", "R3",  "RCB",  "1"]
rcs_instructions[2][start_add+k+27] = rcs_nop_instr
rcs_instructions[2][start_add+k+28] = [ "IMM", "ZERO",   "SADD", "R3",  "RCB", "-7"] # move
rcs_instructions[2][start_add+k+29] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+k+30] = rcs_nop_instr
rcs_instructions[2][start_add+k+31] = rcs_nop_instr

# COLUMN-2
rcs_instructions[2][start_add+2*k+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "-"]
rcs_instructions[2][start_add+2*k+ 1] = [   "-",    "-",    "LWD", "R1",    "-", "-"]
rcs_instructions[2][start_add+2*k+ 2] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[2][start_add+2*k+ 3] = [ "RCB",   "R2",   "SADD", "R2",    "-", "-"]
rcs_instructions[2][start_add+2*k+ 4] = [  "R2",  "RCT",   "SSUB", "R3",    "-", "-"]
rcs_instructions[2][start_add+2*k+ 5] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[2][start_add+2*k+ 6] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[2][start_add+2*k+ 7] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+2*k+ 8] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[2][start_add+2*k+ 9] = [ "IMM",   "R2",   "SMUL", "R2",    "-", "1033"]
rcs_instructions[2][start_add+2*k+10] = [ "RCT", "SELF", "FXPMUL", "R3",    "-", "-"]
rcs_instructions[2][start_add+2*k+11] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[2][start_add+2*k+13] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+2*k+12] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[2][start_add+2*k+14] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[2][start_add+2*k+15] = [  "R3",   "R2",    "SRT", "R2",    "-", "-"]
rcs_instructions[2][start_add+2*k+16] = [  "R2",  "IMM",    "SLT", "R3",    "-", "2"]
rcs_instructions[2][start_add+2*k+17] = ["ZERO",  "IMM",   "SADD", "R2",    "-", "1854"]
rcs_instructions[2][start_add+2*k+18] = [  "R2",  "IMM",    "SRA", "R2",    "-", "0"]
rcs_instructions[2][start_add+2*k+19] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+2*k+20] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[2][start_add+2*k+21] = [  "R2",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+2*k+22] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[2][start_add+2*k+23] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[2][start_add+2*k+24] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[2][start_add+2*k+25] = ["ZERO",  "IMM",   "BSFA", "R2", "SELF", "-1"]
rcs_instructions[2][start_add+2*k+26] = [  "R3",  "IMM",   "BZFA", "R3",  "RCB",  "1"]
rcs_instructions[2][start_add+2*k+27] = rcs_nop_instr
rcs_instructions[2][start_add+2*k+28] = [ "IMM", "ZERO",   "SADD", "R3",  "RCB", "-7"] # move
rcs_instructions[2][start_add+2*k+29] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+2*k+30] = rcs_nop_instr
rcs_instructions[2][start_add+2*k+31] = rcs_nop_instr

# COLUMN-3
rcs_instructions[2][start_add+3*k+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "-"]
rcs_instructions[2][start_add+3*k+ 1] = [   "-",    "-",    "LWD", "R1",    "-", "-"]
rcs_instructions[2][start_add+3*k+ 2] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[2][start_add+3*k+ 3] = [ "RCB",   "R2",   "SADD", "R2",    "-", "-"]
rcs_instructions[2][start_add+3*k+ 4] = [  "R2",  "RCT",   "SSUB", "R3",    "-", "-"]
rcs_instructions[2][start_add+3*k+ 5] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[2][start_add+3*k+ 6] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[2][start_add+3*k+ 7] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+3*k+ 8] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[2][start_add+3*k+ 9] = [ "IMM",   "R2",   "SMUL", "R2",    "-", "1033"]
rcs_instructions[2][start_add+3*k+10] = [ "RCT", "SELF", "FXPMUL", "R3",    "-", "-"]
rcs_instructions[2][start_add+3*k+11] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[2][start_add+3*k+13] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+3*k+12] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[2][start_add+3*k+14] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[2][start_add+3*k+15] = [  "R3",   "R2",    "SRT", "R2",    "-", "-"]
rcs_instructions[2][start_add+3*k+16] = [  "R2",  "IMM",    "SLT", "R3",    "-", "2"]
rcs_instructions[2][start_add+3*k+17] = ["ZERO",  "IMM",   "SADD", "R2",    "-", "1854"]
rcs_instructions[2][start_add+3*k+18] = [  "R2",  "IMM",    "SRA", "R2",    "-", "0"]
rcs_instructions[2][start_add+3*k+19] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+3*k+20] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[2][start_add+3*k+21] = [  "R2",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+3*k+22] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[2][start_add+3*k+23] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[2][start_add+3*k+24] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[2][start_add+3*k+25] = ["ZERO",  "IMM",   "BSFA", "R2", "SELF", "-1"]
rcs_instructions[2][start_add+3*k+26] = [  "R3",  "IMM",   "BZFA", "R3",  "RCB",  "1"]
rcs_instructions[2][start_add+3*k+27] = rcs_nop_instr
rcs_instructions[2][start_add+3*k+28] = [ "IMM", "ZERO",   "SADD", "R3",  "RCB", "-7"] # move
rcs_instructions[2][start_add+3*k+29] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+3*k+30] = rcs_nop_instr
rcs_instructions[2][start_add+3*k+31] = rcs_nop_instr

#################################################################################################
############################################## RC3 ##############################################
#################################################################################################

# COLUMN-0
rcs_instructions[3][start_add+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "-"]
rcs_instructions[3][start_add+ 1] = [   "-",    "-",    "LWD", "R1",    "-", "-"]
rcs_instructions[3][start_add+ 2] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[3][start_add+ 3] = [ "RCB",   "R2",   "SADD", "R2",    "-", "-"]
rcs_instructions[3][start_add+ 4] = [  "R2",  "RCT",   "SSUB", "R3",    "-", "-"]
rcs_instructions[3][start_add+ 5] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[3][start_add+ 7] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+ 6] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[3][start_add+ 8] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[3][start_add+ 9] = [ "IMM",   "R2",   "SMUL", "R2",    "-", "-199"]
rcs_instructions[3][start_add+10] = [ "RCT", "SELF", "FXPMUL", "R3",    "-", "-"]
rcs_instructions[3][start_add+11] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[3][start_add+12] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[3][start_add+13] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+14] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[3][start_add+15] = [  "R3",   "R2",    "SRT", "R2",    "-", "-"]
rcs_instructions[3][start_add+16] = [  "R2",  "IMM",    "SLT", "R3",    "-", "2"]
rcs_instructions[3][start_add+17] = ["ZERO",  "IMM",   "SADD", "R2",    "-", "-4096"]
rcs_instructions[3][start_add+18] = [  "R2",  "IMM",    "SRA", "R2",    "-", "1"]
rcs_instructions[3][start_add+19] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+20] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[3][start_add+21] = [  "R2",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+22] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[3][start_add+23] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[3][start_add+24] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[3][start_add+25] = ["ZERO",  "IMM",   "BZFA", "R2", "SELF", "-1"]
rcs_instructions[3][start_add+26] = [  "R3",  "IMM",   "BSFA", "R3",  "RCB",  "1"]
rcs_instructions[3][start_add+27] = ["ZERO",  "IMM",   "JUMP",  "-",    "-", "29"]
rcs_instructions[3][start_add+28] = [ "IMM", "ZERO",   "SADD", "R3",  "RCB", "-7"] # move
rcs_instructions[3][start_add+29] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+30] = rcs_nop_instr
rcs_instructions[3][start_add+31] = rcs_nop_instr

# COLUMN-1
rcs_instructions[3][start_add+k+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "-"]
rcs_instructions[3][start_add+k+ 1] = [   "-",    "-",    "LWD", "R1",    "-", "-"]
rcs_instructions[3][start_add+k+ 2] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[3][start_add+k+ 3] = [ "RCB",   "R2",   "SADD", "R2",    "-", "-"]
rcs_instructions[3][start_add+k+ 4] = [  "R2",  "RCT",   "SSUB", "R3",    "-", "-"]
rcs_instructions[3][start_add+k+ 5] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[3][start_add+k+ 7] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+k+ 6] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[3][start_add+k+ 8] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[3][start_add+k+ 9] = [ "IMM",   "R2",   "SMUL", "R2",    "-", "-199"]
rcs_instructions[3][start_add+k+10] = [ "RCT", "SELF", "FXPMUL", "R3",    "-", "-"]
rcs_instructions[3][start_add+k+11] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[3][start_add+k+12] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[3][start_add+k+13] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+k+14] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[3][start_add+k+15] = [  "R3",   "R2",    "SRT", "R2",    "-", "-"]
rcs_instructions[3][start_add+k+16] = [  "R2",  "IMM",    "SLT", "R3",    "-", "2"]
rcs_instructions[3][start_add+k+17] = ["ZERO",  "IMM",   "SADD", "R2",    "-", "-4096"]
rcs_instructions[3][start_add+k+18] = [  "R2",  "IMM",    "SRA", "R2",    "-", "1"]
rcs_instructions[3][start_add+k+19] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+k+20] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[3][start_add+k+21] = [  "R2",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+k+22] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[3][start_add+k+23] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[3][start_add+k+24] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[3][start_add+k+25] = ["ZERO",  "IMM",   "BZFA", "R2", "SELF", "-1"]
rcs_instructions[3][start_add+k+26] = [  "R3",  "IMM",   "BSFA", "R3",  "RCB",  "1"]
rcs_instructions[3][start_add+k+27] = rcs_nop_instr
rcs_instructions[3][start_add+k+28] = [ "IMM", "ZERO",   "SADD", "R3",  "RCB", "-7"] # move
rcs_instructions[3][start_add+k+29] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+k+30] = rcs_nop_instr
rcs_instructions[3][start_add+k+31] = rcs_nop_instr

# COLUMN-2
rcs_instructions[3][start_add+2*k+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "-"]
rcs_instructions[3][start_add+2*k+ 1] = [   "-",    "-",    "LWD", "R1",    "-", "-"]
rcs_instructions[3][start_add+2*k+ 2] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[3][start_add+2*k+ 3] = [ "RCB",   "R2",   "SADD", "R2",    "-", "-"]
rcs_instructions[3][start_add+2*k+ 4] = [  "R2",  "RCT",   "SSUB", "R3",    "-", "-"]
rcs_instructions[3][start_add+2*k+ 5] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[3][start_add+2*k+ 7] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+2*k+ 6] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[3][start_add+2*k+ 8] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[3][start_add+2*k+ 9] = [ "IMM",   "R2",   "SMUL", "R2",    "-", "-199"]
rcs_instructions[3][start_add+2*k+10] = [ "RCT", "SELF", "FXPMUL", "R3",    "-", "-"]
rcs_instructions[3][start_add+2*k+11] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[3][start_add+2*k+12] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[3][start_add+2*k+13] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+2*k+14] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[3][start_add+2*k+15] = [  "R3",   "R2",    "SRT", "R2",    "-", "-"]
rcs_instructions[3][start_add+2*k+16] = [  "R2",  "IMM",    "SLT", "R3",    "-", "2"]
rcs_instructions[3][start_add+2*k+17] = ["ZERO",  "IMM",   "SADD", "R2",    "-", "-4096"]
rcs_instructions[3][start_add+2*k+18] = [  "R2",  "IMM",    "SRA", "R2",    "-", "1"]
rcs_instructions[3][start_add+2*k+19] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+2*k+20] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[3][start_add+2*k+21] = [  "R2",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+2*k+22] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[3][start_add+2*k+23] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[3][start_add+2*k+24] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[3][start_add+2*k+25] = ["ZERO",  "IMM",   "BZFA", "R2", "SELF", "-1"]
rcs_instructions[3][start_add+2*k+26] = [  "R3",  "IMM",   "BSFA", "R3",  "RCB",  "1"]
rcs_instructions[3][start_add+2*k+27] = rcs_nop_instr
rcs_instructions[3][start_add+2*k+28] = [ "IMM", "ZERO",   "SADD", "R3",  "RCB", "-7"] # move
rcs_instructions[3][start_add+2*k+29] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+2*k+30] = rcs_nop_instr
rcs_instructions[3][start_add+2*k+31] = rcs_nop_instr

# COLUMN-3
rcs_instructions[3][start_add+3*k+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "-"]
rcs_instructions[3][start_add+3*k+ 1] = [   "-",    "-",    "LWD", "R1",    "-", "-"]
rcs_instructions[3][start_add+3*k+ 2] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[3][start_add+3*k+ 3] = [ "RCB",   "R2",   "SADD", "R2",    "-", "-"]
rcs_instructions[3][start_add+3*k+ 4] = [  "R2",  "RCT",   "SSUB", "R3",    "-", "-"]
rcs_instructions[3][start_add+3*k+ 5] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[3][start_add+3*k+ 7] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+3*k+ 6] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[3][start_add+3*k+ 8] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[3][start_add+3*k+ 9] = [ "IMM",   "R2",   "SMUL", "R2",    "-", "-199"]
rcs_instructions[3][start_add+3*k+10] = [ "RCT", "SELF", "FXPMUL", "R3",    "-", "-"]
rcs_instructions[3][start_add+3*k+11] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[3][start_add+3*k+12] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[3][start_add+3*k+13] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+3*k+14] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[3][start_add+3*k+15] = [  "R3",   "R2",    "SRT", "R2",    "-", "-"]
rcs_instructions[3][start_add+3*k+16] = [  "R2",  "IMM",    "SLT", "R3",    "-", "2"]
rcs_instructions[3][start_add+3*k+17] = ["ZERO",  "IMM",   "SADD", "R2",    "-", "-4096"]
rcs_instructions[3][start_add+3*k+18] = [  "R2",  "IMM",    "SRA", "R2",    "-", "1"]
rcs_instructions[3][start_add+3*k+19] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+3*k+20] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[3][start_add+3*k+21] = [  "R2",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+3*k+22] = [  "R1",  "IMM",   "SADD", "R1",    "-", "4"]
rcs_instructions[3][start_add+3*k+23] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]
rcs_instructions[3][start_add+3*k+24] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[3][start_add+3*k+25] = ["ZERO",  "IMM",   "BZFA", "R2", "SELF", "-1"]
rcs_instructions[3][start_add+3*k+26] = [  "R3",  "IMM",   "BSFA", "R3",  "RCB",  "1"]
rcs_instructions[3][start_add+3*k+27] = rcs_nop_instr
rcs_instructions[3][start_add+3*k+28] = [ "IMM", "ZERO",   "SADD", "R3",  "RCB", "-7"] # move
rcs_instructions[3][start_add+3*k+29] = [  "R3",   "R1",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+3*k+30] = rcs_nop_instr
rcs_instructions[3][start_add+3*k+31] = rcs_nop_instr
