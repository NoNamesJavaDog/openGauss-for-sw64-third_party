/*******************************************************************************
  Copyright (C), 2011, Huawei Tech.Co., Ltd.
  Description    :
  FileName       : lic_base.h
  History        :
  <version> <date>     <Author> <Description>
 01a       2007-4-6   n70141   Initial file
 01b,2012-11-07,l00124426 modified for 1.5C00.
******************************************************************************/

#ifndef __LIC_BASE_H__
#define __LIC_BASE_H__

#include "lic_define.h"
#include "lic_err.h"

#ifdef __cplusplus
#if __cplusplus
extern "C" {
#endif /*ifdef __cplusplus */
#endif /*if __cplusplus*/

/* License LIB version */
#define LICENSE_CBB_VERSION         "AdaptiveLMV100R005C01SPC009"

/**
 * For DLL
 */
#if defined(WIN32)
# if defined(__GNUC__)
#   define LIC_EXPORT
# else
#   if defined(LIC_BUILD_DLL)
#       define LIC_EXPORT __declspec(dllexport)
#   else
#       define LIC_EXPORT
#   endif
# endif
#else
#   define LIC_EXPORT
#endif /* win32 */

#define  LIC_VOID           void
#define  CONST              const
#define  LIC_HANDLE         void* 

/**
 * Define base data type marco
 */
typedef char                LIC_CHAR;
typedef unsigned char       LIC_UCHAR;
typedef unsigned short      LIC_USHORT;
typedef short               LIC_SHORT;
typedef unsigned int        LIC_UINT;
typedef int                 LIC_INT;
typedef long                LIC_LONG;
typedef unsigned long       LIC_ULONG;
typedef unsigned long       LIC_BOOL;

/**
* @defgroup ManagerDatastructures
* This section contains data structure and data types information which is
* requird by Manager component interfaces.
*/


/**
*  LIC_CALLBACK_FUNCTION_STRU
*
*  ulCallbackFuncType: Specifies function type. For Manager, function type
*  can be same as mentioned in LIC_MANAGER_CALLBACK_FUNC_TYPE_ENUM,
*  LIC_SYS_CALLBACK_FUNC_TYPE_ENUM.
*
*  *pfnFunction Specifies function callback address
*/
typedef struct  TAG_LIC_CALLBACK_FUNCTION_STRU
{
    /* uiCallbackFunc Type. For Manager,
    it can be same as mentioned in
    LIC_MANAGER_CALLBACK_FUNC_TYPE_ENUM,
    LIC_SYS_CALLBACK_FUNC_TYPE_ENUM*/
    LIC_ULONG ulCallbackFuncType; 
    
    /* Function callback address */
    LIC_VOID *pfnFunction;        
} LIC_CALLBACK_FUNCTION_STRU;


/**
*  LIC_MINI_STRING_STRU
*
*  szStream Specifies the buffer used to store the string,
*  terminated by null \0
*/
typedef struct TAG_LIC_MINI_STRING_STRU
{
    /* buffer used to store the string, terminated by null '\0' */
    LIC_CHAR szStream[LIC_MINI_STREAM_LEN];
    
}LIC_MINI_STRING_STRU;


/**
*  LIC_SHORT_STRING_STRU
*
*  szStream Specifies the buffer used to store the string,
*  terminated by null \0
*/
typedef struct TAG_LIC_SHORT_STRING_STRU
{
    /* buffer used to store the string, terminated by null '\0' */
    LIC_CHAR szStream[LIC_SHORT_STREAM_LEN];
    
}LIC_SHORT_STRING_STRU;


/**
*  LIC_LONG_STRING_STRU
*
*  szStream Specifies the buffer used to store the string,
*  terminated by null \0
*  Note
*    1. It is strongly adivised not to use a variable of this type
*    in the stack. Instead, declare a pointer of this type
*    and allocate memory for the same accordingly.
*/
typedef struct TAG_LIC_LONG_STRING_STRU
{
    /* buffer used to store the string, terminated by null '\0' */
    LIC_CHAR szStream[LIC_LONG_STREAM_LEN];
    
}LIC_LONG_STRING_STRU;


/**
*  LIC_SYS_T_STRU
*
*  uwYear Year in YYYY format
*  ucMonth scope is 1 - 12
*  ucDate scope is 1 - 31
*  ucHour scope is 0 - 23
*  ucMinute scope is 0 - 59
*  ucSecond scope is 0 - 59
*  ucWeek Reserved for week, currently not used
*/
typedef struct TAG_LIC_SYS_T_STRU
{
   /*if set to OS time the scope is 1970 ~ 2038, or
    the scope is 1970 ~ 2100. format is YYYY
    */
    LIC_USHORT  uwYear;

   /* scope is 1 - 12 */
    LIC_UCHAR   ucMonth;

    /* scope is 1 - 31 */
    LIC_UCHAR   ucDate;

    /* scope is 0 - 23 */
    LIC_UCHAR   ucHour;

    /* scope is 0 - 59 */
    LIC_UCHAR   ucMinute;

    /* scope is 0 - 59 */
    LIC_UCHAR   ucSecond;

    /* scope is 0 - 6, currently not used  */
    LIC_UCHAR   ucWeek;
}LIC_SYS_T_STRU;


/**
 * LIC_NE_TIME_STRU
 */
typedef LIC_MINI_STRING_STRU       LIC_NE_TIME_STRU;


/**
*  LIC_REVOKETICKET_STRU
*/
typedef LIC_SHORT_STRING_STRU       LIC_REVOKETICKET_STRU;

/**
*  LIC_NE_ESN_STRU
*/
typedef LIC_LONG_STRING_STRU       LIC_NE_ESN_STRU;

/**
*  LIC_HASH_STRU
*/
typedef LIC_MINI_STRING_STRU        LIC_HASH_STRU;


/**
*  LIC_VAR_STREAM_STRU
*
*  ulBufSize Specifies the size of the stream
*  pcStream Specifies the buffer stream
*/
typedef struct TAG_LIC_GENERIC_DATA_STRU
{
    /* Length of data */
    LIC_ULONG ulBufSize;

    /* data */
    LIC_CHAR *pcStream;

} LIC_VAR_STREAM_STRU;


/**
*  LIC_MACHINEID_STRU
*
*  custom_machineprint As selected by product as ID of PROM, IP,
*  Disk id, Host name, ethernet address, network srial number. or customer id.
*/
typedef struct TAG_LIC_MACHINEID_STRU
{
    /* As selected by product as ID of PROM, IP, Disk id, Host name,
    ethernet address, network srial no., customer id */
    LIC_CHAR custom_machineprint[LIC_LONG_STREAM_LEN];

} LIC_MACHINEID_STRU;


/**
*  LIC_ITEM_INFO_STRU
*
*  uiItemId Specifies item ID. The range is [1-LIC_NULL_LONG]
*  acItemName Specifies item name
*/
typedef struct TAG_LIC_ITEM_INFO_STRU
{
    /* Item Id */
    LIC_ULONG          ulItemId;

    /* Item name */
    LIC_CHAR            acItemName[LIC_MINI_STREAM_LEN];
} LIC_ITEM_INFO_STRU;

/**
*  LIC_ITEM_INHERNRT_INFO_STRU
*
*  uiItemId Specifies item ID. The range is [1-LIC_NULL_LONG]
*  usInherentDays   item running day
*/
typedef struct TAG_LIC_ITEM_INHERNRT_INFO_STRU
{
    /* Item Id */
    LIC_ULONG          ulItemId;
    
    /* B钥匙可运行的天数 */
    LIC_USHORT          usInherentDays;

    /* 字节对齐保留 */
    LIC_USHORT          usReserve;
} LIC_ITEM_INHERNRT_INFO_STRU;

typedef struct TAG_LIC_REGISTER_INHERENT_INFO_STRU
{
    /* Inherent Alarm Interval */
    LIC_ULONG          ulAlarmInterval;
    
    /* Item count */
    LIC_ULONG          ulItemCnt;

    /* Item name */
    LIC_ITEM_INHERNRT_INFO_STRU *pstItemInfo;
} LIC_REGISTER_INHERENT_INFO_STRU;

typedef struct TAG_LIC_INHERENT_ITEM_INFO_STRU  
{
    /* Item Id */
    LIC_ULONG   ulItemId;

    /* Item name */
    LIC_CHAR    acItemName[LIC_MINI_STREAM_LEN];
    
    /* Inherent item state, refer LIC_INHERENT_ITEM_STATE_ENUM */
    LIC_ULONG   ulInherentState;

    /* Inherent item alarm interval */
    LIC_ULONG   ulAlarmInterval;
    
    /* Inherent item remain days */
    LIC_USHORT  usRemainDays;

    /* Reserve */
    LIC_USHORT  usReserve;
} LIC_INHERENT_ITEM_INFO_STRU;

typedef struct TAG_LIC_STICK_CFG_STRU
{
    /* Stick notify interval */
    LIC_ULONG ulNotifyInterval;

    /* Support stick item count */
    LIC_ULONG ulItemNum;

    /* Support stick items */
    LIC_ITEM_INFO_STRU* pstItems;

} LIC_STICK_CFG_STRU;

typedef struct TAG_LIC_STICK_INFO_STRU
{
    /* 是否支持stick功能，只有配置了支持stick的控制项才支持stick功能 */
    LIC_BOOL bStickIsValid;

    /* stick是否正在运行 */
    LIC_BOOL bStickIsRun;

    /* stick的启动次数剩余量 */
    LIC_USHORT usStartCountLeft;

    /* 当前stick剩余天数。与紧急、宽限保持一致，此值为0时还允许运行一天 */
    LIC_USHORT usRemainDays; 
    
    /* 重启后自动发送stick通知的时间间隔，单位为天 */
    LIC_ULONG ulNotifyInterval;

    /* 查询列出的控制项数目，列出的控制项存放在pstStickItemsArray中 */
    LIC_ULONG ulItemNum;

    /* 支持stick的控制项列表，需要产品分配空间，空间大小不能少于stick item数目 */
    LIC_ITEM_INFO_STRU* pstStickItemsArray; 

} LIC_STICK_INFO_STRU;

/**
 * LIC_COUNT_INFO_STRU
 * 
 */
typedef struct TAG_LIC_COUNT_INFO_STRU
{
    /* control item actual count in license file */
    LIC_ULONG   ulLkItemCnt;

    /* contorl item count by register */
    LIC_ULONG   ulRegisterItemCnt;

    /* revoke code actual count */
    LIC_ULONG   ulRevokeTicketCnt;

    /* offering actual count in license file */
    LIC_ULONG   ulLkOfferCnt;

    /* inherent item conut by register */
    LIC_ULONG   ulRegInherentItemCnt;

    /* feature count in license file */
    LIC_ULONG   ulLkFeatureCnt;
    
}LIC_COUNT_INFO_STRU;

/**
 * ESN=ANY的License的信息，包括剩余天数、已运行天数
 * ESN=ANY的有效期
 * 
 */
typedef struct TAG_LIC_ESN_ANY_INFO_STRU
{
    /* 是否激活过ESN=ANY的License */
    LIC_BOOL    bIsActiveEsnAny;

    /* 剩余天数 */
    LIC_ULONG   ulRemainDays;

    /* 已运行天数 */
    LIC_ULONG   ulRunningDays;

    /* 有效期:如果当前License是ESN=ANY则显示当前License的有效期；
     * 如果不是，则显示上一个ESN=ANY的有效期
     */
    LIC_ULONG   ulEsnAnyCanUseDay;
    
}LIC_ESN_ANY_INFO_STRU;

/**************************** Common callback *****************************/

/*******Callback prototypes for Memory module.******/

/**
* @defgroup OS_Callbacks
* This section contains data structure and data types information which is
* system OS operations required by manager.
*/

/*****************************************************************************
  Function     : LIC_MEMALLOC_FUNC
  Description  : Interface to allocate memory.
  Input        : uiSize Specifies size for memory allocation [1-LIC_NULL_LONG]
  Output       : None
  Return Value : LIC_NULL_PTR On Failure 
*****************************************************************************/
typedef LIC_VOID* (*LIC_MEMALLOC_FUNC)(LIC_ULONG ulSize);


/*****************************************************************************
  Function     : LIC_MEMFREE_FUNC
  Description  : Interface to free memory.
  Input        : pAddr Specifies address to be freed
  Output       : None
  Return Value : LIC_OK on Success,LIC_ERROR on Failure.
*****************************************************************************/
typedef LIC_ULONG (*LIC_MEMFREE_FUNC)(LIC_VOID * pAddr);


/*****************************************************************************
  Function     : LIC_MUTEX_CREATE_FUNC
  Description  : Interface to create recursive mutex.
  Input        : acSmName Specifies name [Not-Null]
  Output       : puiSmID Specifies ID which will be passed to the interfaces for
                 acquiring and releasing mutex. [Not-Null]
  Return Value : LIC_OK on Success,LIC_ERROR on Failure.
*****************************************************************************/
typedef LIC_ULONG (*LIC_MUTEX_CREATE_FUNC)(
            CONST LIC_CHAR acSmName[LIC_SM_NAME_LENGTH],
            LIC_ULONG *pulSmID);


/*****************************************************************************
  Function     : LIC_MUTEX_ACQUIRE_FUNC
  Description  : Interface to acquire mutex.
  Input        : uiSmID Specifies ID [0-LIC_NULL_LONG]
                 uiTimeOutInMillSec Specifies time out in milli seconds.
                 If it is zero, thread which wants to acquire mutex should wait
                 until it is acquired. For non zero values, it should wait
                 till timeout period.
  Output       : 
  Return Value : LIC_OK on Success,LIC_ERROR on Failure.
*****************************************************************************/
typedef LIC_ULONG (*LIC_MUTEX_ACQUIRE_FUNC)(LIC_ULONG ulSmID,
                                    LIC_ULONG ulTimeOutInMillSec);

/**
* @defgroup LIC_MUTEX_RELEASE_FUNC
* @ingroup OS_Callbacks
* @code
* typedef LIC_ULONG (*LIC_MUTEX_RELEASE_FUNC)(LIC_ULONG uiSmID);
* @endcode
* @par Purpose
* Interface to release mutex.
* @par Description
* Interface to release mutex. Only recursive mutex should be used.
* @param[in] uiSmID Specifies ID [0-LIC_NULL_LONG]
* @retval LIC_OK on Success [0|NA]
* @retval Non-Zero on Failure [NA|NA]
* @par Dependency
* lic_base.h
*
* @attribute Yes NA
*
* @par Note
*
* None
*
* @par Example
* None
* @par Related Topics
* LIC_MUTEX_ACQUIRE_FUNC \n
* FAQs
*/

/*****************************************************************************
  Function     : LIC_MUTEX_RELEASE_FUNC
  Description  : Interface to release mutex.
  Input        : uiSmID Specifies ID [0-LIC_NULL_LONG]
  Output       : 
  Return Value : LIC_OK on Success, Non-Zero on Failure.
*****************************************************************************/
typedef LIC_ULONG (*LIC_MUTEX_RELEASE_FUNC)(LIC_ULONG ulSmID);


/*****************************************************************************
  Function     : LIC_MUTEX_DELETE_FUNC
  Description  : Interface to delete mutex. Only recursive mutex should be used.
  Input        : uiSmID Specifies ID [0-LIC_NULL_LONG]
  Output       : 
  Return Value : LIC_OK on Success, Non-Zero on Failure.
*****************************************************************************/
typedef LIC_ULONG (*LIC_MUTEX_DELETE_FUNC)(LIC_ULONG ulSmID);


/*****************************************************************************
  Function     : LIC_GET_SYSTIME_FUNC
  Description  : Interface to get system time.
  Input        : 
  Output       : pstSysTime Specifies system time [Not-Null]
  Return Value : LIC_OK on Success, Non-Zero on Failure.
*****************************************************************************/
typedef LIC_ULONG (*LIC_GET_SYSTIME_FUNC)(LIC_SYS_T_STRU *pstSysTime);


/*****************************************************************************
  Function     : LIC_TIMER_CALLBACK_FUNC
  Description  : Interface to handle timeout.
  Input        : uiPara Specifies parameter to the callback. Currently not used by
                 the license component. 
  Output       : 
  Return Value : LIC_OK on Success, Non-Zero on Failure.
*****************************************************************************/
typedef LIC_VOID (*LIC_TIMER_CALLBACK_FUNC)(LIC_ULONG ulPara);


/*****************************************************************************
  Function     : LIC_START_TIMER_FUNC
  Description  : Interface to start timer.
  Input        : uiLength Specifies length of time interval in millisecs for
                 relative timer.
                 pstTime Not used. Specifies trigger time for absolute
                 timer.                 
                 pfnTmCallBack Specifies callback function for timer.
                 uiType Specifies relative type [LIC_TIMER_TYPE_ENUM]
                 uiMode Specifies mode, one time or repeat [LIC_TIMER_MODE_ENUM]
                 uiTimerId Specifies timer ID. Basically it gives the license
                 component's internal timer id. This can be ignored. [1-8]
  Output       : pTmHandler Specifies timer handler to identify the timer
  Return Value : LIC_OK on Success, Non-Zero on Failure.
*****************************************************************************/
typedef LIC_ULONG (*LIC_START_TIMER_FUNC)(LIC_ULONG *pTmHandler,
                                       LIC_ULONG  ulLength,
                                       LIC_SYS_T_STRU *pstTime,
                                       LIC_TIMER_CALLBACK_FUNC pfnTmCallBack,
                                       LIC_ULONG  ulMode,
                                       LIC_ULONG  ulType,
                                       LIC_ULONG ulTimerId);


/*****************************************************************************
  Function     : LIC_STOP_TIMER_FUNC
  Description  : Interface to stop timer. If timer is already stopped,
                 the interface should return LIC_OK.
  Input        : uiTmHandler Specifies time handler. 
  Output       : 
  Return Value : LIC_OK on Success, Non-Zero on Failure.
*****************************************************************************/
typedef LIC_ULONG (*LIC_STOP_TIMER_FUNC)(LIC_ULONG ulTmHandler);


/**
* @defgroup LIC_ALM_REPORT_ERROR_FUNC
* @ingroup OS_Callbacks
* @code
* typedef LIC_ULONG (*LIC_ALM_REPORT_ERROR_FUNC)(LIC_CHAR *pcFileName,
*          LIC_ULONG uiLineNo, LIC_ULONG uiErrorNo,
*          LIC_ULONG uiParaLen, LIC_VOID *pPara);
* @endcode
* @par Purpose
* Interface to report errors.
* @par Description
* Interface to report errors.
* @param[in] pcFileName Specifies file name [Not-Null]
* @param[in] uiLineNo Specifies the line number at which the error has
* occured [1-LIC_NULL_LONG]
* @param[in] uiErrorNo Specifies error number [1-LIC_NULL_LONG]
* @param[in] uiParaLen Specifies parameter length [1-LIC_NULL_LONG]
* @param[in] pPara Specifies parameter [Not-Null]
* @retval LIC_OK on Success [0|NA]
* @retval Non-Zero on Failure [NA|NA]
* @par Dependency
* lic_base.h
*
* @attribute Yes NA
*
* @par Note
*
* None
*
* @par Example
* None
* @par Related Topics
* FAQs
*/

/*****************************************************************************
  Function     : LIC_ALM_REPORT_ERROR_FUNC
  Description  : Interface to report errors.
  Input        : pcFileName Specifies file name
                 uiLineNo Specifies the line number at which the error has
                 occured
                 uiErrorNo Specifies error number
                 uiParaLen Specifies parameter length
                 pPara Specifies parameter 
  Output       : 
  Return Value : LIC_OK on Success, Non-Zero on Failure.
*****************************************************************************/
typedef LIC_ULONG (*LIC_ALM_REPORT_ERROR_FUNC)(LIC_CHAR *pcFileName,
                                                LIC_ULONG ulLineNo,
                                                LIC_ULONG ulErrorNo,
                                                LIC_ULONG ulParaLen,
                                                LIC_VOID *pPara);

#ifdef __cplusplus
#if __cplusplus
}
#endif /*ifdef __cplusplus */
#endif /*if __cplusplus*/


#endif /* __LIC_BASE_H__ */

