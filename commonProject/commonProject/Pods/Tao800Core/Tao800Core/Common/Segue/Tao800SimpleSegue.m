//
//  Tao800SimpleSegue.m
//  universalT800
//
//  Created by enfeng on 13-11-22.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//
#import "TBCore/TBCore.h"
#import "Tao800SimpleSegue.h"
#import "TBUI/TBUI.h"

@implementation Tao800SimpleSegue

+ (void)presentModelViewCTL:(UIViewController *)ctl currentCTL:(UIViewController *)currentCTL {
    [currentCTL presentViewController:ctl animated:YES completion:^{
    }];
}

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
            //nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav = [[TBUINavigationController alloc] initWithRootViewController:vc];
        }
        [Tao800SimpleSegue presentModelViewCTL:nav currentCTL:current];
    } else {
        [current.navigationController pushViewController:vc animated:YES];
    }
}
@end
