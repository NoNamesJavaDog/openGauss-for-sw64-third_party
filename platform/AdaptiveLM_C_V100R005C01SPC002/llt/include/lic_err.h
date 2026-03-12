/******************************************************************************
 lic_err.h
 Copyright (C), 2006-2010, Huawei Tech. Co., Ltd.
 Description   : Header file for LK reporsitory
 History       :
 <version> <date>     <Author> <Description>
 01a       2009-06-23  v70993   Initial file
******************************************************************************/

#ifndef __LIC_ERROR_H__
#define __LIC_ERROR_H__

#ifdef __cplusplus
#if __cplusplus
extern "C"{
#endif /*ifdef __cplusplus */
#endif /*if __cplusplus*/


/* Enum for License File minor error */
typedef enum TAG_LIC_LK_MINOR_ERROR_ENUM
{
    LIC_ERR_LK_ESN_MISMATCH = (1 << 0),
    LIC_ERR_LK_VERSION_MISMATCH = (1 << 1),
    LIC_ERR_LK_ITEM_DEADLINE_OVER = (1 << 2),
    LIC_ERR_LK_ITEM_TRIAL_OVER = (1 << 3),
    LIC_ERR_LK_ITEM_DEADLINE_LESSER = (1 << 4),
    LIC_ERR_LK_ITEM_VALUE_LESSER = (1 << 5),
    LIC_ERR_LK_ITEM_NOT_PRESENT = (1 << 6),
    LIC_ERR_LK_ITEM_CONFIG_MORE = (1 << 7),
    LIC_ERR_LK_ITEM_USED_MORE = (1 << 8),
    LIC_ERR_LK_FUNC_DFLT_VAL_ENABLED = (1 << 9),
    LIC_ERR_LK_ITEM_DUPLICATE = (1 << 10),
    LIC_ERR_LK_ITEM_LESSER_THAN_DEFAULT = (1 << 11),
    LIC_ERR_LK_ITEM_LESSER_THAN_MINIMUM = (1 << 12),
    LIC_ERR_LK_ITEM_MORE_THAN_MAXIMUM = (1 << 13),
    LIC_ERR_LK_LSN_SMALLER = (1 << 17),
    LIC_ERR_ITEM_FEAT_TRIAL_OVER = (1 << 18),
    LIC_ERR_ITEM_FEAT_DEADLINE_OVER = (1 << 19),
    LIC_ERR_STICK_ITEM_NOT_FOUND = (1<<20),
    LIC_ERR_LK_MINOR_ERR_BUTT
} LIC_LK_MINOR_ERROR_ENUM;


#define LIC_ERR_BASE 0x78000000

/* Enum for Error codes */
typedef enum TAG_LIC_ERR_ENUM
{
    /* OS Errors */

    /* Memory allocation failed */
    LIC_ERR_MEM_ALLOC_FAIL = (LIC_ERR_BASE | 0x01),

    /* Mutex creation failed */
    LIC_ERR_SM_CREATE_FAIL = (LIC_ERR_BASE | 0x02),

    /* Mutex deletion failed */
    LIC_ERR_SM_DELETE_FAIL = (LIC_ERR_BASE | 0x03),

    /* Acquiring mutex failed */
    LIC_ERR_SM_P_FAIL = (LIC_ERR_BASE | 0x04),

    /* Releasing mutex failed */
    LIC_ERR_SM_V_FAIL = (LIC_ERR_BASE | 0x05),

    /* Error in getting system date and time */
    LIC_ERR_GET_SYSDATE = (LIC_ERR_BASE | 0x06),

    /* Timer start failed */
    LIC_ERR_TIMER_START_FAIL = (LIC_ERR_BASE | 0x07),

    /* Timer stop failed */
    LIC_ERR_TIMER_STOP_FAIL = (LIC_ERR_BASE | 0x08),

    /* Common errors */
    /* Invalid para */
    LIC_ERR_INVALID_PARA = (LIC_ERR_BASE | 0x10),

    /* Null pointer error */
    LIC_ERR_NULL_PTR = (LIC_ERR_BASE | 0x11),

    /* Mem interfaces not registered */
    LIC_ERR_MEM_INTF_NOT_REG = (LIC_ERR_BASE | 0x12),

    /* Timer interfaces not registered */
    LIC_ERR_TIMER_INTF_NOT_REG = (LIC_ERR_BASE | 0x13),

    /* Kernel interfaces not registered */
    LIC_ERR_KERNEL_INTF_NOT_REG = (LIC_ERR_BASE | 0x15),

    /* Manager specific interfaces for io-read or io-write operations are
    not registered */
    LIC_ERR_MANAGER_SPEC_INTF_NOT_REG = (LIC_ERR_BASE | 0x16),

    /* Get ESN error: callback not registered or ESN length invalid or ESN
    count invalid */
    LIC_ERR_GET_ESN_ERROR = (LIC_ERR_BASE | 0x1A),

    /* Invalid pointer size for the attribute type */
    LIC_ERR_ATTRIB_LEN = (LIC_ERR_BASE | 0x1D),

    /* Error codes for registeration static info APIs */
    
    /* item type is invalid */
    LIC_ERR_ITEM_TYPE_INVALID = (LIC_ERR_BASE | 0x25),
    
    /* Resource id is invalid */
    LIC_ERR_RES_ID_INVALID = (LIC_ERR_BASE | 0x26),

    /* Resource type error */
    LIC_ERR_RES_TYPE_ERROR = (LIC_ERR_BASE | 0x27),

    /* Resource id duplicate */
    LIC_ERR_RES_ID_DUPLICATE = (LIC_ERR_BASE | 0x2A),

    /* Resource name length error */
    LIC_ERR_RES_NAME_LEN_ERROR = (LIC_ERR_BASE | 0x2B),

    /* Resource name error */
    LIC_ERR_RES_NAME_ERROR = (LIC_ERR_BASE | 0x2C),

    /* Resource name duplicate */
    LIC_ERR_RES_NAME_DUPLICATE = (LIC_ERR_BASE | 0x2D),

    /* Resource description length error */
    LIC_ERR_RES_DESC_LEN_ERROR = (LIC_ERR_BASE | 0x2E),

    /* Function id is invalid */
    LIC_ERR_FUN_ID_INVALID = (LIC_ERR_BASE | 0x31),

    /* Invalid function type */
    LIC_ERR_FUN_TYPE_ERROR = (LIC_ERR_BASE | 0x32),

    /* Function id duplicate */
    LIC_ERR_FUN_ID_DUPLICATE = (LIC_ERR_BASE | 0x33),

    /* Function name length invalid */
    LIC_ERR_FUN_NAME_LEN_ERROR = (LIC_ERR_BASE | 0x34),

    /* Function name is invalid */
    LIC_ERR_FUN_NAME_ERROR = (LIC_ERR_BASE | 0x35),

    /* Function name duplicate */
    LIC_ERR_FUN_NAME_DUPLICATE = (LIC_ERR_BASE | 0x36),

    /* Function default value is not 0 or 1 */
    LIC_ERR_FUN_DFLT_VAL_ERROR = (LIC_ERR_BASE | 0x37),

    /* Function description length is bigger than maximum allowed */
    LIC_ERR_FUN_DESC_LEN_ERROR = (LIC_ERR_BASE | 0x38),

    /* The maximum value for a resource item is less than the 
    minimum value or default value*/
    LIC_ERR_RES_MAX_VAL_ERR = (LIC_ERR_BASE | 0x3F),

    /* Control API errors */

    /* The maximum number of emergency allowed is already used up,
    so emergency cannot be started now. */
    LIC_ERR_EMERGENCY_COUNT_OVER = (LIC_ERR_BASE | 0x40),

    /* Emergency start error due to not able to get system time. */
    LIC_ERR_EMERGENCY_STRT_INTERNAL_ERROR = (LIC_ERR_BASE | 0x41),

    /* Emergency is already running. It can be continued only in last
    day of emregency. */
    LIC_ERR_EMERGENCY_RUNNING = (LIC_ERR_BASE | 0x43),

    /* Item name length invalid */
    LIC_ERR_ITEM_NAME_LEN_ERROR = (LIC_ERR_BASE | 0x44),

    /* Item name invalid */
    LIC_ERR_ITEM_NAME_ERROR = (LIC_ERR_BASE | 0x45),

    /* Item ID invalid */
    LIC_ERR_ITEM_ID_ERROR = (LIC_ERR_BASE | 0x46),

    /* Emergency not started because none of the items are registered
    to support emergency */
    LIC_ERR_EMERGENCY_NO_ITEM_IN_EME = (LIC_ERR_BASE | 0x47),

     /* License File Activation errors */

    /* OS system error such as memory or OS call failure */
    LIC_ERR_LK_PARSER_SYSTEM_ERROR = (LIC_ERR_BASE | 0x50),

    /* License file validation failed */
    LIC_ERR_LK_FORMAT_ERROR = (LIC_ERR_BASE | 0x51),

    /* No product features present in License File */
    LIC_ERR_LK_NO_PRD_FEATURES_PRESENT = (LIC_ERR_BASE | 0x52),

    /* License File Product invalid */
    LIC_ERR_LK_PRODUCT_INVALID = (LIC_ERR_BASE | 0x54),

    /* License File expired */
    LIC_ERR_LK_EXPIRED = (LIC_ERR_BASE | 0x55),

    /* Failed to get the item configured value */
    LIC_ERR_LK_GET_CONFIG_ERROR = (LIC_ERR_BASE | 0x56),

    /* This License File is already revoked */
    LIC_ERR_LK_LSN_REVOKED = (LIC_ERR_BASE | 0x58),

    /* License File with ESN or Version mismatch cannot be activated
    repetitively */
    LIC_ERR_LK_REPEATED_ESN_VER_MISMATCH = (LIC_ERR_BASE | 0x59),

    /*
    Different License File of type DEMO(Commissioning) with ESN=ANY and 6
    months validity is not allowed for this version as same type of
    License File has already been activated. Once an License File of this
    type is activated for a version, only this License File is allowed to be
    activated again for the same version. For other License Files
    of this type, activation will fail.
    */
    LIC_ERR_LK_ESNANY_AND_SIX_MON_VLDITY_NOT_ALLOWED = (LIC_ERR_BASE | 0x5A),

    /* Minor errors occurred during activation */
    LIC_ERR_LK_MINOR_ERRORS_IN_ACTIVATION = (LIC_ERR_BASE | 0x5B),

    /* Item present in License File, but not registered with manager */
    LIC_ERR_LK_CTRL_ITEM_NOT_FOUND = (LIC_ERR_BASE | 0x5C),

    /* Generate revoke ticket failed */
    LIC_ERR_LK_GEN_REVOKE_TKT_FAIL = (LIC_ERR_BASE | 0x5D),

    /* Get revoke ticket failed */
    LIC_ERR_LK_GET_REVOKE_TKT_FAIL = (LIC_ERR_BASE | 0x5E),

    /* Current License File is not revoked */
    LIC_ERR_LK_CURRENT_LK_NOT_REVOKED = (LIC_ERR_BASE | 0x60),

    /* lk's LSN doesn't match with the stored ones or No LK available */
    LIC_ERR_LK_REVOKE_NOT_ALLOWED = (LIC_ERR_BASE | 0x61),

    /* Invlaid feature name */
    LIC_ERR_LK_INVALID_FEATURE_NAME = (LIC_ERR_BASE | 0x62),

    /* License File features exceeded max limit of 50 */
    LIC_ERR_LK_MAX_FEATURES_REACHED = (LIC_ERR_BASE | 0x63),

    /* Invalid feature type */
    LIC_ERR_LK_INVALID_FEATURE_TYPE = (LIC_ERR_BASE | 0x65),

    /* Get License File version information error */
    /*C_ERR_LK_GET_VER_INFO_ERROR = (LIC_ERR_BASE | 0x66),*/
    
    /*
    NE state is GracePeriod or Default but no ESN mismatch case,
    revoke can not be done
    */
    LIC_ERR_LK_NOT_ESNMISMATCH = (LIC_ERR_BASE | 0x67),

    /* Insufficient memory allocation */
    LIC_ERR_LK_INSUFF_MEMORY = (LIC_ERR_BASE | 0x68),

    /* Persistent module errors */

    /* Safe memory insufficient */
    LIC_ERR_PS_INSUFFICIENT_SAFE_MEM = (LIC_ERR_BASE | 0x70),

    /* Current License File is not revoked */
    LIC_ERR_PS_NO_REVOKE_TKT = (LIC_ERR_BASE | 0x71),

    /* The current License File is already revoked */
    LIC_ERR_PS_DUPLICATE_LSN = (LIC_ERR_BASE | 0x72),

     /* IO read error */
    LIC_ERR_PS_IO_READ_ERROR = (LIC_ERR_BASE | 0x73),

    /* IO write error */
    LIC_ERR_PS_IO_WRITE_ERROR = (LIC_ERR_BASE | 0x74),

    /* Dynamic memory not sufficient */
    LIC_ERR_PS_INSUFF_DYN_MEM = (LIC_ERR_BASE | 0x75),

    /* Manager initalization error codes  */

    /* LM is not initialized */
    LIC_ERR_LM_NOT_INITIALIZED = (LIC_ERR_BASE | 0x90),

    /* LM already inited */
    LIC_ERR_LM_ALREADY_INITIALIZED = (LIC_ERR_BASE | 0x91),

    /* LM shutdown in progress */
    LIC_ERR_LM_SHUTDOWN_INPROGRESS = (LIC_ERR_BASE | 0x92),

    /* LM is not enabled */
    LIC_ERR_LM_NOT_ENABLED = (LIC_ERR_BASE | 0x93),

    /* LM already enabled */
    LIC_ERR_LM_ALREADY_ENABLED = (LIC_ERR_BASE | 0x94),
    
    /* LM manager mode error */
    LIC_ERR_LM_MANAGER_MODE_ERROR = (LIC_ERR_BASE | 0x96),

    /* LM product name error */
    LIC_ERR_LM_PRODUCT_NAME_ERROR = (LIC_ERR_BASE | 0x98),

    /* LM product version error */
    LIC_ERR_LM_PRODUCT_VER_ERROR = (LIC_ERR_BASE | 0x99),

    /* Either safe memory or License File memory size is null */
    LIC_ERR_LM_MEM_SIZE_ERROR = (LIC_ERR_BASE | 0xA0),

    /* LM callback function id error */
    LIC_ERR_LM_CALLBACK_FUN_ID_ERROR = (LIC_ERR_BASE | 0xA4),

    /* LM resource or function count error */
    LIC_ERR_LM_RESFUNC_COUNT_ERROR = (LIC_ERR_BASE | 0xA6),

    /* LM item count error */
    /*LIC_ERR_LM_ITEM_COUNT_ERROR = (LIC_ERR_BASE | 0xA7),*/

    /* LM sbom count error */
    LIC_ERR_LM_SBOM_COUNT_ERROR = (LIC_ERR_BASE | 0xA8),

    /* LM s2b  count error */
    LIC_ERR_LM_S2BOM_COUNT_ERROR = (LIC_ERR_BASE | 0xA9),

    /* LM product key is not set. */
    LIC_ERR_LM_PRODKEY_NOT_SET = (LIC_ERR_BASE | 0xAA),

    /* LM static config info not registered */
    LIC_ERR_LM_STAT_CONF_INFO_NOT_REG = (LIC_ERR_BASE | 0xAB),

    /* LM Msg init failed */
    /*LIC_ERR_LM_MSG_INIT_FAILED = (LIC_ERR_BASE | 0xAC),*/

    /* Input Product key CRC check error */
    LIC_ERR_LM_PRODKEY_CRC_MISMATCH = (LIC_ERR_BASE | 0xB1),

    /* Product name in key is not same with init value */
    LIC_ERR_LM_PROD_NAME_MISMATCH = (LIC_ERR_BASE | 0xB2),

    /* Version name in key is not same with init value */
    LIC_ERR_LM_VER_NAME_MISMATCH = (LIC_ERR_BASE | 0xB3),

    /* Getting License File repository feature pointer failed */
    LIC_ERR_GETALLFEATURE_LK_REPOSITORY = (LIC_ERR_BASE | 0xD1),

    /* Getting License File resource information failed */
    LIC_ERR_GETRES_LK_INFO_ERR = (LIC_ERR_BASE | 0xD2),

    /* Getting License File function information failed */
    LIC_ERR_GETFUN_LK_INFO_ERR = (LIC_ERR_BASE | 0xD3),

    /* Getting resource control info failed */
    LIC_ERR_GETRES_CTRL_INFO_ERR = (LIC_ERR_BASE | 0xD4),

    /* Getting function control info failed */
    LIC_ERR_GETFUN_CTRL_INFO_ERR = (LIC_ERR_BASE | 0xD5),

    /* Duplicate item is found */
    LIC_ERR_DUP_ITEM_FOUND = (LIC_ERR_BASE | 0xD8),

    /* Item name and item ID do not match */
    LIC_ERR_ITEM_NAME_ITEM_ID_MISMATCH = (LIC_ERR_BASE | 0xFA),

    /* No items are registered in the system */
    LIC_ERR_NO_ITEMS_REGD = (LIC_ERR_BASE | 0x104),

    /* Item Id not configured */
    LIC_ERR_ITEM_ID_NOT_CONFIGURED = (LIC_ERR_BASE | 0x110),

    /* Currently no License File is activated */
    LIC_ERR_NO_LK_ACTIVATED = (LIC_ERR_BASE | 0x11A),

    /* All the features in License File are either expired or in
    grace period */
    LIC_ERR_NO_FEATURES_IN_NORMAL_STATE = (LIC_ERR_BASE | 0x13A),

    /* License File Trial Alarm interval error  */
    LIC_ERR_LK_TRIAL_ALARM_INTERVAL_ERROR = (LIC_ERR_BASE | 0x13B),

    /* License File No Permanence features Exist*/
    LIC_ERR_LK_NO_PERM_FEATURE_EXIST = (LIC_ERR_BASE | 0x13C),

    /* Operation failed due to ESN mismatch or Version mismatch error
    in License File activation */
    LIC_ERR_ESN_OR_VER_MISMATCH = (LIC_ERR_BASE | 0x136),

    /* ALM not disabled */
    LIC_ERR_LM_NOT_DISABLED = (LIC_ERR_BASE | 0x140),

    /* Emergency not running */
    LIC_ERR_EMERGENCY_NOT_RUNNING = (LIC_ERR_BASE | 0x141),

    /* Stop emergency failed */
    LIC_ERR_STOP_EMERGENCY_FAILED = (LIC_ERR_BASE | 0x142),

    /* Not register SBOM  */
    LIC_ERR_LM_SBOM_INFO_NOT_SUPPORT = (LIC_ERR_BASE | 0x143),

    /* The offering input not exist */
    LIC_ERR_LM_INPUT_OFFERING_NOT_EXIST = (LIC_ERR_BASE | 0x144),

    /* The offering or sbom input not exist */
    LIC_ERR_INPUT_OFFERING_OR_SBOM_NOT_EXIT = (LIC_ERR_BASE | 0x145),

    /* There is no offering */
    LIC_ERR_LM_NO_OFFERING_EXIST = (LIC_ERR_BASE | 0x146),

    /* There is no SBOM to BBOM information for input sbom */
    LIC_ERR_LM_NO_STOBBOM_INFO_EXIST = (LIC_ERR_BASE | 0x147),

    /* The License LibVer not support */
    LIC_ERR_LK_LIBVER_NOT_SUPPORT = (LIC_ERR_BASE | 0x150),

    /* Verify Sign Error Code */
    LIC_ERR_LK_SIGN_VERIFY_FAIL = (LIC_ERR_BASE | 0x151),

    /* OfferingProduct count over max count: 10 */
    LIC_ERR_LK_OVER_MAX_OFFERING_CNT = (LIC_ERR_BASE | 0x152),

    /* SBOM count over max count */
    LIC_ERR_LK_OVER_MAX_SBOM_CNT = (LIC_ERR_BASE | 0x153),

    /* BBOM count over max count */
    LIC_ERR_LK_OVER_MAX_S2BOM_CNT = (LIC_ERR_BASE | 0x154),

    /* The product name and version not set yet */
    LIC_ERR_PROD_VER_NOT_SET = (LIC_ERR_BASE | 0x155),

    /* Trial Feature number over max count (0~9) */
    LIC_ERR_LK_OVER_MAX_TRAIL_FEAT_CNT = (LIC_ERR_BASE | 0x156),

    /* Convert to feature error */
    LIC_ERR_LK_CONVERT_FEATURE_ERR = (LIC_ERR_BASE | 0x157),

    /* Item default value less than Min value Or more than Max value*/
    LIC_ERR_ITEM_DEFAULT_VAL_INVALID = (LIC_ERR_BASE | 0x158),

    /* 设置Item最大重复个数范围错误 */
    LIC_ERR_ITEM_REPEAT_VAL_ERROR = (LIC_ERR_BASE | 0x159),

    /* 临时文件已经过期 */
    LIC_ERR_IS_OVERDUE = (LIC_ERR_BASE | 0x160),

    /* 安装文件的系统时间错误 */
    LIC_ERR_SYSTIME_ERROR = (LIC_ERR_BASE | 0x161),
    
    /* 该文件已经出现过ESN不匹配，不能再次安装 */
    LIC_ERR_ESN_MISMATCH_ALREADY_DONE = (LIC_ERR_BASE | 0x162),   

    /*设置的软件发布日期时间格式错误 */
    LIC_ERR_SYSTIME_FORMAT_ERROR = (LIC_ERR_BASE | 0x163),

    /* B钥匙Alarm interval超出范围  */
    LIC_ERR_INHERENT_ALARM_INTERVAL_ERROR = (LIC_ERR_BASE | 0x164),

    /* 设置B钥匙控制项试用天数超出范围  */
    LIC_ERR_INHERENT_USING_DAYS_ERROR = (LIC_ERR_BASE | 0x165),

    /* 设置B钥匙控制项数量超过最大值或注册的功能项个数  */
    LIC_ERR_INHERENT_ITEM_NUM_ERROR = (LIC_ERR_BASE | 0x166),

    /* 启动B钥匙试用失败，该控制项不支持试用 */
    LIC_ERR_START_INHERENT_ITEM_NOT_SUPPORT = (LIC_ERR_BASE | 0x167),

    /* 启动B钥匙试用失败，该控制项已经购买 */
    LIC_ERR_START_INHERENT_ITEM_ALREADY_IN_LK = (LIC_ERR_BASE | 0x168),
    
    /* 启动B钥匙试用失败，试用控制项正在试用或已经试用过*/
    LIC_ERR_START_INHERENT_ITEM_ALREADY_USED = (LIC_ERR_BASE | 0x169),

    /* B钥匙试用功能项未注册 */
    LIC_ERR_INHERENT_FUNC_NOT_REG = (LIC_ERR_BASE | 0x170),

    /* 停止B钥匙试用失败，试用控制项未启动试用 */
    LIC_ERR_STOP_INHERENT_ITEM_NOT_USING = (LIC_ERR_BASE | 0x171),

    /* 启动B钥匙试用失败，试用控制项超过最大数量 */
    LIC_ERR_START_INHERENT_ITEM_OVER_MAXNUM = (LIC_ERR_BASE | 0x172),
    
    /* Hourly timeout value invalid */
    LIC_ERR_HOURLY_TIMEOUT_VAL_ERROR = (LIC_ERR_BASE | 0x173),
    
    /* 没有启用stick功能，应该在enable前配置支持stick的控制项 */
    LIC_ERR_STICK_NOT_SUPPORT = (LIC_ERR_BASE | 0x174),

    /* stick已经启动了 */
    LIC_ERR_STICK_IS_RUNNING = (LIC_ERR_BASE | 0x175),

    /* stick没有启动 */
    LIC_ERR_STICK_NOT_RUNNING = (LIC_ERR_BASE | 0x176),

    /* stick启动次数已经耗光 */
    LIC_ERR_STICK_COUNT_OVER = (LIC_ERR_BASE | 0x177),

    /* 启动stick前已经安装了License文件 */
    LIC_ERR_STICK_START_IN_LK = (LIC_ERR_BASE | 0x178),

    /* 传入的次要错误ID集合中存在不支持屏蔽的ID */
    LIC_ERR_MINI_ERR_ID_NOT_SUPPORT = (LIC_ERR_BASE | 0x179),

    /* 未开启ESN=ANY取消安装次数功能时进行查询ESN=ANY的信息 */
    LIC_ERR_CLOSE_ESN_ANY_NOT_SUPPORT = (LIC_ERR_BASE | 0x180),

    /* 激活License时，当前ESN=ANY的有效天数小于已运行的天数 */
    LIC_ERR_LK_ESN_ANY_USE_DAY_LESSER = (LIC_ERR_BASE | 0x181),

    /* ESN=ANY的有效天数已经使用完毕 */
    LIC_ERR_LK_ESN_ANY_USE_DAY_OVER = (LIC_ERR_BASE | 0x182),

    /* 校验Sbom中返回license 文件为2.0 格式*/
    LIC_ERR_VERIFY_CONTAIN_DAT_FILE =(LIC_ERR_BASE | 0x183),

    /* Unknown */
    LIC_ERROR_BUTT

}LIC_ERR_ENUM;

#ifdef __cplusplus
#if __cplusplus
}
#endif /*ifdef __cplusplus */
#endif /*if __cplusplus*/

#endif /* __LIC_ERROR_H__ */

