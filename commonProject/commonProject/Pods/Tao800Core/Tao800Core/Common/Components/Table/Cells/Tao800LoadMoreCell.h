//
// Created by enfeng on 13-7-1.
// Copyright (c) 2013 enfeng. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TBUI/TBUI.h"
#import "Tao800ActivityLabel.h"
#import "Tao800BaseCell.h"

@interface Tao800LoadMoreCell : Tao800BaseCell {
    Tao800ActivityLabel *_activityLabel;
}
@property(nonatomic, strong) Tao800ActivityLabel *activityLabel;
@end