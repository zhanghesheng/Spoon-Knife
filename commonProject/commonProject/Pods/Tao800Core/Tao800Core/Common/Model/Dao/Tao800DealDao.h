//
//  Tao800DealDao.h
//  tao800
//
//  Created by enfeng on 14-2-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tao800DealVo;

@interface Tao800DealDao : NSObject

- (BOOL)saveDeal:(Tao800DealVo *)deal;

- (void)deleteDeal:(Tao800DealVo *)deal;

- (Tao800DealVo *)getDealVoByDealId:(NSString *)dealId;

/**
* 可以用于获取用户收藏的数据
*/
- (NSArray *)getDealsByDealIds:(NSArray *)dealIds;
@end
