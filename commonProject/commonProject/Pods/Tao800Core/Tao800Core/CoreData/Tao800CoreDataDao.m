//
//  Tao800CoreDataDao.m
//  Tao800Core
//
//  Created by enfeng on 15/1/19.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import "Tao800CoreDataDao.h"
#import "Tao800CoreDataSingleton.h"
#import "Tao800CoreDeal.h"
#import "Tao800DealVo.h"
#import "Tao800CoreConfig.h"
#import "Tao800CoreShop.h"
#import "Tao800CoreShopFavorite.h"
#import "Tao800CoreDealFavorite.h"

@interface Tao800CoreDataDao ()
@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation Tao800CoreDataDao


- (id)init {
    self = [super init];
    if (self) {
        Tao800CoreDataSingleton *dataSingleton = [Tao800CoreDataSingleton shareInstance];
        self.managedObjectContext = [dataSingleton getNewManagedObjectContext];
    }
    return self;
}

- (void)saveTao800Configs:(NSArray *)deals {
    for (NSDictionary *item in deals) {
        Tao800CoreConfig* config = (Tao800CoreConfig *) [NSEntityDescription
                insertNewObjectForEntityForName:@"Tao800CoreConfig"
                         inManagedObjectContext:self.managedObjectContext];
        config.configKey = item[@"configKey"];
        config.configValue = item[@"configValue"];;

        NSError *error = nil;
        [self.managedObjectContext save:&error];
    }
}

- (void)saveTao800Deals:(NSArray *)deals {
    for (NSDictionary *item in deals) {
        Tao800CoreDeal* deal = (Tao800CoreDeal *) [NSEntityDescription
                insertNewObjectForEntityForName:@"Tao800CoreDeal"
                         inManagedObjectContext:self.managedObjectContext];
        deal.dealId = item[@"dealId"];
        deal.dealUpdated = item[@"dealUpdated"];
        deal.dealContent = item[@"dealVo"];

        NSError *error = nil;

        [self.managedObjectContext save:&error];
    }
}

- (void)saveTao800DealFavorites:(NSArray *)deals {
    for (NSDictionary *item in deals) {
        Tao800CoreDealFavorite* dealFavorite = (Tao800CoreDealFavorite *) [NSEntityDescription
                insertNewObjectForEntityForName:@"Tao800CoreDealFavorite"
                         inManagedObjectContext:self.managedObjectContext];
        dealFavorite.dealId = item[@"dealId"];
        dealFavorite.dealFavoriteupdated = item[@"dealFavoriteupdated"];
        dealFavorite.userId = item[@"userId"];

        NSError *error = nil;

        [self.managedObjectContext save:&error];
    }
}

- (void)saveTao800Tao800DealHistories:(NSArray *)deals {

}

- (void)saveTao800Shops:(NSArray *)deals {
    for (NSDictionary *item in deals) {
        Tao800CoreShop* deal = (Tao800CoreShop *) [NSEntityDescription
                insertNewObjectForEntityForName:@"Tao800CoreShop"
                         inManagedObjectContext:self.managedObjectContext];
        deal.shopId = item[@"shopId"];
        deal.shopUpdated = item[@"shopUpdated"];
        deal.shopContent = item[@"shopContent"];

        NSError *error = nil;

        [self.managedObjectContext save:&error];
    }
}

- (void)saveTao800ShopFavorites:(NSArray *)deals {
    for (NSDictionary *item in deals) {
        Tao800CoreShopFavorite* deal = (Tao800CoreShopFavorite *) [NSEntityDescription
                insertNewObjectForEntityForName:@"Tao800CoreShopFavorite"
                         inManagedObjectContext:self.managedObjectContext];
        deal.shopId = item[@"shopId"];
        deal.shopFavoriteUpdated = item[@"shopFavoriteUpdated"];
        deal.userId = item[@"userId"];

        NSError *error = nil;

        [self.managedObjectContext save:&error];
    }
}

- (void)saveTao800ShopHistories:(NSArray *)deals {

}


@end
