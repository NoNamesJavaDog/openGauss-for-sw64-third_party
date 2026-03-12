/***************************************************************************
 *                                  _   _ ____  _
 *  Project                     ___| | | |  _ \| |
 *                             / __| | | | |_) | |
 *                            | (__| |_| |  _ <| |___
 *                             \___|\___/|_| \_\_____|
 *
 * Copyright (C) 1998 - 2023, Daniel Stenberg, <daniel@haxx.se>, et al.
 *
 * This software is licensed as described in the file COPYING, which
 * you should have received as part of this distribution. The terms
 * are also available at https://curl.se/docs/copyright.html.
 *
 * You may opt to use, copy, modify, merge, publish, distribute and/or sell
 * copies of the Software, and permit persons to whom the Software is
 * furnished to do so, under the terms of the COPYING file.
 *
 * This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
 * KIND, either express or implied.
 *
 ***************************************************************************/

#include "curl_setup.h"

#include "urldata.h"
#include <curl/curl.h>
#include <stddef.h>

#ifdef HAVE_ZLIB_H
#include <zlib.h>
#endif

#ifdef HAVE_BROTLI
#include <brotli/decode.h>
#endif

#ifdef HAVE_ZSTD
#include <zstd.h>
#endif

#include "sendf.h"
#include "http.h"
#include "content_encoding.h"
#include "strdup.h"
#include "strcase.h"
#include "curl_memory.h"
#include "memdebug.h"

#define CONTENT_ENCODING_DEFAULT  "identity"

#ifndef CURL_DISABLE_HTTP

#define DSIZ CURL_MAX_WRITE_SIZE /* buffer size for decompressed data */

#ifdef HAVE_LIBZ

typedef enum {
  ZLIB_UNINIT,               /* uninitialized */
  ZLIB_INIT,                 /* initialized */
  ZLIB_INFLATING,            /* inflating started. */
  ZLIB_EXTERNAL_TRAILER,     /* reading external trailer */
  ZLIB_INIT_GZIP             /* initialized in transparent gzip mode */
} zlibInitState;

/* Writer parameters. */
struct zlib_params {
  zlibInitState zlib_init;   /* zlib init state */
  uInt trailerlen;           /* Remaining trailer byte count. */
  z_stream z;                /* State structure for zlib. */
};


static voidpf
zalloc_cb(voidpf opaque, unsigned int items, unsigned int size)
{
  (void) opaque;
  /* not a typo, keep it calloc() */
  return (voidpf) calloc(items, size);
}

static void
zfree_cb(voidpf opaque, voidpf ptr)
{
  (void) opaque;
  free(ptr);
}

static CURLcode
process_zlib_error(struct Curl_easy *data, z_stream *z)
{
  if(z->msg)
    failf(data, "Error while processing content unencoding: %s",
          z->msg);
  else
    failf(data, "Error while processing content unencoding: "
          "Unknown failure within decompression software.");

  return CURLE_BAD_CONTENT_ENCODING;
}

static CURLcode
exit_zlib(struct Curl_easy *data,
          z_stream *z, zlibInitState *zlib_init, CURLcode result)
{
  if(*zlib_init != ZLIB_UNINIT) {
    if(inflateEnd(z) != Z_OK && result == CURLE_OK)
      result = process_zlib_error(data, z);
    *zlib_init = ZLIB_UNINIT;
  }

  return result;
}

static CURLcode process_trailer(struct Curl_easy *data,
                                struct zlib_params *zp)
{
  z_stream *z = &zp->z;
  CURLcode result = CURLE_OK;
  uInt len = z->avail_in < zp->trailerlen? z->avail_in: zp->trailerlen;

  /* Consume expected trailer bytes. Terminate stream if exhausted.
     Issue an error if unexpected bytes follow. */

  zp->trailerlen -= len;
  z->avail_in -= len;
  z->next_in += len;
  if(z->avail_in)
    result = CURLE_WRITE_ERROR;
  if(result || !zp->trailerlen)
    result = exit_zlib(data, z, &zp->zlib_init, result);
  else {
    /* Only occurs for gzip with zlib < 1.2.0.4 or raw deflate. */
    zp->zlib_init = ZLIB_EXTERNAL_TRAILER;
  }
  return result;
}

static CURLcode inflate_stream(struct Curl_easy *data,
                               struct contenc_writer *writer,
                               zlibInitState started)
{
  struct zlib_params *zp = (struct zlib_params *) &writer->params;
  z_stream *z = &zp->z;         /* zlib state structure */
  uInt nread = z->avail_in;
  Bytef *orig_in = z->next_in;
  bool done = FALSE;
  CURLcode result = CURLE_OK;   /* Curl_client_write status */
  char *decomp;                 /* Put the decompressed data here. */

  /* Check state. */
  if(zp->zlib_init != ZLIB_INIT &&
     zp->zlib_init != ZLIB_INFLATING &&
     zp->zlib_init != ZLIB_INIT_GZIP)
    return exit_zlib(data, z, &zp->zlib_init, CURLE_WRITE_ERROR);

  /* Dynamically allocate a buffer for decompression because it's uncommonly
     large to hold on the stack */
  decomp = malloc(DSIZ);
  if(!decomp)
    return exit_zlib(data, z, &zp->zlib_init, CURLE_OUT_OF_MEMORY);

  /* because the buffer size is fixed, iteratively decompress and transfer to
     the client via downstream_write function. */
  while(!done) {
    int status;                   /* zlib status */
    done = TRUE;

    /* (re)set buffer for decompressed output for every iteration */
    z->next_out = (Bytef *) decomp;
    z->avail_out = DSIZ;

#ifdef Z_BLOCK
    /* Z_BLOCK is only available in zlib ver. >= 1.2.0.5 */
    status = inflate(z, Z_BLOCK);
#else
    /* fallback for zlib ver. < 1.2.0.5 */
    status = inflate(z, Z_SYNC_FLUSH);
#endif

    /* Flush output data if some. */
    if(z->avail_out != DSIZ) {
      if(status == Z_OK || status == Z_STREAM_END) {
        zp->zlib_init = started;      /* Data started. */
        result = Curl_unencode_write(data, writer->downstream, decomp,
                                     DSIZ - z->avail_out);
        if(result) {
          exit_zlib(data, z, &zp->zlib_init, result);
          break;
        }
      }
    }

    /* Dispatch by inflate() status. */
    switch(status) {
    case Z_OK:
      /* Always loop: there may be unflushed latched data in zlib state. */
      done = FALSE;
      break;
    case Z_BUF_ERROR:
      /* No more data to flush: just exit loop. */
      break;
    case Z_STREAM_END:
      result = process_trailer(data, zp);
      break;
    case Z_DATA_ERROR:
      /* some servers seem to not generate zlib headers, so this is an attempt
         to fix and continue anyway */
      if(zp->zlib_init == ZLIB_INIT) {
        /* Do not use inflateReset2(): only available since zlib 1.2.3.4. */
        (void) inflateEnd(z);     /* don't care about the return code */
        if(inflateInit2(z, -MAX_WBITS) == Z_OK) {
          z->next_in = orig_in;
          z->avail_in = nread;
          zp->zlib_init = ZLIB_INFLATING;
          zp->trailerlen = 4; /* Tolerate up to 4 unknown trailer bytes. */
          done = FALSE;
          break;
        }
        zp->zlib_init = ZLIB_UNINIT;    /* inflateEnd() already called. */
      }
      /* FALLTHROUGH */
    default:
      result = exit_zlib(data, z, &zp->zlib_init, process_zlib_error(data, z));
      break;
    }
  }
  free(decomp);

  /* We're about to leave this call so the `nread' data bytes won't be seen
     again. If we are in a state that would wrongly allow restart in raw mode
     at the next call, assume output has already started. */
  if(nread && zp->zlib_init == ZLIB_INIT)
    zp->zlib_init = started;      /* Cannot restart anymore. */

  return result;
}


/* Deflate handler. */
static CURLcode deflate_init_writer(struct Curl_easy *data,
                                    struct contenc_writer *writer)
{
  struct zlib_params *zp = (struct zlib_params *) &writer->params;
  z_stream *z = &zp->z;     /* zlib state structure */

  if(!writer->downstream)
    return CURLE_WRITE_ERROR;

  /* Initialize zlib */
  z->zalloc = (alloc_func) zalloc_cb;
  z->zfree = (free_func) zfree_cb;

  if(inflateInit(z) != Z_OK)
    return process_zlib_error(data, z);
  zp->zlib_init = ZLIB_INIT;
  return CURLE_OK;
}

static CURLcode deflate_unencode_write(struct Curl_easy *data,
                                       struct contenc_writer *writer,
                                       const char *buf, size_t nbytes)
{
  struct zlib_params *zp = (struct zlib_params *) &writer->params;
  z_stream *z = &zp->z;     /* zlib state structure */

  /* Set the compressed input when this function is called */
  z->next_in = (Bytef *) buf;
  z->avail_in = (uInt) nbytes;

  if(zp->zlib_init == ZLIB_EXTERNAL_TRAILER)
    return process_trailer(data, zp);

  /* Now uncompress the data */
  return inflate_stream(data, writer, ZLIB_INFLATING);
}

static void deflate_close_writer(struct Curl_easy *data,
                                 struct contenc_writer *writer)
{
  struct zlib_params *zp = (struct zlib_params *) &writer->params;
  z_stream *z = &zp->z;     /* zlib state structure */

  exit_zlib(data, z, &zp->zlib_init, CURLE_OK);
}

static const struct content_encoding deflate_encoding = {
  "deflate",
  NULL,
  deflate_init_writer,
  deflate_unencode_write,
  deflate_close_writer,
  sizeof(struct zlib_params)
};


/* Gzip handler. */
static CURLcode gzip_init_writer(struct Curl_easy *data,
                                 struct contenc_writer *writer)
{
  struct zlib_params *zp = (struct zlib_params *) &writer->params;
  z_stream *z = &zp->z;     /* zlib state structure */
  const char *v = zlibVersion();

  if(!writer->downstream)
    return CURLE_WRITE_ERROR;

  /* Initialize zlib */
  z->zalloc = (alloc_func) zalloc_cb;
  z->zfree = (free_func) zfree_cb;

  if(strcmp(v, "1.2.0.4") >= 0) {
    /* zlib version >= 1.2.0.4 supports transparent gzip decompressing */
    if(inflateInit2(z, MAX_WBITS + 32) != Z_OK) {
      return process_zlib_error(data, z);
    }
    zp->zlib_init = ZLIB_INIT_GZIP; /* Transparent gzip decompress state */
  }
  else {
    failf(data, "too old zlib version: %s", v);
    return CURLE_FAILED_INIT;
  }

  return CURLE_OK;
}

static CURLcode gzip_unencode_write(struct Curl_easy *data,
                                    struct contenc_writer *writer,
                                    const char *buf, size_t nbytes)
{
  struct zlib_params *zp = (struct zlib_params *) &writer->params;
  z_stream *z = &zp->z;     /* zlib state structure */

  if(zp->zlib_init == ZLIB_INIT_GZIP) {
    /* Let zlib handle the gzip decompression entirely */
    z->next_in = (Bytef *) buf;
    z->avail_in = (uInt) nbytes;
    /* Now uncompress the data */
    return inflate_stream(data, writer, ZLIB_INIT_GZIP);
  }

  /* We are running with an old version: return error. */
  return exit_zlib(data, z, &zp->zlib_init, CURLE_WRITE_ERROR);
}

static void gzip_close_writer(struct Curl_easy *data,
                              struct contenc_writer *writer)
{
  struct zlib_params *zp = (struct zlib_params *) &writer->params;
  z_stream *z = &zp->z;     /* zlib state structure */

  exit_zlib(data, z, &zp->zlib_init, CURLE_OK);
}

static const struct content_encoding gzip_encoding = {
  "gzip",
  "x-gzip",
  gzip_init_writer,
  gzip_unencode_write,
  gzip_close_writer,
  sizeof(struct zlib_params)
};

#endif /* HAVE_LIBZ */


#ifdef HAVE_BROTLI
/* Writer parameters. */
struct brotli_params {
  BrotliDecoderState *br;    /* State structure for brotli. */
};

static CURLcode brotli_map_error(BrotliDecoderErrorCode be)
{
  switch(be) {
  case BROTLI_DECODER_ERROR_FORMAT_EXUBERANT_NIBBLE:
  case BROTLI_DECODER_ERROR_FORMAT_EXUBERANT_META_NIBBLE:
  case BROTLI_DECODER_ERROR_FORMAT_SIMPLE_HUFFMAN_ALPHABET:
  case BROTLI_DECODER_ERROR_FORMAT_SIMPLE_HUFFMAN_SAME:
  case BROTLI_DECODER_ERROR_FORMAT_CL_SPACE:
  case BROTLI_DECODER_ERROR_FORMAT_HUFFMAN_SPACE:
  case BROTLI_DECODER_ERROR_FORMAT_CONTEXT_MAP_REPEAT:
  case BROTLI_DECODER_ERROR_FORMAT_BLOCK_LENGTH_1:
  case BROTLI_DECODER_ERROR_FORMAT_BLOCK_LENGTH_2:
  case BROTLI_DECODER_ERROR_FORMAT_TRANSFORM:
  case BROTLI_DECODER_ERROR_FORMAT_DICTIONARY:
  case BROTLI_DECODER_ERROR_FORMAT_WINDOW_BITS:
  case BROTLI_DECODER_ERROR_FORMAT_PADDING_1:
  case BROTLI_DECODER_ERROR_FORMAT_PADDING_2:
#ifdef BROTLI_DECODER_ERROR_COMPOUND_DICTIONARY
  case BROTLI_DECODER_ERROR_COMPOUND_DICTIONARY:
#endif
#ifdef BROTLI_DECODER_ERROR_DICTIONARY_NOT_SET
  case BROTLI_DECODER_ERROR_DICTIONARY_NOT_SET:
#endif
  case BROTLI_DECODER_ERROR_INVALID_ARGUMENTS:
    return CURLE_BAD_CONTENT_ENCODING;
  case BROTLI_DECODER_ERROR_ALLOC_CONTEXT_MODES:
  case BROTLI_DECODER_ERROR_ALLOC_TREE_GROUPS:
  case BROTLI_DECODER_ERROR_ALLOC_CONTEXT_MAP:
  case BROTLI_DECODER_ERROR_ALLOC_RING_BUFFER_1:
  case BROTLI_DECODER_ERROR_ALLOC_RING_BUFFER_2:
  case BROTLI_DECODER_ERROR_ALLOC_BLOCK_TYPE_TREES:
    return CURLE_OUT_OF_MEMORY;
  default:
    break;
  }
  return CURLE_WRITE_ERROR;
}

static CURLcode brotli_init_writer(struct Curl_easy *data,
                                   struct contenc_writer *writer)
{
  struct brotli_params *bp = (struct brotli_params *) &writer->params;
  (void) data;

  if(!writer->downstream)
    return CURLE_WRITE_ERROR;

  bp->br = BrotliDecoderCreateInstance(NULL, NULL, NULL);
  return bp->br? CURLE_OK: CURLE_OUT_OF_MEMORY;
}

static CURLcode brotli_unencode_write(struct Curl_easy *data,
                                      struct contenc_writer *writer,
                                      const char *buf, size_t nbytes)
{
  struct brotli_params *bp = (struct brotli_params *) &writer->params;
  const uint8_t *src = (const uint8_t *) buf;
  char *decomp;
  uint8_t *dst;
  size_t dstleft;
  CURLcode result = CURLE_OK;
  BrotliDecoderResult r = BROTLI_DECODER_RESULT_NEEDS_MORE_OUTPUT;

  if(!bp->br)
    return CURLE_WRITE_ERROR;  /* Stream already ended. */

  decomp = malloc(DSIZ);
  if(!decomp)
    return CURLE_OUT_OF_MEMORY;

  while((nbytes || r == BROTLI_DECODER_RESULT_NEEDS_MORE_OUTPUT) &&
        result == CURLE_OK) {
    dst = (uint8_t *) decomp;
    dstleft = DSIZ;
    r = BrotliDecoderDecompressStream(bp->br,
                                      &nbytes, &src, &dstleft, &dst, NULL);
    result = Curl_unencode_write(data, writer->downstream,
                                 decomp, DSIZ - dstleft);
    if(result)
      break;
    switch(r) {
    case BROTLI_DECODER_RESULT_NEEDS_MORE_OUTPUT:
    case BROTLI_DECODER_RESULT_NEEDS_MORE_INPUT:
      break;
    case BROTLI_DECODER_RESULT_SUCCESS:
      BrotliDecoderDestroyInstance(bp->br);
      bp->br = NULL;
      if(nbytes)
        result = CURLE_WRITE_ERROR;
      break;
    default:
      result = brotli_map_error(BrotliDecoderGetErrorCode(bp->br));
      break;
    }
  }
  free(decomp);
  return result;
}

static void brotli_close_writer(struct Curl_easy *data,
                                struct contenc_writer *writer)
{
  struct brotli_params *bp = (struct brotli_params *) &writer->params;
  (void) data;

  if(bp->br) {
    BrotliDecoderDestroyInstance(bp->br);
    bp->br = NULL;
  }
}

static const struct content_encoding brotli_encoding = {
  "br",
  NULL,
  brotli_init_writer,
  brotli_unencode_write,
  brotli_close_writer,
  sizeof(struct brotli_params)
};
#endif


#ifdef HAVE_ZSTD
/* Writer parameters. */
struct zstd_params {
  ZSTD_DStream *zds;    /* State structure for zstd. */
  void *decomp;
};

static CURLcode zstd_init_writer(struct Curl_easy *data,
                                 struct contenc_writer *writer)
{
  struct zstd_params *zp = (struct zstd_params *)&writer->params;
  (void)data;

  if(!writer->downstream)
    return CURLE_WRITE_ERROR;

  zp->zds = ZSTD_createDStream();
  zp->decomp = NULL;
  return zp->zds ? CURLE_OK : CURLE_OUT_OF_MEMORY;
}

static CURLcode zstd_unencode_write(struct Curl_easy *data,
                                    struct contenc_writer *writer,
                                    const char *buf, size_t nbytes)
{
  CURLcode result = CURLE_OK;
  struct zstd_params *zp = (struct zstd_params *)&writer->params;
  ZSTD_inBuffer in;
  ZSTD_outBuffer out;
  size_t errorCode;

  if(!zp->decomp) {
    zp->decomp = malloc(DSIZ);
    if(!zp->decomp)
      return CURLE_OUT_OF_MEMORY;
  }
  in.pos = 0;
  in.src = buf;
  in.size = nbytes;

  for(;;) {
    out.pos = 0;
    out.dst = zp->decomp;
    out.size = DSIZ;

    errorCode = ZSTD_decompressStream(zp->zds, &out, &in);
    if(ZSTD_isError(errorCode)) {
      return CURLE_BAD_CONTENT_ENCODING;
    }
    if(out.pos > 0) {
      result = Curl_unencode_write(data, writer->downstream,
                                   zp->decomp, out.pos);
      if(result)
        break;
    }
    if((in.pos == nbytes) && (out.pos < out.size))
      break;
  }

  return result;
}

static void zstd_close_writer(struct Curl_easy *data,
                              struct contenc_writer *writer)
{
  struct zstd_params *zp = (struct zstd_params *)&writer->params;
  (void)data;

  if(zp->decomp) {
    free(zp->decomp);
    zp->decomp = NULL;
  }
  if(zp->zds) {
    ZSTD_freeDStream(zp->zds);
    zp->zds = NULL;
  }
}

static const struct content_encoding zstd_encoding = {
  "zstd",
  NULL,
  zstd_init_writer,
  zstd_unencode_write,
  zstd_close_writer,
  sizeof(struct zstd_params)
};
#endif


/* Identity handler. */
static CURLcode identity_init_writer(struct Curl_easy *data,
                                     struct contenc_writer *writer)
{
  (void) data;
  return writer->downstream? CURLE_OK: CURLE_WRITE_ERROR;
}

static CURLcode identity_unencode_write(struct Curl_easy *data,
                                        struct contenc_writer *writer,
                                        const char *buf, size_t nbytes)
{
  return Curl_unencode_write(data, writer->downstream, buf, nbytes);
}

static void identity_close_writer(struct Curl_easy *data,
                                  struct contenc_writer *writer)
{
  (void) data;
  (void) writer;
}

static const struct content_encoding identity_encoding = {
  "identity",
  "none",
  identity_init_writer,
  identity_unencode_write,
  identity_close_writer,
  0
};


/* supported content encodings table. */
static const struct content_encoding * const encodings[] = {
  &identity_encoding,
#ifdef HAVE_LIBZ
  &deflate_encoding,
  &gzip_encoding,
#endif
#ifdef HAVE_BROTLI
  &brotli_encoding,
#endif
#ifdef HAVE_ZSTD
  &zstd_encoding,
#endif
  NULL
};


/* Return a list of comma-separated names of supported encodings. */
char *Curl_all_content_encodings(void)
{
  size_t len = 0;
  const struct content_encoding * const *cep;
  const struct content_encoding *ce;
  char *ace;

  for(cep = encodings; *cep; cep++) {
    ce = *cep;
    if(!strcasecompare(ce->name, CONTENT_ENCODING_DEFAULT))
      len += strlen(ce->name) + 2;
  }

  if(!len)
    return strdup(CONTENT_ENCODING_DEFAULT);

  ace = malloc(len);
  if(ace) {
    char *p = ace;
    for(cep = encodings; *cep; cep++) {
      ce = *cep;
      if(!strcasecompare(ce->name, CONTENT_ENCODING_DEFAULT)) {
        strcpy(p, ce->name);
        p += strlen(p);
        *p++ = ',';
        *p++ = ' ';
      }
    }
    p[-2] = '\0';
  }

  return ace;
}


/* Real client writer: no downstream. */
static CURLcode client_init_writer(struct Curl_easy *data,
                                   struct contenc_writer *writer)
{
  (void) data;
  return writer->downstream? CURLE_WRITE_ERROR: CURLE_OK;
}

static CURLcode client_unencode_write(struct Curl_easy *data,
                                      struct contenc_writer *writer,
                                      const char *buf, size_t nbytes)
{
  struct SingleRequest *k = &data->req;

  (void) writer;

  if(!nbytes || k->ignorebody)
    return CURLE_OK;

  return Curl_client_write(data, CLIENTWRITE_BODY, (char *) buf, nbytes);
}

static void client_close_writer(struct Curl_easy *data,
                                struct contenc_writer *writer)
{
  (void) data;
  (void) writer;
}

static const struct content_encoding client_encoding = {
  NULL,
  NULL,
  client_init_writer,
  client_unencode_write,
  client_close_writer,
  0
};


/* Deferred error dummy writer. */
static CURLcode error_init_writer(struct Curl_easy *data,
                                  struct contenc_writer *writer)
{
  (void) data;
  return writer->downstream? CURLE_OK: CURLE_WRITE_ERROR;
}

static CURLcode error_unencode_write(struct Curl_easy *data,
                                     struct contenc_writer *writer,
                                     const char *buf, size_t nbytes)
{
  char *all = Curl_all_content_encodings();

  (void) writer;
  (void) buf;
  (void) nbytes;

  if(!all)
    return CURLE_OUT_OF_MEMORY;
  failf(data, "Unrecognized content encoding type. "
        "libcurl understands %s content encodings.", all);
  free(all);
  return CURLE_BAD_CONTENT_ENCODING;
}

static void error_close_writer(struct Curl_easy *data,
                               struct contenc_writer *writer)
{
  (void) data;
  (void) writer;
}

static const struct content_encoding error_encoding = {
  NULL,
  NULL,
  error_init_writer,
  error_unencode_write,
  error_close_writer,
  0
};

/* Create an unencoding writer stage using the given handler. */
static struct contenc_writer *
new_unencoding_writer(struct Curl_easy *data,
                      const struct content_encoding *handler,
                      struct contenc_writer *downstream,
                      int order)
{
  size_t sz = offsetof(struct contenc_writer, params) + handler->paramsize;
  struct contenc_writer *writer = (struct contenc_writer *)calloc(1, sz);

  if(writer) {
    writer->handler = handler;
    writer->downstream = downstream;
    writer->order = order;
    if(handler->init_writer(data, writer)) {
      free(writer);
      writer = NULL;
    }
  }

  return writer;
}

/* Write data using an unencoding writer stack. "nbytes" is not
   allowed to be 0. */
CURLcode Curl_unencode_write(struct Curl_easy *data,
                             struct contenc_writer *writer,
                             const char *buf, size_t nbytes)
{
  if(!nbytes)
    return CURLE_OK;
  return writer->handler->unencode_write(data, writer, buf, nbytes);
}

/* Close and clean-up the connection's writer stack. */
void Curl_unencode_cleanup(struct Curl_easy *data)
{
  struct SingleRequest *k = &data->req;
  struct contenc_writer *writer = k->writer_stack;

  while(writer) {
    k->writer_stack = writer->downstream;
    writer->handler->close_writer(data, writer);
    free(writer);
    writer = k->writer_stack;
  }
}

/* Find the content encoding by name. */
static const struct content_encoding *find_encoding(const char *name,
                                                    size_t len)
{
  const struct content_encoding * const *cep;

  for(cep = encodings; *cep; cep++) {
    const struct content_encoding *ce = *cep;
    if((strncasecompare(name, ce->name, len) && !ce->name[len]) ||
       (ce->alias && strncasecompare(name, ce->alias, len) && !ce->alias[len]))
      return ce;
  }
  return NULL;
}

/* allow no more than 5 "chained" compression steps */
#define MAX_ENCODE_STACK 5

/* Set-up the unencoding stack from the Content-Encoding header value.
 * See RFC 7231 section 3.1.2.2. */
CURLcode Curl_build_unencoding_stack(struct Curl_easy *data,
                                     const char *enclist, int is_transfer)
{
  struct SingleRequest *k = &data->req;
  unsigned int order = is_transfer? 2: 1;

  do {
    const char *name;
    size_t namelen;

    /* Parse a single encoding name. */
    while(ISSPACE(*enclist) || *enclist == ',')
      enclist++;

    name = enclist;

    for(namelen = 0; *enclist && *enclist != ','; enclist++)
      if(!ISSPACE(*enclist))
        namelen = enclist - name + 1;

    /* Special case: chunked encoding is handled at the reader level. */
    if(is_transfer && namelen == 7 && strncasecompare(name, "chunked", 7)) {
      k->chunk = TRUE;             /* chunks coming our way. */
      Curl_httpchunk_init(data);   /* init our chunky engine. */
    }
    else if(namelen) {
      const struct content_encoding *encoding = find_encoding(name, namelen);
      struct contenc_writer *writer;

      if(!k->writer_stack) {
        k->writer_stack = new_unencoding_writer(data, &client_encoding,
                                                NULL, 0);

        if(!k->writer_stack)
          return CURLE_OUT_OF_MEMORY;
      }

      if(!encoding)
        encoding = &error_encoding;  /* Defer error at stack use. */

      if(k->writer_stack_depth++ >= MAX_ENCODE_STACK) {
        failf(data, "Reject response due to more than %u content encodings",
              MAX_ENCODE_STACK);
        return CURLE_BAD_CONTENT_ENCODING;
      }
      /* Stack the unencoding stage. */
      if(order >= k->writer_stack->order) {
        writer = new_unencoding_writer(data, encoding,
                                       k->writer_stack, order);
        if(!writer)
          return CURLE_OUT_OF_MEMORY;
        k->writer_stack = writer;
      }
      else {
        struct contenc_writer *w = k->writer_stack;
        while(w->downstream && order < w->downstream->order)
          w = w->downstream;
        writer = new_unencoding_writer(data, encoding,
                                       w->downstream, order);
        if(!writer)
          return CURLE_OUT_OF_MEMORY;
        w->downstream = writer;
      }
    }
  } while(*enclist);

  return CURLE_OK;
}

#else
/* Stubs for builds without HTTP. */
CURLcode Curl_build_unencoding_stack(struct Curl_easy *data,
                                     const char *enclist, int is_transfer)
{
  (void) data;
  (void) enclist;
  (void) is_transfer;
  return CURLE_NOT_BUILT_IN;
}

CURLcode Curl_unencode_write(struct Curl_easy *data,
                             struct contenc_writer *writer,
                             const char *buf, size_t nbytes)
{
  (void) data;
  (void) writer;
  (void) buf;
  (void) nbytes;
  return CURLE_NOT_BUILT_IN;
}

void Curl_unencode_cleanup(struct Curl_easy *data)
{
  (void) data;
}

char *Curl_all_content_encodings(void)
{
  return strdup(CONTENT_ENCODING_DEFAULT);  /* Satisfy caller. */
}

#endif /* CURL_DISABLE_HTTP */
