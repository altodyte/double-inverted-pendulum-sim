#include "__cf_IDP.h"
#ifndef RTW_HEADER_IDP_acc_h_
#define RTW_HEADER_IDP_acc_h_
#ifndef IDP_acc_COMMON_INCLUDES_
#define IDP_acc_COMMON_INCLUDES_
#include <stdlib.h>
#include <stddef.h>
#define S_FUNCTION_NAME simulink_only_sfcn 
#define S_FUNCTION_LEVEL 2
#define RTW_GENERATED_S_FUNCTION
#include "rtwtypes.h"
#include "simstruc.h"
#include "fixedpoint.h"
#include "rt_defines.h"
#include "rt_nonfinite.h"
#endif
#include "IDP_acc_types.h"
typedef struct { real_T B_0_0_0 [ 2 ] ; real_T B_0_0_1 ; real_T B_0_2_0 [ 3 ]
; real_T B_0_3_0 ; real_T B_0_4_0 ; } BlockIO_IDP ; typedef struct { void *
Block1_PWORK ; void * Block2_PWORK ; void * Block3_PWORK ; int_T Block1_IWORK
; int_T Block3_IWORK ; char pad_Block3_IWORK [ 4 ] ; } D_Work_IDP ; typedef
struct { real_T Block1_CSTATE [ 2 ] ; } ContinuousStates_IDP ; typedef struct
{ real_T Block1_CSTATE [ 2 ] ; } StateDerivatives_IDP ; typedef struct {
boolean_T Block1_CSTATE [ 2 ] ; } StateDisabled_IDP ; struct Parameters_IDP_
{ real_T P_0 [ 2 ] ; real_T P_1 [ 34 ] ; real_T P_2 [ 3 ] ; real_T P_3 ; } ;
extern Parameters_IDP IDP_rtDefaultParameters ;
#endif
