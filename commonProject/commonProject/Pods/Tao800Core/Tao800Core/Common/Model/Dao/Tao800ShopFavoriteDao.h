//
//  Tao800ShopFavoriteDao.h
//  tao800
//
//  Created by enfeng on 14-2-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TBUserVo;
@class Tao800ShopVo;

@interface Tao800ShopFavoriteDao : NSObject


- (void) insertFavoriteShop:(Tao800ShopVo*)shopVo ofUser:(TBUserVo *)user;

- (void) deleteFavoriteShop:(Tao800ShopVo*)shopVo ofUser:(TBUserVo *)user;

- (NSArray*) getFavoreiteShopsOfUser:(TBUserVo*) user;
@end
