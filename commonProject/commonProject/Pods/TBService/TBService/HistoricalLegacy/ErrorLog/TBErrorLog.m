//
//  TBErrorLog.m
//  universalT800
//
//  Created by fei lu on 12-12-12.
//  Copyright (c) 2012年 com.tuan800.iphone. All rights reserved.
//

#import "TBErrorLog.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "TBCore/TBCoreCommonFunction.h"


NSString * const TBErrorInfoUrl = @"http://m.api.tuan800.com/mobilelog/errorlog/ios";
NSString * const TBUncaughtExceptionHandlerSignalExceptionName = @"TBUncaughtExceptionHandlerSignalExceptionName";
NSString * const TBUncaughtExceptionHandlerSignalKey = @"TBUncaughtExceptionHandlerSignalKey";
NSString * const TBUncaughtExceptionHandlerAddressesKey = @"TBUncaughtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

const NSInteger TBUncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger TBUncaughtExceptionHandlerReportAddressCount = 5;

@implementation TBErrorLog
@synthesize errorMsg = _errorMsg;

-(void)dealloc{
   
}
#define MAX_CALLSTACK_DEPTH	(64)

+ (NSArray *)backtrace:(NSUInteger)depth
{
	NSMutableArray * array = [[NSMutableArray alloc] init];
	
	void * stacks[MAX_CALLSTACK_DEPTH] = { 0 };
    
	depth = backtrace( stacks, (depth > MAX_CALLSTACK_DEPTH) ? MAX_CALLSTACK_DEPTH : (uint)depth );
	if ( depth > 1 )
	{
		char ** symbols = backtrace_symbols( stacks, (uint)depth );
		if ( symbols )
		{
			for ( int i = 0; i < (depth - 1); ++i )
			{
				NSString * symbol = [NSString stringWithUTF8String:(const char *)symbols[1 + i]];
				if ( 0 == [symbol length] )
					continue;
                
				NSRange range1 = [symbol rangeOfString:@"["];
				NSRange range2 = [symbol rangeOfString:@"]"];
                
				if ( range1.length > 0 && range2.length > 0 )
				{
					NSRange range3;
					range3.location = range1.location;
					range3.length = range2.location + range2.length - range1.location;
					[array addObject:[symbol substringWithRange:range3]];
				}
				else
				{
					[array addObject:symbol];
				}					
			}
            
			free( symbols );
		}
	}
	
	return array;
}
NSString* getAppInfo()
{
    NSString *appInfo = [NSString stringWithFormat:@"App : %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\nUDID : %@\n",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         [UIDevice currentDevice].model,
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].systemVersion,
                    GetWifiMacAddress()];
    NSLog(@"Crash!!!! %@", appInfo);
    return appInfo;
}
- (void)errorInfo:(NSDictionary *)params{
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
    NSString *platform = @"iphone";
    NSString *os_version = [UIDevice currentDevice].systemVersion;
    NSString *product = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *app_version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *trackid = @"moniqudao";
    NSString *contact = @"";
    NSString *errorType = TBUncaughtExceptionHandlerSignalExceptionName;
    NSString *errorDetail = _errorMsg;
    NSURL *url = [NSURL URLWithString:TBErrorInfoUrl];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    [request setPostValue:platform forKey:@"platform"];
    [request setPostValue:os_version forKey:@"os_version"];
    [request setPostValue:product forKey:@"product"];
    [request setPostValue:app_version forKey:@"app_version"];
    [request setPostValue:trackid forKey:@"trackid"];
    [request setPostValue:contact forKey:@"contact"];
    [request setPostValue:errorType forKey:@"errorType"];
    [request setPostValue:errorDetail forKey:@"errorDetail"];
    request.serviceMethodFlag =APIFeedback;
    request.serviceData = params;
    [self send:request];
}
- (void)requestFinished:(TBASIFormDataRequest *)request {
    NSString *msg = @"日志发送成功，感谢您的反馈，您的软件如果继续运行可能不稳定，是否退出?";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"异常崩溃提示" message:msg delegate:self cancelButtonTitle:@"继续" otherButtonTitles:@"退出",nil];
    [alert setTag:1];
    [alert show];
}
- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
    switch (anAlertView.tag) {
        case 0:
            if (anIndex != anAlertView.cancelButtonIndex) {
//                NSString *urlStr = [NSString stringWithFormat:@"mailto://lufei@rd.tuan800.com?subject=异常崩溃报告&body=感谢您的配合!<br><br>%@<br>",_errorMsg];
//                NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//                [[UIApplication sharedApplication] openURL:url];
                [self errorInfo:nil];
            }
            break;
        case 1:
            if (anIndex != anAlertView.cancelButtonIndex) {
                dismissed = YES;
            }
            break;
            
        default:
            break;
    }
}

- (void)handleException:(NSException *)exception
{
    self.errorMsg = [[exception userInfo] objectForKey:TBUncaughtExceptionHandlerSignalKey];//错误详情
    NSString *msg = @"软件产生严重错误，对给您造成的不便深感抱歉，如您允许可以把错误日志发送给我们，我们会尽快解决！";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"异常崩溃提示" message:msg delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"发送错误报告",nil];
    [alert setTag:0];
    [alert show];
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    while (!dismissed)
    {
        for (NSString *mode in (__bridge NSArray *)allModes)
        {
            CFRunLoopRunInMode((__bridge CFStringRef)mode, 0.001, false);
        }
    }
    
    CFRelease(allModes);
    
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    if ([[exception name] isEqual:TBUncaughtExceptionHandlerSignalExceptionName])
    {
        kill(getpid(), [[[exception userInfo] objectForKey:TBUncaughtExceptionHandlerSignalKey] intValue]);
    }
    else
    {
        [exception raise];
    }
}

@end



void MySignalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal]forKey:TBUncaughtExceptionHandlerSignalKey];
    
    NSArray *callStack = [TBErrorLog backtrace:500];
    
    [userInfo setObject:callStack forKey:TBUncaughtExceptionHandlerAddressesKey];
    
    NSException *exception = [NSException exceptionWithName:TBUncaughtExceptionHandlerSignalExceptionName
                              reason:getAppInfo()
                              userInfo:[NSDictionary dictionaryWithObject:userInfo
                               forKey:TBUncaughtExceptionHandlerSignalKey]];
    
    [[[TBErrorLog alloc] init] performSelectorOnMainThread:@selector(handleException:) withObject:exception waitUntilDone:YES];
}

void InstallTBUncaughtExceptionHandler()
{
    signal(SIGABRT, MySignalHandler);
    signal(SIGILL, MySignalHandler);
    signal(SIGSEGV, MySignalHandler);
    signal(SIGFPE, MySignalHandler);
    signal(SIGBUS, MySignalHandler);
    signal(SIGPIPE, MySignalHandler);
}

