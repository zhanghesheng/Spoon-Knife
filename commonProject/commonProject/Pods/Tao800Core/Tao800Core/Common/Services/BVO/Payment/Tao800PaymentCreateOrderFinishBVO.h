//
//  Tao800PaymentCreateOrderFinishBVO.h
//  tao800
//
//  Created by enfeng on 14-5-4.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800PaymentCreateOrderFinishBVO : NSObject

@property (nonatomic) BOOL successful;   //订单是否创建成功
@property (nonatomic, copy) NSString* orderNo; //订单编号
@property (nonatomic, strong) NSNumber* totalFee; //订单总金额
@property (nonatomic, copy) NSString* errorCode;
@property (nonatomic, copy) NSString* errorMessage;

+ (Tao800PaymentCreateOrderFinishBVO *) convertCreateOrderFinishBVOWith:(NSDictionary *) dict;
@end
