//
//  Tao800OpenGroupRemindSingleton.h
//  tao800
//
//  Created by worker on 13-10-30.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//
//  开团提醒

#import <Foundation/Foundation.h>
#import "Tao800DealVo.h"

@interface Tao800OpenGroupRemindSingleton : NSObject <NSCoding>
{
    NSMutableArray *_dataArray;
}

@property (nonatomic,strong) NSMutableArray *dataArray;

+ (Tao800OpenGroupRemindSingleton *)sharedInstance;

// 获取数据列表
- (NSMutableArray *)getDataArray;

// 把数据写入文件
- (void)save:(Tao800DealVo *)dealVo;

// 根据dealId查询对应的数据
- (NSMutableDictionary *)getByDealId:(int)dealId;

// 根据dealVo删除对应的数据
- (void)deleteByDealVo:(Tao800DealVo *)dealVo;

@end
