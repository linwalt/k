#! /bin/sh
set -e o pipefail

git clone --depth=1 https://github.com/kdrag0n/proton-clang ~/tc/proton-clang && git clone --depth=1 https://github.com/walternewtz/AnyKernel3 ~/anykernel3

#exporting

export PATH="/home/runner/tc/proton-clang/bin:${PATH}"
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_COMPILER_STRING="$(/home/runner/tc/proton-clang/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')"

#configure

make O=out ARCH=arm64 beryllium_defconfig

#build

make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC=clang \
                      CROSS_COMPILE=aarch64-linux-gnu- \
                      CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                      NM=llvm-nm \
                      OBJCOPY=llvm-objcopy \
                      OBJDUMP=llvm-objdump \
                      STRIP=llvm-strip

echo "**** Verify Image.gz-dtb ****"
ls $PWD/out/arch/arm64/boot/Image.gz-dtb
