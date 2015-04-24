//
//  Tao800ForwardSegue.m
//  universalT800
//
//  Created by enfeng on 13-11-11.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "Tao800ForwardSegue.h"
#import "TBUI/TBUI.h"
#import "TBCore/TBCore.h"

@implementation Tao800ForwardSegue


+ (BOOL)ForwardTo:(NSDictionary *)params sourceController:(UIViewController *)sourceViewController {
    [[NSNotificationCenter defaultCenter] postNotificationName:Tao800PromotionGifWillRemoveNotification object:nil];
    return [Tao800ForwardSegue ForwardTo:params sourceController:sourceViewController animated:YES];
}

@end
