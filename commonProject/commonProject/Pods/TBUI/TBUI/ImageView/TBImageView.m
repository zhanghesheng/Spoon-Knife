#import "TBImageView.h"
#import "TBImageViewDelegate.h"

#import "UIImageAdditions.h"
#import "TBNetwork/ASIFormDataRequest.h"
#import "TBImageLayer.h"
#import "TBUICommon.h"
#import "TBCore/TBURLCache.h"
#import "TBCore/TBGlobalCorePaths.h"
 
#import "UIViewAdditions.h"
#import "TBImageLayer.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

@interface TBImageView()

@property (nonatomic, copy) NSString *referrer;
@end

@implementation TBImageView

@synthesize urlPath = _urlPath;
@synthesize image = _image;
@synthesize defaultImage = _defaultImage;
@synthesize autoresizesToImage = _autoresizesToImage;
@synthesize delegate = _delegate;
@synthesize request = _request;

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [self.layer insertSublayer:self.layer2 atIndex:0];
}

- (void) initContent {
     _autoresizesToImage = NO;
    
    CALayer *layerX = [[CALayer alloc] init];
    [self.layer addSublayer:layerX];
    self.layer2 = layerX;
    
//    self.layer2.opacity = 0;
}

- (void)releaseRequest {
    if (_request) {
        [_request clearDelegatesAndCancel];
    }
    _request = nil;

}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
       
        [self initContent];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initContent];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    _delegate = nil;

    [self releaseRequest];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (Class)layerClass {
    return [TBImageLayer class];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.layer setNeedsDisplay];
    self.layer2.frame = self.bounds;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawContent:(CGRect)rect {
    if (nil != _image) {
        [_image drawInRect:rect contentMode:self.contentMode];

    } else {
        [_defaultImage drawInRect:rect contentMode:self.contentMode];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark ASIHTTPRequestDelegate

- (void)requestStarted:(ASIHTTPRequest *)request {
//    [self releaseRequest];
//    _request = [request retain];

    [self imageViewDidStartLoad];
    if ([_delegate respondsToSelector:@selector(imageViewDidStartLoad:)]) {
        [_delegate imageViewDidStartLoad:self];
    }
}

- (void)setImage:(UIImage *)image imageURL:(NSString *)imageURL {
    if ([imageURL isEqualToString:_urlPath]) {
        [self setImage:image enableAnimation:YES];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSData *response = request.responseData;
    [self releaseRequest];

    __weak id <TBImageViewDelegate> delegate2 = _delegate;
    __weak TBImageView * instance = self;
    NSString *imageUrlString = request.originalURL.absoluteString;

    dispatch_queue_t mainQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(mainQueue, ^(void) {
        UIImage *image = DataToImage(response);

        if (image == nil) {
            if ([delegate2 respondsToSelector:@selector(imageView:didFailLoadWithError:)]) {
                [delegate2 imageView:instance didFailLoadWithError:nil];
            }
        } else {
            NSData *imageData = UIImagePNGRepresentation(image);
            [[TBURLCache sharedCache] storeImage:image forURL:imageUrlString];
            [[TBURLCache sharedCache] storeData:imageData forURL:imageUrlString];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self setImage:image imageURL:imageUrlString];

                if ([delegate2 respondsToSelector:@selector(imageView:didLoadImage:)]) {
                    [delegate2 imageView:instance didLoadImage:image];
                }
            });
        }
    });
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = request.error;
    [self releaseRequest];

    [self imageViewDidFailLoadWithError:error];
    if ([_delegate respondsToSelector:@selector(imageView:didFailLoadWithError:)]) {
        [_delegate imageView:self didFailLoadWithError:error];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTURLRequestDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoading {
    return !!_request;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoaded {
    return nil != _image && _image != _defaultImage;
}

- (void)downloadImage {
    if (nil == _request && nil != _urlPath) {
        if (_urlPath && [_urlPath hasPrefix:@"bundle://"]) {
            //没有取到本地图片
            return;
        }

        NSURL *url = [NSURL URLWithString:_urlPath];
        _request = [ASIHTTPRequest requestWithURL:url];
        _request.delegate = self;
        if (self.referrer) {
            [_request addRequestHeader:@"Referer" value:self.referrer];
        }

        // Give the delegate one chance to configure the requester.
        if ([_delegate respondsToSelector:@selector(imageView:willSendARequest:)]) {
            [_delegate imageView:self willSendARequest:_request];
        }

        [_request startAsynchronous];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reload {
    if (_request) {
        [self releaseRequest];
    }

    __weak TBImageView *instance = self;
    __weak NSString *imagePath = _urlPath;

    //不要采用gpu方式读起，避免出现列表图片闪烁现象
    UIImage *image = [[TBURLCache sharedCache] imageForURL:imagePath];
    if (nil != image) {
//        instance.image = image;
        [instance setImage:image enableAnimation:NO];
    } else {
        [instance downloadImage];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)stopLoading {
//    [_request cancel];
    [_request clearDelegatesAndCancel];
    _request = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imageViewDidStartLoad {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imageViewDidLoadImage:(UIImage *)image {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imageViewDidFailLoadWithError:(NSError *)error {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)unsetImage {
    [self stopLoading];
//    self.layer2.opacity = 0;
//    self.image = nil;
    [self setImage:nil enableAnimation:NO];
    self.urlPath = nil;
    self.referrer = nil;
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setUrlPath:(NSString *)urlPath {
    // Check for no changes.
    if (nil != _image && nil != _urlPath && [urlPath isEqualToString:_urlPath]) {
        return;
    }

    [self stopLoading];


    {
        NSString *urlPathCopy = [urlPath copy];
        _urlPath = urlPathCopy;
    }

    if (nil == _urlPath || 0 == _urlPath.length) {
        // Setting the url path to an empty/nil path, so let's restore the default image.
//        self.image = _defaultImage;
//        [self setImage:_defaultImage isDoingAnimation:NO];
    } else {
        [self reload];
    }
}

- (void)setUrlPath:(NSString *)urlPath referrer:(NSString *)referrer {
    self.referrer = referrer;
    [self setUrlPath:urlPath];
}

/////////////////////////////////////华丽的分割线////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateLayer {
    TBImageLayer *layer = (TBImageLayer *) self.layer;
    
    // This is dramatically faster than calling drawRect.  Since we don't have any styles
    // to draw in this case, we can take this shortcut.
    layer.override = self;
    
    [layer setNeedsDisplay];
}

- (void)resetFrameWithImage:(UIImage *)image {
    CGRect frame = self.frame;
    if (!frame.size.width && !frame.size.height) {
        self.width = image.size.width;
        self.height = image.size.height;
        
        // If a width was specified, but no height, then resize the image with the correct aspect
        // ratio.
        
    } else if (frame.size.width && !frame.size.height) {
        self.height = (float)floor((image.size.height / image.size.width) * frame.size.width);
        
        // If a height was specified, but no width, then resize the image with the correct aspect
        // ratio.
        
    } else if (frame.size.height && !frame.size.width) {
        self.width = (float)floor((image.size.width / image.size.height) * frame.size.height);
    }
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setImage:(UIImage *)image enableAnimation:(BOOL)enableAnimation{
    if (image != _image) {
        _image = image;
        //        if (!_urlPath) {
        //            return;
        //        }
        
        
        
        
        [CATransaction begin];
        [CATransaction setValue:(id) kCFBooleanTrue
                         forKey:kCATransactionDisableActions];
        self.layer2.frame = self.bounds;
        
        self.layer2.contents = (id)image.CGImage;
        //        self.layer2.opacity = 1;
        if (_image && enableAnimation) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            [animation setDuration:1.0];
            animation.fromValue = [NSNumber numberWithFloat:0.0];
            animation.toValue = [NSNumber numberWithFloat:1.0];
            
            [self.layer2 addAnimation:animation forKey:@"BigFire"];
            
        }
        [CATransaction commit];
        
        if (_autoresizesToImage) {
            self.width = image.size.width;
            self.height = image.size.height;
            
        } else {
            //            [self resetFrameWithImage:image];
        }
        
        if (nil == _defaultImage || image != _defaultImage) {
            // Only send the notification if there's no default image or this is a new image.
            [self imageViewDidLoadImage:image];
            if ([self.delegate respondsToSelector:@selector(imageView:didLoadImage:)]) {
                [self.delegate imageView:self didLoadImage:image];
            }
        }
    }
}

- (void)setDefaultImage:(UIImage *)theDefaultImage {
    if (theDefaultImage != _defaultImage) {
        _defaultImage = theDefaultImage;
        
        
        [CATransaction begin];
        [CATransaction setValue:(id) kCFBooleanTrue
                         forKey:kCATransactionDisableActions];
        [self updateLayer];
        [CATransaction commit];
        
        
        if (_autoresizesToImage) {
            self.width = theDefaultImage.size.width;
            self.height = theDefaultImage.size.height;
            
        } else {
            //            [self resetFrameWithImage:image];
        }
        
        if (nil == _defaultImage || theDefaultImage != _defaultImage) {
            // Only send the notification if there's no default image or this is a new image.
            [self imageViewDidLoadImage:theDefaultImage];
            if ([self.delegate respondsToSelector:@selector(imageView:didLoadImage:)]) {
                [self.delegate imageView:self didLoadImage:theDefaultImage];
            }
        }
    }
}
@end
