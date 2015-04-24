//
//  Tao800PaymentCreateOrderDealCountCell.m
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PaymentCreateOrderDealCountCell.h"
#import "Tao800PaymentCreateOrderDealCountItem.h"

@implementation Tao800PaymentCreateOrderDealCountCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    return 54;
}

- (void)setObject:(id)object {
    [super setObject:object];
    if (self.lineLayer) {
        [self.lineLayer removeFromSuperlayer];
        self.lineLayer = nil;
    }

    Tao800PaymentCreateOrderDealCountItem *item = (Tao800PaymentCreateOrderDealCountItem *) _item;
    if (item == nil) {
        return;
    }
    self.minusButton.backgroundColor = [UIColor clearColor];
    self.plusButton.backgroundColor = [UIColor clearColor];
    self.countText.textColor = TEXT_COLOR_BLACK1;
    self.countLabel.textColor = TEXT_COLOR_BLACK1;
    self.countText.userInteractionEnabled = NO;
    self.countText.text = item.text;

    _minusButton.enabled = item.productCount >= 2;
    if (item.limitCount>0) {
        _plusButton.enabled = item.productCount < item.limitCount;
    }

    UIImage *image1 = TBIMAGE(@"bundle://payment_minus_btn@2x.png");
    UIImage *image3 = TBIMAGE(@"bundle://payment_minus_disable_btn@2x.png");

    UIImage *plusNormal = TBIMAGE(@"bundle://payment_plus_btn@2x.png");
    UIImage *plusDisable = TBIMAGE(@"bundle://payment_plus_disable_btn@2x.png");

    [_minusButton setImage:image1 forState:UIControlStateNormal];
    [_minusButton setImage:image3 forState:UIControlStateDisabled];

    [_plusButton setImage:plusDisable forState:UIControlStateDisabled];
    [_plusButton setImage:plusNormal forState:UIControlStateNormal];


    self.backgroundColor = BACKGROUND_COLOR_GRAT2;
}
@end
