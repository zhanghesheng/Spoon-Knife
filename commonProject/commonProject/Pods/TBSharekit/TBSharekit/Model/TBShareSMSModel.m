//
// Created by enfeng on 13-11-26.
// Copyright (c) 2013 enfeng. All rights reserved.
//


#import <MessageUI/MessageUI.h>
#import "TBShareSMSModel.h"
#import "TBCore/TBCoreCommonFunction.h"
#import <UIKit/UIKit.h>

@interface TBShareSMSModel () <MFMessageComposeViewControllerDelegate>


@end

@implementation TBShareSMSModel {


}

- (void)sendContent:(NSDictionary *)params
         completion:(TBShareModelCallback)completion
            failure:(TBShareModelCallback)failure {
    [super sendContent:params completion:completion failure:failure];

    self.shareVo = params[@"shareVo"];

    //避免键盘不显示
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.windowLevel = UIWindowLevelNormal;

    NSString *shareContent = self.shareVo.message;
    NSRange range = [shareContent rangeOfString:self.shareVo.shareUrl];
    if (self.shareVo.shareUrl.length > 0 && range.length<1) {
        shareContent = [NSString stringWithFormat:@"%@ %@", shareContent, self.shareVo.shareUrl];
    }

    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if ([MFMessageComposeViewController canSendText]) {

        controller.body = shareContent;
        if (!RequireSysVerGreaterOrEqual(@"7.0")) {
            controller.recipients = [NSArray array];
        } else {
//            controller.recipients = [NSArray arrayWithObjects:@"", nil];
        }
        controller.messageComposeDelegate = self;

        [self popViewCTL:controller];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled: {
            NSDictionary *dict = @{
                    @"message" : @"未发送短信"
            };
            [self failureCallBack:dict];
        }
            break;
        case MessageComposeResultFailed: {
            NSDictionary *dict = @{
                    @"message" : @"短信发送失败"
            };
            [self failureCallBack:dict];
        }
            break;
        case MessageComposeResultSent: {
            NSDictionary *dict = @{
                    @"message" : @"短信发送成功"
            };
            [self completionCallBack:dict];
        }
            break;
        default: {
            NSDictionary *dict = @{
                    @"message" : @"未知错误"
            };
            [self failureCallBack:dict];
        }
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:^{}];
}

@end