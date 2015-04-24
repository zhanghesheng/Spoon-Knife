//
//  TBErrorLog.h
//  universalT800
//
//  Created by fei lu on 12-12-12.
//  Copyright (c) 2012年 com.tuan800.iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBBaseNetworkApi.h"
@protocol TBUncaughtExceptionHandlerDelegate <TBBaseNetworkDelegate>
@optional 
- (void)errorInfoFinish:(NSDictionary *)params;
@end

@interface TBErrorLog : TBBaseNetworkApi<ASIHTTPRequestDelegate>
{
    BOOL dismissed;
    NSString *_errorMsg;
}
- (void)errorInfo:(NSDictionary *)params;
@property(nonatomic, strong) NSString *errorMsg;
@end
void InstallTBUncaughtExceptionHandler();

