#
# FFT computation for complex input (manual mapping)
#

ker_col_needed = 2
ker_num_instr  = 14

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
rcs_instructions[0][start_add+ 0] = [   "-",    "-",    "LWD", "R2",    "-", "-"]
rcs_instructions[0][start_add+ 1] = [ "IMM", "ZERO",   "SADD", "R3",    "-", "4"]
rcs_instructions[0][start_add+ 2] = rcs_nop_instr

# INNER ITERATION LOOP
rcs_instructions[0][start_add+ 3] = [   "-",   "R0",    "LWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+ 4] = [ "RCB", "SELF", "FXPMUL",  "-",    "-", "-"]
rcs_instructions[0][start_add+ 5] = ["SELF",  "RCR",   "SSUB",  "-",    "-", "-"]
rcs_instructions[0][start_add+ 6] = [ "RCT", "SELF",   "SSUB",  "-",    "-", "-"]
rcs_instructions[0][start_add+ 7] = ["SELF",   "R0",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+ 8] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]

# MIDDLE ITERATION LOOP
rcs_instructions[0][start_add+ 9] = [  "R2",   "R3",   "SADD", "R0",    "-", "-"]
rcs_instructions[0][start_add+10] = rcs_nop_instr
rcs_instructions[0][start_add+11] = [  "R0",  "RCT",   "SADD", "R0",    "-", "-"]

# OUTER ITERATION LOOP
rcs_instructions[0][start_add+12] = [  "R3",  "IMM",    "SLT", "R3",    "-", "1"]
rcs_instructions[0][start_add+13] = rcs_nop_instr


# COLUMN-1
# PROLOGUE
rcs_instructions[0][start_add+k+ 0] = rcs_nop_instr
rcs_instructions[0][start_add+k+ 1] = [ "IMM", "ZERO",   "SADD", "R3",    "-", "4"]
rcs_instructions[0][start_add+k+ 2] = [ "RCB", "ZERO",   "SADD", "R2",    "-", "-"]

# INNER ITERATION LOOP
rcs_instructions[0][start_add+k+ 3] = [   "-",   "R0",    "LWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+k+ 4] = [ "RCB", "SELF", "FXPMUL",  "-",    "-", "-"]
rcs_instructions[0][start_add+k+ 5] = rcs_nop_instr
rcs_instructions[0][start_add+k+ 6] = rcs_nop_instr
rcs_instructions[0][start_add+k+ 7] = [ "RCB",   "R0",    "SWI",  "-",    "-", "-"]
rcs_instructions[0][start_add+k+ 8] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]

# MIDDLE ITERATION LOOP
rcs_instructions[0][start_add+k+ 9] = [  "R2",   "R3",   "SADD", "R0",    "-", "-"]
rcs_instructions[0][start_add+k+10] = rcs_nop_instr
rcs_instructions[0][start_add+k+11] = [  "R0",  "RCT",   "SADD", "R0",    "-", "-"]

# OUTER ITERATION LOOP
rcs_instructions[0][start_add+k+12] = [  "R3",  "IMM",    "SLT", "R3",    "-", "1"]
rcs_instructions[0][start_add+k+13] = rcs_nop_instr

#################################################################################################
############################################## RC1 ##############################################
#################################################################################################

# COLUMN-0
# PROLOGUE
rcs_instructions[1][start_add+ 0] = [   "-",    "-",    "LWD", "R2",    "-", "-"]
rcs_instructions[1][start_add+ 1] = [ "RCB",  "IMM",    "SLT", "R1",    "-", "1"]
rcs_instructions[1][start_add+ 2] = ["ZERO", "ZERO",    "BEQ",  "-",    "-", "9"]

# INNER ITERATION LOOP
rcs_instructions[1][start_add+ 3] = [   "-",   "R0",    "LWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+ 4] = [ "RCR",  "RCT", "FXPMUL",  "-",    "-", "-"]
rcs_instructions[1][start_add+ 5] = rcs_nop_instr
rcs_instructions[1][start_add+ 6] = rcs_nop_instr
rcs_instructions[1][start_add+ 7] = [  "R1", "ZERO",   "SADD",  "-",    "-", "-"]
rcs_instructions[1][start_add+ 8] = [  "R0", "SELF",   "SADD", "R0",    "-", "-"]

# MIDDLE ITERATION LOOP
rcs_instructions[1][start_add+ 9] = [  "R2", "ZERO",   "SADD", "R0",    "-", "-"]
rcs_instructions[1][start_add+10] = rcs_nop_instr
rcs_instructions[1][start_add+11] = rcs_nop_instr

# OUTER ITERATION LOOP
rcs_instructions[1][start_add+12] = [  "R1",  "IMM",    "SRT", "R1",    "-", "1"]
rcs_instructions[1][start_add+13] = [   "-",    "-",   "EXIT",  "-",    "-", "-"]


# COLUMN-1
# PROLOGUE
rcs_instructions[1][start_add+k+ 0] = [   "-",    "-",    "LWD", "R2",    "-", "-"]
rcs_instructions[1][start_add+k+ 1] = [ "RCB", "ZERO",   "SADD",  "-",    "-", "-"]
rcs_instructions[1][start_add+k+ 2] = rcs_nop_instr

# INNER ITERATION LOOP
rcs_instructions[1][start_add+k+ 3] = [   "-",   "R0",    "LWI",  "-",    "-", "-"]
rcs_instructions[1][start_add+k+ 4] = [ "RCL",  "RCT", "FXPMUL",  "-",    "-", "-"]
rcs_instructions[1][start_add+k+ 5] = ["SELF",  "RCL",   "SADD",  "-",    "-", "-"]
rcs_instructions[1][start_add+k+ 6] = [ "RCB", "SELF",   "SSUB",  "-",    "-", "-"]
rcs_instructions[1][start_add+k+ 7] = rcs_nop_instr
rcs_instructions[1][start_add+k+ 8] = [  "R0",  "RCL",   "SADD", "R0",    "-", "-"]

# MIDDLE ITERATION LOOP
rcs_instructions[1][start_add+k+ 9] = [  "R2", "ZERO",   "SADD", "R0",    "-", "-"]
rcs_instructions[1][start_add+k+10] = rcs_nop_instr
rcs_instructions[1][start_add+k+11] = rcs_nop_instr

# OUTER ITERATION LOOP
rcs_instructions[1][start_add+k+12] = rcs_nop_instr
rcs_instructions[1][start_add+k+13] = rcs_nop_instr

#################################################################################################
############################################## RC2 ##############################################
#################################################################################################

# COLUMN-0
# PROLOGUE
rcs_instructions[2][start_add+ 0] = [   "-",    "-",    "LWD",  "-",    "-", "-"]
rcs_instructions[2][start_add+ 1] = ["ZERO",  "IMM",   "SSUB", "R1",    "-", "1"]
rcs_instructions[2][start_add+ 2] = [ "RCT",  "IMM",    "SRT", "R0",    "-", "2"]

# INNER ITERATION LOOP
rcs_instructions[2][start_add+ 3] = rcs_nop_instr
rcs_instructions[2][start_add+ 4] = rcs_nop_instr
rcs_instructions[2][start_add+ 5] = rcs_nop_instr
rcs_instructions[2][start_add+ 6] = rcs_nop_instr
rcs_instructions[2][start_add+ 7] = rcs_nop_instr
rcs_instructions[2][start_add+ 8] = rcs_nop_instr

# MIDDLE ITERATION LOOP
rcs_instructions[2][start_add+ 9] = rcs_nop_instr
rcs_instructions[2][start_add+10] = [  "R1",  "IMM",   "SADD", "R1",    "-", "1"]
rcs_instructions[2][start_add+11] = [  "R1",   "R0",    "BLT",  "-",    "-", "3"]

# OUTER ITERATION LOOP
rcs_instructions[2][start_add+12] = [  "R0",  "IMM",    "SRT", "R0",    "-", "1"]
rcs_instructions[2][start_add+13] = ["ZERO",  "IMM",   "SSUB", "R1",    "-", "1"]


# COLUMN-1
# PROLOGUE
rcs_instructions[2][start_add+k+ 0] = [   "-",    "-",    "LWD", "R2",    "-", "-"]
rcs_instructions[2][start_add+k+ 1] = ["ZERO",  "RCB",   "SADD", "R1",    "-", "-"]
rcs_instructions[2][start_add+k+ 2] = rcs_nop_instr

# INNER ITERATION LOOP
rcs_instructions[2][start_add+k+ 3] = [   "-",   "R0",    "LWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+k+ 4] = rcs_nop_instr
rcs_instructions[2][start_add+k+ 5] = rcs_nop_instr
rcs_instructions[2][start_add+k+ 6] = ["SELF",  "RCT",   "SADD",  "-",    "-", "-"]
rcs_instructions[2][start_add+k+ 7] = ["SELF",   "R0",    "SWI",  "-",    "-", "-"]
rcs_instructions[2][start_add+k+ 8] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]

# # MIDDLE ITERATION LOOP
rcs_instructions[2][start_add+k+ 9] = [  "R2", "ZERO",   "SADD", "R0",    "-", "-"]
rcs_instructions[2][start_add+k+10] = rcs_nop_instr
rcs_instructions[2][start_add+k+11] = [  "R2",  "RCB",   "SADD", "R0",    "-", "-"]

# OUTER ITERATION LOOP
rcs_instructions[2][start_add+k+12] = rcs_nop_instr
rcs_instructions[2][start_add+k+13] = [  "R1",  "RCB",    "BGE",  "-",    "-", "9"]

#################################################################################################
############################################## RC3 ##############################################
#################################################################################################

# COLUMN-0
# PROLOGUE
rcs_instructions[3][start_add+ 0] = rcs_nop_instr
rcs_instructions[3][start_add+ 1] = [ "RCB", "ZERO",   "SADD", "R2",    "-", "-"]
rcs_instructions[3][start_add+ 2] = ["ZERO",  "IMM",   "SSUB", "R3",    "-", "4"]

# INNER ITERATION LOOP
rcs_instructions[3][start_add+ 3] = [   "-",   "R0",    "LWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+ 4] = rcs_nop_instr
rcs_instructions[3][start_add+ 5] = rcs_nop_instr
rcs_instructions[3][start_add+ 6] = ["SELF",  "RCB",   "SADD",  "-",    "-", "-"]
rcs_instructions[3][start_add+ 7] = ["SELF",   "R0",    "SWI",  "-",    "-", "-"]
rcs_instructions[3][start_add+ 8] = [  "R0",  "IMM",   "SADD", "R0",    "-", "4"]

# MIDDLE ITERATION LOOP
rcs_instructions[3][start_add+ 9] = [  "R3",  "IMM",   "SADD", "R3",    "-", "4"]
rcs_instructions[3][start_add+10] = ["SELF",  "RCR",    "SLT",  "-",    "-", "-"]
rcs_instructions[3][start_add+11] = [  "R2", "SELF",   "SADD", "R0",    "-", "-"]

# OUTER ITERATION LOOP
rcs_instructions[3][start_add+12] = rcs_nop_instr
rcs_instructions[3][start_add+13] = ["ZERO",  "IMM",   "SSUB", "R3",    "-", "4"]


# COLUMN-1
# PROLOGUE
rcs_instructions[3][start_add+k+ 0] = [   "-",    "-",    "LWD",  "-",    "-", "-"]
rcs_instructions[3][start_add+k+ 1] = ["ZERO",  "IMM",   "SADD", "R2",    "-", "1"]
rcs_instructions[3][start_add+k+ 2] = ["ZERO",  "IMM",   "SADD", "R0",    "-", "1"]

# INNER ITERATION LOOP
rcs_instructions[3][start_add+k+ 3] = [  "R3",  "IMM",   "SADD", "R3",    "-", "1"]
rcs_instructions[3][start_add+k+ 4] = rcs_nop_instr
rcs_instructions[3][start_add+k+ 5] = rcs_nop_instr
rcs_instructions[3][start_add+k+ 6] = rcs_nop_instr
rcs_instructions[3][start_add+k+ 7] = rcs_nop_instr
rcs_instructions[3][start_add+k+ 8] = [  "R3",   "R2",    "BLT",  "-",    "-", "3"]

# MIDDLE ITERATION LOOP
rcs_instructions[3][start_add+k+ 9] = [  "R0", "ZERO",   "SADD",  "-",    "-", "-"]
rcs_instructions[3][start_add+k+10] = [ "RCL", "SELF",    "SLT",  "-",    "-", "-"]
rcs_instructions[3][start_add+k+11] = ["ZERO", "ZERO",   "SADD", "R3",    "-", "-"]

# OUTER ITERATION LOOP
rcs_instructions[3][start_add+k+12] = [  "R0",  "IMM",   "SADD", "R0",    "-", "1"]
rcs_instructions[3][start_add+k+13] = [  "R2",  "IMM",    "SLT", "R2",    "-", "1"]
