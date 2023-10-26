////////////////////////////////////////////////////////////////////////////////
//                                                                            //
// Author:         Benoît Denkinger - benoit.denkinger@epfl.ch                //
//                                                                            //
// Additional contributions by:                                               //
//                 Name Surname - email (affiliation if not ESL)              //
//                                                                            //
// File Name:      hv_cgra.c                                                  //
//                                                                            //
// Project Name:   HealWear-V                                                 //
//                                                                            //
// Language:       C                                                          //
//                                                                            //
// Description:    CGRA functions source file                                 //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

#include "hv_cgra.h"

// void CGRA_set_pointers_1_col(uint32_t rd_ptr, uint32_t wr_ptr, uint32_t c_id){

//   // TODO : check input values are ok!

//   // Write read/write pointers
//   if(c_id == 0) {
//     APB_CGRA ->POINTER_DATA_IN_P0_COL0  = rd_ptr;
//     APB_CGRA ->POINTER_DATA_OUT_P0_COL0 = wr_ptr;
//   }
//   else if(c_id == 1) {
//     APB_CGRA ->POINTER_DATA_IN_P1_COL0  = rd_ptr;
//     APB_CGRA ->POINTER_DATA_OUT_P1_COL0 = wr_ptr;
//   }
//   else if(c_id == 2) {
//     APB_CGRA ->POINTER_DATA_IN_P2_COL0  = rd_ptr;
//     APB_CGRA ->POINTER_DATA_OUT_P2_COL0 = wr_ptr;
//   }
//   else if(c_id == 3) {
//     APB_CGRA ->POINTER_DATA_IN_P3_COL0  = rd_ptr;
//     APB_CGRA ->POINTER_DATA_OUT_P3_COL0 = wr_ptr;
//   }
// }

// void CGRA_start(uint32_t ker_id, uint32_t c_id){

//   if(c_id == 0)
//     APB_CGRA ->CORE_0_KER_ID = ker_id;
//   else if(c_id == 1)
//     APB_CGRA ->CORE_1_KER_ID = ker_id;
//   else if(c_id == 2)
//     APB_CGRA ->CORE_2_KER_ID = ker_id;
//   else if(c_id == 3)
//     APB_CGRA ->CORE_3_KER_ID = ker_id;
// }
