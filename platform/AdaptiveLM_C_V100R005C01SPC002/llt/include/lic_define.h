/******************************************************************************
 lic_define.h
 Copyright (C), 2006-2010, Huawei Tech. Co., Ltd.
 Description   : Header file for Init and Configuration methods
  History        :
  <version> <date>     <Author> <Description>
  01a,2009-06-30,n70141 Initial file.
  01b,2012-11-07,l00124426 modified for 1.5C00.
******************************************************************************/


#ifndef __LIC_DEFINE_H__
#define __LIC_DEFINE_H__

#ifdef __cplusplus
#if __cplusplus
extern "C" {
#endif /* __cpluscplus */
#endif /* __cpluscplus */

#define IN

#define OUT

#define INOUT

#define LIC_NULL_VALUE                  0

#define LIC_NULL_LONG                   ~(0UL)

#define LIC_YES                         1

#define LIC_NO                          0

#define LIC_TRUE                        1

#define LIC_FALSE                       0

#define LIC_OK                            0

#define LIC_ERROR                       1

#define LIC_NULL_PTR                    (0L)

/* Short stream length */
#define LIC_MINI_STREAM_LEN         72

/* Short stream length */
#define LIC_SHORT_STREAM_LEN        136

/*
 *Long stream length.
 *It is strongly adivised not to use this macro, while
 *defining arrays in the stack. Instead, use a pointer
 *and allocate for the length specified by the macro
 */
#define LIC_LONG_STREAM_LEN         2056

/* Max mutex name length */
#define LIC_SM_NAME_LENGTH              16

/* Max number of ESNs supported by the system */
#define LIC_MAX_ESN_NUM                 1

/* Max ESN length, supported by the system (ESN list) */
#define LIC_MAX_ESN_LEN                 2048

/* Prd name max len (without '\0') */
#define LIC_PRDNAME_MAX_LEN             54

/* Prd version max len (without '\0') - Change as per K&V */
#define LIC_PRDVER_MAX_LEN              30

/* Feature name max len */
#define LIC_FEATURE_NAME_MAX_LEN     0x40

/* Item name max len */
#define LIC_ITEM_NAME_MAX_LEN           0x40

/* Item unit description max len */
#define LIC_ITEM_UNIT_MAX_LEN           0x40

/* Item description max len */
#define LIC_ITEM_DESC_MAX_LEN            0x80

/* SaleItem English & Chinese Description Max Len */
#define LIC_SALEITEM_DESC_MAX_LEN        256

/* Customer Name Max Len */
#define LIC_CUSTOMER_NAME_MAX_LEN       512

/* Max resource count */
#define LIC_MAX_RESITEM_COUNT           5000

/* Max function count */
#define LIC_MAX_FUNITEM_COUNT           5000

/* Max SBOM count */
#define LIC_MAX_SBOM_COUNT          5000

/* Max SBOM maped BBOM count */
#define LIC_MAX_S2BBOM_COUNT       5

/* Max Offering  count */
#define LIC_MAX_OFFERING_COUNT      10

/* License file serial no. length */
#define LIC_LICFILE_SRNO_LEN            17

/* License file serial no. length */
#define LIC_LKSRNO_MAX_LEN            24

/* Revoke ticket length */
#define LIC_REVOKE_TICKET_LEN           40

/* Max ESN=ANY Can Use Day */
#define LIC_MAX_ESN_ANY_CAN_USE_DAY    255

/* Max Mask Minor Error Count */
#define LIC_MAX_MASK_MINOR_ERR_COUNT    9

/*
 *LM-Daily Timer for managing NE state. In C05 version, this timer is removed.
 *This timer id should not be used for testing purpose. 
 */
#define LIC_LM_STATE_MGR_ABS_TIMR_ID                    1

/* LM-Hourly Timer for managing NE state */
#define LIC_LM_STATE_MGR_REL_TIMR_ID                    2

/* Max feature number supported by the system */
#define LIC_MAX_FEATURES_NUM                            50

/* Maximum length of the item retrieved from the license file */
#define LIC_MAX_ITEM_LINE_LEN                           4096

/* Max Item num that can repeat in LK */
#define LIC_MAX_ITEM_VALUE_NUM                 5

/* Maximum number of revoke tickets supported */
#define LIC_MAX_REVOKE_TKT_ENTRIES 10

/* Maximum number of security files supported */
#define LIC_MAX_SECURITY_FILE_ENTRIES 10

/* Grace alarm will be raised once in 10 days */
#define LIC_TRIAL_ALARM_DFLT_INTERVAL_DAYS 10

/* the length of full time, YYYY-MM-DD HH:MM:SS */
#define LIC_FULL_TIME_LEN   19

/* the length of deadline,YYYY-MM-DD */
#define LIC_DEADLINE_LEN    10

/* the length of time info,YYYY-MM-DD HH:MM:SS */
#define LIC_TIME_MAX_LEN    24

/* the max length of sign */
#define LIC_MAX_SIGN_LEN 1024

#define LIC_MANAGER                     0x1

/* Default operator id */
#define LIC_DFLT_OPERATOR_ID   (0xFFFFFFFF)

/* Reserved operator Id for items disabled for sharing */
#define LIC_RESRVD_OPR_ID_FOR_DISBLD_ITEM ((LIC_DFLT_OPERATOR_ID) - 1)

/* Inherent Item Max Count */
#define LIC_LICENSE_KEY_INHERENT_ITEM_MAX_NUM    255

/*License SoftWareId in Comment*/
#define LIC_SOFT_ID_LEN 64


/**
*  LIC_LK_NODE_STATE_ENUM
*
*  LIC_LK_NODE_DEFAULT_STATE Specifies NE Default State
*  LIC_LK_NODE_GRACE_PERIOD_STATE Specifies NE GracePeriod (Trial) State
*  LIC_LK_NODE_NORMAL_STATE Specifies NE Normal State, LK commercial type
*  LIC_LK_NODE_EMERGENCY Specifies NE Emergency State
*  LIC_LK_NODE_DEMO_STATE Specifies NE Commissioning(Demo), LK Demo i.e. Commissioning type
*  LIC_LK_NODE_ERROR_TAB Not used
*/
/* Enum for LK node status  */
typedef enum TAG_LIC_LK_NODE_STATE_ENUM
{
    LIC_LK_NODE_DEFAULT_STATE = 1,  /* NE Default State */
    LIC_LK_NODE_GRACE_PERIOD_STATE, /* NE GracePeriod (Trial) State */
    LIC_LK_NODE_NORMAL_STATE,       /* NE Normal State, LK comm type */
    LIC_LK_NODE_EMERGENCY,          /* NE Emergency State */
    LIC_LK_NODE_DEMO_STATE,         /* NE Commissioning (Demo),
                                       LK Demo i.e. Commissioning type */
    LIC_LK_NODE_ERROR_TAB

} LIC_LK_NODE_STATE_ENUM;

/* Enum for LK feature status for the features */
typedef enum TAG_LIC_LK_FEATURE_STATE_ENUM
{
    /* After LK items deadline, grace period (trial) over: Default state */
    LIC_FEATURE_DEFAULT_STATE = 1,  /* Feature Default state */

    /* Before LK items deadline, grace period (trial) start */
    LIC_FEATURE_GRACE_PERIOD_STATE, /* Feature GracePeriod (trial) state */
    
    LIC_FEATURE_NORMAL_STATE, /* Feature normal state */
    
    LIC_FEATURE_DEMO_STATE = 5, /* Feature commissioning (demo) state */

    LIC_FEATURE_STATE_ERROR_TAB

}LIC_LK_FEATURE_STATE_ENUM;

/* Enum for LK Item status for the items */
typedef enum TAG_LIC_LK_ITEM_STATE_ENUM
{
    /* After LK items deadline, grace period (trial) over: Default state */
    LIC_ITEMS_DEFAULT_STATE = 1,  /* Item Default state */

    /* After LK items deadline, grace period (trial) start */
    LIC_ITEMS_TRIAL_STATE,
    LIC_ITEMS_NORMAL_STATE,       /* After LK actived, items becomes normal*/
    LIC_ITEMS_EMERGENCY,          /* If LK is in emergency */

    LIC_ITEMS_STATE_ERROR_TAB

}LIC_LK_ITEM_STATE_ENUM;

/**
*  LIC_ALARM_REASON_ENUM
*
*  LIC_ALARM_RSN_LK_REVOKED LK is revoked
*  LIC_ALARM_RSN_LK_ESN_MISMATCH ESN mismatch occured while activating LK
*  LIC_ALARM_RSN_LK_VERSION_MISMATCH Version mismatch occured while activating LK
*  LIC_ALARM_RSN_EMERGENCY_START Emergency is started
*  LIC_ALARM_RSN_EMERGENCY_STOP Emergency is stopped after 7 days
*  LIC_ALARM_RSN_NO_LK_AVAILABLE No LK is present in persistent medium
*   during initialization
*  LIC_ALARM_RSN_LK_DEADLINE_OVER LK deadline is over
*  LIC_ALARM_RSN_LK_GRACE_PERIOD_OVER LK grace period is over
*  LIC_ALARM_RSN_INIT_LK_ACTIVATION_FAILED LK activation failed during
*   init time
*  LIC_MANAGER_ALARM_REASON_BUTT Not used
*/
typedef enum TAG_LIC_ALARM_REASON_ENUM
{
    /* Note: Don't change the existing alarm reason assigned values below.
    These values are mapped to some of the event reasons */

    /******************* LK alarm reasons *******************************/
    /*************** Init time and run time LK alarm reasons *************/
    /* LK is revoked */
    LIC_ALARM_RSN_LK_REVOKED = 3,

    /* ESN mismatch occured while activating LK */
    LIC_ALARM_RSN_LK_ESN_MISMATCH = 4,

    /* Version mismatch occured while activating LK */
    LIC_ALARM_RSN_LK_VERSION_MISMATCH = 5,

    /* Both ESN and Version mismatch occured while activating LK */
    LIC_ALARM_RSN_LK_ESN_AND_VERSION_MISMATCH = 6,

    /* Emergency started. State will change to emergency */
    LIC_ALARM_RSN_EMERGENCY_START = 7,

    /*Emergency stopped after 7 days. The state will
    be changed as per the current LK state.*/
    LIC_ALARM_RSN_EMERGENCY_STOP = 8,

    /***************** Init time LK alarm reasons ************************/
    /* During init, no LK available */
    LIC_ALARM_RSN_NO_LK_AVAILABLE = 15,

    /******************* Feature Alarm reasons **************************/
    /* LK Deadline over. State will change to GracePeriod */
    LIC_ALARM_RSN_LK_DEADLINE_OVER = 17,

    /* LK grace period over. State will change to Default */
    LIC_ALARM_RSN_LK_GRACE_PERIOD_OVER = 18,

    /* During init, activation failed */
    LIC_ALARM_RSN_INIT_LK_ACTIVATION_FAILED = 23,

    /* Not used */
    LIC_MANAGER_ALARM_REASON_BUTT

}LIC_ALARM_REASON_ENUM;

/**
*  LIC_ALARM_LEVEL_ENUM
*
*  LIC_ALARM_LEVEL_CRITICAL Indicates critical alarm
*  LIC_ALARM_LEVEL_MAJOR Indicates major alarm
*  LIC_ALARM_LEVEL_MINOR Indicates minor alarm
*  LIC_ALARM_LEVEL_SUGGESTION Indicates suggestive alarm
*  LIC_ALARM_LEVEL_BUTT Not used
*/
typedef enum TAG_LIC_ALARM_LEVEL_ENUM
{
    /* Critical */
    LIC_ALARM_LEVEL_CRITICAL = 1,

    /* Major */
    LIC_ALARM_LEVEL_MAJOR,

    /* Minor */
    LIC_ALARM_LEVEL_MINOR,

    /* Suggestion */
    LIC_ALARM_LEVEL_SUGGESTION,

    /* Critical */
    LIC_ALARM_LEVEL_BUTT
}LIC_ALARM_LEVEL_ENUM;


/**
*  LIC_TIMER_TYPE_ENUM
*
*  LIC_TIMER_TYPE_ABS Specifies absolute timer.
*   It is deprecated and not in use. License does not use
*   absolute timer. So, the product need not implement the same.
*  LIC_TIMER_TYPE_REL Specifies relative timer
*  LIC_TIMER_TYPE_BUTT Not used
*/
/* Adapter: Timer types */
typedef enum TAG_LIC_TIMER_TYPE_ENUM
{
    /* Absoulte Timer. Deprecated. Not used */
    LIC_TIMER_TYPE_ABS = 0, 
    
    /* Relative Timer */
    LIC_TIMER_TYPE_REL,     

    LIC_TIMER_TYPE_BUTT
}LIC_TIMER_TYPE_ENUM;


/**
*  LIC_TIMER_MODE_ENUM
*
*  LIC_TIMER_MODE_ONCE One time
*  LIC_TIMER_MODE_REPEAT Repeat again
*  LIC_TIMER_MODE_BUTT Not used
*/
/* Adapter: Timer mode */
typedef enum TAG_LIC_TIMER_MODE_ENUM
{
    /* One time */
    LIC_TIMER_MODE_ONCE = 0, 
    
    /* Repeat again */
    LIC_TIMER_MODE_REPEAT,   

    LIC_TIMER_MODE_BUTT
}LIC_TIMER_MODE_ENUM;


/**
*  LIC_LOG_ENUM
*
*  LIC_TRACE_LOG Trace Level
*  LIC_DEBUG_LOG Debugging Level
*  LIC_INFO_LOG Information Level
*  LIC_NOTICE_LOG Notice Level
*  LIC_WARNING_LOG Warning Level
*  LIC_ERROR_LOG Error Level
*  LIC_CRITICAL_LOG Critical Level
*  LIC_FATAL_LOG Fatal Level
*  LIC_LOG_BUTT Not used
*/
/* Enum types for logging */
typedef enum TAG_LIC_LOG_ENUM
{
    LIC_TRACE_LOG = 0,
    LIC_DEBUG_LOG,
    LIC_INFO_LOG,
    LIC_NOTICE_LOG,
    LIC_WARNING_LOG,
    LIC_ERROR_LOG,
    LIC_CRITICAL_LOG,
    LIC_FATAL_LOG,

    LIC_LOG_BUTT

}LIC_LOG_ENUM;


/**
*  LIC_CONTROLTYPE_ENUM
*
*  LIC_RESOURCE_CONTROL Specifies License resource control type
*  LIC_FUNCTION_CONTROL Specifies License function control type
*  LIC_MAINTAIN_BUTT Not used
*/
typedef enum TAG_LIC_CONTROLTYPE_ENUM
{
    /* License resource control type */
    LIC_RESOURCE_CONTROL = 0,   

    /* License function control type */
    LIC_FUNCTION_CONTROL,            

    LIC_MAINTAIN_BUTT

} LIC_CONTROLTYPE_ENUM;

/**
*  LIC_RES_UNIT_TYPE_ENUM
*
*  LIC_RES_COUNT_STATIC
*    License resource type static counted: Every application
*    instance license usage is counted, this type to be
*    used for the resources which are used during
*    only Init time, this type not support Emergency function.
*  LIC_RES_COUNT_DYNAMIC
* License resource type dynamic counted: Every
*    application instance license usage is counted,
*    this type to be used for the resources
*    which are used during runtime, this type support the 
*    Emergency function.
*  LIC_RES_UNIT_BUTT Not used
*/
typedef enum TAG_LIC_RES_UNIT_TYPE_ENUM
{
    /* License resource type static counted */
    LIC_RES_COUNT_STATIC = 1,

    /* License resource type dynamic counted */
    LIC_RES_COUNT_DYNAMIC,

    /* License resource type function counted */
    LIC_RES_COUNT_FUNCTION,

    /* License resource type performance based */
    LIC_RES_PERFORMANCE,

    LIC_RES_UNIT_BUTT

} LIC_RES_UNIT_TYPE_ENUM;


/**
*  LIC_FUN_UNIT_TYPE_ENUM
*
*  LIC_FUNCTION_NORMAL License function type normal: This type is to be
*                             used for the functions which are used during
*                             initialization time or during activation at
*                             runtime.
*                             If the LK value is changed, application will be
*                             informed by invoking the callback.
*  LIC_FUN_UNIT_BUTT Not used
*/
typedef enum TAG_LIC_FUN_UNIT_TYPE_ENUM
{
    LIC_FUNCTION_NORMAL = 1,   /* License function type normal: This type to be
                               used for the functions which are used during
                               Init time or during its activated, during runtime
                               if the LK value is changed will inform the
                               application by invoking the callback */
    LIC_FUN_UNIT_BUTT

} LIC_FUN_UNIT_TYPE_ENUM;


/**
*  LIC_PERSISTENT_TYPE_ENUM
*
*  LIC_HIDDEN_PERSISTENT_SAFEMEM All safe hidden information are
*   stored in this type of persistence: \n
*                              1. LK state(Node license state), Time of start \n
*                              2. Emergency and GracePeriod state remain days \n
*                              3. Flag for ESN version mismatch \n
*                              4. Emergency remain count \n
*                              5. Product version \n
*                              6. Revoke Info (LSN) \n
*                              7. Current LK LSN \n
*                              8. LSN for the LK with ESN=ANY and validity of
*                                   6 months
*  LIC_NOT_HIDDEN_PERSISTENT_LKINFO Specifies
*       License file storage memory
*  LIC_PERSISTENT_BUTT Not used
*/
typedef enum TAG_LIC_PERSISTENT_TYPE_ENUM
{
    /* All safe hidden information */
    LIC_HIDDEN_PERSISTENT_SAFEMEM, 

    /* License file storage memory */
    LIC_NOT_HIDDEN_PERSISTENT_LKINFO,  

    /* The Second Safe Memory File */
    LIC_HIDDEN_PERSISTENT_SECOND_SAFEMEM,    

    LIC_PERSISTENT_BUTT
}LIC_PERSISTENT_TYPE_ENUM;

/**
*  LIC_ATTRIBUTE_TYPE_ENUM
*
*  LIC_LK_GRACE_PERIOD_ALARM_INTERVAL Attribute type to
*   set the grace alarm send interval days \n
*  LIC_SUPPRESS_LK_VER_CHECK Attribute type to disable the version
*   comparison in LK during LK activation and verification.
*   If it is LIC_TRUE, then the product version
*    validation will be skipped during LK activation and verification. \n
*    If it is LIC_FALSE, then the product version validation will be done
*    during LK activation and verification. \n
*  LIC_INIT_CONFIG_PARAMS Attribute type for init configuration
*   parameters. This type cannot be set but only queried.
*  LIC_SUPPRESS_LK_PRD_NAME_CHECK
*  LIC_IGNORE_ESN_UPPER_AND_LOWER
*  LIC_ATTRIBUTE_TYPE_BUTT Not used
*/
typedef enum TAG_LIC_ATTRIBUTE_TYPE_ENUM
{
     /* Periodicity of Inherent Alarm in days */
    LIC_LK_GRACE_PERIOD_ALARM_INTERVAL = 1,

    /* Do not validate the version in LK when the LK is activated */
    LIC_SUPPRESS_LK_VER_CHECK,

    /* Type to get init configuration */
    LIC_INIT_CONFIG_PARAMS, 
    
    /* Do not validate the product name in LK when the LK is activated */
    LIC_SUPPRESS_LK_PRD_NAME_CHECK,

    /* Ignore ESN uppercase and lowercase in license file and get machine ESN 
    callback*/
    LIC_IGNORE_ESN_UPPER_AND_LOWER,

    /*软件发布时间*/
    LIC_SOFTWARE_ISSUE_TIME,

    /* 小时定时器超时时间 */
    LIC_HOURLY_TIMER_TIMEOUT,

    /* 兼容C03 */
    LIC_C03_COMPATIBLE,
    
    LIC_ATTRIBUTE_TYPE_BUTT
}LIC_ATTRIBUTE_TYPE_ENUM;


/**
*  LIC_SYS_CALLBACK_FUNC_TYPE_ENUM
*
*  LIC_CALLBACK_TYPE_STATIC_MALLOC Static Memory
*                       Alloc Interface LIC_MEMALLOC_FUNC \n
*  LIC_CALLBACK_TYPE_STATIC_FREE
*                       Memory Free Interface LIC_MEMFREE_FUNC \n
*  LIC_CALLBACK_TYPE_DYNAMIC_MALLOC Dynamic memory
*                       Alloc Interface LIC_MEMALLOC_FUNC \n
*  LIC_CALLBACK_TYPE_DYNAMIC_FREE Dynamic memory
*                       Free Interface LIC_MEMFREE_FUNC \n
*  LIC_CALLBACK_TYPE_MUTEX_CREATE Mutex create
*                       Interface LIC_MUTEX_CREATE_FUNC \n
*  LIC_CALLBACK_TYPE_MUTEX_DELETE Mutex delete
*                       Interface LIC_MUTEX_DELETE_FUNC \n
*  LIC_CALLBACK_TYPE_MUTEX_ACQUIRE Mutex P operation
*                       Interface LIC_MUTEX_ACQUIRE_FUNC \n
*  LIC_CALLBACK_TYPE_MUTEX_RELEASE Mutex V operation
*                       Interface LIC_MUTEX_RELEASE_FUNC \n
*  LIC_CALLBACK_TYPE_GET_TIME Get Time 
*                       Interface LIC_GET_SYSTIME_FUNC\n
*  LIC_CALLBACK_TYPE_START_TIMER Start Timer
*                       Interface LIC_START_TIMER_FUNC \n
*  LIC_CALLBACK_TYPE_STOP_TIMER Stop Timer
*                       Interface LIC_STOP_TIMER_FUNC \n
* @dataenum LIC_CALLBACK_TYPE_BUTT Not used
*/
/* Various OS,  callbacks list is provided here, the list includes the enum,
prototype in comment of each callbacks. */
typedef enum TAG_LIC_SYS_CALLBACK_FUNC_TYPE_ENUM
{
    /* Memory Interfaces */
    LIC_CALLBACK_TYPE_DYNAMIC_MALLOC = 3,    /* LIC_MEMALLOC_FUNC */
    LIC_CALLBACK_TYPE_DYNAMIC_FREE,      /* LIC_MEMFREE_FUNC */

    /* OS Interfaces */
    LIC_CALLBACK_TYPE_MUTEX_CREATE,      /* LIC_MUTEX_CREATE_FUNC */
    LIC_CALLBACK_TYPE_MUTEX_DELETE,      /* LIC_MUTEX_DELETE_FUNC */
    LIC_CALLBACK_TYPE_MUTEX_ACQUIRE,     /* LIC_MUTEX_ACQUIRE_FUNC */
    LIC_CALLBACK_TYPE_MUTEX_RELEASE,     /* LIC_MUTEX_RELEASE_FUNC */

    /* Time Interfaces */
    LIC_CALLBACK_TYPE_GET_TIME,          /* LIC_GET_SYSTIME_FUNC */
    LIC_CALLBACK_TYPE_START_TIMER,       /* LIC_START_TIMER_FUNC */
    LIC_CALLBACK_TYPE_STOP_TIMER,        /* LIC_STOP_TIMER_FUNC */

    LIC_CALLBACK_TYPE_BUTT

} LIC_SYS_CALLBACK_FUNC_TYPE_ENUM;


/* Various Manager callbacks list is provided here,
the list includes the enum, prototype in comment of each callbacks. */
typedef enum TAG_LIC_MANAGER_CALLBACK_FUNC_TYPE_ENUM
{
    /* This is the report error callback  R5 change to LIC_MANAGER_CALLBACK_FUNC_TYPE_ENUM */
    ALM_CALLBACK_TYPE_SYSTEM_ERROR= 51,       /* for the old LIC_ALM_REPORT_ERROR_FUNC  */

    /* Debug Interfaces for handling the logs. It should be used by product
    having less storage space. In this callback, only important logs will be
    passed with minimum information.
    ALM_CALLBACK_MINIMAL_DEBUG_HANDLER  R5 change name to ALM_CALLBACK_TYPE_BUSINESS_ERROR*/
    ALM_CALLBACK_TYPE_BUSINESS_ERROR,

    /*Debug Interfaces for debugging
    ALM_CALLBACK_DEBUG_HANDLER R5 change name to ALM_CALLBACK_TYPE_DEBUG_LOG*/
    ALM_CALLBACK_TYPE_DEBUG_LOG,

    /*IO Interfaces */
    /* ALM_CALLBACK_IOREADFUNC  R5 change name to ALM_CALLBACK_TYPE_IO_READ_FUNC*/
    ALM_CALLBACK_TYPE_IO_READ_FUNC,

    /* ALM_CALLBACK_IOWRITEFUNC R5 change name to ALM_CALLBACK_TYPE_IO_WRITE_FUNC*/
    ALM_CALLBACK_TYPE_IO_WRITE_FUNC,

    /*APP_Central, to provide the machine finger print
    ALM_CALLBACK_GET_MACHINE_ESN*/
    ALM_CALLBACK_TYPE_GET_MACHINE_ESN,

    /* Alarm notification callback type, ALM_CALLBACK_ALARM_NOTIFY  R5 change name to ALM_CALLBACK_TYPE_NODE_LK_ALARM_NOTIFY */
    ALM_CALLBACK_TYPE_NODE_LK_ALARM_NOTIFY,

    /* Callback to notify the NE state change to APP.
    ALM_CALLBACK_NODE_STATE_NOTIFY  R5 change name to  ALM_CALLBACK_TYPE_NODE_LK_STATE_NOTIFY*/
    ALM_CALLBACK_TYPE_NODE_LK_STATE_NOTIFY,

    /*Callback to notify change in permanent and temporary parts.
    ALM_CALLBACK_TYPE_ITEM_CHANGE_LIST  R5 change name to ALM_CALLBACK_TYPE_ITEM_CHANGE_NOTIFY*/
    ALM_CALLBACK_TYPE_ITEM_CHANGE_NOTIFY,

    /* Callback to get the config and used value of every items
    ALM_CALLBACK_TYPE_GET_CONFIG_USAGE_LIST */
    ALM_CALLBACK_TYPE_GET_CONFIG_USAGE_LIST,

    /* B钥匙item级别告警类型 */ 
    ALM_CALLBACK_TYPE_INHERENT_ITEM_ALARM_NOTIFY,

    /* Stick通知的回调 */
    ALM_CALLBACK_TYPE_STICK_NOTIFY,
    
    /* Not used */
    ALM_CALLBACK_TYPE_BUTT

}LIC_MANAGER_CALLBACK_FUNC_TYPE_ENUM;


/**
*  LIC_LOG_ID_ENUM
*
*  LOG_PERS_WRITE_ERROR
*   Unable to write data into safe memory
*  LOG_PERS_READ_ERROR
*   Unable to read data from safe memory
*  LOG_PERS_MAX_LK_ENTRIES_REACHED_ERROR
*   Maximum revoke ticket entries reached
*  LOG_PERS_GET_LK_INFO_READ_ERROR
*   Unable to read data from safe memory
*  LOG_PERS_INIT_SAFE_MEM_READ_ERROR
*   Insufficent memory for safe memory
*  LOG_PERS_INSUFFICIENT_SAFE_MEM_ERROR
*   ESN or Version mismatch error while activating LK
*  LOG_LK_ESN_VERS_MISMATCH_ERROR
*   ESN or Version mismatch error while activating LK
*  LOG_INIT_LK_PARSE_ERROR
*   Parser system error while activating LK when enabling manager
*  LOG_INIT_LK_NO_PRD_FEATURE_PRESENT
*   No product features present in LK while activating LK when enabling manager
*  LOG_INIT_LK_MAX_FEATURE_REACHED
*   LK features exceeded max limit of 50 while activating LK when enabling
*   manager
*  LOG_INIT_LK_INVALID_FEATURE_TYPE
*   Invalid feature type while activating LK when enabling manager
*  LOG_INIT_LK_MEM_ALLOC_FAIL
*   Memory allocation failed while activating LK when enabling manager
*  LOG_INIT_LK_GET_ESN_ERROR
*   Get ESN error while activating LK when enabling manager
*  LOG_LM_NO_LK_PRESENT
*   No LK found for activation
*  LOG_INIT_LK_NO_PERM_FEAT_EXIST
*   No Term feature found for activation
*/

/* Enum for Mininal Log ID */
typedef enum TAG_LIC_LOG_ID_ENUM
{
    /* PERSISTANCE */
    LOG_PERS_WRITE_ERROR = 1,
    LOG_PERS_SAVED_PRDT_VERS_ERROR,
    LOG_PERS_SAVED_MSG_DIGEST_WITH_RVK_TICKET_ERROR,
    LOG_PERS_SAVED_MSG_DIGEST_WITHOUT_RVK_TICKET_ERROR,
    LOG_PERS_READ_ERROR,
    LOG_PERS_MAX_LK_ENTRIES_REACHED_ERROR,
    LOG_PERS_GET_LK_INFO_READ_ERROR,
    LOG_PERS_INIT_SAFE_MEM_READ_ERROR,
    LOG_PERS_INSUFFICIENT_SAFE_MEM_ERROR,

    /* LK */
    LOG_LK_ESN_VERS_MISMATCH_ERROR,
    LOG_LK_FILE_IS_OVERDUE,
    LOG_LK_ESN_ANY_CAN_USE_DAY_OVER,

    /* INIT-LK */
    LOG_INIT_LK_PARSE_ERROR = 27,
    LOG_INIT_LK_NO_PRD_FEATURE_PRESENT,
    LOG_INIT_LK_MAX_FEATURE_REACHED,
    LOG_INIT_LK_INVALID_FEATURE_TYPE,
    LOG_INIT_LK_MEM_ALLOC_FAIL,
    LOG_INIT_LK_GET_ESN_ERROR,
    LOG_INIT_LK_NO_PERM_FEAT_EXIST,
    
    /* LM specific */
    LOG_LM_NO_LK_PRESENT = 35

    /*LOG_PERS_SAVED_PRDT_VERS_ERROR = 51*/
    
} LIC_LOG_ID_ENUM;


/**
*  LIC_LICENSE_KEY_TYPE_ENUM
*
*  LIC_LICENSE_KEY_TYPE_COMM Specifies that the LK is of type Commercial
*  LIC_LICENSE_KEY_TYPE_DEMO Specifies that the LK is of type Demo(Commissioning)
*  LIC_LICENSE_KEY_TYPE_BUTT Specifies invalid LK type
*/
/* Classification of LK based on LK type.*/
typedef enum TAG_LIC_LICENSE_KEY_TYPE_ENUM
{
    /* Commercial type */
    LIC_LICENSE_KEY_TYPE_COMM,

    /* DEMO(Commissioning) type */
    LIC_LICENSE_KEY_TYPE_DEMO,

    /* Unused */
    LIC_LICENSE_KEY_TYPE_BUTT
    
} LIC_LICENSE_KEY_TYPE_ENUM;


/**
* @defgroup LIC_LICENSE_KEY_DEADLINE_ENUM
* @ingroup OtherDatastructures
* @code
* typedef enum TAG_LIC_LICENSE_KEY_DEADLINE_ENUM
* {
*    LIC_LICENSE_KEY_DEADLINE_PERMANENT,
*    LIC_LICENSE_KEY_DEADLINE_FIXED,
*    LIC_LICENSE_KEY_DEADLINE_MIXED,
*    LIC_LICENSE_KEY_DEADLINE_BUTT
* } LIC_LICENSE_KEY_DEADLINE_ENUM;
* @endcode
*
* @dataenum LIC_LICENSE_KEY_DEADLINE_PERMANENT Specifies that all features
* in the LK have no expiry
* @dataenum LIC_LICENSE_KEY_DEADLINE_FIXED Specifies that all features in the LK
* have fixed deadline
* @dataenum LIC_LICENSE_KEY_DEADLINE_MIXED Specifies that some features in the
* LK have fixed deadline and some features have permanent deadline
* @dataenum LIC_LICENSE_KEY_DEADLINE_BUTT Specifies invalid type
*/
/* Classification of LK based on dead line */
typedef enum TAG_LIC_LICENSE_KEY_DEADLINE_ENUM
{
    /* All features have permanent deadline */
    LIC_LICENSE_KEY_DEADLINE_PERMANENT,

    /* All Features have fixed dealine */
    LIC_LICENSE_KEY_DEADLINE_FIXED,

    /* Some Features have permanent and rest features have fixed deadline */
    LIC_LICENSE_KEY_DEADLINE_MIXED,

    /* Unused */
    LIC_LICENSE_KEY_DEADLINE_BUTT
    
} LIC_LICENSE_KEY_DEADLINE_ENUM;

/**
* @defgroup LIC_LICENSE_KEY_POLICY_ENUM
* @ingroup OtherDatastructures
* @code
* typedef enum TAG_LIC_LICENSE_KEY_POLICY_ENUM
* {
*    LIC_LICENSE_KEY_POLICY_TRIAL,
*    LIC_LICENSE_KEY_POLICY_NORMAL,
*    LIC_LICENSE_KEY_POLICY_BUTT
* } LIC_LICENSE_KEY_POLICY_ENUM;
* @endcode
*
* @dataenum LIC_LICENSE_KEY_POLICY_TRIAL Specifies that there exists at least
* one feature in the LK with the name "Trial0"
* @dataenum LIC_LICENSE_KEY_POLICY_NORMAL Specifies no special policy type is
* present in the LK
* @dataenum LIC_LICENSE_KEY_POLICY_BUTT Specifies invalid LK policy
*/
/* Classification of LK as per policy */
typedef enum TAG_LIC_LICENSE_KEY_POLICY_ENUM
{
    /* Trial LK, if any one feature name starts with Trial */
    LIC_LICENSE_KEY_POLICY_TRIAL = 2,

    /* If its is neither PEAK, TRUST and with no feature start with TRIAL */
    LIC_LICENSE_KEY_POLICY_NORMAL,

    /* Unused */
    LIC_LICENSE_KEY_POLICY_BUTT
} LIC_LICENSE_KEY_POLICY_ENUM;


/**
*  LIC_LK_LOCKMODEL_ENUM
*
*  LIC_LK_LOCKMODEL_NODELOCK Specifies that the Esn node locked Commercial
*  LIC_LK_LOCKMODEL_DUALLOCK Specifies that the Esn dual node locked Demo(Commissioning)
*  LIC_LK_LOCKMODEL_BUTT Specifies invalid lock model
*/
/* Classification of LK lock model.*/
typedef enum TAG_LIC_LK_LOCKMODEL_ENUM
{
    /* node lock model */
    LIC_LK_LOCKMODEL_NODELOCK,

    /* dual lock model */
    LIC_LK_LOCKMODEL_DUALLOCK,

    /* Unused */
    LIC_LK_LOCKMODEL_BUTT
    
} LIC_LK_LOCKMODEL_ENUM;


/**
*  LIC_OPERATION_MODE_ENUM
*
*  LIC_STANDALONE Standalone type
*  LIC_NETWORK Network type
*  LIC_OP_MODE_BUTT Not used
*/
/* License Manager operation Mode */
typedef enum TAG_LIC_OPERATION_MODE_ENUM
{
    LIC_STANDALONE = 1,     /* Standalone type*/
    LIC_NETWORK,        /* Network type */

    LIC_OP_MODE_BUTT

}LIC_OPERATION_MODE_ENUM;


/**
*  LIC_ALARM_LIST_ENUM
*
*
*  LIC_ALARM_LK_GRACE_PERIOD This alarm specifies that NE is in GracePeriod
* state
*  LIC_ALARM_LK_DEFAULT This alarm specifies that NE is in deafault
* state
*  LIC_ALARM_FEATURE_GRACE_PERIOD This alarm specifies that feature is in
* grace period
*  LIC_ALARM_FEATURE_DEFAULT This alarm specifies that NE is in default
*  LIC_ALARM_LK_EMERGENCY_START This alarm specifies that emergency
* is started
*  LIC_ALARM_LK_EMERGENCY_STOP This alarm specifies that emergency
* is stopped
*  LIC_ALARM_LIST_BUTT Not used
*/
typedef enum TAG_LIC_ALARM_LIST_ENUM
{
    /* LK goes to GracePeriod alarm */
    LIC_ALARM_LK_GRACE_PERIOD = 1,

    /* LK goes to default alarm */
    LIC_ALARM_LK_DEFAULT,

    /* Feature goes to GracePeriod */
    LIC_ALARM_FEATURE_GRACE_PERIOD,

    /* Feature goes to default */
    LIC_ALARM_FEATURE_DEFAULT,

    /* LK info alarms */
    /* Emergency started */
    LIC_ALARM_LK_EMERGENCY_START = 101,

    /* Emergency Stopped */
    LIC_ALARM_LK_EMERGENCY_STOP,

    LIC_ALARM_LIST_BUTT
}LIC_ALARM_LIST_ENUM;

/**
*  LIC_ALARM_TYPE_ENUM
*
*  LIC_ALARM_TYPE_FAULT Specifies the fault alarm type
*  LIC_ALARM_TYPE_RECOVERY Specifies the recovery alarm type
*  LIC_ALARM_TYPE_INFO Specifies the information alarm type
*  LIC_ALARM_TYPE_BUTT Not Used
*/
typedef enum TAG_LIC_ALARM_TYPE_ENUM
{
    /* Fault alarm type */
    LIC_ALARM_TYPE_FAULT = 1,

    /* Recovery alarm type */
    LIC_ALARM_TYPE_RECOVERY,

    /* Info alarm type */
    LIC_ALARM_TYPE_INFO,

    LIC_ALARM_TYPE_BUTT
}LIC_ALARM_TYPE_ENUM;

/* Inherent item using state. */
typedef enum TAG_LIC_INHERENT_ITEM_STATE_ENUM
{
    /* B钥匙控制项为未使用状态 */
    LIC_INHERENT_ITEM_UNUSED_STATE = 1,

    /* B钥匙控制项为使用状态 */
    LIC_INHERENT_ITEM_USING_STATE,

    /* B钥匙控制项为使用过状态 */
    LIC_INHERENT_ITEM_USED_STATE,

    LIC_INHERENT_ITEM_ERROR_TAB

} LIC_INHERENT_ITEM_STATE_ENUM;

/* Sbom in current license or in new license flag. */
typedef enum TAG_LIC_SBOM_IN_FILE_ENUM
{
    /* Only in the current license file. */
    LIC_SBOM_IN_CURRENT_LICENSE = 1,
    
    /* Only in the new license file. */
    LIC_SBOM_IN_NEW_LICENSE,
    
    /* Both in the new license file and current license file. */
    LIC_SBOM_IN_CURRENT_NEW_LICENSE,

    /* reserve */
    LIC_SBOM_IN_LICENSE_BUTT
} LIC_SBOM_IN_FILE_ENUM;

#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif

#endif /* __LIC_DEFINE_H__ */

