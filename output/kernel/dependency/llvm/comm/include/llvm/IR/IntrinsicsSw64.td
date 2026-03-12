//==- IntrinsicsSw64.td - Sw64 intrinsics                 -*- tablegen -*-==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines all of the Sw64-specific intrinsics.
//
//===----------------------------------------------------------------------===//

// ZHAIYH20190312_SWLLVM
let TargetPrefix = "sw64" in {  // All intrinsics start with "llvm.sw64.".
  def int_sw64_umulh : GCCBuiltin<"__builtin_sw_umulh">,
    Intrinsic<[llvm_i64_ty], [llvm_i64_ty, llvm_i64_ty], [IntrNoMem]>;

  class sw64VectorIntArg
        : Intrinsic<[llvm_anyvector_ty], [LLVMMatchType<0>, llvm_anyint_ty],
        [IntrNoMem]>;

#ifndef CHENHB20230420_8A
def int_sw64_crc32b : GCCBuiltin<"__builtin_sw64_crc32b">,
  Intrinsic<[llvm_i64_ty], [llvm_i64_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_crc32h : GCCBuiltin<"__builtin_sw64_crc32h">,
  Intrinsic<[llvm_i64_ty], [llvm_i64_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_crc32w : GCCBuiltin<"__builtin_sw64_crc32w">,
  Intrinsic<[llvm_i64_ty], [llvm_i64_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_crc32l : GCCBuiltin<"__builtin_sw64_crc32l">,
  Intrinsic<[llvm_i64_ty], [llvm_i64_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_crc32cb : GCCBuiltin<"__builtin_sw64_crc32cb">,
  Intrinsic<[llvm_i64_ty], [llvm_i64_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_crc32ch : GCCBuiltin<"__builtin_sw64_crc32ch">,
  Intrinsic<[llvm_i64_ty], [llvm_i64_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_crc32cw : GCCBuiltin<"__builtin_sw64_crc32cw">,
  Intrinsic<[llvm_i64_ty], [llvm_i64_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_crc32cl : GCCBuiltin<"__builtin_sw64_crc32cl">,
  Intrinsic<[llvm_i64_ty], [llvm_i64_ty, llvm_i64_ty],
  [IntrNoMem]>;

def int_sw64_sbt : GCCBuiltin<"__builtin_sw64_sbt">,
  Intrinsic<[llvm_i64_ty], [llvm_i64_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_cbt : GCCBuiltin<"__builtin_sw64_cbt">,
  Intrinsic<[llvm_i64_ty], [llvm_i64_ty, llvm_i64_ty],
  [IntrNoMem]>;
#endif

// SIMD Intrincs
def int_sw64_vaddw : GCCBuiltin<"__builtin_sw_vaddw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;

def int_sw64_ctpopow : GCCBuiltin<"__builtin_sw_ctpopow">,
  Intrinsic<[llvm_i64_ty], [llvm_v4i64_ty],
  [IntrNoMem]>;
def int_sw64_ctlzow : GCCBuiltin<"__builtin_sw_ctlzow">,
  Intrinsic<[llvm_i64_ty], [llvm_v4i64_ty],
  [IntrNoMem]>;
def int_sw64_reduc_plusw : GCCBuiltin<"__builtin_sw_reduc_plusw">,
  Intrinsic<[llvm_i32_ty], [llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_reduc_pluss : GCCBuiltin<"__builtin_sw_reduc_pluss">,
  Intrinsic<[llvm_float_ty], [llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_reduc_plusd : GCCBuiltin<"__builtin_sw_reduc_plusd">,
  Intrinsic<[llvm_double_ty], [llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vucaddw  : GCCBuiltin<"__builtin_sw_vucaddw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vucaddwi : GCCBuiltin<"__builtin_sw_vucaddwi">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty],
  [IntrNoMem]>;
def int_sw64_vucsubw : GCCBuiltin<"__builtin_sw_vucsubw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vucsubwi : GCCBuiltin<"__builtin_sw_vucsubwi">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty],
  [IntrNoMem]>;
def int_sw64_vucaddh : GCCBuiltin<"__builtin_sw_vucaddh">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vucaddhi : GCCBuiltin<"__builtin_sw_vucaddhi">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vucsubh : GCCBuiltin<"__builtin_sw_vucsubh">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vucsubhi : GCCBuiltin<"__builtin_sw_vucsubhi">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vucaddb : GCCBuiltin<"__builtin_sw_vucaddb">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vucaddbi : GCCBuiltin<"__builtin_sw_vucaddbi">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vucsubb : GCCBuiltin<"__builtin_sw_vucsubb">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vucsubbi : GCCBuiltin<"__builtin_sw_vucsubbi">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vslls : GCCBuiltin<"__builtin_sw_vslls">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vslld : GCCBuiltin<"__builtin_sw_vslld">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vsrls : GCCBuiltin<"__builtin_sw_vsrls">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vsrld : GCCBuiltin<"__builtin_sw_vsrld">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_i64_ty],
  [IntrNoMem]>;

def int_sw64_vsll : sw64VectorIntArg;
def int_sw64_vsrl : sw64VectorIntArg;
def int_sw64_vsra : sw64VectorIntArg;
def int_sw64_vrol : sw64VectorIntArg;

//def int_sw64_sllow : GCCBuiltin<"__builtin_sw_sllow">, sw64VectorIntArg;
//def int_sw64_srlow : GCCBuiltin<"__builtin_sw_srlow">, sw64VectorIntArg;
//def int_sw64_sraow : GCCBuiltin<"__builtin_sw_sraow">, sw64VectorIntArg;

def int_sw64_vsllw : GCCBuiltin<"__builtin_sw_vsllw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vsllh : GCCBuiltin<"__builtin_sw_vsllh">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vsllb : GCCBuiltin<"__builtin_sw_vslln">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vslll : GCCBuiltin<"__builtin_sw_vslll">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i64_ty],
  [IntrNoMem]>;

def int_sw64_vsrlw : GCCBuiltin<"__builtin_sw_vsrlw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vsrlh : GCCBuiltin<"__builtin_sw_vsrlh">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vsrlb : GCCBuiltin<"__builtin_sw_vsrlb">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vsrll : GCCBuiltin<"__builtin_sw_vsrll">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i64_ty],
  [IntrNoMem]>;

def int_sw64_vsraw : GCCBuiltin<"__builtin_sw_vsraw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vsrah : GCCBuiltin<"__builtin_sw_vsrah">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vsrab : GCCBuiltin<"__builtin_sw_vsrab">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vsral : GCCBuiltin<"__builtin_sw_vsral">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i64_ty],
  [IntrNoMem]>;

def int_sw64_vrolw : GCCBuiltin<"__builtin_sw_vrolw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i64_ty],
  [IntrNoMem]>;
//def int_sw64_vrolh : GCCBuiltin<"__builtin_sw_vrolw">,
//  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i64_ty],
//  [IntrNoMem]>;
//def int_sw64_vrolb : GCCBuiltin<"__builtin_sw_vrolw">,
//  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i64_ty],
//  [IntrNoMem]>;
//def int_sw64_vroll : GCCBuiltin<"__builtin_sw_vrolw">,
//  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i64_ty],
//  [IntrNoMem]>;


// ------------ ZYH
//def int_sw64_vrolw : GCCBuiltin<"__builtin_sw_vrolw">,
//  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty],
//  [IntrNoMem]>;
def int_sw64_vrolwi : GCCBuiltin<"__builtin_sw_vrolwi">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_sllow : GCCBuiltin<"__builtin_sw_sllow">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_srlow : GCCBuiltin<"__builtin_sw_srlow">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_sllowi : GCCBuiltin<"__builtin_sw_sllowi">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i64_ty],
  [IntrNoMem]>;
//  [IntrNoMem, ImmArg<1>]>;

def int_sw64_srlowi : GCCBuiltin<"__builtin_sw_srlowi">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty],
  [IntrNoMem]>;
//  [IntrNoMem, ImmArg<1>]>;
// ------------ ZYH

def int_sw64_vsqrts : GCCBuiltin<"__builtin_sw_vsqrts">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vsqrtd : GCCBuiltin<"__builtin_sw_vsqrtd">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty],
  [IntrNoMem]>;


def int_sw64_vornotw : GCCBuiltin<"__builtin_sw_vornotw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_veqvw : GCCBuiltin<"__builtin_sw_veqvw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;

def int_sw64_vfcmpeqs : GCCBuiltin<"__builtin_sw_vfcmpeqs">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vfcmples : GCCBuiltin<"__builtin_sw_vfcmples">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vfcmplts : GCCBuiltin<"__builtin_sw_vfcmplts">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vfcmpuns : GCCBuiltin<"__builtin_sw_vfcmpuns">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vfcmpeqd : GCCBuiltin<"__builtin_sw_vfcmpeqd">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vfcmpled : GCCBuiltin<"__builtin_sw_vfcmpled">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vfcmpltd : GCCBuiltin<"__builtin_sw_vfcmpltd">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vfcmpund : GCCBuiltin<"__builtin_sw_vfcmpund">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vcpyss : GCCBuiltin<"__builtin_sw_vcpyss">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vcpysns : GCCBuiltin<"__builtin_sw_vcpysns">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vcpyses : GCCBuiltin<"__builtin_sw_vcpyses">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vcpysd : GCCBuiltin<"__builtin_sw_vcpysd">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vcpysnd : GCCBuiltin<"__builtin_sw_vcpysnd">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vcpysed : GCCBuiltin<"__builtin_sw_vcpysed">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vseleqw : GCCBuiltin<"__builtin_sw_vseleqw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vseleqwi : GCCBuiltin<"__builtin_sw_vseleqwi">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vselltw : GCCBuiltin<"__builtin_sw_vselltw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vselltwi : GCCBuiltin<"__builtin_sw_vselltwi">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vsellew : GCCBuiltin<"__builtin_sw_vsellew">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vsellewi : GCCBuiltin<"__builtin_sw_vsellewi">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vsellbcw : GCCBuiltin<"__builtin_sw_vsellbcw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vsellbcwi : GCCBuiltin<"__builtin_sw_vsellbcwi">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vfseleqs : GCCBuiltin<"__builtin_sw_vfseleqs">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty, llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vfselles : GCCBuiltin<"__builtin_sw_vfselles">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty, llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vfsellts : GCCBuiltin<"__builtin_sw_vfsellts">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty, llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vfseleqd : GCCBuiltin<"__builtin_sw_vfseleqd">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty, llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vfselled : GCCBuiltin<"__builtin_sw_vfselled">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty, llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vfselltd : GCCBuiltin<"__builtin_sw_vfselltd">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty, llvm_v4f64_ty],
  [IntrNoMem]>;

// Multiply-add instructions
//def int_sw64_vnmss : GCCBuiltin<"__builtin_sw_vnmss">,
//  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty, llvm_v4f32_ty],
//  [IntrNoMem]>;
def int_sw64_vnmsd : GCCBuiltin<"__builtin_sw_vnmsd">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty, llvm_v4f64_ty],
  [IntrNoMem]>;

// Vector Insert Intrinsic
def int_sw64_vinsfs : GCCBuiltin<"__builtin_sw_vinsfs">,
  Intrinsic<[llvm_v4f32_ty], [llvm_float_ty, llvm_v4f32_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vinsfd : GCCBuiltin<"__builtin_sw_vinsfd">,
  Intrinsic<[llvm_v4f64_ty], [llvm_double_ty, llvm_v4f64_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vinsw : GCCBuiltin<"__builtin_sw_vinsw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_i64_ty, llvm_v8i32_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vinsb  : GCCBuiltin<"__builtin_sw_vinsb">,
  Intrinsic<[llvm_v32i8_ty], [llvm_i64_ty, llvm_v32i8_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vinsh  : GCCBuiltin<"__builtin_sw_vinsh">,
  Intrinsic<[llvm_v16i16_ty], [llvm_i64_ty, llvm_v16i16_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vinsl : GCCBuiltin<"__builtin_sw_vinsl">,
  Intrinsic<[llvm_v4i64_ty], [llvm_i64_ty, llvm_v4i64_ty, llvm_i64_ty],
  [IntrNoMem]>;

// Vector Duplicate Intrinsic
//def int_sw64_vcpyfs : GCCBuiltin<"__builtin_sw_vcpyfs">,
//  Intrinsic<[llvm_v4f32_ty], [llvm_float_ty],
//  [IntrNoMem]>;
//def int_sw64_vcpyfd : GCCBuiltin<"__builtin_sw_vcpyfd">,
//  Intrinsic<[llvm_v4f64_ty], [llvm_double_ty],
//  [IntrNoMem]>;
//def int_sw64_vcpyw : GCCBuiltin<"__builtin_sw_vcpyw">,
//  Intrinsic<[llvm_v8i32_ty], [llvm_i32_ty],
//  [IntrNoMem]>;
//def int_sw64_vcpyb  : GCCBuiltin<"__builtin_sw_vcpyb">,
//  Intrinsic<[llvm_v32i8_ty], [llvm_v1i8_ty],
//  [IntrNoMem]>;
//def int_sw64_vcpyh  : GCCBuiltin<"__builtin_sw_vcpyh">,
//  Intrinsic<[llvm_v16i16_ty], [llvm_v1i16_ty],
//  [IntrNoMem]>;
//def int_sw64_vcpyl : GCCBuiltin<"__builtin_sw_vcpyl">,
//  Intrinsic<[llvm_v4i64_ty], [llvm_v1i64_ty],
//  [IntrNoMem]>;

def int_sw64_vextfs : GCCBuiltin<"__builtin_sw_vextfs">,
  Intrinsic<[llvm_float_ty], [llvm_v4f32_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vextfd : GCCBuiltin<"__builtin_sw_vextfd">,
  Intrinsic<[llvm_double_ty], [llvm_v4f64_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vextw : GCCBuiltin<"__builtin_sw_vextw">,
  Intrinsic<[llvm_i64_ty], [llvm_v8i32_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vextl : GCCBuiltin<"__builtin_sw_vextl">,
  Intrinsic<[llvm_i64_ty], [llvm_v4i64_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vconw : GCCBuiltin<"__builtin_sw_vconw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_ptr_ty],
  [IntrNoMem, IntrArgMemOnly]>;
def int_sw64_vconl : GCCBuiltin<"__builtin_sw_vconl">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_ptr_ty],
  [IntrNoMem, IntrArgMemOnly]>;
def int_sw64_vcons : GCCBuiltin<"__builtin_sw_vcons">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty, llvm_ptr_ty],
  [IntrNoMem, IntrArgMemOnly]>;
def int_sw64_vcond : GCCBuiltin<"__builtin_sw_vcond">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty, llvm_ptr_ty],
  [IntrNoMem, IntrArgMemOnly]>;

def int_sw64_vlogzz : GCCBuiltin<"__builtin_sw_vlogzz">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_v4i64_ty, llvm_i64_ty],
  [IntrNoMem]>;

def int_sw64_vshfw : GCCBuiltin<"__builtin_sw_vshfw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vucaddh_v16hi : GCCBuiltin<"__builtin_sw_vucaddh_v16hi">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty],
  [IntrNoMem]>;
def int_sw64_vucaddhi_v16hi : GCCBuiltin<"__builtin_sw_vucaddhi_v16hi">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty],
  [IntrNoMem]>;
def int_sw64_vucsubh_v16hi : GCCBuiltin<"__builtin_sw_vucsubh_v16hi">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty],
  [IntrNoMem]>;
def int_sw64_vucsubhi_v16hi : GCCBuiltin<"__builtin_sw_vucsubhi_v16hi">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty],
  [IntrNoMem]>;
def int_sw64_vucaddb_v32qi : GCCBuiltin<"__builtin_sw_vucaddb_v32qi">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [IntrNoMem]>;
def int_sw64_vucaddbi_v32qi : GCCBuiltin<"__builtin_sw_vucaddbi_v32qi">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [IntrNoMem]>;
def int_sw64_vucsubb_v32qi : GCCBuiltin<"__builtin_sw_vucsubb_v32qi">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [IntrNoMem]>;
def int_sw64_vucsubbi_v32qi : GCCBuiltin<"__builtin_sw_vucsubbi_v32qi">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [IntrNoMem]>;
def int_sw64_vrolb : GCCBuiltin<"__builtin_sw_vrolb">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty],
  [IntrNoMem]>;
def int_sw64_vrolbi : GCCBuiltin<"__builtin_sw_vrolbi">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty],
  [IntrNoMem]>;
def int_sw64_vrolh : GCCBuiltin<"__builtin_sw_vrolh">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty],
  [IntrNoMem]>;
def int_sw64_vrolhi : GCCBuiltin<"__builtin_sw_vrolhi">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty],
  [IntrNoMem]>;
def int_sw64_vroll : GCCBuiltin<"__builtin_sw_vroll">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty],
  [IntrNoMem]>;
def int_sw64_vrolli : GCCBuiltin<"__builtin_sw_vrolli">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty],
  [IntrNoMem]>;
def int_sw64_vmaxb : GCCBuiltin<"__builtin_sw_vmaxb">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [IntrNoMem]>;
def int_sw64_vminb : GCCBuiltin<"__builtin_sw_vminb">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [IntrNoMem]>;
def int_sw64_vmaxh : GCCBuiltin<"__builtin_sw_vmaxh">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty],
  [IntrNoMem]>;
def int_sw64_vminh : GCCBuiltin<"__builtin_sw_vminh">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty],
  [IntrNoMem]>;
def int_sw64_vmaxw : GCCBuiltin<"__builtin_sw_vmaxw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vminw : GCCBuiltin<"__builtin_sw_vminw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vmaxl : GCCBuiltin<"__builtin_sw_vmaxl">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty],
  [IntrNoMem]>;
def int_sw64_vminl : GCCBuiltin<"__builtin_sw_vminl">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty],
  [IntrNoMem]>;
def int_sw64_vumaxb : GCCBuiltin<"__builtin_sw_vumaxb">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [IntrNoMem]>;
def int_sw64_vuminb : GCCBuiltin<"__builtin_sw_vuminb">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [IntrNoMem]>;
def int_sw64_vumaxh : GCCBuiltin<"__builtin_sw_vumaxh">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty],
  [IntrNoMem]>;
def int_sw64_vuminh : GCCBuiltin<"__builtin_sw_vuminh">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty],
  [IntrNoMem]>;
def int_sw64_vumaxw : GCCBuiltin<"__builtin_sw_vumaxw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vuminw : GCCBuiltin<"__builtin_sw_vuminw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vumaxl : GCCBuiltin<"__builtin_sw_vumaxl">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty],
  [IntrNoMem]>;
def int_sw64_vuminl : GCCBuiltin<"__builtin_sw_vuminl">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty],
  [IntrNoMem]>;
def int_sw64_sraow : GCCBuiltin<"__builtin_sw_sraow">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_sraowi : GCCBuiltin<"__builtin_sw_sraowi">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty],
  [IntrNoMem]>;

def int_sw64_vcmpgew : GCCBuiltin<"__builtin_sw_vcmpgew">,
  Intrinsic<[llvm_i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
//def int_sw64_vcmpgewi : GCCBuiltin<"__builtin_sw_vcmpgewi">,
//  Intrinsic<[llvm_i32_ty], [llvm_v8i32_ty, llvm_i32_ty],
//  [IntrNoMem]>;

def int_sw64_vcmpeqw : GCCBuiltin<"__builtin_sw_vcmpeqw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vcmplew : GCCBuiltin<"__builtin_sw_vcmplew">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vcmpltw : GCCBuiltin<"__builtin_sw_vcmpltw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vcmpulew : GCCBuiltin<"__builtin_sw_vcmpulew">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vcmpultw : GCCBuiltin<"__builtin_sw_vcmpultw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;

def int_sw64_vcmpueqb : GCCBuiltin<"__builtin_sw_vcmpueqb">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [IntrNoMem]>;
def int_sw64_vcmpueqbi : GCCBuiltin<"__builtin_sw_vcmpueqbi">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty],
  [IntrNoMem]>;
def int_sw64_vcmpugtb : GCCBuiltin<"__builtin_sw_vcmpugtb">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [IntrNoMem]>;
def int_sw64_vcmpugtbi : GCCBuiltin<"__builtin_sw_vcmpugtbi">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty],
  [IntrNoMem]>;
def int_sw64_vsumw : GCCBuiltin<"__builtin_sw_vsumw">,
  Intrinsic<[llvm_i64_ty], [llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vsuml : GCCBuiltin<"__builtin_sw_vsuml">,
  Intrinsic<[llvm_i64_ty], [llvm_v4i64_ty],
  [IntrNoMem]>;
def int_sw64_vbinvw : GCCBuiltin<"__builtin_sw_vbinvw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vwinv : GCCBuiltin<"__builtin_sw_vwinv">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty],
  [IntrNoMem]>;
def int_sw64_vseleql : GCCBuiltin<"__builtin_sw_vseleql">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_v4i64_ty],
  [IntrNoMem]>;
def int_sw64_veqvb : GCCBuiltin<"__builtin_sw_veqvb">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [IntrNoMem]>;
def int_sw64_veqvh : GCCBuiltin<"__builtin_sw_veqvh">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty],
  [IntrNoMem]>;
def int_sw64_veqvl : GCCBuiltin<"__builtin_sw_veqvl">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty],
  [IntrNoMem]>;
def int_sw64_vsums : GCCBuiltin<"__builtin_sw_vsums">,
  Intrinsic<[llvm_float_ty], [llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vsumd : GCCBuiltin<"__builtin_sw_vsumd">,
  Intrinsic<[llvm_double_ty], [llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vfrecs : GCCBuiltin<"__builtin_sw_vfrecs">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vfrecd : GCCBuiltin<"__builtin_sw_vfrecd">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vfris : GCCBuiltin<"__builtin_sw_vfris">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vfris_g : GCCBuiltin<"__builtin_sw_vfris_g">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vfris_p : GCCBuiltin<"__builtin_sw_vfris_p">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vfris_z : GCCBuiltin<"__builtin_sw_vfris_z">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vfris_n : GCCBuiltin<"__builtin_sw_vfris_n">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vfrid : GCCBuiltin<"__builtin_sw_vfrid">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vfrid_g : GCCBuiltin<"__builtin_sw_vfrid_g">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vfrid_p : GCCBuiltin<"__builtin_sw_vfrid_p">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vfrid_z : GCCBuiltin<"__builtin_sw_vfrid_z">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vfrid_n : GCCBuiltin<"__builtin_sw_vfrid_n">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vmaxs : GCCBuiltin<"__builtin_sw_vmaxs">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vmins : GCCBuiltin<"__builtin_sw_vmins">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vmaxd : GCCBuiltin<"__builtin_sw_vmaxd">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vmind : GCCBuiltin<"__builtin_sw_vmind">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vfcvtsd : GCCBuiltin<"__builtin_sw_vfcvtsd">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f32_ty],
  [IntrNoMem]>;
def int_sw64_vfcvtds : GCCBuiltin<"__builtin_sw_vfcvtds">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vfcvtsh : GCCBuiltin<"__builtin_sw_vfcvtsh">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f32_ty, llvm_v4f32_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vfcvths : GCCBuiltin<"__builtin_sw_vfcvths">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f64_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vfcvtls : GCCBuiltin<"__builtin_sw_vfcvtls">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4i64_ty],
  [IntrNoMem]>;
def int_sw64_vfcvtld : GCCBuiltin<"__builtin_sw_vfcvtld">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4i64_ty],
  [IntrNoMem]>;
def int_sw64_vfcvtdl : GCCBuiltin<"__builtin_sw_vfcvtdl">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vfcvtdl_g : GCCBuiltin<"__builtin_sw_vfcvtdl_g">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vfcvtdl_p : GCCBuiltin<"__builtin_sw_vfcvtdl_p">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vfcvtdl_z : GCCBuiltin<"__builtin_sw_vfcvtdl_z">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vfcvtdl_n : GCCBuiltin<"__builtin_sw_vfcvtdl_n">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty],
  [IntrNoMem]>;
def int_sw64_vfcvtsl  : GCCBuiltin<"__builtin_sw_vfcvtsl">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f32_ty],
  [IntrNoMem]>;

//def int_sw64_vinsectlb  : GCCBuiltin<"__builtin_sw_vinsectlb">,
//  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
//  [IntrNoMem]>;
//def int_sw64_vinsectlh  : GCCBuiltin<"__builtin_sw_vinsectlh">,
//  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty],
//  [IntrNoMem]>;
//def int_sw64_vinsectlw  : GCCBuiltin<"__builtin_sw_vinsectlw">,
//  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
//  [IntrNoMem]>;
//def int_sw64_vinsectll  : GCCBuiltin<"__builtin_sw_vinsectll">,
//  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty],
//  [IntrNoMem]>;
def int_sw64_vshfq : GCCBuiltin<"__builtin_sw_vshfq">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i64_ty],
  [IntrNoMem]>;
def int_sw64_vshfqb : GCCBuiltin<"__builtin_sw_vshfqb">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [IntrNoMem]>;

def int_sw64_vsm3msw  : GCCBuiltin<"__builtin_sw_vsm3msw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_sw64_vsm3r  : GCCBuiltin<"__builtin_sw_vsm3r">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i32_ty],
  [IntrNoMem]>;
def int_sw64_vsm4key  : GCCBuiltin<"__builtin_sw_vsm4key">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty],
  [IntrNoMem]>;
def int_sw64_vsm4r  : GCCBuiltin<"__builtin_sw_vsm4r">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;


def int_sw64_vldw : GCCBuiltin<"__builtin_sw_vldw">,
  Intrinsic<[llvm_v8i32_ty], [llvm_ptr_ty, llvm_i32_ty],
  [IntrReadMem, IntrArgMemOnly]>;
def int_sw64_vldl : GCCBuiltin<"__builtin_sw_vldl">,
  Intrinsic<[llvm_v4i64_ty], [llvm_ptr_ty, llvm_i32_ty],
  [IntrReadMem, IntrArgMemOnly]>;
def int_sw64_vlds : GCCBuiltin<"__builtin_sw_vlds">,
  Intrinsic<[llvm_v4f32_ty], [llvm_ptr_ty, llvm_i32_ty],
  [IntrReadMem, IntrArgMemOnly]>;
def int_sw64_vldd : GCCBuiltin<"__builtin_sw_vldd">,
  Intrinsic<[llvm_v4f64_ty], [llvm_ptr_ty, llvm_i32_ty],
  [IntrReadMem, IntrArgMemOnly]>;

def int_sw64_vload : Intrinsic<[llvm_anyvector_ty], [llvm_anyptr_ty],
  [IntrReadMem, IntrArgMemOnly]>;
def int_sw64_vloadu : Intrinsic<[llvm_anyvector_ty], [llvm_anyptr_ty],
  [IntrReadMem, IntrArgMemOnly]>;
def int_sw64_vload_u : Intrinsic<[llvm_anyvector_ty], [llvm_anyptr_ty],
  [IntrReadMem, IntrArgMemOnly]>;
def int_sw64_vloade : Intrinsic<[llvm_anyvector_ty], [llvm_anyptr_ty],
  [IntrReadMem, IntrArgMemOnly]>;
def int_sw64_vloadnc : Intrinsic<[llvm_anyvector_ty], [llvm_anyptr_ty],
  [IntrReadMem, IntrArgMemOnly]>;
def int_sw64_vstore   : Intrinsic<[], [llvm_anyvector_ty, llvm_anyptr_ty],
  [IntrWriteMem, IntrArgMemOnly]>;
def int_sw64_vstoreu  : Intrinsic<[], [llvm_anyvector_ty, llvm_anyptr_ty],
  [IntrWriteMem, IntrArgMemOnly]>;
def int_sw64_vstore_u : Intrinsic<[], [llvm_anyvector_ty, llvm_anyptr_ty],
  [IntrWriteMem, IntrArgMemOnly]>;
def int_sw64_vstoreuh : Intrinsic<[], [llvm_anyvector_ty, llvm_anyptr_ty],
  [IntrWriteMem, IntrArgMemOnly]>;
def int_sw64_vstoreul : Intrinsic<[], [llvm_anyvector_ty, llvm_anyptr_ty],
  [IntrWriteMem, IntrArgMemOnly]>;
def int_sw64_vstorenc : Intrinsic<[], [llvm_anyvector_ty, llvm_anyptr_ty],
  [IntrWriteMem, IntrArgMemOnly]>;

def int_sw64_loadu : GCCBuiltin<"__builtin_sw_loadu">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty],
  [IntrReadMem, IntrArgMemOnly]>;

def int_sw64_loadu_i : GCCBuiltin<"__builtin_sw_loadu_i">,
  Intrinsic<[llvm_v8i32_ty], [llvm_ptr_ty, llvm_i32_ty],
  [IntrReadMem, IntrArgMemOnly]>;
def int_sw64_loadu_l : GCCBuiltin<"__builtin_sw_loadu_l">,
  Intrinsic<[llvm_v4i64_ty], [llvm_ptr_ty, llvm_i32_ty],
  [IntrReadMem, IntrArgMemOnly]>;
def int_sw64_loadu_f : GCCBuiltin<"__builtin_sw_loadu_f">,
  Intrinsic<[llvm_v4f32_ty], [llvm_ptr_ty, llvm_i32_ty],
  [IntrReadMem, IntrArgMemOnly]>;
def int_sw64_loadu_d : GCCBuiltin<"__builtin_sw_loadu_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_ptr_ty, llvm_i32_ty],
  [IntrReadMem, IntrArgMemOnly]>;

def int_sw64_load_u : GCCBuiltin<"__builtin_sw_load_u">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty],
  [IntrReadMem, IntrArgMemOnly]>;

}
