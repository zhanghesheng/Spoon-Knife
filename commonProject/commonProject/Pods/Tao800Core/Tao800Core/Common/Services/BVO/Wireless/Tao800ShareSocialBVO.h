//
//  Tao800ShareSocialBVO.h
//  tao800
//
//  Created by enfeng on 14/11/20.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TBShareVo;
@class Tao800DealVo;
@class Tao800ShareVo;
@class Tao800ShareDealItem;

typedef NS_ENUM(NSInteger, Tao80ShareSocialType) {
    Tao80ShareSocialTypeMall = 1,  //1:特卖商城
    Tao80ShareSocialTypeTaobao = 2,  //2:天猫淘宝
    Tao80ShareSocialTypeOrderOk = 3,   //3:下单成功
    Tao80ShareSocialTypePromotion = 4, //4:大促分享
    Tao80ShareSocialTypeActive = 5, //5:活动分享
    Tao80ShareSocialTypeOrderEgg = 6, //6:下单彩蛋
    Tao80ShareSocialTypeUnlock = 7,  //7:分享解锁
    Tao80ShareSocialTypeLuckyDraw = 8,  //8:0元抽奖
    Tao80ShareSocialTypeInviteRegister = 9,  //9:邀请好友注册
    Tao80ShareSocialTypeMultiBuy = 10, //10:多人成团
    Tao80ShareSocialTypeRoomUnlock = 20, //20虚拟试衣间分享解锁
    Tao80ShareSocialTypeRoomPic = 30,  //30虚拟试衣间图片分享
    Tao80ShareSocialTypeSongLi = 40, //H5送礼打点
    Tao80ShareSocialTypeQiandao = 50,//签到复活
    Tao80ShareSocialTypeDefault = 100,
    
};

typedef NS_ENUM(NSInteger, Tao80ShareMethod) {
    Tao80ShareMethodWeixin = 1,  //1:微信
    Tao80ShareMethodFriends = 2,  //2:朋友圈
};

@interface Tao800ShareSocialBVO : NSObject <NSCoding>

@property(nonatomic, strong) NSNumber *contentId;
@property(nonatomic) Tao80ShareSocialType socialType; //"share_type"
@property(nonatomic, copy) NSString *shareMethod; //share_method" 分享方法 1:微信 2:朋友圈 可以支持多个，用逗号,分割
@property(nonatomic, copy) NSString *shareTitle; //share_title
@property(nonatomic, copy) NSString *shareSmallPic; //share_small_pic
@property(nonatomic, copy) NSString *shareLink; //share_link
@property(nonatomic, copy) NSString *recommendPic; //recommend_pic
@property(nonatomic, copy) NSString *recommendLink; //recommend_link
@property(nonatomic, copy) NSString *dealId; //分享商品的dealid

// 分享文本。分享文本和图片会返回多值，客户端随机取一个展示。
// 分享文本是模板形式，包含标题、原价、现价和是否包邮，需要客户端自行替换。
// %title%代表标题；%list_price%代表原价；%price%代表现价；%baoyou%代表包邮。
@property(nonatomic, strong) NSArray *infos;

@property(nonatomic, strong) NSArray *images;//images 分享图片

@property (nonatomic, strong) NSDate *lastUpdated; //用于处理本地缓存


@property (nonatomic, strong) Tao800ShareVo *shareVo;

+ (Tao800ShareSocialBVO *)wrapperShareSocialBVO:(NSDictionary *)item;

- (id)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;

- (NSArray *) shareMethodArray;

+ (NSString *) defaultShareMethod;

- (Tao800ShareVo *) shareVoWithDeal:(Tao800ShareDealItem*) shareDealItem shareVo:(Tao800ShareVo*)shareVoParam;

@end
