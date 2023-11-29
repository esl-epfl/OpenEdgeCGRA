#
# Check CGRA size is correctly configured
#

ker_col_needed = 1
ker_num_instr  = 6

ker_conf_words[ker_next_id] = get_bin(int(pow(2,ker_col_needed))-1,CGRA_N_COL) +\
                              get_bin(ker_start_add, RCS_NUM_CREG_LOG2) +\
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
rcs_instructions[0][start_add+0] = [   "-",    "-",  "LWD",  "-",      "-", "4"]
rcs_instructions[0][start_add+1] = [ "RCT", "ZERO", "SADD",  "-",      "-", "-"] # move
rcs_instructions[0][start_add+2] = [ "RCL", "ZERO", "SADD",  "-",      "-", "-"] # move
rcs_instructions[0][start_add+3] = ["SELF",    "-",  "SWD",  "-",      "-", "4"]
rcs_instructions[0][start_add+4] = rcs_nop_instr
rcs_instructions[0][start_add+5] = [   "-",    "-", "EXIT",  "-",      "-", "-"]

