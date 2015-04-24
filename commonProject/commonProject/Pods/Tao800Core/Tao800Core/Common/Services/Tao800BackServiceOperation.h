//
// Created by enfeng on 13-7-17.
// Copyright (c) 2013 enfeng. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Tao800DealService.h"


typedef enum {
    TNOperationFlagAutoLogin,
    TNOperationFlagGetFavoriteDealIds,   //我收藏的团购id
    TNOperationFlagGetFavoriteShopIds,   //我关注的商铺id
    TNOperationFlagGetTagsOfRecommend,   //获取首页推荐的分类
    TNOperationFlagGetCid,   //获取用户设备推荐的淘宝分类id
    TNOperationFlagAddLocalDeals,   //将本地商品收藏上传到服务器
    TNOperationFlagAddLocalShops,   //将本地店铺收藏上传到服务器
    TNOperationFlagGetListTag,      //获取分类tag
    TNOperationFlagGetOperationModel, //获取首页5个模块的信息
    TNOperationFlagGetPromotionHomeOperationModel, //获取大促首页大促商场信息
} TNOperationFlag;

@interface Tao800BackServiceOperation : NSOperation  {
@private
    BOOL _operationFinish;

    TNOperationFlag _operationFlag;
}
@property(nonatomic) TNOperationFlag operationFlag;
@property (nonatomic, strong) Tao800DealService *dealService;
@end