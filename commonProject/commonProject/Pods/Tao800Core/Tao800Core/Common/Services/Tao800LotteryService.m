//
//  Tao800LotteryService.m
//  tao800
//
//  Created by LeAustinHan on 14-10-11.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800LotteryService.h"
#import "Tao800BannerVo.h"
#import "TBCore/NSDictionaryAdditions.h"
#import <Foundation/Foundation.h>
#import <TBCore/NSString+Addition.h>

#if DEBUG
#else
#endif

@implementation Tao800LotteryService

- (void)getLotteryEntrance:(NSDictionary *)paramsExt
                complation:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/lottery/zero",UrlBase];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlStr params:paramsExt];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.requestMethod = TBRequestMethodGet;
    request.serviceMethodFlag = ServiceLotteryEntranceTag;
    
    __weak Tao800LotteryService *instance = self;
    __weak ASIFormDataRequest *pRequest = request;
    
    [request setCompletionBlock:^{
        NSDictionary *dic = [instance getResponseJsonResult:pRequest];
        if (!dic) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        NSArray *banners = [instance wrapperLotteryEntrance:dic];
        NSDictionary *retDict = @{@"items" : banners,@"dic":dic};
        completion(retDict);
        
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
    
}

- (NSArray *)wrapperLotteryEntrance:(NSDictionary *)dict {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[dict count]];
    
    Tao800BannerVo *vo = [[Tao800BannerVo alloc] init];
    vo.bannerId = [NSNumber numberWithInt:[[dict objectForKey:@"id" convertNSNullToNil:YES] intValue]];
    vo.value = [dict objectForKey:@"value" convertNSNullToNil:YES];
    vo.imageBigUrl = [dict objectForKey:@"image_ios_url" convertNSNullToNil:YES];
        
    [vo resetNullProperty];
    [arr addObject:vo];
    return arr;
}


- (void)getLotteryDetail:(NSDictionary *)paramsExt
              complation:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@/lottery/v2",UrlBase];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlStr params:paramsExt];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.requestMethod = TBRequestMethodGet;
    request.serviceMethodFlag = ServiceLotteryEntranceTag;
    [request setUseCookiePersistence:YES];
    
    __weak Tao800LotteryService *instance = self;
    __weak ASIFormDataRequest *pRequest = request;
    
    
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

//下期预告
- (void)getLotteryDetailByNoticeChengDu:(NSDictionary *)paramsExt
                             complation:(void (^)(NSDictionary *))completion
                                failure:(void (^)(TBErrorDescription *))failure{
    NSString *urlStr = [[NSString stringWithFormat:@"%@/cn/inner/lottery/comming",UrlBaseNeedLogin] urlEncoded];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.requestMethod = TBRequestMethodGet;
    //request.serviceMethodFlag = ServiceLotteryEntranceTag;
    [request setUseCookiePersistence:YES];
    
    __weak Tao800LotteryService *instance = self;
    __weak ASIFormDataRequest *pRequest = request;
    
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

//本期活动
- (void)getLotteryDetailByCurrentLotteryChengDu:(NSDictionary *)paramsExt
                                     complation:(void (^)(NSDictionary *))completion
                                        failure:(void (^)(TBErrorDescription *))failure{
    NSString *urlStr = [[NSString stringWithFormat:@"%@/cn/inner/lottery/processing",UrlBaseNeedLogin] urlEncoded];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.requestMethod = TBRequestMethodGet;
    //request.serviceMethodFlag = ServiceLotteryEntranceTag;
    [request setUseCookiePersistence:YES];

    __weak Tao800LotteryService *instance = self;
    __weak ASIFormDataRequest *pRequest = request;
    
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

- (void)getLotteryDetailByLotteryIdChengDu:(NSDictionary *)paramsExt
                                complation:(void (^)(NSDictionary *))completion
                                   failure:(void (^)(TBErrorDescription *))failure{
    NSString* lotteryId = @"";
    if (paramsExt) {
        lotteryId = [paramsExt objectForKey:@"id"];
    }
    NSString *urlStr = [[NSString stringWithFormat:@"%@/cn/inner/lottery/%@/detail",UrlBaseNeedLogin,lotteryId] urlEncoded];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.requestMethod = TBRequestMethodGet;
    //request.serviceMethodFlag = ServiceLotteryEntranceTag;
    [request setUseCookiePersistence:YES];
    
    __weak Tao800LotteryService *instance = self;
    __weak ASIFormDataRequest *pRequest = request;
    
    
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


- (void)getLotteryResultChengDu:(NSDictionary *)paramsExt
                     complation:(void (^)(NSDictionary *))completion
                        failure:(void (^)(TBErrorDescription *))failure{
    NSString* lotteryId = @"";
    if (paramsExt) {
        lotteryId = [paramsExt objectForKey:@"id"];
    }
    
    NSString *urlStr = [[NSString stringWithFormat:@"%@/cn/inner/lottery/%@",UrlBaseNeedLogin,lotteryId] urlEncoded];
    NSURL *url = [NSURL URLWithString:urlStr];
    //NSURL *url = [self wrapperUrlForRequestMethodGet:urlStr params:paramsExt];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    //[request setShouldContinueWhenAppEntersBackground:self.enableExecuteInBackground];
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;
    [request setUseCookiePersistence:YES];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    [params removeObjectForKey:@"id"];
    [self wrapperPostRequest:params request:request];
    
    __weak Tao800LotteryService *instance = self;
    __weak ASIFormDataRequest *pRequest = request;
    
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

- (void)getLotteryGetEverydayChengDu:(NSDictionary *)paramsExt
                          complation:(void (^)(NSDictionary *))completion
                             failure:(void (^)(TBErrorDescription *))failure{
    NSString* lotteryId = @"";
    if (paramsExt) {
        lotteryId = [paramsExt objectForKey:@"id"];
    }
    NSString *urlStr = [[NSString stringWithFormat:@"%@/cn/inner/lottery/%@/dayget",UrlBaseNeedLogin,lotteryId] urlEncoded];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.requestMethod = TBRequestMethodGet;
    //request.serviceMethodFlag = ServiceLotteryEntranceTag;
    [request setUseCookiePersistence:YES];
    
    __weak Tao800LotteryService *instance = self;
    __weak ASIFormDataRequest *pRequest = request;
    
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

- (void)getLotteryShareFirstChengDu:(NSDictionary *)paramsExt
                         complation:(void (^)(NSDictionary *))completion
                            failure:(void (^)(TBErrorDescription *))failure{
    NSString* lotteryId = @"";
    if (paramsExt) {
        lotteryId = [paramsExt objectForKey:@"id"];
    }
    NSString *urlStr = [[NSString stringWithFormat:@"%@/cn/inner/lottery/%@/shared",UrlBaseNeedLogin,lotteryId] urlEncoded];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.requestMethod = TBRequestMethodGet;
    //request.serviceMethodFlag = ServiceLotteryEntranceTag;
    [request setUseCookiePersistence:YES];
    
    __weak Tao800LotteryService *instance = self;
    __weak ASIFormDataRequest *pRequest = request;
    
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

- (void)getLotteryExchangeChengDu:(NSDictionary *)paramsExt
                       complation:(void (^)(NSDictionary *))completion
                          failure:(void (^)(TBErrorDescription *))failure{
    NSString* lotteryId = @"";
    if (paramsExt) {
        lotteryId = [paramsExt objectForKey:@"id"];
    }
    NSString *urlStr = [[NSString stringWithFormat:@"%@/cn/inner/lottery/%@/exchange",UrlBaseNeedLogin,lotteryId] urlEncoded];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.requestMethod = TBRequestMethodGet;
    //request.serviceMethodFlag = ServiceLotteryEntranceTag;
    [request setUseCookiePersistence:YES];
    
    __weak Tao800LotteryService *instance = self;
    __weak ASIFormDataRequest *pRequest = request;
    
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

- (void)getLotteryResult:(NSDictionary *)paramsExt
              complation:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/lottery/draw/v2",UrlBase];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlStr params:paramsExt];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.requestMethod = TBRequestMethodGet;
    request.serviceMethodFlag = ServiceLotteryResultTag;
    [request setUseCookiePersistence:YES];
    
    __weak Tao800LotteryService *instance = self;
    __weak ASIFormDataRequest *pRequest = request;
    
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


@end
