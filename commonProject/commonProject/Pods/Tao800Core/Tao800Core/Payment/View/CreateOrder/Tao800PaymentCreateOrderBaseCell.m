//
//  Tao800PaymentCreateOrderBaseCell.m
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PaymentCreateOrderBaseCell.h"

@implementation Tao800PaymentCreateOrderBaseCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    return 44;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)setObject:(id)object {
    [super setObject:object];

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.lineLayer.backgroundColor = [UIColor colorWithHex:0xE5E5E5].CGColor;
}
@end
