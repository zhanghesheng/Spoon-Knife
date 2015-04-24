//
//  Tao800WirelessService.m
//  universalT800
//
//  Created by enfeng on 13-10-12.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <TBUI/TBErrorDescription.h>
#import <TBUI/TBUICommon.h>
#import "Tao800WirelessService.h"
#import "Tao800BannerVo.h"
#import "Tao800ActivityVo.h"
#import "Tao800DealVo.h"
#import "TBCore/TBCore.h"
#import "Tao800SoftVo.h"
#import "Tao800ConfigTipBVO.h"
#import "Tao800ConfigBVO.h"
#import "Tao800StartInfoVo.h"
#import "Tao800ActivityVo.h"
#import "Tao800PromotionEntranceVo.h"
#import "Tao800PromotionEntranceItem.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800CheckConfigTaoBaoSwitchBVO.h"
#import "Tao800SaunterVo.h"
#import "Tao800ShareSocialBVO.h"

#ifdef DEBUG
NSString *const baseUrl = @"http://m.api.xiongmaoz.com";
NSString *const WrdUrlBase = @"http://m.api.xiongmaoz.com";
NSString *const hotBannerUrl = @"http://m.api.xiongmaoz.com";
NSString *const promtionBannerUrl = @"http://m.api.xiongmaoz.com";
//NSString *const appBaseUrl = @"http://192.168.3.151:5678";
NSString *const appBaseUrl = @"http://m.api.zhe800.com";
#else
NSString *const baseUrl = @"http://m.api.zhe800.com";
NSString *const WrdUrlBase = @"http://m.api.zhe800.com";
NSString *const hotBannerUrl = @"http://m.api.zhe800.com";
NSString *const promtionBannerUrl = @"http://m.api.zhe800.com";
NSString *const appBaseUrl = @"http://m.api.zhe800.com";
#endif

@interface Tao800WirelessService ()
- (NSArray *)wrapperStartInfoVo:(NSDictionary *)dict;
@end

@implementation Tao800WirelessService

- (NSArray *)wrapperBanners:(NSDictionary *)dict {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[dict count]];
    
    for (NSDictionary *item in dict) {
        
        Tao800BannerVo *vo = [[Tao800BannerVo alloc] init];
        vo.bannerId = [item objectForKey:@"id" convertNSNullToNil:YES];
        vo.bannerType = [item objectForKey:@"banner_type" convertNSNullToNil:YES];
        vo.title = [item objectForKey:@"title" convertNSNullToNil:YES];
        vo.value = [item objectForKey:@"value" convertNSNullToNil:YES];
        vo.dealUrl = [item objectForKey:@"deal_url" convertNSNullToNil:YES];
        vo.wapUrl = [item objectForKey:@"wap_url" convertNSNullToNil:YES];
        vo.bigImageUrl = [item objectForKey:@"image_largest_ios_url" convertNSNullToNil:YES];
        vo.imageBigUrl = [item objectForKey:@"image_big_ios_url" convertNSNullToNil:YES];
        vo.normalImageUrl = [item objectForKey:@"image_middle_ios_url" convertNSNullToNil:YES];
        vo.smallImageUrl = [item objectForKey:@"image_little_ios_url" convertNSNullToNil:YES];
        vo.show_model = [[item objectForKey:@"show_model" convertNSNullToNil:YES] boolValue];
        vo.detailString = [item objectForKey:@"detail" convertNSNullToNil:YES];
        vo.dealParams = [item objectForKey:@"deal_params" convertNSNullToNil:YES];
        
        vo.parentUrlName = [item objectForKey:@"parent_url_name" convertNSNullToNil:YES];
        vo.checkInPageImageUrl =  [item objectForKey:@"image_registration_ios_url" convertNSNullToNil:YES];
        // 判断是否有子专题
        NSArray *childTopics = [item objectForKey:@"child_topics" convertNSNullToNil:YES];
        if (childTopics && childTopics.count > 0) {
            NSMutableArray *childTopicsResult = [NSMutableArray arrayWithCapacity:childTopics.count];
            for (NSDictionary *topicDic in childTopics) {
                
                Tao800ActivityVo *activityVo = [[Tao800ActivityVo alloc] init];
                activityVo.bannerType = [topicDic objectForKey:@"banner_type" convertNSNullToNil:YES];
                activityVo.mImageUrl = [topicDic objectForKey:@"image_ios_url" convertNSNullToNil:YES];
                activityVo.title = [topicDic objectForKey:@"title" convertNSNullToNil:YES];
                activityVo.value = [topicDic objectForKey:@"value" convertNSNullToNil:YES];
                [childTopicsResult addObject:activityVo];
            }
            vo.childTopics = childTopicsResult;
        }
        
        [vo resetNullProperty];
        [arr addObject:vo];
    }
    
    return arr;
}

//大促数据封装
- (NSArray *)wrapperPromotion:(NSDictionary *)dict {
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:2];
    for (NSDictionary *proDic in dict) {
        Tao800PromotionEntranceVo *dealVo = [[Tao800PromotionEntranceVo alloc] init];
        dealVo.bannerType = [proDic objectForKey:@"banner_type" convertNSNullToNil:YES];
        dealVo.detail = [proDic objectForKey:@"detail" convertNSNullToNil:YES];
        dealVo.idString = [proDic objectForKey:@"id" convertNSNullToNil:YES];
        dealVo.imgUrl = [proDic objectForKey:@"image_ios_url" convertNSNullToNil:YES];
        dealVo.imgGifUrl = [proDic objectForKey:@"image_middle_url" convertNSNullToNil:YES];
        dealVo.showModel = [proDic objectForKey:@"show_model" convertNSNullToNil:YES];
        dealVo.title = [proDic objectForKey:@"title" convertNSNullToNil:YES];
        dealVo.value = [proDic objectForKey:@"value" convertNSNullToNil:YES];
        dealVo.wapUrl = [proDic objectForKey:@"wap_url" convertNSNullToNil:YES];
        dealVo.dealParams = [proDic objectForKey:@"deal_params" convertNSNullToNil:YES];
        [dealVo resetNullProperty];
        
        Tao800PromotionEntranceItem *item = [[Tao800PromotionEntranceItem alloc] init];
        item.dealVo = dealVo;
        
        [arr addObject:item];
    }
    return arr;
}

- (NSArray *)wrapperSaunterCategory:(NSDictionary *)dict {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[dict count]];
    for (NSDictionary *item in dict) {
        Tao800SaunterVo *vo = [[Tao800SaunterVo alloc] init];
        vo.name = [item objectForKey:@"category_name" convertNSNullToNil:YES];
        vo.tagId = [item objectForKey:@"id" convertNSNullToNil:YES];
        vo.desc = [item objectForKey:@"category_desc" convertNSNullToNil:YES];
        vo.urlName = [item objectForKey:@"url_name" convertNSNullToNil:YES];
        [vo resetNullProperty];
        [arr addObject:vo];
    }
    return arr;
}

- (NSArray *)wrapperHotActivityList:(NSDictionary *)dict {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[dict count]];
    @try {
        for (NSDictionary *item in dict) {
            
            Tao800ActivityVo *vo = [[Tao800ActivityVo alloc] init];
            vo.bannerType = [item objectForKey:@"banner_type" convertNSNullToNil:YES];
            vo.dealUrl = [item objectForKey:@"deal_url" convertNSNullToNil:YES];
            vo.activityId = [item objectForKey:@"id" convertNSNullToNil:YES];
            vo.lImageUrl = [item objectForKey:@"image_little_ios_url" convertNSNullToNil:YES];
            vo.mImageUrl = [item objectForKey:@"image_middle_ios_url2" convertNSNullToNil:YES];
            vo.sImageUrl = [item objectForKey:@"image_little_ios_url" convertNSNullToNil:YES];
            vo.title = [item objectForKey:@"title" convertNSNullToNil:YES];
            vo.value = [item objectForKey:@"value" convertNSNullToNil:YES];
            vo.status = [[item objectForKey:@"status" convertNSNullToNil:YES] intValue];
            vo.wapUrl = [item objectForKey:@"wap_url" convertNSNullToNil:YES];
            vo.show_model = [[item objectForKey:@"show_model" convertNSNullToNil:YES] boolValue];
            vo.detailString = [item objectForKey:@"detail" convertNSNullToNil:YES];
            vo.ext = [item objectForKey:@"ext" convertNSNullToNil:YES];
            vo.urlName = [item objectForKey:@"url_name" convertNSNullToNil:YES];
            vo.dealParams = [item objectForKey:@"deal_params" convertNSNullToNil:YES];
            
            [vo resetNullProperty];
            
            [arr addObject:vo];
        }
        
    } @catch (NSException *e) {
        TBDPRINT(@"convertJsonToActivity 字符串 转换 数字错误");
    }
    return arr;
}

- (Tao800ConfigBVO *)wrapperConfigBVO:(NSDictionary *)dict {
    //解析软件升级
    NSDictionary *softDict = [dict objectForKey:@"soft" convertNSNullToNil:YES];
    Tao800SoftVo *softVo = [[Tao800SoftVo alloc] init];
    softVo.url = [softDict objectForKey:@"url" convertNSNullToNil:YES];
    softVo.minVersion = [softDict objectForKey:@"min_version" convertNSNullToNil:YES];
    softVo.version = [softDict objectForKey:@"version" convertNSNullToNil:YES];
    softVo.mustUpdate = [[softDict objectForKey:@"must-update" convertNSNullToNil:YES] boolValue];
    softVo.softDescription = [softDict objectForKey:@"description" convertNSNullToNil:YES];
    softVo.minimumSystemVersion = [softDict objectForKey:@"minimum_system_version" convertNSNullToNil:YES];
    [softVo resetNullProperty];
    
    Tao800ConfigBVO *configBVO = [[Tao800ConfigBVO alloc] init];
    Tao800ConfigTipBVO *tipBVO = [[Tao800ConfigTipBVO alloc] init];
    
    configBVO.softVo = softVo;
    configBVO.configTipBVO = tipBVO;
    
    //解析tips
    NSArray *tips = [dict objectForKey:@"tips" convertNSNullToNil:YES];
    for (int iTemp = 0; iTemp < tips.count; iTemp++) {
        NSDictionary *dic = [tips objectAtIndex:iTemp];
        if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.closelogin.url"]) {
            NSString *tao800CloseLoginUrl = [dic objectForKey:@"content" convertNSNullToNil:YES];
            if (tao800CloseLoginUrl != nil && ![tao800CloseLoginUrl isEqualToString:@""]) {
                tipBVO.tao800CloseLoginUrl = tao800CloseLoginUrl;
            }
        } else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.out.protocol"]) {
            NSString *content = [dic objectForKey:@"content" convertNSNullToNil:YES];
            if (content != nil && ![content isEqualToString:@""]) {
                
                NSArray *contentArray = [content componentsSeparatedByString:@","];
                NSMutableDictionary *result = [NSMutableDictionary dictionary];
                
                for (int i = 0; i < contentArray.count; i++) {
                    [result setObject:[NSNumber numberWithBool:YES] forKey:[contentArray objectAtIndex:i]];
                }
                
                tipBVO.tao800OutProtocol = result;
            }
        } else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.out.close"]) {
            NSString *content = [dic objectForKey:@"content"];
            
            if (content != nil && ![content isEqualToString:@""]) {
                if ([content isEqualToString:@"0"]) { // 0代表开启白名单功能 1代表关闭
                    tipBVO.tao800OutClose = YES;
                } else {
                    tipBVO.tao800OutClose = NO;
                }
            } else {
                tipBVO.tao800OutClose = NO;
            }
        } else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.deals.comingsoon"]) {
            NSString *content = [dic objectForKey:@"content"];
            
            if (content != nil && [content isEqualToString:@"true"]) {
                tipBVO.isShowPreviewDealButton = YES;
            } else {
                tipBVO.isShowPreviewDealButton = NO;
            }
        } else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.deals.begintime"]) {
            NSString *content = [dic objectForKey:@"content"];
            
            if (content != nil && ![content isEqualToString:@""]) {
                tipBVO.showPreviewDealTime = content;
            }
        } else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.weixin.score"]) {
            NSString *content = [dic objectForKey:@"content"];
            
            if (content != nil && ![content isEqualToString:@""]) {
                tipBVO.weixinScore = content;
            }
        }
        else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.rechargelottery.switch"]) {
            NSString *content = [dic objectForKey:@"content"];
            
            if (content != nil && ![content isEqualToString:@""]) {
                tipBVO.isShowPhoneRechargeButton = content;
            }
        } else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.firstorder.rebate"]) {
            NSString *content = [dic objectForKey:@"content"];
            if (content != nil && ![content isEqualToString:@""]) {
                if ([content isEqualToString:@"true"]) {
                    tipBVO.showFirstOrderEntry = YES;
                } else {
                    tipBVO.showFirstOrderEntry = NO;
                }
            } else {
                tipBVO.showFirstOrderEntry = NO;
            }
        } else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.firstorder.rebate.url"]) {
            NSString *content = [dic objectForKey:@"content"];
            tipBVO.firstOrderUrl = nil;
            if (content != nil && ![content isEqualToString:@""]) {
                tipBVO.firstOrderUrl = content;
            }
        } else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.qq.score"]) {
            NSString *content = [dic objectForKey:@"content"];
            
            if (content != nil && ![content isEqualToString:@""]) {
                tipBVO.qqScore = content;
            }
        } else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.weixin.concern"]) {
            NSString *content = [dic objectForKey:@"content"];
            if (content != nil && ![content isEqualToString:@""]) {
                if ([content isEqualToString:@"true"]) {
                    tipBVO.weixinConcernSwitch = YES;
                } else {
                    tipBVO.weixinConcernSwitch = NO;
                }
            } else {
                tipBVO.weixinConcernSwitch = NO;
            }
        } else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.image.statistics"]) {
            NSString *content = [dic objectForKey:@"content"];
            if (content != nil && ![content isEqualToString:@""]) {
                if ([content isEqualToString:@"true"]) {
                    tipBVO.baoguangSwitch = YES;
                } else {
                    tipBVO.baoguangSwitch = NO;
                }
            }
        } else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.signin.tips"]) {
            NSString *content = [dic objectForKey:@"content"];
            if (content != nil && ![content isEqualToString:@""]) {
                tipBVO.checkInRules = content;
            }
        } else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.invite.jifen"]) {
            NSString *content = [dic objectForKey:@"content"];
            if (content != nil && ![content isEqualToString:@""]) {
                tipBVO.inviteFriendsScoreReward = content;
            }
        } else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.deals.user.define.url"]) {
            NSString *content = [dic objectForKey:@"content"];
            if (content != nil && ![content isEqualToString:@""]) {
                if ([content isEqualToString:@"true"]) {
                    tipBVO.isUserDefineUrl = YES;
                } else {
                    tipBVO.isUserDefineUrl = NO;
                }
            } else {
                tipBVO.isUserDefineUrl = NO;
            }
        } else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.shangcheng.checkconfig"]) {
            NSString *dataStr = [dic objectForKey:@"content"];
            NSDictionary *content = [dataStr JSONValue];
            Tao800CheckConfigTaoBaoSwitchBVO *taoBaoSwitchBVO =
            [Tao800CheckConfigTaoBaoSwitchBVO convertTao800CheckConfigTaoBaoSwitchBVO:content];
            configBVO.taoBaoSwitchBVO = taoBaoSwitchBVO;
        } else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.push.url"]) {
            NSString *content = [dic objectForKey:@"content"];
            if (content != nil && ![content isEqualToString:@""]) {
                tipBVO.pushToShareUrl = content;
            } else {
            }
        } else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.push.switch"]) {
            NSString *content = [dic objectForKey:@"content"];
            if (content != nil && ![content isEqualToString:@""]) {
                if ([content isEqualToString:@"true"]) {
                    tipBVO.pushToShareSwitchIsOnOrOff = YES;
                } else {
                    tipBVO.pushToShareSwitchIsOnOrOff = NO;
                }
            }
        }else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.im.switch.new"]) {
            NSString *content= [dic objectForKey:@"content"];
            if (content!=nil && ![content isEqualToString:@""]) {
                if ([content isEqualToString:@"1"]) {
                    tipBVO.isDisplayIMSwitch = YES;
                }else{
                    tipBVO.isDisplayIMSwitch = NO;
                }
            }else{
                tipBVO.isDisplayIMSwitch = NO;
            }
        } else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.clear.cookie"]) {
            NSString *content = [dic objectForKey:@"content"];
            
            if (content != nil && [content isEqualToString:@"true"]) {
                tipBVO.isClearTaobaoCookie = YES;
            } else {
                tipBVO.isClearTaobaoCookie = NO;
            }
        } else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.switch.taobao.login"]) {
            NSNumber *content = [dic objectForKey:@"content"];
            tipBVO.tao800SwitchTaobaoLogin = [content boolValue];
            
        } else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.ios.cpa.number"]){
            int count = [[dic objectForKey:@"content"] intValue];
            tipBVO.cpaOutNumber = count;
        } else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.switch.taobao.tianmao.sale"]) {
            NSNumber *content = [dic objectForKey:@"content"];
            //取值范围：1--打开；0--关闭（不做销量显示的控制）
            tipBVO.enableDisplayTaobaoSaleCount = ![content boolValue];
        }else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.hitegg.switch"]) { //砸蛋开关
            NSString *content = [dic objectForKey:@"content"];
            //取值范围：1--打开；0--关闭
            tipBVO.hitEggEntry = [content boolValue];
        }else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.gift.switch"]) { //送礼开关
            NSString *content = [dic objectForKey:@"content"];
            //取值范围：1--打开；0--关闭
            tipBVO.displayGiftEntry = [content boolValue];
        }else if ([[dic objectForKey:@"key"] isEqualToString:@"tao800.invitefriends.switch"]){
            NSString *content = [dic objectForKey:@"content"];
            //取值范围：1--打开；0--关闭（默认打开）
            tipBVO.displayInvitation = [content boolValue];
        }
    }
    
    return configBVO;
}

//获取大促信息
- (void)getPromotionItem:(NSDictionary *)paramsExt
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/tao800/salebanner.json", promtionBannerUrl]; // hotBannerUrl
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    [params setValue:@"iphone" forKey:@"platform"];
    
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800WirelessService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSArray *arr = [instance wrapperPromotion:dict];
        NSDictionary *retDict = @{@"items" : arr};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getZaoJiuWanBa:(NSDictionary *)paramsExt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure {
    
#if DEBUG
    //    NSString *urlString = [NSString stringWithFormat:@"%@/v3/deals/count/zaojiuwanba", @"http://192.168.1.36:8100"]; // hotBannerUrl
    NSString *urlString = [NSString stringWithFormat:@"%@/v3/deals/count/zaojiuwanba", @"http://m.api.xiongmaoz.com"];
#else
    NSString *urlString = [NSString stringWithFormat:@"%@/v3/deals/count/zaojiuwanba", WrdUrlBase]; // hotBannerUrl
#endif
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    
    // [params setValue:@"webp" forKey:@"image_model"];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800WirelessService *instance = self;
    
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


- (void)getBanners:(NSDictionary *)paramsExt
        completion:(void (^)(NSDictionary *))completion
           failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/tao800/bannerv2.json", hotBannerUrl]; // hotBannerUrl
    // 注:获取广告活动信息列表V2。3.4及以上版本用此接口
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    [params setValue:@"iphone" forKey:@"platform"];
    [params setValue:@"webp" forKey:@"image_model"];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800WirelessService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        NSArray *banners = [instance wrapperBanners:dict];
        NSDictionary *retDict = @{@"items" : banners};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getSaunterCategory:(NSDictionary *)paramsExt
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v2/guang/tags", baseUrl];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:paramsExt];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800WirelessService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        NSArray *worthVisitingListArray = [instance wrapperSaunterCategory:dict];
        NSDictionary *retDict = @{@"items" : worthVisitingListArray};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getHotActivityList:(NSDictionary *)paramsExt
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/tao800/hotbanner.json", hotBannerUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    [params setValue:@"webp" forKey:@"image_model"];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800WirelessService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        NSArray *worthVisitingListArray = [instance wrapperHotActivityList:dict];
        NSDictionary *retDict = @{@"items" : worthVisitingListArray};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
    
}

- (void)getConfigs:(NSDictionary *)paramsExt
       completioin:(void (^)(NSDictionary *))completion
            failue:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/checkconfig/v3", WrdUrlBase];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    [params setValue:@"webp" forKey:@"imgModel"];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    //    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    //    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
    ////    [request setSecondsToCache:60*60*24];
    //    [request setSecondsToCache:60];
    //    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    //    [request setRequestMethod :TBRequestMethodGet];
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800WirelessService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        Tao800ConfigBVO *bvo = nil;
        @try {
            bvo = [instance wrapperConfigBVO:dict];
        } @catch (NSException *e) {
            ASIDownloadCache *sharedCache = [ASIDownloadCache sharedCache];
            [sharedCache removeCachedDataForURL:pRequest.url];
            //            [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        }
        if (!bvo) {
            bvo = [[Tao800ConfigBVO alloc] init];
        }
        
        NSDictionary *retDict = @{@"item" : bvo};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getNewConfigs:(NSDictionary *)paramsExt
          completioin:(void (^)(NSDictionary *))completion
               failue:(void (^)(TBErrorDescription *))failure{
    //appBaseUrl
    NSString *urlString = [NSString stringWithFormat:@"%@/config/switch", appBaseUrl];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800WirelessService *instance = self;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    
    [request setCompletionBlock:^{
        NSArray *array = (NSArray *)[instance getResponseJsonResult:pRequest];
        
        if (!array || array.count == 0) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            dm.enableShowCustomServerIMPage = NO;
            return;
        }
        NSDictionary *dict = [array objectAtIndex:0];
        NSString *content = dict[@"content"];
        
        if ([content isEqualToString:@"1"]) {
            dm.enableShowCustomServerIMPage = YES;
        }else{
            dm.enableShowCustomServerIMPage = NO;
        }
        
        completion(nil);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
    
}

- (void)getTaoBaoURLFilterStrategy:(NSDictionary *)paramsExt
                       completioin:(void (^)(NSDictionary *))completion
                            failue:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/tao800/clientcontrol/iphone/1/client.json", WrdUrlBase];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:paramsExt];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800WirelessService *instance = self;
    
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

- (NSArray *)wrapperStartInfoVo:(NSDictionary *)dict {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[dict count]];
    
    for (NSDictionary *item in dict) {
        
        Tao800StartInfoVo *vo = [[Tao800StartInfoVo alloc] init];
        vo.bannerId = [item objectForKey:@"id"];
        vo.type = [item objectForKey:@"type"];
        vo.title = [item objectForKey:@"title"];
        vo.value = [item objectForKey:@"value"];
        vo.dealUrl = [item objectForKey:@"deal_url"];
        vo.wapUrl = [item objectForKey:@"wap_url"];
        vo.bigImageUrl = [item objectForKey:@"image_largest_ios_url"];
        vo.normalImageUrl = [item objectForKey:@"image_middle_ios_url"];
        vo.smallImageUrl = [item objectForKey:@"image_little_ios_url"];
        vo.updateTime = [item objectForKey:@"update_time"];
        vo.beginTime = [item objectForKey:@"begin_time"];
        vo.expireTime = [item objectForKey:@"expire_time"];
        vo.detail = [item objectForKey:@"detail"];
        vo.show_model = [[item objectForKey:@"show_model"] boolValue];
        [vo resetNullProperty];
        [arr addObject:vo];
    }
    
    return arr;
}

- (void)getBannersOfStart:(NSDictionary *)paramsExt
              completioin:(void (^)(NSDictionary *))completion
                   failue:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/tao800/startinfo.json", hotBannerUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    
    // 判断是否是iphone5分辨率
    if (TBIsAfterIphone4()) {
        [params setValue:@"iphone5" forKey:@"version"];
    }
    [params setValue:@"webp" forKey:@"image_model"];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800WirelessService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        NSArray *array = [instance wrapperStartInfoVo:dict];
        NSDictionary *retDict = @{@"items" : array};
        completion(retDict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getCheckInRules:(NSDictionary *)paramsExt
             completion:(void (^)(NSDictionary *))completion
                 failue:(void (^)(TBErrorDescription *))failure {
    NSString *ruletype = [paramsExt objectForKey:@"ruletype"]; // 0--积分兑换，1--抽奖，2--签到
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/tao800/ruledesc.json?ruletype=%@", UrlBase, ruletype]];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceGetRuleTag;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800WirelessService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dic = [instance getResponseJsonResult:pRequest];
        if (!dic) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        completion(dic);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)uploadWishWord:(NSDictionary *)paramsExt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure {
    Tao800DataModelSingleton *da = [Tao800DataModelSingleton sharedInstance];
    NSString *timeStr = [self getShortDateString];
    NSString *deviceId = da.macAddress;
    NSString *userId = @"";
    if (da.user && da.user.userId) {
        userId = da.user.userId;
    }
    UIDevice *device = [UIDevice currentDevice];
    NSString *platform = [device model];
    NSString *version = da.currentVersion;
    NSString *wishWord = [paramsExt objectForKey:@"wishWord"];
    
    //|许愿时间|设备号|userid|平台|版本|心愿单内容 例如：|2014-04-23|device_id|1234556|iphone|3.1.0|男装
    NSString *urlStr = [NSString stringWithFormat:@"%@/tao800/wishlist?wish=|%@|%@|%@|%@|%@|%@",
                        UrlBase, timeStr, deviceId, userId, platform, version, wishWord];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceUploadWishListTag;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800WirelessService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dic = [instance getResponseJsonResult:pRequest];
        if (!dic) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        completion(dic);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (NSString *)getShortDateString {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [dateFormatter stringFromDate:date];
    
    return timeStr;
}


- (void)testSSOZhe800:(NSDictionary *)paramsExt
           completion:(void (^)(NSDictionary *))completion
               failue:(void (^)(TBErrorDescription *))failure {
    NSURL *url = [NSURL URLWithString:@"https://sso.zhe800.com/m/login?ticket=tzga7phqqq7brzreqije"];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceGetRuleTag;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    NSData *cerFile1 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"go_daddy_1a" ofType:@"der"]];
    NSData *cerFile2 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"go_daddy_1b" ofType:@"der"]];
    NSData *cerFile3 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"go_daddy_2a" ofType:@"der"]];
    NSData *cerFile4 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"go_daddy_2b" ofType:@"der"]];
    
    SecCertificateRef cert1 = SecCertificateCreateWithData(NULL, (__bridge CFDataRef) cerFile1);
    SecCertificateRef cert2 = SecCertificateCreateWithData(NULL, (__bridge CFDataRef) cerFile2);
    SecCertificateRef cert3 = SecCertificateCreateWithData(NULL, (__bridge CFDataRef) cerFile3);
    SecCertificateRef cert4 = SecCertificateCreateWithData(NULL, (__bridge CFDataRef) cerFile4);
    
    NSArray *array = [NSArray arrayWithObjects:
                      (__bridge id) cert1,
                      (__bridge id) cert2,
                      (__bridge id) cert3,
                      (__bridge id) cert4,
                      
                      nil];
    
    [request setClientCertificates:array];
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800WirelessService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dic = [instance getResponseJsonResult:pRequest];
        if (!dic) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        completion(dic);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getIpAddress:(NSDictionary *)params
          completion:(void (^)(NSDictionary *resultDic))completion
             failure:(void (^)(TBErrorDescription *error))failure {
    
    NSString *urlString = @"http://nc.zhe800.com/get_remote_addr";
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:TBRequestMethodGet];
    __weak Tao800WirelessService *instance = self;
    __weak TBASIFormDataRequest *theRequest = request;
    
    [theRequest setCompletionBlock:^{
        BOOL isError = [instance isResponseDidNetworkError:theRequest];
        if (isError) {
            failure(nil);
            return;
        }
        NSString *ipAddress = theRequest.responseString;
        ipAddress = [ipAddress trim];
        completion(@{@"ipAddress" : ipAddress});
    }];
    
    [theRequest setFailedBlock:^{
        failure(nil);
    }];
    
    [self send:theRequest];
}

- (void)getSocialShareContent:(NSDictionary *)params
                   completion:(void (^)(NSDictionary *resultDic))completion
                      failure:(void (^)(TBErrorDescription *error))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/socialshare/content", UrlBase];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:TBRequestMethodGet];
    __weak Tao800WirelessService *instance = self;
    __weak TBASIFormDataRequest *theRequest = request;
    
    [theRequest setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:theRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:theRequest];
            failure(tbd);
            return;
        }
        Tao800ShareSocialBVO *shareSocialBVO = [Tao800ShareSocialBVO wrapperShareSocialBVO:dict];
        
        completion(@{@"item" : shareSocialBVO});
        
    }];
    
    [theRequest setFailedBlock:^{
        failure(nil);
    }];
    
    [self send:theRequest];
}

- (void)uploadErrorInfo:(NSDictionary *)paramsExt
             completion:(void (^)(NSDictionary *))completion
                failure:(void (^)(TBErrorDescription *))failure{
    NSString *errorInfoUrl = @"http://m.api.tuan800.com/mobilelog/errorlog/ios";
    NSURL *url = [NSURL URLWithString:errorInfoUrl];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:TBRequestMethodPost];
    __weak Tao800WirelessService *instance = self;
    __weak TBASIFormDataRequest *theRequest = request;
    
    [self wrapperPostRequest:paramsExt request:request];
    
    [theRequest setCompletionBlock:^{
        BOOL isError = [instance isResponseDidNetworkError:theRequest];
        if (isError) {
            failure(nil);
            return;
        }
        completion(nil);
    }];
    
    [theRequest setFailedBlock:^{
        failure(nil);
    }];
    
    [self send:theRequest];
    
}

-(void)getVirtualFittingEntrance:(NSDictionary *)params
                      completion:(void (^)(NSDictionary *))completion
                         failure:(void (^)(TBErrorDescription *))failue{
    
    //    NSString *urlString = [NSString stringWithFormat:@"http://m.api.xiongmaoz.com/dressroom/banner"];
    NSString *urlString = [NSString stringWithFormat:@"%@/dressroom/banner", UrlBase];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    //NSURL *url = [NSURL URLWithString:urlString];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:TBRequestMethodGet];
    __weak Tao800WirelessService *instance = self;
    __weak TBASIFormDataRequest *theRequest = request;
    
    [theRequest setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:theRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:theRequest];
            failue(tbd);
            return;
        }
        
        NSArray *banners = [instance wrapperVirtualFittingEntrance:dict];
        NSDictionary *retDict = @{@"items" : banners,@"dic":dict};
        completion(retDict);
    }];
    
    [theRequest setFailedBlock:^{
        failue(nil);
    }];
    
    [self send:theRequest];
}

- (NSArray *)wrapperVirtualFittingEntrance:(NSDictionary *)dict {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[dict count]];
    
    Tao800BannerVo *vo = [[Tao800BannerVo alloc] init];
    vo.bannerId = [NSNumber numberWithInt:[[dict objectForKey:@"id" convertNSNullToNil:YES] intValue]];
    vo.title = [dict objectForKey:@"name" convertNSNullToNil:YES];
    vo.imageBigUrl = [dict objectForKey:@"image_ios_url" convertNSNullToNil:YES];
    
    [vo resetNullProperty];
    [arr addObject:vo];
    return arr;
}
@end
