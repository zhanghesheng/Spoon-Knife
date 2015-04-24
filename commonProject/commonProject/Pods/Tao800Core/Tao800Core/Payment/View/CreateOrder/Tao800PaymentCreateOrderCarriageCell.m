//
//  Tao800PaymentCreateOrderCarriageCell.m
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PaymentCreateOrderCarriageItem.h"
#import "Tao800PaymentCreateOrderCarriageCell.h"

@implementation Tao800PaymentCreateOrderCarriageCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    return 27;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)setObject:(id)object {
    [super setObject:object];

    if (self.lineLayer) {
        [self.lineLayer removeFromSuperlayer];
        self.lineLayer = nil;
    }

    Tao800PaymentCreateOrderCarriageItem *item = (Tao800PaymentCreateOrderCarriageItem *) _item;
    if (!item) {
        return;
    }
    self.contentLabel.textColor = TEXT_COLOR_BLACK3;
    self.titleLabel.textColor = TEXT_COLOR_BLACK3;
    self.titleLabel.font = V3_24PX_FONT;

    if (item.postFree) {
        self.titleLabel.text = item.text;
        self.contentLabel.hidden = YES;
    } else {
        self.titleLabel.text = @"运费：";
        self.contentLabel.hidden = NO;
        self.contentLabel.text = item.text;
    }
    self.backgroundColor = BACKGROUND_COLOR_GRAT2;
}
@end
