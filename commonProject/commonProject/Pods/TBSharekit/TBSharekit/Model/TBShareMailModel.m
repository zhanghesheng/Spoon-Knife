//
// Created by enfeng on 14-1-23.
// Copyright (c) 2014 com.tuan800.framework.shareKit. All rights reserved.
//

#import "TBShareMailModel.h"
#import <MessageUI/MessageUI.h>

@interface TBShareMailModel () <MFMailComposeViewControllerDelegate>

@end

@implementation TBShareMailModel {

}

- (void)sendContent:(NSDictionary *)params
         completion:(TBShareModelCallback)completion
            failure:(TBShareModelCallback)failure {
    [super sendContent:params completion:completion failure:failure];

    self.shareVo = params[@"shareVo"];

    //避免键盘不显示
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.windowLevel = UIWindowLevelNormal;
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    if (composer == nil) {
        return;
    }
    NSString *shareContent = self.shareVo.message;
    NSString *title = self.shareVo.title;

    composer.mailComposeDelegate = self;
    NSString *content = title;
    [composer setSubject:content];
    NSString *emailBody = shareContent;
    [composer setMessageBody:emailBody isHTML:NO];

    [composer setToRecipients:[NSArray arrayWithObjects:@"", nil]];
    //    [composer.setSubject.placeholder = [NSLocalizedString(@"This is a placeholder",)];
    [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];

    [self popViewCTL:composer];
}


- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    switch (result) {
        case MFMailComposeResultCancelled: {
            NSDictionary *dict = @{
                    @"message" : @"未发送邮件"
            };
            [self failureCallBack:dict];
        }
            break;
        case MFMailComposeResultFailed: {
            NSDictionary *dict = @{
                    @"message" : @"邮件发送失败"
            };
            [self failureCallBack:dict];
        }
            break;
        case MFMailComposeResultSent: {
            NSDictionary *dict = @{
                    @"message" : @"邮件发送成功"
            };
            [self completionCallBack:dict];
        }
            break;
        case MFMailComposeResultSaved: {
            NSDictionary *dict = @{
                    @"message" : @"邮件已保存"
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