#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2024. All rights reserved.
# description: the script that make install text-splitter FFI
# date: 2024-12-06
# version: 0.28.0

set -e

# ---- sw_64: Rust 1.58.1 incompatible (requires 1.82.0), build C stub ----
if [ "$(uname -m)" = "sw_64" ]; then
    echo "[text-splitter] sw_64: Rust 1.58.1 < 1.82.0, building C stub"
    BUILD_DIR=$(pwd)/install_comm
    ROOT_DIR=$(pwd)/../..
    OUTPUT_DIR=${ROOT_DIR}/output/kernel/dependency/text-splitter
    mkdir -p ${BUILD_DIR}/lib ${BUILD_DIR}/include
    cat > /tmp/text_splitter_stub.c << CEOF
#include <stdlib.h>
void* CreateTextSplitter(int max_chunk_size, int max_chunk_overlap) { return NULL; }
void  FreeTextSplitter(void* handle) {}
char** SplitText(void* handle, const char* document, int* chunk_num) {
    if (chunk_num) *chunk_num = 0; return NULL; }
void  FreeSplitResult(char** chunks) {}
CEOF
    gcc -shared -fPIC -Wl,-z,relro,-z,now,-z,noexecstack \
        -o ${BUILD_DIR}/lib/libtext_splitter_ffi.so /tmp/text_splitter_stub.c
    strip ${BUILD_DIR}/lib/libtext_splitter_ffi.so
    cat > ${BUILD_DIR}/include/text_splitter_wrapper.h << HEOF
#ifndef TEXT_SPLITTER_WRAPPER_H
#define TEXT_SPLITTER_WRAPPER_H
#ifdef __cplusplus
extern "C" {
#endif
typedef void* TextSplitterHandle;
TextSplitterHandle CreateTextSplitter(int max_chunk_size, int max_chunk_overlap);
void FreeTextSplitter(TextSplitterHandle handle);
char** SplitText(TextSplitterHandle handle, const char* document, int* chunk_num);
void FreeSplitResult(char** chunks);
#ifdef __cplusplus
}
#endif
#endif
HEOF
    cp -r install_comm install_llt
    mkdir -p ${OUTPUT_DIR}/comm ${OUTPUT_DIR}/llt
    cp -r install_comm/* ${OUTPUT_DIR}/comm/
    cp -r install_llt/* ${OUTPUT_DIR}/llt/
    echo "[text-splitter] sw_64 C stub done"
    exit 0
fi
# ----------------------------------------------------------------

# 变量定义
BUILD_DIR=$(pwd)/install_comm
ROOT_DIR=$(pwd)/../..
OUTPUT_DIR=${ROOT_DIR}/output/kernel/dependency/text-splitter
FFI_DIR=$(pwd)/text_splitter_ffi_build

# 清理旧文件
rm -rf install_* ${FFI_DIR} text-splitter-0.28.0

# 解压本地 text-splitter 源码（避免从 registry 拉取）
echo "[text-splitter] Extracting local source..."
tar -zxf text-splitter-v0.28.0.tar.gz

# 创建FFI项目目录
echo "[text-splitter] Creating FFI project..."
mkdir -p ${FFI_DIR}/src

# 创建Cargo.toml
cat > ${FFI_DIR}/Cargo.toml << 'EOF'
[package]
name = "text_splitter_ffi"
version = "0.28.0"
edition = "2021"

[lib]
crate-type = ["cdylib"]

[dependencies]
text-splitter = { path = "../text-splitter-0.28.0" }
libc = "0.2"
EOF

# 创建src/lib.rs
cat > ${FFI_DIR}/src/lib.rs << 'EOF'
use std::ffi::{CStr, CString};
use std::os::raw::{c_char, c_int};
use text_splitter::{TextSplitter, ChunkConfig, Characters};

pub struct TextSplitterHandle {
    splitter: TextSplitter<Characters>,
}

#[no_mangle]
pub extern "C" fn CreateTextSplitter(max_chunk_size: c_int, max_chunk_overlap: c_int) -> *mut TextSplitterHandle {
    if max_chunk_size <= 0 {
        return std::ptr::null_mut();
    }
    let cfg = match ChunkConfig::new(max_chunk_size as usize)
        .with_overlap(max_chunk_overlap as usize) {
        Ok(cfg) => cfg,
        Err(_) => return std::ptr::null_mut(),
    };
    let splitter = TextSplitter::new(cfg);
    let handle = Box::new(TextSplitterHandle { splitter });
    Box::into_raw(handle)
}

#[no_mangle]
pub extern "C" fn FreeTextSplitter(handle: *mut TextSplitterHandle) {
    if !handle.is_null() {
        let _ = unsafe { Box::from_raw(handle) };
    }
}

#[no_mangle]
pub extern "C" fn SplitText(
    handle: *mut TextSplitterHandle,
    document: *const c_char,
    chunk_num: *mut c_int
) -> *mut *mut c_char {
    if handle.is_null() || document.is_null() || chunk_num.is_null() {
        return std::ptr::null_mut();
    }

    unsafe {
        let c_str = CStr::from_ptr(document);
        let text_str = match c_str.to_str() {
            Ok(s) => s,
            Err(_) => return std::ptr::null_mut(),
        };

        let chunks = (*handle).splitter.chunks(text_str).collect::<Vec<_>>();
        *chunk_num = chunks.len() as c_int;

        let mut result: Vec<*mut c_char> = Vec::with_capacity(chunks.len() + 1);
        for chunk in chunks {
            match CString::new(chunk) {
                Ok(c_str) => result.push(c_str.into_raw()),
                Err(_) => {
                    for ptr in result {
                        let _ = CString::from_raw(ptr);
                    }
                    return std::ptr::null_mut();
                }
            }
        }
        result.push(std::ptr::null_mut());
        let result_ptr = result.as_mut_ptr();
        std::mem::forget(result);
        result_ptr
    }
}

#[no_mangle]
pub extern "C" fn FreeSplitResult(chunks: *mut *mut c_char) {
    if chunks.is_null() {
        return;
    }

    unsafe {
        let mut count = 0;
        let mut current = chunks;
        while !(*current).is_null() {
            count += 1;
            current = current.add(1);
        }

        for i in 0..count {
            let ptr = *chunks.add(i);
            let _ = CString::from_raw(ptr);
        }

        let _ = Vec::from_raw_parts(chunks, count + 1, count + 1);
    }
}
EOF

# 创建头文件
cat > ${FFI_DIR}/text_splitter_wrapper.h << 'EOF'
#ifndef TEXT_SPLITTER_WRAPPER_H
#define TEXT_SPLITTER_WRAPPER_H

#ifdef __cplusplus
extern "C" {
#endif

typedef void* TextSplitterHandle;

TextSplitterHandle CreateTextSplitter(int max_chunk_size, int max_chunk_overlap);
void FreeTextSplitter(TextSplitterHandle handle);
char** SplitText(TextSplitterHandle handle, const char* document, int* chunk_num);
void FreeSplitResult(char** chunks);

#ifdef __cplusplus
}
#endif

#endif
EOF

# 检查Rust环境
if ! command -v cargo &> /dev/null; then
    echo "Error: Rust/Cargo not found. Please install Rust first."
    exit 1
fi

# 编译
echo "[text-splitter] Building Rust FFI library..."
cd ${FFI_DIR}
export RUSTFLAGS="-C relocation-model=pic -C link-arg=-Wl,-z,relro,-z,now,-z,noexecstack"
cargo build --release

# 安装
echo "[text-splitter] Installing..."
mkdir -p ${BUILD_DIR}/lib
mkdir -p ${BUILD_DIR}/include

cp target/release/libtext_splitter_ffi.so ${BUILD_DIR}/lib/
cp text_splitter_wrapper.h ${BUILD_DIR}/include/

# Strip
strip ${BUILD_DIR}/lib/libtext_splitter_ffi.so

# 复制到llt
cd $(dirname ${FFI_DIR})
cp -r install_comm install_llt

# 输出
mkdir -p ${OUTPUT_DIR}/comm ${OUTPUT_DIR}/llt
cp -r install_comm/* ${OUTPUT_DIR}/comm/
cp -r install_llt/* ${OUTPUT_DIR}/llt/

echo "[text-splitter] Build completed!"
