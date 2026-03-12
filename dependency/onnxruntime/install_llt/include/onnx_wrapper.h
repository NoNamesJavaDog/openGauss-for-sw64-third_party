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
