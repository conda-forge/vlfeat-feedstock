#!/bin/bash

if [[ "${target_platform}" == linux* ]]; then
  VL_ARCH="glnxa64"
  OPENMP=1
elif [[ "${target_platform}" == osx* ]]; then
  VL_ARCH="maci64"
  OPENMP=0
fi

if [[ "${target_platform}" != "osx-arm64" && "${target_platform}" != "linux-aarch64" ]]; then
  DISABLE_SSE2="no"
else
  DISABLE_SSE2="yes"
fi

# Turn off all intrinsics.
make ARCH=${VL_ARCH} DISABLE_AVX=yes DISABLE_OPENMP=$OPENMP MKOCTFILE="" MEX="" VERB=1 DISABLE_SSE2=$DISABLE_SSE2

# Run tests
if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
  ./bin/${VL_ARCH}/test_gauss_elimination
  ./bin/${VL_ARCH}/test_getopt_long
  ./bin/${VL_ARCH}/test_gmm
  ./bin/${VL_ARCH}/test_heap-def
  ./bin/${VL_ARCH}/test_imopv
  ./bin/${VL_ARCH}/test_kmeans
  ./bin/${VL_ARCH}/test_liop
  ./bin/${VL_ARCH}/test_mathop
  ./bin/${VL_ARCH}/test_mathop_abs
  ./bin/${VL_ARCH}/test_nan
  ./bin/${VL_ARCH}/test_qsort-def
  ./bin/${VL_ARCH}/test_rand
  ./bin/${VL_ARCH}/test_sqrti
  ./bin/${VL_ARCH}/test_stringop
  ./bin/${VL_ARCH}/test_svd2
  ./bin/${VL_ARCH}/test_vec_comp
  # These test fail even natively on the M1
  if [[ $(uname -m) != 'arm64' ]]; then
    ./bin/${VL_ARCH}/test_host
    ./bin/${VL_ARCH}/test_threads
  fi
fi

# Copy all the files and executables
mkdir -p $PREFIX/bin
cp bin/${VL_ARCH}/sift $PREFIX/bin/sift
cp bin/${VL_ARCH}/mser $PREFIX/bin/mser
cp bin/${VL_ARCH}/aib $PREFIX/bin/aib

mkdir -p $PREFIX/lib
cp bin/${VL_ARCH}/libvl${SHLIB_EXT} $PREFIX/lib/libvl${SHLIB_EXT}
mkdir -p $PREFIX/include/vl
cp vl/*.h $PREFIX/include/vl/

# For some reason the instal_name_tool fails, so I do it manually here
if [[ "${target_platform}" == osx* ]]; then
  install_name_tool -id @rpath/libvl.dylib $PREFIX/lib/libvl.dylib
  install_name_tool -change @loader_path/libvl.dylib @rpath/../lib/libvl.dylib $PREFIX/bin/sift
  install_name_tool -change @loader_path/libvl.dylib @rpath/../lib/libvl.dylib $PREFIX/bin/mser
  install_name_tool -change @loader_path/libvl.dylib @rpath/../lib/libvl.dylib $PREFIX/bin/aib
fi
