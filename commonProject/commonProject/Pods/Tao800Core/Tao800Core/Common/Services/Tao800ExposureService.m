//
//  Tao800ExposureService.m
//  tao800
//
//  Created by adminName on 14-5-22.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800ExposureService.h"
#import "TBCore/TBCoreMacros.h"

#ifdef DEBUG
//测试
NSString *const initLogBase = @"http://m.api.xiongmaoz.com";
NSString *const Tao800ExposureServiceAppActiveUrl = @"http://api.tuan800.com";
#else
//正式
NSString *const initLogBase = @"http://m.api.tuan800.com";
//http://api.tuan800.com
NSString *const Tao800ExposureServiceAppActiveUrl = @"http://api.tuan800.com";
#endif

@implementation Tao800ExposureService

- (void)sendSaveDealLogs:(NSDictionary *)paramsExt
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failur{
    NSString *urlString = @"http://analysis.tuanimg.com/v1/global/img/a.gif";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    request.userInfo = paramsExt;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800ExposureService *instance = self;
    
    [request setCompletionBlock:^{
        int staues = pRequest.responseStatusCode;
        if (staues == 200) {
            
        }
        completion(nil);
    }];
    [request setFailedBlock:^{
        int staues = pRequest.responseStatusCode;
        if (staues!=200) {
            TBDPRINT(@"responseStatusCode失败＝%d",staues);
        }
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failur(tbd);
    }];
    
    [self send:request];
}

- (void)sendInitLogs:(NSDictionary *)paramsExt
          completion:(void (^)(NSDictionary *))completion
             failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/operation/click/v2/getmobileinit",initLogBase];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    request.userInfo = paramsExt;
    
    __weak ASIFormDataRequest *pRequest = request;
    //    __weak Tao800ExposureService *instance = self;
    
    [request setCompletionBlock:^{
        int staues = pRequest.responseStatusCode;
        if (staues == 200) {
            TBDPRINT(@"上传init 打点事件成功！");
        }
        completion(nil);
    }];
    [request setFailedBlock:^{

    }];
    
    [self send:request];
    
}

- (void)sendInitThreeMinuteLogs:(NSDictionary *)paramsExt
          completion:(void (^)(NSDictionary *))completion
             failure:(void (^)(TBErrorDescription *))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@/operation/click/v2/getmobilethree",initLogBase];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    request.userInfo = paramsExt;
    
     __weak ASIFormDataRequest *pRequest = request;
    //    __weak Tao800ExposureService *instance = self;
    
    [request setCompletionBlock:^{
        int staues = pRequest.responseStatusCode;
        if (staues == 200) {
            TBDPRINT(@"3分钟后上传init 打点事件成功！");
        }
        completion(nil);
    }];
    [request setFailedBlock:^{
        
    }];
    
    [self send:request];
    
}

- (void)sendCpaOutLogs:(NSDictionary *)paramsExt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@/operation/click/v2/getmobileout",initLogBase];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    request.userInfo = paramsExt;
    
    __weak ASIFormDataRequest *pRequest = request;
    //    __weak Tao800ExposureService *instance = self;
    
    [request setCompletionBlock:^{
        int staues = pRequest.responseStatusCode;
        if (staues == 200) {
            TBDPRINT(@"cpa-out 参数上传成功");
        }
        completion(nil);
    }];
    [request setFailedBlock:^{
        
    }];
    
    [self send:request];

}

- (void)sendRegisterLogs:(NSDictionary *)paramsExt
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/operation/click/v2/getmobileregister",initLogBase];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    request.userInfo = paramsExt;
    
    __weak ASIFormDataRequest *pRequest = request;
    //    __weak Tao800ExposureService *instance = self;
    
    [request setCompletionBlock:^{
        int staues = pRequest.responseStatusCode;
        if (staues == 200) {
            TBDPRINT(@"注册参数上传成功");
        }
        completion(nil);
    }];
    [request setFailedBlock:^{
        
    }];
    
    [self send:request];
}

//引导页后上传客户端激活信息
- (void)sendAppActiveLogs:(NSDictionary *)paramsExt
               completion:(void (^)(NSDictionary *))completion
                  failure:(void (^)(TBErrorDescription *))failure{

    NSString *urlString = [NSString stringWithFormat:@"%@/mobilelog/activelog/v2/activeinfo",Tao800ExposureServiceAppActiveUrl];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *paramStr = paramsExt[@"param"];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;

    [request setPostValue:paramStr forKey:@"data"];
    __weak ASIFormDataRequest *pRequest = request;
    
    [request setCompletionBlock:^{
        int staues = pRequest.responseStatusCode;
        if (staues == 200) {
            TBDPRINT(@"客户端上传激活参数成功");
        }
        completion(nil);
    }];
    [request setFailedBlock:^{
        completion(nil);
    }];
    
    [self send:request];


}
@end
