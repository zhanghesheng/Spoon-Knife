//
// Created by enfeng on 13-5-9.
//
// To change the template use AppCode | Preferences | File Templates.
//
#import <UIKit/UIKit.h>

@class TBProgressBarWebView;

@protocol TBWebViewProgressDelegate <NSObject>
@optional
- (void) webView:(TBProgressBarWebView*)webView didReceiveResourceNumber:(int)resourceNumber totalResources:(int)totalResources;
@end

@interface TBProgressBarWebView : UIWebView {
 
}

@property (nonatomic, assign) int resourceCount;
@property (nonatomic, assign) int resourceCompletedCount;

@property (nonatomic, weak) id<TBWebViewProgressDelegate> progressDelegate;

@end
