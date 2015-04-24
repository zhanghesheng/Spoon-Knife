//
//  Tao800UpgradeManage.m
//  tao800
//
//  Created by enfeng on 14/12/9.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800UpgradeManage.h"
#import "Tao800FunctionCommon.h"
#import "Tao800AlertView.h"
#import "Tao800ConfigBVO.h"
#import "Tao800NotifycationConstant.h"
#import "Tao800StyleSheet.h"

NSString *const Tao800NeverAsk = @"Tao800NeverAsk";

@interface Tao800UpgradeManage () <Tao800AlertViewDelegate>
@property(nonatomic, weak) Tao800AlertView *alertView;
@end

@implementation Tao800UpgradeManage

/**
 * 将版本号转换为整数 如3.5.2, 转换后为 300500200
 */
+ (long long)getVersionNumber:(NSString *)version {
    NSArray *sysArr = [version componentsSeparatedByString:@"."];
    NSMutableArray *arr1 = [NSMutableArray arrayWithArray:sysArr];
    if (arr1.count==1) {
        //不太应该出现这种情况
        [arr1 addObject:@"0"];
        [arr1 addObject:@"0"];
    } else if (arr1.count==2) {
        [arr1 addObject:@"0"];
    }
    
    long long m1 = 0;
    int i = (int) (arr1.count - 1);
    for (NSString *s1 in arr1) {
        int p = pow(1000, i);
        long seg = s1.intValue * 100 * p;
        m1 = m1 + seg;
        i--;
    }
    
    return m1;
}

+ (BOOL) enableShowUpgradeTip {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    NSString *minus = dm.configBVO.softVo.minimumSystemVersion;
    
    if (minus == nil || minus.length<1) {
        return YES;
    }
    
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
    long long m1 = [Tao800UpgradeManage getVersionNumber:minus];
    long long m2 = [Tao800UpgradeManage getVersionNumber:sysVersion];
    
    return m2>=m1;
}

+ (void) resetNeverAskValue {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:0 forKey:Tao800NeverAsk];
    [userDefault synchronize];
}

- (void)neverAskBtnClicked:(id)sender {
    UIButton* button = (UIButton*)sender;
    button.selected = !button.selected;
    return;
    
//    NSInteger showFlag = -1;
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    [userDefault setInteger:showFlag forKey:Tao800NeverAsk];
//    [userDefault synchronize];
//    
//    __weak Tao800UpgradeManage *instance = self;
//    [self.alertView close:.2
//               completion:^{
//                   if (instance.finishCallback) {
//                       instance.finishCallback(NO);
//                   }
//               }];
}

- (void) closeCallback:(BOOL) didClose {
    if (self.finishCallback) {
        self.finishCallback(didClose);
    }
}

- (void)getCheckUpApp {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    Tao800SoftVo *softVo = dm.configBVO.softVo;
    
    NSInteger showFlag = 0;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    showFlag = [userDefault integerForKey:Tao800NeverAsk];
    
    switch (CheckUpdate(softVo)) {
    //          switch (TBAppUpdateApi_Update_Flag_HAVE_UPDATE_APP) {
        case TBAppUpdateApi_Update_Flag_NO_UPDATE_APP:
            [self closeCallback:YES];
            break;
        case TBAppUpdateApi_Update_Flag_HAVE_UPDATE_APP: {
            if (showFlag != -1) {
                Tao800AlertView *tipsTmp = [[Tao800AlertView alloc] initWithTitle:@"好久不见,我们又有新版本啦～"
                                                                           detail:softVo.softDescription
                                                                         delegate:(id) self
                                                                            style:Tao800AlertViewStyleWithCheckBtn
                                                                     buttonTitles:@"体验新版本", @"暂不升级", nil];
                tipsTmp.tag = TBAppUpdateApi_Update_Flag_HAVE_UPDATE_APP;
                tipsTmp.greetingView.titleLabel.textColor = TEXT_COLOR_BLACK2;
                [tipsTmp greetingStyleSet:Tao800GreetingStyleChanPin];
                [tipsTmp.checkBtn addTarget:self
                                     action:@selector(neverAskBtnClicked:)
                           forControlEvents:UIControlEventTouchUpInside];
                tipsTmp.enableClose = NO;
                [tipsTmp show];
                
                self.alertView = tipsTmp;
            }
        }
            break;
        case TBAppUpdateApi_Update_Flag_MUST_UPDATE_APP: {
            Tao800AlertView *tipsTmp = [[Tao800AlertView alloc] initWithTitle:nil
                                                                       detail:softVo.softDescription
                                                                     delegate:(id) self
                                                                        style:Tao800AlertViewStyleDefault
                                                                 buttonTitles:@"体验新版本", nil];
            tipsTmp.tag = TBAppUpdateApi_Update_Flag_MUST_UPDATE_APP;
            [tipsTmp greetingStyleSet:Tao800GreetingStyleChanPin];
            tipsTmp.enableClose = NO;
            [tipsTmp show];
            self.alertView = tipsTmp;
        }
            break;
        default:
            break;
    }
    
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:Tao800CheckConfigFinishNotification
     object:nil];
}

- (void)checkUpdate:(Tao800UpgradeFinishCallback)callback {
    self.finishCallback = callback;
    [self getCheckUpApp];
}

- (void)Tao800AlertView:(Tao800AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    Tao800SoftVo *softVo = dm.configBVO.softVo;
    
    switch (alertView.tag) {
        case TBAppUpdateApi_Update_Flag_HAVE_UPDATE_APP: {
            if (buttonIndex == 1) {
                __weak Tao800UpgradeManage *instance = self;
                if (alertView.checkBtn.selected) {
                    NSInteger showFlag = -1;
                    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                    [userDefault setInteger:showFlag forKey:Tao800NeverAsk];
                    [userDefault synchronize];
                }
                
                [self.alertView close:.2
                           completion:^{
                               [instance closeCallback:YES];
                           }];
            } else {
                __weak Tao800UpgradeManage *instance = self;
                [self.alertView close:0
                           completion:^{
                               [instance closeCallback:YES];
                           }];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:softVo.url]];
            }
        }
            break;
        case TBAppUpdateApi_Update_Flag_MUST_UPDATE_APP: {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:softVo.url]];
        }
            break;
        default:
            break;
    }
}

@end
