#ifndef __NC_I_LIBRABACKUPPLUGIN_H__
#define __NC_I_LIBRABACKUPPLUGIN_H__
#include <stdint.h>

#ifdef __cplusplus

extern "C"
{
#endif

#define MAX_PATHNAME            1024
#define MAX_DESCRIPTION         100

/* EISOO_UInt32*/
typedef unsigned int EISOO_UInt32;

/* EISOO_UInt64*/
typedef struct { /* defined as two unsigned 32-bit integers */
    EISOO_UInt32 left;
    EISOO_UInt32 right;
} EISOO_UInt64;

typedef struct
{
    char path[MAX_PATHNAME];
    char name[MAX_PATHNAME];
} ObjectName;


typedef enum {
    ObjectType_ANY = 1,
    ObjectType_FILE,
    ObjectType_DIRECOTRY,
    ObjectType_OTHER,
} ObjectType;


typedef struct
{
    ObjectName objectName;
    EISOO_UInt64 restoreOrder;
    EISOO_UInt64 estimatedSize;

    ObjectType objectType;
    char objectInfo[MAX_DESCRIPTION];
} ObjectDescriptor;

typedef struct
{
    ObjectName objectName;
    ObjectType objectType;
} QueryDescriptor;


typedef struct {
    EISOO_UInt32 length;
    unsigned char* buffer;
} Datablock;

int Init (void);
int BeginTxn (long txnId);
int SendObject (long txnId, ObjectDescriptor* objectDescriptor);
int SendData (long txnId, Datablock* datablock);
int EisooGetObject(long txnId, QueryDescriptor *queryDesc, ObjectDescriptor *objDesc);
int QueryObject(long txnId, QueryDescriptor *queryDesc, ObjectDescriptor *objDesc);
int GetNextObject(long txnId, ObjectDescriptor *objDesc);
int EisooGetData(long txnId, Datablock *datablock);
int EndTxn (long txnId);
void EndAll (bool abort);
int GetErrorString(int errId , EISOO_UInt32 *lenPtr, char *errmsg);

#ifdef __cplusplus
}
#endif

#endif //__NC_I_LIBRABACKUPPLUGIN_H__
