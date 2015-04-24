//
//  Tao800CookieManager.m
//  tao800
//
//  Created by worker on 14-3-5.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800CookieManager.h"
#import "TBNetwork/ASIHTTPRequest.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800FunctionCommon.h"
#import "Tao800ConfigBVO.h"
#import "Tao800CheckConfigTaoBaoSwitchBVO.h"
#import "Tao800CheckConfigTaoBaoSwitchCookieBVO.h"
#import "Tao800NotifycationConstant.h"
#import "TBCore/TBCore.h"

@implementation Tao800CookieManager

#pragma mark 自动清cookie
+ (void)autoRemoveCookie {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    Tao800ConfigBVO *configBVO =  dm.configBVO;
    Tao800CheckConfigTaoBaoSwitchBVO *taoBaoSwitchBVO = configBVO.taoBaoSwitchBVO;
    if (!taoBaoSwitchBVO) {
        return;
    }
    
    NSDate *currentDate = [NSDate date];
    
    if (dm.oldCurrVersion.length == 0 || ![dm.currentVersion isEqualToString:dm.oldCurrVersion]) {
        //第一次启动软件或升级上来的
        [self didAutoRemoveCookie]; // 覆盖或全新安装清cookie
    }else {
        // 判断最后一次进入应用时间是否等于当前时间
        BOOL isSameDay;
        isSameDay = IsSameDay(currentDate, dm.lastEnterAppDate);
        
        if (!isSameDay) {
            // 不是同一天
            // 判断是否自动清除cookie
            if (dm.isClearTaobaoCookie) {
                [self didAutoRemoveCookie];
            }
        }

    }
    dm.lastEnterAppDate = currentDate;
    [dm archive];
}

#pragma mark 确认执行自动清cookie
+ (void)didAutoRemoveCookie {
    // 清除名称叫cna的淘宝cookie
//    [Tao800CookieManager removeTaobaoCookieByCookieName:@"cna"];
//    // 清除名称叫utkey的淘宝cookie
//    [Tao800CookieManager removeTaobaoCookieByCookieName:@"utkey"];
//    // 清除mmstat.com域名下的cookie
//    [Tao800CookieManager removeCookieByDomain:@"http://mmstat.com"];

    [Tao800CookieManager manualRemoveCookie];
}

#pragma mark 手动清cookie
+ (void)manualRemoveCookie {
    [Tao800CookieManager removeAllCookie];
    
    // 发送自动登录通知
    [[NSNotificationCenter defaultCenter]
     postNotificationName:Tao800CookieManagerDidRemoveCookieNotifyCation
     object:nil];
}

#pragma mark 清除所有cookie
+ (void)removeAllCookie {
    // 清除cookie
//    [ASIHTTPRequest setSessionCookies:nil];
    // 清除淘宝cookie
    [self removeTaobaoCookie];
}

#pragma mark 清除特定域名下的cookie
+ (void)removeCookieByDomain:(NSString *)domain {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = [storage cookiesForURL:[NSURL URLWithString:domain]];
    for (cookie in cookies)
    {
        //NSLog(@"delete cookie name is : %@",cookie.name);
        [storage deleteCookie:cookie];
    }
}

#pragma mark 清除淘宝cookie
+ (void)removeTaobaoCookie {

    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    Tao800ConfigBVO *configBVO =  dm.configBVO;

    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    Tao800CheckConfigTaoBaoSwitchBVO *taoBaoSwitchBVO = configBVO.taoBaoSwitchBVO;
    if (taoBaoSwitchBVO) {
        //根据接口返回删除cookie
        for (Tao800CheckConfigTaoBaoSwitchCookieBVO *cookieBVO in taoBaoSwitchBVO.cookieBlacklist) {
            NSArray *cookies = [storage cookiesForURL:[NSURL URLWithString:cookieBVO.domainUrl]];
            NSString *cName = cookieBVO.cookieName.trim;

            BOOL clearAll = NO;
            if ([cName isEqualToString:@"*"]) {
                clearAll = YES;
            }
            for (cookie in cookies) {
                if (clearAll || [cookie.name isEqualToString:cName]) {
                    [storage deleteCookie:cookie];
                }
            }
        }
    } else {
        //走之前某认的逻辑
        NSArray *urls = @[@"http://taobao.com/",@"http://tmall.com/",@"http://mmstat.com"];

        for (NSString *url in urls) {
            NSArray *cookies = [storage cookiesForURL:[NSURL URLWithString:url]];
            for (cookie in cookies)
            {
                //NSLog(@"delete cookie name is : %@",cookie.name);
                [storage deleteCookie:cookie];
            }
        }
    }
}

#pragma mark 清除淘宝cookie中特定名称cookie
+ (void)removeTaobaoCookieByCookieName:(NSString *)cookieName {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *urls = @[@"http://taobao.com/",@"http://tmall.com/"];
    
    for (NSString *url in urls) {
        NSArray *cookies = [storage cookiesForURL:[NSURL URLWithString:url]];
        for (cookie in cookies)
        {
            //NSLog(@"cookie name is : %@",cookie.name);
            if ([cookie.name isEqualToString:cookieName]) {
                [storage deleteCookie:cookie];
            }
        }
    }
}

@end
