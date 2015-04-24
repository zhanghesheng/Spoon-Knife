//
//  Tao800SimpleSegue.h
//  universalT800
//
//  Created by enfeng on 13-11-22.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Tao800SimpleSegue : UIStoryboardSegue
@property(nonatomic, strong) NSDictionary *forwardParams;
@property(nonatomic) BOOL cancel;

+ (void)presentModelViewCTL:(UIViewController *)ctl currentCTL:(UIViewController *)currentCTL;
@end
