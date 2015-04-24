//
//  Tao800BannerVCL.m
//  tao800
//
//  Created by enfeng on 14/12/8.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BannerVCL.h"
#import "Tao800NotifycationConstant.h"
#import "Tao800BannerModel.h"
#import "Tao800ForwardSingleton.h"
#import "Tao800BannerDataSource.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800ConfigManage.h"
#import "Tao800StyleSheet.h"
#import "TBCore/TBCoreCommonFunction.h"

@interface Tao800BannerVCL ()

@property(nonatomic, weak) TBUICycleScrollView *cycleScrollView;
@property(nonatomic, strong) Tao800BannerModel *bannerModel;
@property(nonatomic) int bannerTimeInterval;
@property(nonatomic, retain) NSTimer *nsTimer;

- (void)fireTimer:(NSTimer *)theTimer;

@property(nonatomic, assign) BOOL dragging;
@end

@implementation Tao800BannerVCL

- (BOOL)userIsStudent {
    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    NSString *userStudentIdentity = [configManage getUserStudentIdentity];

    return [userStudentIdentity isEqualToString:@"YES"];
}

- (void)loadItems {
    __weak Tao800BannerVCL *instance = self;

    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];

    NSMutableDictionary *dict = [@{@"cityid" : @"1"} mutableCopy];
    if (dm.partner)
        [dict setValue:dm.partner forKey:@"channelid"];

    [dict setValue:@(dm.userType) forKey:@"userType"];

    //@"productkey" : dm.product
    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    NSString *userRole = [configManage getUserIdentity];
    if (userRole)
        [dict setValue:userRole forKey:@"userRole"];

    if (dm.product) {
        [dict setValue:dm.product forKey:@"productkey"];
    }
    BOOL userIsStudent = [self userIsStudent];
    if (userIsStudent) {
        [dict setValue:@"1" forKeyPath:@"student"];
    }
    [dict setValue:@"1" forKey:@"unlock"];
    [self.bannerModel loadItems:dict
                     completion:^(NSDictionary *dictParam) {
                         [instance reloadBanners];
                     } failure:^(TBErrorDescription *error) {
//                     [instance loadLotteryEntrance];
            }];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appActivate)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    TBRemoveObserver(self);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        TBAddObserver(Tao800BackgroundServiceDownImageFinish, self, @selector(reloadBannerData), nil);
        TBAddObserver(UIApplicationDidBecomeActiveNotification, self, @selector(appActivate), nil);
        TBAddObserver(UIApplicationWillResignActiveNotification, self, @selector(appWillResignActivate), nil);

        self.bannerModel = [[Tao800BannerModel alloc] init];

        self.dataSource = [[Tao800BannerDataSource alloc] init];
    }
    return self;
}


- (void)reloadBanners {

    if (self.dragging) {
        //用户正在滑动，此时不做处理
        return;
    }

    if (self.cycleScrollView.animating) {
        return;
    }

    //停止滚动
    [self stopTimer];

    self.cycleScrollView.scrollView.userInteractionEnabled = NO;
    NSArray *bannerArray = self.bannerModel.bannerItems;
    if (bannerArray == nil || bannerArray.count <= 0) {
        return;
    }

    self.bannerModel.bannerArray = bannerArray;
    if (self.bannerModel.bannerArray && self.bannerModel.bannerArray.count > 0) {
        _bannerTimeInterval = 5;
    } else {
        _bannerTimeInterval = 4;
    }

    self.cycleScrollView.pageControl.hidden = self.bannerModel.bannerArray.count <= 1;


    //清空图片缓存
    [self.dataSource.urlDict removeAllObjects];

    self.dataSource.bannerArray = bannerArray; 
    
    self.cycleScrollView.dataSource = self.dataSource;

    self.cycleScrollView.currentPage = 0;
    [self.cycleScrollView reloadData];
    self.cycleScrollView.scrollView.userInteractionEnabled = YES;

    //开始自动滚动
    [self startTimer];
}

- (void) loadRemoteImageEnabled :(BOOL) enableLoad {
    self.dataSource.loadRemoteImageEnabled = enableLoad;
}

//banner图片为一时，重载banner
- (void)reloadBannerData {
    if (self.bannerModel.bannerArray && [self.bannerModel.bannerArray count] == 1) {
        [self.cycleScrollView reloadData];
    }
}

- (void)appWillResignActivate {
    [self stopTimer];
    [self.cycleScrollView reloadData];
}

- (void)appActivate {

    [self.cycleScrollView reloadData];
    [self startTimer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self reloadBannerData];
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self stopTimer];
    [self reloadBannerData];
}

- (BOOL)needRedrawStatusBar {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cycleScrollView = (TBUICycleScrollView *) self.view;
    self.cycleScrollView.delegate = self;

    self.bannerTimeInterval = 4;

    self.cycleScrollView.pageControl.activeImage = TBIMAGE(@"bundle://home_dot_white@2x.png");
    self.cycleScrollView.pageControl.inactiveImage = TBIMAGE(@"bundle://home_dot_red@2x.png");
    self.cycleScrollView.scrollView.scrollsToTop = NO;

    self.cycleScrollView.pageControl.hidden = YES;

    [self loadItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGRect rect = self.view.bounds;
    self.dataSource.bannerSize = rect.size;

    rect.origin.y = rect.size.height - 20;
    rect.size.height = 20;

    CGFloat width = (self.cycleScrollView.pageControl.numberOfPages + 1) * 16;
    rect.size.width = width;
    rect.origin.x = (self.view.width - rect.size.width) / 2;
    self.cycleScrollView.pageControl.frame = rect;

    self.view.backgroundColor = BACKGROUND_COLOR_GRAY1;

}

- (void)stopTimer {
    if (self.nsTimer) {
        [self.nsTimer invalidate];
        self.nsTimer = nil;
    } else {
        //todo
        return;
    }
}

- (void)startTimer {
    if (self.nsTimer) {
        [self.nsTimer invalidate];
    }
    //少于一条不用轮询
    if (self.bannerModel.bannerArray == nil || self.bannerModel.bannerArray.count < 2) {
        self.cycleScrollView.scrollView.scrollEnabled = NO;
        return;
    }
    self.cycleScrollView.scrollView.scrollEnabled = YES;
    self.nsTimer = [NSTimer scheduledTimerWithTimeInterval:_bannerTimeInterval
                                                    target:self
                                                  selector:@selector(fireTimer:)
                                                  userInfo:nil repeats:YES];
}

- (void)fireTimer:(NSTimer *)theTimer {
    NSUInteger count = [self.bannerModel.bannerArray count];
    NSInteger tMax = count - 1;
    if (self.cycleScrollView.currentPage > tMax) {
        self.cycleScrollView.currentPage = 0;
    }
    NSInteger inx = self.cycleScrollView.currentPage;
    if (inx < tMax) {
        inx++;
    } else {
        inx = 0;
    }
    uint upIndex = (uint) inx;
    uint oldIndex = (uint) (self.cycleScrollView.currentPage);
    [self.cycleScrollView setCenterPageIndex:upIndex
                                    oldIndex:oldIndex
                                    animated:YES];
}

#pragma mark --- ---

- (void)cycleScrollViewWillBeginDragging:(TBUICycleScrollView *)scrollView {
    self.dragging = YES;
    [self stopTimer];
}

- (void)cycleScrollViewDidEndDragging:(TBUICycleScrollView *)scrollView willDecelerate:(BOOL)willDecelerate {
    self.dragging = NO;
    [self startTimer];
}

- (void)cycleScrollView:(TBUICycleScrollView *)scrollView didClickPageAtIndex:(NSInteger)index {
    if (self.bannerModel.bannerArray == nil || [self.bannerModel.bannerArray count] == 0) {
        return;
    } else {
        Tao800BannerVo *vo = (self.bannerModel.bannerArray)[(uint) index];
        if (!vo.bannerId) {
            return;
        }

        if (self.userDidClickOneItem) {
            self.userDidClickOneItem((int)index, [vo.bannerId intValue]);
        }

        [[Tao800ForwardSingleton sharedInstance] bannerForward:vo openByModel:YES bannerAtIndex:(int)index];
    }
}

@end
