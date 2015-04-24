//
//  Tao800OrderVo.h
//  tao800
//
//  Created by hanyuan on 13-4-16.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800OrderVo : NSObject
{
    NSString *orderId; //订单号
    NSString *dealId; //商品编号
    NSString *title;
    NSString *description;
    
    int originPrice;
    int price;
    NSString *discount;
    NSString *imgUrl;
    NSString *createTime;
}

@property(nonatomic, copy)NSString *orderId;
@property(nonatomic, copy)NSString *dealId;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *description;
@property(nonatomic, assign)int originPrice;
@property(nonatomic, assign)int price;
@property(nonatomic, copy)NSString *discount;
@property(nonatomic, copy)NSString *imgUrl;
@property(nonatomic, copy)NSString *createTime;

@end
