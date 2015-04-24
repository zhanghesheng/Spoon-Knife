//
//  Tao800PaymentCreateOrderReceiverTitleCell.m
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PaymentCreateOrderReceiverErrorCell.h"
#import "Tao800PaymentCreateOrderReceiverErrorItem.h"

@interface Tao800PaymentCreateOrderReceiverErrorCell ()
@property(nonatomic, weak) CALayer *leftVerticalLineLayer;
@property(nonatomic, weak) CALayer *rightVerticalLineLayer;
@property(nonatomic, weak) CALayer *topLineLayer;
@end

@implementation Tao800PaymentCreateOrderReceiverErrorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed: @"Tao800PaymentCreateOrderReceiverErrorCell" owner:self options:nil];
        [self addSubview:self.customContent];
    }
    return self;
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    return 68;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    Tao800PaymentCreateOrderReceiverErrorItem *item = (Tao800PaymentCreateOrderReceiverErrorItem *) _item;

    if (!item) {
        return;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)setObject:(id)object {
    [super setObject:object];

    Tao800PaymentCreateOrderReceiverErrorItem *item = (Tao800PaymentCreateOrderReceiverErrorItem *) _item;

    if (!item) {
        return;
    }

    self.customContent.backgroundColor = BACKGROUND_COLOR_GRAT2;
}

-(IBAction)gotoAdressBtnClicked:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gotoAdressFromError:)]){
        [self.delegate gotoAdressFromError:self];
    }
}

@end
