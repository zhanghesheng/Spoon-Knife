//
//  Tao800DealListItemView.m
//  tao800
//
//  Created by enfeng on 14-2-13.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800DealListItemView.h"
#import "Tao800StyleSheet.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800PromotionHomeOperationVo.h"

@implementation Tao800DealListItemView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) { 
        self.backgroundColor = [UIColor whiteColor];

        UIView *customView = [[[NSBundle mainBundle]
                loadNibNamed:@"Tao800DealListItemView"
                       owner:self
                     options:nil] lastObject];
        [self addSubview:customView];
        
        self.priceLabel.textColor = TEXT_COLOR_RED1;
        self.priceLabel.font = V3_28PX_FONT;
        
        self.pointLabel.textColor = TEXT_COLOR_BLACK4;
        self.discountLabel.textColor = TEXT_COLOR_BLACK4;
        self.postLabel.textColor = TEXT_COLOR_BLACK4;
        self.soldCountLabel.textColor = TEXT_COLOR_BLACK4;
        
        self.titleLabel.textColor = TEXT_COLOR_BLACK1;
        self.imageView.defaultImage = TBIMAGE(@"bundle://common_list_default@2x.png");

        self.titleLabel.numberOfLines = 2;
        self.imageViewRect = self.imageView.frame;
    }
    return self;
}

- (void)prepareForReuse { 
    [super prepareForReuse];
}

- (void) layoutSubviews {
    [super layoutSubviews];

    
    CGFloat hPadding = 7;
    
    //商品售卖状态
    CGRect soldOutRect = self.soldOutImageView.frame;
    soldOutRect.origin.x = self.width - soldOutRect.size.width;
    self.soldOutImageView.frame = soldOutRect;
    
    //标题和图片顶部对齐
    CGRect leftImageRect = self.imageView.frame;
    CGRect titleRect = self.titleLabel.frame;
    titleRect.origin.y = leftImageRect.origin.y-1;
    titleRect.origin.x = hPadding + leftImageRect.origin.x+leftImageRect.size.width;
    CGSize size;

    if (self.soldOutImageView.hidden && self.todayImageView.hidden&& self.privilegeImageView.hidden) {
        titleRect.size.width= self.width - titleRect.origin.x-10;
        size = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(titleRect.size.width, 100)];
    } else {
        CGFloat offsetWidth = 0;
        CGFloat padding = 5;
        
        if (!self.soldOutImageView.hidden) {
            padding = 5;
            offsetWidth = self.soldOutImageView.frame.size.width;
        } else if (!self.todayImageView.hidden) {
            offsetWidth = self.todayImageView.frame.size.width;
            padding = 12;
        }else if (!self.privilegeImageView.hidden) {
            offsetWidth = self.privilegeImageView.frame.size.width;
            padding = 12;
        }
        
        titleRect.size.width = self.width - titleRect.origin.x-offsetWidth-padding;
        size = [self.titleLabel.text
                       sizeWithFont:self.titleLabel.font
                       constrainedToSize:CGSizeMake(titleRect.size.width, 100)];
    }
    titleRect.size.height = size.height;
    if (titleRect.size.height>32) { //超过了两行的高度，注意：如果调整了字体大小，当前条件也需要调整
        titleRect.size.height = 35;
    }
    
    self.titleLabel.frame = titleRect;
  
    //布局折扣和包邮
    CGRect discountRect = self.discountLabel.frame;
    CGRect postRect = self.postLabel.frame;
    CGRect soldCountRect = self.soldCountLabel.frame;
    
    discountRect.origin.x = titleRect.origin.x+1; //数字开头的，占据空白字符较少；所以向右靠一点
    discountRect.size =[self.discountLabel.text
                        sizeWithFont:self.discountLabel.font
                        constrainedToSize:CGSizeMake(300, 100)];
    discountRect.origin.y = leftImageRect.origin.y+leftImageRect.size.height - discountRect.size.height+1;
    postRect.origin.y = discountRect.origin.y;
    postRect.origin.x = self.width - postRect.size.width-hPadding;
    postRect.size.height = discountRect.size.height;
    soldCountRect.origin.y = discountRect.origin.y;
    soldCountRect.size.height = discountRect.size.height;
    
    self.discountLabel.frame = discountRect;
    self.postLabel.frame = postRect;
    self.soldCountLabel.frame = soldCountRect;
    
    //布局价格返积分, 中间空白区域垂直居中
    CGFloat centerSpaceHeight =discountRect.origin.y - (titleRect.origin.y+titleRect.size.height);//中间空白区域高度
    
    CGRect priceRect = self.priceLabel.frame;
    CGRect marketPriceRect = self.marketPriceLabel.frame;
    CGRect pointRect = self.pointLabel.frame;
    CGRect todayRect = self.todayImageView.frame;
    
    //布局价格
    priceRect.origin.x = titleRect.origin.x; //￥占据的空格比较宽，所以向左靠近点
    priceRect.size =[self.priceLabel.text
                     sizeWithFont:self.priceLabel.font
                     constrainedToSize:CGSizeMake(300, 100)];
    CGFloat offsetY = (centerSpaceHeight-priceRect.size.height)/2;
    priceRect.origin.y = titleRect.origin.y+titleRect.size.height+offsetY;
    self.priceLabel.frame = priceRect;
    
    //布局市场价, 底部和当前价格底部对齐
    marketPriceRect.size = [self.marketPriceLabel.text sizeWithFont:self.marketPriceLabel.font
                                                  constrainedToSize:CGSizeMake(200, MAXFLOAT)];
    marketPriceRect.origin.x = priceRect.origin.x + priceRect.size.width + 10;
    marketPriceRect.origin.y = priceRect.origin.y + priceRect.size.height -(marketPriceRect.size.height+1);
    self.marketPriceLabel.frame = marketPriceRect;
    
    //布局返积分, 底部和当前价格底部对齐
    pointRect.size = [self.pointLabel.text sizeWithFont:self.pointLabel.font
                                                  constrainedToSize:CGSizeMake(200, MAXFLOAT)];
    pointRect.origin.y = priceRect.origin.y + priceRect.size.height -(pointRect.size.height+1);
    pointRect.origin.x = self.width - pointRect.size.width-hPadding;
    self.pointLabel.frame = pointRect;
    
    //布局今日上新图标
    todayRect.origin.x = self.width - todayRect.size.width - 10;
    self.todayImageView.frame = todayRect;
}
@end
