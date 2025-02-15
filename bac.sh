#! /bin/sh
set -e o pipefail

git clone --depth=1 https://github.com/walternewtz/AnyKernel3 ~/anykernel3

git clone https://gitlab.com/ImSurajxD/clang-r450784d /home/runner/clang-r450784d --depth 1
export clangpath=/home/runner/clang-r450784d/bin
export KBUILD_COMPILER_STRING="$(/home/runner/clang-r450784d/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')"
git clone https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 /home/runner/gcc --depth 1
git clone https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9.git --depth=1 /home/runner/gcc32
PATH="/home/runner/clang-r450784d/bin:/home/runner/gcc/bin:/home/runner/gcc32/bin:${PATH}"
args="-j$(nproc --all) \
O=out \
ARCH=arm64 \
CC=clang \
HOSTCC=clang \
HOSTCXX=clang++ \
AR=llvm-ar \
NM=llvm-nm \
OBJCOPY=llvm-objcopy \
OBJDUMP=llvm-objdump \
STRIP=llvm-strip \
READELF=llvm-readelf \
OBJSIZE=llvm-size \
CLANG_TRIPLE=aarch64-linux-gnu- \
CROSS_COMPILE=aarch64-linux-android- \
CROSS_COMPILE_ARM32=arm-linux-androideabi-"
make ${args} beryllium_defconfig
make ${args}
