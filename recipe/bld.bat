if "%VS_VERSION%" == "9.0" (
  set VL_MSC=1500
  set MSVSVER=90
) else if "%VS_VERSION%" == "10.0" (
  set VL_MSC=1700
  set MSVSVER=100
) else if "%VS_VERSION%" == "14.0" (
  set VL_MSC=1900
  set MSVSVER=140
) else if "%VS_VERSION%" == "15.0" (
  set VL_MSC=2000
  set MSVSVER=141
) else if "%VS_VERSION%" == "16.0" (
  set VL_MSC=2100
  set MSVSVER=142
)
set MSVCROOT="C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise"
set WINSDKROOT="C:\Program Files (x86)\Windows Kits\10\include\10.0.22000.0"

set VL_ARCH=win%ARCH%

rmdir bin\%VL_ARCH% /S /Q
md bin\%VL_ARCH%
nmake /f Makefile.mak ARCH=%VL_ARCH% VL_MSVC=%VS_VERSION% VL_MSVS=%VS_MAJOR% VL_MSC=%VL_MSC% MSVSVER=%MSVSVER% MSVCROOT=%MSVCROOT% WINSDKROOT=%WINSDKROOT% VERB=1
if errorlevel 1 exit 1

rem Run tests
bin\\%VL_ARCH%\\test_gauss_elimination
if errorlevel 1 exit 1
bin\\%VL_ARCH%\\test_getopt_long
if errorlevel 1 exit 1
bin\\%VL_ARCH%\\test_gmm
if errorlevel 1 exit 1
bin\\%VL_ARCH%\\test_heap-def
if errorlevel 1 exit 1
bin\\%VL_ARCH%\\test_host
if errorlevel 1 exit 1
bin\\%VL_ARCH%\\test_imopv
if errorlevel 1 exit 1
bin\\%VL_ARCH%\\test_kmeans
if errorlevel 1 exit 1
bin\\%VL_ARCH%\\test_liop
if errorlevel 1 exit 1
bin\\%VL_ARCH%\\test_mathop
if errorlevel 1 exit 1
bin\\%VL_ARCH%\\test_mathop_abs
if errorlevel 1 exit 1
bin\\%VL_ARCH%\\test_nan
if errorlevel 1 exit 1
bin\\%VL_ARCH%\\test_qsort-def
if errorlevel 1 exit 1
bin\\%VL_ARCH%\\test_rand
if errorlevel 1 exit 1
bin\\%VL_ARCH%\\test_sqrti
if errorlevel 1 exit 1
bin\\%VL_ARCH%\\test_stringop
if errorlevel 1 exit 1
bin\\%VL_ARCH%\\test_svd2
if errorlevel 1 exit 1
bin\\%VL_ARCH%\\test_threads
if errorlevel 1 exit 1
bin\\%VL_ARCH%\\test_vec_comp
if errorlevel 1 exit 1

copy "bin\%VL_ARCH%\sift.exe" "%LIBRARY_BIN%\sift.exe"
if errorlevel 1 exit 1
copy "bin\%VL_ARCH%\mser.exe" "%LIBRARY_BIN%\mser.exe"
if errorlevel 1 exit 1
copy "bin\%VL_ARCH%\aib.exe"  "%LIBRARY_BIN%\aib.exe"
if errorlevel 1 exit 1

copy "bin\%VL_ARCH%\vl.dll" "%LIBRARY_BIN%\vl.dll"
if errorlevel 1 exit 1
copy "bin\%VL_ARCH%\vl.lib" "%LIBRARY_BIN%\vl.lib"
if errorlevel 1 exit 1

robocopy "vl" "%LIBRARY_INC%\vl" *.h /MIR
if %ERRORLEVEL% GEQ 2 (exit 1) else (exit 0)
