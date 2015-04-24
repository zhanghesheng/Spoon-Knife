//
// Created by enfeng on 12-10-18.
//
// To change the template use AppCode | Preferences | File Templates.
//
#import <TBNetwork/Reachability.h>
#import <TBService/TBNetworkApiAdapter.h>
#import "Tao800VCL.h"
#import "Tao800StyleSheet.h"
#import "Tao800NetworkNotReachableTipView.h"
#import "TBCore/TBCore.h"

@implementation Tao800VCL {

}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.enableShowPageTip = YES;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        self.enableShowPageTip = YES;
    }
    return self;
}

- (void)dealError:(TBErrorDescription *)error {
    NSString *errorMessage = @"当前网络不稳定，请稍后再试";

    TBNetworkApiAdapter *serviceAdapter = [TBNetworkApiAdapter sharedInstance];
    if (serviceAdapter.networkStatus == NotReachable) { //无网络
        errorMessage = nil;

        //需要显示网络断开的提示
        Tao800NetworkNotReachableTipView *mView = [[Tao800NetworkNotReachableTipView alloc]
                initWithTitle:@"当前处于无网络连接，请检查设置"
                     delegate:nil
                        style:TBBMessageViewStyleWarning
                     position:TBBMessageViewPositionBottom
           containRightButton:YES];
        [mView show];
    }

    if (serviceAdapter.networkStatus == NotReachable) {
    } else if (error.errorCode >= 500) {
        errorMessage = @"工程师们正在抢修，请稍后再试";
    } else if (error.errorCode == 404) {
        errorMessage = @"工程师们正在抢修，请稍后再试";
    }

    [self showPageLoading:NO];

    if (self.enableShowPageTip) {
        [self showPageTip:nil
                   detail:nil
                  tipType:Tao800PageTipTypeNetworkServer500];
    }

    if (errorMessage) {
        [self showTextTip:errorMessage];
    }
}

- (BOOL) needRedrawStatusBar {
    return NeedResetUIStyleLikeIOS7();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR_RED1;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.navigationBar.hidden = YES;

    [self resetStyleForIOS7];
    
    if ([self needRedrawStatusBar]) {
        UIView *statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
        statusBar.backgroundColor = BACKGROUND_COLOR_RED1;
        statusBar.tag = Tao800RedStatusBar;
        [self.view addSubview:statusBar];
    }
}

- (void)dealloc {

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self viewWillAppearDeal:animated];
}

@end