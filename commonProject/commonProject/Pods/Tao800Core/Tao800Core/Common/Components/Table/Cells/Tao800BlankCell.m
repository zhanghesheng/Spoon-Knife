//
//  Tao800BlankCell.m
//  tao800
//
//  Created by LeAustinHan on 14-10-22.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//
#import "Tao800BlankItem.h"
#import "Tao800BlankCell.h"
#import "Tao800StyleSheet.h"
#import "Tao800FunctionCommon.h"


@interface Tao800BlankCell ()

@property(nonatomic, weak) CALayer *vLayer1;
@property(nonatomic, weak) CALayer *vLayer2;

@end

@implementation Tao800BlankCell

+ (NSString*) tbIdentifier {
    return @"Tao800BlankCell";
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        CALayer *layer1 = [CALayer layer];
        CALayer *layer2 = [CALayer layer];
        
        [self.contentView.layer addSublayer:layer1];
        [self.contentView.layer addSublayer:layer2];
        
        layer1.backgroundColor = BORDERLINE_COLOR_GRAY1.CGColor;
        layer2.backgroundColor = layer1.backgroundColor;
        
        self.vLayer1 = layer1;
        self.vLayer2 = layer2;
        
        self.backgroundColor = BACKGROUND_COLOR_GRAY1;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    if (_item == nil) {
//        return;
//    }
    
//    NSArray *subButtons = self.contentView.subviews;
//    UIView* boardView = [subButtons objectAtIndex:0];
//    
//    self.contentView.backgroundColor = BACKGROUND_COLOR_GRAY1;//[UIColor colorWithHex:0xECECEC];
//    self.contentView.frame = CGRectMake(0, 0, self.width, self.height);
//    boardView.frame = CGRectMake(0, 6, self.width, 146);
    
    
    [CATransaction begin];
    [CATransaction setValue:(id) kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    CGFloat h = SuitOnePixelHeight();
    CGRect rect = CGRectMake(0,
                             0,
                             self.width,
                             h);

    self.vLayer1.frame = rect;
    
    rect.origin.y = self.height-h,
    self.vLayer2.frame = rect;
    
    [CATransaction commit];

}

- (void)setObject:(id)object{
    [super setObject:object];
    
    Tao800BlankItem *item1 = (Tao800BlankItem*)_item;
    if (!item1) {
        return;
    }
    
    if (!item1.enableDisplayTopLine && self.vLayer1) {
        [self.vLayer1 removeFromSuperlayer];
        self.vLayer1 = nil;
    }
    
    if (!item1.enableDisplayBottomLine && self.vLayer2) {
        [self.vLayer2 removeFromSuperlayer];
        self.vLayer2 = nil;
    }
    if (item1.backgroundColor) {
        self.contentView.backgroundColor = item1.backgroundColor;
    }else{
        self.contentView.backgroundColor = BACKGROUND_COLOR_GRAY1;
    }
}

+(CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object{
    Tao800BlankItem *item1 = (Tao800BlankItem*)object;
    if (item1.lineHeight>1) {
        return item1.lineHeight;
    }
    return 7;
}

@end
