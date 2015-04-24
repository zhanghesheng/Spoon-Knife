//
//  Tao800DealListItemBaseView.m
//  tao800
//
//  Created by enfeng on 14-2-21.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800DealListItemBaseView.h"
#import "Tao800DealBaseItem.h"

@implementation Tao800DealListItemBaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) { 
        //[self addSubview:_htmlLabelView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect priceRect = self.priceLabel.frame;
    priceRect.size = [self.priceLabel.text sizeWithFont:self.priceLabel.font
                                      constrainedToSize:CGSizeMake(200, MAXFLOAT)];
    self.priceLabel.frame = priceRect;

    CGRect marketPriceRect = self.marketPriceLabel.frame;
    marketPriceRect.size = [self.marketPriceLabel.text sizeWithFont:self.marketPriceLabel.font
                                                  constrainedToSize:CGSizeMake(200, MAXFLOAT)];
    marketPriceRect.origin.x = priceRect.origin.x + priceRect.size.width + 5;
    marketPriceRect.origin.y = priceRect.origin.y + priceRect.size.height -(marketPriceRect.size.height+1);
    self.marketPriceLabel.frame = marketPriceRect;

}

- (void)prepareForReuse {
    
    self.titleLabel.text = nil;
    self.discountLabel.text = nil;
    self.pointLabel.text = nil;
    self.priceLabel.text = nil;
    self.postLabel.text = nil;
    self.marketPriceLabel.text = nil;
    self.tipLabel.text = nil;
    self.tipPrivilegeLabel.text = nil;
    self.maskView2.titleLabel.text = nil;
    self.htmlString = nil;
    
    [self.imageView unsetImage];
    //全删除 防止图片显示错误
//    [self.imageView removeFromSuperview];
//    self.imageView = nil;

    //用于曝光打点的判断
    self.item.disappearTime = [[NSDate date] timeIntervalSince1970];
}
@end
