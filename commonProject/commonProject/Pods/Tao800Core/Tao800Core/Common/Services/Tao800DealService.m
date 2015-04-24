//  Tao800DealService.m
//  universalT800
//
//  Created by enfeng on 13-10-12.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <TBUI/TBErrorDescription.h>
#import "Tao800DealService.h"
#import "Tao800ShopVo.h"
#import "Tao800DealVo.h"
#import "Tao800DailyTenVo.h"
#import "Tao800SearchSuggestionVo.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800CategoryVo.h"
#import "Tao800FunctionCommon.h"
#import "Tao800MobileRecordVo.h"
#import "TBCore/TBCore.h"
#import "Tao800StaticConstant.h"
#import "Tao800MyLuckyDrawVo.h"
#import "Tao800HeartWishBVO.h"

#ifdef DEBUG
NSString *const RubyUrlBase = @"http://m.api.zhe800.com";
//NSString *const WirelessUrlBase = @"http://192.168.1.36:8100";
NSString *const WirelessUrlBase = @"http://m.api.zhe800.com";
NSString *const WirelessXiongmaoz = @"http://m.api.xiongmaoz.com";
NSString *const WirelessV6tag = @"http://192.168.10.142:8100";//@"http://192.168.3.151:8111";
NSString *const MyLuckyUrlBse = @"http://m.api.xiongmaoz.com";
NSString *const ZAPIUrlBase = @"http://zapi.zhe800.com";
NSString *const RecordBaseUrl = @"http://buy.m.xiongmaoz.com";
NSString *const WishBaseUrl = @"http://zapi.zhe800.com";
NSString *const BrandBaseUrl = @"http://192.168.10.144:8100";
#else
NSString *const RubyUrlBase = @"http://m.api.zhe800.com";
NSString *const WirelessUrlBase = @"http://m.api.zhe800.com";
NSString *const MyLuckyUrlBse = @"http://m.api.zhe800.com";
NSString *const ZAPIUrlBase = @"http://zapi.zhe800.com";
NSString *const RecordBaseUrl = @"http://buy.m.zhe800.com";
NSString *const WirelessXiongmaoz = @"http://m.api.zhe800.com";
NSString *const WirelessV6tag =  @"http://m.api.zhe800.com";
NSString *const WishBaseUrl = @"http://zapi.zhe800.com";
NSString *const BrandBaseUrl = @"http://m.api.zhe800.com";
#endif

@interface Tao800DealService ()
- (NSArray *)wrapperTags:(NSArray *)tags;
@end

@implementation Tao800DealService

- (NSArray *)wrapperShops:(NSDictionary *)dict {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[dict count]];
    
    for (NSDictionary *item in dict) {
        Tao800ShopVo *shopVo = [Tao800ShopVo convertJSONShop:item];
        [arr addObject:shopVo];
    }
    
    return arr;
}

- (NSArray *)wrapperMyLuckyDrawDetail:(NSDictionary *)item {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    
    Tao800MyLuckyDrawVo *vo = [[Tao800MyLuckyDrawVo alloc] init];
    vo.totalCount = ((NSString *)[item objectForKey:@"total_count" convertNSNullToNil:YES]).intValue;
    vo.dealDescription = [item objectForKey:@"description" convertNSNullToNil:YES];
    vo.begunAt = [item objectForKey:@"begun_at" convertNSNullToNil:YES];
    vo.endedAt = [item objectForKey:@"ended_at" convertNSNullToNil:YES];
    vo.runTime = [item objectForKey:@"run_time" convertNSNullToNil:YES];
    vo.cost = [item objectForKey:@"cost" convertNSNullToNil:YES];
    vo.image = ((NSArray *)[item objectForKey:@"image" convertNSNullToNil:YES]).firstObject;
    vo.runStatus = ((NSString *)[item objectForKey:@"run_status" convertNSNullToNil:YES]).intValue;
    vo.orderId = [item objectForKey:@"order_id" convertNSNullToNil:YES];
    vo.userInfos = [item objectForKey:@"user_infos" convertNSNullToNil:YES];
    vo.luckyUsers = (NSArray *)[item objectForKey:@"lucky_user" convertNSNullToNil:YES];
    vo.intro = [item objectForKey:@"intro" convertNSNullToNil:YES];
    vo.returnStatus = ((NSString *) [item objectForKey:@"run_status" convertNSNullToNil:YES]).intValue;
    vo.title = [item objectForKey:@"title" convertNSNullToNil:YES];
    vo.dealId = ((NSString *)[item objectForKey:@"dealId" convertNSNullToNil:YES]).intValue;
    vo.listImage = ((NSArray *)[item objectForKey:@"list_image" convertNSNullToNil:YES]).firstObject;
    vo.delivery = [item objectForKey:@"delivery" convertNSNullToNil:YES];
    vo.originPrice = ((NSString *) [item objectForKey:@"origin_price" convertNSNullToNil:YES]).floatValue;
    vo.joinCount = ((NSString *) [item objectForKey:@"join_count" convertNSNullToNil:YES]).intValue;
    vo.orderStatus = ((NSString *) [item objectForKey:@"order_status" convertNSNullToNil:YES]).intValue;
    id obj1 = [item objectForKey:@"has_show" convertNSNullToNil:YES];
    if ([obj1 isKindOfClass:[NSNumber class]]) {
        vo.hasShow = [obj1 boolValue];
    }
    [array addObject:vo];
    return array;
}

- (NSArray *)wrapperMyLuckyDrawList:(NSArray *)arr {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[arr count]];
    
    for (NSDictionary *item in arr) {
        Tao800MyLuckyDrawVo *vo = [[Tao800MyLuckyDrawVo alloc] init];
        NSNumber *dealNum = [item objectForKey:@"id" convertNSNullToNil:YES];
        if (!dealNum) {
            continue;
        }
        vo.dealId = ((NSString *)[item objectForKey:@"id" convertNSNullToNil:YES]).intValue;

        vo.title = [item objectForKey:@"title" convertNSNullToNil:YES];
        vo.originPrice = ((NSString *)[item objectForKey:@"origin_price" convertNSNullToNil:YES]).floatValue;
        vo.returnStatus = ((NSString *)[item objectForKey:@"return_status" convertNSNullToNil:YES]).intValue;
        vo.listImage = ((NSArray *)[item objectForKey:@"list_image" convertNSNullToNil:YES]).firstObject;
        vo.joinCount = ((NSString *)[item objectForKey:@"join_count" convertNSNullToNil:YES]).intValue;

        
        [array addObject:vo];
    }
    return array;
}

- (NSDictionary *)wrapperMyLuckyDrawShowPage:(NSDictionary *)dic{
    
    Tao800MyLuckyDrawVo *vo = [[Tao800MyLuckyDrawVo alloc] init];
    
    vo.dealId = ((NSString *)[dic objectForKey:@"id" convertNSNullToNil:YES]).intValue;
    vo.title = [dic objectForKey:@"title" convertNSNullToNil:YES];
    vo.begunAt = [dic objectForKey:@"begin_time" convertNSNullToNil:YES];
    vo.endedAt = [dic objectForKey:@"end_time" convertNSNullToNil:YES];
    vo.originPrice = ((NSString *)[dic objectForKey:@"origin_price" convertNSNullToNil:YES]).floatValue;
    vo.runTime = [dic objectForKey:@"run_time" convertNSNullToNil:YES];
    vo.listImage = ((NSArray *)[dic objectForKey:@"list_image" convertNSNullToNil:YES]).firstObject;
    vo.joinCount = ((NSString *)[dic objectForKey:@"join_count" convertNSNullToNil:YES]).intValue;
    
    vo.luckyUsers = [dic objectForKey:@"lucky_user" convertNSNullToNil:YES];
    
    NSDictionary *d = @{@"vo":vo};
    return d;
}

#pragma mark - 封装tendeal
- (NSMutableArray *)wrapperTenDeals:(NSDictionary *)dict {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[dict count]];
    @try {
        for (NSDictionary *item in dict) {
            Tao800DailyTenVo *deal = [[Tao800DailyTenVo alloc] init];
            NSNumber *dealIdNum = [item objectForKey:@"id" convertNSNullToNil:YES];
            
            if (dealIdNum) {
                deal.dealId = dealIdNum.intValue;
            }
            deal.title = [item objectForKey:@"title"];
            deal.recommendReason = [item objectForKey:@"recommend_reason"];
            deal.beginTime = [item objectForKey:@"begin_time"];
            deal.expireTime = [item objectForKey:@"expire_time"];
            deal.wapUrl = [item objectForKey:@"wap_url"];
            
            if([item objectForKey:@"price" convertNSNullToNil:YES]){
                deal.price = ((NSString *) [item objectForKey:@"price"]).intValue;
            }
            if([item objectForKey:@"oos" convertNSNullToNil:YES]){
                deal.oos = (DealSaleState) ((NSString *) [item objectForKey:@"oos"]).intValue;
            }
            if([item objectForKey:@"baoyou" convertNSNullToNil:YES]){
                deal.isBaoyou = [[item objectForKey:@"baoyou"] boolValue];
            }
            deal.imageUrl = [item objectForKey:@"image_url"];
            NSArray* arrayRelatedRecommend = [item objectForKey:@"related_recommend" convertNSNullToNil:YES];
            if (arrayRelatedRecommend && [arrayRelatedRecommend count]>0) {
                for (NSDictionary* dic in arrayRelatedRecommend) {
                    if([dic isKindOfClass:[NSDictionary class]]){
                        RelatedType type = RelatedTypeNone;
                        if([dic objectForKey:@"type" convertNSNullToNil:YES]){
                            type = (RelatedType) ((NSString*) [dic objectForKey:@"type"]).intValue;
                        }
                        if (type == RelatedTypeSearch) {
                            deal.type = type;
                            NSString* values = [dic objectForKey:@"value"];
                            NSMutableArray* array = [NSMutableArray arrayWithCapacity:3];
                            if (values && values.length>0) {
                                array = [NSMutableArray arrayWithArray:[values componentsSeparatedByString:@","]];
                            }
                            deal.relatedRecommend = array;
                        }
                    }
                }
            }
            [deal resetNullProperty];
            [arr addObject:deal];
        }
    }@catch (NSException *e) {
        TBDPRINT(@"convertJson ToDeals 字符串 转换 数字错误");
    }
    return arr;
}


#pragma mark - 封装deal

- (NSMutableArray *)wrapperDeals:(NSDictionary *)dict {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[dict count]];
    @try {
        for (NSDictionary *item in dict) {
            Tao800DealVo *deal = [[Tao800DealVo alloc] init];
            [Tao800DealVo convertJSONDict:item toDeal:deal];
            [arr addObject:deal];
        }
        
    } @catch (NSException *e) {
        TBDPRINT(@"convertJson ToDeals 字符串 转换 数字错误");
    }
    return arr;
}

#pragma mark 封装搜索建议数据

- (NSArray *)wrapperSearchSuggestion:(NSDictionary *)items {
    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:items.count];
    for (NSDictionary *itemDict in items) {
        Tao800SearchSuggestionVo *vo = [[Tao800SearchSuggestionVo alloc] init];
        vo.word = [itemDict objectForKey:@"word" convertNSNullToNil:YES];
        vo.resultCount = [itemDict objectForKey:@"count" convertNSNullToNil:YES];
        [retArray addObject:vo];
    }
    return retArray;
}

- (NSArray *)wrapperMobileRecord:(NSDictionary *)items {
    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:items.count];
    for (NSDictionary *dict in items) {
        Tao800MobileRecordVo *vo = [[Tao800MobileRecordVo alloc] init];
        vo.status = [dict objectForKey:@"statusDesc" convertNSNullToNil:YES];
        vo.number = [dict objectForKey:@"mobile" convertNSNullToNil:YES];
        vo.time = [dict objectForKey:@"payTime" convertNSNullToNil:YES];
        vo.price = [dict objectForKey:@"money" convertNSNullToNil:YES];
        [retArray addObject:vo];
    }
    return retArray;
}

- (void)getForenotices:(NSDictionary *)paramsExt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v2/forecast/deals", RubyUrlBase];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    //    [params setValue:@"iphone" forKey:@"platform"];
    [params setValue:@"webp" forKey:@"image_model"];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = [dict objectForKey:@"meta" convertNSNullToNil:YES];
        NSDictionary *objects = [dict objectForKey:@"objects" convertNSNullToNil:YES];
        
        if (!meta) {
            meta = @{@"has_next" : @(0)};
        }
        
        NSArray *deals = [instance wrapperDeals:objects];
        NSDictionary *retDict = @{@"items" : deals, @"meta" : meta};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (NSArray *)wrapperTags:(NSArray *)tags {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:20];
    for (NSDictionary *item in tags) {
        Tao800CategoryVo *vo = [[Tao800CategoryVo alloc] init];
        vo.categoryName = item[@"category_name"];
        NSString *tagId = item[@"tag_id"];
        if (tagId) {
            vo.categoryId = [tagId intValue];
        } else {
            vo.categoryId = [item[@"id"] intValue];
        }
        vo.urlName = item[@"url_name"];
        if ([vo.urlName isEqualToString:@"taomuying"]) {
            vo.urlName = @"muying";
        }
        vo.parentUrlName = item[@"parent_url_name"];
        if ([vo.parentUrlName isEqualToString:@"taomuying"]) {
            vo.parentUrlName = @"muying";
        }
        vo.pic = item[@"pic"];
        vo.queryUrl = item[@"query"];
        vo.remoteUrl = item[@"pic"];
        [vo resetNullProperty];
        if (vo.parentUrlName && vo.parentUrlName.length < 1) {
            vo.parentUrlName = nil;
        }
        [array addObject:vo];
    }
    return array;
}

- (NSArray *)wrapperBrandTags:(NSArray *)tags {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:20];
    for (NSDictionary *item in tags) {
        Tao800CategoryVo *vo = [[Tao800CategoryVo alloc] init];
        vo.categoryName = item[@"category_name"];
        NSString *tagId = item[@"tag_id"];
        if (tagId) {
            vo.categoryId = [tagId intValue];
        } else {
            vo.categoryId = [item[@"id"] intValue];
        }
        vo.urlName = item[@"url_name"];
        vo.parentUrlName = item[@"parent_url_name"];
        vo.pic = item[@"pic"];
        vo.queryUrl = item[@"query"];
        vo.remoteUrl = item[@"pic"];
        [vo resetNullProperty];
        if (vo.parentUrlName && vo.parentUrlName.length < 1) {
            vo.parentUrlName = nil;
        }
        [array addObject:vo];
    }
    return array;
}

- (void)getDealsByIds:(NSDictionary *)paramsExt
           completion:(void (^)(NSDictionary *))completion
              failure:(void (^)(TBErrorDescription *))failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/v4/deals/ids", WirelessUrlBase];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *objects = nil;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            objects = [dict objectForKey:@"objects" convertNSNullToNil:YES];
        }
        
        NSArray *deals = [instance wrapperDeals:objects];
        NSDictionary *meta = @{@"has_next" : @(0)};
        
        NSDictionary *retDict = @{@"items" : deals, @"meta":meta};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getCategoryTags:(NSDictionary *)paramsExt
             completion:(void (^)(NSDictionary *))completion
                failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v6/tags", WirelessV6tag];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    //[request setSecondsToCache:60*60*24];
    [request setSecondsToCache:60];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        NSString *dataStr = nil;
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }else{
            dataStr = [pRequest responseString];
            dataStr = [dataStr trim];
        }
        
        NSArray *array = @[];
        if ([dict isKindOfClass:[NSArray class]]) {
            NSArray *tags = (NSArray *) dict;
            array = [instance wrapperTags:tags];
        }
        
        NSDictionary *retDict = @{@"items" : array, @"string" : dataStr};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
    
}

- (void)getTagsOfRecommend:(NSDictionary *)paramsExt
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v3/tags/recommend", WirelessXiongmaoz];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSArray *array = @[];
        if ([dict isKindOfClass:[NSArray class]]) {
            NSArray *tags = (NSArray *) dict;
            array = [instance wrapperTags:tags];
        }
        
        NSDictionary *retDict = @{@"items" : array};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getCid:(NSDictionary *)paramsExt
    completion:(void (^)(NSDictionary *))completion
       failure:(void (^)(TBErrorDescription *))failure {
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v1/cn/get_cid", WirelessUrlBase];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        completion(dict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

//获取上传的访问折800客服端日期字符串
- (NSString *)getUploadingDateString:(NSString *)noteVisitKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *visitDateStr = [defaults objectForKey:noteVisitKey];
    if (!visitDateStr) {
        visitDateStr = @"100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
        [defaults setObject:visitDateStr forKey:noteVisitKey];
        [defaults synchronize];
    }
    return visitDateStr;
}

//获取30天内out 次数
- (NSString *)getOutDaysString {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:Tao800DealListVCLCountEachDayOut];
    if (!str) {
        str = @"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0";
    }
    return str;
}

- (void)getDailyTen:(NSDictionary *)paramsExt
         completion:(void (^)(NSDictionary *))completion
            failure:(void (^)(TBErrorDescription *))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@/v3/tendeals", WirelessXiongmaoz];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    [params setValue:@"all" forKey:@"image_type"];
    [params setValue:@"webp" forKey:@"image_model"];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = nil;
        NSDictionary *objects = nil;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            meta = [dict objectForKey:@"meta" convertNSNullToNil:YES];
            objects = [dict objectForKey:@"objects" convertNSNullToNil:YES];
        }
        
        if (!objects) {
            objects = dict;
        }
        if (!meta) {
            meta = @{@"has_next" : @(0)};
        }
        NSArray *banners = [instance wrapperTenDeals:objects];
        NSArray *banners2 = [instance wrapperDeals:objects];
        NSDictionary *retDict = @{@"items" : banners, @"meta" : meta , @"items2" : banners2};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}


- (void)getDeals:(NSDictionary *)paramsExt
      completion:(void (^)(NSDictionary *))completion
         failure:(void (^)(TBErrorDescription *))failure {
    NSString* queryString = nil;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    NSString *urlString = [NSString stringWithFormat:@"%@/v4/deals", WirelessXiongmaoz];
    if ([paramsExt objectForKey:@"today"]) {
        urlString = [NSString stringWithFormat:@"%@/v3/deals/today", WirelessXiongmaoz];
        [params setValue:@"all" forKey:@"image_type"];
        [params setValue:@"webp" forKey:@"image_model"];
    }else{
        //如果v4/deals
        //queryString优先
        queryString = [paramsExt objectForKey:@"queryString"];
        if (queryString && queryString.length>0) {
            [params removeObjectForKey:@"queryString"];
        }else{
            NSString* tag_url = [paramsExt objectForKey:@"tag_url"];
            if (tag_url) {
                //url_name
                [params removeObjectForKey:@"tag_url"];
                [params setValue:tag_url forKey:@"url_name"];
            }
            //parent_url_name
            NSString* parent_url = [paramsExt objectForKey:@"parent_url_name"];
            if (parent_url) {
                [params removeObjectForKey:@"parent_url_name"];
                [params setValue:parent_url forKey:@"parent_tag"];
            }
        }
    }
    

    if ([paramsExt objectForKey:@"today"]){
        [params removeObjectForKey:@"today"];
    }
    
    NSURL *url = nil;
    if (queryString) {
        url = [self wrapperUrlForRequestMethodGet:urlString params:params addition:queryString];
    }else{
        url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    }
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    NSString *userId = dm.user.userId;
    if (!dm.user.userId) {
        userId = @"";
    }
    [request addRequestHeader:@"X-Zhe800filter" value:[self getUploadingDateString:UserDefaultKeyUGCSingletonNoteVisitZhe800Date]];
    [request addRequestHeader:@"X-Zhe800out" value:[self getOutDaysString]];
    [request addRequestHeader:@"X-Zhe800userid" value:userId];
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = nil;
        NSDictionary *objects = nil;
        NSString *version = nil;//排序版本号
//        NSString *listVersion = nil;//列表版本 0 无线排序，其他协同过滤版本
        if ([dict isKindOfClass:[NSDictionary class]]) {
            meta = [dict objectForKey:@"meta" convertNSNullToNil:YES];
            version = [meta objectForKey:@"version" convertNSNullToNil:YES];
            objects = [dict objectForKey:@"objects" convertNSNullToNil:YES];
        }
        
        if (!objects) {
            objects = dict;
        }
        if (!meta) {
            meta = @{@"has_next" : @(0)};
        }
        if (version) {
            dm.version = version;
        } else {
            dm.version = @"0";
        }

        //千人千面参数
        if (version) {
            dm.listVersion = version;
        } else {
            dm.listVersion = @"0";
        }
        NSArray *banners = [instance wrapperDeals:objects];
        NSDictionary *retDict = @{@"items" : banners, @"meta" : meta};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)guangIdsDeals:(NSDictionary *)paramsExt
           completion:(void (^)(NSDictionary *))completion
              failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v3/guang/ids", WirelessXiongmaoz];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    [params setValue:@"all" forKey:@"image_type"];
    [params setValue:@"webp" forKey:@"image_model"];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = [dict objectForKey:@"meta" convertNSNullToNil:YES];
        NSDictionary *objectsDict = [dict objectForKey:@"objects" convertNSNullToNil:YES];
        NSArray *saunterList = nil;
        if (objectsDict) {
            saunterList = [instance wrapperDeals:objectsDict];
        }
        NSNumber *hasNextNum = [meta objectForKey:@"has_next" convertNSNullToNil:YES];
        if (!hasNextNum) {
            hasNextNum = @(0);
        }
        if (!saunterList) {
            saunterList = [NSArray array];
        }
        
        NSDictionary *retDict = @{@"items" : saunterList, @"meta" : meta};
        completion(retDict);
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)GetDealsOfPromotion:(NSDictionary *)paramsExt
                 completion:(void (^)(NSDictionary *))completion
                    failure:(void (^)(TBErrorDescription *))failure {
    
#ifdef DEBUG
    NSString *urlString = [NSString stringWithFormat:@"http://m.api.xiongmaoz.com/v3/deals/promotion"];
    
#else
    NSString *urlString = [NSString stringWithFormat:@"%@/v3/deals/promotion", WirelessUrlBase];
    
#endif
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    [params setValue:@"all" forKey:@"image_type"];
    [params setValue:@"webp" forKey:@"image_model"];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = nil;
        NSDictionary *objects = nil;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            meta = [dict objectForKey:@"meta" convertNSNullToNil:YES];
            objects = [dict objectForKey:@"objects" convertNSNullToNil:YES];
        }
        
        if (!objects) {
            objects = dict;
        }
        if (!meta) {
            meta = @{@"has_next" : @(0)};
        }
        
        NSArray *banners = [instance wrapperDeals:objects];
        NSDictionary *retDict = @{@"items" : banners, @"meta" : meta};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
    
    
}

- (void)getBrandTags:(NSDictionary *)paramsExt//获取品牌分类
          completion:(void (^)(NSDictionary *))completion
             failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v5/brand/tags", BrandBaseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        NSArray *array = @[];
        if ([dict isKindOfClass:[NSArray class]]) {
            NSArray *tags = (NSArray *) dict;
            array = [instance wrapperBrandTags:tags];//数据处理，封装获取tag_id、category_name、url_name
        }
        
        NSDictionary *retDict = @{@"items" : array};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getTodayBrand:(NSDictionary *)paramsExt
           completion:(void (^)(NSDictionary *))completion
              failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v5/brand/branddeals/today", BrandBaseUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    //    [params setValue:@"all" forKey:@"image_type"];
    //    [params setValue:@"webp" forKey:@"image_model"];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = [dict objectForKey:@"meta" convertNSNullToNil:YES];
        NSArray *sections = [dict objectForKey:@"objects" convertNSNullToNil:YES];
        if (!meta) {
            meta = @{@"has_next" : @(0)};
        }
        if (!sections) {
            sections = @[];
        }
        
        NSDictionary *retDict = @{@"sections" : sections, @"meta" : meta};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getYesterdayBrand:(NSDictionary *)paramsExt
               completion:(void (^)(NSDictionary *))completion
                  failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v5/brand/branddeals/yesterday", BrandBaseUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    //    [params setValue:@"all" forKey:@"image_type"];
    //    [params setValue:@"webp" forKey:@"image_model"];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = [dict objectForKey:@"meta" convertNSNullToNil:YES];
        NSArray *sections = [dict objectForKey:@"objects" convertNSNullToNil:YES];
        if (!meta) {
            meta = @{@"has_next" : @(0)};
        }
        if (!sections) {
            sections = @[];
        }
        
        NSDictionary *retDict = @{@"sections" : sections, @"meta" : meta};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getLastBrand:(NSDictionary *)paramsExt
          completion:(void (^)(NSDictionary *))completion
             failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v5/brand/branddeals/last", BrandBaseUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    //    [params setValue:@"all" forKey:@"image_type"];
    //    [params setValue:@"webp" forKey:@"image_model"];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = [dict objectForKey:@"meta" convertNSNullToNil:YES];
        NSArray *sections = [dict objectForKey:@"objects" convertNSNullToNil:YES];
        if (!meta) {
            meta = @{@"has_next" : @(0)};
        }
        if (!sections) {
            sections = @[];
        }
        
        NSDictionary *retDict = @{@"sections" : sections, @"meta" : meta};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getBrand:(NSDictionary *)paramsExt
      completion:(void (^)(NSDictionary *))completion
         failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v5/brand/branddeals", BrandBaseUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    //    [params setValue:@"all" forKey:@"image_type"];
    //    [params setValue:@"webp" forKey:@"image_model"];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = [dict objectForKey:@"meta" convertNSNullToNil:YES];
        NSArray *sections = [dict objectForKey:@"objects" convertNSNullToNil:YES];
        if (!meta) {
            meta = @{@"has_next" : @(0)};
        }
        if (!sections) {
            sections = @[];
        }
        
        NSDictionary *retDict = @{@"sections" : sections, @"meta" : meta};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getBrandDeals:(NSDictionary *)paramsExt
           completion:(void (^)(NSDictionary *))completion
              failure:(void (^)(TBErrorDescription *))failure {
    //若需要启用新的品牌商品列表需修改 url：v5/brand/getdealsbyid 和 WirelessXiongmaoz改成http://192.168.10.144:8100
    NSString *urlString = [NSString stringWithFormat:@"%@/v5/brand/getdealsbyid", WirelessXiongmaoz];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    //    [params setValue:@"all" forKey:@"image_type"];
    //    [params setValue:@"webp" forKey:@"image_model"];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = [dict objectForKey:@"meta" convertNSNullToNil:YES];
        NSDictionary *objects = [dict objectForKey:@"objects" convertNSNullToNil:YES];
        if (!meta) {
            meta = @{@"has_next" : @(0)};
        }
        NSArray *deals = [instance wrapperDeals:objects];
        
        NSDictionary *retDict = @{@"items" : deals, @"meta" : meta};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getMobileDeals:(NSDictionary *)paramsExt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v3/mobile/deals", WirelessXiongmaoz];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    [params setValue:@"webp" forKey:@"image_model"];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = [dict objectForKey:@"meta" convertNSNullToNil:YES];
        NSDictionary *objects = [dict objectForKey:@"objects" convertNSNullToNil:YES];
        if (!meta) {
            meta = @{@"has_next" : @(0)};
        }
        
        NSArray *banners = [instance wrapperDeals:objects];
        NSDictionary *retDict = @{@"items" : banners, @"meta" : meta};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

-(void)getCampusProducts:(NSDictionary *)paramsExt
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@/v3/deals/taocampus", WirelessXiongmaoz];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    [params setValue:@"webp" forKey:@"image_model"];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = [dict objectForKey:@"meta" convertNSNullToNil:YES];
        NSDictionary *objects = [dict objectForKey:@"objects" convertNSNullToNil:YES];
        if (!meta) {
            meta = @{@"has_next" : @(0)};
        }
        
        NSArray *banners = [instance wrapperDeals:objects];
        NSDictionary *retDict = @{@"items" : banners, @"meta" : meta};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)addFavoriteDeal:(NSDictionary *)paramsExt
             completion:(void (^)(NSDictionary *))completion
                failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/cn/favorites", ZAPIUrlBase];
    
    //NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:paramsExt];
    NSURL *url = [NSURL URLWithString:urlString];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setShouldContinueWhenAppEntersBackground:self.enableExecuteInBackground];
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [request addRequestHeader:@"X-Tuan800-Platform" value:dm.platform];
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [self wrapperPostRequest:paramsExt request:request];
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        completion(dict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)deleteFavoriteDeal:(NSDictionary *)paramsExt
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/cn/favorites/%@", ZAPIUrlBase, paramsExt[@"dealids"]];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:nil];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setShouldContinueWhenAppEntersBackground:self.enableExecuteInBackground];
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [request addRequestHeader:@"X-Tuan800-Platform" value:dm.platform];
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        completion(dict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getFavoriteDeals:(NSDictionary *)paramsExt
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/cn/favorites", ZAPIUrlBase];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    //    [params setValue:@"iphone" forKey:@"platform"];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [request addRequestHeader:@"X-Tuan800-Platform" value:dm.platform];
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSNumber *hasNext = [dict objectForKey:@"has_next" convertNSNullToNil:YES];
        if (!hasNext) {
            hasNext = [NSNumber numberWithBool:NO];
        }
        NSDictionary *objects = [dict objectForKey:@"deals" convertNSNullToNil:YES];
        NSDictionary *meta = @{@"has_next" : hasNext};
        
        NSArray *deals = [instance wrapperDeals:objects];
        NSDictionary *retDict = @{@"items" : deals, @"meta" : meta};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getFavoriteDealIds:(NSDictionary *)paramsExt
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/cn/favorites", ZAPIUrlBase];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    [params setValue:@"ids" forKey:@"resultMode"];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [request addRequestHeader:@"X-Tuan800-Platform" value:dm.platform];
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSArray *objects = [dict objectForKey:@"deals" convertNSNullToNil:YES];// dict[@"deals"];
        if (!objects) {
            objects = [NSArray array];
        }
        NSDictionary *retDict = @{@"items" : objects};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)addFavoriteShop:(NSDictionary *)paramsExt
             completion:(void (^)(NSDictionary *))completion
                failure:(void (^)(TBErrorDescription *))failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/cn/shop_concerns", ZAPIUrlBase];
    
    //NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:paramsExt];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //    NSHTTPCookie *cookie;
    //    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    //    NSArray *cookies = [storage cookiesForURL:url];
    //    for (cookie in cookies) {
    //        TBDPRINT(@"%@", cookie);
    //    }
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    [request setShouldContinueWhenAppEntersBackground:self.enableExecuteInBackground];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [request addRequestHeader:@"X-Tuan800-Platform" value:dm.platform];
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [self wrapperPostRequest:paramsExt request:request];
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        completion(dict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)deleteFavoriteShop:(NSDictionary *)paramsExt
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/cn/shop_concerns/%@", ZAPIUrlBase, paramsExt[@"id"]];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:nil];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    [request setShouldContinueWhenAppEntersBackground:self.enableExecuteInBackground];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [request addRequestHeader:@"X-Tuan800-Platform" value:dm.platform];
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        completion(dict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}


#pragma mark 获取我的抽奖列表

- (void)getMyLuckyDrawList:(NSDictionary *)paramsExt
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure {

    NSString *urlString = [NSString stringWithFormat:@"%@/cn/inner/lottery/mylotteries",ZAPIUrlBase];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [request addRequestHeader:@"X-Tuan800-Platform" value:dm.platform];
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
    
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        
        NSDictionary *meta = [dict objectForKey:@"meta"];
        NSArray *objects = [dict objectForKey:@"objects"  convertNSNullToNil:YES];// dict[@"shops"];
        if (!meta) {
            meta = @{@"has_next" : @(0)};
        }
        
        
        NSArray *deals = [instance wrapperMyLuckyDrawList:objects];
        NSDictionary *retDict = @{@"items" : deals, @"meta" : meta};
        completion(retDict);
        
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
    
}

-(NSString*)ifNSNumberChangeToNSString:(NSString*) postValue{
    if ([postValue isKindOfClass:[NSNumber class]]) {
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        postValue = [numberFormatter stringFromNumber:(NSNumber*)postValue];
    }
    return postValue;
}

#pragma mark 我的抽奖详情页面
- (void)getMyLuckyDrawDetail:(NSDictionary *)paramsExt
                  completion:(void (^)(NSDictionary *))completion
                     failure:(void (^)(TBErrorDescription *))failure {

    id dealIdValue = paramsExt[@"dealId"];
    
    if (!dealIdValue) {
        failure(nil);
        return;
    }
    
    NSString *dealId = [self ifNSNumberChangeToNSString:dealIdValue];
    if (!dealId || [dealId isEqualToString:@""]) {
        failure(nil);
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/cn/inner/lottery/order/%@",ZAPIUrlBase,dealId]; //deal_id
    //NSString *urlString = [NSString stringWithFormat:@"%@/v5/brand/branddeals", BrandBaseUrl];
    NSURL *url = [NSURL URLWithString:urlString];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [request addRequestHeader:@"X-Tuan800-Platform" value:dm.platform];
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];

    
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = [dict objectForKey:@"meta"];
        NSArray *deals = [instance wrapperMyLuckyDrawDetail:dict];
        NSArray *detail = [instance wrapperMyLuckyDrawDetail:dict];
        
        if (!meta) {
            meta = @{};
        }
        
        NSDictionary *retDict = @{@"items" : deals, @"detail" : detail, @"meta" : meta};
        
        completion(retDict);
        
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
    
}

#pragma mark 我的抽奖详情页查看我的抽奖码
- (void)getMyLuckyDrawDetailMyCode:(NSDictionary *)paramsExt
                        completion:(void (^)(NSDictionary *))completion
                           failure:(void (^)(TBErrorDescription *))failure
{
    NSString *dealId = paramsExt[@"dealId"];
    NSString *urlString = [NSString stringWithFormat:@"%@/cn/inner/lottery/%@/mynos",ZAPIUrlBase,dealId]; //deal_id

    NSURL *url = [NSURL URLWithString:urlString];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [request addRequestHeader:@"X-Tuan800-Platform" value:dm.platform];
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = [dict objectForKey:@"meta"];
        
        if (!meta) {
            meta = @{};
        }
        
        completion(dict);
        
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
    
}

- (void)getMyLuckyDrawDetailShowPage:(NSDictionary *)paramsExt
                          completion:(void (^)(NSDictionary *))completion
                             failure:(void (^)(TBErrorDescription *))failure
{
    NSString *dealId = paramsExt[@"dealId"];
    NSString *urlString = [NSString stringWithFormat:@"%@/cn/inner/lottery/%@/shows",ZAPIUrlBase,dealId]; //deal_id

    NSURL *url = [NSURL URLWithString:urlString];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [request addRequestHeader:@"X-Tuan800-Platform" value:dm.platform];
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = ((NSArray *)[instance getResponseJsonResult:pRequest]).firstObject;

        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = [dict objectForKey:@"meta"];
        
        if (!meta) {
            meta = @{};
        }

        NSDictionary *rectDic = [instance wrapperMyLuckyDrawShowPage:dict];
        completion(rectDic);
        
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    [self send:request];

}

- (void)getFavoriteShops:(NSDictionary *)paramsExt
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/cn/shop_concerns", ZAPIUrlBase];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    //    [params setValue:@"iphone" forKey:@"platform"];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [request addRequestHeader:@"X-Tuan800-Platform" value:dm.platform];
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSNumber *hasNext = [dict objectForKey:@"has_next"  convertNSNullToNil:YES];//[@"has_next"];
        if (!hasNext) {
            hasNext = [NSNumber numberWithBool:NO];
        }
        
        NSDictionary *objects = [dict objectForKey:@"shops"  convertNSNullToNil:YES];// dict[@"shops"];
        NSDictionary *meta = @{@"has_next" : hasNext};
        
        NSArray *deals = [instance wrapperShops:objects];
        NSDictionary *retDict = @{@"items" : deals, @"meta" : meta};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getFavoriteShopIds:(NSDictionary *)paramsExt
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/cn/shop_concerns", ZAPIUrlBase];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    [params setValue:@"ids" forKey:@"resultMode"];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [request addRequestHeader:@"X-Tuan800-Platform" value:dm.platform];
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSArray *objects = [dict objectForKey:@"shops" convertNSNullToNil:YES];// dict[@"shops"];
        if (!objects) {
            objects = [NSArray array];
        }
        NSDictionary *retDict = @{@"items" : objects};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}


#pragma mark 获取搜索建议

- (void)getSearchSuggestion:(NSDictionary *)paramsExt
                 completion:(void (^)(NSDictionary *))completion
                    failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v2/suggestion", WirelessUrlBase];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSArray *items = [instance wrapperSearchSuggestion:dict];
        NSDictionary *retDict = @{@"items" : items};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

#pragma mark 获取搜索商品列表

- (void)getSearchDeals:(NSDictionary *)params
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure {
    
    NSMutableString *urlStr = [NSMutableString stringWithCapacity:255];
    [urlStr appendString:WirelessXiongmaoz];
    [urlStr appendFormat:@"/v4/search"];
    
    NSString *keywords = [params objectForKey:@"keywords" convertNSNullToNil:YES];
    NSString *priceFrom = [params objectForKey:@"priceFrom" convertNSNullToNil:YES];
    NSString *priceTo = [params objectForKey:@"priceTo" convertNSNullToNil:YES];
    NSString *beginTimeFrom = [params objectForKey:@"beginTimeFrom" convertNSNullToNil:YES];
    NSString *beginTimeTo = [params objectForKey:@"beginTimeTo" convertNSNullToNil:YES];
    NSNumber *pageNumber = [params objectForKey:@"pageNumber" convertNSNullToNil:YES];
    NSNumber *pageSize = [params objectForKey:@"pageSize" convertNSNullToNil:YES];
    
    //    // 计算分页
    //    NSString *offset = [NSString stringWithFormat:@"%d", (pageNumber.intValue - 1) * pageSize.intValue];
    //    NSString *limit = [NSString stringWithFormat:@"%d", pageSize.intValue];
    
    NSMutableDictionary *paramsExt = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      pageNumber, @"page",
                                      pageSize, @"per_page",
                                      @"all", @"image_type",
                                      nil];
    
    if (keywords) {
        [paramsExt setObject:keywords forKey:@"q"];
    }
    
    if (priceFrom) {
        [paramsExt setObject:priceFrom forKey:@"from_price"];
    }
    
    if (priceTo) {
        [paramsExt setObject:priceTo forKey:@"to_price"];
    }
    
    if (beginTimeFrom) {
        NSDateFormatter *date = [[NSDateFormatter alloc] init];
        [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *d = [date dateFromString:beginTimeFrom];
        NSTimeInterval late = [d timeIntervalSince1970] * 1;
        long long temp = (long long) late;
        NSString *time = [NSString stringWithFormat:@"%lld", temp];
        [paramsExt setObject:time forKey:@"from_time"];
    }
    
    if (beginTimeTo) {
        NSDateFormatter *date = [[NSDateFormatter alloc] init];
        [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *d = [date dateFromString:beginTimeTo];
        NSTimeInterval late = [d timeIntervalSince1970] * 1;
        long long temp = (long long) late;
        NSString *time = [NSString stringWithFormat:@"%lld", temp];
        [paramsExt setObject:time forKey:@"to_time"];
    }
    
    [self getNewSearchDeals:paramsExt
                 completion:completion
                    failure:failure];
    
    //    // 添加手机型号、设备id
    //    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    //    [paramsExt setObject:dm.headerVo.phoneModel forKey:@"model"];
    //    [paramsExt setObject:dm.headerVo.deviceId forKey:@"deviceId"];
    
    //    NSURL *url = [self wrapperUrlForRequestMethodGet:urlStr params:paramsExt];
    //
    //    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    //    request.delegate = self;
    //    request.allowCompressedResponse = YES;
    //    request.requestMethod = TBRequestMethodGet;
    //
    //    __weak ASIFormDataRequest *pRequest = request;
    //    __weak Tao800DealService *instance = self;
    //
    //    [request setCompletionBlock:^{
    //        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
    //        if (!dict) {
    //            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
    //            failure(tbd);
    //            return;
    //        }
    //
    //        // 接口没有meta，这是自己设置的。用于判断是否有下一页
    //        NSDictionary *meta = nil;
    //        NSString *pageSize = [paramsExt objectForKey:@"limit" convertNSNullToNil:YES];
    //        if (dict.count == pageSize.intValue) {
    //            meta = @{@"has_next" : @(1)};
    //        } else {
    //            meta = @{@"has_next" : @(0)};
    //        }
    //
    //        NSArray *items = [instance wrapperDeals:dict];
    //        NSDictionary *retDict = @{@"items" : items, @"meta" : meta};
    //        completion(retDict);
    //
    //    }];
    //
    //    [request setFailedBlock:^{
    //        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
    //        failure(tbd);
    //    }];
    //
    //    [self send:request];
}

#pragma mark 获取推荐商品列表

- (void)getRecommendDeals:(NSDictionary *)paramsExt
               completion:(void (^)(NSDictionary *))completion
                  failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v3/deals/recommend", WirelessXiongmaoz];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    
    [params setValue:@"webp" forKey:@"image_model"];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = [dict objectForKey:@"meta" convertNSNullToNil:YES];
        NSDictionary *objects = [dict objectForKey:@"objects" convertNSNullToNil:YES];
        if (!meta) {
            meta = @{@"has_next" : @(0)};
        }
        
        NSArray *banners = [instance wrapperDeals:objects];
        NSDictionary *retDict = @{@"items" : banners, @"meta" : meta};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

#pragma mark 获取搜索商品列表 (新)

- (void)getNewSearchDeals:(NSDictionary *)params
               completion:(void (^)(NSDictionary *))completion
                  failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v4/search", WirelessXiongmaoz];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:params];
    [param setValue:@"all" forKey:@"image_type"];
    [param setValue:@"webp" forKey:@"image_model"];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:param];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = [dict objectForKey:@"meta" convertNSNullToNil:YES];
        NSDictionary *objects = [dict objectForKey:@"objects" convertNSNullToNil:YES];
        if (!meta) {
            meta = @{@"has_next" : @(0)};
        }
        
        NSArray *deals = [instance wrapperDeals:objects];
        NSDictionary *retDict = @{@"items" : deals, @"meta" : meta};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getSaunterList:(NSDictionary *)paramsExt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure {
    //http://118.186.245.174:8980/
    NSString *urlString = [NSString stringWithFormat:@"%@/v2/guang/deals", WirelessUrlBase];
    //   NSString *urlString = [NSString stringWithFormat:@"%@/v2/guang/deals", @"http://118.186.245.174:8980"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    [params setValue:@"webp" forKey:@"image_model"];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    request.userInfo = paramsExt;
    
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    NSString *userId = dm.user.userId;
    if (!dm.user.userId) {
        userId = @"";
    }
    [request addRequestHeader:@"X-Zhe800filter" value:[self getUploadingDateString:UserDefaultKeyUGCSingletonNoteVisitSaunterDate]];
    [request addRequestHeader:@"X-Zhe800userid" value:userId];
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = [dict objectForKey:@"meta" convertNSNullToNil:YES];
        NSDictionary *objectsDict = [dict objectForKey:@"objects" convertNSNullToNil:YES];
        NSArray *saunterList = nil;
        if (objectsDict) {
            saunterList = [instance wrapperDeals:objectsDict];
        }
        NSNumber *hasNextNum = [meta objectForKey:@"has_next" convertNSNullToNil:YES];//meta[@"has_next"];
        if (!hasNextNum) {
            hasNextNum = @(0);
        }
        if (!saunterList) {
            saunterList = [NSArray array];
        }
        NSDictionary *retDict = @{
                                  @"items" : saunterList,
                                  @"hasNext" : hasNextNum,
                                  @"userInfo" : pRequest.userInfo
                                  };
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
    
}

#pragma mark 获取商品详情列表

- (void)getDealDetails:(NSDictionary *)paramsExt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure {
    
    NSMutableString *urlStr = [NSMutableString stringWithCapacity:255];
    [urlStr appendString:UrlBase];
    [urlStr appendFormat:@"/v4/deals/ids"];
    NSString *ids = paramsExt[@"ids"];
    if (ids) {
        [urlStr appendFormat:@"?ids=%@", ids];
    }
    
    //    NSURL *url = [self wrapperUrlForRequestMethodGet:urlStr params:paramsExt];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        // 接口没有meta，这是自己设置的。用于判断是否有下一页
        //NSDictionary *meta = @{@"has_next" : @(0)};
        
        NSDictionary *meta = [dict objectForKey:@"meta" convertNSNullToNil:YES];
        NSDictionary *objects = [dict objectForKey:@"objects" convertNSNullToNil:YES];
        if (!meta) {
            meta = @{@"has_next" : @(0)};
        }
        
        NSArray *items = [instance wrapperDeals:objects];
        NSDictionary *retDict = @{@"items" : items, @"meta" : meta};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

#pragma mark 开卖提醒订阅统计

- (void)addDealSubscribe:(NSDictionary *)paramsExt
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/cn/deal_subscibe", @"http://www.zhe800.com"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    
    NSString *date = currentDateFormatToStr();
    [params setObject:date forKey:@"date"];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        completion(dict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

#pragma mark 手机充值纪录

- (void)getMobileRecordList:(NSDictionary *)paramsExt
                 completion:(void (^)(NSDictionary *))completion
                    failure:(void (^)(TBErrorDescription *))failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/orders/get_order_list", RecordBaseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *data =[dict objectForKey:@"data" convertNSNullToNil:YES];// dict[@"data"];
        NSNumber *hasNext =[dict objectForKey:@"hasNext" convertNSNullToNil:YES];// dict[@"hasNext"];
        if (hasNext == nil) {
            hasNext = [NSNumber numberWithBool:NO];
        }
        NSArray *saunterList = [instance wrapperMobileRecord:data];
        NSDictionary *retDict = @{
                                  @"items" : saunterList,
                                  @"hasNext" : hasNext,
                                  };
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getMobileRechargeDeals:(NSDictionary *)paramsExt
                    completion:(void (^)(NSDictionary *))completion
                       failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/recharge", WirelessUrlBase];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        completion(dict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getMobileRechargeDetail:(NSDictionary *)paramsExt
                     completion:(void (^)(NSDictionary *))completion
                        failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *faceValue = [paramsExt objectForKey:@"faceValue"];
    NSString *mobile = [paramsExt objectForKey:@"mobile"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/recharge/%@?mobile=%@", WirelessUrlBase, faceValue, mobile];
    
    NSURL *url = [NSURL URLWithString:urlString];
    TBDPRINT(@"面值详情页面数据请求 = %@", url);
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        completion(dict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getHomePageOperationInfo:(NSDictionary *)paramsExt
                      completion:(void (^)(NSDictionary *))completion
                         failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v4/homesetting", WirelessXiongmaoz];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:paramsExt];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        completion(dict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
    
}

- (void)getPromotionHomePageOperationInfo:(NSDictionary *)paramsExt
                               completion:(void (^)(NSDictionary *))completion
                                  failure:(void (^)(TBErrorDescription *))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@/homepromotion/v1", WirelessUrlBase];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:paramsExt];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        completion(dict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}
-(void)getSaunterAllCategory:(NSDictionary *)paramsExt
                  completion:(void (^)(NSDictionary *))completion
                     failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v3/guang/tags",WirelessUrlBase];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:paramsExt];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        NSArray *array = @[];
        if ([dict isKindOfClass:[NSArray class]]) {
            NSArray *tags = (NSArray *) dict;
            array = [instance wrapperTags:tags];
        }
        
        NSDictionary *retDict = @{@"items" : array};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}
-(void)getSaunterDisplayCategory:(NSDictionary *)paramsExt
                      completion:(void (^)(NSDictionary *))completion
                         failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v3/guang/tags/recommend",WirelessUrlBase];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:paramsExt];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        NSArray *array = @[];
        if ([dict isKindOfClass:[NSArray class]]) {
            NSArray *tags = (NSArray *) dict;
            array = [instance wrapperTags:tags];
        }
        
        NSDictionary *retDict = @{@"items" : array};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}


//心愿单保存
-(void)getHeartWishCreate:(NSDictionary *)paramsExt
               completion:(void (^)(NSDictionary *))completion
                  failure:(void (^)(TBErrorDescription *))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@/wish_lists/create", WishBaseUrl];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setShouldContinueWhenAppEntersBackground:self.enableExecuteInBackground];
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [request addRequestHeader:@"X-Tuan800-Platform" value:dm.platform];
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [self wrapperPostRequest:paramsExt request:request];
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        completion(dict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
    
}


//心愿单删除
-(void)getHeartWishDelete:(NSDictionary *)paramsExt
               completion:(void (^)(NSDictionary *))completion
                  failure:(void (^)(TBErrorDescription *))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@/wish_lists/destroy", WishBaseUrl];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setShouldContinueWhenAppEntersBackground:self.enableExecuteInBackground];
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [request addRequestHeader:@"X-Tuan800-Platform" value:dm.platform];
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [self wrapperPostRequest:paramsExt request:request];
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        completion(dict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
    
}

//心愿单列表
-(void)getHeartWishList:(NSDictionary *)paramsExt
             completion:(void (^)(NSDictionary *))completion
                failure:(void (^)(TBErrorDescription *))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@/cn/wish_lists/index", WishBaseUrl];
    NSURL *url = [NSURL URLWithString:urlString];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [self wrapperPostRequest:paramsExt request:request];
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        NSArray*array = [Tao800HeartWishBVO wrapperHeartWishBVOList:dict];
        [dict setValue:array forKey:@"item"];
        completion(dict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

//查询是否有心愿单达成
-(void)getHeartWishReached:(NSDictionary *)paramsExt
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure{
    //
    NSString *urlString = [NSString stringWithFormat:@"%@/cn/wish_lists/reached", WishBaseUrl];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    [self wrapperPostRequest:paramsExt request:request];
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        NSNumber *wishStatus = [dict objectForKey:@"wish_status" convertNSNullToNil:YES];
        NSNumber *code = [dict objectForKey:@"code" convertNSNullToNil:YES];
        if (!wishStatus) {
            wishStatus = @(0);
        }
        if (!code) {
            code = @(0);
        }
        Tao800HeartWishReachedBVO *wishReachedBvo = [Tao800HeartWishReachedBVO wrapperHeartWishReachedBVO:dict];
        //NSDictionary *responseDict = @{@"reached" : wishReachedBvo.reached ,@"count" : wishReachedBvo.count};
        NSDictionary *retDict = @{@"wishReachedBvo" : wishReachedBvo, @"wishStatus" : wishStatus, @"code" : code};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

-(void)getHeartWishCreateAllWish:(NSDictionary *)paramsExt
                      completion:(void (^)(NSDictionary *))completion
                         failure:(void (^)(TBErrorDescription *))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@/wish_lists/batch_create", WishBaseUrl];
    
    
    NSURL *url = [self wrapperUrlForWish:urlString params:paramsExt];
    //NSURL *url = [NSURL URLWithString:urlString];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setShouldContinueWhenAppEntersBackground:self.enableExecuteInBackground];
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [request addRequestHeader:@"X-Tuan800-Platform" value:dm.platform];
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"device", nil];
    [self wrapperPostRequest:params request:request];
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        completion(dict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

//心愿单删除
-(void)getHeartWishDeleteAllWish:(NSDictionary *)paramsExt
                      completion:(void (^)(NSDictionary *))completion
                         failure:(void (^)(TBErrorDescription *))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@/wish_lists/batch_destroy", WishBaseUrl];
    NSURL *url = [self wrapperUrlForWish:urlString params:paramsExt];
    //    NSURL *url = [NSURL URLWithString:urlString];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setShouldContinueWhenAppEntersBackground:self.enableExecuteInBackground];
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [request addRequestHeader:@"X-Tuan800-Platform" value:dm.platform];
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800DealService *instance = self;
    
    //[self wrapperPostRequest:paramsExt request:request];
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        completion(dict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (NSURL *)wrapperUrlForWish:(NSString *)urlStr params:(NSDictionary *)params {
    if (params == nil || params.count < 1) {
        return [NSURL URLWithString:urlStr];
    }
    
    NSMutableArray *paramArr = [NSMutableArray arrayWithCapacity:params.count];
    for (NSString *key in params) {
        
        NSString *value = [params objectForKey:key];
        NSString *param = [NSString stringWithFormat:@"key[]=%@", value];
        
        [paramArr addObject:param];
    }
    NSString *wrapperUrlString = [paramArr componentsJoinedByString:@"&"];
    NSRange range = [urlStr rangeOfString:@"?"];
    NSString *preStr = nil;
    
    if (range.length > 0) {
        preStr = @"&";
    } else {
        preStr = @"?";
    }
    wrapperUrlString = [NSString stringWithFormat:@"%@%@%@&device=ios", urlStr, preStr, wrapperUrlString];
    wrapperUrlString = [wrapperUrlString urlEncoded];
    return [NSURL URLWithString:wrapperUrlString];
}

- (NSURL *)wrapperUrlForRequestMethodGet:(NSString *)urlStr params:(NSDictionary *)params addition:(NSString*)string{
    if (params == nil || params.count < 1) {
        return [NSURL URLWithString:urlStr];
    }
    
    NSMutableArray *paramArr = [NSMutableArray arrayWithCapacity:params.count];
    for (NSString *key in params) {
        
        NSString *value = [params objectForKey:key];
        NSString *param = [NSString stringWithFormat:@"%@=%@", key, value];
        
        [paramArr addObject:param];
    }
    NSString *wrapperUrlString = [paramArr componentsJoinedByString:@"&"];
    NSRange range = [urlStr rangeOfString:@"?"];
    NSString *preStr = nil;
    
    if (range.length > 0) {
        preStr = @"&";
    } else {
        preStr = @"?";
    }
    wrapperUrlString = [NSString stringWithFormat:@"%@%@%@", urlStr, preStr, wrapperUrlString];
    if (string) {
        range = [wrapperUrlString rangeOfString:@"?"];
        if (range.length > 0) {
            preStr = @"&";
        } else {
            preStr = @"?";
        }
        wrapperUrlString = [NSString stringWithFormat:@"%@%@%@",wrapperUrlString,preStr,string];
    }
    wrapperUrlString = [wrapperUrlString urlEncoded];
    return [NSURL URLWithString:wrapperUrlString];
}


@end
