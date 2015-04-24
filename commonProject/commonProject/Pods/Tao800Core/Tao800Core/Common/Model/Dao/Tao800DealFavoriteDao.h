//
//  Tao800DealFavoriteDao.h
//  universalT800
//
//  Created by enfeng on 13-10-8.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tao800DealVo;
@class TBUserVo;

@interface Tao800DealFavoriteDao : NSObject

- (void) insertFavoriteDeal:(Tao800DealVo*)dealVo ofUser:(TBUserVo *)user;

- (void) deleteFavoriteDeal:(Tao800DealVo*)dealVo ofUser:(TBUserVo *)user;

- (NSArray*) getFavoreiteDealsOfUser:(TBUserVo*) user;

@end
