# Copyright EPFL contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import os
import sys
import io
import numpy as np
import log2file as logfunc
from math import *

######################################################################

def get_bin(x, n=0):
    """
    Get the binary representation of x.

    Parameters
    ----------
    x : int
    n : int
        Minimum number of digits. If x needs less digits in binary, the rest
        is filled with zeros.

    Returns
    -------
    str
    """
    return format(x, 'b').zfill(n)

def int2bin(x, bits):
    """
    Get the 2's complement binary representation of x.

    Parameters
    ----------
    x : signed int
    n : int
        Minimum number of digits. If x needs less digits in binary, the rest
        is signed extended.

    Returns
    -------
    str
    """
    s = bin(x & int("1"*bits, 2))[2:]
    return ("{0:0>%s}" % (bits)).format(s)

def get_hex(x, n=0):
    """
    Get the hexadecimal representation of x.

    Parameters
    ----------
    x : int
    n : int
        Minimum number of digits. If x needs less digits in binary, the rest
        is filled with zeros.

    Returns
    -------
    str
    """
    return format(x, 'x').zfill(n).upper()


def return_indices_of_a(a, b, name = ''):
    """
    Check if string b is in list a and return the index where b == a(index)
    Return an error if no index is found

    Parameters
    ----------
    a : list of string
    b : string

    Returns
    -------
    int
    """
    for val in a:
        if b == val:
            return a.index(val)

    sys.exit("ERROR instruction: " + str(b) + " is not a valid command (not in " + name + " list)")

##########################################################################
#   _____ _____ _____              _____ ____  _   _ ______ _____ _____  #
#  / ____/ ____|  __ \    /\      / ____/ __ \| \ | |  ____|_   _/ ____| #
# | |   | |  __| |__) |  /  \    | |   | |  | |  \| | |__    | || |  __  #
# | |   | | |_ |  _  /  / /\ \   | |   | |  | | . ` |  __|   | || | |_ | #
# | |___| |__| | | \ \ / ____ \  | |___| |__| | |\  | |     _| || |__| | #
#  \_____\_____|_|  \_/_/    \_\  \_____\____/|_| \_|_|    |_____\_____| #
#                                                                        #
##########################################################################

CGRA_N_COL = 4
CGRA_N_ROW = 4

RCS_NUM_CREG      = 32;
RCS_NUM_CREG_LOG2 = ceil(log(RCS_NUM_CREG,2));

CGRA_IMEM_N_LINE = 128
CGRA_IMEM_NL_LOG2 = ceil(log(CGRA_IMEM_N_LINE,2))

# Memory holding the kernel configuration words (KMEM)
# Max possible number of kernel
CGRA_KMEM_N_KER = 16
# Kernel configuration word width
CGRA_KMEM_WIDTH = CGRA_N_COL + CGRA_IMEM_NL_LOG2 + RCS_NUM_CREG_LOG2

#################################################################
#  _____   _____  _____    _____ ____  _   _ _____ _____ _____  #
# |  __ \ / ____|/ ____|  / ____/ __ \| \ | |  ___|_   _/ ____| #
# | |__) | |    | (___   | |   | |  | |  \| | |__   | || |  __  #
# |  _  /| |     \___ \  | |   | |  | | . ` |  __|  | || | |_ | #
# | | \ \| |____ ____) | | |___| |__| | |\  | |    _| || |__| | #
# |_|  \_\\_____|_____/   \_____\____/|_| \_|_|   |_____\_____| #
#                                                               #
#################################################################

RCS_MUXA_BITS    = 4
RCS_MUXB_BITS    = 4
RCS_ALU_OP_BITS  = 5
RCS_RF_WADD_BITS = 2
RCS_RF_WE_BITS   = 1
RCS_MUXFLAG_BITS = 3
RCS_IMM_BITS     = 13

CGRA_IMEM_WIDTH = RCS_MUXA_BITS+RCS_MUXB_BITS+RCS_ALU_OP_BITS+RCS_RF_WADD_BITS+RCS_RF_WE_BITS+RCS_MUXFLAG_BITS+RCS_IMM_BITS

muxA_list     = ['ZERO', 'SELF', 'RCL', 'RCR', 'RCT', 'RCB',  'R0', 'R1', 'R2', 'R3', 'IMM']
muxB_list     = ['ZERO', 'SELF', 'RCL', 'RCR', 'RCT', 'RCB',  'R0', 'R1', 'R2', 'R3', 'IMM']

ALU_op_list   = ['NOP', 
                 'SADD', 'SSUB', 'SMUL', 'FXPMUL', 
                 'SLT', 'SRT', 'SRA',
                 'LAND', 'LOR', 'LXOR', 'LNAND', 'LNOR', 'LXNOR', 
                 'BSFA', 'BZFA',
                 'BEQ', 'BNE', 'BLT', 'BGE', 'JUMP',
                 'LWD', 'SWD', 'LWI', 'SWI',
                 'EXIT']

# BSFA --> operand a if sign flag, else operand b

reg_dest_list  = ['R0', 'R1', 'R2', 'R3']
reg_we_list    = ['0', '1']
muxF_list      = ['SELF', 'RCL', 'RCR', 'RCT', 'RCB']

rcs_nop_instr = ['ZERO', 'ZERO', 'NOP', '-', 'SELF', '0']

#####################################################################################
#  _  _______ _____     _____ ____  _   _ _____  __          ______  _____  _____   #
# | |/ /  ___|  __ \   / ____/ __ \| \ | |  ___| \ \        / / __ \|  __ \|  __ \  #
# | ' /| |__ | |__) | | |   | |  | |  \| | |__    \ \  /\  / / |  | | |__) | |  | | #
# |  < |  __||  _  /  | |   | |  | | . ` |  __|    \ \/  \/ /| |  | |  _  /| |  | | #
# | . \| |___| | \ \  | |___| |__| | |\  | |        \  /\  / | |__| | | \ \| |__| | #
# |_|\_\_____|_|  \_\  \_____\____/|_| \_|_|         \/  \/   \____/|_|  \_\_____/  #
#                                                                                   #
#####################################################################################

ker_null_conf = get_bin(0, CGRA_KMEM_WIDTH)

#####################################################################################

rcs_imem_file = '../bitsream/cgra_imem.bit'
ker_kmem_file = '../bitsream/cgra_kmem.bit'

if not os.path.exists('../bitsream'):
    os.mkdir('../bitsream')

open(rcs_imem_file, 'w')
open(ker_kmem_file, 'w')

rcs_logger = logfunc.log2file(rcs_imem_file, CGRA_IMEM_WIDTH + 4) # + 0b<>, 
ker_logger = logfunc.log2file(ker_kmem_file, CGRA_KMEM_WIDTH)

rcs_instructions = [[rcs_nop_instr for _ in range(CGRA_IMEM_N_LINE)] for _ in range (CGRA_N_ROW)]
ker_conf_words   = [ker_null_conf for _ in range(CGRA_KMEM_N_KER)]

# First entry is always null
ker_conf_words[0] = ker_null_conf

# ================================================================================ #
# ========================> UNCOMMENT KERNEL INSTRUCTIONS <======================= #
# ================================================================================ #

# ID zero is reserved (= no kernel request)
ker_next_id    = 1
# First kernel start at adress 0
ker_start_add  = 0

# The order of the kernel in memory (and their ID) correspond to the execution order given below

# exec(open("instructions_dbl_min.py").read())
# exec(open("instructions_dbl_max.py").read())
# exec(open("instructions_max_peak.py").read())
# exec(open("instructions_min_max_circular.py").read())

exec(open("instructions_fft_bitrev.py").read())
exec(open("instructions_fft_cplx.py").read())
exec(open("instructions_fft_cplx_forever.py").read())
# exec(open("instructions_fft_splitops.py").read())

# exec(open("instructions_while_loop_100percent.py").read())
# exec(open("instructions_while_loop_75percent.py").read())
# exec(open("instructions_while_loop_50percent.py").read())

# exec(open("instructions_func_test.py").read())

# PRINT STATS
print("CGRA conf. word width  :", CGRA_KMEM_WIDTH)
print("CGRA instruction width :", CGRA_IMEM_WIDTH)
print("CGRA number of kernels :", ker_next_id-1)
print("-------------------------------------")

# Check instruction memory is large enough
if ker_start_add > CGRA_IMEM_N_LINE:
    print("ERROR: TOO MANY INSTRUCTIONS FOR CGRA MEMORY")
else:
    print("INFO: {}/{} CGRA INSTRUCTIONS".format(ker_start_add, CGRA_IMEM_N_LINE));

print("-------------------------------------")

for i in range(0,CGRA_KMEM_N_KER):
    # ker_logger.log_line(ker_conf_words[i])
    ker_logger.log_line(hex(int(ker_conf_words[i],2)))
    # print(ker_conf_words[i])
    # print(hex(int(ker_conf_words[i],2)))

for i in range(0,CGRA_N_ROW):
    for instruction in rcs_instructions[i]:

        instr_bits = ""

        for idx in range(len(instruction)):
            cmd = instruction[idx]

            # Don't care is replaced by default value
            if cmd == '-':
                cmd = rcs_nop_instr[idx]

            # Don't care for register destination also need a 0 bit to disable write to register
            if idx == 3:
                # Default command
                cmd_tmp = ['R0', '0']
                # If we write to a register put a 1 for write enable
                if cmd != '-':
                    cmd_tmp[0] = cmd
                    cmd_tmp[1] = '1'
                cmd = cmd_tmp

            if idx == 0:
                instr_bits = instr_bits + get_bin(return_indices_of_a(muxA_list, cmd, 'muxA_list'), RCS_MUXA_BITS)
            elif idx == 1:
                instr_bits = instr_bits + get_bin(return_indices_of_a(muxB_list, cmd, 'muxB_list'), RCS_MUXB_BITS)
            elif idx == 2:
                instr_bits = instr_bits + get_bin(return_indices_of_a(ALU_op_list, cmd, 'ALU_op_list'), RCS_ALU_OP_BITS)
            elif idx == 3:
                instr_bits = instr_bits + get_bin(return_indices_of_a(reg_dest_list, cmd[0], 'reg_dest_list'), RCS_RF_WADD_BITS)
                instr_bits = instr_bits + get_bin(return_indices_of_a(reg_we_list, cmd[1], 'reg_we_list'), RCS_RF_WE_BITS)
            elif idx == 4:
                instr_bits = instr_bits + get_bin(return_indices_of_a(muxF_list, cmd, 'muxF_list'), RCS_MUXFLAG_BITS)
            elif idx == 5:
                instr_bits = instr_bits + int2bin(int(cmd), RCS_IMM_BITS)
                # print(int2bin(int(cmd), RCS_IMM_BITS))
                # print(cmd)
            else:
                print("ERROR: index overflow in instruction word")

        # rcs_logger.log_line(instr_bits)
        rcs_logger.log_line(hex(int(instr_bits,2)))
        # print(instr_bits)
        # print(hex(int(instr_bits,2)))
    # print()

