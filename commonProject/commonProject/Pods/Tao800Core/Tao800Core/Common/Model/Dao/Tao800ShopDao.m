//
//  Tao800ShopDao.m
//  tao800
//
//  Created by enfeng on 14-2-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800ShopDao.h"
#import "Tao800ShopVo.h"
#import "Tao800CoreDataSingleton.h"
#import "Tao800CoreShop.h"

@interface Tao800ShopDao ()
@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation Tao800ShopDao

- (id)init {
    self = [super init];
    if (self) {
        Tao800CoreDataSingleton *dataSingleton = [Tao800CoreDataSingleton shareInstance];
        self.managedObjectContext = [dataSingleton getNewManagedObjectContext];
    }
    return self;
}

- (Tao800CoreShop *)getShopByShopId:(NSString *)shopId {
    Tao800CoreShop *config = nil;
    NSError *error = nil;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tao800CoreShop"
                                              inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"shopId=%@", shopId];
    fetchRequest.predicate = predicate;
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects && fetchedObjects.count > 0) {
        config = fetchedObjects[0];
    }

    return config;
}

- (BOOL)saveShop:(Tao800ShopVo *)shopVo {
    Tao800CoreShop *deal = [self getShopByShopId:shopVo.shopId.stringValue];
    if (deal) {
        [self.managedObjectContext deleteObject:deal];
    }

    deal = (Tao800CoreShop *) [NSEntityDescription
            insertNewObjectForEntityForName:@"Tao800CoreShop"
                     inManagedObjectContext:self.managedObjectContext];
    deal.shopId = shopVo.shopId.stringValue;
    deal.shopUpdated = [NSDate date];
    deal.shopContent = [NSKeyedArchiver archivedDataWithRootObject:shopVo];

    NSError *error = nil;
    BOOL ret = YES;
    if (![self.managedObjectContext save:&error]) {
        ret = NO;
    }
    return ret;
}

- (void)deleteShop:(Tao800ShopVo *)shopVo {
    NSString *shopId = shopVo.shopId.stringValue;
    Tao800CoreShop *shop = [self getShopByShopId:shopId];
    if (shop) {
        [self.managedObjectContext deleteObject:shop];
    }

    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {

    }
}

- (Tao800ShopVo *)getShopVoByShopId:(NSString *)shopId {
    Tao800CoreShop *deal = [self getShopByShopId:shopId];
    if (!deal) {
        return nil;
    }
    Tao800ShopVo *dealVo = [NSKeyedUnarchiver unarchiveObjectWithData:deal.shopContent];
    return dealVo;
}

- (NSArray *)getShopsByShopIds:(NSArray *)shopIds {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[shopIds count]];
    for (NSNumber *shopId in shopIds) {
        Tao800ShopVo *dealVo = [self getShopVoByShopId:shopId.stringValue];
        if (dealVo) {
            [array addObject:dealVo];
        }
    }
    return array;
}


@end
