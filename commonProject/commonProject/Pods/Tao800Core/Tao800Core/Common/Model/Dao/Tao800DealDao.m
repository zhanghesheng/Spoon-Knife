//
//  Tao800DealDao.m
//  tao800
//
//  Created by enfeng on 14-2-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800DealDao.h"
#import "Tao800CoreDeal.h"
#import "Tao800CoreDataSingleton.h"
#import "Tao800DealVo.h"

@interface Tao800DealDao ()
@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation Tao800DealDao

- (id)init {
    self = [super init];
    if (self) {
        Tao800CoreDataSingleton *dataSingleton = [Tao800CoreDataSingleton shareInstance];
        self.managedObjectContext = [dataSingleton getNewManagedObjectContext];
    }
    return self;
}

- (Tao800CoreDeal *)getDealByDealId:(NSString *)dealId {
    Tao800CoreDeal *config = nil;
    NSError *error = nil;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tao800CoreDeal"
                                              inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dealId=%@", dealId];
    fetchRequest.predicate = predicate;
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects && fetchedObjects.count > 0) {
        config = fetchedObjects[0];
    }

    return config;
}


- (BOOL)saveDeal:(Tao800DealVo *)dealVo {
    NSString *dealId = [NSString stringWithFormat:@"%d", dealVo.dealId];
    Tao800CoreDeal *deal = [self getDealByDealId:dealId];
    if (deal) {
        [self.managedObjectContext deleteObject:deal];
    }

    deal = (Tao800CoreDeal *) [NSEntityDescription
            insertNewObjectForEntityForName:@"Tao800CoreDeal"
                     inManagedObjectContext:self.managedObjectContext];
    deal.dealId = dealId;
    deal.dealUpdated = [NSDate date];
    deal.dealContent = [NSKeyedArchiver archivedDataWithRootObject:dealVo];

    NSError *error = nil;
    BOOL ret = YES;
    if (![self.managedObjectContext save:&error]) {
        ret = NO;
    }
    return ret;
}

- (void)deleteDeal:(Tao800DealVo *)dealVo {
    NSString *dealId = [NSString stringWithFormat:@"%d", dealVo.dealId];
    if ([self getDealByDealId:dealId]) {
        [self.managedObjectContext deleteObject:[self getDealByDealId:dealId]];
    }

    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {

    }
}

- (Tao800DealVo *)getDealVoByDealId:(NSString *)dealId {
    Tao800CoreDeal *deal = [self getDealByDealId:dealId];
    if (!deal) {
        return nil;
    }
    Tao800DealVo *dealVo = [NSKeyedUnarchiver unarchiveObjectWithData:deal.dealContent];
    return dealVo;
}

- (NSArray *)getDealsByDealIds:(NSArray *)dealIds {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[dealIds count]];
    for (NSNumber *dealId in dealIds) {
        Tao800DealVo *dealVo = [self getDealVoByDealId:dealId.stringValue];
        if (dealVo) {
            [array addObject:dealVo];
        }
    }
    return array;
}


@end
