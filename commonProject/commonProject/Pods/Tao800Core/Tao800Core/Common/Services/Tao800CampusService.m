//
//  Tao800CampusService.m
//  tao800
//
//  Created by tuan800 on 14-8-15.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800CampusService.h"

#ifdef DEBUG
NSString * const CampusUrlBase = @"http://m.api.xiongmaoz.com";
#else
NSString * const CampusUrlBase = @"http://campus.tuan800.com";
#endif

@implementation Tao800CampusService

-(void)checkCampusPromotionCode:(NSDictionary *)params andCompletion:(void(^)(NSDictionary * resultDic))completion andFail:(void(^)(NSError * error))Failure{
    NSString *campusSpreadCode = [params objectForKey:@"campusSpreadCode"];
    
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@/campus/promotion/validatePromoCode?",CampusUrlBase];

    
    [urlStr appendFormat:@"promocode=%@",campusSpreadCode];
    
    NSURL *url = [NSURL URLWithString :urlStr];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    [request setRequestMethod :TBRequestMethodGet];
    
    [self send:request];
    
    __weak TBASIFormDataRequest * theRequest = request;
    
    [request setCompletionBlock:^{
        NSData * resultData = [theRequest responseData];
        NSString * resultString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        if (resultString && resultString.length > 0) {
            NSDictionary * dic = @{@"CampusPromotionCode": resultString};
            completion(dic);
        }
    }];
    
    [request setFailedBlock:^{
//        NSData * resultData = [theRequest responseData];
//        NSString * resultString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        Failure(nil);
    }];
}

@end
