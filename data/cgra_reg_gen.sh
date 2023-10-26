# Copyright EPFL contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

echo "Generating CGRA Register RTL"
python3 ../utilities/lowrisc_opentitan/regtool.py -r -t ../rtl cgra_regs.hjson
echo "Generating CGRA Register SW"
python3 ../utilities/lowrisc_opentitan/regtool.py  --cdefines -o ../sw/cgra_regs.h cgra_regs.hjson
