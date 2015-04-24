
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TBNetwork/ASIHTTPRequestDelegate.h"

@protocol TBImageViewDelegate;
@class ASIFormDataRequest;

/**
* A view that asynchronously loads an image and subsequently displays it.
*/
@interface TBImageView : UIView <ASIHTTPRequestDelegate> {
    NSString *_urlPath;
    UIImage *_image;
    UIImage *_defaultImage;
    BOOL _autoresizesToImage;
    ASIHTTPRequest *_request;
}

@property (nonatomic, weak) CALayer *layer2;

/**
* The path of the image. This may be a web path (http://path/to/image.gif) or a local bundle
* path (bundle://path/to/image.png).
*/
@property(nonatomic, copy) NSString *urlPath;

/**
* The default image that is displayed until the image has been downloaded. If no imageUrlPath is
* specified, this image will be displayed indefinitely.
*/
@property(nonatomic, strong) UIImage *defaultImage;

/**
* The image that is currently being displayed.
*/
@property(nonatomic, readonly) UIImage *image;

/**
* Override the default sizing operation and resize the frame of this view with the size of
* the image.
*
* @default NO
*/
@property(nonatomic) BOOL autoresizesToImage;

/**
* Is an asynchronous request currently active?
*/
@property(nonatomic, readonly) BOOL isLoading;

/**
* Has the image been successfully loaded?
*/
@property(nonatomic, readonly) BOOL isLoaded;

/**
* A delegate that notifies you when the image has started and finished loading.
*/
@property(nonatomic, weak) id <TBImageViewDelegate> delegate;
@property(nonatomic, readonly) ASIHTTPRequest *request;


/**
* Cancel any pending request, remove the image, and redraw the view.
*/
- (void)unsetImage;

/**
* Force the image to be reloaded. If the image is not in the cache, an asynchronous request is
* sent off to fetch the image.
*/
- (void)reload;

/**
* Cancel this image views' active asynchronous requests.
*/
- (void)stopLoading;

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

/**
*  @param urlPath
*  @param referrer 用于打点
*/
- (void)setUrlPath:(NSString *)urlPath referrer:(NSString *)referrer;

/**
 * Useful when overriding the TBImageView class's setImage method.
 * @see TTPhotoView
 *
 * @protected
 */
- (void)setImage:(UIImage*)image enableAnimation:(BOOL)isDoingAnimation;

@end
