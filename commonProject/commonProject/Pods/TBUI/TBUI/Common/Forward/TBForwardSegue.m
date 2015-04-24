//
//  TBForwardSegue.m
//  TBUI
//
//  Created by 恩锋 杨 on 15/1/7.
//  Copyright (c) 2015年 com.tuan800.framework.ui. All rights reserved.
//

#import "TBForwardSegue.h"
#import "TBUI.h"
#import "TBCore/NSString+Addition.h"

NSString *const TBBForwardSegueSplitCharacter = @"@";
NSString *const TBBForwardSeguePrefixInner = @"inner";

NSString *const TBBForwardSegueIdentifierKey = @"_standard_identifier";

@implementation TBForwardSegue

+ (id)LoadViewControllerFromStoryboard:(NSString *)storyboardName classIdentifier:(NSString *)classIdentifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    TBBaseViewCTL *vc = nil;
    if (classIdentifier) {
        vc = [storyboard instantiateViewControllerWithIdentifier:classIdentifier];
    } else {
        vc = [storyboard instantiateInitialViewController];
    }
    return vc;
}

+ (BOOL)ForwardTo:(NSDictionary *)params sourceController:(UIViewController *)sourceViewController {
    return [TBForwardSegue ForwardTo:params sourceController:sourceViewController animated:YES];
}

+ (BOOL)ForwardTo:(NSDictionary *)params
 sourceController:(UIViewController *)sourceViewController animated:(BOOL)animated {
    NSString *pIdentifier = params[TBBForwardSegueIdentifierKey];
    
    if (!pIdentifier
        || pIdentifier.length < 1
        || [pIdentifier hasPrefix:TBBForwardSeguePrefixInner]) {
        
        return NO;
    }
    
    NSRange range = [pIdentifier rangeOfString:TBBForwardSegueSplitCharacter];
    NSString *storyboardName = pIdentifier;
    NSString *classIdentifier = pIdentifier;
    classIdentifier = [classIdentifier trim];
    
    BOOL useClassIdentifier = NO;
    if (range.length > 0) {
        NSArray *arr = [pIdentifier componentsSeparatedByString:TBBForwardSegueSplitCharacter];
        if (arr.count == 2) {
            storyboardName = arr[0];
            classIdentifier = arr[1];
            useClassIdentifier = YES;
            
            storyboardName = storyboardName.trim;
            classIdentifier = classIdentifier.trim;
        }
    }
    
    UIViewController *current = sourceViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    id vc = nil;
    if (useClassIdentifier) {
        vc = [storyboard instantiateViewControllerWithIdentifier:classIdentifier];
    } else {
        vc = [storyboard instantiateInitialViewController];
    }
    
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *) vc;
        NSArray *viewControllers = nav.viewControllers;
        if (viewControllers.count > 0) {
            TBBaseViewCTL *viewCTL = viewControllers[0];
            [viewCTL setParameters:params];
        }
    } else {
        [vc setParameters:params];
    }
    
    NSString *modelKey = params[TBNavigationCTLIsModelKey];
    BOOL isModelCTL = NO;
    if (modelKey) {
        isModelCTL = [modelKey boolValue];
    }
    
    if (isModelCTL) {
        TBBaseViewCTL *vc2 = vc;
        vc2.isModelViewCTL = YES;
        UINavigationController *nav = vc2.navigationController;
        if (!nav) {
            nav = [[TBUINavigationController alloc] initWithRootViewController:vc];
            
        }
        [current presentViewController:nav animated:YES completion:^{
        }];
    } else {
        if ([current isKindOfClass:[UINavigationController class]]) {
            UINavigationController *uc = (UINavigationController *) current;
            if ([vc isKindOfClass:[UINavigationController class]]) {
                UINavigationController *uCTL = (UINavigationController *) vc;
                UIViewController *sCTL = [uCTL topViewController];
                [uc pushViewController:sCTL animated:animated];
            } else {
                [uc pushViewController:vc animated:animated];
            }
        } else {
            if ([vc isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nav = (UINavigationController *) vc;
                NSArray *viewControllers = nav.viewControllers;
                if (viewControllers.count > 0) {
                    vc = viewControllers[0];
                    TBBaseViewCTL *vc2 = vc;
                    [vc2 setParameters:params];
                }
            }
            [current.navigationController pushViewController:vc animated:animated];
        }
    }
    return YES;
}

/**
 * 如果是跳到storybard, 需要包含storyboard名字以及类的identifier，如：
 * storybardName@classIdentifier
 *
 * 如果self.identifier 以inner开头则跳到父类处理
 */
- (void)perform {
    if (self.cancel) {
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.forwardParams];
    [dict setValue:self.identifier forKey:TBBForwardSegueIdentifierKey];
    
    if (![TBForwardSegue ForwardTo:dict sourceController:self.sourceViewController]) {
        [super perform];
    }
}

@end