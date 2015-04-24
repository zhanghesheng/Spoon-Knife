//
//  TBButton.m
//  TBUI
//
//  Created by enfeng on 12-11-27.
//  Copyright (c) 2012年 com.tuan800.framework.ui. All rights reserved.
//

#import "TBButton.h"
#import <Foundation/Foundation.h>
#import "UIImageAdditions.h"
#import "TBNetwork/ASIFormDataRequest.h"
#import "TBButtonDelegate.h"
#import "TBUICommon.h"
#import "TBCore/TBURLCache.h"

@interface TBButton()

@property (nonatomic, strong) NSMutableDictionary *stateUrlDict;
@property(nonatomic, copy) NSString *urlPath;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, readonly) ASIHTTPRequest *request;
@end

@implementation TBButton


- (void)releaseRequest {
    if (_request) {
        [_request setDelegate:nil];
        [_request cancel];
    }
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.stateUrlDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.stateUrlDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    _delegate = nil;
    [self releaseRequest];
}

- (void) setImage:(UIImage*) imageParam withUrl:(NSString*) url1 {
    for (NSNumber *key in self.stateUrlDict) {
        NSString *url2 = self.stateUrlDict[key];
        if ([url2 isEqualToString:url1]) {
            [self setImage:imageParam forState:key.intValue];
        }
    }
}

- (void)setImage2:(NSString *)imageURL forState:(UIControlState)state {
    UIImage *image = [[TBURLCache sharedCache] imageForURL:imageURL];
    if (nil != image) {
        [self setImage:image forState:state];
        return;
    }

    self.urlPath = imageURL;
    NSNumber *n1 = @(state);
    self.stateUrlDict[n1] = imageURL;
//    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate

- (void)requestStarted:(ASIHTTPRequest *)request {
//    [self releaseRequest];
//    _request = [request retain];

    [self imageViewDidStartLoad];
    if ([_delegate respondsToSelector:@selector(tbButtonImageDidStartLoad:)]) {
        [_delegate tbButtonImageDidStartLoad:self];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSData *response = request.responseData;
    [self releaseRequest];

    __weak id <TBButtonDelegate> delegate2 = _delegate;
    NSString *imageUrlString = request.originalURL.absoluteString;

    dispatch_queue_t mainQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(mainQueue, ^(void) {
        UIImage *image = DataToImage(response);

        if (image == nil) {
            if ([delegate2 respondsToSelector:@selector(tbButton:didFailLoadWithError:)]) {
                [delegate2 tbButton:self didFailLoadWithError:nil];
            }
        } else {
            NSData *imageData = UIImagePNGRepresentation(image);
            [[TBURLCache sharedCache] storeImage:image forURL:imageUrlString];
            [[TBURLCache sharedCache] storeData:imageData forURL:imageUrlString];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self setImage:image];
                [self setImage:image withUrl:imageUrlString];
            });
        }
    });
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = request.error;
    [self releaseRequest];

    [self imageViewDidFailLoadWithError:error];
    if ([_delegate respondsToSelector:@selector(tbButton:didFailLoadWithError:)]) {
        [_delegate tbButton:self didFailLoadWithError:error];
    }
}

- (void)imageViewDidStartLoad {
}

- (void)imageViewDidLoadImage:(UIImage *)image {
}

- (void)unsetImage {
    [self stopLoading];
    self.image = nil;
}

- (BOOL)isLoading {
    return !!_request;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoaded {
    return nil != _image;
}

- (void) downloadImage {
    if (nil == _request && nil != _urlPath) {
        if (_urlPath && [_urlPath hasPrefix:@"bundle://"]) {
            //没有取到本地图片
            return;
        }

        NSURL *url = [NSURL URLWithString:_urlPath];
        _request = [ASIHTTPRequest requestWithURL:url];
        _request.delegate = self;

        // Give the delegate one chance to configure the requester.
        if ([_delegate respondsToSelector:@selector(tbButton:willSendARequest:)]) {
            [_delegate tbButton:self willSendARequest:_request];
        }

        [_request startAsynchronous];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reload {
    if (_request) {
        [self releaseRequest];
    }

    UIImage *image = [[TBURLCache sharedCache] imageForURL:_urlPath];
    if (nil != image) {
        self.image = image;
        [self setImage:image withUrl:_urlPath];
    } else {
        [self downloadImage];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imageViewDidFailLoadWithError:(NSError *)error {
}

- (void)setUrlPath:(NSString *)urlPath {
    // Check for no changes.
    if (nil != _image && nil != _urlPath && [urlPath isEqualToString:_urlPath]) {
        if ([urlPath isEqualToString:_urlPath]) {
            UIImage *image = [[TBURLCache sharedCache] imageForURL:_urlPath];
            if (nil != image) {
                [self setImage:image withUrl:_urlPath];
            }
        }
        return;
    }

    [self stopLoading];

    {
        NSString *urlPathCopy = [urlPath copy];
        _urlPath = urlPathCopy;
    }

    if (nil == _urlPath || 0 == _urlPath.length) {
        // Setting the url path to an empty/nil path, so let's restore the default image.
        self.image = nil;
    } else {
        [self reload];
    }
}

- (void)stopLoading {
    [_request clearDelegatesAndCancel];
    _request = nil;
}
@end
