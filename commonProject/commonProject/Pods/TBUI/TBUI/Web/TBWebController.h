#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "TBBaseViewCTL.h"
#import "TBWebViewProgressBar.h"
#import "TBProgressBarWebView.h"

@protocol TTWebControllerDelegate;

@interface TBWebController : TBBaseViewCTL <UIWebViewDelegate, UIActionSheetDelegate,
        TBWebViewProgressDelegate> {
@protected
    TBProgressBarWebView *_webView;

    UIToolbar *_toolbar;

    UIView *_headerView;

    UIBarButtonItem *_backButton;
    UIBarButtonItem *_forwardButton;
    UIBarButtonItem *_refreshButton;
    UIBarButtonItem *_stopButton;
    UIBarButtonItem *_actionButton;
//    UIBarButtonItem *_activityItem;

    NSURL *_originalURL; // 原始URL
    NSURL *_loadingURL;

    UIActionSheet *_actionSheet; 

    TBWebViewProgressBar *_progressBar;
    NSURLRequest *_request;
    NSURL *_url;
}

/**
 * The current web view URL. If the web view is currently loading a URL, then the loading URL is
 * returned instead.
 */
@property(nonatomic, readonly) NSURL *URL;
@property(nonatomic, strong) NSURL *originalURL;

/**
 * A view that is inserted at the top of the web view, within the scroller.
 */
@property(nonatomic, strong) UIView *headerView;

/**
 * The web controller delegate
 */
@property(nonatomic, weak) id <TTWebControllerDelegate> delegate;
@property(nonatomic, strong) NSURLRequest *request;
@property(nonatomic, strong) NSURL *url;


/**
 * Navigate to the given URL.
 */
- (void)openURL:(NSURL *)URL;

/**
 * Load the given request using UIWebView's loadRequest:.
 *
 * @param request  A URL request identifying the location of the content to load.
 */
- (void)openRequest:(NSURLRequest *)request;


- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query;

- (void)hideToolBar:(BOOL)hide;

@end

/**
 * The web controller delegate, similar to UIWebViewDelegate, but prefixed with controller
 */
@protocol TTWebControllerDelegate <NSObject>

@optional
- (BOOL)     webController:(TBWebController *)controller webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
            navigationType:(UIWebViewNavigationType)navigationType;

- (void)webController:(TBWebController *)controller webViewDidStartLoad:(UIWebView *)webView;

- (void)webController:(TBWebController *)controller webViewDidFinishLoad:(UIWebView *)webView;

- (void)webController:(TBWebController *)controller webView:(UIWebView *)webView
 didFailLoadWithError:(NSError *)error;

@end
