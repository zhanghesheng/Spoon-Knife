//
//  Tao800ForwardConstant.h
//  Tao800Core
//
//  Created by 恩锋 杨 on 15/1/16.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, Tao800WindowKey) {
    Tao800WindowKeyLaunch = 1,   //引导图
    Tao800WindowKeyUserType = 2, // 用户身份选择
    Tao800WindowKeyStartBanner = 3, //开机广告大图
    Tao800WindowKeyStartWeb = 4, //普通web页面
    Tao800WindowKeyDealDetail = 5, //商品详情页面
    Tao800WindowKeyFirstOrderReward = 6, //首单返利
    Tao800WindowKeyUpgrade = 7, //升级提醒
    Tao800WindowKeyAppComment = 8, //App评价
    Tao800WindowKeyTaobaoMergeTip = 9, //首页启动调起的淘宝第三方账号合并提示页面
    Tao800WindowKeyCategoryTip = 10,//分类蒙层
    Tao800WindowKeyCrashTip = 11,//崩溃提示

    Tao800WindowKeyTopic = 12,//单栏专题
    Tao800WindowKeySaunterTopic = 13,//值得逛专题
    Tao800WindowKeyLockTopic = 14,//解锁专题
    Tao800WindowKeySectionTopic = 15,//分栏专题
    Tao800WindowKeyCommonWeb = 16,//通用web
    Tao800WindowKeyInteractionWeb = 17,//用于和h5页面交互，类似原生页面
    Tao800WindowKeySaunter = 18,//值得逛
    Tao800WindowKeyMobileNearby = 19,//手机周边
    Tao800WindowKeyForenotice = 20,//精选预告
    Tao800WindowKeyCheckIn = 21,//签到
    Tao800WindowKeyTen = 22,//每日十条
    Tao800WindowKeyToday = 23,//今日更新
    Tao800WindowKeyLottery = 24,//0元抽奖
    Tao800WindowKeyPromotionNotice = 25,//大促预告

    Tao800WindowKeyHome = 26,//首页
    Tao800WindowKeyTag = 27,//分类首页
};

@interface Tao800ForwardConstant : NSObject

@end
