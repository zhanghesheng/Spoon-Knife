//
//  Tao800PromotionHomeSettingVo.h
//  Tao800Core
//
//  Created by suminjie on 15-1-30.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  NS_ENUM(NSInteger, Tao800PromotionHomeSettingHomeKey) {
    Tao800PromotionHomeSettingHomeKeyToday = 1,    //今日更新
    Tao800PromotionHomeSettingHomeKeyDailyTen = 2, //每日10件
    Tao800PromotionHomeSettingHomeKeyNotice = 3, //精品预告
    Tao800PromotionHomeSettingHomeKeyMobile = 4, //手机周边
    Tao800PromotionHomeSettingHomeKeyNinePointNine = 5, //9.9
    Tao800PromotionHomeSettingHomeKeySaunter = 6, //值得逛
    Tao800PromotionHomeSettingHomeKeyLottery = 7, //0元抽奖
    Tao800PromotionHomeSettingHomeKeySignIn = 8, //签到
};

@interface Tao800PromotionHomeSettingVo : NSObject<NSCoding>

@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) NSString* content;
@property (nonatomic,strong) NSString* image;
@property (nonatomic,strong) NSNumber* point;
@property (nonatomic,strong) NSString* value;
@property (nonatomic,strong) NSNumber* homekey;     //homekey
@property (nonatomic,assign) Tao800PromotionHomeSettingHomeKey promotionHomeSettingHomeKey;

+(Tao800PromotionHomeSettingVo*) wrapperSettingVo:(NSDictionary*)dic;
@end
