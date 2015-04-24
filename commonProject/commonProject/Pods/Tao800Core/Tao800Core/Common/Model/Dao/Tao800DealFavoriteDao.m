//
//  Tao800DealFavoriteDao.m
//  universalT800
//
//  Created by enfeng on 13-10-8.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <TBService/TBUserVo.h>
#import "Tao800DealFavoriteDao.h"
#import "TBCore/TBCore.h"
#import "Tao800DealVo.h"
#import "Tao800CoreDealFavorite.h"
#import "Tao800CoreDataSingleton.h"
#import "Tao800DealDao.h"
#import "Tao800CoreDeal.h"
#import "Tao800CoreShopFavorite.h"

@interface Tao800DealFavoriteDao ()
@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation Tao800DealFavoriteDao

- (id)init {
    self = [super init];
    if (self) {
        Tao800CoreDataSingleton *dataSingleton = [Tao800CoreDataSingleton shareInstance];
        self.managedObjectContext = [dataSingleton getNewManagedObjectContext];
    }
    return self;
}

- (void)insertFavoriteDeal:(Tao800DealVo *)dealVo ofUser:(TBUserVo *)user {
    Tao800CoreDealFavorite *dealFavorite = (Tao800CoreDealFavorite *) [NSEntityDescription
            insertNewObjectForEntityForName:@"Tao800CoreDealFavorite"
                     inManagedObjectContext:self.managedObjectContext];
    dealFavorite.dealId = [NSString stringWithFormat:@"%d", dealVo.dealId];
    dealFavorite.dealFavoriteupdated = [NSDate date];
    
    NSString *userId = nil;
    if ([user.userId isKindOfClass:[NSNumber class]]) {
        NSNumber *num = (NSNumber *) user.userId;
        userId = num.stringValue;
    } else {
        userId = user.userId;
    }
    dealFavorite.userId = userId;

    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {

    }
}

- (Tao800CoreDealFavorite *)getFavoriteDeal:(NSString *)dealId userId:(NSString *)userId {
    Tao800CoreDealFavorite *historyDeal = nil;
    NSError *error = nil;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tao800CoreDealFavorite"
                                              inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dealId=%@ and userId=%@", dealId, userId];
    fetchRequest.predicate = predicate;
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (fetchedObjects && fetchedObjects.count > 0) {
        historyDeal = fetchedObjects[0];
    }

    return historyDeal;
}

- (void)deleteFavoriteDeal:(Tao800DealVo *)dealVo ofUser:(TBUserVo *)user {
    NSString *dealId = [NSString stringWithFormat:@"%d", dealVo.dealId];
    Tao800CoreDealFavorite *historyDeal = [self getFavoriteDeal:dealId userId:user.userId];
    if (historyDeal) {
        [self.managedObjectContext deleteObject:historyDeal];
    }

    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {

    }
}

- (NSArray *)getFavoreiteDealsOfUser:(TBUserVo *)user {

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

    Tao800DealDao *dealDao = [[Tao800DealDao alloc] init];

    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:fetchedObjects.count];
    for (Tao800CoreDealFavorite *dealFavorite in fetchedObjects) {
        Tao800DealVo *deal = [dealDao getDealVoByDealId:dealFavorite.dealId];
        [retArray addObject:deal];
    }
    return retArray;
}
@end
