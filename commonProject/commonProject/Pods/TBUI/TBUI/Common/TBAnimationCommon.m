//
//  MyAnimationView.m
//  yijing
//
//  Created by lufei lufei on 11-12-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TBAnimationCommon.h"
#import <QuartzCore/QuartzCore.h> 
 
@implementation TBAnimationCommon
+(void)setAnimation:(UIView *) view type:(int) _type{
    [UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
    switch (_type) {
        case ANIMATION_UP:
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:view cache:YES];
            break;
        case ANIMATION_DOWN:
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:view cache:YES];
            break;
        case ANIMATION_LEFT:
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:view cache:YES];
            break;
        case ANIMATION_RIGHT:
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:view cache:YES];     
            break;
        default:
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:view cache:YES]; 
            break;
    }
	[UIView commitAnimations];
}
+(void)setTranAnimation:(UIView *) view type:(int) _type typeID:(int) _typeID{
    CATransition *animation = [CATransition animation];
//    animation.delegate = self;
    animation.duration = 0.5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    switch (_type) {
        case ANIMATION_DANHUA:
            animation.type = kCATransitionFade;
            break;
        case ANIMATION_TUIJI:
            animation.type = kCATransitionPush;
            break;
        case ANIMATION_JIEKAI:
            animation.type = kCATransitionReveal;
            break;
        case ANIMATION_FUGAN:
            animation.type = kCATransitionMoveIn;
            break;
        case ANIMATION_LIFANGTI:
            animation.type = @"cube";
            break;
        case ANIMATION_XISHOU:
            animation.type = @"suckEffect";
            break;
        case ANIMATION_FANZHUAN:
            animation.type = @"oglFlip";
            break;
        case ANIMATION_BOWEN:
            animation.type = @"rippleEffect";
            break;
        case ANIMATION_JINGTOUKAI:
            animation.type = @"cameraIrisHollowOpen";
            break;
        case ANIMATION_JINGTOUGUAN:
            animation.type = @"cameraIrisHollowClose";
            break;
            
        default:
            animation.type = @"cube";
            break;
    } 
    switch (_typeID) {
        case 0:
            animation.subtype = kCATransitionFromLeft;
            break;
        case 1:
            animation.subtype = kCATransitionFromBottom;
            break;
        case 2:
            animation.subtype = kCATransitionFromRight;
            break;
        case 3:
            animation.subtype = kCATransitionFromTop;
            break;
        default:
            animation.subtype = kCATransitionFromRight;
            break;
    }
    //    animation.subtype = kCATransitionFromTop;
    [[view layer] addAnimation:animation forKey:@"animation"];
}
@end

