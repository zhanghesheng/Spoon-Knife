//
//  Tao800PersonalBirthdayVCL.m
//  tao800
//
//  Created by LeAustinHan on 14-4-3.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PersonalBirthdayVCL.h"
#import "Tao800PersonalBirthdayModel.h"
#import "Tao800StyleSheet.h"
#import "Tao800RightArrowButton.h"
#import "Tao800NotifycationConstant.h"
#import "Tao800UGCSingleton.h"
#import "Tao800LogParams.h"
#import "Tao800Util.h"
#import "TBCore/TBCoreCommonFunction.h"

@interface Tao800PersonalBirthdayVCL ()
@property (nonatomic,strong) NSString *boyOrGirl;
@end

@implementation Tao800PersonalBirthdayVCL

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.sourse = @"";
    }
    return self;
}
- (void)setParameters:(NSDictionary *)parameters {
    [super setParameters:parameters];
}

//- (void)changeSkipButton{
//    UIImage *image = TBIMAGE(@"bundle://personal_identity_close@2x.png");
//    self.sckipButton.backgroundColor = [UIColor clearColor];
//    [self.sckipButton setImage:image forState:UIControlStateNormal];
//    float height = self.sckipButton.frame.origin.y;
//    [self.sckipButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//    [self.sckipButton setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
//    self.sckipButton.frame = CGRectMake((self.view.frame.size.width - image.size.width)/2, height, image.size.width, image.size.height);
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.sourse isEqualToString:@"3"]&&NeedResetUIStyleLikeIOS7()) {
        UIView *topView = [[UIView alloc]init];
        topView.frame = CGRectMake(0, 0, self.window.frame.size.width, 20);
        topView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
        [self.view addSubview:topView];
    }
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self fullScreenView];
    [self suitFor480Height];
    [self setDatePicker];
    // Do any additional setup after loading the view.
    Tao800PersonalBirthdayModel *model = [[Tao800PersonalBirthdayModel alloc] init];
    self.model = model;
    self.boyOrGirl = [model userBabySex];
    [self setBoyAndGirlButtonbgImage:self.boyOrGirl];

    
    
    UIImage *btnImage = TBIMAGE(@"bundle://personal_identity_baby_sure@2x.png");
    [self.confirmButton setImage:btnImage forState:UIControlStateNormal];

    
    self.confirmButton.backgroundColor = [UIColor clearColor];

//    NSString *babyBirthday = [model userBirthday];
    //母婴专区取消按钮文案：不用了，随便逛逛 其他均为：跳过 v3.6.5身份选择修改
    if ([self.sourse isEqualToString:@"3"]) {
        [self.sckipButton setTitle:@"不用了，随便逛逛" forState:UIControlStateNormal];
    }else{
        [self.sckipButton setTitle:@"跳过" forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (self.view.tag>0) {
//        [self changeSkipButton];
//    }
    [self readyForShow:self.contentView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.contentView bringSubviewToFront:self.view];
    [self showViewWithAnimation];
}

- (IBAction)handleSkip:(id)sender {
    if (sender) { //用户点击了跳过
        //创建一个默认身份
        [self setDatePicker];
        Tao800PersonalBirthdayModel *model = (Tao800PersonalBirthdayModel *)self.model;
        NSString *babyBirthday = [model userBirthday];
        self.boyOrGirl = [model userBabySex];
        [self setBoyAndGirlButtonbgImage:self.boyOrGirl];
//        NSString *babySex = [model userBabySex];
        if (babyBirthday == nil) {
            [model saveDefaultBirthday];
            [model saveDefaultSex];
            //选择生日打点
            [[Tao800UGCSingleton sharedInstance] paramsLog:Event_Baby params:@{Event_Baby_T: @"",
                                                                               Event_Baby_S: self.sourse}];
        }
    }
    [self dismissViewWithAnimation];
    if (self.closeCallbackWithCancel) {
        self.closeCallbackWithCancel();
    } else {
        [self goBackFromNavigator];
    }
}

- (IBAction)handleConfirmDate:(id)sender {
    
    if (sender) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];// HH:mm +0800
        NSString *destDateString = [dateFormatter stringFromDate:self.birthDatePicker.date];
        if (self.boyOrGirl == nil) {
            self.boyOrGirl = @"0";
        }
        NSString *sexString = self.boyOrGirl;
        //选择生日打点
        if (destDateString && self.sourse) {
            [[Tao800UGCSingleton sharedInstance] paramsLog:Event_Baby params:@{Event_Baby_T: destDateString,
                    Event_Baby_S:
                    self.sourse}];
        }

        //创建一个默认身份
        Tao800PersonalBirthdayModel *model = (Tao800PersonalBirthdayModel *)self.model;
        [model saveBirthday:@{@"birthday":destDateString}
                 completion:^(NSDictionary *dic) {
                     TBDPRINT(@"存储用户孩子生日成功");
                 }
                    failure:^(TBErrorDescription *error) {
                        TBDPRINT(@"存储用户孩子生日出现错误");
                    }];
        [model saveBabySex:@{@"babySex":sexString}
                completion:^(NSDictionary *dic) {
                    TBDPRINT(@"存储用户孩子性别成功");
                }
                   failure:^(TBErrorDescription *error) {
                       TBDPRINT(@"存储用户孩子性别出现错误");
                   }];

        TBNotify(Tao800PersonalBirthdayVCLDidChangeNotification, nil, nil);

        TBDPRINT(@"得到时间为 = %@",destDateString);
        TBDPRINT(@"得到性别为 = %@",sexString);
        
        NSString *babyBirthday = [model userBirthday];
        if (!([babyBirthday isEqualToString:@""]||babyBirthday == nil)&&[self.sourse isEqualToString:@"3"]) {
            [self.sckipButton setTitle:@"不想改了" forState:UIControlStateNormal];
        }
    }
    [self dismissViewWithAnimation];
    if (self.closeCallback) {
        self.closeCallback();
    } else {
        [self goBackFromNavigator];
    }
}

-(IBAction)boyButtonBeSelected:(id)sender{
    if ([self.boyOrGirl isEqualToString:@"1"]){
        self.boyOrGirl = @"0";
    }else{
        self.boyOrGirl = @"1";
    }
    [self setBoyAndGirlButtonbgImage:self.boyOrGirl];
    
}

-(IBAction)girlButtonBeSelected:(id)sender{
    if ([self.boyOrGirl isEqualToString:@"2"]){
        self.boyOrGirl = @"0";
    }else{
        self.boyOrGirl = @"2";
    }
    [self setBoyAndGirlButtonbgImage:self.boyOrGirl];
}

-(void)setBoyAndGirlButtonbgImage:(NSString *)boyOrGirl{
    UIImage *image1 = TBIMAGE(@"bundle://personal_identity_boy_a@2x.png");
    UIImage *image2 = TBIMAGE(@"bundle://personal_identity_girl_a@2x.png");
    UIImage *image3 = TBIMAGE(@"bundle://personal_identity_boy_b@2x.png");
    UIImage *image4 = TBIMAGE(@"bundle://personal_identity_girl_b@2x.png");
    
    //解决图片仅仅显示一个image的轮廓
    if(RequireSysVerGreaterOrEqual(@"7")){
        image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        image2 = [image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        image3 = [image3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        image4 = [image4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    __weak Tao800PersonalBirthdayVCL *intance = self;
    if ([boyOrGirl isEqualToString:@"1"]) {
        [intance.boyButton setImage:image3 forState:UIControlStateNormal];
        [intance.girlButton setImage:image2 forState:UIControlStateNormal];
    }else if ([boyOrGirl isEqualToString:@"2"]){
        [intance.boyButton setImage:image1 forState:UIControlStateNormal];
        [intance.girlButton setImage:image4 forState:UIControlStateNormal];
    }else{
        [intance.boyButton setImage:image1 forState:UIControlStateNormal];
        [intance.girlButton setImage:image2 forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma 动画准备函数
-(void)readyForShow:(UIView *)superView
{
    self.superView = superView;
    CGRect rect = self.contentView.frame;
    rect.origin.y = +self.view.size.height;
    
    self.contentView.frame = rect;
    
//    [superView addSubview:self.realView];
//    [superView bringSubviewToFront:self.realView];
    [self showViewWithAnimation];
}

-(void)showViewWithAnimation
{
    CGRect rect = self.contentView.frame;
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.5];
    //在出动画的时候减缓速度
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    //添加动画开始及结束的代理
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationWillStartSelector:@selector(beginViewAnimation)];
    
    BOOL isOverIOS7 = NeedResetUIStyleLikeIOS7();
    float change_Y;
    if (isOverIOS7) {
        change_Y = 0;
    }else{
        change_Y = 20;
    }
    rect.origin.y = self.view.frame.size.height - self.contentView.frame.size.height + change_Y;//结束位置
    
    self.contentView.frame = rect;
    
    [UIView setAnimationDidStopSelector:@selector(endViewAnimation)];
    //动画效果
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.contentView cache:YES];
    
    [UIView commitAnimations];
}

-(void)dismissViewWithAnimation
{
    CGRect rect = self.contentView.frame;
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.5];
    //在出动画的时候减缓速度
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //添加动画开始及结束的代理
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationWillStartSelector:@selector(beginDissmissViewAnimation)];
    
    
    rect.origin.y = 1000;
    self.contentView.frame = rect;
    
    [UIView setAnimationDidStopSelector:@selector(endDissmissViewAnimation)];
    //动画效果
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.contentView cache:YES];
    
    [UIView commitAnimations];
}

- (void)beginViewAnimation{
    self.superView.userInteractionEnabled = NO;
}

- (void)endViewAnimation{
    self.superView.userInteractionEnabled = YES;
}

- (void)beginDissmissViewAnimation{
    self.superView.userInteractionEnabled = NO;
}

- (void)endDissmissViewAnimation{
    [self.view removeFromSuperview];
    self.superView.userInteractionEnabled = YES;
}


-(void)suitFor480Height{
    if (self.window.height<=480) {
        CGRect rect1 = self.outLabel1.frame;
        rect1.origin.y -= 5;
        self.outLabel1.frame = rect1;
        CGRect rect2 = self.outLabel2.frame;
        rect2.origin.y -=3;
        self.outLabel2.frame = rect2;
        CGRect rect3 = self.birthDatePicker.frame;
        rect3.origin.y -=3;
        self.birthDatePicker.frame = rect3;
        CGRect rect4 = self.boyButton.frame;
        rect4.origin.y +=25;
        self.boyButton.frame = rect4;
        CGRect rect5 = self.girlButton.frame;
        rect5.origin.y += 25;
        self.girlButton.frame = rect5;
        CGRect rect6 = self.confirmButton.frame;
        rect6.origin.y +=35;
        self.confirmButton.frame = rect6;
        CGRect rect7 = self.sckipButton.frame;
        rect7.origin.y +=10;
        self.sckipButton.frame = rect7;
    }
}

-(void)fullScreenView{
    UIView* baseView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                    [[UIScreen mainScreen] applicationFrame].size.width,
                    [[UIScreen mainScreen] applicationFrame].size.height+20)];
    baseView.alpha = 0.75;
    [baseView setBackgroundColor:[UIColor colorWithHex:0x4A4A4A]];
    [self.view addSubview:baseView];
    [self.view bringSubviewToFront:self.contentView];
}


//reset datepicker
-(void)setDatePicker{
    Tao800PersonalBirthdayModel *model = [[Tao800PersonalBirthdayModel alloc] init];
//    self.model = model;
//    self.boyOrGirl = [model userBabySex];
//    [self setBoyAndGirlButtonbgImage:self.boyOrGirl];
    self.birthDatePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];// HH:mm +0800
    NSDate *dateNow = [NSDate date];
    NSString *nowString = [dateFormatter stringFromDate:dateNow];
    
    int currentYear = [[nowString substringToIndex:5] intValue];
    //产品要求可选时间范围，往前12年，往后1年
    NSDate *minDate = [dateFormatter dateFromString:[NSString stringWithFormat: @"%i-01-01",currentYear-12]];
    NSDate *maxDate = [dateFormatter dateFromString:[NSString stringWithFormat: @"%i-12-31",currentYear+1]];
    NSDate *thisYear = [dateFormatter dateFromString:[NSString stringWithFormat: @"%i-01-01",currentYear]];
    
    NSString *userBabyBirthdayStr = [model userBirthday];//取的宝宝生日
    
    if (userBabyBirthdayStr&&![userBabyBirthdayStr isEqualToString:@""]) {
        self.birthDatePicker.date = [dateFormatter dateFromString:userBabyBirthdayStr];
        //        if ([self.birthDatePicker.date compare:minDate] < 0) {
        //            minDate = self.birthDatePicker.date;
        //        }
    }else{
        self.birthDatePicker.date = thisYear;//默认显示今年的一月一日时间
    }
    
    
    self.birthDatePicker.minimumDate = minDate;
    self.birthDatePicker.maximumDate = maxDate;
}



@end
