//
//  Tao800CheckConfigTaoBaoSwitchBVO.m
//  tao800
//
//  Created by enfeng on 14-5-14.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800CheckConfigTaoBaoSwitchBVO.h"
#import "TBCore/NSDictionaryAdditions.h"
#import "Tao800CheckConfigTaoBaoSwitchCookieBVO.h"

@implementation Tao800CheckConfigTaoBaoSwitchBVO

+ (Tao800CheckConfigTaoBaoSwitchBVO *)convertTao800CheckConfigTaoBaoSwitchBVO:(NSDictionary *)dict {
    Tao800CheckConfigTaoBaoSwitchBVO *taoBaoSwitchBVO = [[Tao800CheckConfigTaoBaoSwitchBVO alloc] init];
    NSNumber *cookieCet = [dict objectForKey:@"cookie_cet" convertNSNullToNil:YES];
    NSNumber *h5pj = [dict objectForKey:@"zhe800_h5_pj" convertNSNullToNil:YES];
    NSArray *cookieBlacklist = [dict objectForKey:@"cookie_blacklist" convertNSNullToNil:YES];

    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:10];
    for (NSDictionary *item in cookieBlacklist) {
        NSString *cookieName = [item objectForKey:@"cookie_name" convertNSNullToNil:YES];
        NSString *domain = [item objectForKey:@"domain" convertNSNullToNil:YES];
        Tao800CheckConfigTaoBaoSwitchCookieBVO *cookieBVO = [[Tao800CheckConfigTaoBaoSwitchCookieBVO alloc] init];
        cookieBVO.cookieName = cookieName;
        cookieBVO.domainUrl = domain;
        [mutableArray addObject:cookieBVO];
    }
    taoBaoSwitchBVO.cookieBlacklist = mutableArray;
    taoBaoSwitchBVO.urlBlacklist = [dict objectForKey:@"url_blacklist" convertNSNullToNil:YES];
    taoBaoSwitchBVO.cookieCet = [cookieCet boolValue];
    taoBaoSwitchBVO.zhe800H5Pj = (CheckConfigTaoBaoSwitchBVO)[h5pj intValue];

    return taoBaoSwitchBVO;
}


@end
