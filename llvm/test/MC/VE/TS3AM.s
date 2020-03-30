# RUN: llvm-mc -triple ve-unknown-unknown --show-encoding %s | FileCheck %s

# CHECK: ts3am %s20, 20(%s11), %s32
# CHECK: encoding: [0x14,0x00,0x00,0x00,0x8b,0xa0,0x14,0x52]
ts3am %s20, 20(%s11), %s32

# CHECK: ts3am %s20, 8192, 1
# CHECK: encoding: [0x00,0x20,0x00,0x00,0x00,0x01,0x14,0x52]
ts3am %s20, 8192, 1
