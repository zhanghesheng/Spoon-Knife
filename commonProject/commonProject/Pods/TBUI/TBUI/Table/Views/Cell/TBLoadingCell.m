//
// Created by enfeng on 13-6-3.
// Copyright (c) 2013 com.tuan800.framework.ui. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "TBLoadingCell.h"
#import "TBCore/TBCoreMacros.h"
#import "TBLoadingItem.h"
#import "UIViewAdditions.h"
#import "TBUICommon.h"

@implementation TBLoadingCell {

}

- (void)setObject:(id)object {
    [super setObject:object];

    TBLoadingItem *item = (TBLoadingItem *) _item;
    if (item == nil) {
        return;
    }
    self.activityLabel.label.text = item.text;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _activityLabel = [[TBActivityLabel alloc] initWithFrame:CGRectZero
                                                          style:UIActivityIndicatorViewStyleGray
                                                           text:@""];
        [self.contentView addSubview:_activityLabel];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];

        _activityLabel.layer.borderWidth = 1;
        _activityLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _activityLabel.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    TBLoadingItem *item = (TBLoadingItem *) _item;
    if (item == nil) {
        return;
    }
    CGFloat hPadding = TBGroupedTableCellInset();
    CGFloat vPadding = 3;
    CGFloat x = hPadding;
    if (item.isGroupTable) {
        x = 0;
    }
    _activityLabel.frame = CGRectMake(x, vPadding, self.width - hPadding * 2, self.height - vPadding * 2);

//    [_activityLabel layoutSubviews];
}

- (void)dealloc {
     
}
@end