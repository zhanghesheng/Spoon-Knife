//
//  TBNavigationViewCTL.m
//  Tuan800API
//
//  Created by enfeng on 12-10-12.
//  Copyright (c) 2012年 com.tuan800.framework.Tuan800API. All rights reserved.
//

#import "TBNavigationViewCTL.h"
#import "TBBaseViewCTL.h"
#import "TBUINotifycationConstant.h"

NSString *const TBNavigationCTLPageTagKey = @"TBNavigationCTLPageTagKey";
NSString *const TBNavigationCTLIsModelKey = @"TBNavigationCTLIsModelKey";
NSString *const TBForwardKey = @"forwardKey";
NSString *const TBNavigationCTLLoadFromStoryboardKey = @"TBNavigationCTLLoadFromStoryboard";

@interface TBNavigationViewCTL ()

@end

@implementation TBNavigationViewCTL

- (BOOL)canDealForward:(NSNotification *)note {
    NSString *forwardKey = [note.userInfo objectForKey:TBForwardKey];
    if (forwardKey == nil) {
        return NO;
    }
    NSString *str = [_forwordDict objectForKey:forwardKey];
    if (str == nil) {
        return NO;
    }

    return YES;
}

- (void)viewDidAppearFromNotification:(NSNotification *)note {

}

- (void)viewDidDisappearFromNotification:(NSNotification *)note {

}

- (NSString*) keyFromName:(NSString*)paramName {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyMMddHHmmss"];
    NSString *targetDateString = [dateFormatter stringFromDate:date];
    
    return [NSString stringWithFormat:@"%@%@", paramName, targetDateString];
}

- (void)forwardTo:(Class)targetClass params:(NSDictionary *)params {
    Class baseClass = TBBaseViewCTL.class;
    if ([targetClass isSubclassOfClass:baseClass]) {
        NSString *className = NSStringFromClass(targetClass);
        NSString *key = [self keyFromName:className];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
        [dict setObject:key forKey:TBForwardKey];
        [_forwordDict setObject:className forKey:key];
        
        NSString *storyboardName = [params objectForKey:TBNavigationCTLLoadFromStoryboardKey];
        if(storyboardName != nil){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
            TBBaseViewCTL *ctl = [storyboard instantiateViewControllerWithIdentifier: className];
            [ctl setParameters:dict];
            [self pushViewController:ctl animated:YES];
        }else{
            TBBaseViewCTL *ctl = [[targetClass alloc] initWithParams:dict];
            [ctl setParameters:dict];
            [self pushViewController:ctl animated:YES];
        }
    }
}
 
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(viewDidAppearFromNotification:)
                                                     name:TBBaseViewCTLDidAppearNotifyCation
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(viewDidDisappearFromNotification:)
                                                     name:TBBaseViewCTLDidDisappearNotifyCation
                                                   object:nil];
        _forwordDict = [[NSMutableDictionary alloc] initWithCapacity:20];
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
