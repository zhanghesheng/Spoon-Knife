//
//  Tao800HomeNavigationViewCTL.m
//  tao800
//
//  Created by enfeng on 12-10-18.
//  Copyright (c) 2012年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800HomeNavigationViewCTL.h"
#import "TBCore/TBCore.h"

#define kSCNavBarImageTag 12345

@interface Tao800HomeNavigationViewCTL ()

@end

@implementation Tao800HomeNavigationViewCTL

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UINavigationBar *navBar = self.navigationBar;
        
        navBar.tintColor = [UIColor blackColor];
        
        if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        {
            //if iOS 5.0 and later
            [navBar setBackgroundImage:TBIMAGE(@"bundle://nav_bg@2x.png") forBarMetrics:UIBarMetricsDefault];
        }
        else
        {

        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGRect rect = self.view.frame;
    rect.size.height = TBDefaultRowHeight;
    rect.origin.y = self.view.height-rect.size.height;
    if (!NeedResetUIStyleLikeIOS7()) {
        rect.origin.y = rect.origin.y - 20;
    }
    self.view.frame = rect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
