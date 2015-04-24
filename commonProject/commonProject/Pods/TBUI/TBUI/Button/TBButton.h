//
//  TBButton.h
//  TBUI
//
//  Created by enfeng on 12-11-27.
//  Copyright (c) 2012年 com.tuan800.framework.ui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TBNetwork/ASIHTTPRequestDelegate.h"

@protocol TBButtonDelegate;

@interface TBButton : UIButton <ASIHTTPRequestDelegate> {

}

@property(nonatomic, strong) NSObject *userData;
@property(nonatomic, weak) id <TBButtonDelegate> delegate;

- (void)unsetImage;

- (BOOL)isLoading;

- (void)stopLoading;

- (void)setImage2:(NSString *)imageURL forState:(UIControlState)state;

/**
 * Called when the image begins loading asynchronously.
 * Overridable method.
 *
 * @protected
 */
- (void)imageViewDidStartLoad;

/**
 * Called when the image finishes loading asynchronously.
 * Overridable method.
 *
 * @protected
 */
- (void)imageViewDidLoadImage:(UIImage *)image;

/**
 * Called when the image failed to load asynchronously.
 * Overridable method.
 *
 * @protected
 */
- (void)imageViewDidFailLoadWithError:(NSError *)error;
@end
