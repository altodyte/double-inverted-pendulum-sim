# Copyright 1994-2010 The MathWorks, Inc.
#
# File    : accel_lcc.tmf   $Revision: 1.19.4.28 $
#
# Abstract:
#	Accelerator template makefile for building a PC-based,
#       generated mex-file of Simulink model using generated C code. 
#	     LCC compiler version 2.4.
#
# 	This makefile attempts to conform to the guidelines specified in the
# 	IEEE Std 1003.2-1992 (POSIX) standard. It is designed to be used
#       with GNU Make (gmake) which is located in matlabroot/bin/win32.
#
# 	Note that this template is automatically customized by the Real-Time
#	Workshop build procedure to create "<model>.mk"
#
#       The following defines can be used to modify the behavior of the
#	build:
#
#         MEX_OPTS       - User specific mex options.
#	  OPT_OPTS       - Optimization options. Default is none. To enable 
#                          debugging specify as OPT_OPTS=-g. 
#	  USER_SRCS      - Additional user sources, such as files needed by
#			   S-functions.
#	  USER_INCLUDES  - Additional include paths
#			   (i.e. USER_INCLUDES="-Iwhere-ever -Iwhere-ever2")
#			   (For Lcc, have a '/'as file seperator before the 
#			   file name instead of a '\' . 
#			   i.e.,  d:\work\proj1/myfile.c - reqd for 'gmake')
#
#       This template makefile is designed to be used with a system target
#       file that contains 'rtwgensettings.BuildDirSuffix' see accel.tlc

#------------------------ Macros read by make_rtw ------------------------------
#
# The following macros are read by the build procedure:
#
#  MAKECMD         - This is the command used to invoke the make utility
#  HOST            - What platform this template makefile is targeted for
#                    (i.e. PC or UNIX)
#  BUILD           - Invoke make from the build procedure (yes/no)?
#  SYS_TARGET_FILE - Name of system target file.

MAKECMD         = "%MATLAB%\bin\win32\gmake"
SHELL           = cmd
HOST            = PC
BUILD           = yes
SYS_TARGET_FILE = accel.tlc
COMPILER_TOOL_CHAIN = lcc

MAKEFILE_FILESEP = /

#---------------------- Tokens expanded by make_rtw ----------------------------
#
# The following tokens, when wrapped with "|>" and "<|" are expanded by the
# build procedure.
#
#  MODEL_NAME      - Name of the Simulink block diagram
#  MODEL_MODULES   - Any additional generated source modules
#  MAKEFILE_NAME   - Name of makefile created from template makefile <model>.mk
#  MATLAB_ROOT     - Path to where MATLAB is installed.
#  MATLAB_BIN      - Path to MATLAB executable.
#  S_FUNCTIONS     - List of S-functions.
#  S_FUNCTIONS_LIB - List of S-functions libraries to link.
#  SOLVER          - Solver source file name
#  NUMST           - Number of sample times
#  TID01EQ         - yes (1) or no (0): Are sampling rates of continuous task
#                    (tid=0) and 1st discrete task equal.
#  NCSTATES        - Number of continuous states
#  BUILDARGS       - Options passed in at the command line.
#  MEXEXT          - extension that a mex file has. See the MATLAB mexext 
#                    command

MODEL              = IDP
MODULES            = IDP_acc_data.c rtGetInf.c rtGetNaN.c rt_nonfinite.c 
MAKEFILE           = IDP.mk
MATLAB_ROOT        = C:/Program Files (x86)/MATLAB/R2012a.x32
ALT_MATLAB_ROOT    = C:/PROGRA~2/MATLAB/R2012a.x32
MASTER_ANCHOR_DIR  = 
START_DIR          = C:/Users/wwarner/Documents/S5/Dynamics/Project
MATLAB_BIN         = C:/Program Files (x86)/MATLAB/R2012a.x32/bin
ALT_MATLAB_BIN     = C:/PROGRA~2/MATLAB/R2012a.x32/bin
S_FUNCTIONS        = mech_engine.c
S_FUNCTIONS_LIB    = 
SOLVER             = ode45.c
NUMST              = 2
TID01EQ            = 0
NCSTATES           = 2
MEM_ALLOC          = RT_STATIC
BUILDARGS          =  GENERATE_REPORT=0
MEXEXT             = mexw32

MODELREFS          = 
SHARED_SRC         = 
SHARED_SRC_DIR     = 
SHARED_BIN_DIR     = 
SHARED_LIB         = 
MEX_OPT_FILE       = -f $(MATLAB_BIN)/win32/mexopts/lccopts.bat
OPTIMIZATION_FLAGS = -DNDEBUG
ADDITIONAL_LDFLAGS = 

#--------------------------- Model and reference models -----------------------
MODELLIB                  = IDPlib.lib
MODELREF_LINK_LIBS        = 
MODELREF_INC_PATH         = 
RELATIVE_PATH_TO_ANCHOR   = ../../..
MODELREF_TARGET_TYPE      = NONE

#-- In the case when directory name contains space ---
ifneq ($(MATLAB_ROOT),$(ALT_MATLAB_ROOT))
MATLAB_ROOT := $(ALT_MATLAB_ROOT)
endif
ifneq ($(MATLAB_BIN),$(ALT_MATLAB_BIN))
MATLAB_BIN := $(ALT_MATLAB_BIN)
endif

#--------------------------- Tool Specifications ------------------------------

LCC = $(MATLAB_ROOT)\sys\lcc
include $(MATLAB_ROOT)\rtw\c\tools\lcctools.mak

MEX = $(MATLAB_BIN)\mex.bat
CC  = $(MATLAB_BIN)\mex.bat -c

#------------------------------ Include Path -----------------------------------

# Additional includes

ADD_INCLUDES = \
	-I$(START_DIR)/slprj/accel/IDP \
	-I$(START_DIR) \
	-I$(MATLAB_ROOT)/toolbox/physmod/mech/c \
	-I$(MATLAB_ROOT)/toolbox/physmod/common/foundation/core/c \


# see MATLAB_INCLUES and COMPILER_INCLUDES from lcctool.mak

SHARED_INCLUDES =
ifneq ($(SHARED_SRC_DIR),)
SHARED_INCLUDES = -I$(SHARED_SRC_DIR) 
endif

INCLUDES = -I. -I$(RELATIVE_PATH_TO_ANCHOR) $(MATLAB_INCLUDES) $(ADD_INCLUDES) \
           $(COMPILER_INCLUDES) $(USER_INCLUDES) $(MODELREF_INC_PATH) $(SHARED_INCLUDES)

#------------------------ C and MEX optimization options -----------------------
MEX_OPTS  =
OPT_OPTS  = $(DEFAULT_OPT_OPTS)

ifneq ($(ADDITIONAL_LDFLAGS),)
MEX_LDFLAGS = LINKFLAGS="$$LINKFLAGS $(ADDITIONAL_LDFLAGS)"
else
MEX_LDFLAGS =
endif

ifneq ($(OPTIMIZATION_FLAGS),)
MEX_OPT_OPTS = OPTIMFLAGS="$(OPTIMIZATION_FLAGS)"    # passed to 'mex -c'
else
MEX_OPT_OPTS = $(OPT_OPTS)    # passed to 'mex -c'
endif

ifeq "$(MEX_OPTS)" "-g"
MEX_OPT_OPTS =
endif

#-------------------------------- Mex Options  ---------------------------------
MEX_FLAGS = -win32 $(MEX_OPT_OPTS) $(MEX_LDFLAGS) $(MEX_OPTS) $(MEX_OPT_FILE)

#----------------------------- Source Files -----------------------------------
USER_SRCS =

USER_OBJS       = $(USER_SRCS:.c=.obj)
LOCAL_USER_OBJS = $(notdir $(USER_OBJS))

SRCS      = $(MODEL)_acc.c $(MODULES)
OBJS      = $(SRCS:.c=.obj) $(USER_OBJS)
LINK_OBJS = $(SRCS:.c=.obj) $(LOCAL_USER_OBJS)

SHARED_OBJS := $(addsuffix .obj, $(basename $(wildcard $(SHARED_SRC))))
FMT_SHARED_OBJS = $(subst /,\,$(SHARED_OBJS))

#------------------------- Additional Libraries -------------------------------

LIBS =

ifeq ($(OPT_OPTS),$(DEFAULT_OPT_OPTS))
LIBS += $(MATLAB_ROOT)/toolbox/physmod/mech/lib/win32\mech_rtwsfcn_lcc.lib
else
LIBS += mech.lib
endif

ifeq ($(OPT_OPTS),$(DEFAULT_OPT_OPTS))
LIBS += $(MATLAB_ROOT)/toolbox/physmod/common/foundation/core/lib/win32\pm_rtwsfcn_lcc.lib
else
LIBS += pm.lib
endif



LIBUT = $(MATLAB_ROOT)\extern\lib\win32\lcc\libut.lib
LIBMWMATHUTIL = $(MATLAB_ROOT)\extern\lib\win32\lcc\libmwmathutil.lib
LIBMWSL_FILEIO = $(MATLAB_ROOT)\extern\lib\win32\lcc\libmwsl_fileio.lib
LIBMWIPP = $(MATLAB_ROOT)\lib\win32\libippmwipt.lib
LIBS += $(LIBUT) $(LIBMWMATHUTIL) $(LIBMWSL_FILEIO) $(LIBMWIPP)

PROGRAM = ../$(MODEL)_acc.$(MEXEXT)

#--------------------------------- Rules --------------------------------------

$(PROGRAM) : $(OBJS) $(LIBS) $(SHARED_LIB)
	@echo ### Linking ...
	$(MEX) $(MEX_FLAGS) -outdir $(RELATIVE_PATH_TO_ANCHOR) $(LINK_OBJS) $(S_FUNCTIONS_LIB) $(SHARED_LIB) $(LIBS) 
	@echo ### Created mex file: $(MODEL)_acc.$(MEXEXT)

%.obj : %.c
	$(CC) $(MEX_FLAGS) $(INCLUDES) $<

%.obj : $(RELATIVE_PATH_TO_ANCHOR)/%.c
	$(CC) $(MEX_FLAGS) $(INCLUDES) $<

%.obj : $(MATLAB_ROOT)/rtw/c/src/%.c
	$(CC) $(MEX_FLAGS) $(INCLUDES) $<

%.obj : $(MATLAB_ROOT)/toolbox/physmod/mech/c/%.c
	$(CC) $(MEX_FLAGS) $(INCLUDES) $<

%.obj : $(MATLAB_ROOT)/toolbox/physmod/common/foundation/core/c/%.c
	$(CC) $(MEX_FLAGS) $(INCLUDES) $<



%.obj : $(MATLAB_ROOT)/simulink/src/%.c
	$(CC) $(MEX_FLAGS) $(INCLUDES) $<

# Libraries:



MODULES_mech = \
          mech_00020161.obj \
          mech_000dbf6e.obj \
          mech_01d6ce36.obj \
          mech_01d7c975.obj \
          mech_01deabec.obj \
          mech_026799f3.obj \
          mech_0267fa3c.obj \
          mech_026a4926.obj \
          mech_03b58d10.obj \
          mech_03b88dd1.obj \
          mech_03bd5683.obj \
          mech_05018eed.obj \
          mech_05065e53.obj \
          mech_05095730.obj \
          mech_050a88b1.obj \
          mech_06b1bffa.obj \
          mech_06b261d7.obj \
          mech_06b2b048.obj \
          mech_06b5dfa4.obj \
          mech_07637d0d.obj \
          mech_08635480.obj \
          mech_086ce9f2.obj \
          mech_086d5aef.obj \
          mech_09b09473.obj \
          mech_0a00ca2c.obj \
          mech_0a0d7c1d.obj \
          mech_0a0e7e05.obj \
          mech_0bde6238.obj \
          mech_0cb012f7.obj \
          mech_0cb5cc4e.obj \
          mech_0d6500be.obj \
          mech_0d69dcc3.obj \
          mech_0d6e61cf.obj \
          mech_0ed03c1f.obj \
          mech_0edb87e1.obj \
          mech_0f00f59d.obj \
          mech_0f019802.obj \
          mech_0f0af65a.obj \
          mech_10d2a886.obj \
          mech_10d2c41a.obj \
          mech_10dd7df1.obj \
          mech_1101dfad.obj \
          mech_12b557bf.obj \
          mech_12bc8a6d.obj \
          mech_136041a7.obj \
          mech_1361973d.obj \
          mech_136ffca3.obj \
          mech_140386b2.obj \
          mech_14045f49.obj \
          mech_140c5385.obj \
          mech_15db2810.obj \
          mech_1661c46d.obj \
          mech_1662782c.obj \
          mech_166818a4.obj \
          mech_16687320.obj \
          mech_1668cac9.obj \
          mech_17b0d95c.obj \
          mech_17b6030b.obj \
          mech_18b04eeb.obj \
          mech_18b2214e.obj \
          mech_18bafac5.obj \
          mech_1966eff8.obj \
          mech_1969553e.obj \
          mech_1ad50f5c.obj \
          mech_1ad8d187.obj \
          mech_1adf679c.obj \
          mech_1c64bc6b.obj \
          mech_1e089621.obj \
          mech_1e0af9c9.obj \
          mech_1fd6e658.obj \
          mech_1fdd3984.obj \
          mech_2064e5bf.obj \
          mech_220fa3ea.obj \
          mech_23d10839.obj \
          mech_23d1d06d.obj \
          mech_23d8bba8.obj \
          mech_23db6173.obj \
          mech_23ded6f8.obj \
          mech_26d65ff4.obj \
          mech_27052a27.obj \
          mech_270b9070.obj \
          mech_270b9114.obj \
          mech_270b9e1e.obj \
          mech_280e0b3c.obj \
          mech_29d175e7.obj \
          mech_29dc7328.obj \
          mech_2cdc4287.obj \
          mech_2d035c0c.obj \
          mech_2d063399.obj \
          mech_2d0a3026.obj \
          mech_2eb6d938.obj \
          mech_2ebc6229.obj \
          mech_2f63a82c.obj \
          mech_2f6413b6.obj \
          mech_2f6ecfa5.obj \
          mech_30b89e1a.obj \
          mech_30ba9d20.obj \
          mech_3161503f.obj \
          mech_316a38e5.obj \
          mech_316f3e7e.obj \
          mech_32d80d9e.obj \
          mech_32de6ca9.obj \
          mech_33001ee8.obj \
          mech_3301109a.obj \
          mech_3309c494.obj \
          mech_330ecff4.obj \
          mech_3466d42e.obj \
          mech_346c6523.obj \
          mech_35b219ba.obj \
          mech_35b912b8.obj \
          mech_3600245f.obj \
          mech_38d0a2fb.obj \
          mech_390c64c6.obj \
          mech_3ab68bff.obj \
          mech_3ab93b3e.obj \
          mech_3abc8aea.obj \
          mech_3b60275d.obj \
          mech_3b652b93.obj \
          mech_3b6a25d6.obj \
          mech_3c028802.obj \
          mech_3c04861f.obj \
          mech_3c0588e4.obj \
          mech_3c063642.obj \
          mech_3c0f33a4.obj \
          mech_3e6173f2.obj \
          mech_3e66ca8f.obj \
          mech_3e68a227.obj \
          mech_3fbdbe13.obj \
          mech_40d06fb9.obj \
          mech_40dddd6d.obj \
          mech_41021b17.obj \
          mech_4105a886.obj \
          mech_4109c090.obj \
          mech_42b1fdf5.obj \
          mech_42b2f03a.obj \
          mech_42b39737.obj \
          mech_42bffbef.obj \
          mech_4364e783.obj \
          mech_4367e052.obj \
          mech_4400f80d.obj \
          mech_4403f39d.obj \
          mech_45d8e3bd.obj \
          mech_45db5b2e.obj \
          mech_4667d790.obj \
          mech_466f0960.obj \
          mech_47be1187.obj \
          mech_47bf163d.obj \
          mech_47bfad88.obj \
          mech_48b25f89.obj \
          mech_48bc8ece.obj \
          mech_48be545e.obj \
          mech_48be547a.obj \
          mech_496ff51a.obj \
          mech_4ad07a75.obj \
          mech_4ad0ac9a.obj \
          mech_4adb7fee.obj \
          mech_4c66abc6.obj \
          mech_4c69ce55.obj \
          mech_4c6a1183.obj \
          mech_4db4d8cb.obj \
          mech_4db4d95c.obj \
          mech_4db6b82d.obj \
          mech_4dbcd54d.obj \
          mech_4e023226.obj \
          mech_4e0c38c4.obj \
          mech_5003c23b.obj \
          mech_51d2b564.obj \
          mech_51d4bfae.obj \
          mech_51d6d166.obj \
          mech_51d7b7b2.obj \
          mech_51d9d483.obj \
          mech_526486f6.obj \
          mech_53ba487b.obj \
          mech_54d387c2.obj \
          mech_54d5329b.obj \
          mech_550294da.obj \
          mech_55042fb6.obj \
          mech_56b2101b.obj \
          mech_56b2a996.obj \
          mech_56b41caa.obj \
          mech_59b25776.obj \
          mech_59b4ec32.obj \
          mech_59b6e92f.obj \
          mech_59b952ef.obj \
          mech_59b9e6a5.obj \
          mech_5a050a2c.obj \
          mech_5a06df3d.obj \
          mech_5bd0abbb.obj \
          mech_5bd17eb2.obj \
          mech_5bd31d02.obj \
          mech_5bd6c428.obj \
          mech_5bd7a249.obj \
          mech_5bd7c738.obj \
          mech_5bddc5b9.obj \
          mech_5bde780c.obj \
          mech_5cb0bd8a.obj \
          mech_5cb6d582.obj \
          mech_5cbe0185.obj \
          mech_5d65adff.obj \
          mech_5eda405d.obj \
          mech_60bbec7e.obj \
          mech_60bf8acb.obj \
          mech_6163439f.obj \
          mech_616f206b.obj \
          mech_62d1cfc0.obj \
          mech_6307b0ed.obj \
          mech_646bc84e.obj \
          mech_646ca964.obj \
          mech_646cc198.obj \
          mech_646d12e2.obj \
          mech_65b6b80d.obj \
          mech_6604882c.obj \
          mech_660887ba.obj \
          mech_660de44c.obj \
          mech_67d19009.obj \
          mech_67d1f0c4.obj \
          mech_67d44962.obj \
          mech_67dcf2e9.obj \
          mech_68dbdbd6.obj \
          mech_690f1fb6.obj \
          mech_6ab94ea2.obj \
          mech_6b638cca.obj \
          mech_6c02feee.obj \
          mech_6c0e2c56.obj \
          mech_6c0f4cdf.obj \
          mech_6dd03823.obj \
          mech_6dd1577f.obj \
          mech_6ddd8af4.obj \
          mech_6e67b93d.obj \
          mech_6e6d0d1d.obj \
          mech_6fb97ca9.obj \
          mech_6fbaca54.obj \
          mech_6fbba9f5.obj \
          mech_70604dc2.obj \
          mech_706a4462.obj \
          mech_72066f8e.obj \
          mech_7206d38c.obj \
          mech_73d6c852.obj \
          mech_73d8a10b.obj \
          mech_73dba670.obj \
          mech_73dc156c.obj \
          mech_73df146b.obj \
          mech_74bc0147.obj \
          mech_7569c0d7.obj \
          mech_756bc203.obj \
          mech_756ca475.obj \
          mech_76d5f656.obj \
          mech_76d6fbb8.obj \
          mech_76df2bb9.obj \
          mech_79d068a6.obj \
          mech_79d461e7.obj \
          mech_79d86de4.obj \
          mech_79d9643f.obj \
          mech_79ded63c.obj \
          mech_79dedfa5.obj \
          mech_79dfb2e1.obj \
          mech_7a6be6e6.obj \
          mech_7bb1f70c.obj \
          mech_7bb24c60.obj \
          mech_7bb9901f.obj \
          mech_7cd0e0c4.obj \
          mech_7cdcef4b.obj \
          mech_7cdf8cdb.obj \
          mech_7ebbceab.obj \
          mech_7f67b613.obj \
          mech_81b31e2b.obj \
          mech_81b4a1af.obj \
          mech_81b5a2ae.obj \
          mech_81bfada3.obj \
          mech_820b9da8.obj \
          mech_83d054c0.obj \
          mech_83d13c72.obj \
          mech_84b7f391.obj \
          mech_84bd2df9.obj \
          mech_84be4eac.obj \
          mech_85675d1d.obj \
          mech_856b8726.obj \
          mech_86d261e4.obj \
          mech_86d2d80d.obj \
          mech_86d36b10.obj \
          mech_86d3dd1e.obj \
          mech_870bcf67.obj \
          mech_88003582.obj \
          mech_880b8364.obj \
          mech_880c8faf.obj \
          mech_880d3a99.obj \
          mech_880e8b7a.obj \
          mech_89d4fe7b.obj \
          mech_89d593cc.obj \
          mech_89dd4cf2.obj \
          mech_89df4eb1.obj \
          mech_8a6a753d.obj \
          mech_8a6eced6.obj \
          mech_8bb4b94e.obj \
          mech_8bbbbf15.obj \
          mech_8bbc09d1.obj \
          mech_8cd21a81.obj \
          mech_8cde7c29.obj \
          mech_8d0160c7.obj \
          mech_8d03677c.obj \
          mech_8d040b9a.obj \
          mech_8d0bbcef.obj \
          mech_8eb38e91.obj \
          mech_8ebc309e.obj \
          mech_8f6022a5.obj \
          mech_8f609771.obj \
          mech_8f642961.obj \
          mech_90b2aa66.obj \
          mech_90b4c836.obj \
          mech_9166b0b6.obj \
          mech_916b0b87.obj \
          mech_92d05c86.obj \
          mech_92dc8f47.obj \
          mech_930344b2.obj \
          mech_9467ea4c.obj \
          mech_95b1f5f3.obj \
          mech_95b1f910.obj \
          mech_95b522da.obj \
          mech_960a1120.obj \
          mech_960b71f7.obj \
          mech_97d06ff9.obj \
          mech_97d0bbd6.obj \
          mech_97dcdbad.obj \
          mech_98d62e21.obj \
          mech_98d642df.obj \
          mech_9901edea.obj \
          mech_9905e631.obj \
          mech_99063f3b.obj \
          mech_990b5e9d.obj \
          mech_990d3616.obj \
          mech_9b6519ef.obj \
          mech_9b661640.obj \
          mech_9b69c7b9.obj \
          mech_9dd37b92.obj \
          mech_9ddc71c6.obj \
          mech_9dddcf41.obj \
          mech_9e602455.obj \
          mech_9e60f69c.obj \
          mech_9e67917d.obj \
          mech_9e6cf5e5.obj \
          mech_9e6df8a7.obj \
          mech_9fb0501c.obj \
          mech_9fb489a2.obj \
          mech_9fbaebd4.obj \
          mech_a00a329c.obj \
          mech_a00b3c36.obj \
          mech_a1d5433c.obj \
          mech_a2601d35.obj \
          mech_a266c4a6.obj \
          mech_a26ba514.obj \
          mech_a4d1a20d.obj \
          mech_a5086761.obj \
          mech_a50ab3a7.obj \
          mech_a50ddda5.obj \
          mech_a50fdbef.obj \
          mech_a6b2e894.obj \
          mech_a6b9305f.obj \
          mech_a763f1b0.obj \
          mech_a8646954.obj \
          mech_a866039d.obj \
          mech_a86a09c6.obj \
          mech_a86db59c.obj \
          mech_a86f6c89.obj \
          mech_a9b47558.obj \
          mech_a9b9c006.obj \
          mech_aa02f239.obj \
          mech_aa0843cc.obj \
          mech_aa0e9f32.obj \
          mech_abd05c1e.obj \
          mech_abd48ba5.obj \
          mech_abdc5ed0.obj \
          mech_abddea2a.obj \
          mech_acb5221d.obj \
          mech_acba49d8.obj \
          mech_ad60e707.obj \
          mech_ad65508c.obj \
          mech_aedebcb7.obj \
          mech_af077cea.obj \
          mech_af0bcc53.obj \
          mech_b0d04b49.obj \
          mech_b0d22a1d.obj \
          mech_b0d4f2c3.obj \
          mech_b0d59e5e.obj \
          mech_b0defb63.obj \
          mech_b106879f.obj \
          mech_b10a5c9e.obj \
          mech_b10b8cd9.obj \
          mech_b2b807bd.obj \
          mech_b2bad7e1.obj \
          mech_b3697288.obj \
          mech_b36c7284.obj \
          mech_b4086a7a.obj \
          mech_b40ad112.obj \
          mech_b40ed4ce.obj \
          mech_b5d01550.obj \
          mech_b5d2a6ff.obj \
          mech_b5d87961.obj \
          mech_b5db1e2e.obj \
          mech_b5deacf7.obj \
          mech_b668952c.obj \
          mech_b6699901.obj \
          mech_b6699de9.obj \
          mech_b968d8f4.obj \
          mech_b96a08bc.obj \
          mech_bad55f59.obj \
          mech_bb0a2f71.obj \
          mech_bc6538b5.obj \
          mech_bc658bdb.obj \
          mech_bc6d3a77.obj \
          mech_bc6e8808.obj \
          mech_bdb69746.obj \
          mech_bdb7f56b.obj \
          mech_be0019f2.obj \
          mech_be06afe5.obj \
          mech_be0f7a94.obj \
          mech_bfd2d4b5.obj \
          mech_bfd7626e.obj \
          mech_bfdf61c0.obj \
          mech_c0b10a1e.obj \
          mech_c16112b0.obj \
          mech_c16270fe.obj \
          mech_c168a0f6.obj \
          mech_c2d19b40.obj \
          mech_c2d4ff87.obj \
          mech_c2d54042.obj \
          mech_c30feec9.obj \
          mech_c46a2e07.obj \
          mech_c46f2dd1.obj \
          mech_c5ba3dfd.obj \
          mech_c5be8a87.obj \
          mech_c60065a1.obj \
          mech_c600dc32.obj \
          mech_c7d0a292.obj \
          mech_c7d51210.obj \
          mech_c7dc1dca.obj \
          mech_c7dcc283.obj \
          mech_c9002078.obj \
          mech_cb61d576.obj \
          mech_cb626222.obj \
          mech_cb6e0371.obj \
          mech_cc05a4fe.obj \
          mech_cc07a9da.obj \
          mech_cc0fcc0a.obj \
          mech_cdd0099a.obj \
          mech_cdd66477.obj \
          mech_cddfd8e4.obj \
          mech_ce63ec92.obj \
          mech_ce6637f1.obj \
          mech_cfb12207.obj \
          mech_cfb32f22.obj \
          mech_cfb69e39.obj \
          mech_cfb720af.obj \
          mech_cfbbf429.obj \
          mech_d068c3da.obj \
          mech_d06b7b3c.obj \
          mech_d06b7fdb.obj \
          mech_d1b40ffd.obj \
          mech_d1b9bb31.obj \
          mech_d1be66f8.obj \
          mech_d200307a.obj \
          mech_d20550ea.obj \
          mech_d2075977.obj \
          mech_d2098975.obj \
          mech_d3d22ed4.obj \
          mech_d3d4219a.obj \
          mech_d3d72ce8.obj \
          mech_d4b85e29.obj \
          mech_d4bb3bd3.obj \
          mech_d6daa983.obj \
          mech_d705bd10.obj \
          mech_d7060554.obj \
          mech_d708d8d0.obj \
          mech_d70964df.obj \
          mech_d804fce5.obj \
          mech_d8069b2c.obj \
          mech_d80a9576.obj \
          mech_d80c9869.obj \
          mech_d80e9a2a.obj \
          mech_d9df5bf4.obj \
          mech_da670c88.obj \
          mech_dbb81734.obj \
          mech_dbbaaa65.obj \
          mech_dbbfca4f.obj \
          mech_dcd1d2f7.obj \
          mech_dcd265d7.obj \
          mech_dd00cf5c.obj \
          mech_dd02100b.obj \
          mech_dd041b71.obj \
          mech_dd0da830.obj \
          mech_deb59db7.obj \
          mech_debc21ca.obj \
          mech_debef8c0.obj \
          mech_df68e099.obj \
          mech_e0dc58b0.obj \
          mech_e2b01d01.obj \
          mech_e2b61d19.obj \
          mech_e2b7c577.obj \
          mech_e2bccf11.obj \
          mech_e2bd145d.obj \
          mech_e369660c.obj \
          mech_e4077c8c.obj \
          mech_e4087f3a.obj \
          mech_e5db60f7.obj \
          mech_e661ec6a.obj \
          mech_e66d5b16.obj \
          mech_e7b79268.obj \
          mech_e7b84972.obj \
          mech_e8b3d5b3.obj \
          mech_e8b46e8f.obj \
          mech_e8bc0531.obj \
          mech_e8bcbbc6.obj \
          mech_e966c514.obj \
          mech_e9697f3a.obj \
          mech_ead020e5.obj \
          mech_ead54fa6.obj \
          mech_ead9f01f.obj \
          mech_eb0686b7.obj \
          mech_edb98112.obj \
          mech_ee01bb34.obj \
          mech_ee02656f.obj \
          mech_ee07d5ac.obj \
          mech_ee0c64e3.obj \
          mech_ee0f0453.obj \
          mech_efd7c6c6.obj \
          mech_efd9cdb1.obj \
          mech_f0049f5f.obj \
          mech_f1d73a17.obj \
          mech_f1d987ec.obj \
          mech_f26e0669.obj \
          mech_f26ed13b.obj \
          mech_f4d5d757.obj \
          mech_f5007ab8.obj \
          mech_f6b546ec.obj \
          mech_f76c8634.obj \
          mech_f76e5dc0.obj \
          mech_f860c130.obj \
          mech_f862c000.obj \
          mech_fbd3fa82.obj \
          mech_fbda4bb4.obj \
          mech_fcb43ff8.obj \
          mech_fcbb8004.obj \
          mech_fcbe3c82.obj \
          mech_fd6022a3.obj \
          mech_fd64499c.obj \
          mech_fd6af815.obj \
          mech_fedc73bd.obj \
          mech_ff09d914.obj \
          

mech.lib :  $(MAKEFILE) rtw_proj.tmw $(MODULES_mech)
	@echo ### Creating $@
	@if exist $@ del $@
	$(LIBCMD) /out:$@ $(MODULES_mech)
	@echo ### $@ Created 

MODULES_pm = \
          pm_26dc3230.obj \
          

pm.lib :  $(MAKEFILE) rtw_proj.tmw $(MODULES_pm)
	@echo ### Creating $@
	@if exist $@ del $@
	$(LIBCMD) /out:$@ $(MODULES_pm)
	@echo ### $@ Created 



clean :
	@echo ### Deleting the objects and $(PROGRAM)
	@del $(OBJS) ..\$(MODEL)_acc.$(MEXEXT) $(wildcard *.obj) $(wildcard *.lib)

#----------------------------- Dependencies -------------------------------

$(OBJS) : $(MAKEFILE) rtw_proj.tmw

$(SHARED_OBJS) : $(SHARED_BIN_DIR)/%.obj : $(SHARED_SRC_DIR)/%.c 
	$(CC) -outdir $(SHARED_BIN_DIR) $(MEX_FLAGS) $(INCLUDES) $<

$(SHARED_LIB) : $(SHARED_OBJS)
	@echo ### Creating $@ 
	$(LIBCMD) /out:$@ $(FMT_SHARED_OBJS)
	@echo ### $@ Created   


