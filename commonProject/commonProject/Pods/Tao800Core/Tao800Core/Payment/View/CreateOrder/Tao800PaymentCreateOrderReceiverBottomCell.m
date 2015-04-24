//
//  Tao800PaymentCreateOrderReceiverBottomCell.m
//  tao800
//
//  Created by enfeng on 14-5-5.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PaymentCreateOrderReceiverBottomCell.h"
#import "Tao800FunctionCommon.h"
#import "Tao800PaymentCreateOrderReceiverBottomItem.h"

@interface Tao800PaymentCreateOrderReceiverBottomCell () {

}
@property(nonatomic, weak) CALayer *leftVerticalLineLayer;
@property(nonatomic, weak) CALayer *rightVerticalLineLayer;
@property(nonatomic, weak) CALayer *contentLayer;
@end
@implementation Tao800PaymentCreateOrderReceiverBottomCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    return 30;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {


    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    if (self) {
        CALayer *layer1 = [CALayer layer];
        CALayer *layer2 = [CALayer layer];
        CALayer *layer3 = [CALayer layer];

        [self.contentView.layer addSublayer:layer1];
        [self.contentView.layer addSublayer:layer2];
        [self.contentView.layer addSublayer:layer3];

        layer1.backgroundColor = BORDER_COLOR_GRAY1.CGColor;
        layer2.backgroundColor = BORDER_COLOR_GRAY1.CGColor;
        layer3.backgroundColor = [UIColor whiteColor].CGColor;

        self.leftVerticalLineLayer = layer1;
        self.rightVerticalLineLayer = layer2;
        self.contentLayer = layer3;

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];


    [CATransaction begin];
    [CATransaction setValue:(id) kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    CGFloat h = SuitOnePixelHeight();

    CGFloat hPadding = 10;
    self.lineLayer.frame = CGRectMake(hPadding,
            self.height - h-hPadding - 10,
            self.width-hPadding*2, h);

    CGFloat lineWidth = SuitOnePixelHeight();

    self.leftVerticalLineLayer.frame = CGRectMake(
            hPadding,
            0,
            lineWidth,
            self.height - 10 - hPadding);
    self.rightVerticalLineLayer.frame = CGRectMake(
            self.width - lineWidth - hPadding,
            0,
            lineWidth,
            self.height - 10 - hPadding);

    CGRect rect = self.contentLayer.frame;
    rect.origin.x = self.leftVerticalLineLayer.frame.origin.x+self.leftVerticalLineLayer.frame.size.width;
    rect.origin.y = 0;
    rect.size.width = self.rightVerticalLineLayer.frame.origin.x - rect.origin.x;
    rect.size.height = self.height - self.lineLayer.frame.size.height-hPadding - 10;
    self.contentLayer.frame = rect;

    [CATransaction commit];
}

- (void)setObject:(id)object {
    [super setObject:object];
    
    Tao800PaymentCreateOrderReceiverBottomItem *item = (Tao800PaymentCreateOrderReceiverBottomItem *)_item;

    if (item.cellFor) {
        self.lineLayer.backgroundColor = BORDER_COLOR_GRAY1.CGColor;
        self.backgroundColor = [UIColor whiteColor];
    }else{
        self.backgroundColor = BACKGROUND_COLOR_GRAT2;
    }
    
}
@end
