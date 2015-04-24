//
//  TBCustomTabBarViewCTL.m
//  CustomTabBar
//
//  Created by enfeng on 13-5-21.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "TBCustomTabBarViewCTL.h"
#import "TBCustomTabBar.h"


@interface TBCustomTabBarViewCTL ()

@end

@implementation TBCustomTabBarViewCTL
@synthesize selectedIndex = _selectedIndex;
@synthesize originalViewCTLS = _originalViewCTLS;
@synthesize tabBarClass = _tabBarClass;

- (void)customOrientation:(UIInterfaceOrientation)orientation
                 duration:(NSTimeInterval)duration {
    UIViewController *ctl = [self.originalViewCTLS objectAtIndex:(uint) _selectedIndex];
    TBCustomTabBar *tabBar = (TBCustomTabBar *) [ctl.view viewWithTag:TBCustomTabBarTag];
    if (tabBar == nil) {
        return;
    }
    
    NSArray *arr = self.viewControllers;
    int tabCount = 0;
    for (UIViewController *itemCtl in arr) {
        BOOL ret = [self.originalViewCTLS containsObject:itemCtl];
        if (ret) {
            tabCount++;
        }
    }
    if (tabCount>1) {
        self.viewControllers = nil;
        [self pushViewController:ctl animated:NO]; //只保留一个，避免旋转之后，tabBar位置出错
    }

    CGFloat height = [_tabBarClass tabBarHeight];;
    CGFloat width = 0;
    CGFloat y = 0;
    CGFloat x = 0;

    CGFloat temp = 20; //statusBar 高度
    CGFloat navHeight = 0;
    tabBar.selectedIndex = self.selectedIndex;

    if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)) {
        width = self.view.frame.size.height;
        y = self.view.frame.size.width - height;
        navHeight = 0;
    } else {
        width = self.view.frame.size.width;
        y = self.view.frame.size.height - height;
        navHeight = 0;
    }

    y = y - temp - navHeight;
    CGRect rect = CGRectMake(x, y, width, height);
    [UIView animateWithDuration:duration animations:^() {
        tabBar.frame = rect;
    }                completion:^(BOOL finish) {

    }];
}

- (void) resetTabBar:(UIViewController *)ctl {
    if (_tabBarClass == nil || ![_tabBarClass isSubclassOfClass:[TBCustomTabBar class]]) {
        return;
    }
    UIView *tabBar = [ctl.view viewWithTag:TBCustomTabBarTag];
    if (tabBar == nil) {
        CGFloat height = [_tabBarClass tabBarHeight];
        CGFloat width = self.view.bounds.size.width;
        CGFloat y = ctl.view.bounds.size.height - height;
        CGFloat x = 0;
        CGRect rect = CGRectMake(x, y, width, height);
        TBCustomTabBar *tabBar1 = [[_tabBarClass alloc] init];
        tabBar1.frame = rect;
        tabBar1.tag = TBCustomTabBarTag;
        [ctl.view addSubview:tabBar1];
        tabBar1.delegate = self;
    }
    //重新设置tabBar位置
    [self customOrientation:self.interfaceOrientation duration:0];
}

- (void)setSelectedIndex:(int)selectedIndex {
    _selectedIndex = selectedIndex;
    NSUInteger count = self.originalViewCTLS.count;
    NSInteger maxIndex = count - 1;
    if (_selectedIndex > maxIndex || _selectedIndex < 0) {
        return;
    }
    UIViewController *ctl = [self.originalViewCTLS objectAtIndex:(uint) _selectedIndex];
    NSArray *arr = self.viewControllers;

    //判断视图是否已经在堆栈中
    BOOL isViewInStack = NO;
    for (UIViewController *itemCTL in arr) {
        if (itemCTL == ctl) {
            isViewInStack = YES;
            break;
        }
    }

    if (isViewInStack) {//如果在堆栈中则直接弹出
        [self popToViewController:ctl animated:NO];
    } else {
        [self pushViewController:ctl animated:NO];
    }

    [self resetTabBar:ctl];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

    NSArray *arr = self.viewControllers;
    for (UIViewController *ctl in arr) {
        [self resetTabBar:ctl];
        break;
    }
}

- (void)dealloc {
 
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)tabBar:(TBCustomTabBar *)tabBar didSelectItem:(id)sender atIndex:(int)index1 {
    [self setSelectedIndex:index1];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setNavigationBarHidden:YES animated:NO];
}
 
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
                                duration:(NSTimeInterval)duration {
    [self customOrientation:orientation duration:duration];
}

@end
