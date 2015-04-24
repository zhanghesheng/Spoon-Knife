//
//  TBCommonFunction.h
//  Core
//
//  Created by enfeng yang on 12-6-12.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

//If the symbol for iOS 5 isnt defined, define it.
#ifndef NSFoundationVersionNumber_iOS_5_0
#define NSFoundationVersionNumber_iOS_5_0 881.00
#endif

#ifdef NSFoundationVersionNumber_iOS_5_0
#define _iOS_5_0 NSFoundationVersionNumber_iOS_5_0
#endif

//If the symbol for iOS 5.1 isnt defined, define it.
#ifndef NSFoundationVersionNumber_iOS_5_1
#define NSFoundationVersionNumber_iOS_5_1 890.10
#endif

#ifdef NSFoundationVersionNumber_iOS_5_1
#define _iOS_5_1 NSFoundationVersionNumber_iOS_5_1
#endif

//If the symbol for iOS 6.0 isnt defined, define it.
#ifndef NSFoundationVersionNumber_iOS_6_0
#define NSFoundationVersionNumber_iOS_6_0 993.00 //extracted from iOS 7 Header
#endif

#ifdef NSFoundationVersionNumber_iOS_6_0
#define _iOS_6_0 NSFoundationVersionNumber_iOS_6_0
#endif

//If the symbol for iOS 6.1 isnt defined, define it.
#ifndef NSFoundationVersionNumber_iOS_6_1
#define NSFoundationVersionNumber_iOS_6_1 993.00 //extracted from iOS 7 Header
#endif

#ifdef NSFoundationVersionNumber_iOS_6_1
#define _iOS_6_1 NSFoundationVersionNumber_iOS_6_1
#endif

//If the symbol for iOS 7 isnt defined, define it.
#ifndef NSFoundationVersionNumber_iOS_7_0
#define NSFoundationVersionNumber_iOS_7_0 1047.00 //extracted from iOS 7 Header
#endif

#ifdef NSFoundationVersionNumber_iOS_7_0
#define _iOS_7_0 NSFoundationVersionNumber_iOS_7_0
#endif

//If the symbol for iOS 7.1 isnt defined, define it.
#ifndef NSFoundationVersionNumber_iOS_7_1
#define NSFoundationVersionNumber_iOS_7_1 1047.25 //extracted from iOS 8 Header
#endif

#ifdef NSFoundationVersionNumber_iOS_7_1
#define _iOS_7_1 NSFoundationVersionNumber_iOS_7_1
#endif

//If the symbol for iOS 8 isnt defined, define it.
#ifndef NSFoundationVersionNumber_iOS_8_0
#define NSFoundationVersionNumber_iOS_8_0 1134.10 //extracted with NSLog(@"%f", NSFoundationVersionNumber)
#endif

#ifdef NSFoundationVersionNumber_iOS_8_0
#define _iOS_8_0 NSFoundationVersionNumber_iOS_8_0
#endif

#import <Foundation/Foundation.h>

NSString *GetIPAddress(void);

/**
* 获取Wifi地址
*/
NSString *GetWifiMacAddress(void);

/**
* 获取Wifi地址
*/
NSString *GetWifiMacAddressWithSeparator(NSString *sep);

/**
* 需要的最低系统版本
*/
BOOL RequireSysVerGreaterOrEqual(NSString *reqSysVer);

/**
* 用于设置页面坐标
*/
BOOL NeedResetUIStyleLikeIOS7(void);

/**
* 用于替换宏定义，确保swift可以调用
*/
UIImage *TBImage(NSString *url);

void TBDPrint(NSString *errorMessage);


CGSize sizeWithFontFun(UIFont *font, CGSize size); 

CGFloat MinimumLineHeight(void);

BOOL TBIsIPhone5(void);

BOOL TBIsIPhone6(void);

BOOL TBIsIPhone6Plus(void);

BOOL TBIsIPhone(void);

BOOL TBIsIphone4OrLess(void);

void TBNotify(NSString *notificationName, id obj, NSDictionary *userInfoDictionary);

void TBRemoveObserver(id observer);

void TBAddObserver(NSString *notificationName, id observer, SEL observerSelector, id obj);

/**
* @param foundationVersionNumber NSFoundationVersionNumber
*/
BOOL TBSystemVersionEqualTo(double foundationVersionNumber);

/**
* @param foundationVersionNumber 参数如：NSFoundationVersionNumber_iOS_7_0 等等
*/
BOOL TBSystemVersionGreaterThan(double foundationVersionNumber);

/**
* @param foundationVersionNumber 参数如：NSFoundationVersionNumber_iOS_7_0 等等
*/
BOOL TBSystemVersionGreaterThanOrEqualTo(double foundationVersionNumber);

/**
* @param foundationVersionNumber 参数如：NSFoundationVersionNumber_iOS_7_0 等等
*/
BOOL TBSystemVersionLessThan(double foundationVersionNumber);

/**
* @param foundationVersionNumber 参数如：NSFoundationVersionNumber_iOS_7_0 等等
*/
BOOL TBSystemVersionLessThanOrEqualTo(double foundationVersionNumber);
/**
 * 通过屏幕宽度为320的宽高，去求在iphone6上对应的宽和高
 */
CGFloat TBGetIphone6HeightByScaleWidth320Height(CGFloat scaleWidth320Height);
/**
 * 通过屏幕宽度为375（iphone6）的宽高，去求在iphone6 Plus上对应的宽和高
 */
CGFloat TBGetIphone6PlusHeightByScaleWidth375Height(CGFloat scaleWidth375Height);
/**
 * 通过屏幕宽度为375（iphone6）的宽高，去求在屏幕宽度为320（iphone5s以下）对应的宽和高
 */
CGFloat TBGetScale320HeightByIphone6Height(CGFloat iphone6Height);
/**
 * 通过屏幕宽度为320的宽高，去求在iphone6 Plus 上对应的宽和高
 */
CGFloat TBGetIphone6PlusHeightByScaleWidth320Height(CGFloat scaleWidth320Height);


