#import "TBWebController.h"

#import "TBUICommon.h"
#import "UIViewAdditions.h"
#import "UIToolbarAdditions.h"
#import "TBI18n.h"
#import "TBSourceI18n.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TBWebController

@synthesize delegate = _delegate;
@synthesize headerView = _headerView;
@synthesize originalURL = _originalURL;
@synthesize request = _request;
@synthesize url = _url;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }

    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        NSURLRequest *request = [query objectForKey:@"request"];
        if (nil != request) {
            [self openRequest:request];
        } else {
            self.originalURL = URL;
            [self openURL:URL];
        }
    }
    return self;
}

- (id)initWithParams:(NSDictionary *)params {
    self = [super initWithParams:params];
    if (self) {
        self.request = [params objectForKey:@"request"];
        self.url = [params objectForKey:@"url"];
    }
    return self;
}

-(void)setParameters:(NSDictionary *)parameters{
    self.request = [parameters objectForKey:@"request"];
    self.url = [parameters objectForKey:@"url"];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
    }

    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    [_webView setDelegate:nil];
    [_webView stopLoading];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)backAction {
    [_webView goBack];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)forwardAction {
    [_webView goForward];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)refreshAction {
    [_webView reload];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)stopAction {
    [_webView stopLoading];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)shareAction {
    if (nil != _actionSheet && [_actionSheet isVisible]) {
        //should only happen on the iPad
        assert(TBIsPad());
        [_actionSheet dismissWithClickedButtonIndex:-1 animated:YES];
        return;
    }

    if (nil == _actionSheet) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                          cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil otherButtonTitles:@"在浏览器中查看",
                                                                                  nil];
        if (TBIsPad()) {
            [_actionSheet showFromBarButtonItem:_actionButton animated:YES];

        } else {
            [_actionSheet showInView:self.view];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateToolbarWithOrientation:(UIInterfaceOrientation)interfaceOrientation {
    _toolbar.height = TBToolbarHeight();
    _webView.height = self.view.height - _toolbar.height;
    _toolbar.top = self.view.height - _toolbar.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController
CGRect TBToolbarNavigationFrame() {
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    return CGRectMake(0, 0, frame.size.width, frame.size.height - TBToolbarHeight() * 2);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadView {
    [super loadView];

    _webView = [[TBProgressBarWebView alloc] initWithFrame:TBToolbarNavigationFrame()];
    _webView.delegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth
            | UIViewAutoresizingFlexibleHeight;
    _webView.scalesPageToFit = YES;
    _webView.progressDelegate = self;
    [self.view addSubview:_webView];

    UIActivityIndicatorView *spinner =
            [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                    UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
//    _activityItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];

    _backButton =
            [[UIBarButtonItem alloc] initWithImage:TBIMAGE(@"bundle://backIcon.png") style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(backAction)];
    _backButton.tag = 2;
    _backButton.enabled = NO;
    _forwardButton =
            [[UIBarButtonItem alloc] initWithImage:TBIMAGE(@"bundle://forwardIcon.png") style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(forwardAction)];
    _forwardButton.tag = 1;
    _forwardButton.enabled = NO;
    _refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
            UIBarButtonSystemItemRefresh                           target:self action:@selector(refreshAction)];
    _refreshButton.tag = 3;
    _stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
            UIBarButtonSystemItemStop                           target:self action:@selector(stopAction)];
    _stopButton.tag = 3;
    _actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
            UIBarButtonSystemItemAction                           target:self action:@selector(shareAction)];

    UIBarItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
            UIBarButtonSystemItemFlexibleSpace                        target:nil action:nil];

    _toolbar = [[UIToolbar alloc] initWithFrame:
            CGRectMake(0, self.view.height - TBToolbarHeight(),
                    self.view.width, TBToolbarHeight())];
    _toolbar.autoresizingMask =
            UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;

    _toolbar.items = [NSArray arrayWithObjects:
            _backButton,
            space,
            _forwardButton,
            space,
            _refreshButton,
            space,
            _actionButton,
            nil];
    [self.view addSubview:_toolbar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.delegate = self;

    if (nil != self.request) {
        [self openRequest:self.request];

    } else {

        if (self.url) {
            self.originalURL = self.url;
            [self openURL:self.url];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload {
    [super viewDidUnload];

    _delegate = nil;
    [_webView setDelegate:nil];
    [_webView stopLoading];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateToolbarWithOrientation:self.interfaceOrientation];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated {
    [_webView stopLoading]; //避免页面在loading过程中出现crash

    // If the browser launched the media player, it steals the key window and never gives it
    // back, so this is a way to try and fix that
    [self.view.window makeKeyWindow];

    [super viewWillDisappear:animated];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return TBIsSupportedOrientation(interfaceOrientation);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateToolbarWithOrientation:toInterfaceOrientation];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)rotatingFooterView {
    return _toolbar;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UTViewController (TTCategory)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)persistView:(NSMutableDictionary *)state {
    NSString *URL = self.URL.absoluteString;
    if (URL.length && ![URL isEqualToString:@"about:blank"]) {
        [state setObject:URL forKey:@"URL"];
        return YES;

    } else {
        return NO;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)restoreView:(NSDictionary *)state {
    NSString *URL = [state objectForKey:@"URL"];
    if (URL.length && ![URL isEqualToString:@"about:blank"]) {
        [self openURL:[NSURL URLWithString:URL]];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIWebViewDelegate

- (void)resetProcessBar {
    if (_progressBar) {

        return;
    }

//    CGFloat y = TBDefaultPortraitToolbarHeight;
    CGFloat y = 0;
    _progressBar = [[TBWebViewProgressBar alloc] initWithFrame:CGRectMake(0.0f, y, self.view.bounds.size.width, 4.0f)];

    [_webView addSubview:_progressBar];
    [_progressBar performSelector:@selector(setProgress2:)
                       withObject:[NSNumber numberWithFloat:0.01f]
                       afterDelay:.3];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    if ([_delegate respondsToSelector:
            @selector(webController:webView:shouldStartLoadWithRequest:navigationType:)] &&
            ![_delegate webController:self webView:webView
           shouldStartLoadWithRequest:request navigationType:navigationType]) {
        return NO;
    }

//    UIApplication *application = [UIApplication sharedApplication];
//    if ([application canOpenURL:request.URL]) {
//        [_loadingURL release];
//        _loadingURL = [[NSURL URLWithString:@"about:blank"] retain];
//        [[UIApplication sharedApplication] openURL:request.URL];
//        return NO;
//    }
    [_toolbar replaceItemWithTag:3 withItem:_stopButton];
    _loadingURL = nil;
    _loadingURL = request.URL;
    _backButton.enabled = [_webView canGoBack];
    _forwardButton.enabled = [_webView canGoForward];
    return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webViewDidStartLoad:(UIWebView *)webView {
    if ([_delegate respondsToSelector:@selector(webController:webViewDidStartLoad:)]) {
        [_delegate webController:self webViewDidStartLoad:webView];
    }

    self.title = TBSourceLocalizedString(@"Loading...", @"正在载入...");
//    if (!self.navigationItem.rightBarButtonItem) {
//        [self.navigationItem setRightBarButtonItem:_activityItem animated:YES];
//    }


    _backButton.enabled = [_webView canGoBack];
    _forwardButton.enabled = [_webView canGoForward];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([_delegate respondsToSelector:@selector(webController:webViewDidFinishLoad:)]) {
        [_delegate webController:self webViewDidFinishLoad:webView];
    }

    _loadingURL = nil;
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    if (self.navigationItem.rightBarButtonItem == _activityItem) {
//        [self.navigationItem setRightBarButtonItem:nil animated:YES];
//    }
//    [_toolbar replaceItemWithTag:3 withItem:_refreshButton];

    _backButton.enabled = [_webView canGoBack];
    _forwardButton.enabled = [_webView canGoForward];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([_delegate respondsToSelector:@selector(webController:webView:didFailLoadWithError:)]) {
        [_delegate webController:self webView:webView didFailLoadWithError:error];
    }

    _loadingURL = nil;
    [self webViewDidFinishLoad:webView];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIActionSheetDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:self.URL];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    _actionSheet = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSURL *)URL {
    return _loadingURL ? _loadingURL : _webView.request.URL;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeaderView:(UIView *)headerView {
    if (headerView != _headerView) {
        BOOL addingHeader = !_headerView && headerView;
        BOOL removingHeader = _headerView && !headerView;

        [_headerView removeFromSuperview];

        _headerView = headerView;
        _headerView.frame = CGRectMake(0, 0, _webView.width, _headerView.height);

        [self view];
        UIView *scroller = [_webView descendantOrSelfWithClass:NSClassFromString(@"UIScroller")];
        UIView *docView = [scroller descendantOrSelfWithClass:NSClassFromString(@"UIWebDocumentView")];
        [scroller addSubview:_headerView];

        if (addingHeader) {
            docView.top += headerView.height;
            docView.height -= headerView.height;

        } else if (removingHeader) {
            docView.top -= headerView.height;
            docView.height += headerView.height;
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)openURL:(NSURL *)URL {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [self openRequest:request];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)openRequest:(NSURLRequest *)request {
    [self view];
    [self resetProcessBar];

    [_webView loadRequest:request];
}

- (void) hideProcessBar {
    [_progressBar hideWithFadeOut:^(BOOL finish) {
        _progressBar.hidden = YES;
        _progressBar.alpha = 1;
        _progressBar.progress = 0;
    }];
}

- (void)webView:(TBProgressBarWebView *)pWebView didReceiveResourceNumber:(int)resourceNumber totalResources:(int)totalResources {
    //Set progress value

    if (pWebView.resourceCount > 0) {
        _progressBar.hidden = NO;
    }

    [_progressBar setProgress:((float) resourceNumber) / ((float) totalResources) animated:NO];

    //Reset resource count after finished
    if (resourceNumber == totalResources) {
        pWebView.resourceCount = 0;
        pWebView.resourceCompletedCount = 0;
//        [self resetProcessBar];
        [self performSelector:@selector(hideProcessBar) withObject:nil afterDelay:.3];
        [_toolbar replaceItemWithTag:3 withItem:_refreshButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    [_webView stopLoading];
}

- (void)hideToolBar:(BOOL)hide
{
    _toolbar.hidden  = hide;
}

@end
