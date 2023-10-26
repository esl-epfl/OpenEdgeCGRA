
//#define RUN_ON_FPGA

#include <stdio.h>
#include <healwearv.h>
#include <hv_cgra.h>
#include "stimuli.h"

#define kResults          (uint32_t *)0x0002FC00
#define kEventUnit        (uint32_t *)0x60000000

#define kEndApp         (uint32_t *)0x0002FFFC

// one dim slot x n input values (data ptrs, constants, ...)
// int32_t cgra_input[4][10] __attribute__ ((aligned (4)));

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

  int32_t start = INPUT_START;
  int32_t end   = INPUT_LENGTH-1;

  int32_t i;
  int32_t maxpeakI = start;
  int32_t maxpeakV = 0;

  // First value is replaced by length
  if(end<start || start<1) {
    // End Simulation
    *pResults = 0;
    *pEndApp = 0x1;   
    while (1);
  }

  for(i=start+1;i<end;i++){
    if(stimuli[i]>maxpeakV && stimuli[i]>=stimuli[i+1] && stimuli[i]>=stimuli[i-1]){
      maxpeakI = i;
      maxpeakV = stimuli[i];
    }
  }

  // Select request slot of CGRA (4 slots)
  int32_t index = 0;
  int32_t cgra_reg;
  int32_t cgra_res[4] = {0, 0, 0, 0};
  // CGRA expect first value to be loop length
  stimuli[INPUT_START-1] = end-start;

  // PROFILING START
  cgra_reg = APB_CGRA->CGRA_COL_STATUS;
  // CGRA_set_pointers_1_col(uint32_t rd_ptr, uint32_t wr_ptr, uint32_t c_id)
  CGRA_set_pointers_1_col((uint32_t) &stimuli[INPUT_START-1], (uint32_t) cgra_res, index);
  // CGRA_start(uint32_t ker_id, uint32_t c_id)
  CGRA_start(MAX_PEAK_KER_ID, 0);

  // __WFI();
  *pEventUnit = 0x1;

  // PROFILING STOP
  cgra_reg = APB_CGRA->CGRA_COL_STATUS;

  // CGRA counts from zero. Index start offset is added here
  cgra_res[0] += INPUT_START;

  // Few cycles delay
  for(int i=0; i<5; i++);

  if (cgra_res[0] != maxpeakI || cgra_res[1] != maxpeakV)
  {
    *pResults++ = cgra_res[0];
    *pResults++ = maxpeakI;
    *pResults++ = cgra_res[1];
    *pResults++ = maxpeakV;
  } else 
  {
    *pResults = 1;
  }

  // End Simulation
  *pEndApp = 0x1;   
  while (1);

  return 0;
}
