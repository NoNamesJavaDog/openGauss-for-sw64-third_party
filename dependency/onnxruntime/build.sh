#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# description: the script that installs ONNX Runtime and builds onnx_wrapper for embedding
# date: 2025-12-14
# version: 1.22.0

set -e

# ---- sw_64: onnxruntime cmake build not supported, build C stubs ----
if [ "$(uname -m)" = "sw_64" ]; then
    echo "[onnxruntime] sw_64: building C stubs for libonnxruntime + libonnx_wrapper"
    VERSION=1.16.3
    BUILD_DIR=$(pwd)/install_comm
    ROOT_DIR=$(pwd)/../..
    OUTPUT_DIR=${ROOT_DIR}/output/kernel/dependency/onnxruntime
    mkdir -p ${BUILD_DIR}/lib ${BUILD_DIR}/include

    # libonnxruntime stub (empty, just needs to exist for linker)
    echo "/* stub */" > /tmp/onnxrt_stub.c
    gcc -shared -fPIC -Wl,-z,relro,-z,now,-z,noexecstack \
        -o ${BUILD_DIR}/lib/libonnxruntime.so.${VERSION} /tmp/onnxrt_stub.c
    strip ${BUILD_DIR}/lib/libonnxruntime.so.${VERSION}
    cd ${BUILD_DIR}/lib
    ln -sf libonnxruntime.so.${VERSION} libonnxruntime.so.1
    ln -sf libonnxruntime.so.1 libonnxruntime.so
    cd - > /dev/null

    # libonnx_wrapper stub with full API
    cat > /tmp/onnx_wrapper_stub.c << CEOF
#include <stdlib.h>
typedef void* ONNXModelHandle;
typedef void* ONNXEnvHandle;
ONNXEnvHandle ONNXEnvCreate(void) { return NULL; }
void ONNXEnvRelease(ONNXEnvHandle h) {}
ONNXModelHandle ONNXLoadModel(ONNXEnvHandle env, const char* modelPath, const char* tokenizerPath, int* dim) {
    if (dim) *dim = 0; return NULL; }
void ONNXUnloadModel(ONNXModelHandle h) {}
int ONNXEmbeddingInfer(ONNXModelHandle h, const char* text, float* embedding, int dim) { return 0; }
int ONNXEmbeddingInferBatch(ONNXModelHandle h, char** texts, int numTexts, float** embeddings, int dim) { return 0; }
int ONNXGetEmbeddingDim(ONNXModelHandle h) { return -1; }
CEOF
    gcc -shared -fPIC -Wl,-z,relro,-z,now,-z,noexecstack \
        -o ${BUILD_DIR}/lib/libonnx_wrapper.so /tmp/onnx_wrapper_stub.c
    strip ${BUILD_DIR}/lib/libonnx_wrapper.so

    # header
    cat > ${BUILD_DIR}/include/onnx_wrapper.h << HEOF
#ifndef ONNX_WRAPPER_H
#define ONNX_WRAPPER_H
#ifdef __cplusplus
extern "C" {
#endif
typedef void* ONNXModelHandle;
typedef void* ONNXEnvHandle;
ONNXEnvHandle ONNXEnvCreate(void);
void ONNXEnvRelease(ONNXEnvHandle h);
ONNXModelHandle ONNXLoadModel(ONNXEnvHandle env, const char* modelPath, const char* tokenizerPath, int* dim);
void ONNXUnloadModel(ONNXModelHandle h);
int ONNXEmbeddingInfer(ONNXModelHandle h, const char* text, float* embedding, int dim);
int ONNXEmbeddingInferBatch(ONNXModelHandle h, char** texts, int numTexts, float** embeddings, int dim);
int ONNXGetEmbeddingDim(ONNXModelHandle h);
#ifdef __cplusplus
}
#endif
#endif
HEOF

    cp -r install_comm install_llt
    mkdir -p ${OUTPUT_DIR}/comm ${OUTPUT_DIR}/llt
    cp -r install_comm/* ${OUTPUT_DIR}/comm/
    cp -r install_llt/* ${OUTPUT_DIR}/llt/
    echo "[onnxruntime] sw_64 C stubs done"
    exit 0
fi
# ----------------------------------------------------------------

export ONNX_PYTHONHOME=/usr1/build/workspace/dependency/Python-3.8.3
export PATH=$ONNX_PYTHONHOME/bin:$PATH
export LD_LIBRARY_PATH=$ONNX_PYTHONHOME/lib:$LD_LIBRARY_PATH
echo "[onnxruntime] Python version: $(python3 --version)"

export ONNX_CMAKEHOME=/usr1/build/workspace/dependency/cmake-3.26.0
export LD_LIBRARY_PATH=$ONNX_CMAKEHOME/lib:$LD_LIBRARY_PATH
export PATH=$ONNX_CMAKEHOME/bin:$PATH
echo "[onnxruntime] CMake version: $(cmake --version)"

if [ -f /etc/centos-release ]; then
    export ONNX_BINUTILS=/usr1/build/workspace/dependency/binutils-2.40
    export LD_LIBRARY_PATH=$ONNX_BINUTILS/lib:$LD_LIBRARY_PATH
    export PATH=$ONNX_BINUTILS/bin:$PATH
    echo "[onnxruntime] Binutils version: $(ld --version)"
fi

VERSION=1.16.3
PKG_FILE=v1.16.3.tar.gz
BUILD_DIR=$(pwd)/install_comm
ROOT_DIR=$(pwd)/../..
OUTPUT_DIR=${ROOT_DIR}/output/kernel/dependency/onnxruntime
FFI_DIR=$(pwd)/onnx_wrapper_build


ARCH=$(uname -m)
echo "[onnxruntime] Version: ${VERSION}"
echo "[onnxruntime] Architecture: ${ARCH}"
echo "[onnxruntime] Package: ${PKG_FILE}"

if [ ! -f "${PKG_FILE}" ]; then
    echo "Error: Prebuilt package not found: ${PKG_FILE}"
    echo ""
    echo "Please download from:"
    echo "https://github.com/microsoft/onnxruntime/archive/refs/tags/${PKG_FILE}"
    exit 1
fi

rm -rf onnxruntime-${VERSION}
rm -rf install_* ${FFI_DIR}

echo "[onnxruntime] Extracting prebuilt package..."
mkdir -p onnxruntime-${VERSION}
tar -zxf ${PKG_FILE} -C onnxruntime-${VERSION} --strip-components 1
cd onnxruntime-${VERSION}
sed -i 's|^eigen;.*|eigen;https://github.com/eigenteam/eigen-git-mirror/archive/e7248b26a1ed53fa030c5c459f7ea095dfd276ac/eigen-e7248b26a1ed53fa030c5c459f7ea095dfd276ac.zip;ca78943c7e45fa6fe31de288306e9e51a5eee60f|' cmake/deps.txt
sed -i 's|-Xlinker -rpath=\\\$ORIGIN||g' cmake/onnxruntime.cmake
sed -i "s|-Wl,-rpath='\\\$ORIGIN'||g" cmake/onnxruntime.cmake
sed -i "s|-Wl,-rpath=\"\\\$ORIGIN\"||g" cmake/onnxruntime.cmake
sed -i 's|INSTALL_RPATH "@loader_path"||g' cmake/onnxruntime.cmake
sed -i 's|BUILD_WITH_INSTALL_RPATH TRUE|BUILD_WITH_INSTALL_RPATH FALSE|g' cmake/onnxruntime.cmake

./build.sh --config Release --build_shared_lib --parallel --compile_no_warning_as_error --skip_submodule_sync --allow_running_as_root --skip-keras-test --skip_onnx_tests --skip_tests --build_dir build \
    --cmake_extra_defines CMAKE_C_FLAGS="-fstack-protector-strong -D_FORTIFY_SOURCE=2 -O2" \
    --cmake_extra_defines CMAKE_CXX_FLAGS="-fstack-protector-strong -D_FORTIFY_SOURCE=2 -O2" \
    --cmake_extra_defines CMAKE_SHARED_LINKER_FLAGS="-Wl,-z,relro,-z,now,-z,noexecstack" \
    --cmake_extra_defines CMAKE_EXE_LINKER_FLAGS="-Wl,-z,relro,-z,now,-z,noexecstack"
echo "[onnxruntime] Installing from: $(pwd)"

# 编译产物目录
COMPILE_OUTPUT_DIR=$(pwd)/build/Release

mkdir -p ${BUILD_DIR}/lib
mkdir -p ${BUILD_DIR}/include

# ============================================
# 复制库文件
# ============================================
echo "[onnxruntime] Copying library files..."

if [ -f "${COMPILE_OUTPUT_DIR}/libonnxruntime.so.${VERSION}" ]; then
    cp ${COMPILE_OUTPUT_DIR}/libonnxruntime.so.${VERSION} ${BUILD_DIR}/lib/
    # 创建符号链接
    cd ${BUILD_DIR}/lib
    ln -sf libonnxruntime.so.${VERSION} libonnxruntime.so.1
    ln -sf libonnxruntime.so.1 libonnxruntime.so
    cd - > /dev/null
    echo "  - Installed libonnxruntime.so.${VERSION}"
else
    echo "Error: libonnxruntime.so.${VERSION} not found in ${COMPILE_OUTPUT_DIR}"
    exit 1
fi

# ============================================
# 复制头文件 (匹配官方预编译包结构)
# ============================================
echo "[onnxruntime] Copying header files..."

# 源码中头文件的位置
SESSION_INCLUDE_DIR=$(pwd)/include/onnxruntime/core/session
PROVIDERS_INCLUDE_DIR=$(pwd)/include/onnxruntime/core/providers/cpu
FRAMEWORK_INCLUDE_DIR=$(pwd)/include/onnxruntime/core/framework
TRAINING_INCLUDE_DIR=$(pwd)/orttraining/orttraining/training_api/include

# 1. 核心 Session 头文件
if [ -d "${SESSION_INCLUDE_DIR}" ]; then
    cp ${SESSION_INCLUDE_DIR}/onnxruntime_c_api.h ${BUILD_DIR}/include/
    cp ${SESSION_INCLUDE_DIR}/onnxruntime_cxx_api.h ${BUILD_DIR}/include/
    cp ${SESSION_INCLUDE_DIR}/onnxruntime_cxx_inline.h ${BUILD_DIR}/include/
    cp ${SESSION_INCLUDE_DIR}/onnxruntime_float16.h ${BUILD_DIR}/include/
    cp ${SESSION_INCLUDE_DIR}/onnxruntime_session_options_config_keys.h ${BUILD_DIR}/include/
    cp ${SESSION_INCLUDE_DIR}/onnxruntime_run_options_config_keys.h ${BUILD_DIR}/include/
    echo "  - Installed core session headers"
else
    echo "Error: session include directory not found at ${SESSION_INCLUDE_DIR}"
    exit 1
fi

# 2. CPU Provider 头文件
if [ -f "${PROVIDERS_INCLUDE_DIR}/cpu_provider_factory.h" ]; then
    cp ${PROVIDERS_INCLUDE_DIR}/cpu_provider_factory.h ${BUILD_DIR}/include/
    echo "  - Installed cpu_provider_factory.h"
fi

# 3. Framework 头文件
if [ -f "${FRAMEWORK_INCLUDE_DIR}/provider_options.h" ]; then
    cp ${FRAMEWORK_INCLUDE_DIR}/provider_options.h ${BUILD_DIR}/include/
    echo "  - Installed provider_options.h"
fi

# 4. Training API 头文件 (可选)
if [ -d "${TRAINING_INCLUDE_DIR}" ]; then
    if [ -f "${TRAINING_INCLUDE_DIR}/onnxruntime_training_c_api.h" ]; then
        cp ${TRAINING_INCLUDE_DIR}/onnxruntime_training_c_api.h ${BUILD_DIR}/include/
        cp ${TRAINING_INCLUDE_DIR}/onnxruntime_training_cxx_api.h ${BUILD_DIR}/include/
        cp ${TRAINING_INCLUDE_DIR}/onnxruntime_training_cxx_inline.h ${BUILD_DIR}/include/
        echo "  - Installed training API headers"
    fi
fi

# 5. 复制生成的配置头文件
if [ -f "${COMPILE_OUTPUT_DIR}/onnxruntime_config.h" ]; then
    cp ${COMPILE_OUTPUT_DIR}/onnxruntime_config.h ${BUILD_DIR}/include/
    echo "  - Installed onnxruntime_config.h"
fi

echo "[onnxruntime] Header files installed:"
ls -la ${BUILD_DIR}/include/

# ============================================
# Strip 库文件以减小体积
# ============================================
echo "[onnxruntime] Stripping library files..."
find ${BUILD_DIR}/lib -name "*.so*" -type f -exec strip {} \; 2>/dev/null || true

echo "[onnxruntime] Library installation completed"
echo "  Libraries: ${BUILD_DIR}/lib/"
ls -la ${BUILD_DIR}/lib/
echo "  Headers: ${BUILD_DIR}/include/"
ls -la ${BUILD_DIR}/include/

# ============================================
# Create onnx_wrapper project (embedding support)
# ============================================
echo "[onnxruntime] Creating onnx_wrapper project for embedding..."
mkdir -p ${FFI_DIR}

cat > ${FFI_DIR}/CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.10)
project(onnx_wrapper VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(ONNXRUNTIME_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../install_comm" CACHE PATH "ONNX Runtime installation directory")

if(NOT EXISTS "${ONNXRUNTIME_ROOT}/include/onnxruntime_cxx_api.h")
    message(FATAL_ERROR "ONNX Runtime not found at ${ONNXRUNTIME_ROOT}")
endif()

set(TOKENIZERS_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../../tokenizers/install_comm" CACHE PATH "Tokenizers installation directory")

if(NOT EXISTS "${TOKENIZERS_ROOT}/include/tokenizers_ffi.h")
    message(FATAL_ERROR "Tokenizers not found at ${TOKENIZERS_ROOT}. Please build tokenizers first with FULL_OUTPUT=1")
endif()

message(STATUS "Found tokenizers at ${TOKENIZERS_ROOT}")

include_directories(${ONNXRUNTIME_ROOT}/include)
include_directories(${TOKENIZERS_ROOT}/include)

link_directories(${ONNXRUNTIME_ROOT}/lib)
link_directories(${TOKENIZERS_ROOT}/lib)

add_definitions(-DUSE_TOKENIZERS)

add_library(onnx_wrapper SHARED
    onnx_wrapper.cpp
)

target_link_libraries(onnx_wrapper
    onnxruntime
    tokenizers
)

set_target_properties(onnx_wrapper PROPERTIES
    VERSION ${PROJECT_VERSION}
    SOVERSION 1
    PUBLIC_HEADER onnx_wrapper.h
)

install(TARGETS onnx_wrapper
    LIBRARY DESTINATION lib
    PUBLIC_HEADER DESTINATION include
)
EOF

cat > ${FFI_DIR}/onnx_wrapper.h << 'EOF'
#ifndef ONNX_WRAPPER_H
#define ONNX_WRAPPER_H

#ifdef __cplusplus
extern "C" {
#endif

typedef void* ONNXModelHandle;
typedef void* ONNXEnvHandle;

/**
 * @brief Create ONNX runtime environment handle
 * @return ONNX runtime env handle, NULL if error
 */
ONNXEnvHandle ONNXEnvCreate();

/**
 * @brief Release ONNX runtime environment
 * @param onnxEnvHandle ONNX env instance
 */
void ONNXEnvRelease(ONNXEnvHandle onnxEnvHandle);

/**
 * @brief Load ONNX model for embedding
 * @param onnxEnvHandle ONNX env instance
 * @param modelPath Path to model file
 * @param tokenizerPath Path to tokenizer.json (can be NULL)
 * @param dim Output: embedding dimension
 * @return Model handle, NULL if error
 */
ONNXModelHandle ONNXLoadModel(ONNXEnvHandle onnxEnvHandle,
                               const char* modelPath,
                               const char* tokenizerPath,
                               int* dim);

/**
 * @brief Load ONNX model from directory (auto-detect tokenizer)
 * @param onnxEnvHandle ONNX env instance
 * @param modelDir Model directory
 * @param modelFile Model filename (e.g., "model.onnx")
 * @param dim Output: embedding dimension
 * @return Model handle, NULL if error
 */
ONNXModelHandle ONNXLoadModelFromDir(ONNXEnvHandle onnxEnvHandle,
                                     const char* modelDir,
                                     const char* modelFile,
                                     int* dim);

/**
 * @brief Unload ONNX model
 * @param handle Model handle
 */
void ONNXUnloadModel(ONNXModelHandle handle);

/**
 * @brief Perform embedding inference on single text
 * @param handle Model handle
 * @param text Input text
 * @param embedding Output embedding vector (caller allocates)
 * @param dim Embedding dimension
 * @return 1 on success, 0 on failure
 */
int ONNXEmbeddingInfer(ONNXModelHandle handle,
                       const char* text,
                       float* embedding,
                       int dim);

/**
 * @brief Perform embedding inference on multiple texts (batch)
 * @param handle Model handle
 * @param texts Input text array
 * @param numTexts Number of texts
 * @param embeddings Output embedding array (caller allocates)
 * @param dim Embedding dimension
 * @return 1 on success, 0 on failure
 */
int ONNXEmbeddingInferBatch(ONNXModelHandle handle,
                            char** texts,
                            int numTexts,
                            float** embeddings,
                            int dim);

/**
 * @brief Get embedding dimension
 * @param handle Model handle
 * @return Embedding dimension, -1 if model not loaded
 */
int ONNXGetEmbeddingDim(ONNXModelHandle handle);

#ifdef __cplusplus
}
#endif

#endif // ONNX_WRAPPER_H
EOF

cat > ${FFI_DIR}/onnx_wrapper.cpp << 'EOF'
#include "onnx_wrapper.h"
#include <onnxruntime_cxx_api.h>
#include <vector>
#include <string>
#include <memory>
#include <cstring>
#include <algorithm>
#include <fstream>
#include <cmath>

extern "C" {
    typedef void* TokenizerHandle;
    TokenizerHandle tokenizer_from_file(const char* path);
    void tokenizer_free(TokenizerHandle handle);
    int tokenizer_encode(TokenizerHandle handle, const char* text, uint32_t* ids, size_t max_len);
    const char* tokenizer_get_last_error();
}

struct ONNXEnv {
    Ort::Env env;
    Ort::SessionOptions session_options;

    ONNXEnv() : env(ORT_LOGGING_LEVEL_WARNING, "ONNXWrapper") {
        session_options.SetIntraOpNumThreads(4);
        session_options.SetGraphOptimizationLevel(GraphOptimizationLevel::ORT_ENABLE_BASIC);
    }
};

class TokenizerWrapper {
public:
    TokenizerHandle tokenizer;
    bool has_tokenizer;
    static constexpr size_t MAX_TOKENS = 512;

    TokenizerWrapper() : tokenizer(nullptr), has_tokenizer(false) {}

    ~TokenizerWrapper() {
        if (tokenizer != nullptr) {
            tokenizer_free(tokenizer);
        }
    }

    bool loadFromFile(const char* path) {
        if (!path) return false;
        tokenizer = tokenizer_from_file(path);
        has_tokenizer = (tokenizer != nullptr);
        if (!has_tokenizer) {
            const char* error = tokenizer_get_last_error();
            if (error) {
                fprintf(stderr, "Failed to load tokenizer: %s\n", error);
            }
        }
        return has_tokenizer;
    }

    std::vector<int64_t> encode(const char* text) {
        std::vector<int64_t> token_ids;
        if (!has_tokenizer || !text) return token_ids;

        std::vector<uint32_t> temp_ids(MAX_TOKENS);
        int result = tokenizer_encode(tokenizer, text, temp_ids.data(), MAX_TOKENS);

        if (result > 0) {
            token_ids.reserve(result);
            for (int i = 0; i < result; i++) {
                token_ids.push_back(static_cast<int64_t>(temp_ids[i]));
            }
        } else {
            const char* error = tokenizer_get_last_error();
            if (error) {
                fprintf(stderr, "Tokenizer encode failed: %s\n", error);
            }
        }
        return token_ids;
    }
};

struct ONNXModel {
    std::shared_ptr<ONNXEnv> env_ptr;
    std::unique_ptr<Ort::Session> session;
    std::unique_ptr<TokenizerWrapper> tokenizer;
    int embedding_dim;
    std::vector<std::string> input_names;
    std::vector<std::string> output_names;

    ONNXModel(std::shared_ptr<ONNXEnv> env)
        : env_ptr(env), embedding_dim(-1) {}
};

static void normalize_vector(float* vec, int dim) {
    float norm = 0.0f;
    for (int i = 0; i < dim; i++) {
        norm += vec[i] * vec[i];
    }
    norm = std::sqrt(norm);
    if (norm > 1e-12f) {
        for (int i = 0; i < dim; i++) {
            vec[i] /= norm;
        }
    }
}

static void mean_pooling(const float* token_embeddings, const int64_t* attention_mask,
                        int seq_len, int hidden_dim, float* output) {
    std::fill(output, output + hidden_dim, 0.0f);
    int valid_tokens = 0;

    for (int i = 0; i < seq_len; i++) {
        if (attention_mask[i] > 0) {
            for (int j = 0; j < hidden_dim; j++) {
                output[j] += token_embeddings[i * hidden_dim + j];
            }
            valid_tokens++;
        }
    }

    if (valid_tokens > 0) {
        for (int j = 0; j < hidden_dim; j++) {
            output[j] /= valid_tokens;
        }
    }
}

extern "C" {

ONNXEnvHandle ONNXEnvCreate() {
    try {
        return new std::shared_ptr<ONNXEnv>(std::make_shared<ONNXEnv>());
    } catch (...) {
        return nullptr;
    }
}

void ONNXEnvRelease(ONNXEnvHandle onnxEnvHandle) {
    if (onnxEnvHandle) {
        delete static_cast<std::shared_ptr<ONNXEnv>*>(onnxEnvHandle);
    }
}

ONNXModelHandle ONNXLoadModel(ONNXEnvHandle onnxEnvHandle,
                               const char* modelPath,
                               const char* tokenizerPath,
                               int* dim) {
    if (!onnxEnvHandle || !modelPath || !dim) return nullptr;

    try {
        auto env_ptr = *static_cast<std::shared_ptr<ONNXEnv>*>(onnxEnvHandle);
        auto model = std::make_unique<ONNXModel>(env_ptr);

        model->session = std::make_unique<Ort::Session>(
            env_ptr->env, modelPath, env_ptr->session_options);

        Ort::AllocatorWithDefaultOptions allocator;
        size_t num_input_nodes = model->session->GetInputCount();
        for (size_t i = 0; i < num_input_nodes; i++) {
            auto input_name = model->session->GetInputNameAllocated(i, allocator);
            model->input_names.push_back(input_name.get());
        }

        size_t num_output_nodes = model->session->GetOutputCount();
        for (size_t i = 0; i < num_output_nodes; i++) {
            auto output_name = model->session->GetOutputNameAllocated(i, allocator);
            model->output_names.push_back(output_name.get());
        }

        auto type_info = model->session->GetOutputTypeInfo(0);
        auto tensor_info = type_info.GetTensorTypeAndShapeInfo();
        auto shape = tensor_info.GetShape();
        if (shape.size() >= 2) {
            model->embedding_dim = static_cast<int>(shape[shape.size() - 1]);
        }

        *dim = model->embedding_dim;

        model->tokenizer = std::make_unique<TokenizerWrapper>();
        if (tokenizerPath) {
            model->tokenizer->loadFromFile(tokenizerPath);
        } else {
            std::string model_path_str(modelPath);
            size_t last_slash = model_path_str.find_last_of("/\\");
            if (last_slash != std::string::npos) {
                std::string model_dir = model_path_str.substr(0, last_slash);
                std::string tokenizer_path = model_dir + "/tokenizer.json";

                std::ifstream tokenizer_file(tokenizer_path);
                if (tokenizer_file.good()) {
                    model->tokenizer->loadFromFile(tokenizer_path.c_str());
                }
            }
        }

        return model.release();

    } catch (...) {
        return nullptr;
    }
}

ONNXModelHandle ONNXLoadModelFromDir(ONNXEnvHandle onnxEnvHandle,
                                     const char* modelDir,
                                     const char* modelFile,
                                     int* dim) {
    if (!modelDir || !modelFile) return nullptr;

    std::string model_path = std::string(modelDir) + "/" + modelFile;
    std::string tokenizer_path = std::string(modelDir) + "/tokenizer.json";

    std::ifstream tokenizer_file(tokenizer_path);
    const char* tok_path = tokenizer_file.good() ? tokenizer_path.c_str() : nullptr;

    return ONNXLoadModel(onnxEnvHandle, model_path.c_str(), tok_path, dim);
}

void ONNXUnloadModel(ONNXModelHandle handle) {
    if (handle) {
        delete static_cast<ONNXModel*>(handle);
    }
}

int ONNXEmbeddingInfer(ONNXModelHandle handle,
                       const char* text,
                       float* embedding,
                       int dim) {
    if (!handle || !text || !embedding) return 0;

    try {
        auto model = static_cast<ONNXModel*>(handle);
        if (model->embedding_dim != dim) return 0;

        if (!model->tokenizer || !model->tokenizer->has_tokenizer) {
            fprintf(stderr, "Error: Tokenizer not loaded. Cannot perform embedding inference.\n");
            return 0;
        }

        std::vector<int64_t> input_ids = model->tokenizer->encode(text);
        if (input_ids.empty()) {
            fprintf(stderr, "Error: Tokenizer returned empty token IDs.\n");
            return 0;
        }

        int seq_len = static_cast<int>(input_ids.size());
        std::vector<int64_t> input_shape = {1, seq_len};
        std::vector<int64_t> attention_mask(seq_len, 1);
        std::vector<int64_t> token_type_ids(seq_len, 0);

        Ort::MemoryInfo memory_info = Ort::MemoryInfo::CreateCpu(
            OrtArenaAllocator, OrtMemTypeDefault);

        std::vector<Ort::Value> input_tensors;
        std::vector<const char*> input_names_cstr;

        for (const auto& name : model->input_names) {
            if (name == "input_ids") {
                input_tensors.push_back(Ort::Value::CreateTensor<int64_t>(
                    memory_info, input_ids.data(), input_ids.size(),
                    input_shape.data(), input_shape.size()));
                input_names_cstr.push_back(name.c_str());
            } else if (name == "attention_mask") {
                input_tensors.push_back(Ort::Value::CreateTensor<int64_t>(
                    memory_info, attention_mask.data(), attention_mask.size(),
                    input_shape.data(), input_shape.size()));
                input_names_cstr.push_back(name.c_str());
            } else if (name == "token_type_ids") {
                input_tensors.push_back(Ort::Value::CreateTensor<int64_t>(
                    memory_info, token_type_ids.data(), token_type_ids.size(),
                    input_shape.data(), input_shape.size()));
                input_names_cstr.push_back(name.c_str());
            }
        }

        std::vector<const char*> output_names_cstr;
        for (const auto& name : model->output_names) {
            output_names_cstr.push_back(name.c_str());
        }

        auto output_tensors = model->session->Run(
            Ort::RunOptions{nullptr},
            input_names_cstr.data(), input_tensors.data(), input_tensors.size(),
            output_names_cstr.data(), output_names_cstr.size());

        if (output_tensors.empty()) return 0;

        auto& output_tensor = output_tensors[0];
        auto type_info = output_tensor.GetTensorTypeAndShapeInfo();
        auto shape = type_info.GetShape();
        const float* output_data = output_tensor.GetTensorData<float>();

        // Mean pooling
        if (shape.size() == 3) {
            // [batch, seq_len, hidden_dim]
            int hidden_dim = static_cast<int>(shape[2]);
            mean_pooling(output_data, attention_mask.data(), seq_len, hidden_dim, embedding);
        } else if (shape.size() == 2) {
            std::memcpy(embedding, output_data, dim * sizeof(float));
        }

        normalize_vector(embedding, dim);

        return 1;

    } catch (...) {
        return 0;
    }
}

int ONNXEmbeddingInferBatch(ONNXModelHandle handle,
                            char** texts,
                            int numTexts,
                            float** embeddings,
                            int dim) {
    if (!handle || !texts || !embeddings || numTexts <= 0) return 1;

    for (int i = 0; i < numTexts; i++) {
        if (!ONNXEmbeddingInfer(handle, texts[i], embeddings[i], dim)) {
            return 1;
        }
    }

    return 0;
}

int ONNXGetEmbeddingDim(ONNXModelHandle handle) {
    if (!handle) return -1;
    auto model = static_cast<ONNXModel*>(handle);
    return model->embedding_dim;
}

} // extern "C"
EOF

echo "[onnxruntime] onnx_wrapper project created"

# ============================================
# Build onnx_wrapper
# ============================================
echo "[onnxruntime] Building onnx_wrapper..."

if ! command -v cmake &> /dev/null; then
    echo "Error: CMake not found. Please install CMake first."
    exit 1
fi

cd ${FFI_DIR}
mkdir -p build
cd build

cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=${BUILD_DIR} \
    -DCMAKE_C_FLAGS="-fstack-protector-strong -D_FORTIFY_SOURCE=2 -O2" \
    -DCMAKE_CXX_FLAGS="-fstack-protector-strong -D_FORTIFY_SOURCE=2 -O2" \
    -DCMAKE_SHARED_LINKER_FLAGS="-Wl,-z,relro,-z,now,-z,noexecstack"

if [ $? -ne 0 ]; then
    echo "Error: CMake configuration failed"
    exit 1
fi

make -j$(nproc)

if [ $? -ne 0 ]; then
    echo "Error: Compilation failed"
    exit 1
fi

make install

if [ $? -ne 0 ]; then
    echo "Error: Installation failed"
    exit 1
fi

cd ../..

strip ${BUILD_DIR}/lib/libonnx_wrapper.so* 2>/dev/null || true

echo "[onnxruntime] onnx_wrapper built successfully"

if [ "$FULL_OUTPUT" != "1" ]; then
    echo "[onnxruntime] Creating minimal runtime output..."

    rm -rf ${BUILD_DIR}/lib/cmake
    rm -rf ${BUILD_DIR}/lib/pkgconfig

    cd ${BUILD_DIR}/include
    KEEP_HEADERS="onnx_wrapper.h"
    for file in *; do
        if [ -f "$file" ] && ! echo "$KEEP_HEADERS" | grep -q "$file"; then
            rm -f "$file"
        fi
    done
    rm -rf core
    cd ../..

    echo "[onnxruntime] Minimal output created (runtime only, saved ~600KB)"
    echo "  Kept: onnx_wrapper.h (application interface)"
    echo "  Removed: development headers, cmake, pkgconfig"
    echo "  Tip: Use FULL_OUTPUT=1 to keep all files for development"
else
    echo "[onnxruntime] Full output mode (keeping all files)"
fi

cp -r install_comm install_llt

mkdir -p ${OUTPUT_DIR}/comm
mkdir -p ${OUTPUT_DIR}/llt

cp -r install_comm/* ${OUTPUT_DIR}/comm/
cp -r install_llt/* ${OUTPUT_DIR}/llt/

echo "[onnxruntime] Build completed successfully!"
echo "Output: ${OUTPUT_DIR}"
echo ""
echo "Libraries:"
echo "  - libonnxruntime.so.${VERSION}"
echo "  - libonnx_wrapper.so (embedding support)"
echo ""
echo "Headers:"
echo "  - onnxruntime_c_api.h"
echo "  - onnxruntime_cxx_api.h"
echo "  - onnx_wrapper.h (embedding interface)"
echo ""
echo "Features:"
echo "  - Text embedding inference"
echo "  - Batch processing"
echo "  - Tokenizer integration (if available)"
echo "  - Mean pooling & normalization"
echo ""
echo "To use ONNX Wrapper, set environment variable:"
echo "  export ONNXRUNTIME_ROOT=${OUTPUT_DIR}/comm"
echo ""
echo "Or for runtime:"
echo "  export LD_LIBRARY_PATH=${OUTPUT_DIR}/comm/lib:\$LD_LIBRARY_PATH"