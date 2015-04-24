//
//  Tao800CrashManager.h
//  tao800
//
//  Created by Rose on 15/1/6.
//  Copyright (c) 2015年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800AlertView.h"

typedef void (^Tao800CrashManagerCallback)(BOOL didClose);

@interface Tao800CrashManager : NSObject<Tao800AlertViewDelegate>

@property (nonatomic, copy) Tao800CrashManagerCallback callBack;
/**
 *
 * 所有窗口的显示走 Tao800ForwardSingleton
 */
- (void) showCrashInfo:(BOOL) firstInstall callBack:(Tao800CrashManagerCallback) callBackParam;

@end
