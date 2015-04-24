//
//  Tao800PromotionHomeOperationVo.h
//  Tao800Core
//
//  Created by suminjie on 15-1-30.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800StaticConstant.h"
#import "Tao800PromotionHomeSettingVo.h"
#import "Tao800PromotionHomePictureVo.h"
#import "Tao800PromotionHomePromotionVo.h"

typedef  NS_ENUM(NSInteger, Tao800PromotionOperationHomeKey) {
    Tao800PromotionOperationHomeKeyToday = 1,    //今日更新
    Tao800PromotionOperationHomeKeyDailyTen = 2, //每日10件
    Tao800PromotionOperationHomeKeyNotice = 3, //精品预告
    Tao800PromotionOperationHomeKeyMobile = 4, //手机周边
    Tao800PromotionOperationHomeKeyNinePointNine = 5, //9.9
    Tao800PromotionOperationHomeKeySaunter = 6, //值得逛
    Tao800PromotionOperationHomeKeyLottery = 7, //0元抽奖
};

@interface Tao800PromotionHomeOperationVo : NSObject<NSCoding>

@property (nonatomic,strong) Tao800PromotionHomePictureVo *promotionHomePictureVo;

@property (nonatomic,strong) NSArray *settingArray;
@property (nonatomic,strong) NSArray *promotionArray;
@property (nonatomic,strong) NSArray *iconsArray;
@property (nonatomic,strong) NSString* tip;             //商品列表标题(标题前面的附加的小文字，用来特殊情况的说明)

@property (nonatomic,assign) BOOL showPromotionHomePage; //今日是否是大促
@property (nonatomic,assign) BOOL showTaobaoTip;        //是否展示淘宝提示
@property (nonatomic,assign) BOOL showTianmaoTip;       //是否展示天猫提示
@property (nonatomic,assign) BOOL showShopTip;          //是否展示特卖商城提示

@property (nonatomic,assign) Tao800PromotionOperationHomeKey operationHomeKey;

+(Tao800PromotionHomeOperationVo*) wrapperOperationVo:(NSDictionary*)dic;

@end
