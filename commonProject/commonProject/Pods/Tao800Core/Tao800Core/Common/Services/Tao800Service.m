//
//  Tao800Service.m
//  tao800
//
//  Created by enfeng yang on 12-4-19.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import "Tao800Service.h"
#import "TBCore/TBCore.h"
#import "Tao800DealVo.h"
#import "Tao800CategoryVo.h"
#import "TBNetwork/ASIDownloadCache.h"

#import "Tao800SoftVo.h"
#import "Tao800BannerVo.h"
#import "Tao800DataModelSingleton.h"
#import "TBCore/TBCoreMacros.h"
#import "Tao800ShopVo.h"
#import "TBUI/TBUI.h"
#import "Tao800Util.h"
#import "Tao800AdvertVo.h"
#import "Tao800FunctionCommon.h"

@implementation Tao800Service

#pragma mark - 解析商品列表（正在热卖、即将开卖）
- (NSDictionary *)convertJsonToSellDeals:(NSDictionary *)dict withServiceTag:(ServiceTag)serviceTag {
    
    NSString *sellingCount = [NSString stringWithFormat:@"%d",[[dict objectForKey:@"sellingCount"] intValue]];
    NSString *toSellCount = [NSString stringWithFormat:@"%d",[[dict objectForKey:@"toSellCount"] intValue]];
    NSArray *deals = [dict objectForKey:@"deals"];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:deals.count];
    @try {
        for (NSDictionary *item in deals) {
            Tao800DealVo *deal = [[Tao800DealVo alloc] init];
            NSNumber* dealIdNum = [item objectForKey:@"id"];
            if (dealIdNum) {
                deal.dealId = dealIdNum.intValue;
            }
            
            if (serviceTag == ServiceGetTodayDeals) {
                deal.isTodayDeal = YES;
            }else {
                deal.isTodayDeal = NO;
            }
            
            deal.isZhiDeGuangDeal = NO;
            
            deal.title = [item objectForKey:@"title"];
            NSDictionary *imageDict = [item objectForKey:@"image_url"];
            NSString *big = [imageDict objectForKey:@"big"];
            NSString *normal = [imageDict objectForKey:@"normal"];
            NSString *small = [imageDict objectForKey:@"small"];
            NSString *hd1 = [imageDict objectForKey:@"hd1"];
            NSString *hd2 = [imageDict objectForKey:@"hd2"];
            deal.bigImageUrl = big;
            deal.normalImageUrl = normal;
            deal.smallImageUrl = small;
            deal.hd1ImageUrl = hd1;
            deal.hd2ImageUrl = hd2;
            deal.recommendedById = ((NSString *) [item objectForKey:@"recommender_id"]).intValue;
            deal.recommendReason = [item objectForKey:@"recommend_reason"];
            deal.beginTime = [item objectForKey:@"begin_time"];
            deal.expireTime = [item objectForKey:@"expire_time"];
            deal.dealUrl = [item objectForKey:@"deal_url"];
            deal.wapUrl = [item objectForKey:@"wap_url"];
            deal.urlName = [item objectForKey:@"url_name"];
            deal.hotLabel = [item objectForKey:@"hot_label"];
            deal.listPrice = ((NSString *) [item objectForKey:@"list_price"]).intValue;
            deal.price = ((NSString *) [item objectForKey:@"price"]).intValue;
            deal.oos =(DealSaleState) ((NSString *) [item objectForKey:@"oos"]).intValue;
            deal.productType =(DealProductType) ((NSString *) [item objectForKey:@"product_type"]).intValue;
            deal.vip = [item objectForKey:@"vip"];
            deal.isBaoyou = [[item objectForKey:@"baoyou"] boolValue];
            deal.isFanjifen = [[item objectForKey:@"fanjifen"] boolValue];
            deal.isHuiyuangou = [[item objectForKey:@"huiyuangou"] boolValue];
            deal.isZhuanxiang = [[item objectForKey:@"zhuanxiang"] boolValue];
            
            // 增加店铺信息
            Tao800ShopVo *shopVo = [[Tao800ShopVo alloc] init];
            NSDictionary *shopDic = [item objectForKey:@"shop"];
            shopVo.clickUrl = [shopDic objectForKey:@"click_url"];
            shopVo.itemsCount = [[shopDic objectForKey:@"items_count"] intValue];
            shopVo.name = [shopDic objectForKey:@"name"];
            shopVo.picUrl = [shopDic objectForKey:@"pic_path"];
            shopVo.rate = [shopDic objectForKey:@"rate"];
            NSDictionary *credibilityDic = [shopDic objectForKey:@"credibility"];
            if (credibilityDic != nil && ![credibilityDic isKindOfClass:[NSNull class]]) {
                NSString *credibilityName = [credibilityDic objectForKey:@"area_name"];
                if ([credibilityName isEqualToString:@"cap"]) {
                    shopVo.shopCreditName = ShopCreditNameCap;
                }else if ([credibilityName isEqualToString:@"red"]){
                    shopVo.shopCreditName = ShopCreditNameRed;
                }else if ([credibilityName isEqualToString:@"blue"]){
                    shopVo.shopCreditName = ShopCreditNameBlue;
                }else if ([credibilityName isEqualToString:@"crown"]){
                    shopVo.shopCreditName = ShopCreditNameCrown;
                }
                shopVo.shopCreditOffset = [[credibilityDic objectForKey:@"offset"] intValue];
            }
            
            [shopVo resetNullProperty];
            deal.shopVo = shopVo;
            
            [deal resetNullProperty];

            [arr addObject:deal];
        }

    } @catch (NSException *e) {
        TBDPRINT(@"convertJson ToDeals 字符串 转换 数字错误");
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:sellingCount,@"sellingCount",toSellCount,@"toSellCount",arr,@"items", nil];
}

#pragma mark 解析商品列表（今日精选、明日预告）
- (NSMutableArray *)convertJsonToDeals:(NSDictionary *)dict withServiceTag:(ServiceTag)serviceTag {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[dict count]];
    @try {
        for (NSDictionary *item in dict) {
            Tao800DealVo *deal = [[Tao800DealVo alloc] init];
            NSNumber* dealIdNum = [item objectForKey:@"id"];
            if (dealIdNum) {
                deal.dealId = dealIdNum.intValue;
            }
            
            if (serviceTag == ServiceGetTodayDeals) {
                deal.isTodayDeal = YES;
            }else {
                deal.isTodayDeal = NO;
            }
            
            deal.isZhiDeGuangDeal = NO;
            
            deal.title = [item objectForKey:@"title"];
            NSDictionary *imageDict = [item objectForKey:@"image_url"];
            NSString *big = [imageDict objectForKey:@"big"];
            NSString *normal = [imageDict objectForKey:@"normal"];
            NSString *small = [imageDict objectForKey:@"small"];
            NSString *hd1 = [imageDict objectForKey:@"hd1"];
            NSString *hd2 = [imageDict objectForKey:@"hd2"];
            NSString *hd3 = [imageDict objectForKey:@"hd3"];
            NSString *hd4 = [imageDict objectForKey:@"hd4"];
            NSString *hd5 = [imageDict objectForKey:@"hd5"];
            deal.bigImageUrl = big;
            deal.normalImageUrl = normal;
            deal.smallImageUrl = small;
            deal.hd1ImageUrl = hd1;
            deal.hd2ImageUrl = hd2;
            deal.hd3ImageUrl = hd3;
            deal.hd4ImageUrl = hd4;
            deal.hd5ImageUrl = hd5;
            deal.recommendedById = ((NSString *) [item objectForKey:@"recommender_id"]).intValue;
            deal.recommendReason = [item objectForKey:@"recommend_reason"];
            deal.beginTime = [item objectForKey:@"begin_time"];
            deal.expireTime = [item objectForKey:@"expire_time"];
            deal.dealUrl = [item objectForKey:@"deal_url"];
            deal.wapUrl = [item objectForKey:@"wap_url"];
            deal.shareUrl = [item objectForKey:@"share_url"];
            deal.urlName = [item objectForKey:@"url_name"];
            deal.hotLabel = [item objectForKey:@"hot_label"];
            deal.listPrice = ((NSString *) [item objectForKey:@"list_price"]).intValue;
            deal.price = ((NSString *) [item objectForKey:@"price"]).intValue;
            deal.oos =(DealSaleState) ((NSString *) [item objectForKey:@"oos"]).intValue;
            deal.productType =(DealProductType) ((NSString *) [item objectForKey:@"product_type"]).intValue;
            deal.vip = [item objectForKey:@"vip"];
            deal.isBaoyou = [[item objectForKey:@"baoyou"] boolValue];
            deal.isFanjifen = [[item objectForKey:@"fanjifen"] boolValue];
            deal.isHuiyuangou = [[item objectForKey:@"huiyuangou"] boolValue];
            deal.isZhuanxiang = [[item objectForKey:@"zhuanxiang"] boolValue];
            deal.dealDescTopTip = [item objectForKey:@"dealDescTopTip"];
            
            // 增加店铺信息
            Tao800ShopVo *shopVo = [[Tao800ShopVo alloc] init];
            NSDictionary *shopDic = [item objectForKey:@"shop"];
            shopVo.clickUrl = [shopDic objectForKey:@"click_url"];
            shopVo.itemsCount = [[shopDic objectForKey:@"items_count"] intValue];
            shopVo.name = [shopDic objectForKey:@"name"];
            shopVo.picUrl = [shopDic objectForKey:@"pic_path"];
            shopVo.rate = [shopDic objectForKey:@"rate"];
            NSDictionary *credibilityDic = [shopDic objectForKey:@"credibility"];
            if (credibilityDic != nil && ![credibilityDic isKindOfClass:[NSNull class]]) {
                NSString *credibilityName = [credibilityDic objectForKey:@"area_name"];
                if ([credibilityName isEqualToString:@"cap"]) {
                    shopVo.shopCreditName = ShopCreditNameCap;
                }else if ([credibilityName isEqualToString:@"red"]){
                    shopVo.shopCreditName = ShopCreditNameRed;
                }else if ([credibilityName isEqualToString:@"blue"]){
                    shopVo.shopCreditName = ShopCreditNameBlue;
                }else if ([credibilityName isEqualToString:@"crown"]){
                    shopVo.shopCreditName = ShopCreditNameCrown;
                }
                shopVo.shopCreditOffset = [[credibilityDic objectForKey:@"offset"] intValue];
            }
            
            [shopVo resetNullProperty];
            deal.shopVo = shopVo;
            
            [deal resetNullProperty];
            
            [arr addObject:deal];
        }
        
    } @catch (NSException *e) {
        TBDPRINT(@"convertJson ToDeals 字符串 转换 数字错误");
    }
    return arr;
}

////专题获得的数据解析
- (void)convertJsonToAdvertSingle:(NSDictionary *)dict  advert:(Tao800AdvertVo *)advertVo {
    advertVo.data = [dict objectForKey:@"data"];
    advertVo.advertType = [dict objectForKey:@"type"];
    advertVo.message = [dict objectForKey:@"message"];
    advertVo.aId = [dict objectForKey:@"id"];
    advertVo.title = [dict objectForKey:@"title"];
    advertVo.imgUrl = [dict objectForKey:@"imgurl"];
    advertVo.show_model = [[dict objectForKey:@"show_model"] boolValue];
}
 
//获取分类解析
-(NSMutableArray *)convertJsonToCategory:(NSDictionary *)dict
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity: [dict count]];
    
    for (NSDictionary *item in dict) {
        
        Tao800CategoryVo *vo = [[Tao800CategoryVo alloc] init];
        vo.categoryId = [[item objectForKey:@"id"] intValue];
        vo.categoryName = [item objectForKey:@"category_name"];
        vo.urlName = [item objectForKey:@"url_name"];
        
        [vo resetNullProperty];
        [arr addObject:vo];
        
        
    }
    
    return arr;
}

//- (NSArray *) convertJsonToTomorrowAdvertVo:(NSDictionary *)dict {
//    NSMutableArray *arr = [NSMutableArray arrayWithCapacity: [dict count]];
//
//    for (NSDictionary *item in dict) {
//        Tao800TomorrowAdvertVo *vo = [[Tao800TomorrowAdvertVo alloc] init];
//        vo.advertId = [item objectForKey:@"id"];
//        vo.dealUrl = [item objectForKey:@"deal_url"];
//        vo.wapUrl = [item objectForKey:@"wap_url"];
//        vo.value = [item objectForKey:@"value"];
//        vo.title = [item objectForKey:@"title"];
//        vo.advertType = [item objectForKey:@"type"];
//        vo.price = [item objectForKey:@"price"];
//        vo.listPrice = [item objectForKey:@"list_price"];
//        vo.smallImageUrl = [item objectForKey:@"image_little_ios_url"];
//        vo.normalImageUrl = [item objectForKey:@"image_middle_ios_url"];
//
//        [vo resetNullProperty];
//        [arr addObject:vo];
//
//        
//    }
//
//    return arr;
//}

- (Tao800SoftVo *)convertJsonToSoftVo:(NSDictionary *)dict {
    //解析软件升级
    NSDictionary *softDict = [dict objectForKey:@"soft"];
    Tao800SoftVo *softVo = [[Tao800SoftVo alloc] init];
    softVo.url = [softDict objectForKey:@"url"];
    softVo.minVersion = [softDict objectForKey:@"min_version"];
    softVo.version = [softDict objectForKey:@"version"];
    softVo.mustUpdate= [[softDict objectForKey:@"must-update"] boolValue];
    softVo.softDescription = [softDict objectForKey:@"description"];
    [softVo resetNullProperty];
    
    //解析tips
    NSArray *tips = [dict objectForKey:@"tips"];
    for (int ix=0; ix<tips.count; ix++) {
        NSDictionary *dic = [tips objectAtIndex:ix];
        
        Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
        
        if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.closelogin.url"]) {
            NSString *tao800CloseLoginUrl = [dic objectForKey:@"content"];
            if (tao800CloseLoginUrl != nil && ![tao800CloseLoginUrl isEqualToString:@""]) {
                dm.tao800CloseLoginUrl = tao800CloseLoginUrl;
            }
        }else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.out.protocol"]) {
            NSString *content = [dic objectForKey:@"content"];
            if (content != nil && ![content isEqualToString:@""]) {
                
                NSArray *contentArray = [content componentsSeparatedByString:@","];
                NSMutableDictionary *result = [NSMutableDictionary dictionary];
                
                for (int i=0; i<contentArray.count; i++) {
                    [result setObject:[NSNumber numberWithBool:YES] forKey:[contentArray objectAtIndex:i]];
                }
                
                dm.tao800OutProtocol = result;
            }
        }else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.out.close"]) {
            NSString *content = [dic objectForKey:@"content"];
            
            if (content != nil && ![content isEqualToString:@""]) {
                if ([content isEqualToString:@"0"]) { // 0代表开启白名单功能 1代表关闭
                    dm.tao800OutClose = YES;
                }else {
                    dm.tao800OutClose = NO;
                }
            }else {
                dm.tao800OutClose = NO;
            }
        }else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.deals.comingsoon"]) {
            NSString *content = [dic objectForKey:@"content"];
            
            if (content != nil && [content isEqualToString:@"true"]) {
                dm.isShowPreviewDealButton = YES;
            }else {
                dm.isShowPreviewDealButton = NO;
            }
        }else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.deals.begintime"]) {
            NSString *content = [dic objectForKey:@"content"];
            
            if (content != nil && ![content isEqualToString:@""]) {
                dm.showPreviewDealTime = content;
            }
        }else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.weixin.score"]) {
            NSString *content = [dic objectForKey:@"content"];
            
            if (content != nil && ![content isEqualToString:@""] && ![content isEqualToString:@"0"]) {
                dm.weixinScore = content;
            }
        }
        else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.rechargelottery.switch"]) {
            NSString *content = [dic objectForKey:@"content"];
            
            if (content != nil&&![content isEqualToString:@""]) {
                dm.isShowPhoneRechargeButton = content;
            }
        }
        else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.clear.cookie"]) {
            NSString *content = [dic objectForKey:@"content"];
            
            if (content != nil && [content isEqualToString:@"true"]) {
                dm.isClearTaobaoCookie = YES;
            }else {
                dm.isClearTaobaoCookie = NO;
            }
        }
    }
    
    return softVo;
}

- (NSArray *) convertJsonToTodayListBannerVo:(NSDictionary *)dict {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity: [dict count]];
    
    for (NSDictionary *item in dict) {
        
        Tao800BannerVo *vo = [[Tao800BannerVo alloc] init];
        vo.bannerId = [item objectForKey:@"id"];
        vo.bannerType = [item objectForKey:@"banner_type"];
        vo.title = [item objectForKey:@"title"];
        vo.value = [item objectForKey:@"value"];
        vo.dealUrl = [item objectForKey:@"deal_url"];
        vo.wapUrl = [item objectForKey:@"wap_url"];
        vo.bigImageUrl = [item objectForKey:@"image_largest_ios_url"];
        vo.normalImageUrl = [item objectForKey:@"image_middle_ios_url"];
        vo.smallImageUrl = [item objectForKey:@"image_little_ios_url"];
        vo.show_model = [[item objectForKey:@"show_model"] boolValue];
        vo.detailString = [item objectForKey:@"detail"];
        
        // 判断是否有子专题
        NSArray *childTopics = [item objectForKey:@"child_topics"];
        if (childTopics && childTopics.count > 0) {
            NSMutableArray *childTopicsResult = [NSMutableArray arrayWithCapacity:childTopics.count];
            for (NSDictionary *topicDic in childTopics) {
                
                Tao800ActivityVo *activityVo = [[Tao800ActivityVo alloc] init];
                activityVo.bannerType = [topicDic objectForKey:@"banner_type"];
                activityVo.mImageUrl = [topicDic objectForKey:@"image_ios_url"];
                activityVo.title = [topicDic objectForKey:@"title"];
                activityVo.value = [topicDic objectForKey:@"value"];
                [childTopicsResult addObject:activityVo];
                
            }
            vo.childTopics = childTopicsResult;
        }
        
        [vo resetNullProperty];
        [arr addObject:vo];
        
    }
    
    return arr;
}

- (NSMutableArray *)convertJsonToActivity:(NSMutableArray *)dict{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[dict count]];
    @try {
        for (NSDictionary *item in dict) {
            
            Tao800ActivityVo *vo = [[Tao800ActivityVo alloc] init];
            vo.bannerType = [item objectForKey:@"banner_type"];
            vo.dealUrl = [item objectForKey:@"deal_url"];
            vo.activityId = [item objectForKey:@"id"];
            vo.lImageUrl = [item objectForKey:@"image_largest_ios_url"];
            vo.mImageUrl = [item objectForKey:@"image_middle_ios_url"];
            vo.sImageUrl = [item objectForKey:@"image_little_ios_url"];
            vo.title = [item objectForKey:@"title"];
            vo.value = [item objectForKey:@"value"];
            vo.status = [[item objectForKey:@"status"] intValue] ;
            vo.wapUrl = [item objectForKey:@"wap_url"];
            vo.show_model = [[item objectForKey:@"show_model"] boolValue];
            vo.detailString = [item objectForKey:@"detail"];
            vo.ext = [item objectForKey:@"ext"];
            
            [vo resetNullProperty];
            
            [arr addObject:vo];
            
        }
        
    } @catch (NSException *e) {
        TBDPRINT(@"convertJsonToActivity 字符串 转换 数字错误");
    }
    return arr;
}


//- (NSArray *) convertJsonToStartInfoVo:(NSDictionary *)dict {
//    NSMutableArray *arr = [NSMutableArray arrayWithCapacity: [dict count]];
//    
//    for (NSDictionary *item in dict) {
//        
//        Tao800StartInfoVo *vo = [[Tao800StartInfoVo alloc] init];
//        vo.bannerId = [item objectForKey:@"id"];
//        vo.type = [item objectForKey:@"type"];
//        vo.title = [item objectForKey:@"title"];
//        vo.value = [item objectForKey:@"value"];
//        vo.dealUrl = [item objectForKey:@"deal_url"];
//        vo.wapUrl = [item objectForKey:@"wap_url"];
//        vo.bigImageUrl = [item objectForKey:@"image_largest_ios_url"];
//        vo.normalImageUrl = [item objectForKey:@"image_middle_ios_url"];
//        vo.smallImageUrl = [item objectForKey:@"image_little_ios_url"];
//        vo.updateTime = [item objectForKey:@"update_time"];
//        vo.detail = [item objectForKey:@"detail"];
//        vo.show_model = [[item objectForKey:@"show_model"] boolValue];
//        [vo  resetNullProperty];
//        [arr addObject:vo];
//        
//    }
//    
//    return arr;
//}

#pragma mark -
- (void)getTopicActivityDeals:(NSDictionary *)params {
    NSString *pageSize = [params objectForKey:@"pageSize"];
    NSString *pageNum = [params objectForKey:@"pageNum"];
    NSString *dealids = [params objectForKey:@"topic_ids"];
    
    NSInteger flag = ServiceGetTopicActivityDeals;
    NSMutableString *urlStr = [NSMutableString stringWithCapacity:255];
    [urlStr appendString:UrlBase];
    [urlStr appendFormat:@"/v2/deals?ids=%@",dealids];
    [urlStr appendFormat:@"&image_type=all&per_page=%@", pageSize];
    [urlStr appendFormat:@"&page=%@", pageNum];

    
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = flag;
    [request setRequestMethod :TBRequestMethodGet];
    
    [self send:request];
}


- (void)getDeals:(NSDictionary *)params tomorrow:(BOOL)isTomorrow {
    NSString *pageSize = [params objectForKey:@"pageSize"];
    NSString *pageNum = [params objectForKey:@"pageNum"];
    NSString *categoryUrlName = [params objectForKey:@"categoryUrlName"];
    NSString *action = nil;//prdofcategory.json, prdoftomorrow.json

//    NSString *tomorrow = @"";
    NSInteger flag = ServiceGetTodayDeals;
    if (isTomorrow) {
//        tomorrow = @"&date=tomorrow";
        action = @"prdoftomorrow.json";
        flag = ServiceGetTomorrowDeals;
    } else {
        action = @"prdofcategory.json";
    }

//    NSURL *url = [NSURL URLWithString :[NSString stringWithFormat:@"%@/prdofcategory.json?url_name=%@&image_type=all&perpage=%@&page=%@%@",
//                                                                  UrlBase, categoryUrlName, pageSize, pageNum, tomorrow]];
    
    NSMutableString *urlStr = [NSMutableString stringWithCapacity:255];
    [urlStr appendString:UrlBase];
    [urlStr appendFormat:@"/tao800/%@", action];
    [urlStr appendFormat:@"?image_type=all&per_page_count=%@", pageSize];
    [urlStr appendFormat:@"&page=%@", pageNum];
    if (categoryUrlName && categoryUrlName.length>0) {
        [urlStr appendFormat:@"&url_name=%@", categoryUrlName];
    }
    
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    if (dm.recommendCid && dm.recommendCid.length > 0) {
        [urlStr appendFormat:@"&cids=%@", dm.recommendCid];
    }
    
    NSURL *url = [NSURL URLWithString :urlStr];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = flag;
    [request setRequestMethod :TBRequestMethodGet];

    [self send:request];
}

#pragma mark - 获取今日精选deals
- (void)getTodayDeals:(NSDictionary *)params {
    [self getDeals:params tomorrow:NO];
}

- (void)getTomorrowDeals:(NSDictionary *)params {
    [self getDeals:params tomorrow:YES];
}

- (void)getPreviewDeals:(NSDictionary *)params {
    NSString *pageSize = [params objectForKey:@"pageSize"];
    NSString *pageNum = [params objectForKey:@"pageNum"];
    
    NSMutableString *urlStr = [NSMutableString stringWithCapacity:255];
    [urlStr appendString:UrlBase];
    [urlStr appendFormat:@"/v1/deals/tomorrow"];
    [urlStr appendFormat:@"?image_type=all&per_page=%@", pageSize];
    [urlStr appendFormat:@"&page=%@", pageNum];
    
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceGetPreviewDeals;
    [request setRequestMethod :TBRequestMethodGet];
    
    [self send:request];
}

#pragma mark - 获取正在热卖商品
- (void)getSellingDeals:(NSDictionary *)params {
    [self getDeals:params sellStatus:DealSellStatusSelling];
}

#pragma mark 获取即将开卖商品
- (void)getWillSellDeals:(NSDictionary *)params {
    [self getDeals:params sellStatus:DealSellStatusWillSell];
}

#pragma mark 获取商品（正在热卖、即将开卖）
- (void)getDeals:(NSDictionary *)params sellStatus:(DealSellStatus)sellStatus {
    
    NSString *pageSize = [params objectForKey:@"pageSize"];
    NSString *pageNum = [params objectForKey:@"pageNum"];
    
    int limit = pageSize.intValue; //表示每页显示记录数
    int offset = (pageNum.intValue - 1) * limit; //表示从第几条读取数据 0--表示从第1条记录开始读取limit条记录
    
    NSString *oos = [params objectForKey:@"oos"]; //表示商品是否已经售光 取值范围：1--售光;0--未售光，如果不传该参数默认全部
    NSString *beginTime = [params objectForKey:@"beginTime"]; //表示开卖时间 时间戳long型值格式,-1--表示历史商品；-2--表示全部商品
    NSString *image_type = [params objectForKey:@"imageType"]; //表示图片类型 all--所有图片类型，big--大图,normal--标准图，small--小图;hd1--HD1高清图;hd2--HD2高清图 ;默认是全部图片
    
    NSString *action = nil;
    NSInteger flag = 0;
    if (sellStatus == DealSellStatusSelling) {
        action = @"hot_deals";
        flag = ServiceGetSellingDeals;
    } else if (sellStatus == DealSellStatusWillSell){
        action = @"will_hot_deals";
        flag = ServiceGetWillSellDeals;
    }
    
    NSMutableString *urlStr = [NSMutableString stringWithCapacity:255];
    [urlStr appendString:UrlBaseNeedLogin];
    [urlStr appendFormat:@"/deals/%@", action];
    [urlStr appendFormat:@"?limit=%d", limit];
    [urlStr appendFormat:@"&offset=%d", offset];
    
    if (oos && oos.length>0) {
        [urlStr appendFormat:@"&oos=%@", oos];
    }
    
    if (beginTime && beginTime.length>0) {
        if ([beginTime isEqualToString:@"-2"] || [beginTime isEqualToString:@"-1"]) {
            [urlStr appendFormat:@"&beginTime=%@", beginTime];
        }else {
            // 得到当前时间
            NSString *currentDateStr = [Tao800Util currentDateStr:nil];
            NSString *subCurrentDateStr = [currentDateStr substringToIndex:10];
            NSString *beginTimeStr = [NSString stringWithFormat:@"%@ %@:00:00",subCurrentDateStr,beginTime];
            NSLog(@"%@",beginTimeStr);
            
            NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *d=[dateFormat dateFromString:beginTimeStr];
            
            
            NSTimeInterval timeInterval = [d timeIntervalSince1970];
            NSLog(@"%f",timeInterval);
            NSString *timeIntervalStr = [NSString stringWithFormat:@"%f",timeInterval];
            NSString *subTimeIntervalStr = [timeIntervalStr substringToIndex:10];
            
            [urlStr appendFormat:@"&beginTime=%@",subTimeIntervalStr];
        }
    }else {
        [urlStr appendFormat:@"&beginTime=-2"];
    }
    
    if (image_type && image_type.length>0) {
        [urlStr appendFormat:@"&image_type=%@",image_type];
    }
    
    // 添加手机型号、设备id
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [urlStr appendFormat:@"&model=%@",dm.headerVo.phoneModel];
    [urlStr appendFormat:@"&deviceId=%@",dm.headerVo.deviceId];
    
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = flag;
    [request setRequestMethod :TBRequestMethodGet];
    
    [self send:request];
}


#pragma mark - 获取商品详情
- (void)getDealDetail:(NSDictionary *)params {
    NSString *dealId = [params objectForKey:@"dealId"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/v2/deals?image_type=all&ids=%@",UrlBase,dealId];
    
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceGetDealDetail;
    [request setRequestMethod :TBRequestMethodGet];
    
    [self send:request];
}

- (void)getAdvertisement:(NSDictionary *)params {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/tao800/app.json", UrlBase]];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:TBRequestMethodGet];
    request.serviceMethodFlag = ServiceGetAdvertisement;
    [self send:request];
}
 
//获取分类请求接口
/**
 *@params
 **/
- (void)getCategory:(NSDictionary *)params
{
    NSURL *url = [NSURL URLWithString :[NSString stringWithFormat:@"%@/tao800/category.json", UrlBase]];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceGetCategory;
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    /**
    * ASIAskServerIfModifiedWhenStaleCachePolicy
    * 这是ASIDownloadCaches的默认cache策略。使用这个策略时，request会先查看cache中是否有可用的缓存数据。
    * 如果没有，request会像普通request那样工作。
    * 如果有缓存数据并且缓存数据没有过期，那么request会使用缓存的数据，
    * 而且不会向服务器通信。如果缓存数据过期了，request会先进行GET请求来想服务器询问数据是否有新的版本。
    * 如果服务器说缓存的数据就是当前版本，那么缓存数据将被使用，不会下载新数据。
    * 在这种情况下，cache的有效期将被设定为服务器端提供的新的有效期。
    * 如果服务器提供更新的内容，那么新内容会被下载，并且新的数据以及它的有效期将被写入cache。
    */
//    [request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];

    /**
    * 这一项与ASIAskServerIfModifiedWhenStaleCachePolicy相同，
    * 除了一点：request将会每次都询问服务器端数据是否有更新。
    */
    // 每次都向服务器询问是否有新的内容可用，
    // 如果请求失败, 使用cache的数据，即使这个数据已经过期了
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setSecondsToCache:60*60];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setRequestMethod :TBRequestMethodGet];
    
    [self send:request];
}

- (void)getTomorrowAdvert:(NSDictionary *)params {
    NSURL *url = [NSURL URLWithString :[NSString stringWithFormat:@"%@/tao800/prdofrecommend.json", UrlBase]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceGetTomorrowAdvert;
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setSecondsToCache:60*60];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setRequestMethod :TBRequestMethodGet];

    [self send:request];
}

//升级检查接口
/**
 *@params
 **/
- (void)getCheckConfig:(NSDictionary *)params
{
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    NSString *strUrl = [NSString stringWithFormat:@"%@/api/checkconfig/v3?product=%@&platform=%@&trackid=%@&cityid=%@",UrlBase,dm.product,dm.platform,dm.partner,dm.city.cityId];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceGetCheckConfig;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    [self send:request];
}

//获取今日列表页面banner接口
/**
 *@params
 **/
- (void)getTodayListBanner:(NSDictionary *)params
{
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    
    NSMutableString *urlStr = [NSMutableString stringWithCapacity:255];
    [urlStr appendString:UrlBase];
    //[urlStr appendString:@"http://116.255.244.38"];
    [urlStr appendString:@"/tao800/banner.json?platform=iphone"];
    [urlStr appendFormat:@"&cityid=%@",dm.city.cityId];
    [urlStr appendFormat:@"&channelid=%@",dm.partner];
    
    NSString *urlName = [params objectForKey:@"urlName"];
    if (urlName.length > 0) {
        [urlStr appendFormat:@"&url_name=%@",urlName];
    }
    
    NSURL *url = [NSURL URLWithString :urlStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceGetTodayListBanner;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    [self send:request];
}

//获取值得逛页面banner接口
/**
 *@params
 **/
- (void)getShowCheapClassifyBanner:(NSDictionary *)params
{
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];

    NSMutableString *urlStr = [NSMutableString stringWithCapacity:255];
    [urlStr appendString:UrlBase];
    [urlStr appendString:@"/tao800/hotbanner.json?platform=iphone"];
    [urlStr appendFormat:@"&cityid=%@",dm.city.cityId];
    [urlStr appendFormat:@"&channelid=%@",dm.partner];
    NSString *bannerkind = [params objectForKey:@"bannerkind"];
    NSString *pagetype = [NSString stringWithFormat:@"&pagetype=%@",bannerkind];
    [urlStr appendString:pagetype];
    
    
    NSURL *url = [NSURL URLWithString :urlStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceGetShowCheapBanner;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    [self send:request];
}

//获取启动页数据接口
/**
 *@params
 **/
- (void)getStartInfo:(NSDictionary *)params
{
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    
    NSMutableString *urlStr = [NSMutableString stringWithCapacity:255];
    [urlStr appendString:UrlBase];
    [urlStr appendString:@"/tao800/startinfo.json?platform=iphone"];
    [urlStr appendFormat:@"&cityid=%@",dm.city.cityId];
    [urlStr appendFormat:@"&channelid=%@",dm.partner];
    
    // 判断是否是iphone5分辨率
    if (TBIsAfterIphone4()) {
        [urlStr appendString:@"&version=iphone5"];
    }
    
    NSURL *url = [NSURL URLWithString :urlStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceGetStartInfo;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    [self send:request];
}

//获取开卖提醒商品列表接口
/**
 *@params
 **/
- (void)getStartSellRemind:(NSDictionary *)params
{
    NSString *ids = [params objectForKey:@"ids"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/v3/deals?image_type=all&page=1&per_page=100&ids=%@&image_model=webp",UrlBase,ids];
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceGetStartSellRemind;
    [request setRequestMethod :TBRequestMethodGet];
    
    [self send:request];

}

//签到接口
/**
 *@params
 **/
- (void)checkins:(NSDictionary *)params
{
    NSString *checkin = [params objectForKey:@"checkin"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/checkins",UrlBaseNeedLogin];
    
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceCheckins;
    
    [request setPostValue:checkin forKey:@"checkin"];
    [request setPostValue:@"1" forKey:@"check_phone"]; //表示需要检查>30积分（用户当前通过签到获取的积分数）的签到是否有绑定手机
    
    // 统计信息
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    
    NSString *channelString = [NSString stringWithFormat:@"%@|%@|%@|%@|%@",dm.product,[dm getHeaderVo].deviceId,dm.platform,dm.currentVersion,dm.partner];
    [request setPostValue:channelString forKey:@"channel"];

    
    [self send:request];
}

//获取用户签到日期信息列表
/**
 *@params
 **/
- (void)getCheckinsHistory:(NSDictionary *)params
{
    NSString *user_id = [params objectForKey:@"user_id"];
    NSString *query_type = @"add";
    NSString *start_time = [params objectForKey:@"start_date"];
    NSString *end_time = [params objectForKey:@"end_date_date"];
    NSString *page = @"1";
    NSString *per_page = @"40";
    NSString *rule_type = @"sign";
    NSString *product = @"tao800";
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/integral/bill?user_id=%@&query_type=%@&start_time=%@&end_time=%@&page=%@&per_page=%@&rule_type=%@&product=%@",UrlBase,user_id,query_type,start_time,end_time,page,per_page,rule_type,product];
    
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceCheckinsHistory;
    [request setRequestMethod :TBRequestMethodGet];
    
    [self send:request];
}

//用push得到的专题活动id 请求该专题的信息
- (void)getTopicDetailForPush:(NSDictionary *)params {
    NSString *topicId = [params objectForKey:@"topicId"];
    NSString *urlStr = [NSString stringWithFormat:@"http://m.api.tuan800.com/pushv3/topic?topicid=%@", topicId];
    NSURL *url = [NSURL URLWithString:urlStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceGetTopicActivityContent;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    request.serviceData = params;
    [self send:request];
}

#pragma mark 设置重新开团商品的id以及手机设备id接口。
- (void)addOpenGroupRemind:(NSDictionary *)params {
    
    NSString *dealId = [params objectForKey:@"dealId"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/cn/kt/add",UrlBaseNeedLogin];
    
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceAddOpenGroupRemindTag;
    
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    
    NSString *apns =dm.apnsDeviceToken;
    
    [request setPostValue:dealId forKey:@"deal_id"];
    [request setPostValue:@"tao800" forKey:@"product"];
    [request setPostValue:apns forKey:@"device_id"];
    
    [self send:request];
}

#pragma mark 取消设置重新开团商品的id以及手机设备id接口。
- (void)deleteOpenGroupRemind:(NSDictionary *)params {
    
    NSString *ids = [params objectForKey:@"ids"]; // 支持同时取消多个deal_id,多个deal_id之间用逗号分隔。
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/cn/kt/del",UrlBaseNeedLogin];
    
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceDeleteOpenGroupRemindTag;
    
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    
    [request setPostValue:ids forKey:@"deal_id"];
    [request setPostValue:@"tao800" forKey:@"product"];
    [request setPostValue:dm.apnsDeviceToken forKey:@"device_id"];
    
    [self send:request];
}

#pragma mark 订阅统计接口。
- (void)dealSubscibe:(NSDictionary *)params {
    
    NSString *dealId = [params objectForKey:@"dealId"];
    NSString *date = currentDateFormatToStr();
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/cn/deal_subscibe",UrlBase];
    
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceDealSubscibeTag;
    
    [request setPostValue:dealId forKey:@"deal_id"];
    [request setPostValue:date forKey:@"date"];
    
    [self send:request];
}

#pragma mark 获取设备被推荐的淘宝分类id值。
- (void)getRecommendCid:(NSDictionary *)params {
    
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"http://zapi.zhe800.com/v1/cn/get_cid"];
    
    // 获取设备id
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [urlStr appendFormat:@"?device_id=%@",dm.headerVo.deviceId];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceGetRecommendCidTag;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    request.serviceData = params;
    [self send:request];
}

#pragma mark 微信关注接口
- (void)weixinFollowCheck:(NSDictionary *)params {
    
    NSString *urlStr = [NSString stringWithFormat:@"http://m.zhe800.com/hd/wx_follow_check"];
    
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceWeixinFollowCheckTag;
    
    [self send:request];
}

#pragma mark -
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
        case ServiceGetTodayDeals:
        {
            sel = @selector(getTodayDealsFinish:);
            NSMutableArray *arr = [self convertJsonToDeals:dict withServiceTag:request.serviceMethodFlag];
            retObj = [NSMutableDictionary dictionaryWithObject:arr forKey:@"items"];
        }
            break;
        case ServiceGetPreviewDeals:
        {
            sel = @selector(getPreviewDealsFinish:);
            NSArray *arr = [self convertJsonToDeals:dict withServiceTag:request.serviceMethodFlag];
            retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
        }
            break;
        case ServiceGetTomorrowDeals:
        {
            sel = @selector(getTomorrowDealsFinish:);
            NSArray *arr = [self convertJsonToDeals:dict withServiceTag:request.serviceMethodFlag];
            retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
        }
            break;
        case ServiceGetSellingDeals:
        {
            sel = @selector(getSellingDealsFinish:);
            NSDictionary *dic = [self convertJsonToSellDeals:dict withServiceTag:request.serviceMethodFlag];
            retObj = dic;
        }
            break;
        case ServiceGetWillSellDeals:
        {
            sel = @selector(getWillSellDealsFinish:);
            NSDictionary *dic = [self convertJsonToSellDeals:dict withServiceTag:request.serviceMethodFlag];
            retObj = dic;
        }
            break;
        case ServiceGetTopicActivityDeals:
        {
            sel = @selector(getTopicActivityDealsFinish:);
            NSArray *arr = [self convertJsonToDeals:dict withServiceTag:request.serviceMethodFlag];
            retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
        }
            break;
        case ServiceGetTopicActivityContent:
        {
            sel = @selector(getTopicDetailForPushFinish:);
            Tao800AdvertVo *advertVo = [[Tao800AdvertVo alloc] init];
            [self convertJsonToAdvertSingle:dict advert:advertVo];
            retObj = [NSDictionary dictionaryWithObjectsAndKeys:advertVo, @"item", nil];
            TBDPRINT(@"Push到专题页面的retObj========%@",retObj);
        }
            break;
        case ServiceGetDealDetail:
        {
            sel = @selector(getDealDetailFinish:);
            
            NSDictionary *meta = nil;
            NSDictionary *objects = nil;
            if ([dict isKindOfClass:[NSDictionary class]]) {
                meta = dict[@"meta"];
                objects = dict[@"objects"];
            }
            
            if (!objects) {
                objects = dict;
            }
            if (!meta) {
                meta = @{@"has_next" : @(0)};
            }
            
            NSArray *arr = [self convertJsonToDeals:objects withServiceTag:request.serviceMethodFlag];
            retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
        }
            break;
        case ServiceGetAdvertisement:
        {
//            sel = @selector(getAdvertisementFinish:);
//            NSArray *arr = [self convertJsonToAdvertisements:dict];
//            retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
        }
            break;
 
        case ServiceGetCategory:
        {
            sel = @selector(getCategoryFinish:);
            //NSArray *arr = [self convertJsonToCategory:dict];
            NSString *dataStr = [request responseString];
            retObj = [NSDictionary dictionaryWithObject:dataStr forKey:@"dataStr"];
        }
            break;
        case ServiceGetTomorrowAdvert:
        {
//            sel = @selector(getTomorrowAdvertFinish:);
//            NSArray *arr = [self convertJsonToTomorrowAdvertVo:dict];
//            retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
        }
            break;
        case ServiceGetCheckConfig:
        {
            sel = @selector(getCheckConfigFinish:);
            Tao800SoftVo *softVo = [self convertJsonToSoftVo:dict];
            retObj = [NSDictionary dictionaryWithObject:softVo forKey:@"soft"];
        }
            break;
        case ServiceGetTodayListBanner:
        {
            sel = @selector(getTodayListBannerFinish:);
            NSArray *arr = [self convertJsonToTodayListBannerVo:dict];
            retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
        }
            break;
        case ServiceGetShowCheapBanner:
        {
            sel = @selector(getShowCheapClassifyBannerFinish:);
            NSArray *arr = [self convertJsonToTodayListBannerVo:dict];
            retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
        }
            break;
        case ServiceGetStartInfo:
        {
//            sel = @selector(getStartInfoFinish:);
//            NSArray *arr = [self convertJsonToStartInfoVo:dict];
//            retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
        }
            break;
        case ServiceGetStartSellRemind:
        {
            sel = @selector(getStartSellRemindFinish:);
            
            NSDictionary *meta = nil;
            NSDictionary *objects = nil;
            if ([dict isKindOfClass:[NSDictionary class]]) {
                meta = dict[@"meta"];
                objects = dict[@"objects"];
            }
            
            if (!objects) {
                objects = dict;
            }
            if (!meta) {
                meta = @{@"has_next" : @(0)};
            }
            
            NSArray *arr = [self convertJsonToDeals:objects withServiceTag:request.serviceMethodFlag];
            retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
        }
            break;
        case ServiceCheckins:
        {
            sel = @selector(checkinsFinish:);
            retObj = dict;
        }
            break;
        case ServiceCheckinsHistory:
        {
            sel = @selector(checkinsHistoryFinish:);
            retObj = dict;
        }
            break;
        case ServiceSearchDealsTag:
        {
            sel = @selector(searchDealsFinish:);
            NSArray *arr = [self convertJsonToDeals:dict withServiceTag:request.serviceMethodFlag];
            retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
        }
            break;
        case ServiceAddOpenGroupRemindTag:
        {
            sel = @selector(addOpenGroupRemindFinish:);
            retObj = dict;
        }
            break;
        case ServiceDeleteOpenGroupRemindTag:
        {
            sel = @selector(deleteOpenGroupRemindFinish:);
            retObj = dict;
        }
            break;
        case ServiceDealSubscibeTag:
        {
            sel = @selector(dealSubscibeFinish:);
            NSString *dataStr = [request responseString];
            retObj = @{@"status": dataStr};
        }
            break;
        case ServiceGetRecommendCidTag:
        {
            sel = @selector(getRecommendCidFinish:);
            retObj = dict;
        }
            break;
        case ServiceWeixinFollowCheckTag:
        {
            sel = @selector(weixinFollowCheckFinish:);
            retObj = dict;
        }
            break;
        case ServiceQQZoneFollowCheckTag:
        {
            sel = @selector(qqZoneFollowCheckFinish:);
            retObj = dict;
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


-(void)getRemotePushes:(NSDictionary *)params
            completion:(void (^)(NSArray *))completion
                failue:(void (^)(TBErrorDescription *))failure{
    
    NSMutableString * urlString = [NSMutableString stringWithFormat:@"%@/push/ios/tpush?",UrlBase];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800Service *instance = self;
    
    [request setCompletionBlock:^{
        NSArray * responseArray = (NSArray*) [instance getResponseJsonResult:pRequest];
        if (!responseArray) {
            return;
        }
        completion(responseArray);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}


@end
