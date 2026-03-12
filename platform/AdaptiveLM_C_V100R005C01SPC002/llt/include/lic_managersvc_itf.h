/*******************************************************************************
  Copyright (C), 2011, Huawei Tech.Co., Ltd.
  Description    : header file contains all the APIs manager service interfaces
  FileName       : lic_managersvc_itf.h
  History        :
  <version> <date>     <Author> <Description>
  01a,2009-06-30,n70141 Initial file.
*******************************************************************************/

#ifndef __LIC_MANAGERSVC_ITF_H__
#define __LIC_MANAGERSVC_ITF_H__

#include "lic_base.h"

#ifdef __cplusplus
#if __cplusplus
extern "C" {
#endif /* __cpluscplus */
#endif /* __cpluscplus */

/*****************************************************************************
 Function     : ALM_GetErrMessage
 Description  : Interface to get error string for the given error number.
 Input        : uiErrNo Input error number
 Output       : 
 Return       : LIC_OK on success else error.
*****************************************************************************/
LIC_EXPORT const LIC_UCHAR* ALM_GetErrMessage(IN LIC_ULONG ulErrNo);


/*****************************************************************************
 Function     : ALM_GetVersionInfo
 Description  : Interface to get the version of license CBB.
 Input        : pstVersionInfo buff to store version of license cbb
 Output       : 
 Return       : LIC_OK on success else error.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_GetVersionInfo(
                                    OUT LIC_MINI_STRING_STRU *pstVersionInfo);

/*****************************************************************************
 Function     : ALM_GenerateHash
 Description  : To generate the hash for the given input in ascii character format.
 Input        : pucData Input buffer [Not-null]
                uiDataLen Input buffer length [Non-zero]
 Output       : pstHash Hashed value of the given input [Not-null]
 Return       : LIC_OK on success else error.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_GenerateHash(LIC_UCHAR* pucData,
                                       LIC_ULONG ulDataLen,
                                       LIC_HASH_STRU *pstHash);

#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif

#endif /*__LIC_MANAGERSVC_ITF_H__*/

