







#import <Foundation/Foundation.h>
#import "MessageObjects.h"
#import "blake2/blake2.h"
#import "key_tool.h"
#import "CPBridge.h"
#import "zlib.h"
#import <secp256k1/secp256k1_recovery.h>
#import <chat_plugin/chat_plugin-Swift.h>
#import "CPInnerState.h"
#import <YYKit/YYKit.h>
#import <CPMessageRecieveHandleProtocol.h>
#import "CPTools.h"


NSString *const kMsg_RegisterRsp = NCProtoRegisterRsp.descriptor.fullName;
NSString *const kMsg_Heartbeat = NCProtoHeartbeat.descriptor.fullName;







std::string CalcHash(NCProtoNetMsg *net_msg) {
    std::string rtn(32, 0);
    blake2b_state hash_state;
    blake2b_init(&hash_state, 32);
    blake2b_update(&hash_state, nsstring2cstr(net_msg.name), net_msg.name.length);
    blake2b_update(&hash_state, net_msg.data_p.bytes, net_msg.data_p.length);
    bool compress = net_msg.compress;
    blake2b_update(&hash_state, &compress, sizeof(compress));
    blake2b_update(&hash_state, net_msg.head.fromPubKey.bytes, net_msg.head.fromPubKey.length);
    blake2b_update(&hash_state, net_msg.head.toPubKey.bytes, net_msg.head.toPubKey.length);
    blake2b_final(&hash_state, (char*)rtn.data(), rtn.size());
    return rtn;
}

const uint32_t SIGN_SIZE_RECOVER = 65;
NSData * GetSignByPrivateKeyRecover(const uint8_t* contenthash, size_t contenthash_len, const std::string pri_key){
    NSData *hash = [NSData dataWithBytes:contenthash length:contenthash_len];
    NSData *prikey = bytes2nsdata(pri_key);
    NSData *recover_serial_sign = [CPSignWraper signForRecoveryWithHash:hash privateKey:prikey];
    return recover_serial_sign;
}


BOOL CheckSignature(NCProtoNetMsg *net_msg) {
    if (net_msg.head.signature.length != SIGN_SIZE_RECOVER) {
        return false;
    }
    std::string hash = CalcHash(net_msg);
    NSData *hash_d = bytes2nsdata(hash);
    NSData *recoverPubkey =  [CPSignWraper recoverPublicKeyWithHash:hash_d signature:net_msg.head.signature];
    if ([net_msg.head.fromPubKey isEqualToData:recoverPubkey]) {
        return YES;
    }
    return NO;
}



void FillSignature(NCProtoNetMsg *net_msg, const std::string& private_key) {
    std::string hash = CalcHash(net_msg);
    NSData *sign = GetSignByPrivateKeyRecover((uint8_t*)hash.data(), hash.size(), private_key);
    net_msg.head.signature = sign;
    assert(sign.length == SIGN_SIZE_RECOVER);
}




NCProtoNetMsg * CreateNetMsgPackFillName(GPBMessage *body, NCProtoHead *head ,bool compress = false) {
    NCProtoNetMsg *pack = NCProtoNetMsg.alloc.init;
    NSString *name = body.descriptor.fullName;
    pack.name = name;
    pack.head = head;
    pack.data_p = body.data;
    pack.compress = compress;
    return pack;
}



NCProtoNetMsg * CreateRegister(const std::string& from_public_key, const std::string &pri_key) {
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    
    
    NCProtoRegisterReq *body = NCProtoRegisterReq.alloc.init;
    body.version = GetAppVersion();
    body.deviceType = NCProtoDeviceType_DeviceTypeIos;
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
}

NCProtoNetMsg * CreateHeartbeat() {
    NCProtoHead *head = NCProtoHead.alloc.init;
    NCProtoHeartbeat *body = NCProtoHeartbeat.alloc.init;
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    return pack;
}

NCProtoNetMsg * CreateTextMsg(const std::string &from_public_key,
                              const std::string &to_public_key,
                              const std::string &pri_key,
                              const std::string &content) {
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    head.toPubKey = bytes2nsdata(to_public_key);
    
    
    NCProtoText *body = NCProtoText.alloc.init;
    body.content = bytes2nsdata(content);
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
}

NCProtoNetMsg * CreateAudioMsg(const std::string &from_public_key,
                               const std::string &to_public_key,
                               const std::string &pri_key,
                               const std::string &content,
                               uint32_t playTime) {
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    head.toPubKey = bytes2nsdata(to_public_key);
    
    
    NCProtoAudio *body = NCProtoAudio.alloc.init;
    body.content = bytes2nsdata(content);
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
}

extern NCProtoNetMsg * CreateImageMsg(const std::string &from_public_key,
                                      const std::string &to_public_key,
                                      const std::string &pri_key,
                                      NSString *imageHash,
                                      int32_t width,
                                      int32_t height) {
    
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    head.toPubKey = bytes2nsdata(to_public_key);
    
    
    NCProtoImage *body = NCProtoImage.alloc.init;
    body.id_p = imageHash;
    body.width = width;
    body.height = height;
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
}

NCProtoNetMsg *CreateRequestCacheMsg(const std::string &pri_key,
                                     uint32_t rand_id,
                                     uint64_t time,
                                     uint64_t hash,
                                     uint32_t size) {
    
    std::string from_public_key = GetPublicKeyByPrivateKey(pri_key);
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    
    
    NCProtoCacheMsgReq *body = NCProtoCacheMsgReq.alloc.init;
    body.roundId = rand_id;
    body.time = time;
    body.hash_p = hash;
    body.size = size;
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
}

NCProtoNetMsg * CreateClientReplyMsg(NCProtoNetMsg * targetMsg)
{
    NCProtoHead *head = targetMsg.head;
    NCProtoClientReceipt *body = NCProtoClientReceipt.alloc.init;
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    return pack;
}



NCProtoNetMsg * CreateBindAppleId(const std::string &pri_key,
                                  NSString *apple_id) {
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    std::string from_public_key = GetPublicKeyByPrivateKey(pri_key);
    head.fromPubKey = bytes2nsdata(from_public_key);
    
    
    NCProtoAppleIdBind *body = NCProtoAppleIdBind.alloc.init;
    body.appleId = apple_id;
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
}

NCProtoNetMsg * CreateUnBindAppleId(const std::string &pri_key,
                                    NSString *apple_id) {
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    std::string from_public_key = GetPublicKeyByPrivateKey(pri_key);
    head.fromPubKey = bytes2nsdata(from_public_key);
    
    
    NCProtoAppleIdUnbind *body = NCProtoAppleIdUnbind.alloc.init;
    body.appleId = apple_id;
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
}


NCProtoNetMsg * CreateGroupCreate(NSString * group_name,
                                  int group_type, 
                                  NSString *owner_nick_name, 
                                  NSArray <NCProtoNetMsg *> *to_invitee_msgs, 
                                  
                                  const std::string &from_public_key,
                                  const std::string &to_public_key, 
                                  const std::string &pri_key
                                  ) {
    
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    head.toPubKey = bytes2nsdata(to_public_key);
    
    
    
    NCProtoGroupCreate *body = NCProtoGroupCreate.alloc.init;
    body.groupName = group_name;
    body.groupType = group_type;
    body.ownerNickName = owner_nick_name;
    body.toInviteeMsgsArray = to_invitee_msgs;
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
    
}

NCProtoNetMsg * CreateGroupInvite(NSData * group_private_key,
                                  NSData *group_pub_key,
                                  NSString *group_name,
                                  const std::string &from_public_key,
                                  const std::string &to_public_key, 
                                  const std::string &pri_key 
) {
    
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    head.toPubKey = bytes2nsdata(to_public_key);
    head.msgTime =  (uint64_t)([NSDate.date timeIntervalSince1970] * 1000);
    
    
    NSData *datap = nil;
    if (group_private_key.length == kPrivateKeySize ||
        group_private_key.length == 4 
        ) {
        std::string source = nsdata2bytes(group_private_key);
        std::string encode = [CPBridge coreEcdhEncodeMsg:source prikey:pri_key toPubkey:to_public_key];
        datap = bytes2nsdata(encode);
    }
    
    NCProtoGroupInvite *body = NCProtoGroupInvite.alloc.init;
    body.groupPrivateKey = datap;
    body.groupName = group_name;
    body.groupPubKey = group_pub_key;
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
    
}

NCProtoNetMsg * CreateGroupJoin(NSString *nick_name,
                                NSString *desc, 
                                int source, 
                                NSString *inviter_pub_key,
                                
                                const std::string &from_public_key,
                                const std::string &to_public_key, 
                                const std::string &pri_key 
) {
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    head.toPubKey = bytes2nsdata(to_public_key);
    
    
    NCProtoGroupJoin *body = NCProtoGroupJoin.alloc.init;
    body.nickName = nick_name;
    body.source = source;
    
    
    std::string encryDesc = [CPBridge coreEcdhEncodeMsg:nsstring2bytes(desc) prikey:pri_key toPubkey:to_public_key];
    body.description_p = hexStringFromBytes(encryDesc);
    
    std::string inviter = bytesFromHexString(inviter_pub_key);
    body.inviterPubKey = bytes2nsdata(inviter); 
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
}


NCProtoNetMsg * CreateGroupUpdateName(NSString *groupName,
                                      const std::string &from_public_key,
                                      const std::string &to_public_key, 
                                      const std::string &pri_key 
) {
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    head.toPubKey = bytes2nsdata(to_public_key);
    
    
    NCProtoGroupUpdateName *body = NCProtoGroupUpdateName.alloc.init;
    body.name = groupName;
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
}

NCProtoNetMsg * CreateGroupUpdateNotice(NSString *groupNotice,
                                        const std::string &from_public_key,
                                        const std::string &to_public_key, 
                                        const std::string &pri_key 
) {
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    head.toPubKey = bytes2nsdata(to_public_key);
    
    
    NCProtoGroupUpdateNotice *body = NCProtoGroupUpdateNotice.alloc.init;
    body.notice = groupNotice;
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
    
}

NCProtoNetMsg * CreateGroupUpdateNickName(NSString *nicknameInGroup,
                                          const std::string &from_public_key,
                                          const std::string &to_public_key, 
                                          const std::string &pri_key 
) {
    
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    head.toPubKey = bytes2nsdata(to_public_key);
    
    
    NCProtoGroupUpdateNickName *body = NCProtoGroupUpdateNickName.alloc.init;
    body.nickName = nicknameInGroup;
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
    
}



NCProtoNetMsg * CreateGroupGetMemberReq(const std::string &from_public_key,
                                        const std::string &to_public_key, 
                                        const std::string &pri_key 
) {
    
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    head.toPubKey = bytes2nsdata(to_public_key);
    
    NCProtoGroupGetMemberReq *body = NCProtoGroupGetMemberReq.alloc.init;
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
    
}



NCProtoNetMsg * CreateGroupText(const std::string &content,
                                bool at_all,
                                NSArray <NSString *> *hexPubkey_at_members,
                                
                                const std::string &from_public_key,
                                const std::string &to_public_key, 
                                const std::string &pri_key 
) {
    
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    head.toPubKey = bytes2nsdata(to_public_key);
    
    
    NCProtoGroupText *body = NCProtoGroupText.alloc.init;
    body.content = bytes2nsdata(content);
    body.atAll = at_all;
    
    NSMutableArray *bytes = NSMutableArray.array;
    NSData *data;
    for (NSString *hexpub in hexPubkey_at_members) {
        data =  [NSData dataWithHexString:hexpub];
        if (![NSData cp_isEmpty:data]) {
            [bytes addObject:data];
        }
    }
    body.atMembersArray = bytes;
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
    
}

NCProtoNetMsg * CreateGroupAudio(const std::string &content, 
                                 uint32_t playTime,
                                 const std::string &from_public_key,
                                 const std::string &to_public_key, 
                                 const std::string &pri_key 
) {
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    head.toPubKey = bytes2nsdata(to_public_key);
    
    
    NCProtoGroupAudio *body = NCProtoGroupAudio.alloc.init;
    body.content = bytes2nsdata(content);
    body.playTime = playTime;
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
}

NCProtoNetMsg * CreateGroupImage(NSString *imageId,
                                 uint32_t width,
                                 uint32_t height,
                                 
                                 const std::string &from_public_key,
                                 const std::string &to_public_key, 
                                 const std::string &pri_key 
) {
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    head.toPubKey = bytes2nsdata(to_public_key);
    
    
    NCProtoGroupImage *body = NCProtoGroupImage.alloc.init;
    body.id_p = imageId;
    body.width = width;
    body.height = height;
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
}

NCProtoNetMsg * CreateGroupGetMsgReq(int64_t begin_id,
                                     int64_t end_id,
                                     uint32_t count,
                                     const std::string &from_public_key,
                                     const std::string &to_public_key, 
                                     const std::string &pri_key 
) {
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    head.toPubKey = bytes2nsdata(to_public_key);
    
    
    NCProtoGroupGetMsgReq *body = NCProtoGroupGetMsgReq.alloc.init;
    body.beginId = begin_id;
    body.endId = end_id;
    body.count = count;
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
}

NCProtoGroupUnreadReq * CreateGroupUnreadReq(int64_t lastMsgId,
                                            const std::string &group_public_key 
) {
    NCProtoGroupUnreadReq *req = NCProtoGroupUnreadReq.alloc.init;
    req.lastMsgId = lastMsgId;
    req.groupPubKey = bytes2nsdata(group_public_key);
    
    return req;
}

NCProtoNetMsg * CreateGroupGetUnreadReq(NSArray<NCProtoGroupUnreadReq *> *req_items,
                                               const std::string &from_public_key,
                                               const std::string &to_public_key, 
                                               const std::string &pri_key 
) {
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    head.toPubKey = bytes2nsdata(to_public_key);
    
    
    NCProtoGroupGetUnreadReq *body = NCProtoGroupGetUnreadReq.alloc.init;
    body.reqItemsArray = req_items;
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
    
}


NCProtoNetMsg * CreateGroupDismiss(  const std::string &from_public_key,
                                   const std::string &to_public_key, 
                                   const std::string &pri_key 
) {
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    head.toPubKey = bytes2nsdata(to_public_key);
    
    
    NCProtoGroupDismiss *body = NCProtoGroupDismiss.alloc.init;
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
}


NCProtoNetMsg * CreateGroupKickReq(
                                   NSArray * kickHexpubkeys,
                                   const std::string &from_public_key,
                                   const std::string &to_public_key, 
                                   const std::string &pri_key 
) {
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    head.toPubKey = bytes2nsdata(to_public_key);
    
    
    NCProtoGroupKickReq *body = NCProtoGroupKickReq.alloc.init;
    NSMutableArray *array = NSMutableArray.array;
    for (NSString *hexpub in kickHexpubkeys) {
        [array addObject:bytes2nsdata(bytesFromHexString(hexpub))];
    }
    body.kickPubKeysArray = array;
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
}


NCProtoNetMsg * CreateGroupQuit(
                                       const std::string &from_public_key,
                                       const std::string &to_public_key, 
                                       const std::string &pri_key 
) {
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    head.toPubKey = bytes2nsdata(to_public_key);
    
    
    NCProtoGroupQuit *body = NCProtoGroupQuit.alloc.init;
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
}


NCProtoNetMsg * CreateGroupUpdateInviteType(
                                                   CPGroupInviteType inviteType,
                                                   const std::string &from_public_key,
                                                   const std::string &to_public_key, 
                                                   const std::string &pri_key 
) {
    
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    head.toPubKey = bytes2nsdata(to_public_key);
    
    
    NCProtoGroupUpdateInviteType *body = NCProtoGroupUpdateInviteType.alloc.init;
    body.inviteType = inviteType;
    
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
}


NCProtoNetMsg * CreateGroupJoinApproved(NCProtoNetMsg *join_msg,
                                        NSData * group_private_key, 
                                        NSString *group_name, 
                                        const std::string &from_public_key,
                                        const std::string &to_public_key, 
                                        const std::string &pri_key 

) {
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    head.toPubKey = bytes2nsdata(to_public_key);
    
    
    NCProtoGroupJoinApproved *body = NCProtoGroupJoinApproved.alloc.init;
    body.joinMsg = join_msg;
    body.groupName = group_name;
    
    
    std::string p2pPubkey = nsdata2bytes(join_msg.head.fromPubKey);
    std::string prikeyEncry = [CPBridge coreEcdhEncodeMsg:nsdata2bytes(group_private_key) prikey:pri_key toPubkey:p2pPubkey];
    body.groupPrivateKey = bytes2nsdata(prikeyEncry);
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
    
}


NCProtoNetMsg * CreateDeleteCacheMsg( NCProtoDeleteAction action,
                                            int64_t hash, 
                                            const std::string  &related_pub_key,  
                                            const std::string &from_public_key,
                                            const std::string &pri_key 
) {
    
    
    NCProtoHead *head = NCProtoHead.alloc.init;
    head.fromPubKey = bytes2nsdata(from_public_key);
    
    
    NCProtoDeleteCacheMsg *body = NCProtoDeleteCacheMsg.alloc.init;
    body.action = action;
    body.hash_p = hash;
    
    NSData *pdata = bytes2nsdata(related_pub_key);
    body.relatedPubKey = pdata;
    
    
    NCProtoNetMsg *pack = CreateNetMsgPackFillName(body, head);
    FillSignature(pack, pri_key);
    return pack;
}





int32_t GetAppVersion() {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSArray *vers = [app_Version componentsSeparatedByString:@"."];
    int32_t v = 0;
    v += ([vers[0] intValue] * 10000);
    v += ([vers[1] intValue] * 100);
    v += ([vers[2] intValue] * 1);
    return v;
}

static NSMutableDictionary *_ActionNamesMap;

@implementation MessageObjects

#ifndef NSValuePoint
#define NSValuePoint(point)  [NSValue valueWithPointer:point]
#endif
+ (void)configAction {
    _ActionNamesMap = NSMutableDictionary.dictionary;
    _ActionNamesMap[NCProtoRegisterRsp.descriptor.fullName] =  NSValuePoint(@selector(actionForRegisterRsp:));
    _ActionNamesMap[NCProtoText.descriptor.fullName] =  NSValuePoint(@selector(actionForText:));
    _ActionNamesMap[NCProtoAudio.descriptor.fullName] = NSValuePoint(@selector(actionForAudio:));
    _ActionNamesMap[NCProtoImage.descriptor.fullName] = NSValuePoint(@selector(actionForImage:));
    
    _ActionNamesMap[NCProtoServerReceipt.descriptor.fullName] = NSValuePoint(@selector(actionForServerReceipt:));
    _ActionNamesMap[NCProtoCacheMsgRsp.descriptor.fullName] = NSValuePoint(@selector(actionForCacheMsgRsp:));
    
    
    _ActionNamesMap[NCProtoRecallMsgNotify.descriptor.fullName] = NSValuePoint(@selector(actionForRecallMsgNotify:));
    _ActionNamesMap[NCProtoRecallMsgFailedNotify.descriptor.fullName] = NSValuePoint(@selector(actionForRecallMsgFailedNotify:));
    
    
    _ActionNamesMap[NCProtoGroupInvite.descriptor.fullName] = NSValuePoint(@selector(actionForGroupInvite:));
    _ActionNamesMap[NCProtoGroupJoin.descriptor.fullName] = NSValuePoint(@selector(actionForGroupJoin:));
    
    _ActionNamesMap[NCProtoGroupUpdateName.descriptor.fullName] = NSValuePoint(@selector(actionForGroupUpdateName:));
    _ActionNamesMap[NCProtoGroupUpdateNotice.descriptor.fullName] = NSValuePoint(@selector(actionForGroupUpdateNotice:));
    _ActionNamesMap[NCProtoGroupUpdateNickName.descriptor.fullName] = NSValuePoint(@selector(actionForGroupUpdateNickName:));
    
    _ActionNamesMap[NCProtoGroupText.descriptor.fullName] = NSValuePoint(@selector(actionForGroupText:));
    _ActionNamesMap[NCProtoGroupAudio.descriptor.fullName] = NSValuePoint(@selector(actionForGroupAudio:));
    _ActionNamesMap[NCProtoGroupImage.descriptor.fullName] = NSValuePoint(@selector(actionForGroupImage:));
    
    _ActionNamesMap[NCProtoGroupGetMsgRsp.descriptor.fullName] = NSValuePoint(@selector(actionForGroupGetMsgRsp:));
    
    _ActionNamesMap[NCProtoGroupDismiss.descriptor.fullName] = NSValuePoint(@selector(actionForGroupDismiss:));
    
    _ActionNamesMap[NCProtoGroupKickRsp.descriptor.fullName] = NSValuePoint(@selector(actionForGroupKickRsp:));
    _ActionNamesMap[NCProtoGroupKick.descriptor.fullName] = NSValuePoint(@selector(actionForGroupKick:));
    _ActionNamesMap[NCProtoGroupQuit.descriptor.fullName] = NSValuePoint(@selector(actionForGroupQuit:));
    _ActionNamesMap[NCProtoGroupUpdateInviteType.descriptor.fullName] = NSValuePoint(@selector(actionForGroupUpdateInviteType:));
    
    _ActionNamesMap[NCProtoGroupJoinApproveNotify.descriptor.fullName] = NSValuePoint(@selector(actionForGroupJoinApproveNotify:));
    _ActionNamesMap[NCProtoGroupJoinApproved.descriptor.fullName] = NSValuePoint(@selector(actionForGroupJoinApproved:));
    _ActionNamesMap[NCProtoLogonNotify.descriptor.fullName] = NSValuePoint(@selector(actionForLogonNotify:));
    
    
    _ActionNamesMap[NCProtoGroupGetUnreadRsp.descriptor.fullName] = NSValuePoint(@selector(actionForGroupGetUnreadRsp:));
    _ActionNamesMap[NCProtoGroupGetMemberRsp.descriptor.fullName] = NSValuePoint(@selector(actionForGroupGetMemberRsp:));
}


+ (SEL)actionSelectorForPack:(NSString *)pbname {
    
    SEL method = (SEL)[_ActionNamesMap[pbname] pointerValue];
    return method;
}



+ (NSData * _Nullable)encodeNetMsg:(NCProtoNetMsg *)pack {
    MsgPack bytes;
    bytes.pack = pack.data;
    uint32_t checksum = adler32(1, (const Byte *)bytes.pack.bytes, bytes.pack.length);
    bytes.checksum = checksum;
    bytes.length = bytes.pack.length + kChecksumLen;
    
    int total = bytes.length + kHeaderLen;
    char *buff = (char *)malloc(sizeof(char) * (total + 10));
    
    
    __uint32_t len = htonl(bytes.length);
    memcpy(buff, &len, kHeaderLen);
    
    memcpy(buff + kHeaderLen, bytes.pack.bytes, bytes.pack.length);
    
    __uint32_t checksum_nl= htonl(bytes.checksum);
    memcpy(buff + kHeaderLen + bytes.pack.length, &checksum_nl, kChecksumLen);
    
    NSData *data = [NSData dataWithBytes:buff length:total];
    free(buff);
    return data;
}

+ (NCProtoNetMsg *_Nullable)decodePackFrom:(NSData *)data {
    
    if (!data ||
        ![data isKindOfClass:NSData.class] ||
        data.length == 0 ||
        data == NULL ||
        [data isEqual: NSNull.null]) {
        NSLog(@"coremsg-decode-nil");
        return nil;
    }
    
    char *buffer =  (char *)data.bytes;
    if (buffer == NULL) {
        NSLog(@"coremsg-decode-nil-1");
        return nil;
    }
    
    MsgPack pack;
    memcpy(&pack.length, buffer, kHeaderLen);
    
    uint32_t body_check_len = ntohl(pack.length);
    if (body_check_len+kHeaderLen > data.length) {
        NSLog(@"coremsg-decode-nil-2");
        return nil;
    }
    
    uint32_t body_len = body_check_len - kChecksumLen;
    
    NSRange body_range = NSMakeRange(kHeaderLen, body_len);
    NSData *body_data = [data subdataWithRange:body_range];
    pack.pack = body_data;
    
    
    
    
    
    
    memcpy(&pack.checksum, buffer+kHeaderLen + body_len, kChecksumLen);
    
    uint32_t checksum_cal = adler32(1, (const Byte *)pack.pack.bytes, pack.pack.length);
    uint32_t checksum_recieve = ntohl(pack.checksum);
    
    if (checksum_cal != checksum_recieve) {
        NSLog(@"coremsg-checksum-fail");
        return nil;
    }
    
    NSError *err;
    NCProtoNetMsg *nm = [NCProtoNetMsg parseFromData:pack.pack error:&err];
    if (err) {
        NSLog(@"coremsg-parseFromData-err");
        return nil;
    }
    
    if ([self shouldCheckSign:nm]) {
        BOOL valid = CheckSignature(nm);
        if (!valid) {
            NSLog(@"coremsg-CheckSignature-err");
            return nil;
        }
    }
    
    
    return nm;
}

+ (BOOL)shouldCheckSign:(NCProtoNetMsg *)msg {
    
    if ([msg.name isEqualToString:NCProtoText.descriptor.fullName]) {
        return YES;
    }
    if ([msg.name isEqualToString:NCProtoAudio.descriptor.fullName]) {
        return YES;
    }
    if ([msg.name isEqualToString:NCProtoImage.descriptor.fullName]) {
        return YES;
    }
    return false;
}

@end
