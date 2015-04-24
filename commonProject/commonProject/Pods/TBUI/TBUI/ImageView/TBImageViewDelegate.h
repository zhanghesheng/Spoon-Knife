//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TBImageView;
@class ASIHTTPRequest;

@protocol TBImageViewDelegate <NSObject>
@optional

/**
 * Called when the image begins loading asynchronously.
 */
- (void)imageViewDidStartLoad:(TBImageView *)imageView;

/**
 * Called when the image finishes loading asynchronously.
 */
- (void)imageView:(TBImageView *)imageView didLoadImage:(UIImage*)image;

/**
 * Called when the image failed to load asynchronously.
 * If error is nil then the request was cancelled.
 */
- (void)imageView:(TBImageView *)imageView didFailLoadWithError:(NSError*)error;

/**
 * Called before the image view send a network request.
 * At this point we have the opportunity to configure the requester
 * with some custom options (to use ETAGs, for example).
 */
- (void)imageView:(TBImageView *)imageView willSendARequest:(ASIHTTPRequest*)requester;

@end
