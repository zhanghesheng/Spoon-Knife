//
// Created by enfeng on 13-7-17.
// Copyright (c) 2013 enfeng. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface Tao800BackgroundServiceManage : NSObject {
@private
    NSOperationQueue *_queue;
    NSOperationQueue *_imageDownloadQueue;
}

+ (Tao800BackgroundServiceManage *)sharedInstance;

- (void)autoLogin;

-(void)addLocalFavoriteDeals;

-(void)addLocalFavoriteShops;

- (void)loadFavoriteDealIds;

- (void)loadFavoriteShopIds;

/*
 获取首页5个模块信息
 */
- (void)loadOperationModel;
/*
 获取大促首页大促商场信息
 */
- (void)loadPromotionOperationModel;
/**
* 获取首页推荐分类
*/
- (void)loadTagsOfRecommend;

- (void)loadTagList;

/**
*  获取用户设备推荐的淘宝分类id
*/
- (void) loadCid;

/**
* 下载图片
* 下载完成后会保存到TBURLCache
*
*/
- (void)downloadImage:(NSString *)imageUrl;
@end