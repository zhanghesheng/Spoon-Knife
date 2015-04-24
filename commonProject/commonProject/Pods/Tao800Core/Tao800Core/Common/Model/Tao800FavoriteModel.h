//
//  Tao800FavoriteModel.h
//  tao800
//
//  Created by enfeng on 14-4-8.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tao800DealVo;
@class Tao800ShopVo;

extern int const FavoriteModelMaxTaskCount;
extern int const DealFavoriteModelMaxTaskCount;
extern int const ShopFavoriteModelMaxTaskCount;

@interface Tao800FavoriteModel : NSObject <NSCoding>

@property(nonatomic, strong) NSMutableDictionary *addDealsFavoriteDict;
@property(nonatomic, strong) NSMutableDictionary *deleteDealsFavoriteDict;
@property(nonatomic, strong) NSMutableDictionary *addShopsFavoriteDict;
@property(nonatomic, strong) NSMutableDictionary *deleteShopsFavoriteDict;

@property(nonatomic, strong) NSMutableArray *dealKeyArray;
@property(nonatomic, strong) NSMutableArray *shopKeyArray;
@property(nonatomic, strong) NSString *shopSynchronizationKey;   //正在同步的key, 同步成功后删除key，以及key对应的数组
@property(nonatomic, strong) NSString *dealSynchronizationKey;   //正在同步的key, 同步成功后删除key，以及key对应的数组
@property(nonatomic) int dealFinishCount; // 两个商品的
@property(nonatomic) int shopFinishCount; //  两个商铺的
@property(nonatomic) int finishCount; // 两个商品的， 两个商铺的 和

- (id)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;

- (void)addFavoriteDeal:(Tao800DealVo *)dealVo;

- (void)deleteFavoriteDeal:(Tao800DealVo *)dealVo;

- (void)addFavoriteShop:(Tao800ShopVo *)shopVo;

- (void)deleteFavoriteShop:(Tao800ShopVo *)shopVo;

/**
* 同步收藏信息，包括商品和店铺
* 只在注销和登录时调用
*/
- (void)synchronizationFavorite;

- (void)synchronizationDealFavorite;

- (void)synchronizationShopFavorite;
@end
