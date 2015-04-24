//
//  Tao800PaymentProductVo.h
//  tao800
//
//  Created by enfeng on 14-5-4.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _PaymentProductPostType{
    PaymentProductPostTypeFree = 0,    //包邮
    PaymentProductPostTypePostage = 1,  //1部分地区不包邮
}PaymentProductPostType;


@interface Tao800PaymentProductVo : NSObject

@property(nonatomic, copy) NSString *sellerId;
@property(nonatomic, copy) NSString *tradeCode; //Z0001, 积分兑换类
@property(nonatomic, copy) NSString *productId;
@property(nonatomic, copy) NSString *skuNum; //组合方式: pId-vId:pId-vId, 必须保证顺序正确，第一个取自prop_1,第二个prop_2

@property(nonatomic, copy) NSString* sku1;
@property(nonatomic, copy) NSString* sku2;

@property(nonatomic, copy) NSString *score;
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *imageUrl;
@property(nonatomic) int maxBuyLimit;
@property(nonatomic) int stockCount; //库存

//邮费相关
@property(nonatomic) PaymentProductPostType postType;
@property(nonatomic, copy) NSString *noFree;          //不包邮地区编号, 逗号隔开
@property(nonatomic, copy) NSString *firstPostPrice;  //首件邮费
@property(nonatomic, copy) NSString *addPostPrice;    //每增加一件，邮费增加


@end
