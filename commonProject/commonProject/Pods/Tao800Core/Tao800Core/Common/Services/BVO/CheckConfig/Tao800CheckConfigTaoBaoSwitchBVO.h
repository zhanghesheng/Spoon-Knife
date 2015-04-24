//
//  Tao800CheckConfigTaoBaoSwitchBVO.h
//  tao800
//
//  Created by enfeng on 14-5-14.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _CheckConfigTaoBaoSwitchBVO {
    CheckConfigTaoBaoSwitchBVOH5OpenInner = 1, //通过内部WebView跳转
    CheckConfigTaoBaoSwitchBVOH5OpenBrower = 2, //通过系统浏览器跳转
} CheckConfigTaoBaoSwitchBVO;

@interface Tao800CheckConfigTaoBaoSwitchBVO : NSObject

@property(nonatomic, strong) NSArray *urlBlacklist;   //返回域名和URL，支持多个
@property(nonatomic, strong) NSArray *cookieBlacklist; //返回域名和cookie对，支持多个; Tao800CheckConfigTaoBaoSwitchCookieBVO
@property(nonatomic) BOOL cookieCet;     //1. cookie_cet:是否每次启动WebView都清除指定的cookie, true:启动清除，false：不处理
@property(nonatomic) CheckConfigTaoBaoSwitchBVO zhe800H5Pj;

+ (Tao800CheckConfigTaoBaoSwitchBVO*) convertTao800CheckConfigTaoBaoSwitchBVO:(NSDictionary *) dict;
@end
