//
//  TBIntroductionPanel.h
//  TBBlurIntroductionView-Example
//
//  Created by Created by ShenCong  on 11/10/13.
//  Copyright (c) 2013 Matthew York. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TBIntroductionPanelIndex1 = 1,
    TBIntroductionPanelIndex2 = 2,
    TBIntroductionPanelIndex3 = 3,
    TBIntroductionPanelIndex4 = 4,
    TBIntroductionPanelIndex5 = 5,
    TBIntroductionPanelIndex6 = 6,
    TBIntroductionPanelIndex7 = 7,
    TBIntroductionPanelIndex8 = 8,
    TBIntroductionPanelIndex9 = 9,
    TBIntroductionPanelIndex10 = 10
}TBIntroductionPanelIndex;

const static CGFloat kTopPadding = 30;
const static CGFloat kLeftRightMargins = 10;
const static CGFloat kBottomPadding = 48;
const static CGFloat kHeaderTitlePadding = 10;
const static CGFloat kTitleDescriptionPadding = 10;
const static CGFloat kDescriptionImagePadding = 10;
static UIFont *kTitleFont = nil;
static UIColor *kTitleTextColor = nil;
static UIFont *kDescriptionFont = nil;
static UIColor *kDescriptionTextColor = nil;
static UIColor *kSeparatorLineColor = nil;

@class TBBlurIntroductionView;

@interface TBIntroductionPanel : UIView

@property (nonatomic, retain) TBBlurIntroductionView *parentIntroductionView;

@property (nonatomic, retain) UIView *PanelHeaderView;
@property (nonatomic, retain) NSString *PanelTitle;
@property (nonatomic, retain) NSString *PanelDescription;
@property (nonatomic, retain) UILabel *PanelTitleLabel;
@property (nonatomic, retain) UILabel *PanelDescriptionLabel;
@property (nonatomic, retain) UIView *PanelSeparatorLine;
@property (nonatomic, retain) UIImageView *PanelImageView;
@property (nonatomic, assign) BOOL isCustomPanel;
@property (nonatomic, assign) BOOL hasCustomAnimation;
@property (atomic, assign) TBIntroductionPanelIndex panelIndex;
@property (nonatomic, assign) CGFloat panelImageWidth;
@property (nonatomic, assign) CGFloat panelImageHeight;

//Init Methods
-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description;
-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description header:(UIView *)headerView;
-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description image:(UIImage *)image;
-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description image:(UIImage *)image header:(UIView *)headerView;
-(id)initWithFrame:(CGRect)frame nibNamed:(NSString *)nibName;
-(id)initWithFrame:(CGRect)frame nibNamed:(NSString *)nibName panelIndex:(TBIntroductionPanelIndex) index;

-(void)loadImageByPanelIndex:(TBIntroductionPanelIndex) index;

//Support Methods
+(BOOL)runningiOS7;

//Interaction Methods
-(void)panelDidAppear;
-(void)panelDidDisappear;

-(void)buildPanelWithFrame:(CGRect)frame;
@end
