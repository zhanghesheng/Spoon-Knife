//
//  TBFeedBackApi.m
//  Core
//
//  Created by enfeng yang on 12-2-21.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import "TBFeedBackApi.h"

#import "TBLogAnalysisBaseHeader.h"
#import "TBNetwork/Reachability.h"
#import "TBFeedBackReplyVo.h"
#import "TBCore/NSString+Addition.h"
#import "TBCore/NSDictionaryAdditions.h"

#define URL_FEEDBACK @"http://api.tuan800.com/mobile_api/iphone/feedback"
#define URL_FEEDBACK_V2 @"http://m.api.tuan800.com/user/feedback"
#define URL_FEEDBACK_PAY @"http://m.api.tuan800.com/feedback/api/v1/paymentfeedback/"
#define URL_FEEDBACK_CORRECTION @"http://m.api.tuan800.com/feedback/api/v1/dealfeedback/"
#define URL_FEEDBACK_REPLY @"http://m.api.tuan800.com/user/feedbackreply"

//@"http://192.168.5.137:8001/feedback/api/v1/paymentfeedback/"

@implementation TBFeedBackApi

@synthesize baseUrlFeedBackV2 = _baseUrlFeedBackV2;

- (id) init {
    self = [super init];
    if (self) {
        self.baseUrlFeedBackV2 = URL_FEEDBACK_V2;
    }
    return self;
}

- (void)dealloc
{
 
}

/**
 * 用户反馈
 * @params 
 *   key: contact(NSString*)
 *   key: content(NSString*)
 *   key: delegate
 */
- (void)feedback:(NSDictionary *)params {
    
    NSString *contact = [params objectForKey:@"contact"];
    NSString *content = [params objectForKey:@"content"];
    NSString *info = [params objectForKey:@"info"];
    NSURL *url = [NSURL URLWithString:URL_FEEDBACK];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    [request setPostValue:contact forKey:@"feedback[contact]"];
    [request setPostValue:content forKey:@"feedback[content]"];
    [request setPostValue:info forKey:@"feedback[info]"];
    request.serviceMethodFlag = APIFeedback;
    request.serviceData = params;
    [self send:request];
}

/**
 * product	true	string
 contact	true	string
 content	true	string
 platform	true	string
 version	true	string
 extinfo	true	string
 key	true	string
 t	false	string
 key	true	string	md5(testkey_$platform$product$version$contact$content$extinfo)
 
 
 */
- (void)feedbackPay:(NSMutableDictionary *)params {
    
    TBLogAnalysisBaseHeader *_analysisHeader = [params objectForKey:@"headervo"];
    
    //提交统计信息
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:8];
    [dataArr addObject:(_analysisHeader.systemName == nil) ? @"" : _analysisHeader.systemName];
    [dataArr addObject:(_analysisHeader.phoneVersion == nil) ? @"" : _analysisHeader.phoneVersion];
    [dataArr addObject:(_analysisHeader.phoneModel == nil) ? @"" : _analysisHeader.phoneModel];
    [dataArr addObject:(_analysisHeader.appName == nil) ? @"" : _analysisHeader.appName];
    [dataArr addObject:(_analysisHeader.appVersion == nil) ? @"" : _analysisHeader.appVersion];
    NSString *nettype = nil;
    if (_analysisHeader.networkStatus == ReachableViaWiFi) {
        nettype = @"wifi";
    } else if (_analysisHeader.networkStatus == ReachableViaWWAN) {
        nettype = @"wwan";
    } else {
        nettype = @"";
    }
    [dataArr addObject:nettype];
    [dataArr addObject:(_analysisHeader.deviceId == nil) ? @"" : _analysisHeader.deviceId];
    [dataArr addObject:(_analysisHeader.resolution == nil) ? @"" : _analysisHeader.resolution];
    
    NSString *info = [dataArr componentsJoinedByString:@"|"];
    [params setValue:info forKey:@"extinfo"];
    [params removeObjectForKey:@"headervo"];
    
    
    NSURL *url = [NSURL URLWithString:URL_FEEDBACK_PAY];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    NSString *jsonStr = [params JSONString:NO];
    NSData *dataA = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *data = [NSMutableData dataWithData:dataA];
    [request setPostBody:data];
    
    
    request.serviceMethodFlag = APIFeedbackV2;
    request.serviceData = params;
    [self send:request];
}

- (void)feedbackCorrection:(NSMutableDictionary *)params {
    //    NSString *username = [params objectForKey:@"username"];
    //    NSString *product = [params objectForKey:@"product"];
    //    NSString *version = [params objectForKey:@"pversion"];
    //    NSString *contact = [params objectForKey:@"contact"];
    //    NSString *content = [params objectForKey:@"content"];
    //    NSString *platform = [params objectForKey:@"platform"];
    //    NSString *reason = [params objectForKey:@"reason"];
    
    TBLogAnalysisBaseHeader *_analysisHeader = [params objectForKey:@"headervo"];
    
    //提交统计信息
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:8];
    [dataArr addObject:(_analysisHeader.systemName == nil) ? @"" : _analysisHeader.systemName];
    [dataArr addObject:(_analysisHeader.phoneVersion == nil) ? @"" : _analysisHeader.phoneVersion];
    [dataArr addObject:(_analysisHeader.phoneModel == nil) ? @"" : _analysisHeader.phoneModel];
    [dataArr addObject:(_analysisHeader.appName == nil) ? @"" : _analysisHeader.appName];
    [dataArr addObject:(_analysisHeader.appVersion == nil) ? @"" : _analysisHeader.appVersion];
    NSString *nettype = nil;
    if (_analysisHeader.networkStatus == ReachableViaWiFi) {
        nettype = @"wifi";
    } else if (_analysisHeader.networkStatus == ReachableViaWWAN) {
        nettype = @"wwan";
    } else {
        nettype = @"";
    }
    [dataArr addObject:nettype];
    [dataArr addObject:(_analysisHeader.deviceId == nil) ? @"" : _analysisHeader.deviceId];
    [dataArr addObject:(_analysisHeader.resolution == nil) ? @"" : _analysisHeader.resolution];
    
    NSString *info = [dataArr componentsJoinedByString:@"|"];
    [params setValue:info forKey:@"extinfo"];
    [params removeObjectForKey:@"headervo"];
    
    
    NSURL *url = [NSURL URLWithString:URL_FEEDBACK_CORRECTION];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    //    NSString *strJson = (NSString *)params;
    //    NSData *paramData = [strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *jsonStr = [params JSONString:NO];
    NSData *dataA = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];//[NSData dataWithBytes:jsonStr.UTF8String length:jsonStr.length];
    NSMutableData *data = [NSMutableData dataWithData:dataA];
    [request setPostBody:data];
    
    
    request.serviceMethodFlag = APIFeedbackV2;
    request.serviceData = params;
    [self send:request];
}

/**
 * product	true	string
 contact	true	string
 content	true	string
 platform	true	string
 version	true	string
 extinfo	true	string
 key	true	string
 t	false	string
 key	true	string	md5(testkey_$platform$product$version$contact$content$extinfo)
 
 
 */
- (void)feedbackV2:(NSDictionary *)params {
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
    NSString *nettype = nil;
    if (_analysisHeader.networkStatus == ReachableViaWiFi) {
        nettype = @"wifi";
    } else if (_analysisHeader.networkStatus == ReachableViaWWAN) {
        nettype = @"wwan";
    } else {
        nettype = @"";
    }
    [dataArr addObject:nettype];
    [dataArr addObject:(_analysisHeader.deviceId == nil) ? @"" : _analysisHeader.deviceId];
    [dataArr addObject:(_analysisHeader.resolution == nil) ? @"" : _analysisHeader.resolution];
    
    NSString *info = [dataArr componentsJoinedByString:@"|"];
    NSString *key = [NSString stringWithFormat:@"testkey_%@%@%@%@%@%@",
                     platform, product, version, contact, content, info
                     ];
    key = [key md5];
    
    NSURL *url = [NSURL URLWithString:_baseUrlFeedBackV2];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    
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
    
    request.serviceMethodFlag = APIFeedbackV2;
    request.serviceData = params;
    [self send:request];
}

/**
 * 获取对用户反馈信息进行回复的信息列表
 * @params
 * userId 表示用户id
 */
- (void)getFeedbackReply:(NSDictionary *)params {
    
    NSString *userId = [params objectForKey:@"userId"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?username=%@", URL_FEEDBACK_REPLY, userId];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = APIFeedbackReply;
    [request setRequestMethod:TBRequestMethodGet];
    
    //支持gzip
    request.allowCompressedResponse = YES;
    
    request.serviceData = params;
    [self send:request];
}

- (NSArray *)ConvertJsonToReplys:(NSArray *)array {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dic in array) {
        TBFeedBackReplyVo *vo = [[TBFeedBackReplyVo alloc] init];
        vo.relpyId = [[dic objectForKey:@"id" convertNSNullToNil:YES] stringValue];
        vo.msg = (NSString *)[dic objectForKey:@"msg" convertNSNullToNil:YES];
        vo.content = (NSString *)[dic objectForKey:@"content" convertNSNullToNil:YES];
        vo.createTime = [(NSString *)[dic objectForKey:@"createtime" convertNSNullToNil:YES] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        [result addObject:vo];

    }
    return result;
}

- (void)requestFinished:(TBASIFormDataRequest *)request {
    BOOL isError = [self isResponseDidNetworkError:request];
    if (isError) {
        ASIDownloadCache *sharedCache = [ASIDownloadCache sharedCache];
        [sharedCache removeCachedDataForURL:request.url];
        return;
    }
    NSString *dataStr = [request responseString];
    
    dataStr = [dataStr trim];
    NSDictionary *dict = nil;
    @try {
        dict = [dataStr JSONValue];
    }
    @catch (NSException *exception) {
        dict = [NSDictionary dictionary];
    }
    if (dict == nil) {
        dict = [NSDictionary dictionary];
    }
    SEL sel = nil;
    NSObject *finishObj = dict;
    
    switch (request.serviceMethodFlag) {
            
        case APIFeedback: {
            sel = @selector(feedbackFinish:);
        }
            break;
        case APIFeedbackV2: {
            sel = @selector(feedbackV2Finish:);
        }
            break;
        case APIFeedbackReply: {
            NSArray *arr = [self ConvertJsonToReplys:(NSArray *)finishObj];
            finishObj = [NSDictionary dictionaryWithObjectsAndKeys:arr,@"items", nil];
            sel = @selector(getFeedbackReplyFinish:);
        }
            break;
    };
    [super requestFinished:request];
    
    if (sel && self.delegate && [self.delegate respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.delegate performSelector:sel withObject:finishObj];
#pragma clang diagnostic pop
    }
}

@end