//
//  Tao800CrashHandle.m
//  tao800
//
//  Created by Rose on 15/1/15.
//  Copyright (c) 2015年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800CrashHandle.h"
#import <KSCrash/KSCrash.h> // TODO: Remove this
#import <KSCrash/KSCrashInstallationStandard.h>
#import <KSCrash/KSCrashInstallationQuincyHockey.h>
#import <KSCrash/KSCrashInstallationEmail.h>
#import <KSCrash/KSCrashInstallationVictory.h>
#import <KSCrash/KSCrashAdvanced.h>

@implementation Tao800CrashHandle

- (void) installCrashHandler
{
    // Create an installation (choose one)
    //    KSCrashInstallation* installation = [self makeStandardInstallation];
    
    //KSCrashInstallation* installation = [self makeEmailInstallation];
    
    //    KSCrashInstallation* installation = [self makeHockeyInstallation];
    //    KSCrashInstallation* installation = [self makeQuincyInstallation];
    //    KSCrashInstallation *installation = [self makeVictoryInstallation];
    
    //    KSCrashInstallationEmail* installation = [KSCrashInstallationEmail sharedInstance];
    //    installation.recipients = @[@"shencong@rd.tuan800.com"];
    //    [installation setReportStyle:KSCrashEmailReportStyleApple useDefaultFilenameFormat:YES];
    
    // Install the crash handler. This should be done as early as possible.
    // This will record any crashes that occur, but it doesn't automatically send them.
    //    [installation install];
    KSCrash* handler = [KSCrash sharedInstance];
    
    [KSCrash sharedInstance].deleteBehaviorAfterSendAll = KSCDeleteOnSucess; // TODO: Remove this
    [self configureAdvancedSettings];
    
    [handler install];
    
}

- (void) configureAdvancedSettings
{
    KSCrash* handler = [KSCrash sharedInstance];
    
    // Settings in KSCrash.h
    //handler.zombieCacheSize = 16384;
    //handler.deadlockWatchdogInterval = 8;
    //handler.userInfo = @{@"someKey": @"someValue"};
    //handler.zombieCacheSize = 16384;
    //handler.deadlockWatchdogInterval = 5.0f;
    //handler.searchThreadNames = YES;
    //handler.searchQueueNames = YES;
    //handler.printTraceToStdout = YES;
    
    // Don't delete after send for this demo.
    //handler.deleteBehaviorAfterSendAll = KSCDeleteNever;
    
    handler.onCrash = advanced_crash_callback;
    handler.handlingCrashTypes = KSCrashTypeProductionSafe;
    //handler.handlingCrashTypes
    //handler.printTraceToStdout = YES;
    //handler.searchThreadNames = YES;
    //handler.searchQueueNames = YES;
    
    // Do not introspect class SensitiveInfo (see MainVC)
    // When added to the "do not introspect" list, the Objective-C introspector
    // will only record the class name, not its contents.
    //handler.doNotIntrospectClasses = @[@"SensitiveInfo"];
}

static void advanced_crash_callback(const KSCrashReportWriter* writer)
{
    // You can add extra user data at crash time if you want.
    //NSLog(@"advanced_crash_callback");
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    [userDefault setBool:YES forKey:@"advanced_crash_callback"];
//    [userDefault synchronize];
    writer->addBooleanElement(writer, "some_bool_value", NO);
}


@end
