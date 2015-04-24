//
//  TBCommonFunction.m
//  Core
//
//  Created by enfeng yang on 12-6-12.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import "TBCoreCommonFunction.h"

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "TBCoreMacros.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

//参考
//https://github.com/carlj/CJAMacros/blob/master/CJAMacros/CJAMacros.h
#define DEVICE_SCREEN_HAS_LENGTH(_frame, _length) ( fabsf( MAX(CGRectGetHeight(_frame), CGRectGetWidth(_frame)) - _length) < FLT_EPSILON )
#define TBSCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define TBSCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#import "TBURLCache.h"

NSString *GetIPAddress(void) {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
// retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
// Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
// Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
// Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *) temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
// Free memory
    freeifaddrs(interfaces);
    return address;
}

NSString *GetWifiMacAddress(void) {
    return GetWifiMacAddressWithSeparator(@":");
}

NSString *GetWifiMacAddressWithSeparator(NSString *sep) {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;

    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;

    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }

    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }

    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        free(buf);
        return NULL;
    }

    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }

    ifm = (struct if_msghdr *) buf;
    sdl = (struct sockaddr_dl *) (ifm + 1);
    ptr = (unsigned char *) LLADDR(sdl);
    NSString *outString = [NSString stringWithFormat:
            @"%02x%@%02x%@%02x%@%02x%@%02x%@%02x",
            *ptr,
            sep,
            *(ptr + 1),
            sep,
            *(ptr + 2),
            sep,
            *(ptr + 3),
            sep,
            *(ptr + 4),
            sep,
            *(ptr + 5)];
    free(buf);
    return [outString uppercaseString];
}

BOOL RequireSysVerGreaterOrEqual(NSString *reqSysVer) {
    BOOL ret = NO;
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending) {
        ret = YES;
    }
    return ret;
}

BOOL NeedResetUIStyleLikeIOS7(void) {

    BOOL isAfterVersion7 = RequireSysVerGreaterOrEqual(@"7");
    if (!isAfterVersion7) {
        return NO;
    }

    //如果不是通过sdk7编译的，那么也不需要设置坐标

#ifdef __IPHONE_7_0
    return YES;
#else
            return NO;
#endif

}

UIImage *TBImage(NSString *url) {
    return [[TBURLCache sharedCache] imageForURL:url];
}

void TBDPrint(NSString *errorMessage) {
//    TBDPRINT(errorMessage); //todo---
}


CGSize sizeWithFontFun(UIFont *font, CGSize size) {
    NSString *string = @"";
    return [string sizeWithFont:font constrainedToSize:size];
}

CGFloat MinimumLineHeight(void) {

    if ([UIScreen mainScreen].scale > 1) {
        return 0.5;
    }

    return 1;
}

BOOL TBIsIPhone5(void) {
    return DEVICE_SCREEN_HAS_LENGTH([UIScreen mainScreen].bounds, 568.f);
}

BOOL TBIsIPhone6(void) {
    return DEVICE_SCREEN_HAS_LENGTH([UIScreen mainScreen].bounds, 667.f);
}

BOOL TBIsIPhone6Plus(void) {
    return DEVICE_SCREEN_HAS_LENGTH([UIScreen mainScreen].bounds, 736.f);
}

BOOL TBIsIPhone(void) {
    return UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM();
}

BOOL TBIsIphone4OrLess(void) {
    return TBIsIPhone() && TBSCREEN_HEIGHT<568;
}

#define notify(_notificationName, _obj, _userInfoDictionary)

void TBNotify(NSString *notificationName, id obj, NSDictionary *userInfoDictionary) {
    [[NSNotificationCenter defaultCenter]
            postNotificationName:notificationName
                          object:obj
                        userInfo:userInfoDictionary];
}

void TBAddObserver(NSString *notificationName, id observer, SEL observerSelector, id obj) {

    [[NSNotificationCenter defaultCenter]
            addObserver:observer
               selector:observerSelector
                   name:notificationName
                 object:obj];
}

void TBRemoveObserver(id observer) {
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

BOOL TBSystemVersionEqualTo(double foundationVersionNumber) {
    return fabs(NSFoundationVersionNumber - foundationVersionNumber) < DBL_EPSILON;
}

BOOL TBSystemVersionGreaterThan(double foundationVersionNumber) {
    return NSFoundationVersionNumber > foundationVersionNumber;
}

BOOL TBSystemVersionGreaterThanOrEqualTo(double foundationVersionNumber) {
   return NSFoundationVersionNumber > foundationVersionNumber || TBSystemVersionEqualTo(foundationVersionNumber);
}

BOOL TBSystemVersionLessThan(double foundationVersionNumber) {
    return NSFoundationVersionNumber < foundationVersionNumber;
}

BOOL TBSystemVersionLessThanOrEqualTo(double foundationVersionNumber) {
    return  NSFoundationVersionNumber < foundationVersionNumber || TBSystemVersionEqualTo(foundationVersionNumber);
}

CGFloat TBGetIphone6HeightByScaleWidth320Height(CGFloat scaleWidth320Height){
    return ((375.0f/320.0f)*scaleWidth320Height);
}

CGFloat TBGetIphone6PlusHeightByScaleWidth375Height(CGFloat scaleWidth375Height){
    return ((414.0f/375.0f)*scaleWidth375Height);
}

CGFloat TBGetScale320HeightByIphone6Height(CGFloat iphone6Height){
    return ((320.0f/375.0f)*iphone6Height);
}

CGFloat TBGetIphone6PlusHeightByScaleWidth320Height(CGFloat scaleWidth320Height){
    return ((414.0f/320.0f)*scaleWidth320Height);
}
