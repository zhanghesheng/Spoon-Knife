//
//  Tao800AutoLoginManager.h
//  tao800
//
//  Created by worker on 14-3-12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//
//  自动登录管理器

#import <Foundation/Foundation.h>
#import "TBService/TBPassportApi.h"

@interface Tao800AutoLoginManager : NSObject <TBPassportApiDelegate>
{
    TBPassportApi *_passportApi;
}

@property (nonatomic, strong)NSDictionary *autoLoginParams;
@property (nonatomic, strong)NSString *mergePhoneNumber;

- (void) taobaoLogin;

- (void)autoLogin;
- (void)logout;
- (void)checkTaobaoLogin;

@end
