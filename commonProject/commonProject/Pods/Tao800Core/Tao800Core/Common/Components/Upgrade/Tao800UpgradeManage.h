//
//  Tao800UpgradeManage.h
//  tao800
//
//  Created by enfeng on 14/12/9.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800AlertView.h"


typedef void (^Tao800UpgradeFinishCallback)(BOOL didClose);

@interface Tao800UpgradeManage : NSObject

@property (nonatomic, copy) Tao800UpgradeFinishCallback finishCallback;

- (void) checkUpdate:(Tao800UpgradeFinishCallback) callback;

+ (BOOL) enableShowUpgradeTip;

+ (void) resetNeverAskValue;
@end
