# FFT OUTPUT SPLIT OPS instructions DEPREDECATED

instructions.append(["NEXT RC"])

# RC1_0
# PROLOGUE
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["DATA", "OUT_D", "LWD", "RF1", "ON", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["DATA", "OUT_D", "LWD", "RF2", "ON", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])

# ITERATION LOOP
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["DATA", "RF1", "LWI", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RCR", "OUT_D", "FXP_MUL", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["DATA", "RF2", "LWI", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RCR", "OUT_D", "FXP_MUL", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RF1", "CONST", "SADD", "RF1", "ON", "OUT_F", "4"])
instructions.append(["RF2", "CONST", "SADD", "RF2", "ON", "OUT_F", "4"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])


# RC1_1
# PROLOGUE
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["DATA", "OUT_D", "LWD", "RF1", "ON", "OUT_F", "0"])
instructions.append(["DATA", "OUT_D", "LWD", "RF2", "ON", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])

# ITERATION LOOP
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["DATA", "RF1", "LWI", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RF1", "CONST", "SADD", "RF1", "ON", "OUT_F", "4"])
instructions.append(["DATA", "RF2", "LWI", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RF2", "CONST", "SSUB", "RF2", "ON", "OUT_F", "4"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])

#################################################################################################
#################################################################################################
#################################################################################################

instructions.append(["NEXT RC"])

# RC2_0
# PROLOGUE
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])

# ITERATION LOOP
instructions.append(["DATA", "OUT_D", "IN1", "RF3", "ON", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RF3", "RCT", "FXP_MUL", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RCB", "OUT_D", "IN1", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RCT", "OUT_D", "FXP_MUL", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "EXIT", "RF1", "OFF", "OUT_F", "0"])


# RC2_1
# PROLOGUE
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])

# ITERATION LOOP
instructions.append(["DATA", "OUT_D", "IN1", "RF3", "ON", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RF3", "RCT", "FXP_MUL", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RCL", "OUT_D", "FXP_ADD", "RF2", "ON", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RCL", "RCB", "FXP_SUB", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RF2", "OUT_D", "FXP_ADD", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])

#################################################################################################
#################################################################################################
#################################################################################################

instructions.append(["NEXT RC"])

# RC3_0
# PROLOGUE
instructions.append(["DATA", "OUT_D", "LWD", "RF1", "ON", "OUT_F", "0"])
instructions.append(["RF1", "CONST", "SSUB", "RF1", "ON", "OUT_F", "4"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["DATA", "OUT_D", "LWD", "RF2", "ON", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])

# ITERATION LOOP
instructions.append(["RF1", "CONST", "SADD", "RF1", "ON", "OUT_F", "4"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["DATA", "RF2", "LWI", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RCR", "OUT_D", "FXP_MUL", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RF2", "CONST", "SSUB", "RF2", "ON", "OUT_F", "4"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RCB", "RF1", "SWI", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])


# RC3_1
# PROLOGUE
instructions.append(["DATA", "OUT_D", "LWD", "RF1", "ON", "OUT_F", "0"])
instructions.append(["RF1", "CONST", "SSUB", "RF1", "ON", "OUT_F", "4"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])

# ITERATION LOOP
instructions.append(["RF1", "CONST", "SADD", "RF1", "ON", "OUT_F", "4"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["DATA", "OUT_D", "IN1", "RF3", "ON", "OUT_F", "0"])
instructions.append(["DATA", "OUT_D", "IN1", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RF3", "OUT_D", "FXP_MUL", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RCT", "RF1", "SWI", "RF1", "OFF", "OUT_F", "0"])

#################################################################################################
#################################################################################################
#################################################################################################

instructions.append(["NEXT RC"])

# RC4_0
# PROLOGUE
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["DATA", "OUT_D", "LWD", "RF1", "ON", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])

# ITERATION LOOP
instructions.append(["DATA", "RF1", "LWI", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RCR", "OUT_D", "FXP_MUL", "RF2", "ON", "OUT_F", "0"])
instructions.append(["RF1", "CONST", "SADD", "RF1", "ON", "OUT_F", "4"])
instructions.append(["RF2", "RCB", "FXP_SUB", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RCT", "OUT_D", "FXP_ADD", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RCB", "OUT_D", "FXP_ADD", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])


# RC4_1
# PROLOGUE
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["DATA", "OUT_D", "LWD", "RF1", "ON", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["DATA", "OUT_D", "LWD", "RF2", "ON", "OUT_F", "0"])
instructions.append(["DATA", "OUT_D", "LWD", "RF3", "ON", "OUT_F", "0"])

# ITERATION LOOP
instructions.append(["DATA", "RF1", "LWI", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RF1", "CONST", "SADD", "RF1", "ON", "OUT_F", "4"])
instructions.append(["DATA", "RF2", "LWI", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RF2", "CONST", "SADD", "RF2", "ON", "OUT_F", "4"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RF4", "CONST", "SADD", "RF4", "ON", "OUT_F", "1"])
instructions.append(["ZEROS", "OUT_D", "NOP", "RF1", "OFF", "OUT_F", "0"])
instructions.append(["RF4", "RF3", "BLT", "RF1", "OFF", "OUT_F", "6"])


#################################################################################################
#################################################################################################
#################################################################################################

kernel_col_needed = "0011"
row_st_add = 58
n_instructions = 14
