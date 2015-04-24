//
//  Tao800RatingView.m
//  tao800
//
//  Created by enfeng on 14-3-3.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800RatingView.h"


CGFloat const RatingViewMaxRating=5.0f;

@implementation Tao800RatingView

- (void)commonInit
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    bgImageView.contentMode = UIViewContentModeLeft;
    [self addSubview:bgImageView];
    self.backgroundImageView = bgImageView;
    
    UIImageView *fImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    fImageView.contentMode = UIViewContentModeLeft;
    fImageView.clipsToBounds = YES;
    [self addSubview:fImageView];
    self.foregroundImageView = fImageView;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder])
    {
        [self commonInit];
    }
    
    return self;
}

- (void)setRating:(float)newRating
{
    rating = newRating;
    self.foregroundImageView.frame = CGRectMake(0.0, 0.0, self.backgroundImageView.frame.size.width * (rating / RatingViewMaxRating), self.foregroundImageView.bounds.size.height);
}

- (float)rating
{
    return rating;
}

@end
