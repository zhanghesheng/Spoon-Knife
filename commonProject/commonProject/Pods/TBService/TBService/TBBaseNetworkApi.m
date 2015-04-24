//
//  TBBaseNetworkApi.m
//  Core
//
//  Created by enfeng yang on 12-1-16.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import "TBUI/TBErrorDescription.h"
#import "TBBaseNetworkApi.h"
#import "TBCore/TBCoreMacros.h"
#import "TBLogAnalysisBaseHeader.h"
#import <TBUI/TBUICommon.h>

static TBLogAnalysisBaseHeader *logAnalysisHeader;

@implementation TBBaseNetworkApi

- (id)init {
    self = [super init];
    if (self) {

    }

    return self;
}

+ (void)setLLogAnalysisBaseHeader:(TBLogAnalysisBaseHeader *)header {
 
    logAnalysisHeader = [header copy];
}

- (void)dealloc {

}


- (void)send:(TBASIFormDataRequest *)request {
    // 请求中增加user-agent参数

    if (logAnalysisHeader) {
        NSMutableString *str = [NSMutableString stringWithCapacity:6];
        [str appendString:@"tbbz"];

        if (TBIsPad()) {
            [str appendFormat:@"|tao800"];
        }else{
            [str appendFormat:@"|%@", logAnalysisHeader.appName];
        }
        
        [str appendFormat:@"|%@", logAnalysisHeader.macAddress];
        
        if (TBIsPad()) {
            [str appendFormat:@"|iPad"];
        }else{
            [str appendFormat:@"|%@", logAnalysisHeader.platform];
        }
        
        [str appendFormat:@"|%@", logAnalysisHeader.appVersion];
        [str appendFormat:@"|%@", logAnalysisHeader.partner];
        TBDPRINT(@"User-Agent =%@", str);
        [request addRequestHeader:@"User-Agent" value:str];
    }

    [super send:request];
}

- (TBErrorDescription *) getErrorDescription :(ASIHTTPRequest *) request {
    TBErrorDescription *tbd = [[TBErrorDescription alloc] init];
    tbd.errorCode = request.responseStatusCode;
    tbd.errorMessage = request.error.description;
    tbd.isCancelled = request.isCancelled;
    
    if (tbd.errorCode>=400 && tbd.errorCode<500) {
        NSString *str = request.responseString;
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *dict =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                          error:&error];
        tbd.userInfo = dict;
    }
  
    return tbd;
}

@end