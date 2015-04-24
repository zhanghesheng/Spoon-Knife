//
//  Tao800DealListVo.h
//  tao800
//
//  Created by LeAustinHan on 13-12-25.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum DealListStatus {
    Tao800DealZeroExchange, //0元兑换
    Tao800DealScoreReward,  //积分抽奖
    Tao800DealScoreAuction, //积分拍卖
    Tao800DealScoreCash,    //积分现金够
}DealListStatus;

@interface Tao800PointDetailDealListVo : NSObject
{
    DealListStatus _dealSellStatus; // 销售状态
    NSString *_title;
}

@property(nonatomic) DealListStatus dealSellStatus;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) id targetHorizontalViewCTL;

@end
