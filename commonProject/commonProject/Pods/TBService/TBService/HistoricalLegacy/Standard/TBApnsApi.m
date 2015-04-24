//
//  TBApnsApi.m
//  Core
//
//  Created by enfeng yang on 12-2-7.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import "TBApnsApi.h"
#import "TBCore/NSString+Addition.h"
#import "TBLogAnalysisBaseHeader.h"

NSString *const URLApnsProviderAddToken = @"http://m.api.tuan800.com";
NSString *const URLPushLoginLogout = @"http://m.api.tuan800.com";
//#define URLPushLoginLogout       @"http://116.255.244.36/apns/user"

@implementation TBApnsApi

@synthesize baseURLApnsProviderAddToken = _baseURLApnsProviderAddToken;
@synthesize baseURLPushLoginLogout = _baseURLPushLoginLogout;

- (id) init {
    self = [super init];
    if (self) {
        self.baseURLApnsProviderAddToken = URLApnsProviderAddToken;
        self.baseURLPushLoginLogout = URLPushLoginLogout;
    }
    return self;
}

- (void)dealloc
{
 
}

/**
 需要增加一个参数, recievemsg 1:接收通知  0:不接收通知
 
 'testkey' + '|' + product + '|' + mac + '|' + deviceid + '|' + platform + '|' + token
 On 2012-5-16, at 下午6:36, 方凌 wrote:
 
 * 向服务器发送token
 * @params
 *   key: deviceid(NSString*) 手机设备id
 *   key: deviceToken(NSString*)
 *   key: recievemsg(NSString*) 1:接收通知  0:不接收通知
 */
- (void)sendDeviceToken:(NSDictionary *)params {
    /**
     MD5=(sec_key:device_id:device_token)
     值为：
     base64.encode(
     sec_key:device_id:device_token:MD5
     )
     */

    NSString *recievemsg = [params objectForKey:@"recievemsg"];
    NSString *deviceid = @"1";
    NSString *deviceToken = [params objectForKey:@"deviceToken"];
    NSString *product = [params objectForKey:@"product"];
    NSString *macAddress = [params objectForKey:@"macAddress"];
    NSString *platform = [params objectForKey:@"platform"]; //iphone , ipad, ...
    NSString *secKey = @"testkey";
    NSString *userRole = [params objectForKey:@"userRole"];
    NSString *userType = [params objectForKey:@"userType"];
    NSString *userId = [params objectForKey:@"userId"];
    if ([platform isEqualToString:@"iPod touch"]) {
        platform = @"iPod";
    }

    NSArray *arrParams = [NSArray arrayWithObjects:secKey, product, macAddress, deviceid, platform, deviceToken, recievemsg, nil];

    NSString *md5Str = [arrParams componentsJoinedByString:@"|"];
    md5Str = [md5Str md5];
    NSArray *queryParams = [NSArray arrayWithObjects:
            [NSString stringWithFormat:@"product=%@", product],
            [NSString stringWithFormat:@"mac=%@", macAddress],
            [NSString stringWithFormat:@"deviceid=%@", deviceid],
            [NSString stringWithFormat:@"token=%@", deviceToken],
            [NSString stringWithFormat:@"recievemsg=%@", recievemsg],
            [NSString stringWithFormat:@"platform=%@", platform],
            [NSString stringWithFormat:@"md5=%@", md5Str],nil];
    NSString *queryStr = [queryParams componentsJoinedByString:@"&"];
    if (userRole) {
        queryStr = [NSString stringWithFormat:@"%@&user_role=%@",queryStr,userRole];
    }
    if (userType) {
        queryStr = [NSString stringWithFormat:@"%@&user_type=%@",queryStr,userType];
    }
    if(userId){
        queryStr = [NSString stringWithFormat:@"%@&user_id=%@",queryStr,userId];
    }

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/push/user?%@", _baseURLApnsProviderAddToken, queryStr]];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:@"GET"];
    request.serviceMethodFlag = APIApnsSendDeviceToken;
    request.serviceData = params;
    [self send:request];
}

/**
* 当用户登陆或注销成功后，把绑定信息传给服务端
* @params
*  key: headerVo(TN800AnalysisBaseHeaderVo*)
*  key: userid(NSString*)
*  key: macAddress(NSString*)
*  key: logout(NSString*) 1:退出 0:登录
*/
- (void)sendUserDeviceInfo:(NSDictionary *)params {
    TBLogAnalysisBaseHeader *headerVo = [params objectForKey:@"headerVo"];
    NSString *macAddress = [params objectForKey:@"macAddress"];
    NSString *userid = [params objectForKey:@"userid"];
    NSString *logout = [params objectForKey:@"logout"];
    NSString *deviceToken = [params objectForKey:@"deviceToken"];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/apns/user", _baseURLPushLoginLogout]];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = APIApnsSendUserDeviceInfo;
    request.serviceData = params;

    NSString *testkey = @"testkey";
    //md5(testkey|op|product|mac|user|model|token)
    NSArray *arr = [NSArray arrayWithObjects:testkey, logout, headerVo.appName, macAddress, userid, headerVo.phoneModel, deviceToken, nil];
    NSString *mk = [arr componentsJoinedByString:@"|"];
    mk = [mk md5];

    [request setPostValue:macAddress forKey:@"mac"];
    [request setPostValue:userid forKey:@"user"];
    [request setPostValue:headerVo.phoneModel forKey:@"model"];
    [request setPostValue:headerVo.appName forKey:@"product"];
    [request setPostValue:logout forKey:@"op"];
    [request setPostValue:deviceToken forKey:@"token"];
    [request setPostValue:mk forKey:@"md5"];
    [self sendWithoutRequestKey:request];
}

- (void)requestFinished:(TBASIFormDataRequest *)request {
    BOOL isError = [self isResponseDidNetworkError:request];
    if (isError) {
        ASIDownloadCache *sharedCache = [ASIDownloadCache sharedCache];
        [sharedCache removeCachedDataForURL:request.url];
        return;
    }
    NSString *resStr = [request responseString];
    NSDictionary *jsonDict = nil;
    @try {
        jsonDict = [resStr JSONValue];
    }
    @catch (NSException *exception) {
        jsonDict = [NSDictionary dictionary];
    }
    if (jsonDict == nil) {
        jsonDict = [NSDictionary dictionary];
    }
    SEL sel = nil;

    switch (request.serviceMethodFlag) {

        case APIApnsSendUserDeviceInfo: {
            sel = @selector(sendUserDeviceInfoFinish:);
        }
            break;

        case APIApnsSendDeviceToken: {
            sel = @selector(sendDeviceTokenFinish:);
        }
            break;


        default:
            break;
    };

    if (sel && self.delegate && [self.delegate respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.delegate performSelector:sel withObject:jsonDict];
#pragma clang diagnostic pop
    }
    [super requestFinished:request];
}
@end
