//
//  Tao800UserModel.h
//  tao800
//  从3.1版本开始，去掉了loading; 因此收藏逻辑也做了相应调整
//  1：收藏、取消收藏优先保存到本地
//  2：当进入个人中心我的收藏时，优先同步收藏；之后在获取收藏列表
//  3：退出我的收藏时再做一次检查，如果需要，再做一次同步
//
//  同步分为增量同步和减量同步：
//  1：增量同步为需要添加的ids
//  2：减量同步为需要删除的ids
//
//  Created by enfeng on 14-2-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/TBModel.h>

@class TBErrorDescription;

@interface Tao800UserModel : TBModel

/**
* 将收藏商品保存到本地
*/
- (void)addFavorite:(NSDictionary *)params
         completion:(void (^)(NSDictionary *))completion
            failure:(void (^)(TBErrorDescription *))failure;

- (void)deleteFavorite:(NSDictionary *)params
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure;

/**
* 添加关注商铺
*/
- (void)addShopConcern:(NSDictionary *)params
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure;

/**
* 取消关注商铺
*/
- (void)deleteShopConcern:(NSDictionary *)params
               completion:(void (^)(NSDictionary *))completion
                  failure:(void (^)(TBErrorDescription *))failure;
@end
