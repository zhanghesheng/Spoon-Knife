//
//  Tao800PaymentCreateOrderTitleCell.m
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PaymentCreateOrderTitleCell.h"
#import "Tao800PaymentCreateOrderTitleItem.h"
#import "Tao800FunctionCommon.h"

@implementation Tao800PaymentCreateOrderTitleCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    return 25;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect titleRect = self.textLabel.frame;

    titleRect.size = [self.textLabel.text
            sizeWithFont:self.textLabel.font
       constrainedToSize:CGSizeMake(self.width, 100)];

    titleRect.origin.y = self.height - titleRect.size.height-4;
    titleRect.origin.x = 10;
    self.textLabel.frame = titleRect;


    [CATransaction begin];
    [CATransaction setValue:(id) kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    CGFloat h = SuitOnePixelHeight();

    CGFloat hPadding = 10;
    self.lineLayer.frame = CGRectMake(hPadding,
            self.height - h,
            self.width - hPadding * 2, h);

    [CATransaction commit];
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)setObject:(id)object {
    [super setObject:object];

    Tao800PaymentCreateOrderTitleItem *item = (Tao800PaymentCreateOrderTitleItem *) _item;
    if (!item) {
        return;
    }

    self.textLabel.text = item.text;
    self.textLabel.font = V3_26PX_FONT;
    self.textLabel.textColor = TEXT_COLOR_BLACK1;
    self.backgroundColor = item.bgColor;
}
@end
