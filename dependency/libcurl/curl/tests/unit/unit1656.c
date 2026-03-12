/***************************************************************************
 *                                  _   _ ____  _
 *  Project                     ___| | | |  _ \| |
 *                             / __| | | | |_) | |
 *                            | (__| |_| |  _ <| |___
 *                             \___|\___/|_| \_\_____|
 *
 * Copyright (C) Daniel Stenberg, <daniel@haxx.se>, et al.
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
 * SPDX-License-Identifier: curl
 *
 ***************************************************************************/
#include "curlcheck.h"

#include "x509asn1.h"

static CURLcode unit_setup(void)
{
  return CURLE_OK;
}

static void unit_stop(void)
{

}

#if defined(USE_GSKIT) || defined(USE_NSS) || defined(USE_GNUTLS) || \
    defined(USE_WOLFSSL) || defined(USE_SCHANNEL) || defined(USE_SECTRANSP) || \
    defined(USE_MBEDTLS)

#ifndef ARRAYSIZE
#define ARRAYSIZE(A) (sizeof(A)/sizeof((A)[0]))
#endif

struct test_spec {
  const char *input;
  const char *exp_output;
  int exp_success;  /* 1 for success, 0 for failure (NULL) */
};

static struct test_spec test_specs[] = {
  { "190321134340", "1903-21-13 43:40:00", 1 },
  { "", NULL, 0 },
  { "WTF", NULL, 0 },
  { "0WTF", NULL, 0 },
  { "19032113434", NULL, 0 },
  { "19032113434WTF", NULL, 0 },
  { "190321134340.", NULL, 0 },
  { "190321134340.1", "1903-21-13 43:40:00.1", 1 },
  { "19032113434017.0", "1903-21-13 43:40:17", 1 },
  { "19032113434017.01", "1903-21-13 43:40:17.01", 1 },
  { "19032113434003.001", "1903-21-13 43:40:03.001", 1 },
  { "19032113434003.090", "1903-21-13 43:40:03.09", 1 },
  { "190321134340Z", "1903-21-13 43:40:00 GMT", 1 },
  { "19032113434017.0Z", "1903-21-13 43:40:17 GMT", 1 },
  { "19032113434017.01Z", "1903-21-13 43:40:17.01 GMT", 1 },
  { "19032113434003.001Z", "1903-21-13 43:40:03.001 GMT", 1 },
  { "19032113434003.090Z", "1903-21-13 43:40:03.09 GMT", 1 },
  { "190321134340CET", "1903-21-13 43:40:00 CET", 1 },
  { "19032113434017.0CET", "1903-21-13 43:40:17 CET", 1 },
  { "19032113434017.01CET", "1903-21-13 43:40:17.01 CET", 1 },
  { "190321134340+02:30", "1903-21-13 43:40:00 UTC+02:30", 1 },
  { "19032113434017.0+02:30", "1903-21-13 43:40:17 UTC+02:30", 1 },
  { "19032113434017.01+02:30", "1903-21-13 43:40:17.01 UTC+02:30", 1 },
  { "190321134340-3", "1903-21-13 43:40:00 UTC-3", 1 },
  { "19032113434017.0-04", "1903-21-13 43:40:17 UTC-04", 1 },
  { "19032113434017.01-01:10", "1903-21-13 43:40:17.01 UTC-01:10", 1 },
};

static bool do_test(struct test_spec *spec, size_t i)
{
  const char *result;
  const char *in = spec->input;

  result = Curl_x509_GTime2str(in, in + strlen(in));
  if(spec->exp_success) {
    /* Expected success */
    if(!result) {
      fprintf(stderr, "test %zu: expected success but got NULL\n", i);
      return FALSE;
    }
    if(strcmp(spec->exp_output, result)) {
      fprintf(stderr, "test %zu: input '%s', expected output '%s', got '%s'\n",
              i, in, spec->exp_output, result);
      free((void *)result);
      return FALSE;
    }
    free((void *)result);
  }
  else {
    /* Expected failure (NULL) */
    if(result) {
      fprintf(stderr, "test %zu: expected NULL but got '%s'\n", i, result);
      free((void *)result);
      return FALSE;
    }
  }

  return TRUE;
}

UNITTEST_START
{
  size_t i;
  bool all_ok = TRUE;

  if(curl_global_init(CURL_GLOBAL_ALL) != CURLE_OK) {
    fprintf(stderr, "curl_global_init() failed\n");
    return TEST_ERR_MAJOR_BAD;
  }

  for(i = 0; i < ARRAYSIZE(test_specs); ++i) {
    if(!do_test(&test_specs[i], i))
      all_ok = FALSE;
  }
  fail_unless(all_ok, "some tests of Curl_x509_GTime2str() fails");

  curl_global_cleanup();
}
UNITTEST_STOP

#else

UNITTEST_START
{
  puts("not tested since Curl_x509_GTime2str() is not built-in");
}
UNITTEST_STOP

#endif

