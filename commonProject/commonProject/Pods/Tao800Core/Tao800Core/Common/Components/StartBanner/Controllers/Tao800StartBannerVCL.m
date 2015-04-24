//
//  Tao800StartBannerVCL.m
//  tao800
//
//  Created by enfeng on 14/12/12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800StartBannerVCL.h"
#import "Tao800LogParams.h"
#import "Tao800UGCSingleton.h"
#import "Tao800BannerVo.h"
#import "Tao800ForwardSingleton.h"
#import "Tao800StartBannerModel.h"
#import "Tao800StartInfoVo.h"
#import "Tao800ConfigManage.h"
#import "Tao800FunctionCommon.h"
#import "TBCore/TBCore.h"


CGFloat const TZSliderLeftContentOffset = 190;

@interface Tao800StartBannerVCL () <UIGestureRecognizerDelegate> {
    
}
@property (nonatomic) CGFloat currentTranslateX;
@property(nonatomic, strong) Tao800StartBannerModel *startBannerModel;
@property(nonatomic, strong) UIImage *centerImage;
@property (nonatomic, strong) UIPanGestureRecognizer* centerPanGesture;
@property (nonatomic) int appearedCount;

//@property (nonatomic, weak) UIWindow *sWindow;

@property (nonatomic, strong) NSTimer *closeTimer;
@end

@implementation Tao800StartBannerVCL

- (void)dealloc {

}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.appearedCount = 0;
        self.startBannerModel = [[Tao800StartBannerModel alloc] init];
    }
    return self;
}

- (void)setParameters:(NSDictionary *)parameters {
    [super setParameters:parameters];

    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    NSArray *array = [configManage getStartBigBannerData];
    if (array.count > 0) {
        self.startBannerModel.startInfoVo = array[0];

        Tao800StartInfoVo *startInfoVo = array[0];
        UIImage *image = nil;

        // 判断是否是iphone5分辨率
        if (TBIsAfterIphone4()) {
            image = [[TBURLCache sharedCache] imageForURL:startInfoVo.bigImageUrl];
        } else {
            image = [[TBURLCache sharedCache] imageForURL:startInfoVo.normalImageUrl];
        }

        if (!CompareDateIsSmall(startInfoVo.expireTime)) {
            self.centerImage = image;
        }
    }

}

- (void)gobackCallback:(NSTimeInterval) duration {

    __weak Tao800StartBannerVCL *instance = self;

    [UIView animateWithDuration:duration
                     animations:^() {
                         CGRect rect = self.startNewsView.frame;
                         rect.origin.x = -self.startNewsView.frame.size.width;
                         self.startNewsView.frame = rect;
                     }
                     completion:^(BOOL finish) {
                         if (instance.goBackBlock) {
                             instance.goBackBlock(YES, nil);
                         }
                         [self.startNewsView removeFromSuperview];
//                         self.sWindow.windowLevel = UIWindowLevelNormal;
                         TBNotify(TBBaseViewCTLWillGobackNotifyCation, nil, self.paramDict);
                         [instance willMoveToParentViewController:nil];
                         [instance.view removeFromSuperview];
                         [instance removeFromParentViewController];

                     }];


}

- (BOOL)needRedrawStatusBar {
    return NO;
}

- (void) closeTimerNote : (id) sender {
    [self.closeTimer invalidate];
    self.closeTimer = nil;

    [self gobackCallback:.2];
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.sWindow = self.window;
//    self.sWindow.windowLevel = UIWindowLevelStatusBar+1;
//    [self.sWindow addSubview:self.startNewsView];

    self.startNewsView.startNewsDelegate = self;
    self.startNewsView.dragEnable = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(startNewsViewTapEvent:)];
    tap.delegate = self;
    [self.startNewsView addGestureRecognizer:tap];

    self.view.backgroundColor = [UIColor clearColor];
    self.startNewsView.defaultImage = self.centerImage;

    self.centerPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    [self.startNewsView addGestureRecognizer:(self.centerPanGesture)];

    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3
                                                      target:self
                                                    selector:@selector(closeTimerNote:)
                                                    userInfo:nil
                                                     repeats:NO];

    self.closeTimer = timer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handlerDetailAction:(id)sender {

    if (self.closeTimer) {
        [self.closeTimer invalidate];
        self.closeTimer = nil;
    }
//    [self.startNewsView removeFromSuperview];
//    self.window.windowLevel = UIWindowLevelNormal;

    NSDictionary *bannerDic = @{
            Event_Banner_Id :[NSString stringWithFormat:@"%@", self.startBannerModel.startInfoVo.bannerId],
            Event_Banner_Order : @"1",
            Event_Banner_U:[[Tao800UGCSingleton sharedInstance] getUserTypeUserRoleStudentString],
            Event_Banner_Position : [NSString stringWithFormat:@"%@", @"2"],
    };
    //2启动大图
    [[Tao800UGCSingleton sharedInstance] paramsLog:Event_Banner params:bannerDic];

    __weak Tao800StartBannerVCL *instance = self;

    Tao800BannerVo *bannerVo = [instance.startBannerModel getBannerVo];
    bannerVo.exposureRefer = Tao800ExposureReferLaunchBigBanner;
    bannerVo.dealDetailFrom = Tao800DealDetailFromStartInfo;
    [[Tao800ForwardSingleton sharedInstance] bannerForward:bannerVo openByModel:NO bannerAtIndex:-1];
}

- (IBAction)handlerSkipAction:(id)sender {
    [self gobackCallback:.3];
}

- (void)startNewsViewTapEvent:(UITapGestureRecognizer *)sender {

    //对于ios5会优先进入该方法，按钮不会被响应，需要判断是否点击的按钮
    CGPoint location = [sender locationOfTouch:0 inView:self.startNewsView];
    CGRect rect = self.startNewsView.skipOverButton.frame;

    NSDictionary *bannerDic = @{
            Event_Banner_Id : [NSString stringWithFormat:@"%@", self.startBannerModel.startInfoVo.bannerId],
            Event_Banner_Order : @"1",
            Event_Banner_U:[[Tao800UGCSingleton sharedInstance] getUserTypeUserRoleStudentString],
            Event_Banner_Position : [NSString stringWithFormat:@"%@", @"2"],
    };
    //2启动大图
    [[Tao800UGCSingleton sharedInstance] paramsLog:Event_Banner params:bannerDic];

    BOOL touchOnSkipButton = CGRectContainsPoint(rect, location);
    if (touchOnSkipButton) {
        [self startNewsViewClosed];
    } else {
        [self handlerDetailAction:nil];
    }
    return;
}

#pragma mark --- Tao800StartNewsViewDelegate Methods ---

- (void)startNewsViewTouchesMoved:(float)offsetX {

}

- (void)startNewsViewClosed {
    [self gobackCallback:.3];
}

#pragma mark --- UIGestureRecognizerDelegate Methods ---

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ![touch.view isMemberOfClass:[UIButton class]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.appearedCount++;
  
    if (self.appearedCount>1) {
        //点击过详情
        //当从详情返回时直接关闭当前页面
        [self gobackCallback:0];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.appearedCount<2) {
        //创建屏幕截图，
        //当点击进入详情页时，删除滑动视图，显示屏幕截图; 这样可以不影响页面打开时的动画效果

        //滑动时需要将layer 置空, 看到首页
//        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
//        [self.startNewsView.layer renderInContext:UIGraphicsGetCurrentContext()];
//        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        self.view.layer.contents = (id) img.CGImage;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.closeTimer) {
        [self.closeTimer invalidate];
        self.closeTimer = nil;
    }
}

- (void) finishCurrentAnimationAndGoBack {
    
    if (self.closeTimer) {
        [self.closeTimer invalidate];
        self.closeTimer = nil;
    }
    
    CGAffineTransform conT = CGAffineTransformMakeTranslation(-self.view.width, 0);
    [UIView animateWithDuration:.3 animations:^{
        self.startNewsView.transform = conT;
    } completion:^(BOOL finish){
        [self gobackCallback:0];
    }];
}

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes {

    if (panGes.state == UIGestureRecognizerStateBegan) {
        self.currentTranslateX = self.startNewsView.transform.tx;
    }

    CGFloat transX = [panGes translationInView:self.startNewsView].x;
    transX = transX + self.currentTranslateX;
    BOOL isTransformView = transX < 0;   //正在向左滑动

    int pt = abs((int)transX);

    if (panGes.state == UIGestureRecognizerStateChanged) {
        [self.closeTimer setFireDate:[NSDate distantFuture]];

        if (isTransformView) {
            if (pt > TZSliderLeftContentOffset) {
              
                //关闭, 执行关闭的动画
                [self finishCurrentAnimationAndGoBack];
                return;
            }

            CGAffineTransform transT = CGAffineTransformMakeTranslation(transX, 0);
            self.startNewsView.transform = transT;
        }
    } else if (panGes.state == UIGestureRecognizerStateEnded) {
        CGFloat lastX = self.startNewsView.transform.tx;

        if (isTransformView) {
            if (pt > 90) { //如果右侧已经漏出90的宽度，则进行关闭动画

                [self finishCurrentAnimationAndGoBack];
                return;
            }
        }

        if (lastX>self.currentTranslateX) { //向右滑动
            CGAffineTransform conT = CGAffineTransformMakeTranslation(TZSliderLeftContentOffset, 0);
            [UIView beginAnimations:nil context:nil];
            self.startNewsView.transform = conT;

            [UIView commitAnimations];
            return;
        } else {
            [UIView beginAnimations:nil context:nil];
            self.startNewsView.transform = CGAffineTransformIdentity;
            [UIView commitAnimations];

//            self.blackCoverTapGesture.enabled = NO;
        }
        [self.closeTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    }
}

@end
