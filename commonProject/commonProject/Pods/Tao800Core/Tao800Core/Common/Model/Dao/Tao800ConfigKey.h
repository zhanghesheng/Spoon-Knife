//
//  TBBConfigKey.h
//  universalT800
//
//  Created by enfeng on 13-10-8.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum _Tao800ConfigKey {
    Tao800ConfigKeyUserIdentity = -100000, //用户身份    
    Tao800ConfigKeySearchKeywords, //搜索历史
    Tao800ConfigKeyStartImageDatas, //获取启动图数据
    Tao800ConfigKeyStartBigBannerData, //获取启动广告大图，首页可滑动的大图
    Tao800ConfigKeyUserState, //保存老用户状态
    Tao800ConfigKeyAppUpdated, //保存应用更新时间
    Tao800ConfigKeyHomeBubbleState, //保存首页Bubble 状态
    Tao800ConfigKeyTagsOfRecommend, //首页推荐分类
    Tao800ConfigKeyAppLastActiveTime, //记录用户上一次启动或者从后台切换到前台的时间
    Tao800ConfigKeyBabyBirthday,    //宝贝生日信息
    Tao800ConfigKeyBabySex,    //宝贝性别信息
    Tao800ConfigKeyFirstTimeGoToMYPage, //第一次进入母婴页面
    Tao800ConfigKeyFirstTimeShowMYLabelSet,//只显示一次母婴页面，设置提示label
    Tao800ConfigKeyFirstTimeShowMYLabelReset,//只显示一次母婴页面，重新设置显示label
    Tao800ConfigKeyOperationModel,  //首页5模块信息
    Tao800ConfigKeyUserStudentIdentity,
    Tao800ConfigKeyPromotionHomeModel, //大促首页配置
} Tao800ConfigKey;