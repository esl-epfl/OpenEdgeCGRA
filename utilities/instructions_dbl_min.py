#
# DOUBLE_MIN search instructions
#

ker_col_needed = 1
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
rcs_instructions[0][start_add+ 0] = rcs_nop_instr
rcs_instructions[0][start_add+ 1] = rcs_nop_instr
rcs_instructions[0][start_add+ 2] = rcs_nop_instr

# ITERATION LOOP
rcs_instructions[0][start_add+ 3] = rcs_nop_instr
rcs_instructions[0][start_add+ 4] = [ "RCT", "ZERO", "SADD", "R2",      "-", "-"] # move
rcs_instructions[0][start_add+ 5] = [ "RCB", "ZERO", "SADD",  "-",      "-", "-"] # move
rcs_instructions[0][start_add+ 6] = [  "R0", "ZERO", "SADD",  "-",      "-", "-"] # move
rcs_instructions[0][start_add+ 7] = [ "IMM", "ZERO", "JUMP",  "-",      "-", "9"]
rcs_instructions[0][start_add+ 8] = [  "R2", "ZERO", "SADD", "R0",      "-", "-"] # move
rcs_instructions[0][start_add+ 9] = rcs_nop_instr

# EPILOGUE
rcs_instructions[0][start_add+10] = rcs_nop_instr
rcs_instructions[0][start_add+11] = rcs_nop_instr
rcs_instructions[0][start_add+12] = [  "R0",    "-",  "SWD",  "-",      "-", "-"]
rcs_instructions[0][start_add+13] = [   "-",    "-", "EXIT",  "-",      "-", "-"]

#################################################################################################
############################################## RC1 ##############################################
#################################################################################################

# COLUMN-0
# PROLOGUE
rcs_instructions[1][start_add+ 0] = [   "-",    "-",  "LWD", "R2",      "-", "-"]
rcs_instructions[1][start_add+ 1] = rcs_nop_instr
rcs_instructions[1][start_add+ 2] = [   "-",   "R2",  "LWI", "R0",      "-", "-"]

# ITERATION LOOP
rcs_instructions[1][start_add+ 3] = [  "R2",  "IMM", "SADD", "R2",      "-", "4"]
rcs_instructions[1][start_add+ 4] = [   "-",  "R2",   "LWI", "R3",      "-", "-"]
rcs_instructions[1][start_add+ 5] = [  "R0", "ZERO", "SADD",  "-",      "-", "-"] # move
rcs_instructions[1][start_add+ 6] = [  "R3",   "R0",  "BLT",  "-",      "-", "8"]
rcs_instructions[1][start_add+ 7] = rcs_nop_instr
rcs_instructions[1][start_add+ 8] = [  "R3", "ZERO", "SADD", "R0",      "-", "-"] # move
rcs_instructions[1][start_add+ 9] = rcs_nop_instr

# EPILOGUE
rcs_instructions[1][start_add+10] = [  "R0",    "-",  "SWD",  "-",      "-", "-"]
rcs_instructions[1][start_add+11] = rcs_nop_instr
rcs_instructions[1][start_add+12] = rcs_nop_instr
rcs_instructions[1][start_add+13] = rcs_nop_instr

#################################################################################################
############################################## RC2 ##############################################
#################################################################################################

# COLUMN-0
# PROLOGUE
rcs_instructions[2][start_add+ 0] = [ "IMM",  "IMM", "SMUL", "R0",      "-", "2047"] # move
rcs_instructions[2][start_add+ 1] = rcs_nop_instr
rcs_instructions[2][start_add+ 2] = rcs_nop_instr

# ITERATION LOOP
rcs_instructions[2][start_add+ 3] = rcs_nop_instr
rcs_instructions[2][start_add+ 4] = rcs_nop_instr
rcs_instructions[2][start_add+ 5] = [ "RCT",   "R0",  "BGE",  "-",      "-", "9"]
rcs_instructions[2][start_add+ 6] = [ "RCT", "ZERO", "SADD", "R1",      "-", "-"] # move
rcs_instructions[2][start_add+ 7] = [ "RCB", "ZERO", "SADD", "R0",      "-", "-"] # move
rcs_instructions[2][start_add+ 8] = [  "R1", "ZERO", "SADD", "R0",      "-", "-"] # move
rcs_instructions[2][start_add+ 9] = rcs_nop_instr

# EPILOGUE
rcs_instructions[2][start_add+10] = rcs_nop_instr
rcs_instructions[2][start_add+11] = [  "R0",    "-",  "SWD",  "-",      "-", "-"]
rcs_instructions[2][start_add+12] = rcs_nop_instr
rcs_instructions[2][start_add+13] = rcs_nop_instr

#################################################################################################
############################################## RC3 ##############################################
#################################################################################################

# COLUMN-0
# PROLOGUE
rcs_instructions[3][start_add+ 0] = [ "IMM", "ZERO", "SADD", "R0",      "-", "-1"] # move
rcs_instructions[3][start_add+ 1] = [   "-",    "-",  "LWD", "R3",      "-", "-"]
rcs_instructions[3][start_add+ 2] = rcs_nop_instr

# ITERATION LOOP
rcs_instructions[3][start_add+ 3] = [  "R2",  "IMM", "SADD", "R2",      "-", "1"]
rcs_instructions[3][start_add+ 4] = rcs_nop_instr
rcs_instructions[3][start_add+ 5] = rcs_nop_instr
rcs_instructions[3][start_add+ 6] = [ "RCB", "ZERO", "SADD",  "-",      "-", "-"] # move
rcs_instructions[3][start_add+ 7] = [  "R2", "ZERO", "SADD", "R0",      "-", "-"] # move
rcs_instructions[3][start_add+ 8] = [ "RCB", "ZERO", "SADD", "R0",      "-", "-"] # move
rcs_instructions[3][start_add+ 9] = [  "R2",   "R3",  "BLT",  "-",      "-", "3"]

# EPILOGUE
rcs_instructions[3][start_add+10] = rcs_nop_instr
rcs_instructions[3][start_add+11] = rcs_nop_instr
rcs_instructions[3][start_add+12] = rcs_nop_instr
rcs_instructions[3][start_add+13] = [  "R0",    "-",  "SWD",  "-",      "-", "-"]
