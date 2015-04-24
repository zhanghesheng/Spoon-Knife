//
//  Tao800LotteryNoticeSingleton.h
//  Tao800Core
//
//  Created by Rose on 15/3/23.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800DealVo.h"
#import "Tao800LotteryDetailBVO.h"

@interface Tao800LotteryNoticeSingleton : NSObject
{
    NSMutableArray *_startSellArray;
}

@property (nonatomic,retain) NSMutableArray *startSellArray;

+ (Tao800LotteryNoticeSingleton *)sharedInstance;

//用来判断是否添加过
- (NSMutableDictionary *)getLotteryByDealId:(NSString*)dealId;

// 获取开卖列表
- (NSMutableArray *)getStartSellArray;

// 把开卖数据写入文件
- (NSString*)saveNotice:(Tao800LotteryDetailBVO *)dealVo;

// 清空全部开卖提醒数据及通知
- (void)clearAllDataWithNotification;

// 清空全部开卖提醒通知
- (void)clearAllNotification;

- (NSString*)saveNoticeTest:(Tao800LotteryDetailBVO *)dealVo;

@end
