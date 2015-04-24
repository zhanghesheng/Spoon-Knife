//
//  TBUserLogApi.h
//  Core
//  记录用户操作日志
//  Created by enfeng yang on 12-1-16.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TBBaseNetworkApi.h" 
#import "TBLogAnalysisBaseHeader.h"

@protocol TBUserLogApiDelegate <TBBaseNetworkDelegate>
@optional
- (void)didCommitBaseInfo:(NSDictionary *)params;

- (void)logSendFinish:(NSDictionary *)params;
@end

@interface TBUserLogApi : TBBaseNetworkApi {
    TBLogAnalysisBaseHeader *baseHeader;
    BOOL _sendImmediately;

    NSString *_mobileInfoUrl;
    NSString *_mobileLogUrl;
}
@property(nonatomic, assign) BOOL sendImmediately;
@property(nonatomic, retain) TBLogAnalysisBaseHeader *baseHeader;

@property(nonatomic, copy) NSString *mobileInfoUrl;

@property(nonatomic, copy) NSString *mobileLogUrl;

- (void)commitBaseInfoLog;


/**
* 记录用户行为
* @params
*    key:eventId(NSString*)事件标识(如：kEvent_R) 参见: TN800LogConstant
*    key:param(NSDictionary*) 参数　参见: TN800LogConstant  key:参数名(如：kEvent_R)  value:(如：kAbout) 代表进入了关于页面
*/
- (void)addUserAction:(NSDictionary *)params;

/**
 * 获取用户行为基础头信息
 * @params
 *    key:requestKey(NSString*)
 *    key:netType(NSString*) 网络类型wifi,wwan
 *    key:latitude(NSString*) 
 *    key:longitude(NSString*)
 *    key:userid(NSString*) 可以为空字符串
 *    key:verstion(NSString*) 软件版本
 */
- (NSString *)getActionHeader:(NSDictionary *)params;

- (NSString *)getKey:(NSString *)genStr;

- (void)startSend:(NSString *)header;
@end