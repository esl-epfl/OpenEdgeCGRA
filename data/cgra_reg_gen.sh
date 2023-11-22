# Copyright EPFL contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

echo "Generating RTL"
${PYTHON} ../util/lowrisc_opentitan/regtool.py -r -t ../hw/rtl ./cgra_regs.hjson
echo "Generating SW"
mkdir -p ../sw
${PYTHON} ../util/lowrisc_opentitan/regtool.py --cdefines -o ../sw/cgra_regs.h ./cgra_regs.hjson
