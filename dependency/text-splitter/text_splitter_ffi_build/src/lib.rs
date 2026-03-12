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
