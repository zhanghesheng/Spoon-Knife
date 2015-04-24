//
//  Tao800PaymentCreateOrderDealCell.m
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PaymentCreateOrderDealCell.h"
#import "Tao800PaymentCreateOrderDealItem.h"
#import "Tao800PaymentProductVo.h"

@implementation Tao800PaymentCreateOrderDealCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    return 93;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat hPadding = 7;

    //标题和图片顶部对齐
    CGRect leftImageRect = self.leftImageView.frame;
    CGRect titleRect = self.titleLabel.frame;

    titleRect.origin.y = leftImageRect.origin.y - 1;
    titleRect.origin.x = hPadding + leftImageRect.origin.x + leftImageRect.size.width;
    CGSize size;

    titleRect.size.width = self.width - titleRect.origin.x - hPadding;
    size = [self.titleLabel.text
            sizeWithFont:self.titleLabel.font
       constrainedToSize:CGSizeMake(titleRect.size.width, 100)];
    titleRect.size.height = size.height;
    if (titleRect.size.height > 35) { //超过了两行的高度，注意：如果调整了字体大小，当前条件也需要调整
        titleRect.size.height = 35;
    }
    self.titleLabel.frame = titleRect;
}

- (void)prepareForReuse {
    [super prepareForReuse];

    [self.leftImageView unsetImage];
    self.titleLabel.text = nil;
    self.styleLabel.text = nil;
    self.styleValueLabel.text = nil;
}

- (void)setObject:(id)object {
    [super setObject:object];

    Tao800PaymentCreateOrderDealItem *item = (Tao800PaymentCreateOrderDealItem *) _item;
    if (!item) {
        return;
    }
    self.leftImageView.defaultImage = TBIMAGE(@"bundle://common_list_default@2x.png");
    self.leftImageView.urlPath = item.productVo.imageUrl;
    self.titleLabel.text = item.productVo.title;
    self.titleLabel.font = V3_24PX_FONT;
    self.titleLabel.numberOfLines = 0;

    self.titleLabel.textColor = TEXT_COLOR_BLACK1;
    self.styleLabel.textColor = TEXT_COLOR_BLACK1;
    self.styleValueLabel.textColor = TEXT_COLOR_BLACK1;

    if (item.productVo.sku1 || item.productVo.sku2) {
        NSString *sku1 = item.productVo.sku1;
        NSString *sku2 = item.productVo.sku2;

        NSMutableString *skuString = [[NSMutableString alloc] init];
        if (!sku1) {
            [skuString appendString:@""];
        } else {
            [skuString appendFormat:@"%@ ", sku1];
        }
        if (!sku2) {
            sku2 = @"";
        }
        [skuString appendString:sku2];

        self.styleLabel.text = @"款式：";
        self.styleValueLabel.text = skuString;
    }
}
@end
