//
//  TBBlurIntroductionView.h
//  TBBlurIntroductionView-Example
//
//  Created by ShenCong  on 11/10/13.
//  Copyright (c) 2013 Matthew York. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "TBBlurView.h"
#import "TBIntroductionPanel.h"

static UIColor *kBlurTintColor = nil;
static const CGFloat kPageControlWidth = 148;
static const CGFloat kLeftRightSkipPadding = 10;
static UIFont *kSkipButtonFont = nil;
//Enum to define types of introduction finishes
typedef enum {
    TBFinishTypeSwipeOut = 0,
    TBFinishTypeSkipButton
} TBFinishType;

//Enum to define language direction
typedef enum {
    TBLanguageDirectionLeftToRight = 0,
    TBLanguageDirectionRightToLeft
}TBLanguageDirection;

@class TBBlurIntroductionView;

/******************************/
//Delegate Method Declarations
/******************************/
@protocol MYIntroductionDelegate
@optional
-(void)introduction:(TBBlurIntroductionView *)introductionView didFinishWithType:(TBFinishType)finishType;
-(void)introduction:(TBBlurIntroductionView *)introductionView didChangeToPanel:(TBIntroductionPanel *)panel withIndex:(NSInteger)panelIndex;
@end

/******************************/
//TBBlurIntroductionView
/******************************/
@interface TBBlurIntroductionView : UIView <UIScrollViewDelegate>{
    NSArray *Panels;
    
    NSInteger LastPanelIndex;
}

/******************************/
//Properties
/******************************/

//Delegate
@property (weak) id <MYIntroductionDelegate> delegate;

@property (nonatomic, retain) TBBlurView *BlurView;
@property (nonatomic, retain) UIView *BackgroundColorView;
@property (retain, nonatomic) UIImageView *BackgroundImageView;
@property (retain, nonatomic) UIScrollView *MasterScrollView;
@property (retain, nonatomic) UIPageControl *PageControl;
@property (retain, nonatomic) UIButton *RightSkipButton;
@property (retain, nonatomic) UIButton *LeftSkipButton;
@property (nonatomic, assign) NSInteger CurrentPanelIndex;
@property (nonatomic, assign) TBLanguageDirection LanguageDirection;

//Construction Methods
-(void)buildIntroductionWithPanels:(NSArray *)panels;

//Interaction Methods
- (IBAction)didPressSkipButton;
-(void)changeToPanelAtIndex:(NSInteger)index;

//Enables or disables use of the introductionView. Use this if you want to hold someone on a panel until they have completed some task
-(void)setEnabled:(BOOL)enabled;

//Customization Methods
//-(void)setBlurTintColor:(UIColor *)blurTintColor;
-(void)blurTintColorSet:(UIColor*) color;
@end
