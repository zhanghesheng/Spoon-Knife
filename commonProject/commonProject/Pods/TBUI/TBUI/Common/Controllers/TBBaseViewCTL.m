//
//  TBBaseViewCTL.m
//  TBUI
//
//  Created by enfeng on 12-9-19.
//  Copyright (c) 2012年 com.tuan800.framework.ui. All rights reserved.
//

#import <objc/runtime.h>
#import "TBBaseViewCTL.h"
#import "TBActivityLabel.h"

#import "TBCore/TBCoreCommonFunction.h"
#import "TBUI.h"
#import "TBBaseViewCTL.h"

@interface TBBaseViewCTL ()

@end

@implementation TBBaseViewCTL

@synthesize paramDict = _paramDict;
@synthesize isModelViewCTL = _isModelViewCTL;
@synthesize tbNavigatorView = _tbNavigatorView;
@synthesize model = _model;

- (UIInterfaceOrientation)currentOrientation {
    return [[UIApplication sharedApplication] statusBarOrientation];
}

- (void) preBackBlock {

}

- (UIViewController *)goBack:(BOOL)animated {
    [self preBackBlock];
    
    TBNotify(TBBaseViewCTLWillGobackNotifyCation, nil, self.paramDict);

    NSDictionary *dict = [self.goBackParams copy];
    __weak TBBaseViewCTL *instance = self;
    if (self.isModelViewCTL) {
        [self dismissViewControllerAnimated:animated completion:^{

            if (instance.goBackBlock) {
                instance.goBackBlock(YES, dict);
            }
        }];
        return nil;
    } else {
        if (instance.goBackBlock) {
            instance.goBackBlock(NO, dict);
            instance.goBackBlock = nil;
        }
        return [self.navigationController popViewControllerAnimated:animated];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    if (nil != self.nibName) {
        [super loadView];
    } else {
        CGRect frame = self.wantsFullScreenLayout ? TBScreenBounds() : TBNavigationFrame();
        self.view = [[UIView alloc] initWithFrame:frame];
        self.view.autoresizesSubviews = YES;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithParams:(NSDictionary *)params {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.paramDict = params;
        NSString *str = [params objectForKey:TBNavigationCTLIsModelKey];
        self.isModelViewCTL = (str != nil);
    }
    return self;
}

- (void)setParameters:(NSDictionary *)parameters {
    self.paramDict = parameters;
    NSString *str = [parameters objectForKey:TBNavigationCTLIsModelKey];
    self.isModelViewCTL = (str != nil);
}

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [[NSNotificationCenter defaultCenter] postNotificationName:TBBaseViewCTLDidAppearNotifyCation
                                                        object:self
                                                      userInfo:self.paramDict];
}

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [[NSNotificationCenter defaultCenter] postNotificationName:TBBaseViewCTLDidDisappearNotifyCation
                                                        object:self
                                                      userInfo:self.paramDict];
}

- (TBNavigatorView *)tbNavigatorView {
    if (_tbNavigatorView == nil) {
        CGRect rect = self.view.frame;
        rect.size.height = TBDefaultRowHeight;
        rect.origin.x = 0;
        rect.origin.y = 0;
        BOOL isFromIos7 = NeedResetUIStyleLikeIOS7();
        if (isFromIos7) { //需要减去statusBar的高度
            rect.size.height = rect.size.height + TBDefaultStatusBarHeight;
        }
        TBNavigatorView *tbView = [[TBNavigatorView alloc] initWithFrame:rect];
        _tbNavigatorView = tbView;
        _tbNavigatorView.leftPadding = 5;
        _tbNavigatorView.rightPadding = 5;
        TBNavigatorItem *item = [[TBNavigatorItem alloc] init];
        _tbNavigatorView.navigatorItem = item;
        [self.view addSubview:tbView];
    }
    return _tbNavigatorView;
}

- (void)assignParamDict:(NSDictionary *)sParamDict {
    self.paramDict = sParamDict;
}

- (void)dealloc {
}

@end
