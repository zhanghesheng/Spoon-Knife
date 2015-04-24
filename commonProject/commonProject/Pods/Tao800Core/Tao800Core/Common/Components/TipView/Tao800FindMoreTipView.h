//
//  Tao800LoadMoreFinishTipView.h
//  tao800
//
//  Created by enfeng on 14-3-12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tao800FindMoreTipView;

@protocol Tao800FindMoreTipViewDelegate <NSObject>
-(void)findMore:(Tao800FindMoreTipView *)tipView;
@end

@interface Tao800FindMoreTipView : UIView
@property (strong, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIImageView *endingLine;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property(nonatomic, weak)id<Tao800FindMoreTipViewDelegate> delegate;
@property(nonatomic, copy)NSString *keyWord;
@end
