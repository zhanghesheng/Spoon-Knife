//
//  Tao800AddressBVO.h
//  tao800
//
//  Created by LeAustinHan on 14-5-4.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tao800AddressListVo;
@interface Tao800AddressBVO : NSObject

//封装地址列表数据
+ (NSArray *)wrapperAddressList:(NSArray *)tags;

+ (Tao800AddressListVo *)wrapperAddressVo:(NSDictionary *)item;

//增加用户参数
+ (void)addUserInfo:(NSMutableDictionary *)dic;

@end
