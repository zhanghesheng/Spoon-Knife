//
//  Tao800PaymentPayFinishUnipayBVO.h
//  tao800
//
//  Created by enfeng on 14/11/12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800PaymentPayFinishUnipayBVO : NSObject

@property(nonatomic, copy) NSString *respCode;
@property(nonatomic, copy) NSString *tn;
@property(nonatomic, copy) NSString *signMethod;
@property(nonatomic, copy) NSString *transType;
@property(nonatomic, copy) NSString *charset;
@property(nonatomic, copy) NSString *signature;
@property(nonatomic, copy) NSString *version;

+ (Tao800PaymentPayFinishUnipayBVO *)convertUniPayFinishWeixinBVOWith:(NSDictionary *)dict;
@end
