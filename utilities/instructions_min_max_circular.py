#
# MIN_MAX_CIRCULAR search instructions (manual mapping) DEPREDECATED
#

ker_col_needed = 1
ker_num_instr  = 10

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
rcs_instructions[0][start_add+ 1] = [ "RCB",  "IMM",  "SLT", "R3",      "-", "2"]
rcs_instructions[0][start_add+ 2] = [ "RCB",  "IMM",  "SLT", "R1",      "-", "2"]
rcs_instructions[0][start_add+ 3] = ["SRAM",    "-",  "LWD", "R0",      "-", "-"]
rcs_instructions[0][start_add+ 4] = [  "R0",   "R1", "SADD",  "-",      "-", "-"]
rcs_instructions[0][start_add+ 5] = [  "R1",  "IMM", "SADD",  "-",      "-", "4"]
rcs_instructions[0][start_add+ 6] = [  "R3", "PREV", "LAND", "R1",      "-", "-"]
rcs_instructions[0][start_add+ 7] = [  "R0",   "R1", "SADD",  "-",      "-", "-"]
rcs_instructions[0][start_add+ 8] = rcs_nop_instr
rcs_instructions[0][start_add+ 9] = rcs_nop_instr

#################################################################################################
############################################## RC1 ##############################################
#################################################################################################

# COLUMN-0
rcs_instructions[1][start_add+ 0] = ["SRAM",    "-",  "LWD",  "-",      "-", "-"]
rcs_instructions[1][start_add+ 1] = ["SRAM",    "-",  "LWD",  "-",      "-", "-"]
rcs_instructions[1][start_add+ 2] = ["SRAM",    "-",  "LWD", "R3",      "-", "-"]
rcs_instructions[1][start_add+ 3] = rcs_nop_instr
rcs_instructions[1][start_add+ 4] = rcs_nop_instr
rcs_instructions[1][start_add+ 5] = ["SRAM",  "RCT",  "LWI",  "-",      "-", "-"]
rcs_instructions[1][start_add+ 6] = [  "R0",  "IMM", "SADD", "R0",      "-", "1"]
rcs_instructions[1][start_add+ 7] = [  "R0",   "R3",  "BLT",  "-",      "-", "5"]
rcs_instructions[1][start_add+ 8] = rcs_nop_instr
rcs_instructions[1][start_add+ 9] = rcs_nop_instr

#################################################################################################
############################################## RC2 ##############################################
#################################################################################################

# COLUMN-0
rcs_instructions[2][start_add+ 0] = rcs_nop_instr
rcs_instructions[2][start_add+ 1] = rcs_nop_instr
rcs_instructions[2][start_add+ 2] = rcs_nop_instr
rcs_instructions[2][start_add+ 3] = rcs_nop_instr
rcs_instructions[2][start_add+ 4] = rcs_nop_instr
rcs_instructions[2][start_add+ 5] = ["SRAM",    "-",  "INA", "R1",      "-", "-"]
rcs_instructions[2][start_add+ 6] = [  "R0",   "R1", "SSUB",  "-",      "-", "-"]
rcs_instructions[2][start_add+ 7] = [  "R1",   "R0", "BSFA", "R0",   "PREV", "-"]
rcs_instructions[2][start_add+ 8] = [  "R0",    "-",  "SWD",  "-",      "-", "-"]
rcs_instructions[2][start_add+ 9] = [   "-",    "-", "EXIT",  "-",      "-", "-"]

#################################################################################################
############################################## RC03##############################################
#################################################################################################

# COLUMN-0
rcs_instructions[3][start_add+ 0] = rcs_nop_instr
rcs_instructions[3][start_add+ 1] = rcs_nop_instr
rcs_instructions[3][start_add+ 2] = rcs_nop_instr
rcs_instructions[3][start_add+ 3] = rcs_nop_instr
rcs_instructions[3][start_add+ 4] = rcs_nop_instr
rcs_instructions[3][start_add+ 5] = ["SRAM",    "-",  "INA", "R1",      "-", "-"]
rcs_instructions[3][start_add+ 6] = [  "R0",   "R1", "SSUB",  "-",      "-", "-"]
rcs_instructions[3][start_add+ 7] = [  "R0",   "R1", "BSFA", "R0",   "PREV", "-"]
rcs_instructions[3][start_add+ 8] = rcs_nop_instr
rcs_instructions[3][start_add+ 9] = [  "R0",    "-",  "SWD",  "-",      "-", "-"]
