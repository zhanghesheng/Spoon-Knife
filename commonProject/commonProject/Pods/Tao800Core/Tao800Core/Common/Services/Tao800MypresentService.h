//
//  Tao800MypresentService.h
//  tao800
//
//  Created by zhangwenguang on 13-4-7.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BaseService.h"
#import "Tao800RewardOrderVo.h"
#import "Tao800AuctionOrderVo.h" //我的奖品，竞拍列表单元数据类


@protocol Tao800MypresentServiceDelegate <TBBaseNetworkDelegate>
@optional

- (void)getMyPresentListRewardFinish:(NSDictionary *)params;//抽奖奖品
- (void)getMyPresentListScoreFinish:(NSDictionary *)params;//积分兑换
- (void)getMyPresentListAuctionFinish:(NSDictionary *)params;

- (void)getExchangeDealListFinish:(NSDictionary *)params;
//- (void)getMyPresentDetailDataFinish:(NSDictionary *)params;

@end



@interface Tao800MypresentService : Tao800BaseService{
        
}

//请求抽奖商品列表接口
/**
 *@params
 
 **/
- (void)getMyPresentList:(NSDictionary *)params;

//请求兑换商品列表接口
/**
 *@params
 
 **/
- (void)getExchangeDealList:(NSDictionary *)params;

//请求我的积分拍卖商品  列表接口
/**
 *@params
 
 **/

- (void)getMyPresentAuctinList:(NSDictionary *)params;

//请求我的礼品(抽奖奖品)列表接口
/**
 *@params   
 
 暂不需要此接口
 
 **/
//- (void)getMyPresentDetailData:(NSDictionary *)params;

@end
