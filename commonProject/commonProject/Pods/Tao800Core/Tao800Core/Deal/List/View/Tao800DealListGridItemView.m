//
//  Tao800DealListGridItemView.m
//  tao800
//
//  Created by enfeng on 14-2-13.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800DealListGridItemView.h"
#import "Tao800StyleSheet.h"
#import "Tao800Util.h"
#import "TBCore/TBCoreCommonFunction.h"

@implementation Tao800DealListGridItemView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

        UIView *customView = [[[NSBundle mainBundle]
                loadNibNamed:@"Tao800DealListGridItemView"
                       owner:self
                     options:nil] lastObject];
        [self addSubview:customView];

//        UIImage *bgImage = [Tao800Util imageWithColor:[UIColor colorWithHex:0x000000 alpha:.4]
//                                               bounds:CGRectMake(0, 0, 1, 1)];
        CGRect rect = customView.frame;
        CGFloat width = self.screenFrame.size.width;
        if (TBIsIPhone6()) {
            rect.size.width = TBGetIphone6HeightByScaleWidth320Height(width);
            rect.size.height = TBGetIphone6HeightByScaleWidth320Height(rect.size.height);
        }else if (TBIsIPhone6Plus()){
            rect.size.width = TBGetIphone6PlusHeightByScaleWidth320Height(width);
            rect.size.height = TBGetIphone6PlusHeightByScaleWidth320Height(rect.size.height);
        }
        customView.frame = rect;
//        customView.backgroundColor = [UIColor redColor];

        NSArray *arr = [self subviews];
        for (UIView *view in arr) {
            if ([view isKindOfClass:[UIButton class]]) {
                [self bringSubviewToFront:view];
                if (view.frame.size.width > self.frame.size.width / 2) {
                    self.maskButton = (UIButton *) view;
//                    [self.maskButton setBackgroundImage:bgImage forState:UIControlStateHighlighted];
                }
            }
        }

        self.priceLabel.textColor = TEXT_COLOR_RED1;
        self.priceLabel.font = V3_28PX_FONT;

        self.pointLabel.textColor = TEXT_COLOR_BLACK4;
        self.discountLabel.textColor = TEXT_COLOR_BLACK4;
        self.postLabel.textColor = TEXT_COLOR_BLACK4;
        self.soldCountLabel.textColor = TEXT_COLOR_BLACK4;

        self.titleLabel.textColor = TEXT_COLOR_BLACK1;

        self.imageView.defaultImage = TBIMAGE(@"bundle://common_grid_default@2x.png");
        self.backgroundColor = BACKGROUND_COLOR_GRAY1;
        
        self.imageViewRect = self.imageView.frame; 
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect titleRect = self.titleLabel.frame;
    if (self.soldOutImageView.hidden && self.todayImageView.hidden&& self.privilegeImageView.hidden) {
        titleRect.size.width= self.width - titleRect.origin.x-5;
        self.titleLabel.frame = titleRect;
    } else {
        CGFloat offsetWidth = 0;
        CGFloat padding = 5;
        
        if (!self.soldOutImageView.hidden) {
            padding = 5;
            offsetWidth = self.soldOutImageView.frame.size.width;
        } else if (!self.todayImageView.hidden) {
            offsetWidth = self.todayImageView.frame.size.width;
            padding = 12;
        } else if (!self.privilegeImageView.hidden) {
            offsetWidth = self.privilegeImageView.frame.size.width;
            padding = 12;
        }
        
        titleRect.size.width = self.width - titleRect.origin.x-offsetWidth-padding;
        self.titleLabel.frame = titleRect;
    }
    
 
    
    CGRect rect = self.favoriteButton.frame;
    rect.origin.x = self.frame.origin.x + self.frame.size.width - rect.size.width;
    rect.origin.y = self.frame.origin.y + self.imageView.frame.size.height - rect.size.height+8;
    self.favoriteButton.frame = rect;
    
    rect = self.soldCountLabel.frame;
    rect.size.width = 88;
    self.soldCountLabel.frame = rect;
    //self.soldCountLabel.backgroundColor = [UIColor yellowColor];
}

@end
