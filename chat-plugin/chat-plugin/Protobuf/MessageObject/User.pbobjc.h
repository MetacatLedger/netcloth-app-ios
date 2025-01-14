




#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_VERSION < 30002
#error This file was generated by a newer version of protoc which is incompatible with your Protocol Buffer library sources.
#endif
#if 30002 < GOOGLE_PROTOBUF_OBJC_MIN_SUPPORTED_VERSION
#error This file was generated by an older version of protoc which is incompatible with your Protocol Buffer library sources.
#endif



#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

GPB_ENUM_FWD_DECLARE(NCProtoActionType);
GPB_ENUM_FWD_DECLARE(NCProtoChatType);

NS_ASSUME_NONNULL_BEGIN

#pragma mark - NCProtoUserRoot

/**
 * Exposes the extension registry for this file.
 *
 * The base class provides:
 * @code
 *   + (GPBExtensionRegistry *)extensionRegistry;
 * @endcode
 * which is a @c GPBExtensionRegistry that includes all the extensions defined by
 * this file and all files that it depends on.
 **/
@interface NCProtoUserRoot : GPBRootObject
@end

#pragma mark - NCProtoSetMuteReq

typedef GPB_ENUM(NCProtoSetMuteReq_FieldNumber) {
  NCProtoSetMuteReq_FieldNumber_RelatedPubKey = 1,
  NCProtoSetMuteReq_FieldNumber_Action = 2,
  NCProtoSetMuteReq_FieldNumber_ChatType = 3,
};

@interface NCProtoSetMuteReq : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSData *relatedPubKey;

@property(nonatomic, readwrite) enum NCProtoActionType action;

@property(nonatomic, readwrite) enum NCProtoChatType chatType;

@end

/**
 * Fetches the raw value of a @c NCProtoSetMuteReq's @c action property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t NCProtoSetMuteReq_Action_RawValue(NCProtoSetMuteReq *message);
/**
 * Sets the raw value of an @c NCProtoSetMuteReq's @c action property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetNCProtoSetMuteReq_Action_RawValue(NCProtoSetMuteReq *message, int32_t value);

/**
 * Fetches the raw value of a @c NCProtoSetMuteReq's @c chatType property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t NCProtoSetMuteReq_ChatType_RawValue(NCProtoSetMuteReq *message);
/**
 * Sets the raw value of an @c NCProtoSetMuteReq's @c chatType property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetNCProtoSetMuteReq_ChatType_RawValue(NCProtoSetMuteReq *message, int32_t value);

#pragma mark - NCProtoSetMuteBatchReq

typedef GPB_ENUM(NCProtoSetMuteBatchReq_FieldNumber) {
  NCProtoSetMuteBatchReq_FieldNumber_RelatedPubKeysArray = 1,
  NCProtoSetMuteBatchReq_FieldNumber_Action = 2,
  NCProtoSetMuteBatchReq_FieldNumber_ChatType = 3,
};


@interface NCProtoSetMuteBatchReq : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSData*> *relatedPubKeysArray;
/** The number of items in @c relatedPubKeysArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger relatedPubKeysArray_Count;

@property(nonatomic, readwrite) enum NCProtoActionType action;

@property(nonatomic, readwrite) enum NCProtoChatType chatType;

@end

/**
 * Fetches the raw value of a @c NCProtoSetMuteBatchReq's @c action property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t NCProtoSetMuteBatchReq_Action_RawValue(NCProtoSetMuteBatchReq *message);
/**
 * Sets the raw value of an @c NCProtoSetMuteBatchReq's @c action property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetNCProtoSetMuteBatchReq_Action_RawValue(NCProtoSetMuteBatchReq *message, int32_t value);

/**
 * Fetches the raw value of a @c NCProtoSetMuteBatchReq's @c chatType property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t NCProtoSetMuteBatchReq_ChatType_RawValue(NCProtoSetMuteBatchReq *message);
/**
 * Sets the raw value of an @c NCProtoSetMuteBatchReq's @c chatType property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetNCProtoSetMuteBatchReq_ChatType_RawValue(NCProtoSetMuteBatchReq *message, int32_t value);

#pragma mark - NCProtoSetBlacklistReq

typedef GPB_ENUM(NCProtoSetBlacklistReq_FieldNumber) {
  NCProtoSetBlacklistReq_FieldNumber_RelatedPubKey = 1,
  NCProtoSetBlacklistReq_FieldNumber_Action = 2,
};


@interface NCProtoSetBlacklistReq : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSData *relatedPubKey;

@property(nonatomic, readwrite) enum NCProtoActionType action;

@end

/**
 * Fetches the raw value of a @c NCProtoSetBlacklistReq's @c action property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t NCProtoSetBlacklistReq_Action_RawValue(NCProtoSetBlacklistReq *message);
/**
 * Sets the raw value of an @c NCProtoSetBlacklistReq's @c action property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetNCProtoSetBlacklistReq_Action_RawValue(NCProtoSetBlacklistReq *message, int32_t value);

#pragma mark - NCProtoSetBlacklistBatchReq

typedef GPB_ENUM(NCProtoSetBlacklistBatchReq_FieldNumber) {
  NCProtoSetBlacklistBatchReq_FieldNumber_RelatedPubKeysArray = 1,
  NCProtoSetBlacklistBatchReq_FieldNumber_Action = 2,
};

@interface NCProtoSetBlacklistBatchReq : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSData*> *relatedPubKeysArray;
/** The number of items in @c relatedPubKeysArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger relatedPubKeysArray_Count;

@property(nonatomic, readwrite) enum NCProtoActionType action;

@end

/**
 * Fetches the raw value of a @c NCProtoSetBlacklistBatchReq's @c action property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t NCProtoSetBlacklistBatchReq_Action_RawValue(NCProtoSetBlacklistBatchReq *message);
/**
 * Sets the raw value of an @c NCProtoSetBlacklistBatchReq's @c action property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetNCProtoSetBlacklistBatchReq_Action_RawValue(NCProtoSetBlacklistBatchReq *message, int32_t value);

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop


