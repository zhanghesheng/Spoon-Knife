//
//  Tao800PaymentCreateOrderReceiverCell.m
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PaymentCreateOrderReceiverItem.h"
#import "Tao800PaymentCreateOrderReceiverCell.h"
#import "Tao800FunctionCommon.h"

CGFloat const ReceiverTopMargin = 7;
CGFloat const ReceiverHPadding = 17;

@interface Tao800PaymentCreateOrderReceiverCell () {
    
}
@property(nonatomic, weak) CALayer *leftVerticalLineLayer;
@property(nonatomic, weak) CALayer *rightVerticalLineLayer;
@property(nonatomic, weak) CALayer *contentLayer;
@end

@implementation Tao800PaymentCreateOrderReceiverCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed: @"Tao800PaymentCreateOrderReceiverCell" owner:self options:nil];
        [self addSubview:self.customContent];
        
        CALayer *layer1 = [CALayer layer];
        CALayer *layer2 = [CALayer layer];
        CALayer *layer3 = [CALayer layer];
        
        [self.customContent.layer addSublayer:layer1];
        [self.customContent.layer addSublayer:layer2];
        [self.customContent.layer insertSublayer:layer3 atIndex:0];
        
        layer1.backgroundColor = BORDER_COLOR_GRAY1.CGColor;
        layer2.backgroundColor = BORDER_COLOR_GRAY1.CGColor;
        layer3.backgroundColor = [UIColor whiteColor].CGColor;
        
        self.leftVerticalLineLayer = layer1;
        self.rightVerticalLineLayer = layer2;
        self.contentLayer = layer3;
    }
    return self;
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    
    Tao800PaymentCreateOrderReceiverItem *item = (Tao800PaymentCreateOrderReceiverItem *) object;
    
    CGFloat height = 23;
    
    //标题
    CGSize titleSize = [item.title sizeWithFont:V3_24PX_FONT
                              constrainedToSize:CGSizeMake(200, 30)];
    CGFloat offset = height - titleSize.height;
    
    //描述
    UIScreen *screen = [UIScreen mainScreen];
    CGFloat width = screen.bounds.size.width - titleSize.width - ReceiverHPadding * 2;
    CGSize contentSize = [item.text sizeWithFont:V3_24PX_FONT
                               constrainedToSize:CGSizeMake(width, MAXFLOAT)];
    if (contentSize.height > height) {
        height = contentSize.height + offset;
    }
    
    return height;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.titleLabel.text = nil;
    self.contentLabel.text = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //标题
    CGRect titleRect = self.titleLabel.frame;
    CGRect contentRect = self.contentLabel.frame;
    
    titleRect.size = [self.titleLabel.text sizeWithFont:self.titleLabel.font
                                      constrainedToSize:CGSizeMake(200, 30)];
    titleRect.origin.y = ReceiverTopMargin;
    titleRect.origin.x = ReceiverHPadding;
    self.titleLabel.frame = titleRect;
    
    
    //描述
    CGFloat width = self.width - titleRect.size.width - ReceiverHPadding * 2;
    contentRect.size = [self.contentLabel.text sizeWithFont:self.contentLabel.font
                                          constrainedToSize:CGSizeMake(width, MAXFLOAT)];
    contentRect.origin.x = titleRect.origin.x + titleRect.size.width;
    contentRect.origin.y = ReceiverTopMargin;
    self.contentLabel.frame = contentRect;
    
    //布局左右竖线
    [CATransaction begin];
    [CATransaction setValue:(id) kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    CGFloat lineWidth = SuitOnePixelHeight();
    CGFloat hPadding = ReceiverHPadding - 7;
    
    self.leftVerticalLineLayer.frame = CGRectMake(
                                                  hPadding,
                                                  0,
                                                  lineWidth,
                                                  self.height);
    self.rightVerticalLineLayer.frame = CGRectMake(
                                                   self.width - lineWidth - hPadding,
                                                   0,
                                                   lineWidth,
                                                   self.height);
    
    CGRect rect = self.contentLayer.frame;
    rect.origin.x = self.leftVerticalLineLayer.frame.origin.x+self.leftVerticalLineLayer.frame.size.width;
    rect.origin.y = 0;
    rect.size.width = self.rightVerticalLineLayer.frame.origin.x - rect.origin.x;
    rect.size.height = self.height;
    self.contentLayer.frame = rect;
    
    [CATransaction commit];
    [self setBackgroundColor:BACKGROUND_COLOR_GRAY2];
}

- (void)setObject:(id)object {
    [super setObject:object];
    
    if (self.lineLayer) {
        [self.lineLayer removeFromSuperlayer];
        self.lineLayer = nil;
    }
    
    Tao800PaymentCreateOrderReceiverItem *item = (Tao800PaymentCreateOrderReceiverItem *) _item;
    if (!item) {
        return;
    }
    self.titleLabel.text = item.title;
    self.contentLabel.text = item.text;
    self.contentLabel.font = V3_24PX_FONT;
    self.titleLabel.font = V3_24PX_FONT;
    self.contentLabel.numberOfLines = 0;
    
    self.titleLabel.textColor = TEXT_COLOR_BLACK1;
    self.contentLabel.textColor = TEXT_COLOR_BLACK1;
    
    self.customContent.backgroundColor = BACKGROUND_COLOR_GRAT2;
}
@end
