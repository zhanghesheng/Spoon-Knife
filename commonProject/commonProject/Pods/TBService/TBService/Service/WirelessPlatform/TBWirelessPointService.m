//
//  TBWirelessPointService.m
//  Tuan800API
//  --- 积分相关的接口 ---
//  Created by enfeng on 14-1-13.
//  Copyright (c) 2014年 com.tuan800.framework.Tuan800API. All rights reserved.
//

#import <TBUI/TBErrorDescription.h>
#import "TBWirelessPointService.h"
#import "TBPointRuleVo.h"
#import "TBCore/NSString+Addition.h"
#import "TBCore/NSDictionaryAdditions.h"

@implementation TBWirelessPointService

- (NSArray *)wrapperPoint:(NSArray *)arr {
    NSMutableArray *retArr = [NSMutableArray arrayWithCapacity:arr.count];
    for (NSDictionary *item in arr) {
        TBPointRuleVo *vo = [[TBPointRuleVo alloc] init];
        vo.pointRuleDescription = [item objectForKey:@"description" convertNSNullToNil:YES];
        vo.pointRuleScore = [item objectForKey:@"score" convertNSNullToNil:YES];
        vo.pointRuleId = [item objectForKey:@"id" convertNSNullToNil:YES];
        vo.title = [item objectForKey:@"title" convertNSNullToNil:YES];
        vo.pointRuleKey = [item objectForKey:@"key" convertNSNullToNil:YES];
        [retArr addObject:vo];
    }
    return retArr;
}

- (void)getPointRules:(NSDictionary *)params
           completion:(void (^)(NSDictionary *))completion
              failure:(void (^)(TBErrorDescription *))failure {

    NSString *urlString = [NSString stringWithFormat:@"%@/integral/rule", self.baseUrlString];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;

    __weak ASIFormDataRequest *pRequest = request;
    __weak TBWirelessPointService *instance = self;

    [request setCompletionBlock:^{
        NSArray *rules = (NSArray *) [instance getResponseJsonResult:pRequest];
        NSArray *items = [instance wrapperPoint:rules];
        NSDictionary *dict = @{@"items" : items};
        completion(dict);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
}

- (void)addPoint:(NSDictionary *)params
      completion:(void (^)(NSDictionary *)) completion
         failure:(void (^)(TBErrorDescription *))failure {


    NSString *urlString = [NSString stringWithFormat:@"%@/integral/pointv2", self.baseUrlString];
    NSString *userId = params[@"user_id"];
    NSString *pointKey = params[@"point_key"];
    NSString *apiKey = params[@"api_key"];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *time = [NSString stringWithFormat:@"%.2f", timeInterval];

    NSArray *array = @[apiKey, @"point_key", pointKey, @"user_id", userId, time];
    NSString *signString = [array componentsJoinedByString:@""];
    signString = [signString urlEncoded];

    NSString *sign = [signString md5];
    sign = [sign uppercaseString];

    NSMutableDictionary *sParam = [NSMutableDictionary dictionaryWithDictionary:params];
    [sParam setValue:sign forKey:@"sign"];
    [sParam setValue:time forKey:@"timestamp"];

    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:sParam];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;

    __weak ASIFormDataRequest *pRequest = request;
    __weak TBWirelessPointService *instance = self;

    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        completion(dict);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
}

- (void)getUserPoint:(NSDictionary *)params
          completion:(void (^)(NSDictionary *))completion
             failure:(void (^)(TBErrorDescription *))failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/integral/user", self.baseUrlString];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;

    __weak ASIFormDataRequest *pRequest = request;
    __weak TBWirelessPointService *instance = self;

    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        completion(dict);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
}

- (void)getTodayTasks:(NSDictionary *)params
           completion:(void (^)(NSDictionary *))completion
              failure:(void (^)(TBErrorDescription *))failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/integral/today", self.baseUrlString];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;

    __weak ASIFormDataRequest *pRequest = request;
    __weak TBWirelessPointService *instance = self;

    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        completion(dict);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
}

- (void)getPointsByInviter:(NSDictionary *)params
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure {

    NSString *urlString = [NSString stringWithFormat:@"%@/integral/invite_award", self.baseUrlString];

    NSMutableDictionary *pDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [pDict setValue:@"json" forKey:@"format"];

    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:pDict];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;

    __weak ASIFormDataRequest *pRequest = request;
    __weak TBWirelessPointService *instance = self;

    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        completion(dict);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
}


@end
