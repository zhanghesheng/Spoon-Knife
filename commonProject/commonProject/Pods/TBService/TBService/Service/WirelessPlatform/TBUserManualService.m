//
//  TBUserManualService.m
//  Tuan800API
//  --- 运营相关，后台用户操作的 ---
//  Created by enfeng on 14-1-13.
//  Copyright (c) 2014年 com.tuan800.framework.Tuan800API. All rights reserved.
//

#import <TBUI/TBErrorDescription.h>
#import "TBUserManualService.h"

@implementation TBUserManualService

- (void)getLatestVersion:(NSDictionary *)params
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",
                                                     self.baseUrlString,
                                                     @"api/checkconfig/v3/soft"];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:TBRequestMethodGet];

    __weak ASIFormDataRequest *pRequest = request;
    __weak TBUserManualService *instance = self;

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
