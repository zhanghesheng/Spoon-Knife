//
//  Tao800StartSellSingleton.h
//  tao800
//
//  Created by worker on 13-1-21.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800DealVo.h"

@interface Tao800StartSellSingleton : NSObject <NSCoding>
{
    NSMutableArray *_startSellArray;
}

@property (nonatomic,retain) NSMutableArray *startSellArray;

+ (Tao800StartSellSingleton *)sharedInstance;

// 获取开卖列表
- (NSMutableArray *)getStartSellArray;

// 把开卖数据写入文件
- (void)saveStartSell:(Tao800DealVo *)dealVo;

// 根据dealId查询对应的开卖提醒数据
- (NSMutableDictionary *)getStartSellByDealId:(int)dealId;

// 查找同一时间开卖提醒数据
- (NSMutableArray *)getStartSellByRemindTime:(NSString *)remindTime;

// 根据dealVo删除对应的开卖提醒数据
- (void)deleteStartSell:(Tao800DealVo *)dealVo;

// 清空全部开卖提醒数据及通知
- (void)clearAllDataWithNotification;

// 清空全部开卖提醒通知
- (void)clearAllNotification;

// 根据remindTime清空开卖提醒数据
- (void)clearByRemindTime:(NSString *)remindTime;

// 建立全部开卖提醒通知
- (void)createAllNotification;



@end
