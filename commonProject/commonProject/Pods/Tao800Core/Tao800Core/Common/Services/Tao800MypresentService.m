//
//  Tao800MypresentService.m
//  tao800
//
//  Created by zhangwenguang on 13-4-7.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800MypresentService.h"
#import "TBCore/TBCoreMacros.h"
#import "TBCore/TBCore.h"


@implementation Tao800MypresentService

//Class testClass=NSClassFromString(@”testClass”);  Tao800AuctionDealVo
- (NSArray *)convertJsonToAuction:(NSDictionary *)dict withServiceTag:(ServiceTag)serviceTag
{
    NSMutableArray *thearr = [[NSMutableArray alloc] init];
    NSString *count = [dict objectForKey:@"count"];
    
    @try {
        NSArray *arr= [dict objectForKey:@"orders"];
        
        for (NSDictionary *item in arr) {
            
            Tao800AuctionOrderVo *order = [[Tao800AuctionOrderVo alloc] init];
            
            order.count = [count intValue];
            
            NSDictionary  *dealDict = [item objectForKey:@"deal"];
            
            order.url_name = [dealDict objectForKey:@"url_name"];
            order.title = [dealDict objectForKey:@"title"];
            order.price = [dealDict objectForKey:@"price"];
            
            NSDictionary *imageDict = [dealDict objectForKey:@"image_url"];
            
            order.image_big = [imageDict objectForKey:@"big"];
            order.image_normal = [imageDict objectForKey:@"normal"];
            order.image_small = [imageDict objectForKey:@"small"];
            
            
            NSDictionary *addrDict = [item objectForKey:@"addr"];
            
            order.consignee_name = [addrDict objectForKey:@"consignee_name"];
            order.info = [addrDict objectForKey:@"info"];
            order.phone_number = [addrDict objectForKey:@"phone_number"];
            order.telephone = [addrDict objectForKey:@"telephone"];
            
            
            NSDictionary *topicsDict = [item objectForKey:@"topics"];
            
            order.url = [topicsDict objectForKey:@"url"];
            order.create_url = [topicsDict objectForKey:@"create_url"];
            
            
            NSNumber* orderIdNum = [item objectForKey:@"id"];
            if (orderIdNum) {
                order.orderId = orderIdNum.intValue;
            }
            
            NSNumber* oversold = [item objectForKey:@"oversold"];
            NSNumber* scrore = [item objectForKey:@"score"];
            NSNumber* shipped_status = [item objectForKey:@"shipped_status"];
            NSNumber* showed_status = [item objectForKey:@"showed_status"];
            NSNumber* tao_jifen_deal_id = [item objectForKey:@"tao_jifen_deal_id"];
            NSNumber* topic_id = [item objectForKey:@"topic_id"];
            NSNumber* user_id = [item objectForKey:@"user_id"];
            //int  BOOL
            order.oversold = oversold.boolValue;
            order.score = scrore.intValue;
            order.showed_status = showed_status.boolValue;
            order.shipped_status = shipped_status.intValue;
            
            
            order.tao_jifen_deal_id = tao_jifen_deal_id.intValue;
            order.topic_id = topic_id.intValue;
            order.user_id = user_id.intValue;
            //nsstring
            
            order.created_at = [item objectForKey:@"created_at"];
            order.memo = [item objectForKey:@"memo"];
            order.no = [item objectForKey:@"no"];
            order.sku_attr = [item objectForKey:@"sku_attr"];
            order.user_name = [item objectForKey:@"user_name"];
            order.courier_no = [item objectForKey:@"courier_no"];
            order.courier_name = [item objectForKey:@"courier_name"];
            
            [order  resetNullProperty];
            
            [thearr addObject:order];
        }
    } @catch (NSException *e) {
        TBDPRINT(@"convertJsonToPresent 字符串 转换 数字错误");
    }
    return thearr;
}

- (NSArray *)convertJsonToPresent:(NSDictionary *)dict withServiceTag:(ServiceTag)serviceTag
{
    NSMutableArray *thearr = [[NSMutableArray alloc] init];
    NSString *count = [dict objectForKey:@"count"];

    @try {
        NSArray *arr= [dict objectForKey:@"orders"];
        
        for (NSDictionary *item in arr) {

            Tao800RewardOrderVo *order = [[Tao800RewardOrderVo alloc] init];

                order.count = [count intValue];
            
            NSDictionary  *dealDict = [item objectForKey:@"deal"];

                order.url_name = [dealDict objectForKey:@"url_name"];
                order.title = [dealDict objectForKey:@"title"];
                order.price = [dealDict objectForKey:@"price"];
            
            NSDictionary *imageDict = [dealDict objectForKey:@"image_url"];

                order.image_big = [imageDict objectForKey:@"big"];
                order.image_normal = [imageDict objectForKey:@"normal"];
                order.image_small = [imageDict objectForKey:@"small"];


            NSDictionary *addrDict = [item objectForKey:@"addr"];

                order.consignee_name = [addrDict objectForKey:@"consignee_name"];
                order.info = [addrDict objectForKey:@"info"];
                order.phone_number = [addrDict objectForKey:@"phone_number"];
                order.telephone = [addrDict objectForKey:@"telephone"];

            
            NSDictionary *topicsDict = [item objectForKey:@"topics"];

                order.url = [topicsDict objectForKey:@"url"];
                order.create_url = [topicsDict objectForKey:@"create_url"];            
            
            
             NSNumber* orderIdNum = [item objectForKey:@"id"];
             if (orderIdNum) {
             order.orderId = orderIdNum.intValue;
             }
            
            NSNumber* oversold = [item objectForKey:@"oversold"];
            NSNumber* scrore = [item objectForKey:@"score"];
            NSNumber* shipped_status = [item objectForKey:@"shipped_status"];
            NSNumber* showed_status = [item objectForKey:@"showed_status"];
            NSNumber* tao_jifen_deal_id = [item objectForKey:@"tao_jifen_deal_id"];
            NSNumber* topic_id = [item objectForKey:@"topic_id"];
            NSNumber* user_id = [item objectForKey:@"user_id"];
            //int  BOOL
            order.oversold = oversold.boolValue;
            order.score = scrore.intValue;
            order.showed_status = showed_status.boolValue;
            order.shipped_status = shipped_status.intValue;


            order.tao_jifen_deal_id = tao_jifen_deal_id.intValue;
            order.topic_id = topic_id.intValue;
            order.user_id = user_id.intValue;
            //nsstring

            order.created_at = [item objectForKey:@"created_at"];
            order.memo = [item objectForKey:@"memo"];
            order.no = [item objectForKey:@"no"];
            order.sku_attr = [item objectForKey:@"sku_attr"];
            order.user_name = [item objectForKey:@"user_name"];
            order.courier_no = [item objectForKey:@"courier_no"];
            order.courier_name = [item objectForKey:@"courier_name"];
            
            [order  resetNullProperty];
            
            [thearr addObject:order];
        }
    } @catch (NSException *e) {
        TBDPRINT(@"convertJsonToPresent 字符串 转换 数字错误");
    }
    return thearr;
}



//请求我的抽奖奖品  列表接口
/**
 *@params
 
 **/
- (void)getMyPresentList:(NSDictionary *)params
{
    NSString *limit = [params objectForKey:@"limit"];
    NSString *offset = [params objectForKey:@"offset"];
    //3.1.1新增字段cash_order = 1 返回现金购
    NSString *urlStr = [NSString stringWithFormat:@"%@/profile/orders/raffle?limit=%d&offset=%d&cash_order=1",UrlBaseNeedLogin,[limit intValue],[offset intValue]];
    
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceGetPresentListViewTag;
    [request setRequestMethod :TBRequestMethodGet];
    
    [self send:request];
    
}
//请求我的积分兑换商品  列表接口
/**
 *@params
 
 **/
- (void)getExchangeDealList:(NSDictionary *)params
{
    NSString *limit = [params objectForKey:@"limit"];
    NSString *offset = [params objectForKey:@"offset"];
    //3.1.1新增字段cash_order = 1 返回现金购
    NSString *urlStr = [NSString stringWithFormat:@"%@/profile/orders/welfare?limit=%d&offset=%d&cash_order=1",UrlBaseNeedLogin,[limit intValue],[offset intValue]];

    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceGetExchangeDealTag;
    [request setRequestMethod :TBRequestMethodGet];
    
    [self send:request];
}

//请求我的积分拍卖商品  列表接口
/**
 *@params
 
 **/

- (void)getMyPresentAuctinList:(NSDictionary *)params
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/profile/orders/auction",UrlBaseNeedLogin];
    
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceGetPresentAuctionTag;
    [request setRequestMethod :TBRequestMethodGet];
    
    [self send:request];
}

- (void)requestFinished:(ASIHTTPRequest *)requestParam {
    TBASIFormDataRequest *request = (TBASIFormDataRequest *) requestParam;
    
    if (self.delegate == nil) {
        return;
    }
    
    NSDictionary *dict = [self getResponseJsonResult:request];
    if(dict == nil){ //网络错误
        return;
    }
    
    SEL sel = nil;
    NSObject *retObj = nil;
    
    switch (request.serviceMethodFlag) {
        case ServiceGetPresentListViewTag:
        {
            sel = @selector(getMyPresentListRewardFinish:);//
            NSArray *arr = [self convertJsonToPresent:dict withServiceTag:request.serviceMethodFlag];
            retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
        }
            break;
        case ServiceGetExchangeDealTag:
        {
            sel = @selector(getMyPresentListScoreFinish:);
            NSArray *arr = [self convertJsonToPresent:dict withServiceTag:request.serviceMethodFlag];
            retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
        }
            break;
        case ServiceGetPresentAuctionTag:
        {
            sel = @selector(getMyPresentListAuctionFinish:);
            NSArray *arr = [self convertJsonToAuction:dict withServiceTag:request.serviceMethodFlag];
            
            retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
        }
            break;
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:sel]) {
        TB_PERFORM_SELECTOR_LEAK_WARNING([self.delegate performSelector:sel withObject:retObj]);
    }
    
    [super requestFinished:request];
}

@end