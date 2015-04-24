//
//  Tao800ConfigTipBVO.h
//  tao800
//
//  Created by enfeng on 14-2-26.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800ConfigTipBVO : NSObject<NSCoding>

@property (nonatomic, copy) NSString* tao800CloseLoginUrl;
@property (nonatomic, strong) NSMutableDictionary* tao800OutProtocol;
@property (nonatomic, assign) BOOL tao800OutClose;
@property (nonatomic, assign) BOOL isShowPreviewDealButton;
@property (nonatomic, copy) NSString* showPreviewDealTime;
@property (nonatomic, copy) NSString* weixinScore;
@property (nonatomic, copy) NSString* isShowPhoneRechargeButton;
@property(nonatomic, assign)BOOL showFirstOrderEntry;
@property(nonatomic,copy)NSString *firstOrderUrl;

@property (nonatomic, copy) NSString * qqScore;
@property (nonatomic, copy) NSString * checkInRules;
@property (nonatomic, assign) BOOL weixinConcernSwitch;
@property (nonatomic, assign) BOOL baoguangSwitch;
@property (nonatomic, assign) BOOL isUserDefineUrl; //商品详情跳转开关，true,跳转到自定义；否则跳转到淘宝
@property (nonatomic, copy) NSString * inviteFriendsScoreReward;
 
@property (nonatomic, assign) BOOL pushToShareSwitchIsOnOrOff; //用户退出要push,这个是开关
@property (nonatomic, copy) NSString * pushToShareUrl;//用户退出要push,这个是Push到的url

@property (nonatomic, assign) BOOL isClearTaobaoCookie;
@property (nonatomic, assign) BOOL tao800SwitchTaobaoLogin;
@property (nonatomic, assign) BOOL isDisplayIMSwitch;
@property (nonatomic, assign) BOOL enableDisplayTaobaoSaleCount; //控制淘宝销量的显示
@property (nonatomic, assign) int cpaOutNumber;
@property BOOL hitEggEntry;
@property BOOL displayGiftEntry;
@property BOOL displayInvitation;   //个人中心是否显示发红包拿奖金
@end
