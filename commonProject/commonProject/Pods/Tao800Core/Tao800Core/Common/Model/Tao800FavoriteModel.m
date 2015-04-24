//
//  Tao800FavoriteModel.m
//  tao800
//
//  Created by enfeng on 14-4-8.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800FavoriteModel.h"
#import "Tao800DealVo.h"
#import "Tao800ShopVo.h"
#import "Tao800DealService.h"
#import "Tao800DataModelSingleton.h"

int const DealFavoriteModelMaxTaskCount = 2;
int const ShopFavoriteModelMaxTaskCount = 2;
int const FavoriteModelMaxTaskCount = 4;

@interface Tao800FavoriteModel ()

@property(nonatomic, strong) Tao800DealService *dealService;
@property(nonatomic, strong) NSString *currentDealKey;
@property(nonatomic, strong) NSString *currentShopKey;

@property(nonatomic) BOOL dealSynchronization;
@property(nonatomic) BOOL shopSynchronization;
@end

@implementation Tao800FavoriteModel

- (NSString *)generateKey {
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    long long tt = (long long) (timeInterval * 1000);
    return [NSString stringWithFormat:@"%lld", tt];
}

- (void)resetCurrentDealKey {
    if (!self.currentDealKey || self.currentDealKey == self.dealSynchronizationKey) {
        self.currentDealKey = [self generateKey];
        if (!self.dealKeyArray) {
            self.dealKeyArray = [NSMutableArray arrayWithCapacity:4];
        }
        [self.dealKeyArray addObject:self.currentDealKey];
    }
}

- (void)resetCurrentShopKey {
    if (!self.currentShopKey || self.currentShopKey == self.shopSynchronizationKey) {
        self.currentShopKey = [self generateKey];
        if (!self.shopKeyArray) {
            self.shopKeyArray = [NSMutableArray arrayWithCapacity:4];
        }
        [self.shopKeyArray addObject:self.currentShopKey];
    }
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.addDealsFavoriteDict = [coder decodeObjectForKey:@"self.addDealsFavoriteDict"];
        self.deleteDealsFavoriteDict = [coder decodeObjectForKey:@"self.deleteDealsFavoriteDict"];
        self.addShopsFavoriteDict = [coder decodeObjectForKey:@"self.addShopsFavoriteDict"];
        self.deleteShopsFavoriteDict = [coder decodeObjectForKey:@"self.deleteShopsFavoriteDict"];
        self.dealKeyArray = [coder decodeObjectForKey:@"self.dealKeyArray"];
        self.shopKeyArray = [coder decodeObjectForKey:@"self.shopKeyArray"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.addDealsFavoriteDict forKey:@"self.addDealsFavoriteDict"];
    [coder encodeObject:self.deleteDealsFavoriteDict forKey:@"self.deleteDealsFavoriteDict"];
    [coder encodeObject:self.addShopsFavoriteDict forKey:@"self.addShopsFavoriteDict"];
    [coder encodeObject:self.deleteShopsFavoriteDict forKey:@"self.deleteShopsFavoriteDict"];
    [coder encodeObject:self.dealKeyArray forKey:@"self.dealKeyArray"];
    [coder encodeObject:self.shopKeyArray forKey:@"self.shopKeyArray"];
}

- (void)setDictArrayData:(NSMutableDictionary *)dict pId:(NSNumber *)pId key:(NSString *)key {
    NSMutableArray *ids = [dict objectForKey:key];
    if (!ids) {
        ids = [NSMutableArray arrayWithCapacity:10];
        [dict setValue:ids forKey:key];
    }
    if ([ids containsObject:pId]) {
        return;
    }
    [ids addObject:pId];
}

- (void)addFavoriteDeal:(Tao800DealVo *)dealVo {
    [self resetCurrentDealKey];
    if (!self.addDealsFavoriteDict) {
        self.addDealsFavoriteDict = [NSMutableDictionary dictionaryWithCapacity:2];
    }

    //如果之前删除过，则需要从删除队列中移除
    NSNumber *dealId = @(dealVo.dealId);
    if (self.deleteDealsFavoriteDict) {
        NSMutableArray *array = self.deleteDealsFavoriteDict[self.currentDealKey];
        if ([array containsObject:dealId]) {
            [array removeObject:dealId];
        }
    }

    [self setDictArrayData:self.addDealsFavoriteDict pId:dealId key:self.currentDealKey];
}

- (void)deleteFavoriteDeal:(Tao800DealVo *)dealVo {
    [self resetCurrentDealKey];
    if (!self.deleteDealsFavoriteDict) {
        self.deleteDealsFavoriteDict = [NSMutableDictionary dictionaryWithCapacity:2];
    }
    //如果之前添加过，则需要从添加队列中移除
    NSNumber *dealId = @(dealVo.dealId);
    if (self.addDealsFavoriteDict) {
        NSMutableArray *array = self.addDealsFavoriteDict[self.currentDealKey];
        if ([array containsObject:dealId]) {
            [array removeObject:dealId];
        }
    }
    [self setDictArrayData:self.deleteDealsFavoriteDict pId:@(dealVo.dealId) key:self.currentDealKey];
}

- (void)addFavoriteShop:(Tao800ShopVo *)shopVo {
    [self resetCurrentShopKey];
    if (!self.addShopsFavoriteDict) {
        self.addShopsFavoriteDict = [NSMutableDictionary dictionaryWithCapacity:2];
    }

    //如果之前删除过，则需要从删除队列中移除
    NSNumber *shopId = shopVo.shopId;
    if (self.deleteShopsFavoriteDict) {
        NSMutableArray *array = self.deleteShopsFavoriteDict[self.currentShopKey];
        if ([array containsObject:shopId]) {
            [array removeObject:shopId];
        }
    }
    [self setDictArrayData:self.addShopsFavoriteDict pId:shopId key:self.currentShopKey];
}

- (void)deleteFavoriteShop:(Tao800ShopVo *)shopVo {
    [self resetCurrentShopKey];
    if (!self.deleteShopsFavoriteDict) {
        self.deleteShopsFavoriteDict = [NSMutableDictionary dictionaryWithCapacity:2];
    }
    [self setDictArrayData:self.deleteShopsFavoriteDict pId:shopVo.shopId key:self.currentShopKey];
}

- (void)resetFinishState {
    self.finishCount = self.dealFinishCount + self.shopFinishCount;
}

- (void)resetDealFinishState {
    self.dealFinishCount++;
    if (self.dealFinishCount == DealFavoriteModelMaxTaskCount) {
        self.dealSynchronization = NO;
        [self.dealKeyArray removeObject:self.dealSynchronizationKey];
    }
    [self resetFinishState];
}

- (void)resetShopFinishState {
    self.shopFinishCount++;
    if (self.shopFinishCount == ShopFavoriteModelMaxTaskCount) {
        self.shopSynchronization = NO;
        [self.shopKeyArray removeObject:self.shopSynchronizationKey];
    }
    [self resetFinishState];
}

- (void)saveFinishState {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [dm archive];
}

- (void)synchronizationDealFavorite {
    //正在同步
    if (self.dealSynchronization) {
        return;
    }

    if (self.dealKeyArray.count < 1) {
        self.dealFinishCount = DealFavoriteModelMaxTaskCount;
        self.dealSynchronization = NO;
        [self resetFinishState];
        return;
    }

    self.dealSynchronization = YES;
    self.dealFinishCount = 0;

    self.dealSynchronizationKey = self.dealKeyArray.firstObject;

    if (!self.dealService) {
        self.dealService = [[Tao800DealService alloc] init];
        self.dealService.enableExecuteInBackground = YES;
    }

    NSArray *addDealIds = self.addDealsFavoriteDict[self.dealSynchronizationKey];
    NSArray *deleteDealIds = self.deleteDealsFavoriteDict[self.dealSynchronizationKey];

    __weak Tao800FavoriteModel *instance = self;

    if (addDealIds && addDealIds.count > 0) {
        NSString *ids = [addDealIds componentsJoinedByString:@","];
        NSDictionary *dictionary = @{@"dealId" : ids};
        [self.dealService addFavoriteDeal:dictionary
                               completion:^(NSDictionary *pDict) {
                                   NSNumber *statusNumber = pDict[@"status"];
                                   int status = statusNumber.intValue;

                                   if (status == 201 || status == 409) {
                                       //收藏成功
                                       [instance.addDealsFavoriteDict removeObjectForKey:instance.dealSynchronizationKey];
                                       [instance saveFinishState];
                                   }
                                   [instance resetDealFinishState];
                               }
                                  failure:^(TBErrorDescription *err) {
                                      [instance resetDealFinishState];
                                  }];
    } else {
        [self resetDealFinishState];
    }
    if (deleteDealIds && deleteDealIds.count > 0) {
        NSString *ids = [deleteDealIds componentsJoinedByString:@","];
        NSDictionary *dictionary = @{@"dealids" : ids};
        [self.dealService deleteFavoriteDeal:dictionary
                                  completion:^(NSDictionary *dict) {
                                      NSNumber *statusNumber = dict[@"status"];
                                      int status = statusNumber.intValue;

                                      if (status == 201 || status == 409) {
                                          [instance.deleteDealsFavoriteDict removeObjectForKey:instance.dealSynchronizationKey];
                                          [instance saveFinishState];
                                      }

                                      [instance resetDealFinishState];
                                  }
                                     failure:^(TBErrorDescription *errorDescription) {
                                         [instance resetDealFinishState];
                                     }];
    } else {
        [self resetDealFinishState];
    }
}

- (void)synchronizationShopFavorite {
    //正在同步
    if (self.shopSynchronization) {
        return;
    }

    if (self.shopKeyArray.count < 1) {
        self.shopFinishCount = ShopFavoriteModelMaxTaskCount;
        self.shopSynchronization = NO;
        [self resetFinishState];
        return;
    }

    self.shopSynchronization = YES;

    self.shopFinishCount = 0;

    self.shopSynchronizationKey = self.shopKeyArray.firstObject;

    if (!self.dealService) {
        self.dealService = [[Tao800DealService alloc] init];
        self.dealService.enableExecuteInBackground = YES;
    }

    NSArray *addShopIds = self.addShopsFavoriteDict[self.shopSynchronizationKey];
    NSArray *deleteShopIds = self.deleteShopsFavoriteDict[self.shopSynchronizationKey];

    __weak Tao800FavoriteModel *instance = self;

    if (addShopIds && addShopIds.count > 0) {
        NSString *ids = [addShopIds componentsJoinedByString:@","];
        NSDictionary *dictionary = @{@"shopId" : ids};
        [self.dealService addFavoriteShop:dictionary
                               completion:^(NSDictionary *dict) {
                                   NSNumber *statusNumber = dict[@"status"];
                                   int status = statusNumber.intValue;

                                   if (status == 201 || status == 409) {
                                       //收藏成功
                                       [instance.addShopsFavoriteDict removeObjectForKey:instance.shopSynchronizationKey];
                                       [instance saveFinishState];
                                   }
                                   [instance resetShopFinishState];

                               }
                                  failure:^(TBErrorDescription *err) {
                                      [instance resetShopFinishState];
                                  }];
    } else {
        [self resetShopFinishState];
    }
    if (deleteShopIds && deleteShopIds.count > 0) {
        NSString *ids = [deleteShopIds componentsJoinedByString:@","];
        NSDictionary *dictionary = @{@"id" : ids};
        [self.dealService deleteFavoriteShop:dictionary
                                  completion:^(NSDictionary *dict) {
                                      NSNumber *statusNumber = dict[@"status"];
                                      int status = statusNumber.intValue;

                                      if (status == 201 || status == 409) {
                                          [instance.deleteShopsFavoriteDict removeObjectForKey:instance.shopSynchronizationKey];
                                          [instance saveFinishState];
                                      }

                                      [instance resetShopFinishState];
                                  }
                                     failure:^(TBErrorDescription *errorDescription) {
                                         [instance resetShopFinishState];
                                     }];
    } else {
        [self resetShopFinishState];
    }
}

- (void)synchronizationFavorite {
    self.finishCount = 0;
    [self synchronizationDealFavorite];
    [self synchronizationShopFavorite];
}

@end
