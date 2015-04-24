//
//  Tao800SearchNoDealHeaderView.h
//  tao800
//
//  Created by worker on 14-2-27.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBUI/TBUI.h"

@protocol Tao800SearchNoDealHeaderViewDelegate <NSObject>
-(void)addToWishList;
@end

@interface Tao800SearchNoDealHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *makeWishBtn;
@property(nonatomic, weak) CALayer *lineLayer;
@property(nonatomic, weak) CALayer *lineLayer2;
@property(nonatomic, strong) TBImageView *imageView;
@property(nonatomic, weak) IBOutlet UIView *customView;
@property(nonatomic, weak)id<Tao800SearchNoDealHeaderViewDelegate> delegate;

-(IBAction)addToWishListBtnClicked:(id)sender;
@end
