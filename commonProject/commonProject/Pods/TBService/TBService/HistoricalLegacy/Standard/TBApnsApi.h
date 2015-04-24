//
//  TBApnsApi.h
//  Core
//
//  Created by enfeng yang on 12-2-7.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBBaseNetworkApi.h"

@protocol TBApnsApiDelegate <TBBaseNetworkDelegate>
@optional 
/**
 * key:status 0:成功
 */
- (void) sendDeviceTokenFinish:(NSDictionary*) params; 
- (void) sendUserDeviceInfoFinish:(NSDictionary *)params;
@end


@interface TBApnsApi : TBBaseNetworkApi
{
    NSString *_baseURLApnsProviderAddToken;
    NSString *_baseURLPushLoginLogout;
}

@property (nonatomic,copy) NSString *baseURLApnsProviderAddToken;
@property (nonatomic,copy) NSString *baseURLPushLoginLogout;

/**
 * 向服务器发送token
 * @params
 *   key: deviceid(NSString*) 手机设备id, 改为传网卡地址
 *   key: deviceToken(NSString*)
 *   key: recievemsg(BOOL) YES:接收通知  NO:不接收通知
 */
- (void)sendDeviceToken:(NSDictionary *)params;

/**
 * 当用户登陆或注销成功后，把绑定信息传给服务端
 * 不需要carrier参数
 * @params
 *  key: headerVo(TN800AnalysisBaseHeaderVo*)
 *  key: userid(NSString*)
 *  key: macAddress(NSString*)
 *  key: logout(NSString*) 1:退出 0:登录
 */
- (void) sendUserDeviceInfo:(NSDictionary *)params;
@end
