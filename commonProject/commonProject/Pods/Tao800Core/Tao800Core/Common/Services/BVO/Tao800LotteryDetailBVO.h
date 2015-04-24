//
//  Tao800LotteryDetailBVO.h
//  Tao800Core
//
//  Created by Rose on 15/3/11.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    Tao800LotteryDetailStatusNone = -1,
    Tao800LotteryDetailStatusNotice = 0,
    Tao800LotteryDetailStatusRunning = 1,
    Tao800LotteryDetailStatusLottery = 2,
    Tao800LotteryDetailStatusEnding = 3
}Tao800LotteryDetailStatus;

typedef enum {
    Tao800LotteryJoinStatusNotJoin = 0,
    Tao800LotteryJoinStatusJoin = 1,
}Tao800LotteryJoinStatus;

@interface Tao800LotteryDetailBVO : NSObject//<NSCoding>
@property(nonatomic,strong) NSString* dealId;
@property(nonatomic,strong) NSString* title;
@property(nonatomic,strong) NSArray* image;
@property(nonatomic,strong) NSArray* listImage; //原来thumbnail字段
@property(nonatomic,strong) NSNumber* originPrice;
@property(nonatomic,strong) NSNumber* totalCount; //商品库存
@property(nonatomic,strong) NSString* descriptions;//图文详情
@property(nonatomic,strong) NSString* begunAt;
@property(nonatomic,strong) NSString* endedAt;
@property(nonatomic,strong) NSString* runTime;
@property(nonatomic,strong) NSString* nowTime;
@property(nonatomic,strong) NSNumber* joinCount;//参与抽奖人数
@property(nonatomic,strong) NSString* lotteryNotice;
@property(nonatomic,assign) int cost;//兑换抽奖号需要积分
//@property(nonatomic,strong) NSNumber* code;//0:预告;1:进行中;2:即将开奖;3:结束
@property(nonatomic,assign) Tao800LotteryDetailStatus lotteryStatus;
@property(nonatomic,strong) NSDictionary* userInfo;
//property in dic

//@property(nonatomic,strong) NSNumber* joinStatus;//参与状态 0:未参与;1:已参与
@property(nonatomic,assign) Tao800LotteryJoinStatus joinStatus;
@property(nonatomic,assign) int lotteryCount;//总抽奖码数
//over_rate 应该直接string
@property(nonatomic,strong) NSNumber* overRate; //百分数,超越对手百分比
@property(nonatomic,assign) BOOL daygetStatus;//1代表今天领过，0代表没有领过
@property(nonatomic,assign) int daygetCount;//每日领取抽奖码总数
//address 需要增加该字段
@property(nonatomic,strong) NSDictionary* address;
@property(nonatomic,strong) NSString* addressInfo;
@property(nonatomic,strong) NSString* addressConsigneeName;
@property(nonatomic,strong) NSString* addressZipCode;
@property(nonatomic,strong) NSString* addressTelephone;
@property(nonatomic,strong) NSString* addressPhoneNumber;

//三种获取抽奖号文案对应替换数字
@property(nonatomic,assign) int dayget;//每日领取可获得码数
@property(nonatomic,assign) int invite;//邀请好友可获得码数
@property(nonatomic,assign) int exchange;//多少积分可兑换一个码
@property(nonatomic,strong) NSString* inviteLink;//邀请链接
@property(nonatomic,assign) BOOL isShared;//是否分享过
@property(nonatomic,assign) int shareGet;//分享后得多少码

@property(nonatomic,assign) BOOL hasFreshow; //有没有下期预告
@property(nonatomic,assign) BOOL hasShow; //是否有晒单
@property(nonatomic,strong) NSString* showUrl; //晒单地址
@property(nonatomic,strong) NSString* sharedUrl;

@property(nonatomic,assign) BOOL noticeFlag;
+ (Tao800LotteryDetailBVO *)wrapperLotteryDetailBVO:(NSDictionary *)dict;

@end
