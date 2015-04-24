//
//  Tao800GuaranteeView.m
//  tao800
//
//  Created by Rose on 14-7-18.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800GuaranteeView.h"

@implementation Tao800GuaranteeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        [self initContent];
        //TBIMAGE(@"bundle://home_guarantee_list@2x.png");
    }
    return self;
}

- (void)initContent{
    self.guaranteeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview: self.guaranteeButton];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        UIImage *image = TBIMAGE(@"bundle://home_guarantee@2x.png");//;
//        if(image!=nil){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //UI线程
//                [_guaranteeButton setImage:image forState:UIControlStateNormal];
//            });
//        }
//    });
    
    self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview: self.switchButton];
/*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *image = TBIMAGE(@"bundle://home_guarantee_list@2x.png");//;
        if(image!=nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                //UI线程
                //[_switchButton setImage:image forState:UIControlStateNormal];
            });
        }
    });*/
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat selfWidth = 31;
    CGFloat selfHeigh = 73;
    CGFloat halfHeight = selfHeigh/2;
    CGFloat w = 32;
    CGFloat h = 32;
    CGFloat x = (selfWidth - w)/2;
    CGFloat y = (halfHeight - h)/2;
    self.guaranteeButton.frame = CGRectMake(x, y+3, w, h);
    
    y = y + halfHeight;
    self.switchButton.frame = CGRectMake(x, y-1, w, h);
}

@end
