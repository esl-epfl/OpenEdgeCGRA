#
# FFT input bit reversal reordering instructions (manual mapping)
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
# PROLOGUE
rcs_instructions[0][start_add+ 0] = [   "-",    "-",  "LWD", "R0",    "-", "4"]
rcs_instructions[0][start_add+ 1] = [   "-",    "-",  "LWD", "R1",    "-", "4"]
rcs_instructions[0][start_add+ 2] = rcs_nop_instr
rcs_instructions[0][start_add+ 3] = [  "R0",  "RCB", "SADD", "R0",    "-", "-"]

# ITERATION LOOP
rcs_instructions[0][start_add+ 4] = [   "-",   "R0",  "LWI", "R2",    "-", "-"]
rcs_instructions[0][start_add+ 5] = [  "R0",  "IMM", "SADD", "R0",    "-", "8"]
rcs_instructions[0][start_add+ 6] = rcs_nop_instr
rcs_instructions[0][start_add+ 7] = rcs_nop_instr

rcs_instructions[0][start_add+ 8] = [ "RCB",  "IMM",  "SLT",  "-",    "-", "2"]
rcs_instructions[0][start_add+ 9] = [  "R1", "SELF", "SADD",  "-",    "-", "-"]
rcs_instructions[0][start_add+10] = [  "R2", "SELF",  "SWI",  "-",    "-", "-"]

#################################################################################################
############################################## RC1 ##############################################
#################################################################################################

# COLUMN-0
# PROLOGUE
rcs_instructions[1][start_add+ 0] = [   "-",    "-",  "LWD", "R0",    "-", "4"]
rcs_instructions[1][start_add+ 1] = [   "-",    "-",  "LWD", "R1",    "-", "4"]
rcs_instructions[1][start_add+ 2] = [ "RCB",  "IMM",  "SLT",  "-",    "-", "2"]
rcs_instructions[1][start_add+ 3] = [  "R0", "SELF", "SADD", "R0",    "-", "-"]

# ITERATION LOOP
rcs_instructions[1][start_add+ 4] = [   "-",   "R0",  "LWI", "R2",    "-", "-"]
rcs_instructions[1][start_add+ 5] = [  "R0",  "IMM", "SADD", "R0",    "-", "8"]
rcs_instructions[1][start_add+ 6] = [  "R3",  "IMM",  "SLT",  "-",    "-", "1"]
rcs_instructions[1][start_add+ 7] = ["SELF",  "RCB",  "LOR", "R3",    "-", "-"]

rcs_instructions[1][start_add+ 8] = ["ZERO", "ZERO", "SADD", "R3",    "-", "-"] # R3=0
rcs_instructions[1][start_add+ 9] = [ "RCT",   "R1", "SADD",  "-",    "-", "-"]
rcs_instructions[1][start_add+10] = [  "R2", "SELF",  "SWI",  "-",    "-", "-"]

#################################################################################################
############################################## RC2 ##############################################
#################################################################################################

# COLUMN-0
# PROLOGUE
rcs_instructions[2][start_add+ 0] = [   "-",    "-",  "LWD", "R1",    "-", "4"]
rcs_instructions[2][start_add+ 1] = [   "-",    "-",  "LWD", "R0",    "-", "4"]
rcs_instructions[2][start_add+ 2] = rcs_nop_instr
rcs_instructions[2][start_add+ 3] = rcs_nop_instr

# ITERATION LOOP
rcs_instructions[2][start_add+ 4] = ["ZERO",   "R0", "SADD", "R2",    "-", "-"] # R2=R0
rcs_instructions[2][start_add+ 5] = rcs_nop_instr
rcs_instructions[2][start_add+ 6] = [  "R2",  "IMM", "LAND",  "-",    "-", "1"]
rcs_instructions[2][start_add+ 7] = [  "R2",  "IMM",  "SRT", "R2",    "-", "1"]

rcs_instructions[2][start_add+ 8] = [  "R0",  "IMM", "SADD", "R0",    "-", "1"]
rcs_instructions[2][start_add+ 9] = rcs_nop_instr
rcs_instructions[2][start_add+10] = [  "R0",   "R1",  "BLT",  "-",    "-", "4"]

#################################################################################################
############################################## RC3 ##############################################
#################################################################################################

# COLUMN-0
# PROLOGUE
rcs_instructions[3][start_add+ 0] = [   "-",    "-",  "LWD", "R0",    "-", "4"]
rcs_instructions[3][start_add+ 1] = rcs_nop_instr
rcs_instructions[3][start_add+ 2] = rcs_nop_instr
rcs_instructions[3][start_add+ 3] = rcs_nop_instr

# ITERATION LOOP
rcs_instructions[3][start_add+ 4] = ["ZERO", "ZERO", "SADD", "R1",    "-", "-"] # R1=0
rcs_instructions[3][start_add+ 5] = rcs_nop_instr
rcs_instructions[3][start_add+ 6] = [  "R1",  "IMM", "SADD", "R1",    "-", "1"]
rcs_instructions[3][start_add+ 7] = [  "R1",   "R0",  "BLT",  "-",    "-", "6"]

rcs_instructions[3][start_add+ 8] = rcs_nop_instr
rcs_instructions[3][start_add+ 9] = rcs_nop_instr
rcs_instructions[3][start_add+10] = [   "-",    "-", "EXIT",  "-",    "-", "-"]
