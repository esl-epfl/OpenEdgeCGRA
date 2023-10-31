// Copyright EPFL contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

/* Function performing a double maximum search (values and indexes) */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#include "stimuli.h"

int main(int argc, char **argv) {

  int32_t kernel_res[4]    = {0, 0, 0, 0};
  int32_t length           = INPUT_LENGTH;

  kernel_res[0] = stimuli[0];
  kernel_res[1] = INT32_MIN;
  kernel_res[2] = 0;
  kernel_res[3] = -1;

  for(int32_t i=1; i<length; i++) {
    if (stimuli[i] > kernel_res[0]) {
      kernel_res[1] = kernel_res[0];
      kernel_res[0] = stimuli[i] ;
      kernel_res[3] = kernel_res[2];
      kernel_res[2] = i;
    } else if (stimuli[i] > kernel_res[1]) {
      kernel_res[1] = stimuli[i];
      kernel_res[3] = i;
    }
  }

  printf("First maximum value is %d at index %d\n", kernel_res[0], kernel_res[2]);
  printf("Second maximum value is %d at index %d\n", kernel_res[1], kernel_res[3]);

  return 0;
}
