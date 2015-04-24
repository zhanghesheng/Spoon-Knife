//
//  Tao800PersonalBirthdayVCL.h
//  tao800
//
//  Created by LeAustinHan on 14-4-3.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800VCL.h"

@class Tao800RightArrowButton;

typedef void (^PersonalBirthdayCloseCallback)(void);
typedef void (^PersonalBirtndayCloseCallbackWithCancel)(void);
@interface Tao800PersonalBirthdayVCL : Tao800VCL

@property(copy) PersonalBirthdayCloseCallback closeCallback;
@property(copy) PersonalBirtndayCloseCallbackWithCancel closeCallbackWithCancel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *sckipButton;
@property (weak, nonatomic) IBOutlet UIButton *boyButton;
@property (weak, nonatomic) IBOutlet UIButton *girlButton;
@property (weak, nonatomic) IBOutlet UILabel *outLabel1;
@property (weak, nonatomic) IBOutlet UILabel *outLabel2;
//@property (weak, nonatomic) IBOutlet UILabel *outLabel3;


@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthDatePicker;

@property (strong,nonatomic) NSString *sourse;//生日设置来源，0 启动，1 分类搜索页，2 个人设置，3 母婴列表 （v3.1 打点）
//@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) UIView *superView;

-(void)readyForShow:(UIView *)superView;

-(void)showViewWithAnimation;

-(void)dismissViewWithAnimation;

@end
