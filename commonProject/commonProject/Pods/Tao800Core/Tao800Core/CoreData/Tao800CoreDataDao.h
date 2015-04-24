//
//  Tao800CoreDataDao.h
//  Tao800Core
//  兼容老接口， 批量保存数据
//  Created by enfeng on 15/1/19.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800CoreDataDao : NSObject

- (void)saveTao800Configs:(NSArray *)deals;

- (void)saveTao800Deals:(NSArray *)deals;

- (void)saveTao800DealFavorites:(NSArray *)deals;

- (void)saveTao800Tao800DealHistories:(NSArray *)deals;

- (void)saveTao800Shops:(NSArray *)deals;

- (void)saveTao800ShopFavorites:(NSArray *)deals;

- (void)saveTao800ShopHistories:(NSArray *)deals;
@end
