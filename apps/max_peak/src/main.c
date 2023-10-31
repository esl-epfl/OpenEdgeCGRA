// Copyright EPFL contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

/* Function performing max search (value and index) */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#include "stimuli.h"

int main(int argc, char **argv) {

  int32_t start = INPUT_START;
  int32_t end   = INPUT_LENGTH-1;

  int32_t i;
  int32_t maxpeakI = start;
  int32_t maxpeakV = 0;


  for(i=start+1; i<end; i++) {
    if(stimuli[i]>maxpeakV && stimuli[i]>=stimuli[i+1] && stimuli[i]>=stimuli[i-1]) {
      maxpeakI = i;
      maxpeakV = stimuli[i];
    }
  }

  printf("Maximum value is %d at index %d\n", maxpeakV, maxpeakI);

  return 0;
}
