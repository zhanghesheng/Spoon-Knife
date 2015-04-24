//
//  Tao800ScoreRewardCommonDealVo.h
//  tao800
//
//  Created by hanyuan on 13-4-16.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Tao800DealVo.h"

@interface Tao800PointDetailCommonDealVo : NSObject
{
    int dealId;
    int needScore;
    NSString *urlName; //用于积分兑换和抽奖
    NSString *title;
    NSString *description;
    int price;
    
    NSString *beginTime;
    NSString *endTime;
    
    NSString *smallImgUrl;
    NSString *bigImgUrl;
    NSArray *dealImgUrls;
    
    int joinCount; //参与人数
    int dealCount; //礼品数量
    
    DealSaleState _oos;                //在售状态（oos是out of stock的简称）. 0代表在售，1代表已售完
    
    // 2.5.0增加以下属性
    int grade; // 需要用户等级
    // 3.1.1增加
    int dealType; //判断是否是积分现金购 0--0元兑换商品；1--积分现金购商品
}

@property(nonatomic, assign)int dealId;
@property(nonatomic, assign)int needScore;
@property(nonatomic, copy)NSString *urlName; //用于积分兑换和抽奖
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *description;
@property(nonatomic, assign)int price;
@property(nonatomic, assign)int currentPrice; //外
@property(nonatomic, copy)NSString *beginTime;
@property(nonatomic, copy)NSString *endTime;
@property(nonatomic, copy)NSString *smallImgUrl;
@property(nonatomic, copy)NSString *bigImgUrl;
@property(nonatomic, strong)NSArray *dealImgUrls;
@property(nonatomic, assign)int joinCount; //参与人数
@property(nonatomic, assign)int dealCount; //礼品数量
@property(nonatomic, assign)DealSaleState oos;
@property(nonatomic, assign)int grade;
@property(nonatomic, assign)int dealType;
@property (nonatomic, assign) int sortId;



@end
