//
//  Tao800CoreShopFavorite.h
//  tao800
//
//  Created by enfeng on 14-2-20.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tao800CoreShop;


@interface Tao800CoreShopFavorite : NSManagedObject

@property NSString *attribute1;
@property NSString *attribute2;
@property NSString *shopId;
@property NSDate *shopFavoriteUpdated;
@property NSString *userId;

@property Tao800CoreShop *shop;
@end
