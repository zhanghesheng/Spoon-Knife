//
//  Tao800PaymentCreateOrderReceiverSetCell.m
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PaymentCreateOrderReceiverSetCell.h"
#import "Tao800PaymentCreateOrderReceiverSetItem.h"
#import "Tao800FunctionCommon.h"
@interface Tao800PaymentCreateOrderReceiverSetCell ()

@property(nonatomic, weak) CALayer *leftVerticalLineLayer;
@property(nonatomic, weak) CALayer *rightVerticalLineLayer;

@end

@implementation Tao800PaymentCreateOrderReceiverSetCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed: @"Tao800PaymentCreateOrderReceiverSetCell" owner:self options:nil];
        
        CALayer *layer1 = [CALayer layer];
        CALayer *layer2 = [CALayer layer];
        
        [self.customContent.layer addSublayer:layer1];
        [self.customContent.layer addSublayer:layer2];
        
        layer1.backgroundColor = BORDER_COLOR_GRAY1.CGColor;
        layer2.backgroundColor = BORDER_COLOR_GRAY1.CGColor;
        
        self.leftVerticalLineLayer = layer1;
        self.rightVerticalLineLayer = layer2;
        
        [self addSubview:self.customContent];
    }
    return self;
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    Tao800PaymentCreateOrderReceiverSetItem *item = (Tao800PaymentCreateOrderReceiverSetItem *) object;
    if (item.formLottery) {
        return 83;
    }
    return 74;
}

-(void)layoutSubviews{
    [super layoutSubviews];
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
    
    [CATransaction commit];
    if ([self.setButton.currentTitle isEqualToString:@"设置地址"]) {
        CGRect rect = self.setButton.frame;
        rect.size.width = 100;
        rect.origin.x = (self.width - rect.size.width)/2;
        self.setButton.frame = rect;
    }
}

- (void) prepareForReuse {
    [super prepareForReuse];
}

- (void)setObject:(id)object {
    [super setObject:object];

    UIImage *image = TBIMAGE(@"bundle://tip_red_bg_btn@2x.png");
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    [self.setButton setBackgroundImage:image forState:UIControlStateNormal];
    self.customContent.backgroundColor = BACKGROUND_COLOR_GRAT2;
    Tao800PaymentCreateOrderReceiverSetItem *item = (Tao800PaymentCreateOrderReceiverSetItem *) _item;
    
    if (!item) {
        return;
    }

    self.leftVerticalLineLayer.hidden = YES;
    self.rightVerticalLineLayer.hidden = YES;
    
    if (item.formLottery) {
        self.customContent.backgroundColor = [UIColor whiteColor];
        self.tipLabel.hidden = NO;
        [self.setButton setTitle:@"设置地址" forState:UIControlStateNormal];
        self.leftVerticalLineLayer.hidden = NO;
        self.rightVerticalLineLayer.hidden = NO;
    }else{
        CGRect rect = self.contentView.frame;
        rect.size.height = 74;
        self.contentView.frame = rect;
        CGRect rectBtn = self.setButton.frame;
        rectBtn.origin.y = 18;
        self.setButton.frame = rectBtn;
    }

    if (self.lineLayer) {
        [self.lineLayer removeFromSuperlayer];
        self.lineLayer = nil;
    }
    
}

-(IBAction)gotoAdressBtnClicked:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gotoAdressFromSetting:)]){
        [self.delegate gotoAdressFromSetting:self];
    }
}

@end
