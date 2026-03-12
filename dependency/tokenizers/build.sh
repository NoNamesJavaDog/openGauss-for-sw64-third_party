#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# description: the script that builds tokenizers FFI for openGauss
# date: 2025-12-08
# version: 0.21.2

set -e

# ---- sw_64: Rust 1.58.1 incompatible (requires >=1.60), build C stub ----
if [ "$(uname -m)" = "sw_64" ]; then
    echo "[tokenizers] sw_64: Rust 1.58.1 too old, building C stub"
    BUILD_DIR=$(pwd)/install_comm
    ROOT_DIR=$(pwd)/../..
    OUTPUT_DIR=${ROOT_DIR}/output/kernel/dependency/tokenizers
    mkdir -p ${BUILD_DIR}/lib ${BUILD_DIR}/include
    cat > /tmp/tokenizers_stub.c << CEOF
#include <stdlib.h>
#include <stddef.h>
typedef void TokenizerHandle;
TokenizerHandle* tokenizer_from_file(const char* path) { return NULL; }
TokenizerHandle* tokenizer_from_str(const char* json_str) { return NULL; }
TokenizerHandle* tokenizer_from_str_with_base_dir(const char* json_str, const char* base_dir) { return NULL; }
void tokenizer_free(TokenizerHandle* handle) {}
int tokenizer_encode(const TokenizerHandle* handle, const char* text, unsigned int* token_ids, size_t max_ids) { return -1; }
int tokenizer_encode_batch(const TokenizerHandle* handle, const char** texts, size_t num_texts, unsigned int** token_ids_array, size_t max_ids_per_text, size_t* lengths) { return -1; }
const char* tokenizer_get_last_error(void) { return "sw_64: tokenizers not supported"; }
CEOF
    gcc -shared -fPIC -Wl,-z,relro,-z,now,-z,noexecstack \
        -o ${BUILD_DIR}/lib/libtokenizers.so /tmp/tokenizers_stub.c
    strip ${BUILD_DIR}/lib/libtokenizers.so
    cp -r install_comm install_llt
    mkdir -p ${OUTPUT_DIR}/comm ${OUTPUT_DIR}/llt
    cp -r install_comm/* ${OUTPUT_DIR}/comm/
    cp -r install_llt/* ${OUTPUT_DIR}/llt/
    echo "[tokenizers] sw_64 C stub done"
    exit 0
fi
# ----------------------------------------------------------------

PKG_FILE=tokenizers-0.21.2.tar.gz
SOURCE_DIR=tokenizers-0.21.2
BUILD_DIR=$(pwd)/install_comm
ROOT_DIR=$(pwd)/../..
OUTPUT_DIR=${ROOT_DIR}/output/kernel/dependency/tokenizers

# Clean previous builds
rm -rf ${SOURCE_DIR}
rm -rf install_*

echo "[tokenizers] Extracting source..."
tar -zxf ${PKG_FILE}
cd ${SOURCE_DIR}

echo "[tokenizers] Adding FFI support..."
# Add crate-type to [lib] section
sed -i '/^path = "src\/lib.rs"$/a crate-type = ["cdylib", "rlib"]' tokenizers/Cargo.toml

# Add libc dependency
sed -i '55i libc = "0.2"' tokenizers/Cargo.toml

# Add ffi module
echo 'pub mod ffi;' >> tokenizers/src/lib.rs

cat > tokenizers/src/ffi.rs << 'EOFFI'
//! C FFI bindings for tokenizers

#![allow(clippy::not_unsafe_ptr_arg_deref)]

use std::ffi::{CStr, CString};
use std::os::raw::{c_char, c_int};
use std::ptr;
use std::sync::{Arc, Mutex};
use std::fs;
use crate::tokenizer::Tokenizer;
use libc::size_t;

pub struct TokenizerHandle {
    tokenizer: Arc<Tokenizer>,
}

static LAST_ERROR: Mutex<Option<String>> = Mutex::new(None);

fn set_error(err: String) {
    if let Ok(mut error) = LAST_ERROR.lock() {
        *error = Some(err);
    }
}

fn clear_error() {
    if let Ok(mut error) = LAST_ERROR.lock() {
        *error = None;
    }
}

#[no_mangle]
pub extern "C" fn tokenizer_from_file(path: *const c_char) -> *mut TokenizerHandle {
    clear_error();
    if path.is_null() {
        set_error("Path is null".to_string());
        return ptr::null_mut();
    }
    let path_str = unsafe {
        match CStr::from_ptr(path).to_str() {
            Ok(s) => s,
            Err(e) => {
                set_error(format!("Invalid path string: {}", e));
                return ptr::null_mut();
            }
        }
    };
    match Tokenizer::from_file(path_str) {
        Ok(tokenizer) => Box::into_raw(Box::new(TokenizerHandle { tokenizer: Arc::new(tokenizer) })),
        Err(e) => {
            set_error(format!("Failed to load tokenizer: {}", e));
            ptr::null_mut()
        }
    }
}

#[no_mangle]
pub extern "C" fn tokenizer_from_str(json_str: *const c_char) -> *mut TokenizerHandle {
    clear_error();
    if json_str.is_null() {
        set_error("JSON string is null".to_string());
        return ptr::null_mut();
    }
    let json_str_rust = unsafe {
        match CStr::from_ptr(json_str).to_str() {
            Ok(s) => s,
            Err(e) => {
                set_error(format!("Invalid JSON string: {}", e));
                return ptr::null_mut();
            }
        }
    };
    let temp_file = std::env::current_dir().unwrap_or_else(|_| std::env::temp_dir()).join(format!("tokenizer_{}.json", std::process::id()));
    match fs::write(&temp_file, json_str_rust) {
        Ok(_) => {
            let result = match Tokenizer::from_file(temp_file.to_str().unwrap()) {
                Ok(tokenizer) => Box::into_raw(Box::new(TokenizerHandle { tokenizer: Arc::new(tokenizer) })),
                Err(e) => {
                    set_error(format!("Failed to load tokenizer from JSON: {}", e));
                    ptr::null_mut()
                }
            };
            let _ = fs::remove_file(&temp_file);
            result
        }
        Err(e) => {
            set_error(format!("Failed to create temp file: {}", e));
            ptr::null_mut()
        }
    }
}

#[no_mangle]
pub extern "C" fn tokenizer_from_str_with_base_dir(json_str: *const c_char, base_dir: *const c_char) -> *mut TokenizerHandle {
    clear_error();
    if json_str.is_null() {
        set_error("JSON string is null".to_string());
        return ptr::null_mut();
    }
    let json_str_rust = unsafe {
        match CStr::from_ptr(json_str).to_str() {
            Ok(s) => s,
            Err(e) => {
                set_error(format!("Invalid JSON string: {}", e));
                return ptr::null_mut();
            }
        }
    };
    let base_path = if base_dir.is_null() {
        std::env::current_dir().unwrap_or_else(|_| std::env::temp_dir())
    } else {
        let base_dir_str = unsafe {
            match CStr::from_ptr(base_dir).to_str() {
                Ok(s) => s,
                Err(e) => {
                    set_error(format!("Invalid base directory string: {}", e));
                    return ptr::null_mut();
                }
            }
        };
        std::path::PathBuf::from(base_dir_str)
    };
    let temp_file = base_path.join(format!("tokenizer_{}.json", std::process::id()));
    match fs::write(&temp_file, json_str_rust) {
        Ok(_) => {
            let original_dir = std::env::current_dir().ok();
            let _ = std::env::set_current_dir(&base_path);
            let result = match Tokenizer::from_file(temp_file.to_str().unwrap()) {
                Ok(tokenizer) => Box::into_raw(Box::new(TokenizerHandle { tokenizer: Arc::new(tokenizer) })),
                Err(e) => {
                    set_error(format!("Failed to load tokenizer: {}", e));
                    ptr::null_mut()
                }
            };
            if let Some(orig) = original_dir {
                let _ = std::env::set_current_dir(orig);
            }
            let _ = fs::remove_file(&temp_file);
            result
        }
        Err(e) => {
            set_error(format!("Failed to create temp file: {}", e));
            ptr::null_mut()
        }
    }
}

#[no_mangle]
pub extern "C" fn tokenizer_free(handle: *mut TokenizerHandle) {
    if !handle.is_null() {
        unsafe { let _ = Box::from_raw(handle); }
    }
}

#[no_mangle]
pub extern "C" fn tokenizer_encode(handle: *const TokenizerHandle, text: *const c_char, token_ids: *mut u32, max_ids: size_t) -> c_int {
    clear_error();
    if handle.is_null() || text.is_null() || token_ids.is_null() {
        set_error("Null pointer argument".to_string());
        return -1;
    }
    let text_str = unsafe {
        match CStr::from_ptr(text).to_str() {
            Ok(s) => s,
            Err(e) => {
                set_error(format!("Invalid text string: {}", e));
                return -1;
            }
        }
    };
    let tokenizer = unsafe { &(*handle).tokenizer };
    match tokenizer.encode(text_str, false) {
        Ok(encoding) => {
            let ids = encoding.get_ids();
            let len = ids.len().min(max_ids);
            unsafe {
                let ids_slice = std::slice::from_raw_parts_mut(token_ids, max_ids);
                for (i, &id) in ids.iter().take(len).enumerate() {
                    ids_slice[i] = id;
                }
            }
            len as c_int
        }
        Err(e) => {
            set_error(format!("Encoding failed: {}", e));
            -1
        }
    }
}

#[no_mangle]
pub extern "C" fn tokenizer_encode_batch(handle: *const TokenizerHandle, texts: *const *const c_char, num_texts: size_t, token_ids_array: *mut *mut u32, max_ids_per_text: size_t, lengths: *mut size_t) -> c_int {
    clear_error();
    if handle.is_null() || texts.is_null() || token_ids_array.is_null() || lengths.is_null() {
        set_error("Null pointer argument".to_string());
        return -1;
    }
    let tokenizer = unsafe { &(*handle).tokenizer };
    unsafe {
        let texts_slice = std::slice::from_raw_parts(texts, num_texts);
        let lengths_slice = std::slice::from_raw_parts_mut(lengths, num_texts);
        let token_ids_slice = std::slice::from_raw_parts_mut(token_ids_array, num_texts);
        for i in 0..num_texts {
            if texts_slice[i].is_null() {
                lengths_slice[i] = 0;
                continue;
            }
            let text_str = match CStr::from_ptr(texts_slice[i]).to_str() {
                Ok(s) => s,
                Err(e) => {
                    set_error(format!("Invalid text string at index {}: {}", i, e));
                    lengths_slice[i] = 0;
                    continue;
                }
            };
            match tokenizer.encode(text_str, false) {
                Ok(encoding) => {
                    let ids = encoding.get_ids();
                    let len = ids.len().min(max_ids_per_text);
                    lengths_slice[i] = len;
                    if !token_ids_slice[i].is_null() {
                        let ids_slice = std::slice::from_raw_parts_mut(token_ids_slice[i], max_ids_per_text);
                        for (j, &id) in ids.iter().take(len).enumerate() {
                            ids_slice[j] = id;
                        }
                    }
                }
                Err(e) => {
                    set_error(format!("Encoding failed for text at index {}: {}", i, e));
                    lengths_slice[i] = 0;
                }
            }
        }
    }
    0
}

#[no_mangle]
pub extern "C" fn tokenizer_get_last_error() -> *const c_char {
    if let Ok(error) = LAST_ERROR.lock() {
        if let Some(ref err) = *error {
            return err.as_ptr() as *const c_char;
        }
    }
    ptr::null()
}

#[no_mangle]
pub extern "C" fn tokenizer_get_last_error_copy() -> *mut c_char {
    if let Ok(error) = LAST_ERROR.lock() {
        if let Some(ref err) = *error {
            match CString::new(err.clone()) {
                Ok(cstr) => cstr.into_raw(),
                Err(_) => ptr::null_mut(),
            }
        } else {
            ptr::null_mut()
        }
    } else {
        ptr::null_mut()
    }
}

#[no_mangle]
pub extern "C" fn tokenizer_free_error_string(s: *mut c_char) {
    if !s.is_null() {
        unsafe { let _ = CString::from_raw(s); }
    }
}
EOFFI

# Check if Rust/Cargo is available
if ! command -v cargo &> /dev/null; then
    echo "Error: Rust/Cargo not found. Please install Rust first."
    echo "Run: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    exit 1
fi

echo "[tokenizers] Using Cargo: $(which cargo)"
echo "[tokenizers] Rust version: $(rustc --version)"

echo "[tokenizers] Building Rust FFI library..."
cd tokenizers
cargo build --release

echo "[tokenizers] Installing files..."
cd ../..
mkdir -p ${BUILD_DIR}/lib
mkdir -p ${BUILD_DIR}/include

# Copy library file
if [ -f ${SOURCE_DIR}/tokenizers/target/release/libtokenizers.so ]; then
    cp ${SOURCE_DIR}/tokenizers/target/release/libtokenizers.so ${BUILD_DIR}/lib/
    strip ${BUILD_DIR}/lib/libtokenizers.so
    echo "Installed: libtokenizers.so"
else
    echo "Error: Could not find compiled library in ${SOURCE_DIR}/tokenizers/target/release/"
    exit 1
fi

cat > ${BUILD_DIR}/include/tokenizers_ffi.h << 'EOFH'
#ifndef TOKENIZERS_FFI_H
#define TOKENIZERS_FFI_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef void* TokenizerHandle;

TokenizerHandle tokenizer_from_file(const char* path);

void tokenizer_free(TokenizerHandle handle);

int tokenizer_encode(TokenizerHandle handle, const char* text, uint32_t* token_ids, size_t max_ids);

int tokenizer_encode_batch(TokenizerHandle handle, const char** texts, size_t num_texts, uint32_t** token_ids_array, size_t max_ids_per_text, size_t* lengths);

const char* tokenizer_get_last_error(void);

char* tokenizer_get_last_error_copy(void);

void tokenizer_free_error_string(char* s);

#ifdef __cplusplus
}
#endif

#endif /* TOKENIZERS_FFI_H */
EOFH

echo "Generated: tokenizers_ffi.h"

# Copy for llt version
cp -r install_comm install_llt

# Create output directories
mkdir -p ${OUTPUT_DIR}/comm
mkdir -p ${OUTPUT_DIR}/llt

# Copy to output
cp -r install_comm/* ${OUTPUT_DIR}/comm/
cp -r install_llt/* ${OUTPUT_DIR}/llt/

echo "[tokenizers] Build completed successfully!"
echo "Output: ${OUTPUT_DIR}"
echo "Files: libtokenizers.so, tokenizers_ffi.h"

