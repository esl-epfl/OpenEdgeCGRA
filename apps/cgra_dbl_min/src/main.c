
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

  int32_t kernel_res[4]    = {0, 0, 0, 0};
  int32_t cgra_res[4]      = {0, 0, 0, 0};
  int32_t length           = INPUT_LENGTH;

  kernel_res[0] = stimuli[0];
  kernel_res[1] = INT32_MAX;
  kernel_res[2] = 0;
  kernel_res[3] = -1;

  for(int32_t i=1; i<length; i++) {
    if (stimuli[i] < kernel_res[0]) {
      kernel_res[1] = kernel_res[0];
      kernel_res[0] = stimuli[i] ;
      kernel_res[3] = kernel_res[2];
      kernel_res[2] = i;
    } else if (stimuli[i] < kernel_res[1]) {
      kernel_res[1] = stimuli[i];
      kernel_res[3] = i;
    }
  }

  // Select request slot of CGRA (4 slots)
  int32_t index = 0;
  int32_t cgra_reg;
  // input data ptr
  cgra_input[index][0] = (int32_t)&stimuli[0];
  // input size
  cgra_input[index][1] = length-1;
  // PROFILING START
  cgra_reg = APB_CGRA->CGRA_COL_STATUS;
  // CGRA_set_pointers_1_col(uint32_t rd_ptr, uint32_t wr_ptr, uint32_t c_id)
  CGRA_set_pointers_1_col((uint32_t) cgra_input[0], (uint32_t) cgra_res, index);
  // CGRA_start(uint32_t ker_id, uint32_t c_id)
  CGRA_start(DBL_MIN_KER_ID, 0);

  // __WFI();
  *pEventUnit = 0x1;

  // PROFILING STOP
  cgra_reg = APB_CGRA->CGRA_COL_STATUS;

  // Few cycles delay
  for(int i=0; i<5; i++);

  if (cgra_res[0] != kernel_res[0] || cgra_res[1] != kernel_res[1] ||
      cgra_res[2] != kernel_res[2] || cgra_res[3] != kernel_res[3]) 
  {
    *pResults++ = cgra_res[0];
    *pResults++ = kernel_res[0];
    *pResults++ = cgra_res[1];
    *pResults++ = kernel_res[1];
    *pResults++ = cgra_res[2];
    *pResults++ = kernel_res[2];
    *pResults++ = cgra_res[3];
    *pResults++ = kernel_res[3];
  } else 
  {
    *pResults = 1;
  }

  // End Simulation
  *pEndApp = 0x1;   
  while (1);

  return 0;
}
