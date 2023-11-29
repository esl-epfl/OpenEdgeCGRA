// Copyright EPFL contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

{ name: "cgra",
  clock_primary: "clk_i",
  bus_interfaces: [
    { protocol: "reg_iface", direction: "device" }
  ],
  regwidth: "32",
  registers: [
    { name:     "COL_STATUS",
      desc:     "CGRA columns status (0:free, 1:used)",
      swaccess: "ro",
      hwaccess: "hrw",
      resval:   0, // all column free
      fields: [
        { bits: "${cgra_num_columns-1}:0", name: "COL_STATUS", desc: "CGRA columns status (0:free, 1:used)" }
      ]
    },
    { name:     "KERNEL_ID",
      desc:     "Kernel ID acceleration request",
      swaccess: "rw",
      hwaccess: "hrw",
      fields: [
        { bits: "31:0", name: "KERNEL_ID", desc: "Kernel ID acceleration request" }
      ]
    },

  % for col in range(cgra_max_columns):
    { name:     "PTR_IN_COL_${col}",
      desc:     "Input data pointer for column ${col} used",
      swaccess: "rw",
      hwaccess: "hro",
      fields: [
        { bits: "31:0", name: "PTR_IN_C${col}", desc: "Input data pointer for column ${col} used" }
      ]
    },
    { name:     "PTR_OUT_COL_${col}",
      desc:     "Output data pointer for column ${col} used",
      swaccess: "rw",
      hwaccess: "hro",
      fields: [
        { bits: "31:0", name: "PTR_OUT_COL_${col}", desc: "Output data pointer for column ${col} used" }
      ]
    },
  % endfor

    { name:     "PERF_CNT_ENABLE",
      desc:     "Enable performance counters",
      swaccess: "rw",
      hwaccess: "hro",
      fields: [
        { bits: "0", name: "PERF_CNT_ENABLE", desc: "Enable performance counters" }
      ]
    },
    { name:     "PERF_CNT_RESET",
      desc:     "Reset performance counters",
      swaccess: "rw",
      hwaccess: "hrw",
      fields: [
        { bits: "0", name: "PERF_CNT_RESET", desc: "Reset performance counters" }
      ]
    },
    { name:     "PERF_CNT_TOTAL_KERNELS",
      desc:     "Total number of kernels executed (all columns)",
      swaccess: "rw",
      hwaccess: "hrw",
      fields: [
        { bits: "31:0", name: "PERF_CNT_TOTAL_KERNELS", desc: "Total number of kernels executed" }
      ]
    },

  % for col in range(cgra_num_columns):
    { name:     "PERF_CNT_COL_${col}_ACTIVE_CYCLES",
      desc:     "Number of active cycles (configuration+execution)) of column ${col}",
      swaccess: "rw",
      hwaccess: "hrw",
      fields: [
        { bits: "31:0", name: "PERF_CNT_COL_${col}_ACTIVE_CYCLES", desc: "Number of active cycles (configuration+execution)) of column ${col}" }
      ]
    },
    { name:     "PERF_CNT_COL_${col}_STALL_CYCLES",
      desc:     "Number of stall cycles during execution of column ${col}",
      swaccess: "rw",
      hwaccess: "hrw",
      fields: [
        { bits: "31:0", name: "PERF_CNT_COL_${col}_STALL_CYCLES", desc: "Number of stall cycles during execution of column ${col}" }
      ]
    },
  % endfor
   ]
}
