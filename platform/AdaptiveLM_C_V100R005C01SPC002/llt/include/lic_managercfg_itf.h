/******************************************************************************
 lic_managercfg_itf.h
 Copyright (C), 2006-2010, Huawei Tech. Co., Ltd.
 Description   : Header file for Init and Configuration methods
  History        :
  <version> <date>     <Author> <Description>
  01a, 2009-06-30, n70141 Initial file.
******************************************************************************/

#ifndef __LIC_MANAGERCFG_ITF_H__
#define __LIC_MANAGERCFG_ITF_H__

#include "lic_base.h"

/*######: Init & Configuration Methods to use in non-DOPRA by the User ######*/

#ifdef __cplusplus
#if __cplusplus
extern "C" {
#endif /* __cpluscplus */
#endif /* __cpluscplus */


/**
* @defgroup Init_Config_LM
* @ingroup ManagerInterface
* This section provides the Initialization and Configuration methods.
*/


/**
* @defgroup LIC_MANAGER_STATIC_CONFIG_STRU
* @ingroup ManagerDatastructures
* @code
* typedef struct TAG_LIC_MANAGER_STATIC_CONFIG_STRU
* {
*    LIC_ULONG  ulManagerMode;
*    LIC_ULONG  ulSafeMemSize;
*    LIC_ULONG  ulLKMemSize;
*    LIC_ULONG  ulSecSafeMemSize;
* } LIC_MANAGER_STATIC_CONFIG_STRU;
* @endcode
* @datastruct ulManagerMode Manager licensing mode LIC_STANDALONE, LIC_NETWORK
* @datastruct ulResCount Specifies total resource count. The range is
* [0-5000]
* @datastruct ulFunCount Specifies total function count. The range is
* [0-5000]
* @datastruct ulSbomCount Specifies total Sbom count. The range is
* [0-5000]
* @datastruct ulSbomMapMaxBbomCount Specifies total Bbom count which map to 
*   sigle Sbom items. The range is  [0-5]
* @datastruct ulSafeMemSize Specifies the safe hidden memory (in Bytes),
*   minimum value: 380 Bytes
* @datastruct ulLKMemSize Specifies LK mem size (in Bytes),
* suggested value: 0x40000
*/
typedef struct TAG_LIC_MANAGER_STATIC_CONFIG_STRU
{
    /* Manager licensing mode LIC_STANDALONE, LIC_NETWORK */
    LIC_ULONG  ulManagerMode;
    
    /* Safe hidden memory, suggested value: 0x400=1k */
    LIC_ULONG  ulSafeMemSize;

     /* LK mem size, suggested value: 0x40000=256k */
    LIC_ULONG  ulLKMemSize;

    /* The Second Safe File mem size, suggested value: 0x400=1k */
    LIC_ULONG  ulSecSafeMemSize;
    
} LIC_MANAGER_STATIC_CONFIG_STRU;


/**
* @defgroup LIC_STATIC_ITEM_INFO_STRU
* @ingroup ManagerDatastructures
* @code
* typedef struct  TAG_LIC_STATIC_ITEM_INFO_STRU
* {
*     LIC_ULONG   ulItemId;
*     LIC_ULONG   ulItemType;
*     LIC_CHAR    acItemName[LIC_ITEM_NAME_MAX_LEN];
*     LIC_CHAR    acItemDesc[LIC_ITEM_DESC_MAX_LEN];
*     LIC_ULONG   ulDefaultVal;
*     LIC_ULONG   ulResMinmVal;   
*     LIC_ULONG   ulResMaxVal;
*     LIC_ULONG   ulResUnitType; 
* } LIC_STATIC_ITEM_INFO_STRU;
* @endcode
* @datastruct ulItemId Specifies item id value.
* @datastruct ulItemType Specifies the item type is Resource or Function
*   it refer to the type of LIC_CONTROLTYPE_ENUM.
* @datastruct acItemName Specifies the item name which will appear in the LK.
* @datastruct acItemDesc Specifies item description.
* @datastruct ulDefaultVal Specifies item default value which will taken when
*   no license file installed in ALM.
* @datastruct ulResMinmVal Specifies Resource item minimal value whick will
*  taken when this item not apear in the license, only for LIC_RESOURCE_CONTROL. 
* @datastruct ulResMaxVal Specifies Resource item maximal value whick will
*  taken when Emergency start or item value exceed the system hardware limit, 
*  only for LIC_RESOURCE_CONTROL. 
* @datastruct ulResUnitType Specifies Resource item type refer to 
*  LIC_RES_UNIT_TYPE_ENUM, only for LIC_RESOURCE_CONTROL. 
*/
typedef struct  TAG_LIC_STATIC_ITEM_INFO_STRU
 {
      /* License Item ID */
    LIC_ULONG   ulItemId;

     /* License Item type, refer to LIC_CONTROLTYPE_ENUM, 
     could be LIC_RESOURCE_CONTROL or LIC_FUNCTION_CONTROL*/
    LIC_ULONG   ulItemType;

     /* License Item name */
    LIC_CHAR    acItemName[LIC_ITEM_NAME_MAX_LEN + 4];

     /* License Item description */
    LIC_CHAR    acItemDesc[LIC_ITEM_DESC_MAX_LEN + 4];

     /* License Item default value which used if no license file installed */
    LIC_ULONG   ulDefaultVal;

     /* only used for type LIC_RESOURCE_CONTROL, minimal value */
    LIC_ULONG   ulResMinmVal;   

     /* only used for type LIC_RESOURCE_CONTROL, max value */
    LIC_ULONG   ulResMaxVal;

     /* only used for type LIC_RESOURCE_CONTROL
     refer to LIC_RES_UNIT_TYPE_ENUM*/
    LIC_ULONG   ulResUnitType; 
     
} LIC_STATIC_ITEM_INFO_STRU;


/**
* @defgroup LIC_BASIC_DATA_STRU
* @ingroup ManagerDatastructures
* @code
* typedef struct TAG_LIC_BASIC_DATA_STRU
*  {
*     LIC_CHAR    acProduct[LIC_PRDNAME_MAX_LEN];
*     LIC_CHAR    acVersion[LIC_PRDVER_MAX_LEN];
*     LIC_CHAR    *pacProdSecData;
* } LIC_BASIC_DATA_STRU;
* @endcode
* @datastruct acProduct Specifies the software product name.
* @datastruct acVersion Specifies the software product version.
* @datastruct pacProdSecData Specifies decrypt key value whic used to verify
*  license file.
*/
typedef struct TAG_LIC_BASIC_DATA_STRU
 {
    /* software product name info*/
    LIC_CHAR    acProduct[LIC_PRDNAME_MAX_LEN + 8];

    /* software product version info*/
    LIC_CHAR    acVersion[LIC_PRDVER_MAX_LEN + 8];

    /* software product license file encrypt key info*/
    LIC_CHAR    *pacProdSecData;
    
} LIC_BASIC_DATA_STRU;


/**
* @defgroup LIC_ALARM_LK_STRU
* @ingroup OtherDatastructures
* @code
* typedef struct TAG_LIC_ALARM_LK_STRU
* {
*     LIC_ULONG ulAlarmName;
*     LIC_ULONG ulAlarmReason;
*     LIC_ULONG ulAlarmLevel;
*     LIC_ULONG ulNodeLKState;
*     LIC_ULONG ulNodeStateLeftDays;
*     LIC_CHAR  acStateStartTime[ LIC_MINI_STREAM_LEN ];
*     LIC_CHAR  acSerialNumber[ LIC_MINI_STREAM_LEN ];
* } LIC_ALARM_LK_STRU;
* @endcode
* @datastruct ulAlarmName Specifies the alarm name. Refer LIC_ALARM_LIST_ENUM
* @datastruct ulAlarmReason Specifies the alarm reson.
* Refer LIC_ALARM_REASON_ENUM
* @datastruct ulAlarmLevel Specifies the alarm level.
* Refer LIC_ALARM_LEVEL_ENUM
* @datastruct ulNodeLKState Specifies the NE state.
* Refer LIC_LK_NODE_STATE_ENUM
* @datastruct ulNodeStateLeftDays Specifies the left days for NE state
* @datastruct acStateStartTime Specifies the start time for the current NE state
* @datastruct acSerialNumber Specifies the Serial number of the LK in NE
* in unit of days
*/
typedef struct TAG_LIC_ALARM_LK_STRU
{
    /* Alarm Name Refer LIC_ALARM_LIST_ENUM */
    LIC_ULONG ulAlarmName;

    /* Cause for the alarm Refer LIC_ALARM_REASON_ENUM */
    LIC_ULONG ulAlarmReason;

    /* Alarm level. Refer LIC_ALARM_LEVEL_ENUM */
    LIC_ULONG ulAlarmLevel;

    /* node status info*/
    LIC_ULONG ulNodeLKState;
    
    /* state left days */    
    LIC_ULONG ulNodeStateLeftDays;
    
    /* state start time*/
    LIC_CHAR  acStateStartTime[LIC_TIME_MAX_LEN];
    
    /* License serial info*/ 
    LIC_CHAR  acSerialNumber[LIC_LKSRNO_MAX_LEN];

} LIC_ALARM_LK_STRU;


typedef struct TAG_LIC_INHERENT_ALARM_STRU
{
    /* Alarm Name Refer LIC_INHERENT_ITEM_STATE_ENUM */
    LIC_ULONG ulAlarmName;
    
    /* Item name */
    LIC_CHAR   acItemName[LIC_MINI_STREAM_LEN];
    
    /* state left days */    
    LIC_USHORT usInherentLeftDays;
} LIC_INHERENT_ALARM_STRU;


typedef enum TAG_LIC_STICK_NOTIFY_ENUM
{
    /* stick启动通知*/
    LIC_STICK_NOTIFY_START = 1,

    /* stick运行期间发送的通知*/
    LIC_STICK_NOTIFY_RUNNING,

    /* stick停止通知*/
    LIC_STICK_NOTIFY_STOP,

    /* 重启恢复stick */
    LIC_STICK_NOTIFY_RECOVER

} LIC_STICK_NOTIFY_ENUM;

typedef struct TAG_LIC_STICK_NOTIFY_STRU
{
    /* stick通知类型，参照LIC_STICK_NOTIFY_ENUM */
    LIC_ULONG  ulNotifyType;

    /* stick剩余天数*/
    LIC_USHORT usStcikLeftDays;

}LIC_STICK_NOTIFY_STRU;


/**
* @defgroup LIC_ALARM_FEATURE_STRU
* @ingroup OtherDatastructures
* @code
* typedef struct TAG_LIC_ALARM_FEATURE_STRU
* {
*     LIC_ULONG ulAlarmName;
*     LIC_ULONG ulAlarmReason;
*     LIC_ULONG ulAlarmLevel;
*     LIC_CHAR  acFeatureName[ LIC_MINI_STREAM_LEN ];
*     LIC_ULONG ulFeatureId;
* } LIC_ALARM_FEATURE_STRU;
* @endcode
* @datastruct ulAlarmName Specifies the alarm name. Refer LIC_ALARM_LIST_ENUM.
* @datastruct ulAlarmReason Specifies the alarm reason.
* Refer LIC_ALARM_REASON_ENUM
* @datastruct ulAlarmLevel Specifies the alarm level.
* Refer LIC_ALARM_LEVEL_ENUM
* @datastruct acFeatureName Specifies the feature name
* @datastruct ulFeatureId Specifies the feature ID
*/
typedef struct TAG_LIC_ALARM_FEATURE_STRU
{
    /* Alarm name. Refer LIC_ALARM_LIST_ENUM */
    LIC_ULONG ulAlarmName;

    /* Alarm Cause. Refer LIC_ALARM_REASON_ENUM */
    LIC_ULONG ulAlarmReason;

    /* Alarm level. Refer LIC_ALARM_LEVEL_ENUM */
    LIC_ULONG ulAlarmLevel;

    /* Feature name */
    LIC_CHAR  acFeatureName[LIC_FEATURE_NAME_MAX_LEN + 4];

    /* Feature ID */
    LIC_ULONG ulFeatureId;

    /* Feature State */
    LIC_ULONG ulFeatureState;

    /* Feature state left days */
    LIC_ULONG ulFeatureStateLeftDays;
} LIC_ALARM_FEATURE_STRU;

/* Alarm main structure */
/**
* @defgroup LIC_ALARM_STRU
* @ingroup OtherDatastructures
* @code
* typedef struct TAG_LIC_ALARM_STRU
* {
*     LIC_ALARM_LK_STRU stLKAlarm;
*     LIC_ULONG ulFeatureAlarmNum;
*     LIC_ALARM_FEATURE_STRU *pstFeatureAlarms;
* } LIC_ALARM_STRU;
* @endcode
* @datastruct stLKAlarm Specifies the LK alarm,
* if ulAlarmName in stLKAlarm is not 0
* @datastruct ulFeatureAlarmNum Specifies the number of feature alarms
* @datastruct pstFeatureAlarms Specifies the feature alarms information
*/
typedef struct TAG_LIC_ALARM_STRU
{
    /* LK Alarm. If stLKAalrm.ulAlarmName is 0, then no LK alarm */
    LIC_ALARM_LK_STRU stLKAlarm;

    /* Number of feature alarms. If 0, then no feature alarms */
    LIC_ULONG ulFeatureAlarmNum;

    /* Feature alarms */
    LIC_ALARM_FEATURE_STRU *pstFeatureAlarms;

} LIC_ALARM_STRU;


/**
* @defgroup LIC_PERM_TEMP_STRU
* @ingroup OtherDatastructures
* @code
* typedef struct TAG_LIC_PERM_TEMP_STRU
* {
*     LIC_ULONG ulPermValue;
*     LIC_ULONG ulTempValue;
* } LIC_PERM_TEMP_STRU;
* @endcode
* @datastruct ulPermValue the permanent value,
* @datastruct ulTempValue the temp value
*/
typedef struct  TAG_LIC_PERM_TEMP_STRU
{
     /* permanent control value */     
     LIC_ULONG  ulPermValue;
     
     /* Temp control value */
     LIC_ULONG  ulTempValue;
} LIC_PERM_TEMP_STRU;


typedef struct TAG_LIC_ITEM_CHANGE_INFO_STRU
{
     /* Item ID */
     LIC_ULONG  ulItemId;

     /* Old control value */
     LIC_ULONG  ulOldValue;

     /* New control value */
     LIC_ULONG  ulNewValue;
     
     /* New control detail value */     
     LIC_PERM_TEMP_STRU  stNewPermTempValue;
     
}LIC_ITEM_CHANGE_INFO_STRU;


typedef struct TAG_LIC_ITEM_CONFIG_USAGE_INFO_STRU
{
    /* Item ID */
    LIC_ULONG ulItemId;

    /* item configuration value */
    LIC_ULONG ulItemConfigVal;

    /* Item usage value */
    LIC_ULONG ulItemUsageVal;
    
} LIC_ITEM_CONFIG_USAGE_INFO_STRU;


/************************ MANAGER: Required callback **************************/

/**
* @defgroup ALM_CALLBACK_GET_MACHINE_ESN
* @ingroup APP_Callbacks_LM
* @code
* typedef LIC_ULONG (*ALM_CALLBACK_GET_MACHINE_ESN)(
*           INOUT LIC_ULONG *pulCount,
*           OUT LIC_MACHINEID_STRU *pstMachineId);
* @endcode
* @par Purpose
* The application call back to get machine ESN information.
* @par Description
* The application call back to get machine ESN information. The callback
* has to be implemented by the application for providing the machine unique id
* as defined and decided by the product. The Ids include Board serial number,
* MAC address, HD serial number, or Backplane board id.
* Interface has to be registered to the License manager through
* ALM_RegisterCallback interface.
*
* @param[in,out] pulCount Input will have number of machine structure buffer.
* Output will have filled count   [Not-null]
* @param[out] pstMachineId Machine esn generating structure, which application
* has to fill [Not-null]
* @retval LIC_OK Success [0|NA]
* @retval LIC_ERROR Failure to fill machine id [1|NA]
* @par Dependency
* lic_managermnt_itf.h
* @attribute Yes NA
*
* @par Note \n
* 1. For *pulCount, value will always be filled with one.
*    *pulCount should not be changed to other than one. \n
* 2. pstMachineId can be filled with either a single ESN or ESN list
*    seperated by ','. It is suggested to fill it with only one ESN.\n
* 3. It should be ensured that the user fills the ESN information
*    in custom_machineprint field of LIC_MACHINEID_STRU
*    for ( LIC_LONG_STREAM_LEN - 1 ) length and ensures the last
*    character is NULL to terminate the string. \n
* 4. ESN filled by the user should not be 'ANY'.\n
* 5. It is strongly suggested that the callback implementation should limit
* itself for implementing only the intended behaviour. It should not perform
* any unrelated actions. \n
* 6. It should not call ALM_GetMachineESN (), ALM_ActivateLicenseKey (),
* ALM_VerifyLicenseKey (), ALM_CompareLicenseKey () APIs as it may lead to
* infinite looping. \n
* 7. It should not call any client APIs as it may create deadlock scenarios.
*
* @par Example
* ALM_CALLBACK_GET_MACHINE_ESN_Example
* @par Related Topics
* ALM_GenerateHash \n
* ALM_GetMachineESN \n
* FAQs
*/
typedef LIC_ULONG (*ALM_CALLBACK_GET_MACHINE_ESN)(INOUT LIC_ULONG *pulCount,
                                        OUT LIC_MACHINEID_STRU *pstMachineId);

/**
* @defgroup ALM_CALLBACK_IOWRITEFUNC
* @ingroup APP_Callbacks_LM
* @code
* typedef LIC_ULONG (*ALM_CALLBACK_IOWRITEFUNC)(IN LIC_ULONG ulType,
*              IN LIC_VOID *pBuf, IN LIC_ULONG ulLen, IN LIC_ULONG ulOffSet);
* @endcode
* @par Purpose
* Callback function to write to the product persistent(flash/hd) store.
* @par Description
* Function to write to the Persistent store. The product should implement the
* callback for writing into specific persistence stores like flash, hard disk.
* The callback should support different types of persistence like: \n
* LIC_HIDDEN_PERSISTENT_SAFEMEM - which will be the hidden/reserved flash memory
* which will be used to store secured license information \n
* LIC_NOT_HIDDEN_PERSISTENT_LKINFO - which will be the normal persistence store
* used to store the license file. \n
* Interface has to be registered to the License manager through
* ALM_RegisterCallback interface. \n
*
* @param[in] ulType enum as LIC_HIDDEN_PERSISTENT_SAFEMEM,
* LIC_NOT_HIDDEN_PERSISTENT_LKINFO [ LIC_PERSISTENT_TYPE_ENUM ]
*
* @param[in] pBuf Specifies buffer input for writing  [Not-null]
* @param[in] ulLen Specifies buffer length [1-0xFFFF]
* @param[in] ulOffSet Specifies buffer Offset from where to start writing
*   [0-0xFFFF]
* @retval LIC_OK Success [0|NA]
* @retval LIC_ERROR Failure to write to IO[1|NA]
* @par Dependency
* lic_managermnt_itf.h
* @attribute Yes NA
*
* @par Note \n
* 1. It is strongly suggested that the callback implementation should limit
* itself for implementing only the intended behaviour. It should not perform
* any unrelated actions. \n
* 2. It should not call any manager APIs as it may lead to infinite looping. \n
* 3. It should not call any client APIs as it may create deadlock scenarios. \n
* 4. If this callback is used to write the data into persistent media file,
* then ensure that file open mode is proper and the data is written from the
* given offset. For linux platform, can use wb+ mode to open persistent media
* file.
*
* @par Example
* ALM_CALLBACK_IOWRITEFUNC_Example
* @par Related Topics
* ALM_CALLBACK_IOREADFUNC \n
* ALM_RegisterCallback \n
* FAQs
*/
typedef LIC_ULONG (*ALM_CALLBACK_IOWRITEFUNC)(IN LIC_ULONG ulType,
                IN LIC_VOID *pBuf, IN LIC_ULONG ulLen, IN LIC_ULONG ulOffSet);

/**
* @defgroup ALM_CALLBACK_IOREADFUNC
* @ingroup APP_Callbacks_LM
* @code
* typedef LIC_ULONG (*ALM_CALLBACK_IOREADFUNC)(IN LIC_ULONG ulType,
*       IN LIC_VOID *pBuf, INOUT LIC_ULONG *pulReadLen,
*       IN LIC_ULONG ulOffSet);
* @endcode
* @par Purpose
* Function to read from persistent store of the product.
* @par Description
* Interface for registering I/O callback to License manager for reading data
* from I/O (Flash, HD, and so on).  Application has to implement this interface
* and its should be registered through ALM_RegisterCallback.
* @param[in] ulType enum as LIC_HIDDEN_PERSISTENT_SAFEMEM,
* LIC_NOT_HIDDEN_PERSISTENT_LKINFO [ LIC_PERSISTENT_TYPE_ENUM ]
*
* @param[in] pBuf Specifies buffer input for reading  [Not-null]
* @param[in,out] pulReadLen Input buffer len,
* output filled data length [1-0xFFFF]
* @param[in] ulOffSet Specifies buffer Offset to read [0-0xFFFF]
* @retval LIC_OK Success [0|NA]
* @retval LIC_ERROR Failure to read I/O [1|NA]
* @par Dependency
* lic_managermnt_itf.h
* @attribute Yes NA
*
* @par Note \n
* 1. It is strongly suggested that the callback implementation should limit
* itself for implementing only the intended behaviour. It should not perform
* any unrelated actions. \n
* 2. It should not call any manager APIs as it may lead to infinite looping. \n
* 3. It should not call any client APIs as it may create deadlock scenarios. \n
* 4. If this callback is used to read the data from persistent media file,
* then ensure that file open mode is proper and the data is read from the
* given offset. For linux platform, can use rb+ mode to open persistent media
* file.
*
* @par Example
* ALM_CALLBACK_IOREADFUNC_Example
* @par Related Topics
* ALM_CALLBACK_IOWRITEFUNC \n
* ALM_RegisterCallback \n
* FAQs
*/
typedef LIC_ULONG (*ALM_CALLBACK_IOREADFUNC)(IN LIC_ULONG ulType,
        IN LIC_VOID *pBuf, INOUT LIC_ULONG *pulLen,
        IN LIC_ULONG ulOffSet);


/**
* @defgroup ALM_CALLBACK_ALARM_NOTIFY
* @ingroup APP_Callbacks_LM
* @code
* typedef LIC_ULONG (*ALM_CALLBACK_ALARM_NOTIFY)(IN LIC_ULONG ulAlarmType,
*                                            IN LIC_ALARM_STRU *pstAlarmInfo);
*
* @endcode
* @par Purpose
* Application callback function for processing alarms
* @par Description
* Interface for license manager to pass the alarms
* to the application for raising different types of alarms to the
* OMT/LMT.
* Alarms are classified into Fault alarm, Info alarms and
* Recovery alarms. Refer LIC_ALARM_TYPE_ENUM for the alarm types.
* While raising alarms to the application, the reason which has caused
* the alarm will also be informed to the application through the callback.
* Refer LIC_ALARM_REASON_ENUM for different alarm reasons.
* Alarms are raised for LK or features. Refer LIC_ALARM_STRU for more details.
* When Emergency, Peak, Trust is started or stopped, applications are notified
* about the changes through Information alarms.
* The callback should be registered through ALM_RegisterCallback.
*
* @param[in] ulAlarmType Specifies alarm type. Refer
* LIC_ALARM_TYPE_ENUM [1-3]
* @param[in] pstAlarmInfo Specifies alarm information.
*   Refer to LIC_ALARM_STRU for more details
*
* @par Note \n
* 1. Alarms and events are mutually exclusive. Alarm callback can be registered
* only if event and policy event callbacks are not registered. \n
* 2. It is strongly suggested that the callback implementation should limit
* itself for implementing only the intended behaviour. It should not perform
* any unrelated actions. \n
* 3. Information in the recovery alarm will be same as the corresponding fault
* alarm for which this recovery alarm is raised. \n
* 4. It should not call any manager APIs other than query APIs as it may lead to
* infinite looping. \n
* 5. It should not call any client APIs as it may create deadlock scenarios.
*
* @retval LIC_OK Success [0|NA]
* @retval LIC_ERROR Failure to notify the state
*   [1|Check the callback implementation]
* @par Dependency
* lic_managermnt_itf.h
* @attribute Yes NA
*
* @par Example
* ALM_CALLBACK_ALARM_NOTIFY_Example
* @par Related Topics
* ALM_RegisterCallback \n
* FAQs
*/
typedef LIC_ULONG (*ALM_CALLBACK_ALARM_NOTIFY)(IN LIC_ULONG ulAlarmType,
                                            IN LIC_ALARM_STRU *pstAlarmInfo);

typedef LIC_ULONG (*ALM_CALLBACK_INHERENT_ITEM_ALARM_NOTIFY)(
                                            IN LIC_INHERENT_ALARM_STRU *pstAlarmInfo);

typedef LIC_ULONG (*ALM_CALLBACK_STICK_NOTIFY_FUNC)(
        IN LIC_STICK_NOTIFY_STRU *pstNotifyInfo);

/**
* @defgroup ALM_CALLBACK_DEBUG_HANDLER
* @ingroup APP_Callbacks_LM
* @code
* typedef LIC_ULONG (*ALM_CALLBACK_DEBUG_HANDLER)(IN LIC_ULONG ulLogType,
*            IN const LIC_CHAR *pInputBuf);
* @endcode
* @par Purpose
* Interface for application to receive the debug and log information.
* @par Description
* Interface for application to receive the debug and log
* information from License Manager.
* \n
* Interface has to be registered to the License manager through
* ALM_RegisterCallback interface.
*
* @param[in] ulLogType Specifies log type [ LIC_LOG_ENUM ]
* @param[in] pInputBuf Specifies input buffer [Not-null]
* @retval LIC_OK for success [0|NA]
* @retval LIC_ERROR for error [1|NA]
* @par Dependency
* lic_managermnt_itf.h
* @attribute No NA
*
* @par Note \n
* 1. The implementation should be thread safe and should handle synchronization
* issues as the invocations of the callback can take place through multiple
* threads. \n
* 2. It is strongly suggested that the callback implementation should limit
* itself for implementing only the intended behaviour. It should not perform
* any unrelated actions. \n
* 3. It should not call any manager APIs as it may lead to infinite looping. \n
* 4. It should not call any client APIs as it may create deadlock scenarios.
*
* @par Example
* ALM_CALLBACK_DEBUG_HANDLER_Example
* @par Related Topics
* ALM_RegisterCallback \n
* ALM_CALLBACK_MINIMAL_DEBUG_HANDLER \n
* FAQs
*/
typedef LIC_ULONG (*ALM_CALLBACK_DEBUG_HANDLER)(IN LIC_ULONG ulLogType,
            IN const LIC_CHAR *pInputBuf);


/**
* @defgroup ALM_CALLBACK_MINIMAL_DEBUG_HANDLER
* @ingroup APP_Callbacks_LM
* @code
* typedef LIC_ULONG (*ALM_CALLBACK_MINIMAL_DEBUG_HANDLER)(
*             IN LIC_ULONG ulLogID);
* @endcode
* @par Purpose
* Interface for application to receive minimal debug and log information.
* @par Description
* Interface for application to receive minimal debug and log
* information from License Manager. It should be used by product
*   having less storage space. In this callback, only important logs will be
*   passed with minimum information.
* \n
* Interface has to be registered to the License manager through
* ALM_RegisterCallback interface.
*
* @param[in] ulLogID Specifies the Log ID [ LIC_LOG_ID_ENUM ]
* @retval LIC_OK for success [0|NA]
* @retval LIC_ERROR for error [1|NA]
* @par Dependency
* lic_managermnt_itf.h
* @attribute Yes NA
*
* @par Note \n
* 1. The implementation should be thread safe and should handle synchronization
* issues as the invocations of the callback can take place through multiple
* threads.
* 2. It is strongly suggested that the callback implementation should limit
* itself for implementing only the intended behaviour. It should not perform
* any unrelated actions. \n
* 3. It should not call any manager APIs as it may lead to infinite looping. \n
* 4. It should not call any client APIs as it may create deadlock scenarios.
*
* @par Example
* ALM_CALLBACK_MINIMAL_DEBUG_HANDLER_Example
* @par Related Topics
* ALM_RegisterCallback \n
* ALM_CALLBACK_DEBUG_HANDLER \n
* FAQs
*/
typedef LIC_ULONG (*ALM_CALLBACK_MINIMAL_DEBUG_HANDLER)(IN LIC_ULONG ulLogID);


/**
* @defgroup ALM_CALLBACK_NODE_STATE_NOTIFY
* @ingroup APP_Callbacks_LM
* @code
* typedef LIC_VOID (*ALM_CALLBACK_NODE_STATE_NOTIFY)(
*                                                 IN LIC_ULONG ulOldNodeState,
*                                                 IN LIC_ULONG ulNewNodeState);
*
* @endcode
* @par Purpose
* Application callback function for notifying NE node state to the application.
* @par Description
* When ever there is a change of NE node state in the system, inform the
* application by invoking the callback. During init time the node state
* will be notified to the application even if there is no change in the
* node state.
* @param[in] ulOldNodeState Specifies the old node state
* [ LIC_LK_NODE_STATE_ENUM ]
* @param[in] ulNewNodeState Specifies the new node state
* [ LIC_LK_NODE_STATE_ENUM ]
*
* @par Note \n
*
* @retval NA
* @par Dependency
* lic_managermnt_itf.h
* @attribute Yes NA
*
* @par Example
* ALM_CALLBACK_NODE_STATE_NOTIFY_Example
* @par Related Topics
* ALM_RegisterCallback \n
* FAQs
*/
typedef LIC_VOID (*ALM_CALLBACK_NODE_STATE_NOTIFY)(IN LIC_ULONG ulOldNodeState,
                                                IN LIC_ULONG ulNewNodeState);

/**
* @defgroup ALM_CALLBACK_PERM_TEMP_ITEM_CHANGE_LIST
* @ingroup APP_Callbacks_LM
* @code
* typedef LIC_ULONG (*ALM_CALLBACK_PERM_TEMP_ITEM_CHANGE_LIST)(
*                     IN LIC_ULONG ulItemCount,
*                     IN LIC_ITEM_CHANGE_INFO_STRU *pstItemList);
* @endcode
* @par Purpose
* Callback to notify the application about change in permanent and temporary
* parts of item control value.
* @par Description
* During item state change due to LK updation, LK expiry, Emergency start,
* Emergency end, Peak start, Peak end, Trust start and so on, the permanent
* and temporary parts of item control value can change. In this case, the
* callback will be invoked to notify the old and new control value of the
* item (old and new control value can be same). \n\n
* For details of calculation of item control value based on the number of
* permanent and temporary items in the LK file, refer
* "Permanent and Temporary License" feature in developer guide.\n\n
* The callback is optional. \n
* The callback should be registered through
* ALM_RegisterCallback interface. \n
*
* @param[in] ulItemCount Specifies changed item count, which is input to
* the callback [1-10000]
* @param[in] pstItemList Specifies changed items info [Not-Null]
* @retval LIC_OK On success [0|NA]
* @retval LIC_ERROR On error, callback has returned error [1|NA]
* @par Dependency
* lic_managermnt_itf.h
*
* @attribute Yes NA
*
* @par Note \n
* 1. The application should process the change notified
*    without blocking inside the callback task context. \n
* 2. It is strongly suggested that the callback implementation should limit
*    itself for implementing only the intended behaviour. It should not perform
*    any unrelated actions. \n
* 3. It should not call any License LIB APIs other than query APIs, as it may
*    lead to infinite looping. \n
* 4. If the callback is registered, during system init time, old and new
*    control values provided in the callback will be same. \n
* 5. It should not call any client APIs as it may create deadlock scenarios.\n
* 6. This callback will not be called for LSW2PEAKCOUNT and LSW2TRUSTBASED
*    items.
*
* @par Example
* ALM_CALLBACK_PERM_TEMP_ITEM_CHANGE_LIST_Example
* @par Related Topics
* ALM_RegisterCallback \n
* FAQs
*/
typedef LIC_ULONG (*ALM_CALLBACK_ITEM_CHANGE_LIST)(
                                IN LIC_ULONG ulItemCount,
                                IN LIC_ITEM_CHANGE_INFO_STRU *pstItemList);



typedef LIC_ULONG (*ALM_CALLBACK_GET_CONIFG_USAGE_LIST)(
                                IN LIC_ULONG ulItemCount,
                                INOUT LIC_ITEM_CONFIG_USAGE_INFO_STRU *pstItemList);

/*****************************************************************************/

/*****************************************************************************
  Function     : ALM_Init
  Description  : License Manager Init function for initialization of manager.
                 The license manager init interface which is to be invoked 
                 before using any config interface to initialize the License
                 Manager.
  Input        : pstConfig Manager static configuration structure
  Output       : None
  Return Value : LIC_OK is success, others is failed.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_Init(
                            IN const LIC_MANAGER_STATIC_CONFIG_STRU *pstConfig);


/*****************************************************************************
  Function     : ALM_RegisterCallback
  Description  : This is the license manager interface for registering all
                 the required OS and Application callbacks for the manager.
  Input        : ulFuncCount number of callbacks to be registered
                 pstCallbackHook list of callbacks
  Output       : None
  Return Value : LIC_OK is success, others is failed.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_RegisterCallback(IN LIC_ULONG ulFuncCount,
    IN const LIC_CALLBACK_FUNCTION_STRU *pstCallbackHook);


/*****************************************************************************
  Function     : ALM_SetProductBasicData
  Description  : This is the license manager interface for setting product
                 data, contains product name, product version and product key.
  Input        : pstBasicData   product info 
  Output       : None
  Return Value : LIC_OK is success, others is failed.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_SetProductBasicData (
                                      IN const LIC_BASIC_DATA_STRU *pstBasicData);


/*****************************************************************************
  Function     : ALM_GetProductBasicData
  Description  : This is the license manager interface for getting product
                 data, contains product name and product version.
  Input        : 
  Output       : pstBasicData   product data
  Return Value : LIC_OK is success, others is failed.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_GetProductBasicData (
                                      OUT LIC_BASIC_DATA_STRU *pstBasicData);


/*****************************************************************************
  Function     : ALM_RegisterBbomControlInfo
  Description  : This is the license manager interface for registering 
                 control item info, contains resource item and function item.
  Input        : ulItemInfoCount    number of control items
                 pstItem     list of control items
  Output       : None
  Return Value : LIC_OK is success, others is failed.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_RegisterBbomControlInfo(
                     IN LIC_ULONG ulItemInfoCount,
                     IN const LIC_STATIC_ITEM_INFO_STRU *pstItem);


/*****************************************************************************
  Function     : ALM_RemoveBbomControlInfo
  Description  : This is the license manager interface for removing specific
                 item. This API is only used when license manager is not 
                 enabled.
  Input        : ulItemInfoCount number of control item to be removed
                 pstItem list of item info
  Output       : None
  Return Value : LIC_OK is success, others is failed.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_RemoveBbomControlInfo (
                     IN LIC_ULONG ulItemInfoCount,
                     IN const LIC_ITEM_INFO_STRU *pstItem );


/*****************************************************************************
  Function     : ALM_SetStaticPolicyAttribute
  Description  : Sets the static attributes for the manager. The attribute
                 types supported is defined in LIC_ATTRIBUTE_TYPE_ENUM.
  Input        : ulAttrType Type of the Attribute [ LIC_ATTRIBUTE_TYPE_ENUM ]
                 pcAttr Pointer to the attribute to be set [Not-Null]
                 ulAttrLen Attribute pointer's allocated length [Non-zero]
  Output       : None
  Return Value : LIC_OK is success, others is failed.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_SetStaticPolicyAttribute(IN LIC_ULONG ulAttrType,
                                   IN const LIC_VOID *pcAttr,
                                   IN LIC_ULONG ulAttrLen);


/*****************************************************************************
  Function     : ALM_GetStaticPolicyAttribute
  Description  : Gets the static attributes for the manager. The attribute
                 types supported is defined in LIC_ATTRIBUTE_TYPE_ENUM.
  Input        : ulAttrType Type of the Attribute [ LIC_ATTRIBUTE_TYPE_ENUM ]

  Output       : pcAttr Pointer to the attribute to be set [Not-Null]
                 ulAttrLen Attribute pointer's allocated length [Non-zero]
  Return Value : LIC_OK is success, others is failed.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_GetStaticPolicyAttribute(IN LIC_ULONG ulAttrType,
                                            INOUT LIC_VOID *pcAttr,
                                            INOUT LIC_ULONG *pulAttrLen);


/*****************************************************************************
  Function     : ALM_Enable
  Description  : Manager enable method to activate the license manager service.
  Input        :
  Output       : 
  Return Value : LIC_OK is success, others is failed.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_Enable(LIC_VOID);


/*****************************************************************************
  Function     : ALM_Disable
  Description  : Manager disable method to disable the license manager service.
  Input        :
  Output       : 
  Return Value : LIC_OK is success, others is failed.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_Disable(LIC_VOID);


/*****************************************************************************
  Function     : ALM_Shutdown
  Description  : Manager shutdown method to shutdown the license manager service.
  Input        :
  Output       : 
  Return Value : LIC_OK is success, others is failed.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_Shutdown(LIC_VOID);

/*****************************************************************************
  Function     : ALM_SetLogLevel
  Description  : Interface to set the Log level for manager.
  Input        : ulLogLevel Log level to set [ LIC_LOG_ENUM ]
  Output       : None
  Return Value : LIC_OK is success, others is failed.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_SetLogLevel(IN LIC_ULONG ulLogLevel);

/*****************************************************************************
 Function     : ALM_SetInherentInfo
 Description  : Set The Inherent Info, include alarm interval and item info

 Input        : pstInherentInfo   alarm interval and item info
 Output       : None
 Return       : LIC_OK on success, others on error
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_SetInherentInfo(
                            LIC_REGISTER_INHERENT_INFO_STRU *pstInherentInfo);

/*****************************************************************************
  Function     : ALM_SetBanEsnMismatch
  Description  : Interface to set the flag for ban esn mismatch repeat actived.
  Input        : bBanEsnMismatch flag to set [ LIC_TRUE/LIC_FALSE ]
  Output       : None
  Return Value : LIC_OK is success, others is failed.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_SetBanEsnMismatch(LIC_BOOL bBanEsnMismatch);

/*****************************************************************************
  Function     : ALM_SetTimeSafe
  Description  : Interface to set the flag for time safe open or not.
  Input        : bTimeSafeFlag flag to set [ LIC_TRUE/LIC_FALSE ]
  Output       : None
  Return Value : LIC_OK is success, others is failed.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_SetTimeSafe(LIC_BOOL bTimeSafeFlag);

/*****************************************************************************
  Function     : ALM_MaskMiniErrors
  Description  : 屏蔽指定次要错误，只能屏蔽值比较的次要错误，包括
                 LIC_ERR_LK_ITEM_DEADLINE_LESSER
                 LIC_ERR_LK_ITEM_VALUE_LESSER
                 LIC_ERR_LK_ITEM_CONFIG_MORE
                 LIC_ERR_LK_ITEM_USED_MORE
                 LIC_ERR_LK_FUNC_DFLT_VAL_ENABLED
                 LIC_ERR_LK_ITEM_LESSER_THAN_DEFAULT
                 LIC_ERR_LK_ITEM_LESSER_THAN_MINIMUM
                 LIC_ERR_LK_ITEM_MORE_THAN_MAXIMUM
                 LIC_ERR_LK_LSN_SMALLER
                 如果要屏蔽多个次要错误，请将次要错误ID进行按位或操作，然后输入
                 接口中。
                 如果ID为0，表示去屏蔽。
                 如果多次调用，以最后一次调用的为准，之前调用设置的屏蔽无效。
  Input        : ulMiniErrIDs
  Output       : None
  Return Value : LIC_OK is success, others is failed.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_MaskMiniErrors(IN LIC_ULONG ulMiniErrIDs);

/*****************************************************************************
  Function     : ALM_SetEsnIsAnyLimit
  Description  : 取消限制esn为any有效期为180天的license的激活次数，但限制总时长
                 为180天。默认不开启
  Input        : bEsnIsAnyLimit 开启或者关闭，取值为LIC_TRUE或者LIC_FALSE.
  Output       : None
  Return Value : LIC_OK is success, others is failed.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_SetEsnIsAnyLimit(LIC_BOOL bEsnIsAnyLimit);

#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif

#endif /*__LIC_MANAGERCFG_ITF_H__*/

