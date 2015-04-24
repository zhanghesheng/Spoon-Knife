//
//  Tao800PromotionHomePromotionVo.h
//  Tao800Core
//
//  Created by suminjie on 15-1-30.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  NS_ENUM(NSInteger, Tao800PromotionHomePromotionHomeKey) {
    Tao800PromotionHomePromotionHomeKeyURL = 1, //URL
    Tao800PromotionHomePromotionHomeKeyCategory = 2, //分类
    Tao800PromotionHomePromotionHomeKeyDealDetail = 3, //商品详情
    Tao800PromotionHomePromotionHomeKeyPromotion = 4, //大促接口
    Tao800PromotionHomePromotionHomeKeyDealListTopic = 5, //商品列表（专题）
    Tao800PromotionHomePromotionHomeKeyGroupDealListTopic = 6, //分栏商品列表（专题）
    Tao800PromotionHomePromotionHomeKeyMall = 7, //特卖商城
    Tao800PromotionHomePromotionHomeKeyMyCoupon = 8, //我的优惠券
    Tao800PromotionHomePromotionHomeKeyMyFittingRoom = 9, //我的试衣间
    Tao800PromotionHomePromotionHomeKeyLockTopic = 10, //专题解锁
    Tao800PromotionHomePromotionHomeKeyDealDetailShop = 31 //特卖商城
};

@interface Tao800PromotionHomePromotionVo : NSObject<NSCoding>

@property (nonatomic,strong) NSString* content;
@property (nonatomic,strong) NSString* image;
@property (nonatomic,strong) NSNumber* point;
@property (nonatomic,strong) NSString* value;
@property (nonatomic,strong) NSNumber* homekey;     //homekey
@property (nonatomic,strong) NSArray *promotionTopicArray;
@property (nonatomic,strong) NSMutableArray *promotionTagArray;
@property (nonatomic,strong) NSNumber* bannerId;//for专题解锁

@property (nonatomic,assign) Tao800PromotionHomePromotionHomeKey promotionHomePromotionHomeKey;

+(Tao800PromotionHomePromotionVo*) wrapperPromotionVo:(NSDictionary*)dict;
@end
