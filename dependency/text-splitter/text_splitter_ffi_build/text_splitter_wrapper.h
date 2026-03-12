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
