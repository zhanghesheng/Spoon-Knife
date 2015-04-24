//
//  Tao800UserModel.m
//  tao800
//
//  Created by enfeng on 14-2-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/TBErrorDescription.h>
#import "Tao800UserModel.h"
#import "Tao800DealService.h"
#import "Tao800DealVo.h"
#import "Tao800DealFavoriteDao.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800DealDao.h"
#import "Tao800BackgroundServiceManage.h"
#import "Tao800ShopDao.h"
#import "Tao800ShopFavoriteDao.h"
#import "Tao800ConfigManage.h"
#import "Tao800FavoriteModel.h"

enum {
    Tao800UserModelFavoriteOkStatus = 201
};

@interface Tao800UserModel ()
@property(nonatomic, strong) Tao800DealService *tao800DealService;
@end

@implementation Tao800UserModel

- (id)init {
    self = [super init];
    if (self) {
        self.tao800DealService = [[Tao800DealService alloc] init];
    }
    return self;
}

- (void)saveFavoriteDeal:(Tao800DealVo *)deal {
    //刷新商品
    Tao800DealDao *dealDao = [[Tao800DealDao alloc] init];
    [dealDao saveDeal:deal];

    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    if (!dm.favoriteDealIds) {
        dm.favoriteDealIds = [NSMutableArray arrayWithCapacity:5];
        //同步服务器dealids
        [[Tao800BackgroundServiceManage sharedInstance] loadFavoriteDealIds];
    }

    [dm.favoriteDealIds addObject:@(deal.dealId)];
    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    [configManage saveFavoriteDealIdsOfUser:dm.user ids:dm.favoriteDealIds];

    Tao800DealFavoriteDao *favoriteDao = [[Tao800DealFavoriteDao alloc] init];
    [favoriteDao insertFavoriteDeal:deal ofUser:dm.user];
}

- (void)deleteFavoriteDeal:(Tao800DealVo *)deal {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    Tao800DealFavoriteDao *favoriteDao = [[Tao800DealFavoriteDao alloc] init];
    [favoriteDao deleteFavoriteDeal:deal ofUser:dm.user];

    if (dm.favoriteDealIds) {
        [dm.favoriteDealIds removeObject:@(deal.dealId)];
    }
    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    [configManage saveFavoriteDealIdsOfUser:dm.user ids:dm.favoriteDealIds];
}

- (void)deleteFavoriteShop:(Tao800ShopVo *)shopVo {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    Tao800ShopFavoriteDao *favoriteDao = [[Tao800ShopFavoriteDao alloc] init];
    [favoriteDao deleteFavoriteShop:shopVo ofUser:dm.user];

    if (dm.favoriteShopIds) {
        [dm.favoriteShopIds removeObject:shopVo.shopId];
    }
    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    [configManage saveFavoriteShopIdsOfUser:dm.user ids:dm.favoriteShopIds];
}

- (void)saveFavoriteShop:(Tao800ShopVo *)shopVo {
    //刷新商铺
    Tao800ShopDao *dealDao = [[Tao800ShopDao alloc] init];
    [dealDao saveShop:shopVo];

    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    if (!dm.favoriteShopIds) {
        dm.favoriteShopIds = [NSMutableArray arrayWithCapacity:5];
        //同步服务器shopids
        [[Tao800BackgroundServiceManage sharedInstance] loadFavoriteDealIds];
    }

    [dm.favoriteShopIds addObject:shopVo.shopId];
    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    [configManage saveFavoriteShopIdsOfUser:dm.user ids:dm.favoriteShopIds];

    Tao800ShopFavoriteDao *favoriteDao = [[Tao800ShopFavoriteDao alloc] init];
    [favoriteDao insertFavoriteShop:shopVo ofUser:dm.user];
}

- (void)addFavorite:(NSDictionary *)params
         completion:(void (^)(NSDictionary *))completion
            failure:(void (^)(TBErrorDescription *))failure {

    __weak Tao800UserModel *instance = self;

    Tao800DealVo *dealVo = params[@"deal"];
//    NSString *dealId = [NSString stringWithFormat:@"%d", dealVo.dealId];
//    NSDictionary *pDict = @{@"dealId" : dealId};

    [instance saveFavoriteDeal:dealVo];
    completion(@{@"status":@(Tao800UserModelFavoriteOkStatus)});

    //添加到同步队列
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    Tao800FavoriteModel *fModel = [dm.favoriteModelDict objectForKey:dm.user.userId];
    [fModel addFavoriteDeal:dealVo];

//    [self.tao800DealService addFavoriteDeal:pDict
//                                 completion:^(NSDictionary *dict) {
//                                     NSNumber *statusNumber = dict[@"status"];
//                                     NSNumber *dealIdNum = dict[@"dealId"];
//                                     int status = statusNumber.intValue;
//
//                                     if (status == 201|| status==409 || dealIdNum) {
//                                         [instance saveFavoriteDeal:dealVo];
//                                     }
//
//                                     completion(dict);
//                                 }
//                                    failure:^(TBErrorDescription *errorDescription) {
//                                        failure(errorDescription);
//                                    }];
}

- (void)deleteFavorite:(NSDictionary *)params
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure {

    __weak Tao800UserModel *instance = self;
    Tao800DealVo *dealVo = params[@"deal"];
//    NSString *dealId = [NSString stringWithFormat:@"%d", dealVo.dealId];
//    NSDictionary *pDict = @{@"dealids" : dealId};

    [instance deleteFavoriteDeal:dealVo];
    completion(@{@"status":@(Tao800UserModelFavoriteOkStatus)});
    //添加到同步队列
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    Tao800FavoriteModel *fModel = [dm.favoriteModelDict objectForKey:dm.user.userId];
    [fModel deleteFavoriteDeal:dealVo];
//    [self.tao800DealService deleteFavoriteDeal:pDict
//                                    completion:^(NSDictionary *dict) {
//                                        NSNumber *statusNumber = dict[@"status"];
//                                        int status = statusNumber.intValue;
//
//                                        if (status == 201) {
//                                            [instance deleteFavoriteDeal:dealVo];
//                                        }
//
//                                        completion(dict);
//                                    }
//                                       failure:^(TBErrorDescription *errorDescription) {
//                                           failure(errorDescription);
//                                       }];
}

- (void)addShopConcern:(NSDictionary *)params
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure {
    __weak Tao800UserModel *instance = self;

    Tao800ShopVo *shopVo = params[@"shop"];
//    NSDictionary *pDict = @{@"shopId" : shopVo.shopId};
    [instance saveFavoriteShop:shopVo];
    completion(@{@"status":@(Tao800UserModelFavoriteOkStatus)});

    //添加到同步队列
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    Tao800FavoriteModel *fModel = [dm.favoriteModelDict objectForKey:dm.user.userId];
    [fModel addFavoriteShop:shopVo];
//
//    [self.tao800DealService addFavoriteShop:pDict
//                                 completion:^(NSDictionary *dict) {
//                                     NSNumber *statusNumber = dict[@"status"];
//                                     NSNumber *dealIdNum = dict[@"shopId"];
//                                     int status = statusNumber.intValue;
//
//                                     if (status == 201|| status==409 || dealIdNum) {
//                                         [instance saveFavoriteShop:shopVo];
//                                     }
//
//                                     completion(dict);
//                                 }
//                                    failure:^(TBErrorDescription *errorDescription) {
//                                        failure(errorDescription);
//                                    }];
}

- (void)deleteShopConcern:(NSDictionary *)params
               completion:(void (^)(NSDictionary *))completion
                  failure:(void (^)(TBErrorDescription *))failure {
    __weak Tao800UserModel *instance = self;
    Tao800ShopVo *shopVo = params[@"shop"];
//    NSNumber *dealId = shopVo.shopId;
//    NSDictionary *pDict = @{@"id" : dealId};
    [instance deleteFavoriteShop:shopVo];
    completion(@{@"status":@(Tao800UserModelFavoriteOkStatus)});

    //添加到同步队列
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    Tao800FavoriteModel *fModel = [dm.favoriteModelDict objectForKey:dm.user.userId];
    [fModel deleteFavoriteShop:shopVo];
//    [self.tao800DealService deleteFavoriteShop:pDict
//                                    completion:^(NSDictionary *dict) {
//                                        NSNumber *statusNumber = dict[@"status"];
//                                        int status = statusNumber.intValue;
//
//                                        if (status == 201) {
//                                            [instance deleteFavoriteShop:shopVo];
//                                        }
//
//                                        completion(dict);
//                                    }
//                                       failure:^(TBErrorDescription *errorDescription) {
//                                           failure(errorDescription);
//                                       }];
}

@end
