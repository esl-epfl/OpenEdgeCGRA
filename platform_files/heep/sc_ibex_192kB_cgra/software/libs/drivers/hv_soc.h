////////////////////////////////////////////////////////////////////////////////
//                                                                            //
// Author:         Benoît Denkinger - benoit.denkinger@epfl.ch                //
//                                                                            //
// Additional contributions by:                                               //
//                 Name Surname - email (affiliation if not ESL)              //
//                                                                            //
// File Name:      hv_soc.h                                                   //
//                                                                            //
// Project Name:   HealWear-V                                                 //
//                                                                            //
// Language:       C                                                          //
//                                                                            //
// Description:    SoC header file                                            //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

#ifndef _HV_SOC_H_
#define _HV_SOC_H_

#include <stdint.h>

#define APB_CGRA_ADDR            0x50000000UL
#define APB_CGRA_MASK            0xFFFFFF80UL

typedef struct {

  volatile uint32_t CORE_0_KER_ID;
  volatile uint32_t CORE_1_KER_ID;
  volatile uint32_t CORE_2_KER_ID;
  volatile uint32_t CORE_3_KER_ID;
  
  volatile uint32_t POINTER_DATA_IN_P0_COL0;
  volatile uint32_t POINTER_DATA_OUT_P0_COL0;
  volatile uint32_t POINTER_DATA_IN_P0_COL1;
  volatile uint32_t POINTER_DATA_OUT_P0_COL1;

  volatile uint32_t POINTER_DATA_IN_P1_COL0;
  volatile uint32_t POINTER_DATA_OUT_P1_COL0;
  volatile uint32_t POINTER_DATA_IN_P1_COL1;
  volatile uint32_t POINTER_DATA_OUT_P1_COL1;

  volatile uint32_t POINTER_DATA_IN_P2_COL0;
  volatile uint32_t POINTER_DATA_OUT_P2_COL0;
  volatile uint32_t POINTER_DATA_IN_P2_COL1;
  volatile uint32_t POINTER_DATA_OUT_P2_COL1;

  volatile uint32_t POINTER_DATA_IN_P3_COL0;
  volatile uint32_t POINTER_DATA_OUT_P3_COL0;
  volatile uint32_t POINTER_DATA_IN_P3_COL1;
  volatile uint32_t POINTER_DATA_OUT_P3_COL1;

  volatile uint32_t RESERVED20;
  volatile uint32_t RESERVED21;
  volatile uint32_t RESERVED22;
  volatile uint32_t RESERVED23;
  volatile uint32_t RESERVED24;
  volatile uint32_t RESERVED25;
  volatile uint32_t RESERVED26;
  volatile uint32_t RESERVED27;
  volatile uint32_t RESERVED28;
  volatile uint32_t RESERVED29;
  volatile uint32_t RESERVED30;

  volatile uint32_t CGRA_COL_STATUS;

} APB_CGRA_t;

#define APB_CGRA                 ((APB_CGRA_t *) APB_CGRA_ADDR)

#endif // _HV_SOC_H_
