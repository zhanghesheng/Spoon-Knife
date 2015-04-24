//
//  TBUICommon.m
//  Core
//
//  Created by enfeng yang on 12-1-18.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import "TBUICommon.h"
#import <WebP/decode.h>
#import "TBCore/TBCoreMacros.h"
#import <CoreGraphics/CoreGraphics.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import <QuartzCore/QuartzCore.h>

const CGFloat TBDefaultRowHeight = 44.0f;
const CGFloat TBDefaultNavigationBarHeight = 44.0f;

const CGFloat TBDefaultStatusBarHeight = 20.0f;
const CGFloat TBDefaultTabbarHeight = 49.0f;


const CGFloat TBDefaultPortraitToolbarHeight = 44.0f;
const CGFloat TBDefaultLandscapeToolbarHeight = 33.0f;

const CGFloat TBDefaultPortraitKeyboardHeight = 216.0f;
const CGFloat TBDefaultLandscapeKeyboardHeight = 160.0f;
const CGFloat tbkDefaultPadPortraitKeyboardHeight = 264.0f;
const CGFloat tbkDefaultPadLandscapeKeyboardHeight = 352.0f;

const CGFloat TBGroupedIphoneTableCellInset = 9.0f;
const CGFloat TBGroupedPadTableCellInset = 42.0f;

const CGFloat TBDefaultTransitionDuration = 0.3f;
const CGFloat TBDefaultFastTransitionDuration = 0.2f;
const CGFloat TBDefaultFlipTransitionDuration = 0.7f;

///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL TBIsPhoneSupported(void) {
    NSString *deviceType = [UIDevice currentDevice].model;
    return [deviceType isEqualToString:@"iPhone"];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL TBIsPad(void) {
#ifdef __IPHONE_3_2
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
#else
    return NO;
#endif
}


BOOL TBIsHongBao(void) {
    NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
    NSLog(@"获得项目名  %@",executableFile);
    if (executableFile&&executableFile.length>0&&[executableFile isEqualToString:@"hongbao"]) {
        return YES;
    }else{
        return NO;
    }
}


NSString *TBGetPlatform(void) {
    NSString *platform = nil;
    if (TBIsPad()) {
        platform = @"iPad";
    } else if (TBIsPhoneSupported()) {
        platform = @"iPhone";
    } else {
        platform = @"iPod";
    }
    return platform;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGFloat TBGroupedTableCellInset(void) {
    return TBIsPad() ? TBGroupedPadTableCellInset : TBGroupedIphoneTableCellInset;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
CGRect TBScreenBounds(void) {
    CGRect bounds = [UIScreen mainScreen].bounds;
    if (UIInterfaceOrientationIsLandscape(TBInterfaceOrientation())) {
        //CGFloat width = bounds.size.width;
        //bounds.size.width = bounds.size.height;
        //bounds.size.height = width;
        CGFloat realWidth = fetchRealWidthWithParameters(bounds.size.width, bounds.size.height);
        CGFloat realHeight = fetchRealHeightWithParameters(bounds.size.width, bounds.size.height);
        bounds.size.width = realWidth;
        bounds.size.height = realHeight;
    }
    return bounds;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
UIInterfaceOrientation TBInterfaceOrientation(void) {
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
    if (UIDeviceOrientationUnknown == orient) {
//        return [TTBaseNavigator globalNavigator].visibleViewController.interfaceOrientation;
        return UIInterfaceOrientationPortraitUpsideDown; //todo waitfor update
    } else {
        return orient;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
CGRect TBApplicationFrame(void) {
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    return CGRectMake(0, 0, frame.size.width, frame.size.height);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
CGFloat TBToolbarHeightForOrientation(UIInterfaceOrientation orientation) {
    if (UIInterfaceOrientationIsPortrait(orientation) || TBIsPad()) {
        return TBDefaultRowHeight;

    } else {
        return TBDefaultLandscapeToolbarHeight;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
CGRect TBNavigationFrame(void) {
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    return CGRectMake(0, 0, frame.size.width, frame.size.height - TBToolbarHeight());
}

///////////////////////////////////////////////////////////////////////////////////////////////////
CGFloat TBToolbarHeight(void) {
    return TBToolbarHeightForOrientation(TBInterfaceOrientation());
}

BOOL TBIsSupportedOrientation(UIInterfaceOrientation orientation) {
    if (TBIsPad()) {
        return YES;

    } else {
        switch (orientation) {
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                return YES;
            default:
                return NO;
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
void TBAlert(NSString *message) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", @"")
                                                     message:message delegate:nil
                                           cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                           otherButtonTitles:nil];
    [alert show];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
void TBAlertNoTitle(NSString *message) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                           otherButtonTitles:nil];
    [alert show];
}

BOOL TBIsAfterIphone4(void) {
    if (TBIsPad()) {
        return NO;

    } else {
        UIScreen *screen = [UIScreen mainScreen];
        if (screen.bounds.size.height > 480) {
            return YES;
        } else {
            return NO;
        }
    }
}

NSString *TBMachine(void) {
    NSString *machine;
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *name = malloc(size);
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    machine = [NSString stringWithUTF8String:name];
    free(name);
    return machine;
}

NSString *TBDeviceModelName() {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);

    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone1G GSM";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone3G GSM";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone3GS GSM";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone4 GSM";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone4 CDMA";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod 1G";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod 2G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod 3G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod 4G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod 5G";
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad WiFi";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad2 WiFi";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad2 GSM";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad2 CDMAV";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad2 CDMAS";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad3 WiFi";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad3 GSM";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad3 CDMA";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad4 Wifi";
    if ([platform isEqualToString:@"i386"]) return @"Simulator";
    if ([platform isEqualToString:@"x86_64"]) return @"Simulator";

    return platform;
}

/*
 This gets called when the UIImage gets collected and frees the underlying image.
 */
static void free_image_data(void *info, const void *data, size_t size) {
    free((void *) data);
}

UIImage *DataToImage(NSData *myData) {
    NSUInteger len = [myData length];
    if (len > 12) {
        NSRange range = NSMakeRange(0, 4);
        NSData *headerData = [myData subdataWithRange:range];

        //file size
//        range = NSMakeRange(4, 4);

        range = NSMakeRange(8, 4);
        NSData *footerData = [myData subdataWithRange:range];

        NSString *headerString = [[NSString alloc] initWithData:headerData
                                                        encoding:NSASCIIStringEncoding];
        NSString *footerString = [[NSString alloc] initWithData:footerData
                                                        encoding:NSASCIIStringEncoding];

        //是否为webp 图片
        if ([headerString isEqualToString:@"RIFF"] && [footerString isEqualToString:@"WEBP"]) {
            // Get the current version of the WebP decoder
//            int rc = WebPGetDecoderVersion();
//
//            TBDPRINT(@"Version: %d", rc);

            // Get the width and height of the selected WebP image
            int width = 0;
            int height = 0;
            WebPGetInfo([myData bytes], [myData length], &width, &height);

            TBDPRINT(@"Image Width: %d Image Height: %d", width, height);

            // Decode the WebP image data into a RGBA value array
            uint8_t *data = WebPDecodeRGBA([myData bytes], [myData length], &width, &height);

            // Construct a UIImage from the decoded RGBA value array
            CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, data, width * height * 4, free_image_data);
            CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
            CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaLast;
            CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
            CGImageRef imageRef = CGImageCreate(width, height, 8, 32, 4 * width, colorSpaceRef, bitmapInfo, provider, NULL, YES, renderingIntent);
            UIImage *newImage = [UIImage imageWithCGImage:imageRef];

            CGImageRelease(imageRef);  //this line would cause newImage to be released , 所以前面加一次retain
            CGColorSpaceRelease(colorSpaceRef);
            CGDataProviderRelease(provider);

            return newImage;
        } else {
            return [UIImage imageWithData:myData];
        }
    } else {
        return [UIImage imageWithData:myData];
    }
}

void TBAddSublayerWithoutAnimation (CALayer *parentLayer, CALayer *sublayer) {
    //只在修改layer属性时起作用，如：layer.frame=CGMakeRect(...)
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    [parentLayer addSublayer:sublayer];
    [CATransaction commit];
}

CGFloat fetchRealWidthWithParameters(CGFloat width ,CGFloat height){
    CGFloat w = width;
    CGFloat h = height;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (TBIsPad()) {
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            if (w < h) {
                w = h;
            }
        }
    }
    
    return w;

}

CGFloat fetchRealHeightWithParameters(CGFloat width ,CGFloat height){
    CGFloat w = width;
    CGFloat h = height;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (TBIsPad()) {
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            if (w < h) {
                h = w;
            }
        }
    }
    
    return h;

}

CGRect fetRealRectWithParameters(CGRect originRect){
    CGRect realRect = CGRectZero;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (TBIsPad()) {
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            realRect = originRect;
            CGFloat realWidth = fetchRealWidthWithParameters(originRect.size.width, originRect.size.height);
            CGFloat realHeight = fetchRealHeightWithParameters(originRect.size.width, originRect.size.height);
            realRect.size.width = realWidth;
            realRect.size.height = realHeight;
        }
    }
    return realRect;
}
