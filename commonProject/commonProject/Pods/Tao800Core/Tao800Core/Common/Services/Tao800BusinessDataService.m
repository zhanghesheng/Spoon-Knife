//
//  Tao800BusinessDataService.m
//  tao800
//
//  Created by tuan800 on 14-2-24.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/TBErrorDescription.h>
#import "Tao800BusinessDataService.h"
#import "Tao800FunctionCommon.h"

#ifdef DEBUG
NSString *const BDUrlBase = @"http://m.api.tuan800.com";
NSString * const ScoreAndCashUrl = @"http://h5.m.xiongmaoz.com/h5/api/getexchangerule";
#else
NSString *const BDUrlBase = @"http://m.api.tuan800.com";
NSString * const ScoreAndCashUrl = @"http://th5.m.zhe800.com/h5/api/getexchangerule";
#endif

@implementation Tao800BusinessDataService

- (void)checkIn:(NSDictionary *)paramsExt
     completion:(void (^)(NSDictionary *))completion
        failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *checkin = [paramsExt objectForKey:@"checkin"];
    NSString * renewStr = [paramsExt objectForKey:@"renew"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/checkins", UrlBaseNeedLogin];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setUseCookiePersistence:YES];
    request.delegate = self;
    request.serviceMethodFlag = ServiceCheckins;
    [request setPostValue:checkin forKey:@"checkin"];
    
    if (renewStr && renewStr.length > 0) {
        [request setPostValue:renewStr forKey:@"renew"];
    }
    
    __weak Tao800BusinessDataService *instance = self;
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
    /*
     注：需要加入统计的一些参数 这里没加
     */
}

- (void)getCheckInHistory:(NSDictionary *)paramsExt
               complation:(void (^)(NSDictionary *))complation
                  failure:(void (^)(TBErrorDescription *))failure{
    NSString *user_id = [paramsExt objectForKey:@"user_id"];
    if (!user_id) {
        user_id = @"";
    }
    NSString *query_type = [paramsExt objectForKey:@"query_type"];
    if (!query_type) {
        query_type = @"";
    }
    
    NSString *start_time = [paramsExt objectForKey:@"start_date"];
    if (!start_time) {
        start_time = @"";
    }
    NSString *end_time = [paramsExt objectForKey:@"end_date_date"];
    if (!end_time) {
        end_time = @"";
    }
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
    
    __weak Tao800BusinessDataService *instance = self;
    __weak ASIFormDataRequest *pRequest = request;
    
    [pRequest setCompletionBlock:^{
        NSDictionary *dic = [instance getResponseJsonResult:pRequest];
        if (!dic) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        complation(dic);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getCommonScoreAndCashInformation:(NSDictionary *)paramsExt
                              complation:(void (^)(NSDictionary *))complation
                                 failure:(void (^)(TBErrorDescription *))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@",ScoreAndCashUrl];
    
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceCheckinsHistory;
    [request setRequestMethod :TBRequestMethodGet];
    
    __weak Tao800BusinessDataService *instance = self;
    __weak ASIFormDataRequest *pRequest = request;
    
    [pRequest setCompletionBlock:^{
        NSDictionary *dic = [instance getResponseJsonResult:pRequest];
        if (!dic) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        complation(dic);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getPushToExistsHistory:(NSDictionary *)paramsExt
                    complation:(void (^)(NSDictionary *))complation
                       failure:(void (^)(TBErrorDescription *))failure{
    NSString *user_id = [paramsExt objectForKey:@"user_id"];
    if (!user_id) {
        user_id = @"";
    }
    NSString *query_type = [paramsExt objectForKey:@"query_type"];
    if (!query_type) {
        query_type = @"";
    }
    
    NSString *start_time = [paramsExt objectForKey:@"start_date"];
    if (!start_time) {
        start_time = @"";
    }
    NSString *end_time = [paramsExt objectForKey:@"end_date_date"];
    if (!end_time) {
        end_time = @"";
    }
    NSString *page = @"1";
    NSString *per_page = @"40";
    NSString *rule_type = @"quit_share";
    NSString *product = @"tao800";
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/integral/bill?user_id=%@&query_type=%@&start_time=%@&end_time=%@&page=%@&per_page=%@&rule_type=%@&product=%@",UrlBase,user_id,query_type,start_time,end_time,page,per_page,rule_type,product];
    
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceCheckinsHistory;
    [request setRequestMethod :TBRequestMethodGet];
    
    __weak Tao800BusinessDataService *instance = self;
    __weak ASIFormDataRequest *pRequest = request;
    
    [pRequest setCompletionBlock:^{
        NSDictionary *dic = [instance getResponseJsonResult:pRequest];
        if (!dic) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        complation(dic);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)addDealSubscibe:(NSDictionary *)paramsExt
             complation:(void (^)(NSDictionary *))completion
                failure:(void (^)(TBErrorDescription *))failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/cn/deal_subscibe", BDUrlBase];
    
    NSString *date = currentDateFormatToStr();
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    [params setValue:date forKey:@"date"];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;
    
    [self wrapperPostRequest:params request:request];
    
    __weak Tao800BusinessDataService *instance = self;
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

- (void)addOpenGroupRemind:(NSDictionary *)params
                complation:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *dealId = [params objectForKey:@"dealId"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/cn/kt/add",UrlBaseNeedLogin];
    
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;
    
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    
    [request setPostValue:dealId forKey:@"deal_id"];
    [request setPostValue:@"tao800" forKey:@"product"];
    [request setPostValue:dm.apnsDeviceToken forKey:@"device_id"];
    
    __weak Tao800BusinessDataService *instance = self;
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

- (void)deleteOpenGroupRemind:(NSDictionary *)params
                   complation:(void (^)(NSDictionary *))completion
                      failure:(void (^)(TBErrorDescription *))failure{
    
    
    NSString *ids = [params objectForKey:@"ids"]; // 支持同时取消多个deal_id,多个deal_id之间用逗号分隔。
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/cn/kt/del",UrlBaseNeedLogin];
    
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;
    
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    
    [request setPostValue:ids forKey:@"deal_id"];
    [request setPostValue:@"tao800" forKey:@"product"];
    [request setPostValue:dm.apnsDeviceToken forKey:@"device_id"];
    
    __weak Tao800BusinessDataService *instance = self;
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

-(void)checkWeiXinFollowStatus:(NSDictionary *)paramsExt
                    completion:(void (^)(NSDictionary *))completion
                       failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://m.zhe800.com/hd/wx_follow_check"];
    NSURL *url = [NSURL URLWithString :urlStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceWeixinFollowCheckTag;
    
    __weak Tao800BusinessDataService *instance = self;
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

-(void)checkQQZoneFollowStatus:(NSDictionary *)paramsExt
                    completion:(void (^)(NSDictionary *))completion
                       failure:(void (^)(TBErrorDescription *))failure{
    NSString *urlStr = [NSString stringWithFormat:@"http://zapi.zhe800.com/user/qq_follow_check"];
    NSURL *url = [NSURL URLWithString :urlStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.requestMethod = TBRequestMethodPost;
    request.serviceMethodFlag = ServiceQQZoneFollowCheckTag;
    
    __weak Tao800BusinessDataService *instance = self;
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
