@echo off
set MATLAB=C:\Program Files (x86)\MATLAB\R2012a.x32
"%MATLAB%\bin\win32\gmake" -f IDP.mk  GENERATE_REPORT=0
