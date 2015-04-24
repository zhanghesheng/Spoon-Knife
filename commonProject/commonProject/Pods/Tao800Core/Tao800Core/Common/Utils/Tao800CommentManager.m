//
//  TBBCommentManager.m
//  universalT800
//
//  Created by hanyuan on 13-12-30.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "Tao800CommentManager.h"
#import "Tao800StaticConstant.h"

/*
 1 有了你的鼓励和支持，我们会更有动力提供更多物美价廉的商品2 有了你的鼓励和支持，我们会更有动力提供更多物美价廉的商品3 有了你的鼓励和支持，我们会更有动力提供更多物美价廉的商品4 有了你的鼓励和支持，我们会更有动力提供更多物美价廉的商品5
 */
NSString *const massageForNew = @"有了你的鼓励和支持，我们会更有动力提供更多物美价廉的商品";
NSString *const massageForOld = @"有了你的鼓励和支持，我们会做得更好";

@interface Tao800CommentManager ()
@property(nonatomic, strong) Tao800AlertView *alertView;
@end

@implementation Tao800CommentManager

- (void)finishCallBack:(BOOL)didClose {
    if (self.callBack) {
        self.callBack(didClose);
    }
}

- (id)init {
    self = [super init];
    if (self) {
        self.commentViewShow = NO;
    }
    return self;
}

- (void)showCommentInfo:(NSString *)message {
    NSInteger launchCount = 0;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    launchCount = [userDefault integerForKey:@"launchCount"];
    if (launchCount < 0) {
        [self finishCallBack:YES];
        return;
    }
    
    ++launchCount;
    [userDefault setInteger:launchCount forKey:@"launchCount"];
    [userDefault synchronize];
    
    if (self.commentViewShow) {
        //如果是走的Tao800ForwardSingleton队列应该不需要这个条件
        [self finishCallBack:YES];
        return;
    }
    
    if (launchCount > 1) {
        self.commentViewShow = YES;
        
        Tao800AlertView *alertViewTmp = [[Tao800AlertView alloc] initWithTitle:nil
                                                                        detail:message
                                                                      delegate:self
                                                                         style:Tao800AlertViewStyleWithCheckBtn
                                                                  buttonTitles:@"鼓励一下", @"残忍拒绝", nil];
        alertViewTmp.tag = 10000;
        //alertViewTmp.greetingView.titleLabel.text = @"hi,我是产品经理小雯";
        //alertViewTmp.greetingView.greetingImageView.urlPath = @"bundle://alert_headc@2x.png";
        [alertViewTmp greetingStyleSet:Tao800GreetingStyleChanPin];
        //alertViewTmp.detailLabel.textAlignment = NSTextAlignmentLeft;
        [alertViewTmp.checkBtn addTarget:self action:@selector(neverAskBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [alertViewTmp show];
        
        self.alertView = alertViewTmp;
    } else {
        [self finishCallBack:YES];
    }
}

- (void)Tao800AlertView:(Tao800AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger tag = alertView.tag;
    
    if (1 == buttonIndex) {
        if (tag == 10000) {
            if (alertView.checkBtn.selected) {
                NSInteger launchCount = -1;
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setInteger:launchCount forKey:@"launchCount"];
                [userDefault synchronize];
            }
            self.commentViewShow = NO;
            [self finishCallBack:YES];
        }
        return;
    }
    
    switch (tag) {
        case 10000: {
            self.commentViewShow = NO;
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppStoreCommentUrl]];
            NSString *appURL = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",@"502804922"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL]];
            
            NSInteger launchCount = -1;
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setInteger:launchCount forKey:@"launchCount"];
            [userDefault synchronize];
            
            [self finishCallBack:YES];
        }
            break;
    }
}

- (void)neverAskBtnClicked:(id)sender {
    UIButton* button = (UIButton*)sender;
    button.selected = !button.selected;
    return;
    
//    NSInteger launchCount = -1;
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    [userDefault setInteger:launchCount forKey:@"launchCount"];
//    [userDefault synchronize];
//    
//    self.commentViewShow = NO;
//    [self.alertView close];
//    
//    [self finishCallBack:YES];
}

- (void)showCommentInfoForNewUser {
    [self showCommentInfo:massageForNew];
}

- (void)showCommentInfoForOldUser {
    [self showCommentInfo:massageForOld];
}

- (void)showCommentInfo:(BOOL)firstInstall callBack:(Tao800CommentManagerCallback)callBackParam {
    self.callBack = callBackParam;
    
    if (firstInstall) {
        [self showCommentInfoForNewUser];
    } else {
        [self showCommentInfoForOldUser];
    }
}


@end
