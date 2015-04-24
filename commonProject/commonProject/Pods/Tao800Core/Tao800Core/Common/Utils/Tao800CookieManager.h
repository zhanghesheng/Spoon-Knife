//
//  Tao800CookieManager.h
//  tao800
//
//  Created by worker on 14-3-5.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//
//  cookie管理器

#import <Foundation/Foundation.h>

@interface Tao800CookieManager : NSObject

// 自动清cookie
+ (void)autoRemoveCookie;

// 手动清cookie
+ (void)manualRemoveCookie;

+ (void)removeAllCookie;

+ (void)removeCookieByDomain:(NSString *)domain;

+ (void)removeTaobaoCookieByCookieName:(NSString *)cookieName;

@end
