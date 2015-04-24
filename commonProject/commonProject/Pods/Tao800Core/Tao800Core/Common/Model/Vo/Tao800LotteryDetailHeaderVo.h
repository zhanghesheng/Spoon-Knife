//
//  Tao800LotteryDetailHeaderVo.h
//  tao800
//
//  Created by LeAustinHan on 14-10-23.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800LotteryDetailHeaderVo : NSObject

//{
//lottery_status: -1,
//
//orders: [
//         {
//         order_id: 11171,
//         lottery_code:"DHstfQHB",
//         status: 1
//         }
//         ]
//}


@property (strong, nonatomic) NSString *dealId;
@property (strong, nonatomic) NSString *title;
@property(nonatomic, strong) NSString *shortTitle;
@property (assign, nonatomic) int price;
@property (assign, nonatomic) int listPrice;
@property (strong, nonatomic) NSString *beginTime;
@property (strong, nonatomic) NSString *expireTime;
@property (strong, nonatomic) NSString *stock;
@property (strong, nonatomic) NSString *drawNum;
@property (strong, nonatomic) NSString *priceNum;
@property (strong, nonatomic) NSString *priceTime;
@property (strong, nonatomic) NSString *lotteryInfo;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *thumbnail;
@property (nonatomic, strong) NSString *serverTimeString;
@property (strong, nonatomic) NSArray *orders;
@property(nonatomic, assign) Boolean isBaoyou;


@end
