//
//  Tao800PaymentCreateOrderReceiverTitleCell.m
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PaymentCreateOrderReceiverTitleCell.h"
#import "Tao800PaymentCreateOrderReceiverTitleItem.h"
#import "Tao800FunctionCommon.h"

@interface OrderReceiverTitleBGView : UIView

@end

@implementation OrderReceiverTitleBGView

- (void)drawBackgroundInContext:(CGContextRef)context {
    
    CGRect rect = [self bounds];
    
    //绘制背景填充
    CGContextSetFillColorWithColor(context, BACKGROUND_COLOR_GRAT2.CGColor);
    CGContextAddRect(context, rect);
    CGContextFillRect(context, rect);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawBackgroundInContext:context];
    
    CGFloat lineWidth = SuitOnePixelHeight();
    CGContextSetLineWidth(context, lineWidth);
    CGColorRef color = BORDER_COLOR_GRAY1.CGColor;
    CGContextSetStrokeColorWithColor(context, color);
    
    CGFloat hPadding = 10;
    rect = [self bounds];
    rect.origin.x = hPadding;
    rect.origin.y = 0;
    rect.size.width = rect.size.width - hPadding * 2;
    
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
}
@end

@interface Tao800PaymentCreateOrderReceiverTitleCell ()

//@property (nonatomic, weak) OrderReceiverTitleBGView *bgView;

@property(nonatomic, weak) CALayer *leftVerticalLineLayer;
@property(nonatomic, weak) CALayer *rightVerticalLineLayer;
@property(nonatomic, weak) CALayer *topLineLayer;
@end

@implementation Tao800PaymentCreateOrderReceiverTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed: @"Tao800PaymentCreateOrderReceiverTitleCell" owner:self options:nil];
        [self addSubview:self.customContent];
        
        CALayer *layer1 = [CALayer layer];
        CALayer *layer2 = [CALayer layer];
        CALayer *layer3 = [CALayer layer];
        
        [self.customContent.layer addSublayer:layer1];
        [self.customContent.layer addSublayer:layer2];
        [self.customContent.layer addSublayer:layer3];
        
        layer1.backgroundColor = BORDER_COLOR_GRAY1.CGColor;
        layer2.backgroundColor = BORDER_COLOR_GRAY1.CGColor;
        layer3.backgroundColor = BORDER_COLOR_GRAY1.CGColor;
        
        self.leftVerticalLineLayer = layer1;
        self.rightVerticalLineLayer = layer2;
        self.topLineLayer = layer3;
        
        self.customContent.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    return 30;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    Tao800PaymentCreateOrderReceiverTitleItem *item = (Tao800PaymentCreateOrderReceiverTitleItem *) _item;
    
    if (!item) {
        return;
    }
    
    [CATransaction begin];
    [CATransaction setValue:(id) kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    CGFloat h = SuitOnePixelHeight();
    
    CGFloat hPadding = 10;
    self.lineLayer.frame = CGRectMake(hPadding,
                                      self.height - h,
                                      self.width - hPadding * 2, h);
    
    CGFloat lineWidth = SuitOnePixelHeight();
    
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
    
    CGRect rect = self.topLineLayer.frame;
    rect.origin.x = hPadding;
    rect.origin.y = 0;
    rect.size.width = self.width - hPadding * 2;
    rect.size.height = h;
    self.topLineLayer.frame = rect;
    
    [CATransaction commit];
    
    rect = self.titleLabel.frame;
    if (item.editButtonEnabled) {
        rect.origin.x = 17;
    } else {
        rect.origin.x = 17;
    }
    self.titleLabel.frame = rect;
    [self setBackgroundColor:BACKGROUND_COLOR_GRAY2];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.titleLabel.text = nil;
}

- (void)setObject:(id)object {
    [super setObject:object];
    
    Tao800PaymentCreateOrderReceiverTitleItem *item = (Tao800PaymentCreateOrderReceiverTitleItem *) _item;
    
    if (!item) {
        return;
    }
    self.editButton.hidden = !item.editButtonEnabled;
    //    self.customContent.backgroundColor = BACKGROUND_COLOR_GRAT3;
    [self.editButton setTitleColor:BACKGROUND_COLOR_RED1 forState:UIControlStateNormal];
    [self.editButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    if (item.editButtonEnabled||item.lineEnabled) {
        self.lineLayer.backgroundColor = BORDER_COLOR_GRAY1.CGColor;
        //        self.customContent.backgroundColor = [UIColor grayColor];
    }
    if (item.lineEnabled) {
        self.leftVerticalLineLayer.hidden = NO;
        self.rightVerticalLineLayer.hidden = NO;
        self.topLineLayer.hidden = NO;
    }else{
        self.leftVerticalLineLayer.hidden = self.editButton.hidden;
        self.rightVerticalLineLayer.hidden = self.editButton.hidden;
        self.topLineLayer.hidden = self.editButton.hidden;
    }
    
    
    self.titleLabel.textColor = TEXT_COLOR_BLACK1;
    self.titleLabel.text = @"收货人信息";
    self.titleLabel.backgroundColor = [UIColor clearColor];
    
    self.editButton.backgroundColor = [UIColor clearColor];
    
    
}

-(IBAction)gotoAdressBtnClicked:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gotoAdressFromTitle:)]){
        [self.delegate gotoAdressFromTitle:self];
    }
}

@end
