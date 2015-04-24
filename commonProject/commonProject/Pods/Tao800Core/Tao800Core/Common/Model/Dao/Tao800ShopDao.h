//
//  Tao800ShopDao.h
//  tao800
//
//  Created by enfeng on 14-2-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tao800ShopVo;

@interface Tao800ShopDao : NSObject

- (BOOL)saveShop:(Tao800ShopVo *)shopVo;

- (void)deleteShop:(Tao800ShopVo *)shopVo;

- (Tao800ShopVo *)getShopVoByShopId:(NSString *)shopId;

/**
* 可以用于获取用户收藏的数据
*/
- (NSArray *)getShopsByShopIds:(NSArray *)shopIds;
@end
