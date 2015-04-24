//
//  TBShareBaseModel.m
//  universalT800
//
//  Created by enfeng on 13-11-26.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <TBUI/TBUIViewController+Tip.h>
#import "TBShareBaseModel.h"
#import "TBCore/TBCoreMacros.h"

@interface TBShareBaseModel ()

@end

@implementation TBShareBaseModel

- (id)initWithAppId:(NSString *)appId
             appkey:(NSString *)appKey
       appSecretKey:(NSString *)appSecretKey
        callBackUrl:(NSString *)callBackUrl {
    self = [super init];
    if (self) {
        self.appId = appId;
        self.appKey = appKey;
        self.appSecretKey = appSecretKey;
        self.callBackUrl = callBackUrl;

        self.methodHandlers = [NSMutableDictionary dictionaryWithCapacity:2];
        self.appIconUrl = @"http://p12.tuan800.net/static_image/static_image/0003/0977/webp-4564716c-2f28-4014-954c-5439a5644bba.jpg";
    }
    return self;
}

- (void)callback:(NSString *)handlerName params:(NSDictionary *)params {
    TBShareModelCallback handler = self.methodHandlers[handlerName];
    if (handler) {
        TBShareModelCallback callback = [handler copy];
        NSString *hideLoading = params[@"hideLoading"];
        //释放当前的block, 不要放在callback后，避免callback中嵌套的调用
        if (!hideLoading) {
            [self.methodHandlers removeAllObjects];
        }

        callback(params);
    } else {
        TBDPRINT(@"回调失败：%@", handlerName);
    }
}

- (void)popViewCTL:(UIViewController *)controller {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.windowLevel = UIWindowLevelNormal;

    UIViewController *viewCTL = window.rootViewController;
    if (viewCTL.topViewController) {
        viewCTL = viewCTL.topViewController;
    }
    UIViewController*ctl = [viewCTL presentedViewController];
    if (ctl) {
        viewCTL = ctl;
    }
    
    [viewCTL presentViewController:controller animated:YES completion:^{
    }];
}

- (void)loginFailureCallBack:(NSDictionary *)params {
    [self callback:@"login_failure" params:params];
}

- (void)loginCompletionCallBack:(NSDictionary *)params {
    [self callback:@"login_completion" params:params];
}

- (void)logoutFailureCallBack:(NSDictionary *)params {
    [self callback:@"logout_failure" params:params];
}

- (void)logoutCompletionCallBack:(NSDictionary *)params {
    [self callback:@"logout_completion" params:params];
}

- (void)getUserInfo:(NSDictionary *)params
         completion:(TBShareModelCallback)completion
            failure:(TBShareModelCallback)failure {

}

- (BOOL)authorized {
    return NO;
}

- (void)login:(NSDictionary *)params
   completion:(TBShareModelCallback)completion
      failure:(TBShareModelCallback)failure {
    self.methodHandlers[@"login_completion"] = completion;
    self.methodHandlers[@"login_failure"] = failure;
}

- (void)logout:(NSDictionary *)params
    completion:(TBShareModelCallback)completion
       failure:(TBShareModelCallback)failure {
    self.methodHandlers[@"logout_completion"] = completion;
    self.methodHandlers[@"logout_failure"] = failure;
}


- (void)sendContent:(NSDictionary *)params
         completion:(TBShareModelCallback)completion
            failure:(TBShareModelCallback)failure {
    self.methodHandlers[@"send_completion"] = completion;
    self.methodHandlers[@"send_failure"] = failure;
}

- (void)failureCallBack:(NSDictionary *)params {
    [self callback:@"send_failure" params:params];
}

- (void)completionCallBack:(NSDictionary *)params {
    [self callback:@"send_completion" params:params];
}

- (NSString *)convertImageUrl:(NSString *)imgUrl needDefaultImage:(BOOL)needDefaultImage {
    if (imgUrl == nil || imgUrl.length < 1) {
        //团购大全默认logo
        if (needDefaultImage) {
            return self.appIconUrl;
        }
        return nil;
    }

    NSString *ret = nil;
    NSString *str = [imgUrl lowercaseString];
    if ([str hasSuffix:@".webp"]) {
        ret = [imgUrl substringToIndex:imgUrl.length - 5];
        str = [ret lowercaseString];
        if ([str hasSuffix:@".jpg"]) {

        } else if ([str hasSuffix:@".png"]) {

        } else if ([str hasSuffix:@".gif"]) {

        } else if ([str hasSuffix:@".jpeg"]) {

        } else {
            ret = [NSString stringWithFormat:@"%@.jpg", ret];
        }
    } else {
        ret = imgUrl;
    }

    return ret;
}


- (void)didNetworkError:(NSDictionary *)params {
    NSDictionary *dict = @{
            @"message" : @"网络错误"
    };
    [self failureCallBack:dict];
}
@end
