// Generated register defines for cgra

// Copyright information found in source file:
// Copyright EPFL contributors.

// Licensing information found in source file:
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef _CGRA_REG_DEFS_
#define _CGRA_REG_DEFS_

#ifdef __cplusplus
extern "C" {
#endif
// Register width
#define CGRA_PARAM_REG_WIDTH 32

// CGRA columns status (0:free, 1:used)
#define CGRA_COL_STATUS_REG_OFFSET 0x0
#define CGRA_COL_STATUS_COL_STATUS_MASK 0xf
#define CGRA_COL_STATUS_COL_STATUS_OFFSET 0
#define CGRA_COL_STATUS_COL_STATUS_FIELD \
  ((bitfield_field32_t) { .mask = CGRA_COL_STATUS_COL_STATUS_MASK, .index = CGRA_COL_STATUS_COL_STATUS_OFFSET })

// Slot 0 kernel ID
#define CGRA_SLOT0_KER_ID_REG_OFFSET 0x4

// Slot 1 kernel ID
#define CGRA_SLOT1_KER_ID_REG_OFFSET 0x8

// Slot 0 input data pointer for first column used
#define CGRA_SLOT0_PTR_IN_C0_REG_OFFSET 0xc

// Slot 0 output data pointer for first column used
#define CGRA_SLOT0_PTR_OUT_C0_REG_OFFSET 0x10

// Slot 0 input data pointer for second column used
#define CGRA_SLOT0_PTR_IN_C1_REG_OFFSET 0x14

// Slot 0 Output data pointer for second column used
#define CGRA_SLOT0_PTR_OUT_C1_REG_OFFSET 0x18

// Slot 0 input data pointer for third column used
#define CGRA_SLOT0_PTR_IN_C2_REG_OFFSET 0x1c

// Slot 0 output data pointer for first column used
#define CGRA_SLOT0_PTR_OUT_C2_REG_OFFSET 0x20

// Slot 0 input data pointer for fourth column used
#define CGRA_SLOT0_PTR_IN_C3_REG_OFFSET 0x24

// Slot 1 output data pointer for fourth column used
#define CGRA_SLOT0_PTR_OUT_C3_REG_OFFSET 0x28

// Slot 1 input data pointer for first column used
#define CGRA_SLOT1_PTR_IN_C0_REG_OFFSET 0x2c

// Slot 1 output data pointer for first column used
#define CGRA_SLOT1_PTR_OUT_C0_REG_OFFSET 0x30

// Slot 1 input data pointer for second column used
#define CGRA_SLOT1_PTR_IN_C1_REG_OFFSET 0x34

// Slot 1 Output data pointer for second column used
#define CGRA_SLOT1_PTR_OUT_C1_REG_OFFSET 0x38

// Slot 1 input data pointer for third column used
#define CGRA_SLOT1_PTR_IN_C2_REG_OFFSET 0x3c

// Slot 1 output data pointer for first column used
#define CGRA_SLOT1_PTR_OUT_C2_REG_OFFSET 0x40

// Slot 1 input data pointer for fourth column used
#define CGRA_SLOT1_PTR_IN_C3_REG_OFFSET 0x44

// Slot 1 output data pointer for fourth column used
#define CGRA_SLOT1_PTR_OUT_C3_REG_OFFSET 0x48

// Enable performance counters
#define CGRA_PERF_CNT_ENABLE_REG_OFFSET 0x4c
#define CGRA_PERF_CNT_ENABLE_PERF_CNT_ENABLE_BIT 0

// Reset performance counters
#define CGRA_PERF_CNT_RESET_REG_OFFSET 0x50
#define CGRA_PERF_CNT_RESET_PERF_CNT_RESET_BIT 0

// Total number of kernels executed (all columns)
#define CGRA_PERF_CNT_TOTAL_KERNELS_REG_OFFSET 0x54

// Number of active cycles (configuration+execution)) of column 0
#define CGRA_PERF_CNT_C0_ACTIVE_CYCLES_REG_OFFSET 0x58

// Number of stall cycles during execution of column 0
#define CGRA_PERF_CNT_C0_STALL_CYCLES_REG_OFFSET 0x5c

// Number of active cycles (configuration+execution)) of column 1
#define CGRA_PERF_CNT_C1_ACTIVE_CYCLES_REG_OFFSET 0x60

// Number of stall cycles during execution of column 1
#define CGRA_PERF_CNT_C1_STALL_CYCLES_REG_OFFSET 0x64

// Number of active cycles (configuration+execution) )of column 2
#define CGRA_PERF_CNT_C2_ACTIVE_CYCLES_REG_OFFSET 0x68

// Number of stall cycles during execution of column 2
#define CGRA_PERF_CNT_C2_STALL_CYCLES_REG_OFFSET 0x6c

// Number of active cycles (configuration+execution) of column 3
#define CGRA_PERF_CNT_C3_ACTIVE_CYCLES_REG_OFFSET 0x70

// Number of stall cycles during execution of column 3
#define CGRA_PERF_CNT_C3_STALL_CYCLES_REG_OFFSET 0x74

// Reserved
#define CGRA_RESERVED30_REG_OFFSET 0x78

// Reserved
#define CGRA_RESERVED31_REG_OFFSET 0x7c

#ifdef __cplusplus
}  // extern "C"
#endif
#endif  // _CGRA_REG_DEFS_
// End generated register defines for cgra