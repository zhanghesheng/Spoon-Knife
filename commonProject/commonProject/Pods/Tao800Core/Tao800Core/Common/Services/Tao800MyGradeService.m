//
//  Tao800MyGradeService.m
//  tao800
//
//  Created by ayvin on 13-4-22.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800MyGradeService.h"
#import "TBCore/TBCore.h"
#import "Tao800StaticConstant.h"
#import "TBCore/TBFileUtil.h"
#import "TBUI/TBUI.h"
#import "Tao800MyGradeVo.h"
#import "Tao800DataModelSingleton.h"

NSString * const Tao800APIKeyString = @"A5E273B4BADFC7FAA627E0EC1AA8D117";
//加积分的时候需要这个参数，无线后台配

@implementation Tao800MyGradeService

- (void)getMyGrade:(NSDictionary *)params
{
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    NSURL *url = [NSURL URLWithString :[NSString stringWithFormat:@"%@/profile/grade?user_id=%@",UrlBaseNeedLogin, dm.user.userId]];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServiceGetMyGradeTag;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
//    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setSecondsToCache:60*60*24];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setRequestMethod :TBRequestMethodGet];
    
    [self send:request];
}

- (void)requestFinished:(ASIHTTPRequest *)requestParam {
    TBASIFormDataRequest *request = (TBASIFormDataRequest *) requestParam;
    
    if (self.delegate == nil) {
        return;
    }
    
    NSDictionary *dict = nil;
    NSString *dataStr = [request responseString];
    @try {
        dict = [dataStr JSONValue];
    }
    @catch (NSException *exception) {
        dict = [NSDictionary dictionary];
    }
    @finally {
        
    }
    
    SEL sel = nil;
    NSObject *retObj = nil;
    
    switch (request.serviceMethodFlag) {
        case ServiceGetMyGradeTag:
        {
            sel = @selector(getMyGradeFinish:);
            Tao800MyGradeVo *gradeVo = [[Tao800MyGradeVo alloc] init];
            [self convertJson:dict ToMyGrade:gradeVo];
            retObj = [NSDictionary dictionaryWithObject:gradeVo forKey:@"items"];
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


-(void)convertJson: (NSDictionary *)input ToMyGrade: (Tao800MyGradeVo *)output
{
    if(input == nil || ![input isKindOfClass:NSDictionary.class])
    {
        return;
    }
    
    int status = [[input objectForKey:@"status"] intValue];
    
    if (status == 0) {
        output.grade = 0;
        output.price = 0;
        return ;
    }
    
    NSDictionary *gradeDict = [input objectForKey:@"grade"];
    output.grade = [[gradeDict objectForKey:@"grade"] intValue];
    output.price = [[gradeDict objectForKey:@"price"] intValue];
    
}

- (void)addPoint:(NSDictionary *)params
      completion:(void (^)(NSDictionary *)) completion
         failure:(void (^)(TBErrorDescription *))failure {
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/integral/pointv2", UrlBase];
    NSString *userId = params[@"user_id"];
    NSString *pointKey = params[@"point_key"];
    NSString *apiKey = Tao800APIKeyString;
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *time = [NSString stringWithFormat:@"%.2f", timeInterval];
    
    NSArray *array = @[apiKey, @"point_key", pointKey, @"user_id", userId, time];
    NSString *signString = [array componentsJoinedByString:@""];
    signString = [signString urlEncoded];
    
    NSString *sign = [signString md5];
    sign = [sign uppercaseString];
    
    NSMutableDictionary *sParam = [NSMutableDictionary new];
    [sParam setObject:userId forKey:@"user_id"];
    [sParam setObject:pointKey forKey:@"point_key"];
    [sParam setObject:apiKey forKey:@"api_key"];
    [sParam setValue:sign forKey:@"sign"];
    [sParam setValue:time forKey:@"timestamp"];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:sParam];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800MyGradeService *instance = self;
    
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
