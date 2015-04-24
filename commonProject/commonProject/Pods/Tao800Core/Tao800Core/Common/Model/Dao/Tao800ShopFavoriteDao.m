//
//  Tao800ShopFavoriteDao.m
//  tao800
//
//  Created by enfeng on 14-2-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBService/TBUserVo.h>
#import "Tao800ShopFavoriteDao.h"
#import "Tao800ShopVo.h"
#import "Tao800CoreShopFavorite.h"
#import "Tao800CoreDataSingleton.h"
#import "Tao800ShopDao.h"

@interface Tao800ShopFavoriteDao ()
@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation Tao800ShopFavoriteDao

- (id)init {
    self = [super init];
    if (self) {
        Tao800CoreDataSingleton *dataSingleton = [Tao800CoreDataSingleton shareInstance];
        self.managedObjectContext = [dataSingleton getNewManagedObjectContext];
    }
    return self;
}

- (Tao800CoreShopFavorite *)getShopFavorite:(NSString *)shopId userId:(NSString *)userId {
    Tao800CoreShopFavorite *historyDeal = nil;
    NSError *error = nil;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tao800CoreShopFavorite"
                                              inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"shopId=%@ and userId=%@", shopId, userId];
    fetchRequest.predicate = predicate;
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (fetchedObjects && fetchedObjects.count > 0) {
        historyDeal = fetchedObjects[0];
    }

    return historyDeal;
}

- (void)insertFavoriteShop:(Tao800ShopVo *)shopVo ofUser:(TBUserVo *)user {
    Tao800CoreShopFavorite *dealFavorite = (Tao800CoreShopFavorite *) [NSEntityDescription
            insertNewObjectForEntityForName:@"Tao800CoreShopFavorite"
                     inManagedObjectContext:self.managedObjectContext];
    
    NSString *userId = nil;
    if ([user.userId isKindOfClass:[NSNumber class]]) {
        NSNumber *num = (NSNumber *) user.userId;
        userId = num.stringValue;
    } else {
        userId = user.userId;
    }
    
    dealFavorite.shopId = shopVo.shopId.stringValue;
    dealFavorite.shopFavoriteUpdated = [NSDate date];
    dealFavorite.userId = userId;

    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {

    }
}

- (void)deleteFavoriteShop:(Tao800ShopVo *)shopVo ofUser:(TBUserVo *)user {
    Tao800CoreShopFavorite *historyDeal = [self getShopFavorite:shopVo.shopId.stringValue
                                                     userId:user.userId];
    if (historyDeal) {
        [self.managedObjectContext deleteObject:historyDeal];
    }

    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {

    }
}

- (NSArray *)getFavoreiteShopsOfUser:(TBUserVo *)user {

    NSError *error = nil;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TBBHistory"
                                              inManagedObjectContext:self.managedObjectContext];

    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"updated" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId=%@", user.userId];
    fetchRequest.predicate = predicate;
    [fetchRequest setSortDescriptors:sortDescriptors];

    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    Tao800ShopDao *dealDao = [[Tao800ShopDao alloc] init];

    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:fetchedObjects.count];
    for (Tao800CoreShopFavorite *dealFavorite in fetchedObjects) {
        Tao800ShopVo *deal = [dealDao getShopVoByShopId:dealFavorite.shopId];
        [retArray addObject:deal];
    }
    return retArray;
}


@end
