//
//  TBPassportService.m
//  Tuan800API
//
//  Created by enfeng on 14-1-14.
//  Copyright (c) 2014年 com.tuan800.framework.Tuan800API. All rights reserved.
//

#import <TBUI/TBErrorDescription.h>
#import "TBPassportService.h"

#if DEBUG
NSString *const TBPassportUrlBase = @"http://passport.xiongmaot.com/";
#else
NSString *const TBPassportUrlBase = @"https://passport.tuan800.com/";
#endif

@implementation TBPassportService

- (NSString *)getSessionAction {
    //todo 临时修改，目前测试环境只是支持sessions
    NSString *action = @"sessions_v2";
#if DEBUG
    action = @"sessions";
#endif
    return action;
}
- (id)init {
    self = [super init];
    if (self) {
        self.baseUrlString = TBPassportUrlBase;
    }
    return self;
}

- (void)signUp:(NSDictionary *)params
    completion:(void (^)(NSDictionary *))completion
       failure:(void (^)(TBErrorDescription *))failure {

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseUrlString, @"m/users"]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:TBRequestMethodPost];
    [request setUseCookiePersistence:YES];

    //添加请求参数
    [self wrapperPostRequest:params request:request];

    __weak ASIFormDataRequest *pRequest = request;
    __weak TBPassportService *instance = self;

    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            dict = @{@"tb_error" : tbd};
        }
        completion(dict);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
}

- (void)getSecurityCode:(NSDictionary *)params
             completion:(void (^)(NSDictionary *))completion
                failure:(void (^)(TBErrorDescription *))failure {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseUrlString, @"m/phone_confirmations"]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:TBRequestMethodPost];

    //添加请求参数
    [self wrapperPostRequest:params request:request];

    __weak ASIFormDataRequest *pRequest = request;
    __weak TBPassportService *instance = self;

    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            dict = @{@"tb_error" : tbd};
        }
        completion(dict);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
}

- (void)login:(NSDictionary *)params
   completion:(void (^)(NSDictionary *))completion
      failure:(void (^)(TBErrorDescription *))failure {
    NSString *action = [self getSessionAction];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m/%@", self.baseUrlString, action]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:TBRequestMethodPost];
    [request setUseCookiePersistence:YES];

    //添加请求参数
    [self wrapperPostRequest:params request:request];

    __weak ASIFormDataRequest *pRequest = request;
    __weak TBPassportService *instance = self;

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

- (void)logout:(NSDictionary *)params
    completion:(void (^)(NSDictionary *))completion
       failure:(void (^)(TBErrorDescription *))failure {
    NSString *action = [self getSessionAction];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m/%@", self.baseUrlString, action]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:TBRequestMethodPost];

    //添加请求参数
    [self wrapperPostRequest:params request:request];
    [request setPostValue:@"DELETE" forKey:@"_method"];

    __weak ASIFormDataRequest *pRequest = request;
    __weak TBPassportService *instance = self;

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

- (void)verifyShortMessage:(NSDictionary *)params
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseUrlString, @"users/password.json"]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:TBRequestMethodPost];

    //添加请求参数
    [self wrapperPostRequest:params request:request];

    __weak ASIFormDataRequest *pRequest = request;
    __weak TBPassportService *instance = self;

    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            dict = @{@"tb_error" : tbd};
        }
        completion(dict);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
}

- (void)updatePassword:(NSDictionary *)params
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseUrlString, @"m/passwords"]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:TBRequestMethodPost];

    //添加请求参数
    [self wrapperPostRequest:params request:request];

    __weak ASIFormDataRequest *pRequest = request;
    __weak TBPassportService *instance = self;

    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            dict = @{@"tb_error" : tbd};
        }
        completion(dict);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
}

- (void)bindPhone:(NSDictionary *)params
       completion:(void (^)(NSDictionary *))completion
          failure:(void (^)(TBErrorDescription *))failure {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                                                 self.baseUrlString,
                                                                 @"m/users/bind_phone_number"]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:TBRequestMethodPost];

    //添加请求参数
    [self wrapperPostRequest:params request:request];

    __weak ASIFormDataRequest *pRequest = request;
    __weak TBPassportService *instance = self;

    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            dict = @{@"tb_error" : tbd};
        }
        completion(dict);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
}

- (void)verifySecurityCode:(NSDictionary *)params
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                                                 self.baseUrlString,
                                                                 @"m/phone_confirmations/validate"]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:TBRequestMethodPost];

    //添加请求参数
    [self wrapperPostRequest:params request:request];
    [request setUseCookiePersistence:NO];

    __weak ASIFormDataRequest *pRequest = request;
    __weak TBPassportService *instance = self;

    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            dict = @{@"tb_error" : tbd};
        }
        completion(dict);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
}

- (void)ssoRedirectToUrl:(NSDictionary *)params
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure {
    NSString *urlString = [params objectForKey:@"targetUrl"];
    NSString *ssoBaseUrlString = [params objectForKey:@"ssoBaseUrl"];

    NSURL *url = [NSURL URLWithString:ssoBaseUrlString];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:TBRequestMethodPost];

    //添加请求参数
    [request setPostValue:urlString forKey:@"return_to"];
    [request setUseCookiePersistence:YES];

    __weak ASIFormDataRequest *pRequest = request;
    __weak TBPassportService *instance = self;

    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            dict = @{@"tb_error" : tbd};
        }
        completion(dict);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
}

- (void)captchaImg:(NSDictionary *)params
        completion:(void (^)(NSDictionary *))completion
           failure:(void (^)(TBErrorDescription *))failure {

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                                                 self.baseUrlString,
                                                                 @"m/captcha_img.json"]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:TBRequestMethodGet];

    __weak ASIFormDataRequest *pRequest = request;
    __weak TBPassportService *instance = self;

    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            dict = @{@"tb_error" : tbd};
        }
        completion(dict);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
}


@end
