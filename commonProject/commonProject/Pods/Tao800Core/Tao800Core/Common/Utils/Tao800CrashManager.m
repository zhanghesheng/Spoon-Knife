//
//  Tao800CrashManager.m
//  tao800
//
//  Created by Rose on 15/1/6.
//  Copyright (c) 2015年 com.tuan800.tao800iphone. All rights reserved.
//
#import <KSCrash/KSCrash.h> // TODO: Remove this
#import <KSCrash/KSCrashInstallationStandard.h>
#import <KSCrash/KSCrashInstallationQuincyHockey.h>
#import <KSCrash/KSCrashInstallationEmail.h>
#import <KSCrash/KSCrashInstallationVictory.h>
#import <KSCrash/KSCrashAdvanced.h>

#import "Tao800CrashManager.h"
#import "Tao800StaticConstant.h"
#import "CrashTesterCommands.h"
#import "Tao800WirelessService.h"
#import "Tao800DataModelSingleton.h"

NSString *const massageForCrash = @"很抱歉给你带来不好的体验，我们会尽快修复哦～";

@interface Tao800CrashManager ()
@property(nonatomic, strong) Tao800AlertView *alertView;
@property(nonatomic, strong) Tao800WirelessService *wirelessService;
@end

@implementation Tao800CrashManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.wirelessService = [[Tao800WirelessService alloc] init];
    }
    return self;
}

- (void)finishCallBack:(BOOL)didClose {
    if (self.callBack) {
        self.callBack(didClose);
    }
}

- (void)showCrashInfo{
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    BOOL crash = [userDefault integerForKey:@"advanced_crash_callback"];
    NSUInteger crash = [[KSCrash sharedInstance] reportCount];
//    if (crash) {
    if (crash > 0) {
        Tao800AlertView *alertViewTmp = [[Tao800AlertView alloc] initWithTitle:nil
                                                                        detail:massageForCrash
                                                                      delegate:self
                                                                         style:Tao800AlertViewStyleDefault
                                                                  buttonTitles:@"朕知道了", nil];
        alertViewTmp.tag = 10000;
        [alertViewTmp greetingStyleSet:Tao800GreetingStyleYanFa];
        [alertViewTmp show];
        self.alertView = alertViewTmp;
    }else{
        [self finishCallBack:YES];
        return;
    }
}

- (void)Tao800AlertView:(Tao800AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger tag = alertView.tag;
    switch (tag) {
        case 10000: {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"advanced_crash_callback"];
            [userDefault synchronize];
            /*
            KSCrashInstallationEmail* installation = [KSCrashInstallationEmail sharedInstance];
           
            [installation sendAllReportsWithCompletion:^(NSArray* reports, BOOL completed, NSError* error)
             {
                 if(completed)
                 {
                     NSLog(@"Sent %d reports", (int)[reports count]);
                 }
                 else
                 {
                     NSLog(@"Failed to send reports: %@", error);
                 }
             }];
             */
            __weak Tao800CrashManager* instance = self;
            Tao800DataModelSingleton* dm = [Tao800DataModelSingleton sharedInstance];
            [CrashTesterCommands printSideBySide:^(NSArray *filteredReports, BOOL completed, NSError *error) {
                if(completed)
                {
                    /*
                     1.平台名:platform
                     2.系统版本:os_version
                     3.软件名:product
                     4.软件版本:app_version
                     5.渠道号: trackid
                     6.用户联系方式:contact
                     7.错误类型:errorType
                     8.错误详情:errorDetail
                     */
                    TBLogAnalysisBaseHeader* header = [dm getHeaderVo];
                    NSLog(@"justprint %d reports", (int)[filteredReports count]);
                    NSString* reports = [userDefault objectForKey:@"KSCrash_filterReports"];
                    NSLog(@"KSCrash_filterReports =%@", reports);
                    //发送错误日志到服务器
                    NSMutableDictionary* mutable = [NSMutableDictionary dictionaryWithCapacity:5];
                    if(header.platform){
                        [mutable setValue:header.platform forKey:@"platform"];
                    }
                    if (header.phoneVersion) {
                        [mutable setValue:header.phoneVersion forKey:@"os_version"];
                    }
                    [mutable setValue:@"tao800" forKey:@"product"];
                    if (header.appVersion) {
                        [mutable setValue:header.appVersion forKey:@"app_version"];
                    }
                    if (header.partner) {
                        [mutable setValue:header.partner forKey:@"trackid"];
                    }
                    [mutable setValue:@"" forKey:@"contact"];
                    [mutable setValue:@"" forKey:@"errorType"];
                    if(reports){
                        [mutable setValue:reports forKey:@"errorDetail"];
                    }
                    [instance.wirelessService uploadErrorInfo:mutable completion:^(NSDictionary *dic) {
                        //NSLog(@"sending ok!");
                        [[KSCrash sharedInstance] deleteAllReports];
                    } failure:^(TBErrorDescription *err) {
                        
                    }];
                    
                }
                else
                {
                    NSLog(@"Failed to send reports: %@", error);
                }
            }];
            [self finishCallBack:YES];
        }
            break;
    }
}


- (void)showCrashInfo:(BOOL)firstInstall callBack:(Tao800CrashManagerCallback)callBackParam {
    self.callBack = callBackParam;
    [self showCrashInfo];
}
@end
