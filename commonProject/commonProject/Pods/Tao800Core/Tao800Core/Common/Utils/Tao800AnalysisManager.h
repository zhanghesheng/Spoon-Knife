//
//  Tao800AnalysisManager.h
//  tao800
//
//  Created by enfeng on 14-5-15.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800AnalysisManager : NSObject


+ (void)trackPageViewBegin:(NSString *)pageName;

+ (void)trackPageViewEnd:(NSString *)pageName;
@end
