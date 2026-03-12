/*******************************************************************************
  Copyright (C), 2011, Huawei Tech.Co., Ltd.
  Description    : Header file contains manager maintain interfaces
  FileName       : lic_managermnt_itf.h
  History        :
  <version> <date>     <Author> <Description>
  01a,2009-06-30,n70141 Initial file.
  02,2010-06-14,m72276, Supporting Peak and Trust licensing policy. The
                        following new interfaces are added.
                        ALM_CompareLicenseKey()

                        Callbacks added:
                        ALM_CALLBACK_LICENSE_POLICY_EVENT_NOTIFY
*******************************************************************************/


#ifndef __LIC_MANAGERMNT_ITF_H__
#define __LIC_MANAGERMNT_ITF_H__

#include "lic_base.h"

#ifdef __cplusplus
#if __cplusplus
extern "C" {
#endif /* __cpluscplus */
#endif /* __cpluscplus */


/**
*  LIC_ITEM_COMPARE_RESULT_STRU
*
*  ulItemId   Item ID. The range is [1-LIC_NULL_LONG]
*  acItemName Specifies item name
*  ulItemType Specifies item type. Refer LIC_CONTROLTYPE_ENUM
*  ulResUnitType Specifies item sub-type.Refer LIC_RES_UNIT_TYPE_ENUM
*  ulCurrentLKValue Specifies the current License item LK value.
*  ulNewLKValue Specifies the new License item LK value.
*  ulItemConfigValue Specifies config value for the item.
*  ulItemUsedValue Specifies used value for the item.
*/
typedef struct TAG_LIC_ITEM_COMPARE_RESULT_STRU
{
    /* Defines the Item ID registered against the LK item name in the system.
       If suppose the LK item is not present in the system then item Id will 0
    */
    LIC_ULONG          ulItemID;

    /* Item name */
    LIC_CHAR           acItemName[LIC_ITEM_NAME_MAX_LEN + 8];

    /* Item type: LIC_CONTROLTYPE_ENUM */
    LIC_ULONG          ulItemType;

    /* Defines the resource type. Refer enum LIC_RES_UNIT_TYPE_ENUM for
       different resource types.
       This field will not be applicable for Function items
    */
    LIC_ULONG          ulResUnitType;

    /* Old LK value for this Item. */
    LIC_ULONG          ulCurrentLKValue;

    /* New LK value */
    LIC_ULONG          ulNewLKValue;

    /* Config value */
    LIC_ULONG          ulItemConfigValue;

    /* used value */
    LIC_ULONG          ulItemUsedValue;
} LIC_ITEM_COMPARE_RESULT_STRU;

typedef struct TAG_LIC_SBOM_COMPARE_RESULT_STRU
{
    /* SBOM value in the current actived license. Contains perm value and temp 
    value. */
    LIC_ULONG  ulSbomCurrentVal;

    /* SBOM value in the new license. Contains perm value and temp 
    value. */
    LIC_ULONG  ulSbomNewVal;

    /* SBOM in the current license or in the new license. refer 
    LIC_SBOM_IN_FILE_ENUM */
    LIC_ULONG  ulSbomInFile;
    
    /* SBOM name in the new license. */
    LIC_CHAR   acSbomName[LIC_ITEM_NAME_MAX_LEN + 8];

    /* SBOM Chinese unit description */
    LIC_CHAR   acSbomChsUnit[LIC_ITEM_UNIT_MAX_LEN + 8];

    /* SBOM English unit description */
    LIC_CHAR   acSbomEngUnit[LIC_ITEM_UNIT_MAX_LEN + 8];
} LIC_SBOM_COMPARE_RESULT_STRU;


/**
*  LIC_LK_COMPARE_STRU
*
*  ulItemCount  Number of items in new license.
*  ulMinorError Specifies the LK minor errors
*  pstItemResult Specifies result for each item in the License.
*/
/* Provides the output for comparison of LK */
typedef struct TAG_LIC_LK_COMPARE_STRU
{
    /* Item Count */
    LIC_ULONG ulItemCount;
    
    /* Minor error for LK while parsing. */
    LIC_ULONG ulMinorError;

    /* Item Compare result struct */
    LIC_ITEM_COMPARE_RESULT_STRU *pstItemResult;

} LIC_LK_COMPARE_STRU;

/** SBOM compare result struct */
typedef struct TAG_LIC_SBOM_COMPARE_STRU
{
    /* Total Sbom Count, Contains current license and new license. 
     * Prem and Temp is only one */
    LIC_ULONG ulSbomCount;

    /* Sbom Compare result struct */
    LIC_SBOM_COMPARE_RESULT_STRU *pstSbomResult; 

} LIC_SBOM_COMPARE_STRU;

/**
*  LIC_ITEM_VALUE_STRU
*
*  ulItemID Specifies item ID. The range is [1-LIC_NULL_LONG]
*  acItemName Specifies item name
*  ulItemType Specifies item type: LIC_CONTROLTYPE_ENUM
*  ulItemLKVal Specifies License item LK value.
*  ulItemConfigVal Specifies License item value from
*       ALM_CALLBACK_GET_CONFIG callback. If the callback is not
*       registered or callback returns error, its value will be LIC_NULL_LONG
*  ulItemUsedVal Specifies License total used information
*  ulMaxValueInLife Specifies item value used for evaluating
*   the required license for GTS tool. If pfnGetEvalVal is given as
*   not null in LIC_STATIC_RESOURCE_INFO_STRU/LIC_STATIC_FUNCTION_INFO_STRU,
*   then callback provided value will be given. If the callback is null
*   for the item, then it will be maximum value reached since the time
*   system is running
*  ulItemCurrentCtrlVal Specifies current control value of item.
*  stDependentItems Specifies the list of dependent Ids associated
*   with the item
*/
typedef struct  TAG_LIC_ITEM_VALUE_STRU
{
    /* Item ID */
    LIC_ULONG ulItemID;

    /* Item name */
    LIC_CHAR   acItemName[LIC_ITEM_NAME_MAX_LEN + 8];

    /* Item description */
    LIC_CHAR    acItemDesc[LIC_ITEM_DESC_MAX_LEN + 8];

    /* Item type: LIC_CONTROLTYPE_ENUM */
    LIC_ULONG ulItemType;

    /* License item value from ALM_CALLBACK_GET_CONFIG callback */
    LIC_ULONG ulItemConfigVal;

    /* License total used information */
    LIC_ULONG ulItemUsedVal;

    /* Current control value of item */
    LIC_ULONG ulItemCurrentCtrlVal;

    /* Current permanent value of item */
    LIC_ULONG ulItemCurrentPermVal;

    /* Current temp value of item */
    LIC_ULONG ulItemCurrentTempVal;
    
    /* default value registered */
    LIC_ULONG ulDefaultVal;
    
    /* max value registered */
    LIC_ULONG ulMaxVal;

    /* min value registered */
    LIC_ULONG ulMinVal;

    /* State of each items as per the enum
    defined LIC_LK_ITEM_STATE_ENUM */
    LIC_ULONG              ulCurrentState;

} LIC_ITEM_VALUE_STRU;


/**
*  LIC_ITEM_RESULT_STRU
*
*  ulItemErrorCode LK result Info for minor errors
*  acItemName Specifies item name
*  ulItemValue Current Item Value
*  ulItemType Specifies item type: LIC_CONTROLTYPE_ENUM
*  acSwDeadline Specifies deadline. It is equal to higher
*   if item belongs to more than 1 feature
*  ulTrialDays Specifies grace period days
*  ulItemID Specifies item ID
*/
typedef struct TAG_LIC_ITEM_RESULT_STRU
{
    /* Item specific minor errors */
    LIC_ULONG          ulItemErrorCode;

    /* Item name */
    LIC_CHAR            acItemName[LIC_ITEM_NAME_MAX_LEN + 8];

    /* Resource or Function value (as per the feature) */
    LIC_ULONG          ulItemValue;

    /* Item type: LIC_CONTROLTYPE_ENUM */
    LIC_ULONG          ulItemType;

    /* Deadline */
    LIC_CHAR            acSwDeadline[LIC_TIME_MAX_LEN];

    /* Item ID*/
    LIC_ULONG          ulItemID;
}LIC_ITEM_RESULT_STRU;

/**
*  LIC_VERIFY_RESULT_STRU
*
*  ulLKErrorCode LK Error Code
*  acPrdName Prd name as in LK
*  acPrdVer Prd version as in LK
*  acLKEsn ESN as in LK
*  acLKLSN LK Serial number
*  ulItemCount Item Buffer len
*     Output: Filled Item Buffer len
*  pstItemResult Minimum errors for items list
*/
typedef struct  TAG_LIC_VERIFY_RESULT_STRU
{
    /* LK Error Code */
    LIC_ULONG      ulLKErrorCode;

    /* grace period days */
    LIC_ULONG      ulGraceDays;

    /* Prd name as in LK */
    LIC_CHAR        acPrdName[LIC_PRDNAME_MAX_LEN + 8];

    /* Prd version as in LK */
    LIC_CHAR        acPrdVer[LIC_PRDVER_MAX_LEN + 8];

    /* ESN as in LK */
    LIC_CHAR        acLKEsn[LIC_LONG_STREAM_LEN];

    /* LK Serial number */
    LIC_CHAR        acLKLSN[LIC_LKSRNO_MAX_LEN];

    /*
    Input: Item Buffer len
    Output: Filled Item Buffer len
    */
    LIC_ULONG       ulItemCount;


    LIC_ITEM_RESULT_STRU *pstItemResult;

} LIC_VERIFY_RESULT_STRU;


typedef struct  TAG_LIC_LK_GENERALINFO_STRU
{
    /* File copyright */
    LIC_CHAR    acFileCopyRight[LIC_SHORT_STREAM_LEN];
    
    /* File format version */
    LIC_CHAR    acFileFormatVersion[LIC_MINI_STREAM_LEN];

    /* File creator */
    LIC_CHAR    acFileCreator[LIC_SHORT_STREAM_LEN];

    /* File createtime */
    LIC_CHAR    acFileCreateTime[LIC_MINI_STREAM_LEN];

    /* File issuer */
    LIC_CHAR    acFileIssuer[LIC_SHORT_STREAM_LEN];

    /* File mentioned product */
    LIC_CHAR    acFileProduct[LIC_PRDNAME_MAX_LEN + 8];

    /* File mentioned version */
    LIC_CHAR    acFilePrdVersion[LIC_PRDVER_MAX_LEN + 8];
       
    /* File LSN */
    LIC_CHAR    acFileSN[LIC_LKSRNO_MAX_LEN];

    /* File type */
    LIC_ULONG ulLkType;

    /* File graceday */
    LIC_ULONG ulLkGraceDay;

    /* SwUpgradeDueDate */
    LIC_CHAR acSwUpgradeDueDate[LIC_MINI_STREAM_LEN];
    
} LIC_LK_GENERALINFO_STRU;


typedef struct  TAG_LIC_LK_CUSTOMERINFO_STRU
{
    /* File country*/
    LIC_CHAR    acFileCountry[LIC_SHORT_STREAM_LEN];

    /* File mentioned customer */
    LIC_CHAR    acFileCustom[LIC_CUSTOMER_NAME_MAX_LEN + 8];

    /* File mentioned Office */
    LIC_CHAR    acFileOffice[LIC_SHORT_STREAM_LEN];
    
} LIC_LK_CUSTOMERINFO_STRU;


typedef struct  TAG_LIC_LK_NODEINFO_STRU
{
    /* File sequence number in the node */
    LIC_ULONG ulLkNodeSequense;

    /* File lock model */
    LIC_ULONG ulLkLockModel;
    
     /* File mentioned node name */
    LIC_CHAR    acFileNodeName[LIC_MINI_STREAM_LEN]; 

    /* File node description */
    LIC_CHAR    acFileNodeDes[LIC_SHORT_STREAM_LEN];

    /* File ESN */
    LIC_CHAR    acFileEsn[LIC_LONG_STREAM_LEN];

    /* Soft id */
    LIC_CHAR acSoftId[LIC_SOFT_ID_LEN + 8];
} LIC_LK_NODEINFO_STRU;

/**
*  LIC_LICENSE_KEYINFO_STRU
*
*  acFileSN Specifies file LSN
*  acFileCreator Specifies file creator
*  acFileCreateTime Specifies file creation time
*  acFileCountry Specifies file country
*  acFileCustom Specifies file mentioned customer
*  acFileOffice Specifies file mentioned Office
*  acFileProduct Specifies file mentioned product
*  acFilePrdVersion Specifies file mentioned version
*  acFileEsn Specifies file ESN
*/
/* License Key Info structure */
typedef struct  TAG_LIC_LICENSE_KEYINFO_STRU
{
    /* File general info */
    LIC_LK_GENERALINFO_STRU    stLkGeneralInfo;

    /* File customer info */
    LIC_LK_CUSTOMERINFO_STRU    stLkCustomerInfo;

    /* File node info */
    LIC_LK_NODEINFO_STRU    stLkNodeInfo;

    /* Revoke ticket info if the lk been revoked */
    LIC_REVOKETICKET_STRU stRevokeTicket;

    /* Whether lk is revoked or not*/
    LIC_BOOL bBeRevoked;
    
} LIC_LICENSE_KEYINFO_STRU;


typedef struct TAG_LIC_EMERGENCY_INFO_STRU
{
    /* Whether Emergency is running or not */
    LIC_BOOL  bEmergencyRunning;

    /* 免费紧急的剩余次数*/
    LIC_ULONG ulEmergencyRemainCount;

    /* No. of days Emergency remain */
    LIC_ULONG ulEmergencyRemainDays;

    /* 可使用的紧急总数，免费+ 购买 */
    LIC_ULONG ulEmergencyTotalCount;

    /*已经使用的总次数，免费+ 客户购买 */
    LIC_ULONG ulEmergencyUseCount;

    /* Emergency start time */
    LIC_CHAR  acStartTime[LIC_TIME_MAX_LEN];

    /* Emergency runing item count */
    LIC_ULONG ulItemCount;

    /* Emergency runing items */
    LIC_ITEM_INFO_STRU    *pstItemInfo;

} LIC_EMERGENCY_INFO_STRU;


/**
*  LIC_LICENSE_KEYITEMINFO_STRU
*
*  ulItemId   Item ID. The range is [1-LIC_NULL_LONG]
*  acItemName Specifies item name
*  acItemDesc Specifies item description
*  ulItemLKVal Specifies item value as per feature from
* License file information
*  ulItemMaxVal Specifies Hard Maximum limit for the item
*  ulItemMinmVal Specifies minimum value for the item
*  ulItemType Item type: LIC_CONTROLTYPE_ENUM
*  acFeatureName Specifies feature name
*  acSwDeadline Specifies deadline
*  ulTrialDays Specifies grace period days
*  ulCurrentState Specifies state of each item as per the enum
* defined in LIC_LK_ITEM_STATE_ENUM
*/
/* License Key Item Info structure */
typedef struct  TAG_LIC_LICENSE_KEYITEMINFO_STRU
{
    /* Item ID */
    LIC_ULONG              ulItemId;

    /* Item name */
    LIC_CHAR               acItemName[LIC_ITEM_NAME_MAX_LEN + 8];

    /* Item Description */
    LIC_CHAR               acItemDesc[LIC_ITEM_DESC_MAX_LEN + 8];

    /* Item value as per feature from License file information */
    LIC_ULONG              ulItemLKVal;

    /* Item type:LIC_CONTROLTYPE_ENUM */
    LIC_ULONG              ulItemType;

    /* Feature name. */
    LIC_CHAR               acFeatureName[LIC_FEATURE_NAME_MAX_LEN + 8];

    /* Deadline */
    LIC_CHAR               acSwDeadline[LIC_TIME_MAX_LEN];

    /* State of each items as per the enum
    defined LIC_LK_ITEM_STATE_ENUM */
    LIC_ULONG              ulCurrentState;

} LIC_LICENSE_KEYITEMINFO_STRU;


/**
*  LIC_LK_FEAT_ATTRIBUTES_STRU
*
*  acPrdName name of the product
*  acPrdVer  product version
*  acFeatName name of feature
*  acEsn list of ESN
*  acAttrib attribute string
*/
typedef struct TAG_LIC_LK_FEAT_ATTRIBUTES_STRU
{
    /* Name of the product */
    LIC_CHAR acPrdName[LIC_PRDNAME_MAX_LEN + 8];

    /* Version */
    LIC_CHAR acPrdVer[LIC_PRDVER_MAX_LEN + 8];

    /* Feature name */
    LIC_CHAR acFeatName[LIC_FEATURE_NAME_MAX_LEN + 8];

    /* List of ESN */
    LIC_CHAR acEsn[LIC_LONG_STREAM_LEN];

    /* attrib field */
    LIC_CHAR acAttrib[LIC_MINI_STREAM_LEN];

} LIC_LK_FEAT_ATTRIBUTES_STRU;

/**
*  LIC_RES_LIST
*/
typedef LIC_VAR_STREAM_STRU     LIC_RES_LIST;

/**
*  LIC_FUNC_LIST
*/
typedef LIC_VAR_STREAM_STRU     LIC_FUNC_LIST;


/**
*  LIC_LK_FEAT_INFO_STRU
*
*  stFeatInfo feature information from file
*  stResList  resources associated with the feature
*  stFuncList functions associated with the feature
*/
typedef struct TAG_LIC_LK_FEAT_INFO_STRU
{
    /* Details of the features present in file */
    LIC_LK_FEAT_ATTRIBUTES_STRU stFeatInfo;

    /* List of resources present in the file */
    LIC_RES_LIST stResList;

    /* List of functions present in the file */
    LIC_FUNC_LIST stFuncList;

} LIC_LK_FEAT_INFO_STRU;

/**
*  LIC_LK_FILE_INFO_STRU
*
*  stGenericHeader header section of LK
*  ulFeatureCount number of features requested
*  pstLkFeatInfo structure for feature data
*/
typedef struct TAG_LIC_LK_FILE_INFO_STRU
{
    /* This field defines the generic header */
    /*LIC_LK_GENERIC_HEADER_STRU stGenericHeader;*/
    LIC_LICENSE_KEYINFO_STRU stLicKeyInfo;

    /* Total feature count present in the file */
    LIC_ULONG ulFeatureCount;

    /* List of features present including the service section */
    LIC_LK_FEAT_INFO_STRU *pstLkFeatInfo;

} LIC_LK_FILE_INFO_STRU;

typedef struct  TAG_LIC_SBOM_ITEMINFO_STRU
 {
     /* SBom value in the lk */
    LIC_ULONG  ulSBomVal;

    /* SBom value is permanentn or not */
    LIC_BOOL    bIsPermanent;
    
    /*SBOM name in the lk */
    LIC_CHAR    acSBomName[LIC_ITEM_NAME_MAX_LEN + 8];

    /* SBOM dead line to this value */     
    LIC_CHAR    acSBomDeadline[LIC_TIME_MAX_LEN];

    /*SBOM Chinese unit description */    
    LIC_CHAR    acSBomChsUnit[LIC_ITEM_UNIT_MAX_LEN + 8];

    /* SBOM English unit description */    
    LIC_CHAR    acSBomEngUnit[LIC_ITEM_UNIT_MAX_LEN + 8];

    /*SBOM Chinese item description */
    LIC_CHAR    acSBomCHDesc[LIC_SALEITEM_DESC_MAX_LEN + 8];

    /* SBOM English item description */
    LIC_CHAR    acSBomENDesc[LIC_SALEITEM_DESC_MAX_LEN + 8];
} LIC_SBOM_ITEMINFO_STRU;

typedef struct  TAG_LIC_SBOM_NAME_STRU
{
    /*SBOM name in the lk */     
    LIC_CHAR    acSBomName[LIC_ITEM_NAME_MAX_LEN + 8];
    
} LIC_SBOM_NAME_STRU;

typedef struct  TAG_LIC_OFFERING_STRU
{
      /* offering product name */    
    LIC_CHAR    acOfferingProduct[LIC_PRDNAME_MAX_LEN + 8];

     /*  offering product version */     
    LIC_CHAR    acOfferingVersion[LIC_PRDVER_MAX_LEN + 8];
     
} LIC_OFFERING_STRU;

typedef struct  TAG_LIC_LICENSE_S2BINFO_STRU
 {
    /* Item id */     
    LIC_ULONG  ulItemID; 

    /* Item value */     
    LIC_ULONG  ulItemVal; 

    /* Item type */     
    LIC_ULONG  ulItemType; 

    /* Item name */   
    LIC_CHAR    acItemName[LIC_ITEM_NAME_MAX_LEN + 8];

    /* Item deadline */   
    LIC_CHAR    acSwDeadline[LIC_TIME_MAX_LEN];

    /* Is primary item or not */
    LIC_BOOL bIsPrimary;
     
} LIC_LICENSE_S2BINFO_STRU;

typedef struct TAG_LIC_LICENSE_FEATURE_STRU
{
    /* Feature ID */
    LIC_ULONG       ulFeatureID;

    /* Feature name */
    LIC_CHAR        acFeatureName[LIC_MINI_STREAM_LEN];

    /* Feature deadline */
    LIC_CHAR        acSwDeadline[LIC_MINI_STREAM_LEN];

    /* grace period day */
    LIC_ULONG       ulGracePeriodDay;

    /* feature type: 0 (COMM) or 1 (DEMO i.e. Commissioning) */
    LIC_ULONG       ulFeatureType;
}LIC_LICENSE_FEATURE_STRU;


/* Defines LK type according to type, deadline and policy */
typedef struct TAG_LIC_LICENSE_KEY_TYPE_STRU
{
    /* Refer LIC_LICENSE_KEY_TYPE_ENUM */
    LIC_ULONG ulLkType;

    /* Refer LIC_LICENSE_KEY_DEADLINE_ENUM */
    LIC_ULONG ulLkDeadline;

    /* Refer LIC_LICENSE_KEY_POLICY_ENUM */
    LIC_ULONG ulLkPolicy;
} LIC_LICENSE_KEY_TYPE_INFO_STRU;

typedef struct TAG_LIC_VERIFY_SBOM_MINOR_RESULT_STRU
{
    /* SaleItem error code*/
    LIC_ULONG ulSbomErrorCode;

    /* offring name  */
    LIC_CHAR  acOfferingName[LIC_MINI_STREAM_LEN];

    /* Deadline */
    LIC_CHAR acDeadline[LIC_MINI_STREAM_LEN];

    /* SBOM value in the new license or value in current License. Contains perm value and temp value. */
    LIC_ULONG  ulSbomVal;

    /* SBOM name in the new license. */
    LIC_CHAR   acSbomName[LIC_ITEM_NAME_MAX_LEN + 8];

    /* SBOM Chinese unit description */
    LIC_CHAR   acSbomChsUnit[LIC_ITEM_UNIT_MAX_LEN + 8];

    /* SBOM English unit description */
    LIC_CHAR   acSbomEngUnit[LIC_ITEM_UNIT_MAX_LEN + 8];

} LIC_VERIFY_SBOM_MINOR_RESULT_STRU;

typedef struct TAG_LIC_LK_VERIFY_SBOM_MINOR_RESULT
{
    /* LK Error Code */
    LIC_ULONG      ulLKErrorCode;

    /* Prd name as in LK */
    LIC_CHAR        acPrdName[LIC_PRDNAME_MAX_LEN + 8];

    /* Prd version as in LK */
    LIC_CHAR        acPrdVer[LIC_PRDVER_MAX_LEN + 8];

    /* ESN as in LK */
    LIC_CHAR        acLKEsn[LIC_LONG_STREAM_LEN];

    /* LK Serial number */
    LIC_CHAR        acLKLSN[LIC_LKSRNO_MAX_LEN];

    /*Lk Sbom count*/
    LIC_ULONG       ulSbomCount;

    /* Minor Result info Struct */
    LIC_VERIFY_SBOM_MINOR_RESULT_STRU *pstSbomMinorResult;
}LIC_LK_VERIFY_SBOM_MINOR_RESULT;

/*******************************************************************************
 * Header file for O&M Interfaces which can be used by product for LMT command
 * implementations
*******************************************************************************/

/*****************************************************************************
 Function     : ALM_VerifyLicenseKey
 Description  : Interface for verifying the LK for activation in the node.
 Input        : ulBufLength Input buffer length
                pcLKBuf Input LK buffer pointer. Should contain atleast ulBufLength
                 amount of memory
 Output       : pstMinorResult Minor result [Not-Null]
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_VerifyLicenseKey(IN LIC_ULONG ulBufLength,
                                IN const LIC_CHAR *pcLKBuf,
                                OUT LIC_VERIFY_RESULT_STRU *pstMinorResult);


/*****************************************************************************
 Function     : ALM_ActivateLicenseKey
 Description  : Interface for Installing or updating LK in the node
 Input        : pcLKBuf Input LK buffer [Not-Null]
                bForceActivate Input force flag [0/1]
 Output       : pstMinorResult Minor result [Not-Null]
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_ActivateLicenseKey(IN LIC_ULONG ulLKBufLen,
                                  IN const LIC_CHAR *pcLKBuf,
                                  IN LIC_BOOL bForceActivate,
                                  OUT LIC_VERIFY_RESULT_STRU *pstMinorResult);


/*****************************************************************************
 Function     : ALM_GetLicenseKeyInfo
 Description  : The interface to get LK basic and detail information.
 Input        : ulItemCount License Key buffer item count,
 Output       : pstLicKeyInfo License Key buffer
                pstLicKeyItemInfo License Key item info buffer
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_GetLicenseKeyInfo(
                        OUT LIC_LICENSE_KEYINFO_STRU *pstLicKeyInfo,
                        IN CONST LIC_ULONG ulItemCount,
                        OUT LIC_LICENSE_KEYITEMINFO_STRU *pstLicKeyItemInfo);


/*****************************************************************************
 Function     : ALM_GetLicenseAuthUsageInfo
 Description  : The interface for getting License Key item value information.
 Input        : pulLicKeylItemCount Specifies license key buffer count,
 Output       : pstLicKeyItemInfo Specifies License Key buffer item
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_GetLicenseAuthUsageInfo(
                                IN CONST LIC_ULONG ulItemCount,
                                INOUT LIC_ITEM_VALUE_STRU *pstLicKeyItemInfo);


/*****************************************************************************
 Function     : ALM_ListLicenseKeyContent
 Description  : The interface to get the contents of license file.
 Input        : ulLkBufLen Length of the buffer stream [Not-zero]
                pcLkBuf LK file buffer [Not-null]
 Output       : pstLkFileInfo LK file contents 
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_ListLicenseKeyContent(IN LIC_ULONG ulLkBufLen,
                                    IN const LIC_CHAR *pcLkBuf,
                                    OUT LIC_LK_FILE_INFO_STRU *pstLkFileInfo);


/*****************************************************************************
 Function     : ALM_CompareLicenseKey
 Description  : This interface is used to compare the new License Key values
                for all valid items registered, with their Config values.
 Input        : ulBufLength Input buffer length
                pcLKBuf Input LK buffer pointer. Should contain atleast
                   ulBufLength amount of memory [Not-null]
 Output       : pstResult Specifies the list of all items registered in the system
                   along with their config and LK values
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_CompareLicenseKey (IN LIC_ULONG ulLKBufLen,
                                    IN const LIC_CHAR *pcLKBuf,
                                    OUT LIC_LK_COMPARE_STRU *pstResult,
                                    OUT LIC_SBOM_COMPARE_STRU *pstSbomResult);

/*****************************************************************************
 Function     : ALM_StartEmergency
 Description  : Interface to start Emergency.
 Input        : 
 Output       : 
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_StartEmergency(LIC_VOID);

/*****************************************************************************
 Function     : ALM_StopEmergency
 Description  : Interface to stop Emergency.
 Input        : 
 Output       : 
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_StopEmergency(LIC_VOID);

/*****************************************************************************
 Function     : ALM_GetEmergencyInfo
 Description  : Interface to get the emergency info, contains running or not,
                remain count, remain days, start time, item count in emergency
                status, item info.
 Input        : 
 Output       : pstEmergencyInfo   emergency info buffer
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_GetEmergencyInfo(
                                LIC_EMERGENCY_INFO_STRU *pstEmergencyInfo);

/*****************************************************************************
 Function     : ALM_RevokeLicenseKey
 Description  : Interface to generate the revoke ticket for the current LK in
                the node.
 Input        : 
 Output       : pRevokeTicket   revoke code buffer
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_RevokeLicenseKey(
                                           OUT LIC_REVOKETICKET_STRU *pRevokeTicket);

/*****************************************************************************
 Function     : ALM_GetRevokeTicketList
 Description  : The interface to get the list of revoke tickets. You need call
                interface ALM_GetLicenseCountInfo to get offering count in 
                license file.
 Input        : ulRevokeCount revoke list count
 Output       : pstRevokeTktList   revoke list buffer
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_GetRevokeTicketList(IN CONST LIC_ULONG ulRevokeCount,
                                  OUT LIC_REVOKETICKET_STRU *pstRevokeTktList);

/*****************************************************************************
 Function     : ALM_GetLicenseOffering
 Description  : Get the offering info. You need call interface 
                ALM_GetLicenseCountInfo to get offering count in license file.
 Input        : ulOfferingCount offering info count
 Output       : pstOffering   sbom info buffer
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_GetLicenseOffering (IN CONST LIC_ULONG ulOfferingCount,
                                  OUT LIC_OFFERING_STRU *pstOffering);

/*****************************************************************************
 Function     : ALM_GetLicenseSbomInfo
 Description  : Get the sbom info by specific offering.
 Input        : pstOffering specific offering info
 Output       : pulSbomCount   sbom count
                pstLicSbomInfoList   sbom info
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_GetLicenseSbomInfo (
                                  IN const LIC_OFFERING_STRU *pstOffering, 
                                  INOUT LIC_ULONG *pulSbomCount,
                                  INOUT LIC_SBOM_ITEMINFO_STRU *pstLicSbomInfoList);

/*****************************************************************************
 Function     : ALM_GetLicenseS2BInfo
 Description  : Get the s2bom info by specific sbom and specific offering.
 Input        : pstOfferingSbom specific offering info
                pstSbomInfo     specific sbom info
 Output       : pulRelatedBbomNum   s2bom count
                pstLicSbomRelationKey   s2bom info
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_GetLicenseS2BInfo (
                                  IN const LIC_OFFERING_STRU *pstOfferingSbom,   
                                  IN const LIC_SBOM_NAME_STRU *pstSbomInfo,
                                  INOUT LIC_ULONG  *pulRelatedBbomNum,
                                  OUT LIC_LICENSE_S2BINFO_STRU *pstLicSbomRelationKey);

/*****************************************************************************
 Function     : ALM_GetLicenseCountInfo
 Description  : Get the conut info, contains control item actual count in 
                license file, control item register count, revoke code count,
                offering actual count in license file.
 Input        : None
 Output       : pstLicCountInfo  buff of count info
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_GetLicenseCountInfo(
                                    OUT LIC_COUNT_INFO_STRU *pstLicCountInfo);

/*****************************************************************************
 Function     : ALM_GetAllFeature
 Description  : The interface to get all the LK feature information.
 Input        : ulFeatureCount Specifies the number of features
 Output       : 
                pstFeatureList Specifies feature information
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_GetAllFeature(IN LIC_ULONG ulFeatureCount,
                             OUT LIC_LICENSE_FEATURE_STRU *pstFeatureList);

/*****************************************************************************
 Function     : ALM_GetMachineESN
 Description  : To get local machine ESN which is required for license file
                generation.
 Input        : None
 Output       : pstMachineESN Machine ESN buffer structure, output is valid ESN
                of the local node
 Return       : LIC_OK on success, error on others
*****************************************************************************/                               
LIC_EXPORT LIC_ULONG ALM_GetMachineESN(OUT LIC_NE_ESN_STRU *pstMachineESN);


/*****************************************************************************
 Function     : ALM_GetNELicenseStatus
 Description  : The interface to get license status of the NE.
 Input        : None
 Output       : puiStatus NE license status para
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_GetNELicenseStatus(OUT LIC_ULONG *pulStatus);


/*****************************************************************************
 Function     : ALM_GetRemainDays
 Description  : The interface to get remaining days of GracePeriod,
                Commissioning or Emergency state.
 Input        : None
 Output       : puiRemainDays Specifies remaining days buffer
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_GetRemainDays(OUT LIC_ULONG *pulRemainDays);


/*****************************************************************************
 Function     : ALM_RecoveryAlarm
 Description  : Recovery the fault alarm
 Input        : None
 Output       : None
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_RecoveryAlarm(LIC_VOID);

/*****************************************************************************
 Function     : ALM_GetEnterTrialTime
 Description  : Get the time when license enter Trial
 Input        : None
 Output       : None
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_GetEnterTrialTime(
                                    OUT LIC_NE_TIME_STRU* pstEnterTrialTime);

/*****************************************************************************
 Function     : ALM_StartInherent()
 Description  : The API is used to start the LicenseKey inherent
 Input        : None
 Output       : None
 Return       : Returns LIC_OK on success else on others.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_StartInherent(IN LIC_ULONG ulItemID);

/*****************************************************************************
 Function     : ALM_StopInherent()
 Description  : The API is used to stop the LicenseKey inherent
 Input        : None
 Output       : None
 Return       : Returns LIC_OK on success else on others.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_StopInherent(IN LIC_ULONG ulItemID);

/*****************************************************************************
 Function     : ALM_GetInherentInfo()
 Description  : The API is used to query the inherent info
 Input        : ulItemCnt  the inherent item count
 Output       : pstInerentItemList  the inherent item list
 Return       : Returns LIC_OK on success else LIC_ERROR.
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_GetInherentInfo(IN LIC_ULONG ulItemCnt,
                            OUT LIC_INHERENT_ITEM_INFO_STRU *pstInerentItemList);

/*****************************************************************************
 Function     : ALM_GetLicenseKeyTypeInfo
 Description  : The interface to get information about the LK that was last
                activated in the LM.
 Input        : 
 Output       : pstLicenseKeyTypeInfo Info about the LK
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_GetLicenseKeyTypeInfo(
                    OUT LIC_LICENSE_KEY_TYPE_INFO_STRU *pstLicenseKeyTypeInfo);

/*****************************************************************************
 Function     : ALM_StickCfg
 Description  : Appoint stick items and notify interval.
 Input        : pstStickCfg - stick config info.
 Output       : None
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_StickCfg(IN LIC_STICK_CFG_STRU* pstStickCfg);

/*****************************************************************************
 Function     : ALM_StickQuery
 Description  : 查询Stick信息，若ulItemCapTotal为0，将不列出支持stick控制项。
 Input        : ulItemCapTotal - pstStickInfo->pstStickItemsArray中结点数目.
 Output       : pstStickInfo - stick info.
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_StickQuery(IN LIC_ULONG ulItemCapTotal,
    OUT LIC_STICK_INFO_STRU* pstStickInfo);

/*****************************************************************************
 Function     : ALM_StickStart
 Description  : Start stick.
 Input        : None.
 Output       : None.
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_StickStart();

/*****************************************************************************
 Function     : ALM_StickStop
 Description  : Stop stick.
 Input        : None.
 Output       : None.
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_StickStop();

/*****************************************************************************
 Function     : ALM_GetAlarmReason
 Description  : 获取告警的具体原因，为USP增加改接口
 Input        : None.
 Output       : pstAlarmReasonID 告警ID，参考[ LIC_ALARM_REASON_ENUM ]
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_GetAlarmReason(OUT LIC_ULONG *pstAlarmReasonID);

/*****************************************************************************
 Function     : ALM_GetEsnAnyInfo
 Description  : 获取esn为any有效期的剩余天数以及是否激活过ENS=ANY的License
 Input        : None.
 Output       : pstEsnAnyInfo 剩余天数、有效期、已运行天数、是否激活过
 Return       : LIC_OK on success, error on others
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_GetEsnAnyInfo(OUT LIC_ESN_ANY_INFO_STRU * pstEsnAnyInfo);

/*****************************************************************************
 Function     : ALM_VerifyLicenseKeyBySbom
 Description  : To verify licesne key.
 Input        : ulLKBufLen - License文件长度
                pcLKBuf - License文件buf

 Output       : pbHasDat - 当前License或者新License中包含2.0格式
                pulSbomCount - 当前License和新License中SBOM数量的总和
                pstMinorResult - SBOM次要错误列表

 Return       : LIC_OK on success, others on failure
*****************************************************************************/
LIC_EXPORT LIC_ULONG ALM_VerifyLicenseKeyBySbom(IN LIC_ULONG ulLKBufLen,
                    IN const LIC_CHAR *pcLKBuf,
                    OUT LIC_BOOL *pbHasDat,
                    OUT LIC_ULONG *pulSbomCount,
                    OUT LIC_LK_VERIFY_SBOM_MINOR_RESULT *pstLkSbomMinorResult);

/*******************************************************************************
  Prototype     : ALM_SetEmergencyCount
  Description   : 设置客户购买的紧急license 数量
  Input         : ulEmergencyCnt
  Return Value  : None
  Output        : LIC_OK Success,Other failed
*******************************************************************************/
LIC_EXPORT LIC_ULONG ALM_SetEmergencyCount(IN LIC_ULONG ulEmergencyCnt);

#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif

#endif /*__LIC_MANAGERMNT_ITF_H__*/

