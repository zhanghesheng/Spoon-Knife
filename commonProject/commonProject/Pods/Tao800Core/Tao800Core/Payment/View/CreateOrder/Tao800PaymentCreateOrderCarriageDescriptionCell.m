//
//  Tao800PaymentCreateOrderCarriageDescriptionCell.m
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PaymentCreateOrderCarriageDescriptionCell.h"
#import "Tao800PaymentCreateOrderCarriageDescriptionItem.h"

CGFloat const CreateOrderCarriageDescriptionHPadding = 10;
CGFloat const CreateOrderCarriageDescriptionVPadding = 10;

@implementation Tao800PaymentCreateOrderCarriageDescriptionCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    Tao800PaymentCreateOrderCarriageDescriptionItem *item = (Tao800PaymentCreateOrderCarriageDescriptionItem*)object;

    CGFloat hPadding = CreateOrderCarriageDescriptionHPadding;
    UIScreen *screen = [UIScreen mainScreen];
    CGFloat width = screen.bounds.size.width-hPadding*2;
    CGSize size = [item.text
            sizeWithFont:V3_24PX_FONT
       constrainedToSize:CGSizeMake(width, MAXFLOAT)];
    return CreateOrderCarriageDescriptionVPadding+size.height+item.top;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    Tao800PaymentCreateOrderCarriageDescriptionItem *item = (Tao800PaymentCreateOrderCarriageDescriptionItem*)_item;
    if (!item) {
        return;
    }
    CGFloat hPadding = CreateOrderCarriageDescriptionHPadding;

    CGRect titleRect = self.contentLabel.frame;

    titleRect.origin.y = item.top;
    titleRect.origin.x = hPadding;
    CGSize size;

    titleRect.size.width = self.width - titleRect.origin.x-hPadding;
    size = [self.contentLabel.text
            sizeWithFont:self.contentLabel.font
       constrainedToSize:CGSizeMake(titleRect.size.width, MAXFLOAT)];
    titleRect.size.height = size.height;

    self.contentLabel.frame = titleRect;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.contentLabel.text = nil;
}

- (void)setObject:(id)object {
    [super setObject:object];

    Tao800PaymentCreateOrderCarriageDescriptionItem *item = (Tao800PaymentCreateOrderCarriageDescriptionItem*)_item;
    if (!item) {
        return;
    }
    self.contentLabel.text = item.text;
    self.contentLabel.textColor = TEXT_COLOR_BLACK3;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = V3_24PX_FONT;
    self.backgroundColor = BACKGROUND_COLOR_GRAT2;
}
@end
