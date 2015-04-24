//
//  Tao800PushManage.h
//  tao800
//
//  Created by enfeng on 12-8-29.
//
//

#import <Foundation/Foundation.h>
#import "TBService/TBApnsApi.h"
#import "Tao800Service.h"

typedef enum {
    Tao800PushManageProviderAddPush,
    Tao800PushManageProviderCancelPush
} Tao800PushManageProviderPushType;

@interface Tao800PushManage : NSObject <TBApnsApiDelegate, UIAlertViewDelegate> {
    NSDictionary *_pushDict;
    TBApnsApi *_aPNSApi;
    Tao800PushManageProviderPushType _pushType;
}
@property(nonatomic, retain) NSDictionary *pushDict;
@property(nonatomic, retain) TBApnsApi *aPNSApi;
@property(nonatomic, strong) Tao800Service * tao800Service;

+(Tao800PushManage *)shareInstance;

- (void)sendToken:(NSString *)token pushType:(Tao800PushManageProviderPushType)pPushType;

- (void)showPush:(NSDictionary *)userInfo active:(BOOL)applicationIsActive;

- (void)clearRemoteNotification:(UIApplication *)application fore:(BOOL)force;

//请求并加载远程通知
- (void)loadRemoteNotifications;

//如果弹出过push通知，那么记录一下
-(void)addToDmIfNotificationFinishedPushed:(NSDictionary *)onePushDic;
- (void)forwardToTopicActivity:(NSString *)topicId;

@end