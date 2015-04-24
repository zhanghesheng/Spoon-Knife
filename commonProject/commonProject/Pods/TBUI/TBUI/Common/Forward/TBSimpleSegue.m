//
//  TBSimpleSegue.m
//  TBUI
//
//  Created by 恩锋 杨 on 15/1/7.
//  Copyright (c) 2015年 com.tuan800.framework.ui. All rights reserved.
//
#import "TBUINavigationController.h"
#import "TBSimpleSegue.h"

#import "TBBaseViewCTL.h"
#import "TBNavigationViewCTL.h"

@implementation TBSimpleSegue


- (id)initWithIdentifier:(NSString *)identifier
                  source:(UIViewController *)source
             destination:(UIViewController *)destination {
    
    
    self = [super initWithIdentifier:identifier source:source destination:destination];
    if (self) {
        
    }
    return self;
}

- (void)perform {
    if (self.cancel) {
        return;
    }
    
    UIViewController *current = self.sourceViewController;
    TBBaseViewCTL *vc = self.destinationViewController;
    [vc setParameters:self.forwardParams];
    
    NSString *modelKey = [self.forwardParams objectForKey:TBNavigationCTLIsModelKey];
    BOOL isModelCTL = NO;
    if (modelKey) {
        isModelCTL = [modelKey boolValue];
    }
    
    if (isModelCTL) {
        vc.isModelViewCTL = YES;
        UINavigationController *nav = vc.navigationController;
        if (!nav) {
            nav = [[TBUINavigationController alloc] initWithRootViewController:vc];
        }
        [current presentViewController:nav animated:YES completion:^{
        }];
    } else {
        [current.navigationController pushViewController:vc animated:YES];
    }
}

@end
