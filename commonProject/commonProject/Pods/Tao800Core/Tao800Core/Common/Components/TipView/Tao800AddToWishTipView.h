//
//  Tao800LoadMoreFinishTipView.h
//  tao800
//
//  Created by enfeng on 14-3-12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Tao800AddToWishTipViewDelegate <NSObject>
-(void)addToWishList;
@end

@interface Tao800AddToWishTipView : UIView
@property (strong, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIImageView *endingLine;
@property (weak, nonatomic) IBOutlet UIButton *wishButton;
@property(nonatomic, weak)id<Tao800AddToWishTipViewDelegate> delegate;
@end
