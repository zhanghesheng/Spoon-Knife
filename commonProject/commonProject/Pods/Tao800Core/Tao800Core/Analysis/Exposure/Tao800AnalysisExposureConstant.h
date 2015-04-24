//
//  Tao800AnalysisExposureConstant.h
//  Tao800Core
//
//  Created by enfeng on 15/3/10.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, Tao800AnalysisExposurePostType) {
    Tao800AnalysisExposurePostTypeHome = 1,   //首页
    Tao800AnalysisExposurePostTypePromotionHome = 101111,   //大促首页
    Tao800AnalysisExposurePostTypeJvTag = 2,   //分类（除母婴）
    Tao800AnalysisExposurePostTypeMuYing = 3,  //母婴单品
    Tao800AnalysisExposurePostTypeSearch = 4,  //搜索页
    Tao800AnalysisExposurePostTypeBdlst = 5,  //品牌商品页
    Tao800AnalysisExposurePostTypeTopic = 6,  //专题页面
    Tao800AnalysisExposurePostTypePhone = 7,  //手机周边
    Tao800AnalysisExposurePostTypeToday = 8,  //今日更新
    Tao800AnalysisExposurePostTypeYugao = 9,  //精品预告
    Tao800AnalysisExposurePostTypeTen = 10,  //每日十件
    Tao800AnalysisExposurePostTypeMyFavorite = 11,  //我的收藏
    Tao800AnalysisExposurePostTypeCoupon = 12,  //使用优惠券
};

//记录曝光打点入口参数
typedef NS_ENUM(NSInteger, Tao800ExposureRefer) {
    Tao800ExposureReferHome = 1, //首页
    Tao800ExposureReferPromotionHome = 101111, //大促首页
    Tao800ExposureReferHomeTag = 2, //分类首页
    Tao800ExposureReferLaunchBigBanner = 3, //开机大图
    Tao800ExposureReferHomePromotionGif = 4, //首页悬挂大促banner
    Tao800ExposureReferHomeBanner = 5, //首页轮播banner
    Tao800ExposureReferPush = 6, //push
    Tao800ExposureReferTagBanner = 7, //聚分类banner“jutag”
    Tao800ExposureReferHomeOperation = 8, //首页下方运营位“homeope”
    Tao800ExposureReferHomePromotionOperation = 9, //新大促首页下方运营位“acthomeope”
    Tao800ExposureReferCalendar = 10, //签到页面
    Tao800ExposureReferMyCoupon = 11, //个人中心我的优惠券
};

//记录曝光打点入口的参数 Tao800ExposureRefer
extern NSString *const Tao800ExposureReferParam;
extern NSString *const Tao800ExposurePostTypeParam;

@interface Tao800AnalysisExposureConstant : NSObject

+ (NSString *)postTypeWith:(Tao800AnalysisExposurePostType)postType;

+ (NSString *)referWith:(Tao800ExposureRefer)exposureRefer;

@end
