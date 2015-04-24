//
//  Tao800RatingView.h
//  tao800
//
//  Created by enfeng on 14-3-3.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface Tao800RatingView : UIView
{
    float rating;
}

@property (nonatomic, weak)UIImageView *backgroundImageView;
@property (nonatomic, weak)UIImageView *foregroundImageView;

@property float rating;

@end