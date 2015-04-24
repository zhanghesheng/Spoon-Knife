//
//  Tao800PointService.m
//  tao800
//
//  Created by enfeng on 14-4-30.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/TBErrorDescription.h>
#import "Tao800PointService.h"
#import "Tao800PointDetailExchangeDealVo.h"
#import "Tao800PointDetailRewardDealVo.h"
#import "TBCore/TBCore.h"
#import "Tao800PointDetailAuctionVo.h"
#import "Tao800PointDetailAuctionerListItem.h"
#import "Tao800ScoreFeedbackOrderVo.h"

#import "Tao800BaseService.h"
#import "Tao800RewardOrderVo.h"
#import "Tao800AuctionOrderVo.h" //我的奖品，竞拍列表单元数据类

@implementation Tao800PointService

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
            order.price = [dealDict objectForKey:@"list_price"];
            
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

- (void)convertToAuctionDeal:(NSDictionary *)input deal:(Tao800PointDetailAuctionVo *)output {
    if (input == nil || ![input isKindOfClass:NSDictionary.class]) {
        return;
    }

    if ([input objectForKey:@"deal"]) {

        NSDictionary *dealDic = [input objectForKey:@"deal"];
        [self convertToCommonDeal:dealDic deal:output];
        output.minAddedScore = [[dealDic objectForKey:@"min_added_jifen"] intValue];
        output.maxConsumeScore = [[dealDic objectForKey:@"max_consume_jifen"] intValue];
        output.endTime = [dealDic objectForKey:@"auction_end_time"];

        if ([[dealDic objectForKey:@"join_count"] intValue] > 0 && [input objectForKey:@"last_bider"] != nil) {
            NSDictionary *lastDic = [input objectForKey:@"last_bider"];
            Tao800PointDetailAuctionLastBiderVo *lastBider = [[Tao800PointDetailAuctionLastBiderVo alloc] init];
            lastBider.userId = [NSString stringWithFormat:@"%@", [lastDic objectForKey:@"user_id"]];
            lastBider.consumeScore = [NSString stringWithFormat:@"%@", [lastDic objectForKey:@"consume_jifen"]];
            lastBider.createTime = [lastDic objectForKey:@"create_time"];
            output.lastBider = lastBider;
        }


//接口字段问题临时处理
        NSDictionary *imageDict = [[dealDic objectForKey:@"image"] objectForKey:@"image"];
        if (imageDict != nil) {
            output.smallImgUrl = (NSString *) [self convertNSNullClass:[[imageDict objectForKey:@"small"] objectForKey:@"url"]];
            output.bigImgUrl = (NSString *) [self convertNSNullClass:[[imageDict objectForKey:@"big"] objectForKey:@"url"]];

            //商品详情中支持多图滑动
            NSMutableArray *images = [[NSMutableArray alloc] init];
            if (output.bigImgUrl != nil) {
                [images addObject:output.bigImgUrl];
            }
            output.dealImgUrls = images;

        }
    }
    else {
        [self convertToCommonDeal:input deal:output];
        output.maxConsumeScore = [[input objectForKey:@"max_consume_jifen"] intValue];
        output.minAddedScore = [[input objectForKey:@"min_added_jifen"] intValue];

// 接口字段问题临时处理
        NSDictionary *imageDict = [[input objectForKey:@"image"] objectForKey:@"image"];
        if (imageDict != nil) {
            output.smallImgUrl = (NSString *) [self convertNSNullClass:[[imageDict objectForKey:@"small"] objectForKey:@"url"]];
            output.bigImgUrl = (NSString *) [self convertNSNullClass:[[imageDict objectForKey:@"big"] objectForKey:@"url"]];

            //商品详情中支持多图滑动
            NSMutableArray *images = [[NSMutableArray alloc] init];
            if (output.bigImgUrl != nil) {
                [images addObject:output.bigImgUrl];
            }
            output.dealImgUrls = images;

        }
    }

    output.dealProperty = [input objectForKey:@"sku"];
    output.status = [[input objectForKey:@"status"] intValue];
    output.exchangeStatus = [[input objectForKey:@"status"] intValue];

    if ([[input objectForKey:@"join_count"] intValue] > 0 && [input objectForKey:@"last_bider"] != nil) {

        NSDictionary *lastDic = [input objectForKey:@"last_bider"];
        output.lastBider.userId = [NSString stringWithFormat:@"%@", [lastDic objectForKey:@"user_id"]];
        output.lastBider.consumeScore = [NSString stringWithFormat:@"%@", [lastDic objectForKey:@"consume_jifen"]];
        output.lastBider.createTime = [lastDic objectForKey:@"create_time"];
    }

    [output resetNullProperty];
}

//积分拍卖
- (NSArray *)convertToAuctionDealList:(NSDictionary *)input {
    NSMutableArray *returnValue = [[NSMutableArray alloc] init];

    if (input == nil) {
        return returnValue;
    }
    else if (![[input objectForKey:@"deals"] isKindOfClass:NSArray.class]) {
        return returnValue;
    }

    for (NSDictionary *element in [input objectForKey:@"deals"]) {
        Tao800PointDetailAuctionVo *vo = [[Tao800PointDetailAuctionVo alloc] init];
        [self convertToAuctionDeal:element deal:vo];
        [returnValue addObject:vo];

    }
    return returnValue;
}

//竞拍人列表信息
-(NSArray *)convertToAuctionBidersList: (NSDictionary *)input
{
    NSMutableArray *returnValue = [[NSMutableArray alloc] init];
    
    if(input == nil)
    {
        return returnValue;
    }
    else if(![[input objectForKey:@"item"] isKindOfClass:NSArray.class])
    {
        return returnValue;
    }
    
    for(NSDictionary *element in [input objectForKey:@"item"])
    {
        Tao800PointDetailAuctionerListItem *tempItem = [[Tao800PointDetailAuctionerListItem alloc] init];
        tempItem.name =  [element objectForKey:@"user_name"];
        tempItem.price = [NSString stringWithFormat:@"%@",[element objectForKey:@"consume_jifen"]];
        tempItem.date =  [element objectForKey:@"create_time"];
        tempItem.grade = [NSString stringWithFormat:@"%@",[element objectForKey:@"user_grade"]];
        [tempItem resetNullProperty];
        [returnValue addObject: tempItem];
        
    }
    return returnValue;
}


- (void)convertToRewardDeal:(NSDictionary *)input deal:(Tao800PointDetailRewardDealVo *)output {
    if (input == nil || ![input isKindOfClass:NSDictionary.class]) {
        return;
    }

    [self convertToCommonDeal:input deal:output];
    output.winners = [input objectForKey:@"users"];
    output.rewardStatus = [[input objectForKey:@"status"] intValue];
    output.beginTime = [input objectForKey:@"begun_at"];
    output.endTime = [input objectForKey:@"ended_at"];

    [output resetNullProperty];
}

- (NSArray *)convertToRewardDealList:(NSDictionary *)input {
    NSMutableArray *returnValue = [[NSMutableArray alloc] init];

    if (input == nil) {
        return returnValue;
    }
    else if (![input isKindOfClass:NSArray.class]) {
        return returnValue;
    }

    for (NSDictionary *element in input) {
        Tao800PointDetailRewardDealVo *vo = [[Tao800PointDetailRewardDealVo alloc] init];
        [self convertToRewardDeal:element deal:vo];
        [returnValue addObject:vo];

    }

    return returnValue;
}

//解析
- (void)convertToCommonDeal:(NSDictionary *)input deal:(Tao800PointDetailCommonDealVo *)output {
    if (input == nil || ![input isKindOfClass:NSDictionary.class]) {
        return;
    }

    output.dealId = [[input objectForKey:@"id"] intValue];
    output.needScore = [[input objectForKey:@"required_jifen"] intValue];
    output.urlName = [input objectForKey:@"url_name"];
    output.title = [input objectForKey:@"title"];
    output.description = [input objectForKey:@"description"];
    output.price = [[input objectForKey:@"price"] intValue];
    output.beginTime = [input objectForKey:@"begun_at"];
    output.endTime = [input objectForKey:@"ended_at"];
    output.joinCount = [[input objectForKey:@"join_count"] intValue];
    output.dealCount = [[input objectForKey:@"total_count"] intValue];
    output.grade = [[input objectForKey:@"required_user_rank"] intValue];
    output.dealType = [[input objectForKey:@"deal_type"] intValue];
    output.currentPrice = [[input objectForKey:@"cur_price"] intValue];

    NSDictionary *sku = [input objectForKey:@"sku"];
    NSArray *items = [sku objectForKey:@"items"];
    output.oos = DealSaleStateSellOut;
    for (int i = 0; i < items.count; i++) {
        BOOL isOut = [[[items objectAtIndex:i] objectForKey:@"oos"] boolValue];
        if (!isOut) {//如果有一个未卖完的，那么oos就设置为DealSaleStateSelling
            output.oos = DealSaleStateSelling;
        }
    }
    [output resetNullProperty];
    NSDictionary *imageDict = [input objectForKey:@"image_url"];
    if (imageDict != nil) {
        output.smallImgUrl = (NSString *) [self convertNSNullClass:[imageDict objectForKey:@"small"]];
        output.bigImgUrl = (NSString *) [self convertNSNullClass:[imageDict objectForKey:@"big"]];

        //商品详情中支持多图滑动
        NSMutableArray *images = [[NSMutableArray alloc] init];
        if (output.bigImgUrl != nil) {
            [images addObject:output.bigImgUrl];
        }
        output.dealImgUrls = images;

    }
}

- (void)convertToExchangeDeal:(NSDictionary *)input deal:(Tao800PointDetailExchangeDealVo *)output {
    if (input == nil || ![input isKindOfClass:NSDictionary.class]) {
        return;
    }

    [self convertToCommonDeal:input deal:output];
    output.dealProperty = [input objectForKey:@"sku"];
    output.exchangeStatus = [[input objectForKey:@"status"] intValue];
    NSNumber *noAddr = [input objectForKey:@"no_addr" convertNSNullToNil:YES];
    output.noAddr = NO;
    if(noAddr != nil){
        output.noAddr = [noAddr boolValue];
    }
    NSNumber *mustMemo = [input objectForKey:@"must_memo" convertNSNullToNil:YES];
    output.mustMemo = NO;
    if(mustMemo != nil){
        output.mustMemo = [mustMemo boolValue];
    }
    output.memoPlaceholder = [input objectForKey:@"memo" convertNSNullToNil:YES];
    [output resetNullProperty];
}

- (NSArray *)convertToExchangeDealList:(NSDictionary *)input {
    NSMutableArray *returnValue = [[NSMutableArray alloc] init];

    if (input == nil) {
        return returnValue;
    }
    else if (![input isKindOfClass:NSArray.class]) {
        return returnValue;
    }

    for (NSDictionary *element in input) {
        Tao800PointDetailExchangeDealVo *vo = [[Tao800PointDetailExchangeDealVo alloc] init];
        [self convertToExchangeDeal:element deal:vo];
        [returnValue addObject:vo];

    }
    return returnValue;
}

-(NSArray *)convertToScoreFeedbackOrderList: (NSDictionary *)input
{
    NSMutableArray *returnValue = [[NSMutableArray alloc] init] ;
    
    if(input == nil)
    {
        return returnValue;
    }
    
    NSArray *trades = [input objectForKey:@"trades"];
    
    for(NSDictionary *element in trades)
    {
        Tao800ScoreFeedbackOrderVo *vo = [[Tao800ScoreFeedbackOrderVo alloc] init];
        [self convertToScoreFeedbackOrder: element order: vo];
        [vo resetNullProperty];
        [returnValue addObject: vo];
        
    }
    
    return returnValue;
}

-(void)convertToScoreFeedbackOrder:(NSDictionary *)input order:(Tao800ScoreFeedbackOrderVo *)output
{
    if(input == nil || ![input isKindOfClass:NSDictionary.class])
    {
        return;
    }
    
    output.dealId = [input objectForKey: @"deal"];
    output.earnScore = [input objectForKey: @"score"];
    output.title = [input objectForKey: @"title"];
    output.price = [[input objectForKey: @"price"] intValue];
    output.originPrice = [[input objectForKey: @"list_price"] intValue];
    output.discount = [input objectForKey: @"discount"];
    output.orderId = [input objectForKey: @"id"];
    output.tradeId = [input objectForKey: @"trade_id"];
    output.tradeTopic = [input objectForKey: @"trade_topic"];
    output.readStatus = [[input objectForKey: @"read_status"] intValue];
    output.createTime = [input objectForKey: @"create_time"];
    output.topic = [input objectForKey:@"topics"];
    
    NSDictionary *imageDict = [input objectForKey: @"image_url"];
    if(imageDict != nil)
    {
        output.imgUrl = [imageDict objectForKey: @"big"];
    }
    
    NSDictionary *topicDict = [input objectForKey: @"topics"];
    if(topicDict != nil)
    {
        output.hasPosted = [[topicDict objectForKey: @"has_posted"] boolValue];
    }
}

-(void)convertToScoreCashDeal: (NSDictionary *)input deal: (Tao800PointDetailExchangeDealVo *)output{
    if(input == nil || ![input isKindOfClass:NSDictionary.class]){
        return;
    }
    
    [self convertToExchangeDeal:input deal:output];
    output.htmlString = [input objectForKey: @"desc"];
    NSDictionary *sellerInfo = [input objectForKey:@"seller_info" convertNSNullToNil:YES];
    if(sellerInfo != nil){
        output.sellerId = [sellerInfo objectForKey:@"seller_id" convertNSNullToNil:YES];
    }
    output.maxLimit = [[input objectForKey:@"max_buy_limit"] intValue];
    output.postInfo = (NSDictionary *)[self convertNSNullClass:[input objectForKey:@"post"]];
    output.zId = (NSString *)[self convertNSNullClass:[input objectForKey:@"zid"]];
    [output resetNullProperty];
}


//2.8版本
- (NSString *)timeSp {
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long) [datenow timeIntervalSince1970]];
    return timeSp;
}

- (void)getZeroExchangeDeals:(NSDictionary *)paramsExt
                  completion:(void (^)(NSDictionary *))completion
                     failure:(void (^)(TBErrorDescription *))failure {

    //todo 临时将2.8的逻辑拷过来
    NSString *limit = [paramsExt objectForKey:@"limit"];
    NSString *offset = [paramsExt objectForKey:@"offset"];
    NSString *dealStatus = [paramsExt objectForKey:@"dealStatus"];
    NSString *virtual = @"true";//新增是否返回虚拟商品参数，默认为false
    if (dealStatus == nil) {
        dealStatus = @"all";
    }
    NSString *scoreCash = [paramsExt objectForKey:@"scoreCash"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/welfare/%@?more=true&operator=all&limit=%@&offset=%@&grade=1&virtual=%@&score_cash=%@",
                                                                 UrlBaseNeedLogin, dealStatus, limit, offset, virtual,scoreCash]];
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://zapi.xiongmaoz.com/welfare/%@?limit=%@&offset=%@&grade=1&virtual=%@&score_cash=1",
//                                        dealStatus, limit, offset, virtual]];//todo url

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;

    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PointService *instance = self;


    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        NSArray *arr = [instance convertToExchangeDealList:dict];
        NSDictionary *retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];

        completion(retObj);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];

}

- (void)getZeroExchangeDealDetail:(NSDictionary *)paramt
                 completion:(void (^)(NSDictionary *))completion
                    failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *urlName = [paramt objectForKey:@"urlName"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/welfare/%@",
                                       UrlBaseNeedLogin, urlName]];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PointService *instance = self;
    
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        Tao800PointDetailExchangeDealVo *vo = [[Tao800PointDetailExchangeDealVo alloc] init];
        [self convertToExchangeDeal: dict deal: vo];
        
        NSNumber *type = [NSNumber numberWithInt:2];
        NSDictionary *retObj = [NSDictionary dictionaryWithObjectsAndKeys:vo,@"deal",type,@"pageType",nil];
        completion(retObj);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getRewardDeals:(NSDictionary *)paramsExt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure {

    NSString *limit = [paramsExt objectForKey:@"limit"];
    NSString *offset = [paramsExt objectForKey:@"offset"];
    NSString *dealStatus = [paramsExt objectForKey:@"dealStatus"];
    if (dealStatus == nil) {
        dealStatus = @"all";
    }

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/raffle/%@?limit=%@&offset=%@&grade=1",
                                                                 UrlBaseNeedLogin, dealStatus, limit, offset]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;

    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PointService *instance = self;


    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        NSArray *arr = [self convertToRewardDealList:dict];
        NSDictionary *retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];

        completion(retObj);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
}


//请求  抽奖奖品  详情接口
/**
 *@params
 *
 **/
- (void)getRewardDealDetail:(NSDictionary *)paramt
                 completion:(void (^)(NSDictionary *))completion
                    failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *urlName = [paramt objectForKey:@"urlName"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/raffle/%@",
                                       UrlBaseNeedLogin, urlName]];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PointService *instance = self;
    
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        Tao800PointDetailRewardDealVo *vo = [[Tao800PointDetailRewardDealVo alloc] init];
        [self convertToRewardDeal: dict deal: vo];
        
        NSNumber *type = [NSNumber numberWithInt:1];
        NSDictionary *retObj = [NSDictionary dictionaryWithObjectsAndKeys:vo,@"deal",type,@"pageType",nil];
        completion(retObj);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getAuctionDeals:(NSDictionary *)paramsExt
             completion:(void (^)(NSDictionary *))completion
                failure:(void (^)(TBErrorDescription *))failure {

    NSString *limit = [paramsExt objectForKey:@"limit"];
    NSString *offset = [paramsExt objectForKey:@"offset"];

    int page = [offset intValue];
    int pageSize = [limit intValue];
    page = page / pageSize + 1;

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/auction?start=0&rank=0&tag=0&page=%i&per_page=%@&time=%@",
                                                                 UrlBaseNeedLogin, page, limit, [self timeSp]]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;

    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PointService *instance = self;


    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }

        NSArray *arr = [self convertToAuctionDealList:dict];

        NSDictionary *retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
        completion(retObj);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
}

- (void)getAuctionDealDetail:(NSDictionary *)paramt
                 completion:(void (^)(NSDictionary *))completion
                    failure:(void (^)(TBErrorDescription *))failure{

    NSString *urlName = nil ;
    NSRange rang = [[paramt objectForKey:@"urlName"] rangeOfString: @"_"];
    if (rang.length >0) {
        urlName = [NSString stringWithFormat:@"%@",[paramt objectForKey:@"urlName"]];
    }
    else if ([paramt objectForKey:@"id"]!=nil)
    {
        NSString *idString = [paramt objectForKey:@"id"];
        urlName = [NSString stringWithFormat:@"%@_%@",[paramt objectForKey:@"urlName"],idString];
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/auction/%@?time=%@",
                                       UrlBaseNeedLogin, urlName,[self timeSp]]];

    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PointService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        Tao800PointDetailAuctionVo *vo = [[Tao800PointDetailAuctionVo alloc] init];
        [self convertToAuctionDeal: dict deal: vo];
        NSDictionary *retObj = [NSDictionary dictionaryWithObjectsAndKeys:vo,@"deal",nil];
        completion(retObj);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

-(void)getBidersList:(NSDictionary *)paramt
          completion:(void (^)(NSDictionary *))completion
             failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *idString = [paramt objectForKey: @"dealId"];
    NSString *pageNumber = [paramt objectForKey: @"pageNumber"];
    NSString *pageSize = [paramt objectForKey: @"pageSize"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/cn/tao_record_deals/auction?per_page=%@&page=%@&deal_id=%@&time=%@",UrlBaseNeedLogin, pageSize,pageNumber,idString,[self timeSp]]];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PointService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        TBDPRINT(@"竞拍返回数据 %@",dict);
        NSArray *arr = [self convertToAuctionBidersList: dict];
        NSNumber *total = [NSNumber numberWithInt:[[dict objectForKey:@"total"] intValue]];
        NSDictionary *retObj = [NSDictionary dictionaryWithObjectsAndKeys:arr,@"items",total,@"total",nil];
        completion(retObj);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)startReward:(NSDictionary *)params
         completion:(void (^)(NSDictionary *))completion
            failure:(void (^)(TBErrorDescription *))failure{
    
    
    NSString *dealId = [params objectForKey: @"dealId"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/v2/raffle/exchange",
                                       UrlBaseNeedLogin]];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;
    
    [request setPostValue:dealId forKey:@"id"];
    [request setPostValue:params[@"addr_id"] forKey:@"addr_id"];
    TBDPRINT(@"打印抽奖请求增加参数 %@",params[@"addr_id"]);
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PointService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *retObj = dict;
        completion(retObj);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)startExchange:(NSDictionary *)paramt
           completion:(void (^)(NSDictionary *))completion
              failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *dealId = [paramt objectForKey: @"dealId"];
    NSString *meno = [paramt objectForKey: @"memo"];
    NSString *joinId = [paramt objectForKey: @"join_id"];
    NSString *addrStr = paramt[@"addr_id"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/v2/welfare/exchange",
                                       UrlBaseNeedLogin]];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;
    
    [request setPostValue:dealId forKey:@"id"];
    [request setPostValue:meno forKey:@"memo"];
    if(addrStr != nil){
        [request setPostValue:addrStr forKey:@"addr_id"];
    }
    if(![joinId isEqualToString:@""]){
        [request setPostValue:joinId forKey:@"join_id"];
    }
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PointService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *retObj = dict;
        completion(retObj);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)startAuctionPrice:(NSDictionary *)paramt
           completion:(void (^)(NSDictionary *))completion
              failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *idString = [paramt objectForKey:@"id"];
    NSString *bidPrice = [paramt objectForKey:@"bidPrice"];
    NSString *partner = [paramt objectForKey:@"channel"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/v2/auction/chujia?time=%@",
                                       UrlBaseNeedLogin,[self timeSp]]];//@"http://www.zhe800.com"
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;
    
    [request setPostValue:idString forKey:@"deal_id"];
    [request setPostValue:bidPrice forKey:@"bid"];
    [request setPostValue:partner forKey:@"channel"];
    [request setPostValue:paramt[@"addr_id"] forKey:@"addr_id"];
    TBDPRINT(@"打印竞拍请求增加参数 %@",paramt[@"addr_id"]);
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PointService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *retObj = dict;
        completion(retObj);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
    
}

- (void)getScoreCashDealDetail:(NSDictionary *)paramt
                    completion:(void (^)(NSDictionary *))completion
                       failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *dealId = [paramt objectForKey:@"dealId"];
    BOOL isZId = [[paramt objectForKey:@"isZId"] boolValue];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/v3/jifendeal?id=%@",
                                       UrlBaseTodo, dealId]];
    if(isZId){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/v3/jifendeal?zid=%@",
                                    UrlBaseTodo, dealId]];
    }
    TBDPRINT(@"==deal detail: %@===", url);
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PointService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        Tao800PointDetailExchangeDealVo *vo = [[Tao800PointDetailExchangeDealVo alloc] init];
        [self convertToScoreCashDeal: dict deal: vo];
        
        NSDictionary *skuDict = [dict objectForKey:@"stock_sku"];
        
        NSNumber *type = [NSNumber numberWithInt:2];
        NSDictionary *retObj = [NSDictionary dictionaryWithObjectsAndKeys:
                  vo, @"deal",
                  type, @"pageType",
                  skuDict, @"skuInfo",
                  nil];
        completion(retObj);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getScoreFeedbackOrderList:(NSDictionary *)paramt
                       completion:(void (^)(NSDictionary *))completion
                          failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *limit = [paramt objectForKey:@"limit"];
    NSString *offset = [paramt objectForKey:@"offset"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/trade/list?limit=%@&offset=%@",
                                       UrlBaseNeedLogin, limit, offset]];
    
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PointService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSArray *arr = [self convertToScoreFeedbackOrderList: dict];
        NSDictionary *retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
        completion(retObj);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
    
}

- (void)getNotice:(NSDictionary *)paramt
       completion:(void (^)(NSDictionary *))completion
          failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *ruletype = [paramt objectForKey: @"ruletype"]; //0--积分兑换，1--抽奖
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/tao800/ruledesc.json?ruletype=%@",
                                       UrlBase, ruletype]];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PointService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *retObj = nil;
        if([dict isKindOfClass:[NSArray class]])
        {
            id tmpObj = dict;
            NSArray *tmpArray = tmpObj;
            NSDictionary *param = nil;
            if(tmpArray!=nil && tmpArray.count>0)
            {
                param = [tmpArray objectAtIndex:0];
            }
            else
            {
                param = [NSDictionary dictionary];
            }
            retObj = param;
        }
        else
        {
            retObj = dict;
        }

        completion(retObj);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

//请求我的抽奖奖品  列表接口
/**
 *@params
 
 **/
- (void)getMyPresentList:(NSDictionary *)params
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure {

    NSString *limit = [params objectForKey:@"limit"];
    NSString *offset = [params objectForKey:@"offset"];
    //3.1.1新增字段cash_order = 1 返回现金购
    NSString *urlStr = [NSString stringWithFormat:@"%@/profile/orders/raffle?limit=%d&offset=%d",UrlBaseNeedLogin,[limit intValue],[offset intValue]];
    
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    //request.serviceMethodFlag = ServiceGetPresentListViewTag;
    [request setRequestMethod :TBRequestMethodGet];
    
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PointService *instance = self;
    
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }else{
            int status = [[dict objectForKey:@"status"] intValue];
            if(status == 0){
                TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
                tbd.errorCode = 401;
                failure(tbd);
                return;
            }
        }
        
        NSArray *arr = [self convertJsonToPresent:dict withServiceTag:0];
        NSDictionary *retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
        
        completion(retObj);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
    
}
//请求我的积分兑换商品  列表接口
/**
 *@params
 
 **/
- (void)getExchangeDealList:(NSDictionary *)params
                 completion:(void (^)(NSDictionary *))completion
                    failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *limit = [params objectForKey:@"limit"];
    NSString *offset = [params objectForKey:@"offset"];
    NSString *cashOrder = [params objectForKey:@"cashOrder"];
    //3.1.1新增字段cash_order = 1 返回现金购
    NSString *urlStr = [NSString stringWithFormat:@"%@/profile/orders/welfare?limit=%d&offset=%d&cash_order=%@",UrlBaseNeedLogin,[limit intValue],[offset intValue],cashOrder];
    
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    //request.serviceMethodFlag = ServiceGetExchangeDealTag;
    [request setRequestMethod :TBRequestMethodGet];
    
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PointService *instance = self;
    
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }else{
            int status = [[dict objectForKey:@"status"] intValue];
            if(status == 0){
                TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
                tbd.errorCode = 401;
                failure(tbd);
                return;
            }
        }
        
        NSArray *arr = [self convertJsonToPresent:dict withServiceTag:0];
        NSDictionary *retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
        
        completion(retObj);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    
    [self send:request];
}

//请求我的积分拍卖商品  列表接口
/**
 *@params
 
 **/

- (void)getMyPresentAuctinList:(NSDictionary *)params
                    completion:(void (^)(NSDictionary *))completion
                       failure:(void (^)(TBErrorDescription *))failure
{
    NSString *limit = [params objectForKey:@"limit"];
    NSString *offset = [params objectForKey:@"offset"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/profile/orders/auction?limit=%d&offset=%d",UrlBaseNeedLogin,[limit intValue],[offset intValue]];
    
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    //request.serviceMethodFlag = ServiceGetPresentAuctionTag;
    [request setRequestMethod :TBRequestMethodGet];
    
    
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PointService *instance = self;
    
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }else{
            int status = [[dict objectForKey:@"status"] intValue];
            if(status == 0){
                TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
                tbd.errorCode = 401;
                failure(tbd);
                return;
            }
        }
        
        NSArray *arr = [self convertJsonToAuction:dict withServiceTag:0];
        NSDictionary *retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
        
        completion(retObj);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

@end
