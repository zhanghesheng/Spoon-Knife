//
//  TBShareWeixinModel.m
//  universalT800
//
//  Created by enfeng on 13-11-26.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "WXApiObject.h"
#import "WXApi.h"
#import "TBShareWeixinModel.h"
#import "TBUI/TBUI.h"

#import "TBShareKitConstant.h"

@interface TBShareWeixinModel () <UIAlertViewDelegate>

- (void)sendMessage;
@end

@implementation TBShareWeixinModel

- (void)onResp:(NSNotification *)note {
    BaseResp *resp = note.userInfo[@"resp"];
    NSNumber *wxSceneNum = self.sendParams[@"WXScene"];

    int wxScene = wxSceneNum.intValue;

    //写log wxScene
    switch (wxScene) {
        case WXSceneSession: {
            //
        }
            break;
        case WXSceneTimeline: {
            //朋友圈
        }
            break;
        default:
            break;
    }

    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        NSString *message = nil;

        switch (resp.errCode) {
            case WXSuccess: {

            }

                break;
            case WXErrCodeCommon: {
                message = @"发送失败";
            }
                break;
            case WXErrCodeUserCancel: {

            }
                break;
            case WXErrCodeSentFail: {
                message = @"发送失败";
            }
                break;
            case WXErrCodeAuthDeny: {
                message = @"发送失败";
            }
                break;
            case WXErrCodeUnsupport: {
                message = @"发送失败";
            }
                break;
            default: {
                message = @"发送失败";
            }
                break;
        }
        if (resp.errCode == WXSuccess) {
            NSDictionary *dict = @{
                    @"message" : @"发送成功"
            };

            [self completionCallBack:dict];
        }
        else {
            NSDictionary *dict = nil;
            if (message) {
                dict = @{
                        @"message" : message
                };
            }

            [self failureCallBack:dict];
        }

    }
    else if ([resp isKindOfClass:[SendAuthResp class]]) {
        NSDictionary *dict = @{
                @"message" : @"发送失败"
        };
        [self failureCallBack:dict];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithAppId:(NSString *)appId
             appkey:(NSString *)appKey
       appSecretKey:(NSString *)appSecretKey
        callBackUrl:(NSString *)callBackUrl {
    self = [super initWithAppId:appId
                         appkey:appKey
                   appSecretKey:appSecretKey
                    callBackUrl:callBackUrl];
    if (self) {
        [[NSNotificationCenter defaultCenter]
                addObserver:self
                   selector:@selector(onResp:)
                       name:TBBAppWeixinDidResponseNotification
                     object:nil];
    }
    return self;
}

-(BOOL)isWeixinInstalled{
    return [WXApi isWXAppInstalled];
}

- (void)sendContent:(NSDictionary *)params
         completion:(TBShareModelCallback)completion
            failure:(TBShareModelCallback)failure {
    [super sendContent:params completion:completion failure:failure];

    if (params) {
        self.sendParams = params;
        self.shareVo = params[@"shareVo"];
    }

    if (!self.sendParams) {
        return;
    }

    // 检查微信是否已被用户安装
    if ([WXApi isWXAppInstalled]) {

        [self sendMessage];
    } else {
        [self failureCallBack:nil];

        // 没有安装微信
        UIAlertView *alertUpdate = [[UIAlertView alloc] initWithTitle:nil
                                                              message:@"您还没有安装微信，是否立即下载？"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                                    otherButtonTitles:@"立即下载", nil];
        [alertUpdate show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
    }
}

- (void)sendMessage {
    NSString *title = self.shareVo.title;
    NSString *content = self.shareVo.message;
    NSString *imageUrl = self.shareVo.imageNormal;
    NSString *shareUrl = self.shareVo.shareUrl;
    NSNumber *wxSceneNum = self.sendParams[@"WXScene"];

    if (wxSceneNum.intValue == WXSceneTimeline) {
        //title = content;
    }

    NSNumber *dealId = self.sendParams[@"dealId"];

    int wxScene = wxSceneNum.intValue;

    WXMediaMessage *message = [WXMediaMessage message];

    NSString *errorMessage = nil;
    if (!content) {
        errorMessage = @"分享内容不能为空";
    } else if (!shareUrl) {
        errorMessage = @"分享url不能为空";
    }
    if (errorMessage) {
        NSDictionary *dict = @{
                @"message" : errorMessage
        };
        [self failureCallBack:dict];
        return;
    }
    if (!title) {
        message.title = content;
    } else {
        message.title = title;
    }
    message.description = content;

    if (dealId) {
        shareUrl = [NSString stringWithFormat:@"http://m.tuan800.com/hz/weixin?id=%@", dealId];
    }

    NSString *retUrl = [self convertImageUrl:imageUrl needDefaultImage:YES];
    if (!retUrl) {
        imageUrl = self.sendParams[@"imgUrlNormal"];
        imageUrl = [self convertImageUrl:imageUrl needDefaultImage:YES];
    } else {
        imageUrl = retUrl;
    }

    if (imageUrl) {
        dispatch_queue_t mainQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(mainQueue, ^(void) {
//            TBURLCache *cache = [TBURLCache sharedCache];
//            NSData *imgData = [cache dataForURL:imageUrl]; //缓存的数据太大
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];

            CGFloat length = 0;
            UIImage *image = nil;

            if (!imgData) {
//                NSLog(@"imgData不符合格式");
//                return ;
            } else {
                length = imgData.length / 1024.0f;
                image = DataToImage(imgData);
                if (image == nil) {
//                    NSLog(@"image不符合格式");
                }
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImage *image1 = image;
                NSData *data2 = imgData;
                if (length > 32) {
                    CGFloat maxWidth = 100;
              
                    CGFloat height = (maxWidth * image.size.height) / image.size.width;
                    CGSize size = CGSizeMake(maxWidth, height);
                    image1 = [image imageScaleToSize:size];
                    
                     data2 = UIImageJPEGRepresentation(image1, .8);
                    int length2 = data2.length / 1024.0f;
                    if (length2>32) {
                        NSDictionary *dict = @{
                                               @"message" : @"图片太大，分享图片不能超过32K"
                                               };
                        [self failureCallBack:dict];
                        return;

                    }
                }

                if (image) {
//                    [message setThumbImage:image];
                    [message setThumbData:data2];
                }
                NSDictionary *dict2 = @{
                        @"hideLoading" : @""
                };
                [self failureCallBack:dict2];

                WXWebpageObject *ext = [WXWebpageObject object];
                ext.webpageUrl = shareUrl;
                message.mediaObject = ext;

                SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                req.bText = NO;
                req.message = message;
                req.scene = wxScene;

                BOOL ret = [WXApi sendReq:req];
                if (!ret) {
                    NSDictionary *dict = @{
                            @"message" : @"微信调用失败"
                    };
                    [self failureCallBack:dict];
                }
            });
        });
    } else {
        NSDictionary *dict2 = @{
                @"hideLoading" : @""
        };
        [self failureCallBack:dict2];

        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = shareUrl;
        message.mediaObject = ext;

        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = wxScene;

        [WXApi sendReq:req];
    }
}


@end
