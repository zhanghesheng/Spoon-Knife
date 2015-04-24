//
//  Tao800ShopVo.h
//  tao800
//
//  Created by wuzhiguang on 13-4-22.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//
//  店铺vo

#import <Foundation/Foundation.h>

typedef enum ShopCreditName {
//    ShopCreditNameCap,    //皇冠
            ShopCreditNameRed, //红心
    ShopCreditNameBlue, //蓝钻
    ShopCreditNameCap, //兰冠
    ShopCreditNameCrown, //皇冠
} ShopCreditName;

@interface Tao800ShopVo : NSObject <NSCoding> {

    NSString *_clickUrl; // 店铺连接地址
    ShopCreditName _shopCreditName; // 店铺信誉名称
    int _shopCreditOffset; // 店铺信誉数量
    int _itemsCount; // 商品数量
    NSString *_name; // 店铺名称
    NSString *_picUrl; // 店铺图片
    NSString *_rate; // 好评率
}

@property(nonatomic, copy) NSString *clickUrl;
@property(nonatomic, assign) ShopCreditName shopCreditName;
@property(nonatomic, assign) int shopCreditOffset;
@property(nonatomic, assign) int itemsCount;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *picUrl;
@property(nonatomic, copy) NSString *rate;
@property(nonatomic, strong) NSNumber *shopId;


+ (Tao800ShopVo*) convertJSONShop:(NSDictionary *) jsonItemDict;

@end
