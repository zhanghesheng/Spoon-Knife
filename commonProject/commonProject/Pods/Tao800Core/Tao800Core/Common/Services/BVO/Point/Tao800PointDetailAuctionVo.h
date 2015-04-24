//
//  Tao800AunctionVo.h
//  tao800
//
//  Created by LeAustinHan on 13-12-24.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PointDetailCommonDealVo.h"

#import "Tao800PointDetailAuctionLastBiderVo.h"

enum
{
    Auction_Status_InComing,
    Auction_Status_InProgress,
};

@interface Tao800PointDetailAuctionVo :  Tao800PointDetailCommonDealVo
{
    int exchangeStatus;
    int status;                     //竞拍状态
    int minAddedScore;              //每次竞拍最小增加积分数值
    int maxConsumeScore;            //当前最高竞拍积分
    NSDictionary *dealProperty;
    Tao800PointDetailAuctionLastBiderVo *lastBider;
}

@property(nonatomic, assign)int exchangeStatus;
@property(nonatomic, assign)int status;
@property(nonatomic, assign)int minAddedScore;
@property(nonatomic, assign)int maxConsumeScore; 
@property(nonatomic, strong)NSDictionary *dealProperty;
@property(nonatomic, strong)Tao800PointDetailAuctionLastBiderVo *lastBider;

@end
