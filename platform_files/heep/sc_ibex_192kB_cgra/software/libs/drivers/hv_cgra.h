////////////////////////////////////////////////////////////////////////////////
//                                                                            //
// Author:         Benoît Denkinger - benoit.denkinger@epfl.ch                //
//                                                                            //
// Additional contributions by:                                               //
//                 Name Surname - email (affiliation if not ESL)              //
//                                                                            //
// File Name:      hv_cgra.h                                                  //
//                                                                            //
// Project Name:   HealWear-V                                                 //
//                                                                            //
// Language:       C                                                          //
//                                                                            //
// Description:    CGRA functions header file                                 //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

#ifndef _HV_CGRA_H_
#define _HV_CGRA_H_

#include <hv_soc.h>

static inline void CGRA_set_pointers_1_col(uint32_t rd_ptr, uint32_t wr_ptr, uint32_t c_id){

  // TODO : check input values are ok!

  // Write read/write pointers
  if(c_id == 0) {
    APB_CGRA ->POINTER_DATA_IN_P0_COL0  = rd_ptr;
    APB_CGRA ->POINTER_DATA_OUT_P0_COL0 = wr_ptr;
  }
  else if(c_id == 1) {
    APB_CGRA ->POINTER_DATA_IN_P1_COL0  = rd_ptr;
    APB_CGRA ->POINTER_DATA_OUT_P1_COL0 = wr_ptr;
  }
  else if(c_id == 2) {
    APB_CGRA ->POINTER_DATA_IN_P2_COL0  = rd_ptr;
    APB_CGRA ->POINTER_DATA_OUT_P2_COL0 = wr_ptr;
  }
  else if(c_id == 3) {
    APB_CGRA ->POINTER_DATA_IN_P3_COL0  = rd_ptr;
    APB_CGRA ->POINTER_DATA_OUT_P3_COL0 = wr_ptr;
  }
}

static inline void CGRA_start(uint32_t ker_id, uint32_t c_id){

  if(c_id == 0)
    APB_CGRA ->CORE_0_KER_ID = ker_id;
  else if(c_id == 1)
    APB_CGRA ->CORE_1_KER_ID = ker_id;
  else if(c_id == 2)
    APB_CGRA ->CORE_2_KER_ID = ker_id;
  else if(c_id == 3)
    APB_CGRA ->CORE_3_KER_ID = ker_id;
}


/*
 *
 * KERNEL_ID : 0
 * NULL ID
 *
 * KERNEL_ID : 1
 * DBL_MIN_KER_ID KERNEL
 *
 * KERNEL_ID : 2
 * DBL_MAX_KER_ID KERNEL
 *
 * KERNEL_ID : 3
 * DBL_MAX_KER_ID KERNEL
 *
 * KERNEL_ID : 4
 * MIN_MAX_CIRC_KER_ID KERNEL
*/

// Kernel 0 => NULL
#define DBL_MIN_KER_ID      1
#define DBL_MAX_KER_ID      2
#define MAX_PEAK_KER_ID     3
#define MIN_MAX_CIRC_KER_ID 4

#endif // _HV_CGRA_H_
