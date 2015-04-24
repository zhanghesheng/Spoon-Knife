//
// Created by enfeng on 13-5-9.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TBProgressBarWebView.h"


@interface UIWebView ()
- (id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource;

- (void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource;

- (void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource;
@end

@implementation TBProgressBarWebView

@synthesize progressDelegate = _progressDelegate;
@synthesize resourceCount;
@synthesize resourceCompletedCount;

- (id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource {
    [super webView:view identifierForInitialRequest:initialRequest fromDataSource:dataSource];
    return [NSNumber numberWithInt:resourceCount++];
}

- (void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource {
    [super webView:view resource:resource didFailLoadingWithError:error fromDataSource:dataSource];
    resourceCompletedCount++;
    if ([self.progressDelegate respondsToSelector:@selector(webView:didReceiveResourceNumber:totalResources:)]) {
        [self.progressDelegate webView:self didReceiveResourceNumber:resourceCompletedCount totalResources:resourceCount];
    }
}

- (void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource {
    [super webView:view resource:resource didFinishLoadingFromDataSource:dataSource];
    resourceCompletedCount++;
    if ([self.progressDelegate respondsToSelector:@selector(webView:didReceiveResourceNumber:totalResources:)]) {
        [self.progressDelegate webView:self didReceiveResourceNumber:resourceCompletedCount totalResources:resourceCount];
    }
}


@end