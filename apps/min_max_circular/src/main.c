// Copyright EPFL contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

/* Function performing max and min search in a subset of a circular buffer */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#include "stimuli.h"

int main(int argc, char **argv) {

  // First sample index
  int32_t start  = INPUT_START;
  // Input vector size (circular buffer)
  int32_t mask   = INPUT_LENGTH-1;
  // Number of samples to check
  int32_t length = 400;

  int32_t max = stimuli[start], min = stimuli[start];

      for(int32_t i=1; i<length; i++) {
        if (stimuli[(start + i) & mask] > max) {
          max=stimuli[(start + i) & mask];
        }
        if (stimuli[(start + i) & mask] < min) {
          min=stimuli[(start + i) & mask];  
        }
    }

  printf("Maximum value checking %d values starting from index %d is %d \n", length, INPUT_START, max);
  printf("Minimum value checking %d values starting from index %d is %d \n", length, INPUT_START, min);

  return 0;
}
