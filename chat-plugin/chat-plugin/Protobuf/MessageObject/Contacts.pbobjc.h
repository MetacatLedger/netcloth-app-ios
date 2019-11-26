




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




CF_EXTERN_C_BEGIN

NS_ASSUME_NONNULL_BEGIN


@interface NCProtoContactsRoot : GPBRootObject
@end


typedef GPB_ENUM(NCProtoContacts_FieldNumber) {
  NCProtoContacts_FieldNumber_PubKey = 1,
  NCProtoContacts_FieldNumber_Summary = 2,
  NCProtoContacts_FieldNumber_Content = 3,
};

@interface NCProtoContacts : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSData *pubKey;

@property(nonatomic, readwrite, copy, null_resettable) NSData *summary;

@property(nonatomic, readwrite, copy, null_resettable) NSData *content;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END


