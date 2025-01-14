




#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

#import <stdatomic.h>

#import "CommonTypes.pbobjc.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - NCProtoCommonTypesRoot

@implementation NCProtoCommonTypesRoot




@end

#pragma mark - Enum NCProtoChatType

GPBEnumDescriptor *NCProtoChatType_EnumDescriptor(void) {
  static _Atomic(GPBEnumDescriptor*) descriptor = nil;
  if (!descriptor) {
    static const char *valueNames =
        "ChatTypeUnspecified\000ChatTypeSingle\000ChatT"
        "ypeGroup\000";
    static const int32_t values[] = {
        NCProtoChatType_ChatTypeUnspecified,
        NCProtoChatType_ChatTypeSingle,
        NCProtoChatType_ChatTypeGroup,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(NCProtoChatType)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:NCProtoChatType_IsValidValue];
    GPBEnumDescriptor *expected = nil;
    if (!atomic_compare_exchange_strong(&descriptor, &expected, worker)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL NCProtoChatType_IsValidValue(int32_t value__) {
  switch (value__) {
    case NCProtoChatType_ChatTypeUnspecified:
    case NCProtoChatType_ChatTypeSingle:
    case NCProtoChatType_ChatTypeGroup:
      return YES;
    default:
      return NO;
  }
}

#pragma mark - Enum NCProtoActionType

GPBEnumDescriptor *NCProtoActionType_EnumDescriptor(void) {
  static _Atomic(GPBEnumDescriptor*) descriptor = nil;
  if (!descriptor) {
    static const char *valueNames =
        "ActionTypeUnspecified\000ActionTypeAdd\000Acti"
        "onTypeDelete\000";
    static const int32_t values[] = {
        NCProtoActionType_ActionTypeUnspecified,
        NCProtoActionType_ActionTypeAdd,
        NCProtoActionType_ActionTypeDelete,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(NCProtoActionType)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:NCProtoActionType_IsValidValue];
    GPBEnumDescriptor *expected = nil;
    if (!atomic_compare_exchange_strong(&descriptor, &expected, worker)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL NCProtoActionType_IsValidValue(int32_t value__) {
  switch (value__) {
    case NCProtoActionType_ActionTypeUnspecified:
    case NCProtoActionType_ActionTypeAdd:
    case NCProtoActionType_ActionTypeDelete:
      return YES;
    default:
      return NO;
  }
}

#pragma mark - Enum NCProtoOrderBizStatus

GPBEnumDescriptor *NCProtoOrderBizStatus_EnumDescriptor(void) {
  static _Atomic(GPBEnumDescriptor*) descriptor = nil;
  if (!descriptor) {
    static const char *valueNames =
        "OrderBizStatusUnspecified\000OrderBizStatus"
        "Ongoing\000OrderBizStatusSuccess\000OrderBizSt"
        "atusFailed\000";
    static const int32_t values[] = {
        NCProtoOrderBizStatus_OrderBizStatusUnspecified,
        NCProtoOrderBizStatus_OrderBizStatusOngoing,
        NCProtoOrderBizStatus_OrderBizStatusSuccess,
        NCProtoOrderBizStatus_OrderBizStatusFailed,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(NCProtoOrderBizStatus)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:NCProtoOrderBizStatus_IsValidValue];
    GPBEnumDescriptor *expected = nil;
    if (!atomic_compare_exchange_strong(&descriptor, &expected, worker)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL NCProtoOrderBizStatus_IsValidValue(int32_t value__) {
  switch (value__) {
    case NCProtoOrderBizStatus_OrderBizStatusUnspecified:
    case NCProtoOrderBizStatus_OrderBizStatusOngoing:
    case NCProtoOrderBizStatus_OrderBizStatusSuccess:
    case NCProtoOrderBizStatus_OrderBizStatusFailed:
      return YES;
    default:
      return NO;
  }
}


#pragma clang diagnostic pop


