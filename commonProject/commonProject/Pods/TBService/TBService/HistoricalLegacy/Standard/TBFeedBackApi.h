//
//  TBFeedBackApi.h
//  Core
//
//  Created by enfeng yang on 12-2-21.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBBaseNetworkApi.h"

@protocol TBFeedBackApiDelegate <TBBaseNetworkDelegate>
@optional 
- (void)feedbackFinish:(NSDictionary *)params;
- (void)feedbackV2Finish:(NSDictionary *)params;
- (void)getFeedbackReplyFinish:(NSDictionary *)params;
@end

@interface TBFeedBackApi :  TBBaseNetworkApi<ASIHTTPRequestDelegate>
{
    NSString *_baseUrlFeedBackV2;
}

@property (nonatomic,copy) NSString *baseUrlFeedBackV2;

- (void)feedback:(NSDictionary *)params;
- (void)feedbackV2:(NSDictionary *)params;
- (void)feedbackPay:(NSDictionary *)params;
- (void)feedbackCorrection:(NSDictionary *)params;
- (void)getFeedbackReply:(NSDictionary *)params;

@end
