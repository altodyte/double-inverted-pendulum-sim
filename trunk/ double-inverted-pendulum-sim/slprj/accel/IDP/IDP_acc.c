#include "__cf_IDP.h"
#include <math.h>
#include "IDP_acc.h"
#include "IDP_acc_private.h"
#include <stdio.h>
#include "simstruc.h"
#include "fixedpoint.h"
#define CodeFormat S-Function
#define AccDefine1 Accelerator_S-Function
static void mdlOutputs ( SimStruct * S , int_T tid ) { BlockIO_IDP * _rtB ;
Parameters_IDP * _rtP ; D_Work_IDP * _rtDW ; _rtDW = ( ( D_Work_IDP * )
ssGetRootDWork ( S ) ) ; _rtP = ( ( Parameters_IDP * ) ssGetDefaultParam ( S
) ) ; _rtB = ( ( BlockIO_IDP * ) _ssGetBlockIO ( S ) ) ; ssCallAccelRunBlock
( S , 0 , 0 , SS_CALL_MDL_OUTPUTS ) ; if ( ssIsSampleHit ( S , 1 , 0 ) ) {
_rtB -> B_0_2_0 [ 0 ] = _rtP -> P_3 * _rtP -> P_2 [ 0 ] ; _rtB -> B_0_2_0 [ 1
] = _rtP -> P_3 * _rtP -> P_2 [ 1 ] ; _rtB -> B_0_2_0 [ 2 ] = _rtP -> P_3 *
_rtP -> P_2 [ 2 ] ; } ssCallAccelRunBlock ( S , 0 , 3 , SS_CALL_MDL_OUTPUTS )
; ssCallAccelRunBlock ( S , 0 , 4 , SS_CALL_MDL_OUTPUTS ) ; UNUSED_PARAMETER
( tid ) ; }
#define MDL_UPDATE
static void mdlUpdate ( SimStruct * S , int_T tid ) { BlockIO_IDP * _rtB ;
D_Work_IDP * _rtDW ; _rtDW = ( ( D_Work_IDP * ) ssGetRootDWork ( S ) ) ; _rtB
= ( ( BlockIO_IDP * ) _ssGetBlockIO ( S ) ) ; ssCallAccelRunBlock ( S , 0 , 0
, SS_CALL_MDL_UPDATE ) ; ssCallAccelRunBlock ( S , 0 , 3 , SS_CALL_MDL_UPDATE
) ; ssCallAccelRunBlock ( S , 0 , 4 , SS_CALL_MDL_UPDATE ) ; UNUSED_PARAMETER
( tid ) ; }
#define MDL_DERIVATIVES
static void mdlDerivatives ( SimStruct * S ) { BlockIO_IDP * _rtB ;
D_Work_IDP * _rtDW ; _rtDW = ( ( D_Work_IDP * ) ssGetRootDWork ( S ) ) ; _rtB
= ( ( BlockIO_IDP * ) _ssGetBlockIO ( S ) ) ; ssCallAccelRunBlock ( S , 0 , 0
, SS_CALL_MDL_DERIVATIVES ) ; }
#define MDL_PROJECTION
static void mdlProjection ( SimStruct * S ) { BlockIO_IDP * _rtB ; D_Work_IDP
* _rtDW ; _rtDW = ( ( D_Work_IDP * ) ssGetRootDWork ( S ) ) ; _rtB = ( (
BlockIO_IDP * ) _ssGetBlockIO ( S ) ) ; ssCallAccelRunBlock ( S , 0 , 0 ,
SS_CALL_MDL_PROJECTION ) ; } static void mdlInitializeSizes ( SimStruct * S )
{ ssSetChecksumVal ( S , 0 , 3491810292U ) ; ssSetChecksumVal ( S , 1 ,
1236675493U ) ; ssSetChecksumVal ( S , 2 , 4252415420U ) ; ssSetChecksumVal (
S , 3 , 454885752U ) ; { mxArray * slVerStructMat = NULL ; mxArray * slStrMat
= mxCreateString ( "simulink" ) ; char slVerChar [ 10 ] ; int status =
mexCallMATLAB ( 1 , & slVerStructMat , 1 , & slStrMat , "ver" ) ; if ( status
== 0 ) { mxArray * slVerMat = mxGetField ( slVerStructMat , 0 , "Version" ) ;
if ( slVerMat == NULL ) { status = 1 ; } else { status = mxGetString (
slVerMat , slVerChar , 10 ) ; } } mxDestroyArray ( slStrMat ) ;
mxDestroyArray ( slVerStructMat ) ; if ( ( status == 1 ) || ( strcmp (
slVerChar , "7.9" ) != 0 ) ) { return ; } } ssSetOptions ( S ,
SS_OPTION_EXCEPTION_FREE_CODE ) ; if ( ssGetSizeofDWork ( S ) != sizeof (
D_Work_IDP ) ) { ssSetErrorStatus ( S ,
"Unexpected error: Internal DWork sizes do "
"not match for accelerator mex file." ) ; } if ( ssGetSizeofGlobalBlockIO ( S
) != sizeof ( BlockIO_IDP ) ) { ssSetErrorStatus ( S ,
"Unexpected error: Internal BlockIO sizes do "
"not match for accelerator mex file." ) ; } { int ssSizeofParams ;
ssGetSizeofParams ( S , & ssSizeofParams ) ; if ( ssSizeofParams != sizeof (
Parameters_IDP ) ) { static char msg [ 256 ] ; sprintf ( msg ,
"Unexpected error: Internal Parameters sizes do "
"not match for accelerator mex file." ) ; } } _ssSetDefaultParam ( S , (
real_T * ) & IDP_rtDefaultParameters ) ; rt_InitInfAndNaN ( sizeof ( real_T )
) ; } static void mdlInitializeSampleTimes ( SimStruct * S ) { } static void
mdlTerminate ( SimStruct * S ) { }
#include "simulink.c"
