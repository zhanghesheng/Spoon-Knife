//
//  TBUICommon.h
//  Core
//
//  Created by enfeng yang on 12-1-18.
//  Copyright (c) 2012年 mac. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// Dimensions of common iPhone OS Views

/**
 * The standard height of a row in a table view controller.
 * @const 44 pixels
 */
extern const CGFloat TBDefaultRowHeight;
extern const CGFloat TBDefaultNavigationBarHeight;

extern const CGFloat TBDefaultStatusBarHeight;
extern const CGFloat TBDefaultTabbarHeight;

/**
 * The standard height of a toolbar in portrait orientation.
 * @const 44 pixels
 */
extern const CGFloat TBDefaultPortraitToolbarHeight;

/**
 * The standard height of a toolbar in landscape orientation.
 * @const 33 pixels
 */
extern const CGFloat TBDefaultLandscapeToolbarHeight;

/**
 * The standard height of the keyboard in portrait orientation.
 * @const 216 pixels
 */
extern const CGFloat TBDefaultPortraitKeyboardHeight;

/**
 * The standard height of the keyboard in landscape orientation.
 * @const 160 pixels
 */
extern const CGFloat TBDefaultLandscapeKeyboardHeight;

/**
 * The space between the edge of the screen and the cell edge in grouped table views.
 * @const 10 pixels
 */
extern const CGFloat TBGroupedIphoneTableCellInset;

extern const CGFloat TBGroupedPadTableCellInset;

/**
 * The standard duration length for a transition.
 * @const 0.3 seconds
 */
extern const CGFloat TBDefaultTransitionDuration;

/**
 * The standard duration length for a fast transition.
 * @const 0.2 seconds
 */
extern const CGFloat TBDefaultFastTransitionDuration;

/**
 * The standard duration length for a flip transition.
 * @const 0.7 seconds
 */
extern const CGFloat TBDefaultFlipTransitionDuration;

/**
 * @return TRUE if the device has phone capabilities.
 */
BOOL TBIsPhoneSupported(void);

/**
 * @return TRUE if the device is iPad.
 */
BOOL TBIsPad(void);

CGFloat TBGroupedTableCellInset(void);

CGRect TBApplicationFrame(void);

CGFloat TBToolbarHeightForOrientation(UIInterfaceOrientation orientation);

CGRect TBNavigationFrame(void);

CGFloat TBToolbarHeight(void);

UIInterfaceOrientation TBInterfaceOrientation(void);

CGRect TBScreenBounds(void);

BOOL TBIsSupportedOrientation(UIInterfaceOrientation orientation);

void TBAlert(NSString* message);

void TBAlertNoTitle(NSString* message);

BOOL TBIsAfterIphone4(void);

/**
 * 返回当前机型，如iPhone3,1 iPhone3,2 iPhone4,1 iPad2,1
 */
NSString* TBMachine(void);

BOOL TBIsHongBao(void);

NSString* TBDeviceModelName();

/**
* 统计用
*/
NSString *TBGetPlatform(void);


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

UIImage *DataToImage(NSData *data);

void TBAddSublayerWithoutAnimation (CALayer *parentLayer, CALayer *sublayer);


CGFloat fetchRealWidthWithParameters(CGFloat width ,CGFloat height);


CGFloat fetchRealHeightWithParameters(CGFloat width ,CGFloat height);


CGRect fetRealRectWithParameters(CGRect originRect);
