







#import <Foundation/Foundation.h>
#import "CPDataModel.h"

NS_ASSUME_NONNULL_BEGIN



/*
 "pub_key": "0497ba1e995098f9984cf0ca8e63b4a5dd3db402575bf201ac70f89f219a89a4389e9a3a796db8d762c5f015d7b12edd5270de3038262562d14398165e7a154b68",
 "nick_name": "NetCloth小助手",
 "avatar": "https:
 "server_addr": "nch19vnsnnseazkyuxgkt0098gqgvfx0wxmv96479m"
 */
@interface CPAssistant : NSObject
@property (nonatomic, copy) NSString *pub_key;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *server_addr;
@end




@interface CPRecommendedGroup : NSObject


@property (nonatomic, copy) NSString *operator_address;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *group_id; 

@end





@interface CPGroupNotifySession : NSObject

@property (nonatomic, assign) int sessionId;

@property (nonatomic, assign)  NSInteger unreadCount;
@property (nullable, nonatomic, strong)  CPGroupNotify  *lastNotice;

@property (nonatomic, strong) CPContact *relateContact; 
@property (nonatomic, strong) NSArray<CPGroupMember *> *groupRelateMember;

@end


@interface CPGroupNotifyPreview : NSObject

@property (nonatomic, assign)  NSInteger unreadCount; 
@property (nonatomic, assign)  NSInteger readCount;

@property (nonatomic, assign, readonly)  NSInteger needApproveCount; 

@property (nullable, nonatomic, strong)  CPGroupNotify  *lastNotice;

@end











/*
 {
     "create_time" = "2019-12-12T02:41:56.048Z";
     "group_id" = 04d644ac980e09a447671e0af67bb4e348e9c2da9bdb5492ec7b31421ae8b138dac5a046cfe0a49825906fa73197a1846986e8c8080f574445a6ea4119909453a2;
     managers =     (
     );
     "member_count" = 1;
     "modified_time" = "2019-12-12T02:41:56.049Z";
     name = "\U7fa44\U6d4b\U8bd5";
     notice =     {
         content = "";
         "modified_time" = "0001-01-01T00:00:00Z";
         publisher = "";
     };
     owner = 042d80faf892fe8f2d177683b965577f20b639012267fdc7b60d66277bc03da026f450296b61bba90e370bbb9d83c3732a39f580c55f3afae113d8b9c286d2c4bc;
     type = 0;
 }
 */

@interface CPGroupInfoResp : NSObject

@property (nonatomic, copy) NSString *group_id; 
@property (nonatomic, copy) NSString *owner; 
@property (nonatomic, copy) NSString *name; 
@property (nonatomic, assign) int type; 


@property (nonatomic, copy) NSString *create_time;


@property (nonatomic, copy) NSString *modified_time;

@property (nonatomic, assign) int member_count;

@property (nonatomic, copy) NSDictionary *notice; 
@property (nonatomic, assign) int invite_type;

@property (nonatomic, assign) int resultCode;

@end


@interface CPUnreadResponse : NSObject

@property (nonatomic, copy) NSString *groupHexPubkey;
@property (nonatomic, assign) NSInteger unreadCount;
@property (nonatomic, strong, nullable) CPMessage *lastMsg;

@end




NS_ASSUME_NONNULL_END
