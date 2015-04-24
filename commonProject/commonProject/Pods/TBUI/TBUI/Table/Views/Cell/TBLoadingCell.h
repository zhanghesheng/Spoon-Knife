//
// Created by enfeng on 13-6-3.
// Copyright (c) 2013 com.tuan800.framework.ui. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TBTableViewCell.h"
#import "TBActivityLabel.h"

@interface TBLoadingCell : TBTableViewCell  {
    TBActivityLabel *_activityLabel;
}
@property(nonatomic, strong) TBActivityLabel *activityLabel;
@end