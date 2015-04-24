//
//  Tao800FirstOrderCheckerModel.h
//  tao800
//
//  Created by hanyuan on 14-3-5.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800PointService.h"

extern NSString *const Tao800FirstOrderStateDidChangeNotifyCation;
extern NSString *const Tao800FirstOrderEntryKey;
extern NSString *const Tao800FirstOrderMarkKey;

@interface Tao800FirstOrderCheckerModel : NSObject<TBBaseNetworkDelegate>
-(void)checkFirstOrderState;
-(void)notifyEntryState:(BOOL)open;
-(void)notifyMarkState:(BOOL)show;
@end
