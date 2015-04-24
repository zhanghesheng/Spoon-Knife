//
// Created by enfeng on 13-7-17.
// Copyright (c) 2013 enfeng. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <TBUI/TBErrorDescription.h>
#import "Tao800BackServiceOperation.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800ConfigManage.h"
#import "Tao800FavoriteGoodsItem.h"
#import "Tao800FavoriteShopsItem.h"
#import "Tao800NotifycationConstant.h"
#import <TBCore/NSObjectAdditions.h>
#import <TBCore/NSDictionaryAdditions.h>

@interface Tao800BackServiceOperation () {
}

@end

@implementation Tao800BackServiceOperation {

}

- (id)init {
    self = [super init];
    if (self) {
        _dealService = [[Tao800DealService alloc] init];
    }
    return self;
}

- (void)operationFinish {
    _operationFinish = YES;
}

- (void)saveFavoriteDealIds:(NSArray *)items {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    dm.favoriteDealIds = [NSMutableArray arrayWithArray:items];

    Tao800ConfigManage *manage = [[Tao800ConfigManage alloc] init];
    [manage saveFavoriteDealIdsOfUser:dm.user ids:dm.favoriteDealIds];

    _operationFinish = YES;
}

- (void)saveFavoriteShopIds:(NSArray *)items {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    dm.favoriteShopIds = [NSMutableArray arrayWithArray:items];

    Tao800ConfigManage *manage = [[Tao800ConfigManage alloc] init];
    [manage saveFavoriteShopIdsOfUser:dm.user ids:dm.favoriteShopIds];

    _operationFinish = YES;
}

- (void)dealError {
    _operationFinish = YES;
}

- (void)loadFavoriteDealIds {
    __weak Tao800BackServiceOperation *instance = self;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    if (dm.user == nil || dm.user.userId == nil) { //用户未登陆
        _operationFinish = YES;
        return;
    }
    [self.dealService getFavoriteDealIds:@{@"page" : @"1", @"pageset" : @"200"}
                              completion:^(NSDictionary *dict) {
                                  NSArray *items = dict[@"items"];
                                  [instance saveFavoriteDealIds:items];
                              } failure:^(TBErrorDescription *err) {
                [instance dealError];
            }];
}

- (void)loadFavoriteShopIds {
    __weak Tao800BackServiceOperation *instance = self;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    if (dm.user == nil || dm.user.userId == nil) { //用户未登陆
        _operationFinish = YES;
        return;
    }
    [self.dealService getFavoriteShopIds:@{@"page" : @"1", @"pageset" : @"200"}
                              completion:^(NSDictionary *dict) {
                                  NSArray *items = dict[@"items"];
                                  [instance saveFavoriteShopIds:items];

                              } failure:^(TBErrorDescription *err) {
                [instance dealError];
            }];
}

- (void)loadCid {
    __weak Tao800BackServiceOperation *instance = self;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    NSString *macAddress = dm.macAddress;
    if (!macAddress) {
        macAddress = @"";//正常情况下不应该出现空
    }
    [self.dealService getCid:@{@"device_id" : macAddress}
                  completion:^(NSDictionary *dict) {
                      [Tao800DataModelSingleton sharedInstance].recommendCid = dict[@"cid"];
                      [instance operationFinish];
                  }
                     failure:^(TBErrorDescription *err) {
                         [instance dealError];
                     }];
}

-(void)loadOperationModel{
    __weak Tao800BackServiceOperation *instance = self;

    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    NSString *userIdentity = [configManage getUserIdentity];
    if (!userIdentity) {
        userIdentity = @"";
    }
    NSDictionary *dict = @{@"user_type" : @(dm.userType),
            @"user_role" : userIdentity};
    [self.dealService getHomePageOperationInfo:dict
                                    completion:^(NSDictionary *pDict) {
                                        //NSArray *items = pDict[@"items"];
                                        Tao800ConfigManage *manage = [[Tao800ConfigManage alloc] init];
                                        NSMutableArray* arraySave = [NSMutableArray arrayWithCapacity:5];
                                        for(NSDictionary*dic in pDict){
                                            [arraySave addObject:dic];
                                        }
                                        [manage saveOperationModel:arraySave];
                                        if (arraySave && [arraySave count]>0) {
                                            [self performSelector:@selector(operationModelRefresh) withObject:nil afterDelay:.2];
                                        }
                                        [instance operationFinish];
                                    }
                                       failure:^(TBErrorDescription *err) {
                                           [instance dealError];
                                       }];
}

-(void)loadPromotionHomeOperationModel{
    __weak Tao800BackServiceOperation *instance = self;
    
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    NSString *userIdentity = [configManage getUserIdentity];
    if (!userIdentity) {
        userIdentity = @"";
    }
    NSString *student = [configManage getUserStudentIdentity];
    NSDictionary *dict = @{@"user_type" : @(dm.userType),
                           @"user_role" : userIdentity,
                           @"student" : @([student boolValue])};
    
    [self.dealService getPromotionHomePageOperationInfo:dict
                                    completion:^(NSDictionary *pDict) {
                                        NSDictionary *meta = [pDict objectForKey:@"meta" convertNSNullToNil:YES];
                                        dm.enableShowPromotionHomePage = [[meta objectForKey:@"is_promotion" convertNSNullToNil:YES] boolValue];
                                        
                                        Tao800ConfigManage *manage = [[Tao800ConfigManage alloc] init];
                                        [manage savePromotionHomeSettingModel:pDict];

                                        [self performSelector:@selector(promotionOperationModelRefresh) withObject:nil afterDelay:.2];

                                        [instance operationFinish];
                                    }
                                       failure:^(TBErrorDescription *err) {
                                           Tao800ConfigManage *manage = [[Tao800ConfigManage alloc] init];
                                           [manage savePromotionHomeSettingModel:nil];
                                           [instance dealError];
                                       }];
}

-(void)promotionOperationModelRefresh{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:Tao800PromotionOperationModelDidChangeNotification
     object:nil
     userInfo:nil];
}

-(void)operationModelRefresh{
    [[NSNotificationCenter defaultCenter]
            postNotificationName:Tao800OperationModelDidChangeNotification
                          object:nil
                        userInfo:nil];
}


/**
* 获取首页推荐分类
*/
- (void)loadTagsOfRecommend {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    __weak Tao800BackServiceOperation *instance = self;
    NSString *userRole = [dm getUserRole];
    NSString *diviceId = dm.macAddress;
    NSString *userType = [NSString stringWithFormat:@"%d", [dm userType]];

    NSMutableDictionary * dict =[NSMutableDictionary dictionary];

    if (userRole && userRole.length > 0) {
        [dict setObject:userRole forKey:@"user_role"];
    }

    if (userType && userType.length > 0) {
        [dict setObject:userType forKey:@"user_type"];
    }

    if (diviceId && diviceId.length > 0) {
        [dict setObject:diviceId forKey:@"device_id"];
    }

    Tao800ConfigManage* configManage = [[Tao800ConfigManage alloc] init];
    NSString * userStudentIdentity = [configManage getUserStudentIdentity];
    if ([userStudentIdentity isEqualToString:@"YES"]) {
        [dict setObject:@"1" forKey:@"student"];
    }

    [self.dealService getTagsOfRecommend:dict
                              completion:^(NSDictionary *pDict) {
                                  NSArray *items = pDict[@"items"];
                                  Tao800ConfigManage *manage = [[Tao800ConfigManage alloc] init];
                                  [manage saveTagsOfRecommend:items];
                                  [instance operationFinish];
                              }
                                 failure:^(TBErrorDescription *err) {
                                     [instance dealError];
                                 }];
}

//todo 临时方法, 几个版本后会取消
- (void)addLocalFavoriteDeals {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    NSArray *goods = dm.goods;
    NSString *deaIds = nil;
    __weak Tao800BackServiceOperation *instance = self;
    if (!dm.user || !dm.user.userId) { //用户未登录
        [instance operationFinish];
        return;
    }

    if (!dm.goods) {
        //没有本地收藏
        [instance operationFinish];
        return;
    }

    NSMutableArray *fDealIds = [NSMutableArray arrayWithCapacity:20];
    if (goods && goods.count > 0) {
        NSMutableArray *ids = [NSMutableArray arrayWithCapacity:goods.count];
        for (Tao800FavoriteGoodsItem *item in goods) {
            NSString *dealId = [NSString stringWithFormat:@"%d", item.dealVo.dealId];
            [ids addObject:dealId];

            [fDealIds addObject:@(item.dealVo.dealId)];
        }
        deaIds = [ids componentsJoinedByString:@","];
    }
    if (!deaIds) {
        [instance operationFinish];
        return;
    }
    NSDictionary *dictionary = @{@"dealId":deaIds};
    [self.dealService addFavoriteDeal:dictionary
                           completion:^(NSDictionary *pDict) {
                               NSNumber *statusNumber = pDict[@"status"];
                               int status = statusNumber.intValue;

                               if (status == 201) {
                                   dm.goods = nil;
                                   dm.favoriteDealIds = fDealIds;
                                   [dm archive];
                               } else {
                                   //收藏失败
                               }
                               [instance operationFinish];
                           }
                              failure:^(TBErrorDescription *err) {
                                  [instance dealError];
                              }];

}

//todo 临时方法, 几个版本后会取消
- (void)addLocalFavoriteShops {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    NSArray *shops = dm.shops;
    NSString *shopIds = nil;
    __weak Tao800BackServiceOperation *instance = self;
    if (!dm.user || !dm.user.userId) { //用户未登录
        [instance operationFinish];
        return;
    }

    if (!dm.shops) {
        //没有本地收藏
        [instance operationFinish];
        return;
    }

    NSMutableArray *fShopIds = [NSMutableArray arrayWithCapacity:20];
    if (shops && shops.count > 0) {
        NSMutableArray *ids = [NSMutableArray arrayWithCapacity:shops.count];
        for (Tao800FavoriteShopsItem *item in shops) {
            NSString *wholeId = [NSString stringWithFormat:@"%@", item.dealVo.shopVo.clickUrl];
            NSArray *components = [wholeId componentsSeparatedByString:@"/"];
            NSString *shopId = [components lastObject];
            [ids addObject:shopId];
        }
        shopIds = [ids componentsJoinedByString:@","];
    }
    if (!shopIds) {
        [instance operationFinish];
        return;
    }
    NSDictionary *dictionary = @{@"shopId":shopIds};
    [self.dealService addFavoriteShop:dictionary
                           completion:^(NSDictionary *dict) {
                               NSNumber *statusNumber = dict[@"status"];
                               int status = statusNumber.intValue;

                               if (status == 201) {
                                   dm.shops = nil;
                                   dm.favoriteShopIds = fShopIds;
                                   [dm archive];
                               } else {
                                   //收藏失败
                               }
                               [instance operationFinish];

                           }
                              failure:^(TBErrorDescription *err){
                                  [instance dealError];
                              }];
}

- (void)main {
    _operationFinish = NO;

    switch (_operationFlag) {

        case TNOperationFlagAutoLogin: {
        }
            break;

        case TNOperationFlagGetFavoriteDealIds: {
            [self loadFavoriteDealIds];
        }
            break;

        case TNOperationFlagGetFavoriteShopIds: {
            [self loadFavoriteShopIds];
        }
            break;
        case TNOperationFlagGetOperationModel:{
            [self loadOperationModel];
        }
            break;
        case TNOperationFlagGetPromotionHomeOperationModel:{
            [self loadPromotionHomeOperationModel];
        }
            break;
        case TNOperationFlagGetTagsOfRecommend: {
            [self loadTagsOfRecommend];
        }
            break;
        case TNOperationFlagGetCid: {
            [self loadCid];
        }
            break;
        case TNOperationFlagAddLocalDeals: {
            [self addLocalFavoriteDeals];
        }
            break;
        case TNOperationFlagAddLocalShops: {
            [self addLocalFavoriteShops];
        }
            break;
        case TNOperationFlagGetListTag:
            break;
    }

    do {
        [NSThread sleepForTimeInterval:1];

        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    } while (!_operationFinish);
}

@end