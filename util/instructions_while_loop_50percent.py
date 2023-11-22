#
# CGRA never ending while loop for power measurement with 75% PE utilization (manual mapping)
#

ker_col_needed = 4
ker_num_instr  = 8

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
rcs_instructions[0][start_add+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "4"]
rcs_instructions[0][start_add+ 1] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+ 2] = ["ZERO",  "IMM",   "SADD", "R1",    "-", "123"]
rcs_instructions[0][start_add+ 3] = [ "RCB",   "R2",   "SMUL", "R2",    "-", "-"]
rcs_instructions[0][start_add+ 4] = [  "R2",   "R3",   "SADD", "R3",    "-", "-"]
rcs_instructions[0][start_add+ 5] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+ 6] = ["ZERO", "ZERO",    "BEQ",  "-",    "-", "3"]
rcs_instructions[0][start_add+ 7] = [   "-",    "-",   "EXIT",  "-",    "-", "-"]

# COLUMN-1
rcs_instructions[0][start_add+k+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "4"]
rcs_instructions[0][start_add+k+ 1] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+k+ 2] = ["ZERO",  "IMM",   "SADD", "R1",    "-", "123"]
rcs_instructions[0][start_add+k+ 3] = [ "RCT",   "R2",   "SMUL", "R2",    "-", "-"]
rcs_instructions[0][start_add+k+ 4] = [  "R2",   "R3",   "SADD", "R3",    "-", "-"]
rcs_instructions[0][start_add+k+ 5] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+k+ 6] = [  "R0",   "R2",   "LAND",  "-",    "-", "-"]
rcs_instructions[0][start_add+k+ 7] = rcs_nop_instr

# COLUMN-2
rcs_instructions[0][start_add+2*k+ 0] = rcs_nop_instr
rcs_instructions[0][start_add+2*k+ 1] = rcs_nop_instr
rcs_instructions[0][start_add+2*k+ 2] = rcs_nop_instr
rcs_instructions[0][start_add+2*k+ 3] = rcs_nop_instr
rcs_instructions[0][start_add+2*k+ 4] = rcs_nop_instr
rcs_instructions[0][start_add+2*k+ 5] = rcs_nop_instr
rcs_instructions[0][start_add+2*k+ 6] = rcs_nop_instr
rcs_instructions[0][start_add+2*k+ 7] = rcs_nop_instr

# COLUMN-3
rcs_instructions[0][start_add+3*k+ 0] = rcs_nop_instr
rcs_instructions[0][start_add+3*k+ 1] = rcs_nop_instr
rcs_instructions[0][start_add+3*k+ 2] = rcs_nop_instr
rcs_instructions[0][start_add+3*k+ 3] = rcs_nop_instr
rcs_instructions[0][start_add+3*k+ 4] = rcs_nop_instr
rcs_instructions[0][start_add+3*k+ 5] = rcs_nop_instr
rcs_instructions[0][start_add+3*k+ 6] = rcs_nop_instr
rcs_instructions[0][start_add+3*k+ 7] = rcs_nop_instr

#################################################################################################
############################################## RC1 ##############################################
#################################################################################################

# COLUMN-0
rcs_instructions[1][start_add+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "4"]
rcs_instructions[1][start_add+ 1] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+ 2] = ["ZERO",  "IMM",   "SADD", "R1",    "-", "123"]
rcs_instructions[1][start_add+ 3] = [ "RCB",   "R2",   "SMUL", "R2",    "-", "-"]
rcs_instructions[1][start_add+ 4] = [  "R2",   "R3",   "SADD", "R3",    "-", "-"]
rcs_instructions[1][start_add+ 5] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+ 6] = [  "R0",   "R2",   "LAND",  "-",    "-", "-"]
rcs_instructions[1][start_add+ 7] = rcs_nop_instr

# COLUMN-1
rcs_instructions[1][start_add+k+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "4"]
rcs_instructions[1][start_add+k+ 1] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+k+ 2] = ["ZERO",  "IMM",   "SADD", "R1",    "-", "123"]
rcs_instructions[1][start_add+k+ 3] = [ "RCT",   "R2",   "SMUL", "R2",    "-", "-"]
rcs_instructions[1][start_add+k+ 4] = [  "R2",   "R3",   "SADD", "R3",    "-", "-"]
rcs_instructions[1][start_add+k+ 5] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+k+ 6] = [  "R0",   "R2",   "LAND",  "-",    "-", "-"]
rcs_instructions[1][start_add+k+ 7] = rcs_nop_instr

# COLUMN-2
rcs_instructions[1][start_add+2*k+ 0] = rcs_nop_instr
rcs_instructions[1][start_add+2*k+ 1] = rcs_nop_instr
rcs_instructions[1][start_add+2*k+ 2] = rcs_nop_instr
rcs_instructions[1][start_add+2*k+ 3] = rcs_nop_instr
rcs_instructions[1][start_add+2*k+ 4] = rcs_nop_instr
rcs_instructions[1][start_add+2*k+ 5] = rcs_nop_instr
rcs_instructions[1][start_add+2*k+ 6] = rcs_nop_instr
rcs_instructions[1][start_add+2*k+ 7] = rcs_nop_instr

# COLUMN-3
rcs_instructions[1][start_add+3*k+ 0] = rcs_nop_instr
rcs_instructions[1][start_add+3*k+ 1] = rcs_nop_instr
rcs_instructions[1][start_add+3*k+ 2] = rcs_nop_instr
rcs_instructions[1][start_add+3*k+ 3] = rcs_nop_instr
rcs_instructions[1][start_add+3*k+ 4] = rcs_nop_instr
rcs_instructions[1][start_add+3*k+ 5] = rcs_nop_instr
rcs_instructions[1][start_add+3*k+ 6] = rcs_nop_instr
rcs_instructions[1][start_add+3*k+ 7] = rcs_nop_instr

#################################################################################################
############################################## RC2 ##############################################
#################################################################################################

# COLUMN-0
rcs_instructions[2][start_add+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "4"]
rcs_instructions[2][start_add+ 1] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[2][start_add+ 2] = ["ZERO",  "IMM",   "SADD", "R1",    "-", "123"]
rcs_instructions[2][start_add+ 3] = [ "RCB",   "R2",   "SMUL", "R2",    "-", "-"]
rcs_instructions[2][start_add+ 4] = [  "R2",   "R3",   "SADD", "R3",    "-", "-"]
rcs_instructions[2][start_add+ 5] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[2][start_add+ 6] = [  "R0",   "R2",   "LAND",  "-",    "-", "-"]
rcs_instructions[2][start_add+ 7] = rcs_nop_instr

# COLUMN-1
rcs_instructions[2][start_add+k+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "4"]
rcs_instructions[2][start_add+k+ 1] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[2][start_add+k+ 2] = ["ZERO",  "IMM",   "SADD", "R1",    "-", "123"]
rcs_instructions[2][start_add+k+ 3] = [ "RCT",   "R2",   "SMUL", "R2",    "-", "-"]
rcs_instructions[2][start_add+k+ 4] = [  "R2",   "R3",   "SADD", "R3",    "-", "-"]
rcs_instructions[2][start_add+k+ 5] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[2][start_add+k+ 6] = [  "R0",   "R2",   "LAND",  "-",    "-", "-"]
rcs_instructions[2][start_add+k+ 7] = rcs_nop_instr

# COLUMN-2
rcs_instructions[2][start_add+2*k+ 0] = rcs_nop_instr
rcs_instructions[2][start_add+2*k+ 1] = rcs_nop_instr
rcs_instructions[2][start_add+2*k+ 2] = rcs_nop_instr
rcs_instructions[2][start_add+2*k+ 3] = rcs_nop_instr
rcs_instructions[2][start_add+2*k+ 4] = rcs_nop_instr
rcs_instructions[2][start_add+2*k+ 5] = rcs_nop_instr
rcs_instructions[2][start_add+2*k+ 6] = rcs_nop_instr
rcs_instructions[2][start_add+2*k+ 7] = rcs_nop_instr

# COLUMN-3
rcs_instructions[2][start_add+3*k+ 0] = rcs_nop_instr
rcs_instructions[2][start_add+3*k+ 1] = rcs_nop_instr
rcs_instructions[2][start_add+3*k+ 2] = rcs_nop_instr
rcs_instructions[2][start_add+3*k+ 3] = rcs_nop_instr
rcs_instructions[2][start_add+3*k+ 4] = rcs_nop_instr
rcs_instructions[2][start_add+3*k+ 5] = rcs_nop_instr
rcs_instructions[2][start_add+3*k+ 6] = rcs_nop_instr
rcs_instructions[2][start_add+3*k+ 7] = rcs_nop_instr

#################################################################################################
############################################## RC3 ##############################################
#################################################################################################

# COLUMN-0
rcs_instructions[3][start_add+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "4"]
rcs_instructions[3][start_add+ 1] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[3][start_add+ 2] = ["ZERO",  "IMM",   "SADD", "R1",    "-", "123"]
rcs_instructions[3][start_add+ 3] = [ "RCB",   "R2",   "SMUL", "R2",    "-", "-"]
rcs_instructions[3][start_add+ 4] = [  "R2",   "R3",   "SADD", "R3",    "-", "-"]
rcs_instructions[3][start_add+ 5] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[3][start_add+ 6] = [  "R0",   "R2",   "LAND",  "-",    "-", "-"]
rcs_instructions[3][start_add+ 7] = rcs_nop_instr

# COLUMN-1
rcs_instructions[3][start_add+k+ 0] = [   "-",    "-",    "LWD", "R0",    "-", "4"]
rcs_instructions[3][start_add+k+ 1] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[3][start_add+k+ 2] = ["ZERO",  "IMM",   "SADD", "R1",    "-", "123"]
rcs_instructions[3][start_add+k+ 3] = [ "RCT",   "R2",   "SMUL", "R2",    "-", "-"]
rcs_instructions[3][start_add+k+ 4] = [  "R2",   "R3",   "SADD", "R3",    "-", "-"]
rcs_instructions[3][start_add+k+ 5] = [   "-",   "R0",    "LWI", "R2",    "-", "-"]
rcs_instructions[3][start_add+k+ 6] = [  "R0",   "R2",   "LAND",  "-",    "-", "-"]
rcs_instructions[3][start_add+k+ 7] = rcs_nop_instr

# COLUMN-2
rcs_instructions[3][start_add+2*k+ 0] = rcs_nop_instr
rcs_instructions[3][start_add+2*k+ 1] = rcs_nop_instr
rcs_instructions[3][start_add+2*k+ 2] = rcs_nop_instr
rcs_instructions[3][start_add+2*k+ 3] = rcs_nop_instr
rcs_instructions[3][start_add+2*k+ 4] = rcs_nop_instr
rcs_instructions[3][start_add+2*k+ 5] = rcs_nop_instr
rcs_instructions[3][start_add+2*k+ 6] = rcs_nop_instr
rcs_instructions[3][start_add+2*k+ 7] = rcs_nop_instr


# COLUMN-3
rcs_instructions[3][start_add+3*k+ 0] = rcs_nop_instr
rcs_instructions[3][start_add+3*k+ 1] = rcs_nop_instr
rcs_instructions[3][start_add+3*k+ 2] = rcs_nop_instr
rcs_instructions[3][start_add+3*k+ 3] = rcs_nop_instr
rcs_instructions[3][start_add+3*k+ 4] = rcs_nop_instr
rcs_instructions[3][start_add+3*k+ 5] = rcs_nop_instr
rcs_instructions[3][start_add+3*k+ 6] = rcs_nop_instr
rcs_instructions[3][start_add+3*k+ 7] = rcs_nop_instr
