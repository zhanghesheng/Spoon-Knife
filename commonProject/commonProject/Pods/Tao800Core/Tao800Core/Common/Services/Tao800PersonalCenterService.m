//
//  Tao800PersonalCenterService.m
//  tao800
//
//  Created by tuan800 on 14-5-27.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PersonalCenterService.h"
#import "TBService/TBScoreConsume.h"
#import "TBCore/NSString+Addition.h"

#ifdef DEBUG
NSString * const BaseUrl = @"http://m.api.tuan800.com";
NSString * const ScoreHistoryUrl = @"http://zapi.zhe800.com";
#else
NSString * const BaseUrl = @"http://api.tuan800.com";
NSString * const ScoreHistoryUrl = @"http://zapi.zhe800.com";
#endif

@implementation Tao800PersonalCenterService

-(void)getUserScoreAccountsInformation:(NSDictionary *)extraParams
                            completion:(void (^)(NSDictionary *))completion
                               failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *pageNum = [extraParams objectForKey:@"pageNum"];
    NSString *pageSize = [extraParams objectForKey:@"pageSize"];
    NSString *type = [extraParams objectForKey:@"type"];
    NSMutableString *paramStr = [NSMutableString stringWithCapacity:100];
    [paramStr appendFormat:@"%@/mobile_api/v3/score_accounts?page=%@&per_page=%@&type=%@", BaseUrl, pageNum, pageSize, type];
    
    //判断是否是sso跳转方式
    NSMutableString *urlString = [NSMutableString stringWithCapacity:255];
    NSString *ssoUrl = [extraParams objectForKey:@"ssoUrl"];
    if (ssoUrl && ![ssoUrl isEqualToString:@""]) {
        NSString *temp = [paramStr encoded]; // URL编码转码
        [urlString appendFormat:@"%@?return_to=%@",ssoUrl,temp];
    }else {
        [urlString appendString:paramStr];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    if ([urlString hasPrefix:@"https"]) {
        NSData *cerFile1 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pass" ofType:@"cer"]];
        NSData *cerFile2 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sso" ofType:@"cer"]];

        SecCertificateRef cert1 = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)cerFile1);
        SecCertificateRef cert2 = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)cerFile2);

        NSArray *array = [NSArray arrayWithObjects:
                (__bridge id) cert1,
                (__bridge id) cert2,

                nil];

        [request setClientCertificates:array];
        [request setValidatesSecureCertificate:YES];
    }
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PersonalCenterService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        //数据需要预先解析
        NSDictionary *accountDic = [instance wrappePastScoreDic:dict];
        completion(accountDic);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}



-(void)getUserGradeInformation:(NSDictionary *)extraParams
                    completion:(void (^)(NSDictionary *))completion
                       failure:(void (^)(TBErrorDescription *))failure{
}


-(void)getUserCouponsInformation:(NSDictionary *)extraParams
                      completion:(void (^)(NSDictionary *))completion
                         failure:(void (^)(TBErrorDescription *))failure{
    NSString *pageNum = [extraParams objectForKey:@"page_number"];
    NSString *pageSize = [extraParams objectForKey:@"page_size"];
    NSString * statusStr = [extraParams objectForKey:@"status"];
    NSString * overFlag = [extraParams objectForKey:@"over_flag"];
    
#ifdef DEBUG
    NSString * CouponsBaseUrl = @"http://h5.m.xiongmaoz.com/h5/api/coupons/usercoupons?";
#else
    NSString * CouponsBaseUrl = @"http://th5.m.zhe800.com/h5/api/coupons/usercoupons?";
#endif
    
    NSString * theUrlString = [NSString stringWithFormat:@"%@page=%@&per_page=%@&status=%@&over_flag=%@", CouponsBaseUrl,pageNum,pageSize,statusStr,overFlag];
    NSURL * url = [NSURL URLWithString:theUrlString];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PersonalCenterService *instance = self;
    
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


-(void)getUserScoreHistoryInformation:(NSDictionary *)extraParams
                           completion:(void (^)(NSDictionary *))completion
                              failure:(void (^)(TBErrorDescription *))failure{
    NSString *pageNum = [extraParams objectForKey:@"pageNum"];
    NSString *pageSize = [extraParams objectForKey:@"pageSize"];
    NSString *type = [extraParams objectForKey:@"type"];
    NSMutableString *paramStr = [NSMutableString stringWithCapacity:100];
    [paramStr appendFormat:@"%@/cn/score_histories?page=%@&per_page=%@&type=%@", ScoreHistoryUrl, pageNum, pageSize, type];
    
//    //判断是否是sso跳转方式
    NSMutableString *urlString = [NSMutableString stringWithCapacity:255];
//    NSString *ssoUrl = [extraParams objectForKey:@"ssoUrl"];
//    if (ssoUrl && ![ssoUrl isEqualToString:@""]) {
//        NSString *temp = [paramStr encoded]; // URL编码转码
//        [urlString appendFormat:@"%@?return_to=%@",ssoUrl,temp];
//    }else {
        [urlString appendString:paramStr];
//    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = @"GET";
    if ([urlString hasPrefix:@"https"]) {
        NSData *cerFile1 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pass" ofType:@"cer"]];
        NSData *cerFile2 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sso" ofType:@"cer"]];

        SecCertificateRef cert1 = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)cerFile1);
        SecCertificateRef cert2 = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)cerFile2);

        NSArray *array = [NSArray arrayWithObjects:
                (__bridge id) cert1,
                (__bridge id) cert2,

                nil];

        [request setClientCertificates:array];
        [request setValidatesSecureCertificate:YES];
    }
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PersonalCenterService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        NSDictionary * objectsDic = [self wrapperScoreHistoryItems:dict];
        completion(objectsDic);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

-(NSDictionary *)wrapperScoreHistoryItems:(NSDictionary *)dict{
    NSArray *items = [self convertToScoreHistoory: dict];
    NSNumber *score = [dict objectForKey:@"score"];
    NSNumber *hasNext = [dict objectForKey:@"has_next"];
    NSDictionary * resultDic = [NSDictionary dictionaryWithObjectsAndKeys:items, @"items", score, @"score", hasNext, @"hasNext", nil];
    return resultDic;
}

-(NSDictionary *)wrappePastScoreDic:(NSDictionary *)dict {
    NSMutableDictionary *finishDic = [NSMutableDictionary dictionaryWithCapacity:2];
    
    NSArray *items = [self convertToScoreAccount: dict];
    NSNumber *score = [dict objectForKey:@"score"];
    NSString *expiringTime = [dict objectForKey:@"expiring_time"];
    NSString *expiringScore = [dict objectForKey:@"expiring_score"];
    
    [finishDic setObject:items forKey:@"items"];
    
    if (score!=nil && ![score isKindOfClass:[NSNull class]]) {
        [finishDic setObject:score forKey:@"score"];
    }else {
        [finishDic setObject:@"" forKey:@"score"];
    }
    
    
    NSArray *infos = [expiringTime componentsSeparatedByString: @" "];
    if(infos!=nil && infos.count>0)
    {
        [finishDic setObject:[infos objectAtIndex:0] forKey:@"expiringTime"];
    }
    else
    {
        [finishDic setObject:@"" forKey:@"expiringTime"];
    }
    
    if (expiringTime!=nil && ![expiringTime isKindOfClass:[NSNull class]])
    {
        [finishDic setObject:expiringTime forKey:@"expiringWholeInfo"];
    }
    else
    {
        [finishDic setObject:@"" forKey:@"expiringWholeInfo"];
    }
    
    if (expiringScore!=nil && ![expiringScore isKindOfClass:[NSNull class]]) {
        [finishDic setObject:expiringScore forKey:@"expiringScore"];
    }else {
        [finishDic setObject:@"" forKey:@"expiringScore"];
    }
    return finishDic;
}

-(NSArray *)convertToScoreHistoory:(NSDictionary *)dict
{
    NSMutableArray *returnValue = [NSMutableArray arrayWithCapacity:10];
    NSArray *historyList = [dict objectForKey:@"score_histories"];
    for(NSDictionary *history in historyList)
    {
        TBScoreConsume *vo = [[TBScoreConsume alloc] init];
        vo.spendDescription = [history objectForKey:@"description"];
        vo.createAt = [history objectForKey:@"create_time"];
        vo.ruleId = [history objectForKey:@"rule_id"];
        vo.score = [history objectForKey:@"score"];
        vo.spendId = [history objectForKey:@"id"];
        [returnValue addObject:vo];
        
    }
    return returnValue;
}


-(NSArray *)convertToScoreAccount:(NSDictionary *)dict
{
    NSMutableArray *returnValue =  [NSMutableArray arrayWithCapacity:10];
    NSArray *accountList = [dict objectForKey:@"score_accounts"];
    for(NSDictionary *account in accountList)
    {
        TBScoreConsume *vo = [[TBScoreConsume alloc] init];
        vo.spendDescription = [account objectForKey:@"description"];
        vo.score = [account objectForKey:@"score"];
        vo.income = [account objectForKey:@"income"];
        NSString *expireTime = [account objectForKey:@"expire_time"];
        NSArray *expireInfo = [expireTime componentsSeparatedByString:@" "];
        if(expireInfo!=nil && expireInfo.count>0)
        {
            vo.expireDate = [expireInfo objectAtIndex:0];
        }
        else
        {
            vo.expireDate = @"";
        }
        [returnValue addObject:vo];
        
    }
    return returnValue;
}

@end
