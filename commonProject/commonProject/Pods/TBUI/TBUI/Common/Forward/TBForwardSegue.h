//
//  TBForwardSegue.h
//  TBUI
//
//  Created by 恩锋 杨 on 15/1/7.
//  Copyright (c) 2015年 com.tuan800.framework.ui. All rights reserved.
//

#import "TBSimpleSegue.h"

extern NSString *const TBBForwardSegueIdentifierKey;
extern NSString *const TBBForwardSegueSplitCharacter;
extern NSString *const TBBForwardSeguePrefixInner;

@interface TBForwardSegue : TBSimpleSegue
+ (BOOL)ForwardTo:(NSDictionary *)params sourceController:(UIViewController *)sourceViewController;

+ (BOOL)ForwardTo:(NSDictionary *)params
 sourceController:(UIViewController *)sourceViewController animated:(BOOL)animated;


+ (id)LoadViewControllerFromStoryboard:(NSString *)storyboardName
                       classIdentifier:(NSString *)classIdentifier;
@end
