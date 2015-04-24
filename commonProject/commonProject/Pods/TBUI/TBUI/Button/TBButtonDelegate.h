//
// Created by enfeng on 12-11-27.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@class TBButton;
@class ASIHTTPRequest;

@protocol TBButtonDelegate <NSObject>
@optional

/**
 * Called when the image begins loading asynchronously.
 */
- (void)tbButtonImageDidStartLoad:(TBButton *)tbButton;

/**
 * Called when the image finishes loading asynchronously.
 */
- (void)tbButton:(TBButton *)tbButton didLoadImage:(UIImage*)image;

/**
 * Called when the image failed to load asynchronously.
 * If error is nil then the request was cancelled.
 */
- (void)tbButton:(TBButton *)tbButton didFailLoadWithError:(NSError*)error;

/**
 * Called before the image view send a network request.
 * At this point we have the opportunity to configure the requester
 * with some custom options (to use ETAGs, for example).
 */
- (void)tbButton:(TBButton *)tbButton willSendARequest:(ASIHTTPRequest*)requester;

@end