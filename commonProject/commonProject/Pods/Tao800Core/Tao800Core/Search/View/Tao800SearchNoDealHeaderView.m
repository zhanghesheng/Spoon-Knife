//
//  Tao800SearchNoDealHeaderView.m
//  tao800
//
//  Created by worker on 14-2-27.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800SearchNoDealHeaderView.h"
#import "Tao800FunctionCommon.h"
#import "Tao800StyleSheet.h"
#import "Tao800NotifycationConstant.h"

@implementation Tao800SearchNoDealHeaderView

- (id)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
//        
//        UIView *customView = [[[NSBundle mainBundle]
//                               loadNibNamed:@"Tao800SearchNoDealHeaderView"
//                               owner:self
//                               options:nil] lastObject];
//        [self addSubview:customView];
//        [self initView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [[NSBundle mainBundle] loadNibNamed:@"Tao800SearchNoDealHeaderView" owner:self options:nil];
        [self addSubview:self.customView];
        [self initView];

    }
    return self;
}

- (void)initView {
    CALayer *layer1 = [CALayer layer];
    [self.layer addSublayer:layer1];
    layer1.backgroundColor = BACKGROUND_COLOR_GRAY1.CGColor;
    self.lineLayer = layer1;
    
    CGRect rect = self.customView.frame;
    rect.size.width = self.width;
    self.customView.frame = rect;
    
    rect = self.makeWishBtn.frame;
    CGFloat x =(self.width-rect.size.width)/2;
    rect.origin.x = x;
    self.makeWishBtn.frame = rect;
//    CALayer *layer2 = [CALayer layer];
//    [self.layer addSublayer:layer2];
//    layer2.backgroundColor = BACKGROUND_COLOR_GRAY1.CGColor;
//    self.lineLayer2 = layer2;
//    
//    self.imageView = [[TBImageView alloc] initWithFrame:CGRectZero];
//    self.imageView.imageUrlPath = @"bundle://v6_category_nothing@2x.png";
//    [self addSubview:self.imageView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [CATransaction begin];
    [CATransaction setValue:(id) kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    CGFloat h = SuitOnePixelHeight();
    
    self.lineLayer.frame = CGRectMake(0,
                                      self.height - h,
                                      self.width, h);
    
//    self.lineLayer.frame = CGRectMake(0,
//                                      60 - h,
//                                      self.width, h);
//    
//    self.imageView.frame = CGRectMake(90,9,36,43);
    [CATransaction commit];
}

-(IBAction)addToWishListBtnClicked:(id)sender{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(addToWishList)]){
        [self.delegate addToWishList];
    }
}

@end
