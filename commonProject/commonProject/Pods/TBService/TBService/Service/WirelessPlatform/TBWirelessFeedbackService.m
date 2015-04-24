//
//  TBWirelessFeedbackService.m
//  Tuan800API
//  --- 用户反馈相关的接口 ---
//  Created by enfeng on 14-1-13.
//  Copyright (c) 2014年 com.tuan800.framework.Tuan800API. All rights reserved.
//

#import <TBNetwork/Reachability.h>
#import <Foundation/Foundation.h>
#import "TBWirelessFeedbackService.h"
#import "TBCore/NSDictionaryAdditions.h"
#import "TBCore/NSString+Addition.h"

@implementation TBWirelessFeedbackService

- (void)addFeedBack:(NSDictionary *)params
         completion:(void (^)(NSDictionary *))completion
            failure:(void (^)(TBErrorDescription *))failure {

    NSString *urlString = [NSString stringWithFormat:@"%@/user/feedback", self.baseUrlString];
    NSURL *url = [NSURL URLWithString:urlString];

    NSString *product = [params objectForKey:@"product"];
    NSString *contact = [params objectForKey:@"contact"];
    NSString *content = [params objectForKey:@"content"];
    NSString *platform = [params objectForKey:@"platform"];
    NSString *version = [params objectForKey:@"version"];
    NSString *username = [params objectForKey:@"username"];
    NSString *pType = [params objectForKey:@"t"];

    TBLogAnalysisBaseHeader *_analysisHeader = [params objectForKey:@"headervo"];

    //提交统计信息
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:8];
    [dataArr addObject:(_analysisHeader.systemName == nil) ? @"" : _analysisHeader.systemName];
    [dataArr addObject:(_analysisHeader.phoneVersion == nil) ? @"" : _analysisHeader.phoneVersion];
    [dataArr addObject:(_analysisHeader.phoneModel == nil) ? @"" : _analysisHeader.phoneModel];
    [dataArr addObject:(_analysisHeader.appName == nil) ? @"" : _analysisHeader.appName];
    [dataArr addObject:(_analysisHeader.appVersion == nil) ? @"" : _analysisHeader.appVersion];
    NSString *netType = nil;
    if (_analysisHeader.networkStatus == ReachableViaWiFi) {
        netType = @"wifi";
    } else if (_analysisHeader.networkStatus == ReachableViaWWAN) {
        netType = @"wwan";
    } else {
        netType = @"";
    }
    [dataArr addObject:netType];
    [dataArr addObject:(_analysisHeader.deviceId == nil) ? @"" : _analysisHeader.deviceId];
    [dataArr addObject:(_analysisHeader.resolution == nil) ? @"" : _analysisHeader.resolution];

    NSString *info = [dataArr componentsJoinedByString:@"|"];
    NSString *key = [NSString stringWithFormat:@"testkey_%@%@%@%@%@%@",
                                               platform, product, version, contact, content, info
    ];
    key = [key md5];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:TBRequestMethodPost];

    [request setPostValue:info forKey:@"extinfo"];
    [request setPostValue:product forKey:@"product"];
    [request setPostValue:contact forKey:@"contact"];
    [request setPostValue:content forKey:@"content"];
    [request setPostValue:platform forKey:@"platform"];
    [request setPostValue:version forKey:@"version"];
    if (pType) {
        [request setPostValue:pType forKey:@"t"];
    }
    if(username){
        [request setPostValue:username forKey:@"username"];
    }
    [request setPostValue:key forKey:@"key"];

    __weak ASIFormDataRequest *wRequest = request;
    __weak TBBaseNetworkApi *instance = self;

    [request setCompletionBlock:^{
//        NSString *str = wRequest.responseString;
//        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *error = nil;
//        NSDictionary *dict =
//                [NSJSONSerialization JSONObjectWithData:data
//                                                options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
//                                                  error:&error];
        NSDictionary *dict = [instance getResponseJsonResult:wRequest];
        completion (dict);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:wRequest];
        failure(tbd);
    }];

    [self send:request];
}

- (void)addDealFeedBack:(NSDictionary *)params
             completion:(void (^)(NSDictionary *))completion
                failure:(void (^)(TBErrorDescription *))failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/feedback/api/v1/dealfeedback/", self.baseUrlString];
    NSURL *url = [NSURL URLWithString:urlString];

    TBLogAnalysisBaseHeader *_analysisHeader = [params objectForKey:@"headervo"];

    //提交统计信息
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:8];
    [dataArr addObject:(_analysisHeader.systemName == nil) ? @"" : _analysisHeader.systemName];
    [dataArr addObject:(_analysisHeader.phoneVersion == nil) ? @"" : _analysisHeader.phoneVersion];
    [dataArr addObject:(_analysisHeader.phoneModel == nil) ? @"" : _analysisHeader.phoneModel];
    [dataArr addObject:(_analysisHeader.appName == nil) ? @"" : _analysisHeader.appName];
    [dataArr addObject:(_analysisHeader.appVersion == nil) ? @"" : _analysisHeader.appVersion];
    NSString *netType = nil;
    if (_analysisHeader.networkStatus == ReachableViaWiFi) {
        netType = @"wifi";
    } else if (_analysisHeader.networkStatus == ReachableViaWWAN) {
        netType = @"wwan";
    } else {
        netType = @"";
    }
    [dataArr addObject:netType];
    [dataArr addObject:(_analysisHeader.deviceId == nil) ? @"" : _analysisHeader.deviceId];
    [dataArr addObject:(_analysisHeader.resolution == nil) ? @"" : _analysisHeader.resolution];

    NSString *info = [dataArr componentsJoinedByString:@"|"];

    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [jsonDict setValue:info forKey:@"extinfo"];
    [jsonDict removeObjectForKey:@"headervo"];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:TBRequestMethodPost];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];

    //    NSString *strJson = (NSString *)params;
    //    NSData *paramData = [strJson dataUsingEncoding:NSUTF8StringEncoding];

    NSString *jsonStr = [jsonDict JSONString:NO];
    NSData *dataA = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];//[NSData dataWithBytes:jsonStr.UTF8String length:jsonStr.length];
    NSMutableData *data = [NSMutableData dataWithData:dataA];
    [request setPostBody:data];

    __weak ASIFormDataRequest *wRequest = request;
    __weak TBBaseNetworkApi *instance = self;

    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:wRequest];
        completion (dict);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:wRequest];
        failure(tbd);
    }];

    [self send:request];
}


@end
