//
//  Tao800PaymentCreateOrderPayMethodCell.m
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//
#import "Tao800StyleSheet.h"
#import "Tao800PaymentCreateOrderPayMethodItem.h"
#import "Tao800PaymentCreateOrderPayMethodCell.h"
#import "Tao800FunctionCommon.h"

@implementation Tao800PaymentCreateOrderPayMethodCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    return 68;
}

-(void)layoutSubviews{
    [super layoutSubviews];

}

- (void) prepareForReuse {
    [super prepareForReuse];

    [self.leftImageView unsetImage];
}

- (void)setObject:(id)object {
    [super setObject:object];

    Tao800PaymentCreateOrderPayMethodItem * item = (Tao800PaymentCreateOrderPayMethodItem *) _item;
    if (item == nil) {
        return;
    }
    self.leftImageView.backgroundColor = [UIColor clearColor];
    self.leftImageView.urlPath = item.imageUrl;

    self.titleLabel.font = V3_26PX_FONT;
    self.titleLabel.text = item.title;
    self.subTitleLabel.text = item.subTitle;
    self.subTitleLabel.textColor = TEXT_COLOR_BLACK6;
    self.titleLabel.textColor = TEXT_COLOR_BLACK1;

    self.selectionStyle = UITableViewCellSelectionStyleGray;

    self.checkImageView.backgroundColor = [UIColor clearColor];
    self.checkImageView.urlPath = @"bundle://payment_check_yes@2x.png";
}
@end
