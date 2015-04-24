//
//  Tao800MyLuckyDrawVo.h
//  tao800
//
//  Created by worker on 14-10-13.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800MyLuckyDrawVo : NSObject<NSCoding> {
    
    //成都
    int _dealId;
    NSString *_title;
    NSString *_userId;
    NSString *_listImage;     //列表图片
    float _originPrice;
    int _joinCount;
    int _returnStatus;
    
    //详情
    NSString *_image;         //详情页图片
    int _totalCount;          //总数
    NSString *_dealDescription;     //图文详情
    NSString *_begunAt;         //开始时间
    NSString *_endedAt;         //结束时间
    NSString *_runTime;         //开奖时间
    NSString *_cost;            //兑换抽奖号需要积分
    int _runStatus;              //参与状态
    int _orderStatus;             //订单状态   1:已发; 0:未发货
    NSString *_orderId;            //订单编号
    NSDictionary *_delivery;      //物流信息，已发货的
    NSDictionary *_userInfos;      //用户信息
    NSArray *_luckyUsers;          //中奖用户
    NSString *_myLucky;            //我的中奖号（已开奖，且中奖）
    int _lotteryCount;            //抽奖码数
    float _overRate;              //超过百分数
    NSString *_intro;            //订单详情页说明  后台配置，所有活动统一，无则不显示
    BOOL _hasShow;                //是否有晒单

}
@property(nonatomic) BOOL isBaoyou;
@property(nonatomic) double price;
@property(nonatomic) int dealId;
@property(nonatomic, strong) NSString *title;
@property(nonatomic) BOOL hasShow;
//成都

@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *listImage;
@property(nonatomic) float originPrice;
@property(nonatomic, assign) int joinCount;
@property(nonatomic, assign) int returnStatus;
@property(nonatomic, strong) NSString *orderId;
@property(nonatomic, strong) NSString *image;
@property(nonatomic, assign) int totalCount;
@property(nonatomic, strong) NSString *dealDescription;
@property(nonatomic, strong) NSString *begunAt;
@property(nonatomic, strong) NSString *endedAt;
@property(nonatomic, strong) NSString *runTime;
@property(nonatomic, strong) NSString *cost;
@property(nonatomic, assign) int runStatus;
@property(nonatomic, assign) int orderStatus;

@property(nonatomic, strong)  NSDictionary *delivery;
@property(nonatomic, strong)  NSDictionary *userInfos;
@property(nonatomic, strong)  NSArray *luckyUsers;

@property(nonatomic, strong) NSString *myLucky;
@property(nonatomic, assign) int lotteryCount;
@property(nonatomic, assign) float overRate;
@property(nonatomic, strong) NSString *intro;
//

  

@end
