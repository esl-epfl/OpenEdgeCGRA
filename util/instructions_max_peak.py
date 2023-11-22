#
# MAX_PEAK search instructions DEPREDECATED
#

ker_col_needed = 1
ker_num_instr  = 11

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
rcs_instructions[0][start_add+ 0] = rcs_nop_instr
rcs_instructions[0][start_add+ 1] = rcs_nop_instr
rcs_instructions[0][start_add+ 2] = ["SRAM",    "-",  "LWD", "R1",      "-", "-"]
rcs_instructions[0][start_add+ 3] = ["SRAM",    "-",  "LWD", "R0",      "-", "-"]
rcs_instructions[0][start_add+ 4] = rcs_nop_instr
rcs_instructions[0][start_add+ 5] = [  "R2",   "R1", "SSUB",  "-",      "-", "-"]
rcs_instructions[0][start_add+ 6] = [  "R1",   "R2", "BSFA",  "-",   "PREV", "-"]
rcs_instructions[0][start_add+ 7] = [  "R2", "PREV", "BSFA", "R2",    "RCB", "-"]
rcs_instructions[0][start_add+ 8] = [  "R0",    "-",  "INA", "R1",      "-", "-"]
rcs_instructions[0][start_add+ 9] = rcs_nop_instr
rcs_instructions[0][start_add+10] = [  "R2",    "-",  "SWD",  "-",      "-", "-"]

#################################################################################################
############################################## RC1 ##############################################
#################################################################################################

# COLUMN-0
rcs_instructions[1][start_add+ 0] = rcs_nop_instr
rcs_instructions[1][start_add+ 1] = ["SRAM",    "-",  "LWD", "R0",      "-", "-"]
rcs_instructions[1][start_add+ 2] = [   "-",  "IMM",  "INB", "R1",      "-", "-1"]
rcs_instructions[1][start_add+ 3] = [ "RCT",    "-",  "INA", "R3",      "-", "-"]
rcs_instructions[1][start_add+ 4] = [  "R3",   "R0", "SSUB",  "-",      "-", "-"]
rcs_instructions[1][start_add+ 5] = [  "R1",   "R2", "BSFA",  "-",   "PREV", "-"]
rcs_instructions[1][start_add+ 6] = [ "RCB", "PREV", "SADD",  "-",      "-", "-"]
rcs_instructions[1][start_add+ 7] = rcs_nop_instr
rcs_instructions[1][start_add+ 8] = [  "R3",    "-",  "INA", "R0",      "-", "-"]
rcs_instructions[1][start_add+ 9] = rcs_nop_instr
rcs_instructions[1][start_add+10] = rcs_nop_instr

#################################################################################################
############################################## RC2 ##############################################
#################################################################################################

# COLUMN-0
rcs_instructions[2][start_add+ 0] = rcs_nop_instr
rcs_instructions[2][start_add+ 1] = rcs_nop_instr
rcs_instructions[2][start_add+ 2] = [   "-",  "IMM",  "INB", "R1",      "-", "-1"]
rcs_instructions[2][start_add+ 3] = ["SRAM",    "-",  "INA",  "-",      "-", "-"]
rcs_instructions[2][start_add+ 4] = [ "RCB", "PREV", "SSUB",  "-",      "-", "-"]
rcs_instructions[2][start_add+ 5] = [  "R1",   "R2", "BSFA",  "-",   "PREV", "-"]
rcs_instructions[2][start_add+ 6] = [ "RCT", "PREV", "SADD",  "-",      "-", "-"]
rcs_instructions[2][start_add+ 7] = rcs_nop_instr
rcs_instructions[2][start_add+ 8] = rcs_nop_instr
rcs_instructions[2][start_add+ 9] = rcs_nop_instr
rcs_instructions[2][start_add+10] = [   "-",    "-", "EXIT",  "-",      "-", "-"]

#################################################################################################
############################################## RC3 ##############################################
#################################################################################################

# COLUMN-0
rcs_instructions[3][start_add+ 0] = ["SRAM",    "-",  "LWD", "R3",      "-", "-"]
rcs_instructions[3][start_add+ 1] = rcs_nop_instr
rcs_instructions[3][start_add+ 2] = ["SRAM",    "-",  "INA", "R1",      "-", "-"]
rcs_instructions[3][start_add+ 3] = [  "R1",    "-",  "INA",  "-",      "-", "-"]
rcs_instructions[3][start_add+ 4] = [ "RCB",    "-",  "INA", "R1",      "-", "-"]
rcs_instructions[3][start_add+ 5] = [  "R0",  "IMM", "SADD", "R0",      "-", "1"]
rcs_instructions[3][start_add+ 6] = [  "R0",   "R2", "BSFA",  "-",    "RCB", "-"]
rcs_instructions[3][start_add+ 7] = [  "R2", "PREV", "BSFA", "R2",    "RCT", "-"]
rcs_instructions[3][start_add+ 8] = [  "R0",   "R3",  "BLT",  "-",      "-", "3"]
rcs_instructions[3][start_add+ 9] = [  "R2",    "-",  "SWD",  "-",      "-", "-"]
rcs_instructions[3][start_add+10] = rcs_nop_instr
