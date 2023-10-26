
//#define RUN_ON_FPGA

#include <stdio.h>
#include <healwearv.h>
#include <hv_cgra.h>
#include "stimuli.h"

#define kResults          (uint32_t *)0x0002FC00
#define kEventUnit        (uint32_t *)0x60000000

#define kEndApp         (uint32_t *)0x0002FFFC

// one dim slot x n input values (data ptrs, constants, ...)
int32_t cgra_input[4][10] __attribute__ ((aligned (4)));

int main(void) {

  uint32_t *pResults   = kResults;
  uint32_t *pEventUnit = kEventUnit;

#ifdef RUN_ON_FPGA
  uint32_t *pStatus_regs  = kStatus_regs;
  uint32_t *pPerfCnt_regs = kPerfCnt_regs;

  // Reset Status regs
  *pStatus_regs = 0x0;

  // Reset Perf Cnt
  *pPerfCnt_regs = 0x2;

  // Start Perf Cnt
  *pPerfCnt_regs = 0x1;
#else
  uint32_t *pEndApp    = kEndApp;
#endif

  // First sample index
  int32_t start  = INPUT_START;
  // Input vector size (circular buffer)
  int32_t mask   = INPUT_LENGTH-1;
  // Number of samples to check
  int32_t length = 400;

  int32_t max = stimuli[start], min = stimuli[start];

      for(int32_t i=1; i<length; i++) {
        if(stimuli[(start + i) & mask] > max) max=stimuli[(start + i) & mask];
        if(stimuli[(start + i) & mask] < min) min=stimuli[(start + i) & mask];  
    }

  // Select request slot of CGRA (4 slots)
  int32_t index = 0;
  int32_t cgra_reg;
  int32_t cgra_res[4] = {0, 0, 0, 0};

  cgra_input[index][0] = mask;
  cgra_input[index][1] = start;
  cgra_input[index][2] = length;
  cgra_input[index][3] = (uint32_t) &stimuli[0];

  // PROFILING START
  cgra_reg = APB_CGRA->CGRA_COL_STATUS;
  // CGRA_set_pointers_1_col(uint32_t rd_ptr, uint32_t wr_ptr, uint32_t c_id)
  CGRA_set_pointers_1_col((uint32_t) &cgra_input[0], (uint32_t) cgra_res, index);
  // CGRA_start(uint32_t ker_id, uint32_t c_id)
  CGRA_start(MIN_MAX_CIRC_KER_ID, 0);

  // __WFI();
  *pEventUnit = 0x1;

  // PROFILING STOP
  cgra_reg = APB_CGRA->CGRA_COL_STATUS;

  // Few cycles delay
  for(int i=0; i<5; i++);

  if (cgra_res[0] != max || cgra_res[1] != min)
  {
    *pResults++ = cgra_res[0];
    *pResults++ = max;
    *pResults++ = cgra_res[1];
    *pResults++ = min;
  } else 
  {
    *pResults = 1;
  }

  // End Simulation
  *pEndApp = 0x1;   
  while (1);

  return 0;
}
