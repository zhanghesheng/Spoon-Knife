//
// Created by enfeng on 13-7-1.
// Copyright (c) 2013 enfeng. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Tao800LoadMoreCell.h"
#import "TBCore/TBCore.h"
#import "Tao800LoadMoreItem.h"
#import "Tao800StyleSheet.h"

@implementation Tao800LoadMoreCell {

}

@synthesize activityLabel = _activityLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
    self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self) {
        _activityLabel = [[Tao800ActivityLabel alloc] initWithFrame:CGRectZero
                                                               text:@"正在加载..."];
        _activityLabel.label.font = V3_28PX_FONT;
//        _activityLabel.label.textColor = V3_FONT_BLACK_COLORD;
        [self.contentView addSubview:_activityLabel];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _activityLabel.frame = self.bounds;
    Tao800LoadMoreItem *item = (Tao800LoadMoreItem *) _item;
    if (item == nil) {
        return;
    }
    if (item.text) {
        _activityLabel.label.text = item.text;
    }

    if (item.loading) {

        if (![_activityLabel isAnimating]) {
            [_activityLabel startAnimating];
        }
    } else {
        if (_activityLabel.isAnimating) {
            [_activityLabel stopAnimating];
        }
    }
    [_activityLabel layoutSubviews];
}

- (void)setObject:(id)object {
    [super setObject:object];
    Tao800LoadMoreItem *item = (Tao800LoadMoreItem *) _item;
    if (item == nil) {
        return;
    }
    if (item.text) {
        _activityLabel.label.text = item.text;
    }
//    self.backgroundColor = [UIColor colorWithHex:0xF9F9F9];

    self.selectionStyle = UITableViewCellSelectionStyleGray;

    if (self.lineLayer) {
        [self.lineLayer removeFromSuperlayer];
        self.lineLayer = nil;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];

    if ([_activityLabel isAnimating]) {
        [_activityLabel stopAnimating];
    }
}
@end