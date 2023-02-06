#!/bin/sh

cd drivers && git clone https://github.com/walternewtz/KernelSU
rm -rf kernelsu
mv ./KernelSU/kernel ./kernelsu
rm -rf KernelSU
cd kernelsu && sed -i 's/0x033b/0x36c/g' Makefile && sed -i 's/0xb0b91415/0x4da843ab/g' Makefile
cd .. && cd ..
git add .
git commit -m "a"
git reset --soft HEAD~2
git commit -m "add kernelsu"
git push -f
