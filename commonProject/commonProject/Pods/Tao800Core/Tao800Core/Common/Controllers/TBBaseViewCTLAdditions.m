//
// Created by enfeng on 12-10-23.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <sys/ucred.h>
#import "TBBaseViewCTLAdditions.h"
#import "Tao800NavigationVCL.h"
#import "Tao800StyleSheet.h"
#import "Tao800LoadingView.h"
#import "Tao800RectangleBorderButton.h"
#import "Tao800ForwardSingleton.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800LoadingActivityLabel.h"
#import "Tao800DealService.h"
#import "Tao800BubblePopupView.h"
#import "Tao800NewScreenTipView.h"
#import "Tao800PageLoadingView.h"
#import "TBCore/TBCore.h"

enum {
    Tao800PageTipTag = 22341122,
    Tao800NewPageTipTag = 22341177
};

@implementation TBBaseViewCTL (Tao800Category)


- (void)bringBubbleViewToFront {
    NSArray *sViews = [self.view subviews];
    Tao800BubblePopupView *mainTouchView = nil;
    for (UIView *itemView in sViews) {
        if ([itemView isKindOfClass:[Tao800BubblePopupView class]]) {
            [self.view bringSubviewToFront:itemView];
            Tao800BubblePopupView *view1 = (Tao800BubblePopupView *) itemView;
            if (view1.isMainTouchView) {
                mainTouchView = view1;
            }
        }
    }
    if (mainTouchView) {
        [self.view bringSubviewToFront:mainTouchView];
    }
}

- (void)goBackFromNavigator {
    [self goBack:YES];
}

- (void)resetNavigatorView:(TBNavigatorView *)naviView {
    UIImage *image = TBIMAGE(@"bundle://common_goback_btn@2x.png");
    //    UIImage *image2 = TBIMAGE(@"bundle://common_goback_selected_btn@2x.png");
    
    CGFloat btnHeight = 36;
    CGFloat y = (TBDefaultRowHeight - btnHeight) / 2;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(5, y, 36, btnHeight);
    [naviView addSubview:btn];
    
    UIImage *bgImage = TBIMAGE(@"bundle://common_navbar_bg@2x.png");
    
    naviView.layer.contents = (id) bgImage.CGImage;
    [btn setImage:image forState:UIControlStateNormal];
    //    [btn setImage:image2 forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(goBackFromNavigator) forControlEvents:UIControlEventTouchUpInside];
    
    naviView.displayShadow = NO;
    [naviView setTitleFont:V3_30PX_FONT];
    
    CGRect rect = naviView.frame;
    rect.size.height = TBDefaultRowHeight;
    rect.origin.y = self.view.height - rect.size.height;
    
    naviView.backgroundColor = [UIColor clearColor];
    naviView.frame = rect;
}

- (void)addBackButtonToNavigator {
    [self resetNavigatorView:self.tbNavigatorView];
}

- (void)resetStyleForIOS7 {
    if (NeedResetUIStyleLikeIOS7()) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

- (void)alertShow:(NSString *)message {
    
    [self showTextTip:message];
}

- (void)dealWithHttpStatusCode:(int)statusCode {
    switch (statusCode) {
        case 401: {
            [self alertShow:@"您没有登录，请先登录"];
        }
            break;
        case 500: {
            [self alertShow:@"服务器出错"];
        }
            break;
        default: {
            [self alertShow:@"网络连接错误"];
        }
            break;
    }
}

#pragma mark ------- 网络连接失败delegate----------
//- (void)didNetworkError:(NSDictionary *)params {
//
//    [self hideLoadingView];
//
//    if (params) {
//        ASIHTTPRequest *request = [params objectForKey:@"request"];
//        NSError *error = [request error];
//        if (error) {
//            int code = error.code;
//            if (code >= 1 && code <= 11) {
//                ASINetworkErrorType type = (ASINetworkErrorType) code;
//
//                switch (type) {
//                    case ASIRequestTimedOutErrorType: {
//                        [self alertShow:@"网络连接超时"];
//                    }
//                        return;
//                    case ASIRequestCancelledErrorType: {
//                        TBDPRINT(@"取消请求");
//                    }
//                        return;
//                    default:
//                        break;
//                }
//            }
//        }
//
//        if (request) {
//            int statusCode = request.responseStatusCode;
//            [self dealWithHttpStatusCode:statusCode];
//        } else {
//            [self alertShow:@"网络连接错误"];
//        }
//    } else {
//        [self alertShow:@"网络连接错误"];
//    }
//}

- (void)hideLoadingView {
    UIView *progressLoading = [self.view.window viewWithTag:TBProgressLoadingTag];
    if (!progressLoading) {
        progressLoading = [self.view viewWithTag:TBProgressLoadingTag];
    }
    if (progressLoading) {
        [progressLoading removeFromSuperview];
    }
}

- (void)didNetworkError:(NSDictionary *)params {
    [self hideLoadingView];
    
    Tao800DealService *workService = [[Tao800DealService alloc] init];
    ASIHTTPRequest *request = [params objectForKey:@"request"];
    TBErrorDescription *tbd = [workService getErrorDescription:request];
    [self dealError:tbd];
}
- (void)showNoDataPageTip:(NSString *)title detail:(NSString *)detail hideButton:(BOOL) hideButton {
    Tao800ScreenTipView *errorView1 = (Tao800ScreenTipView *) [self.view viewWithTag:Tao800PageTipTag];
    
    if (errorView1) {
        [errorView1 removeFromSuperview];
    }
    
    CGRect loadingRect = [self getLoadingRect];
    
    errorView1 = [[Tao800ScreenTipView alloc]
                  initWithTitle:title
                  subtitle:detail
                  delegate:self
                  style:Tao800ScreenTipViewStyleContainButton
                  ];
    errorView1.tag = Tao800PageTipTag;
    errorView1.frame = loadingRect;
    errorView1.backgroundColor = [UIColor whiteColor];
    errorView1.centerImageView.image = TBIMAGE(@"bundle://message_0001@2x.png");
    [errorView1 setTag:Tao800PageTipTag];
    [self.view addSubview:errorView1];
    
    errorView1.centerButton.hidden = hideButton;
    
    [errorView1 layoutSubviews];
}
- (void)showPageTip:(NSString *)title detail:(NSString *)detail tipType:(Tao800PageTipType)tipType {
    Tao800ScreenTipView *errorView1 = (Tao800ScreenTipView *) [self.view viewWithTag:Tao800PageTipTag];
    
    NSString *paramTitle = nil;
    if (title) {
        paramTitle = title;
    } else if (detail) {
        paramTitle = detail;
    } else {
        paramTitle = @"";
    }
    
    if (errorView1) {
        [errorView1 removeFromSuperview];
    }
    
    CGRect loadingRect = [self getLoadingRect];
    
    errorView1 = [[Tao800ScreenTipView alloc]
                  initWithTitle:paramTitle
                  delegate:self
                  style:Tao800ScreenTipViewStyleContainButton];
    errorView1.tag = Tao800PageTipTag;
    errorView1.frame = loadingRect;
    errorView1.backgroundColor = [UIColor whiteColor];
    errorView1.centerImageView.image = TBIMAGE(@"bundle://message_network_error@2x.png");
    [errorView1 setTag:Tao800PageTipTag];
    [self.view addSubview:errorView1];
    
    switch (tipType) {
            
        case Tao800PageTipTypeNetworkNotReachable:
            errorView1.centerImageView.image = TBIMAGE(@"bundle://message_network_not_reachable@2x.png");
            break;
        case Tao800PageTipTypeNetworkTimeout:
            break;
        case Tao800PageTipTypeNetworkServer500:
            errorView1.centerImageView.image = TBIMAGE(@"bundle://message_server_error@2x.png");
            break;
        case Tao800PageTipTypeNetworkServer404:
            errorView1.centerImageView.image = TBIMAGE(@"bundle://message_server_error@2x.png");
            break;
        case Tao800PageTipTypeNetworkError: {
            errorView1.centerImageView.image = TBIMAGE(@"bundle://message_network_error@2x.png");
        }
            break;
        case Tao800PageTipTypeNoData: {
            errorView1.centerImageView.image = TBIMAGE(@"bundle://message_nodata@2x.png");
            errorView1.centerButton.hidden = YES;
        }
            //        case Tao800PageTipTypeNoData: {
            //            errorView1.centerImageView.image = TBIMAGE(@"bundle://message_nodata@2x.png");
            //            errorView1.centerButton.hidden = YES;
            //        }
            break;
    }
    
    [errorView1 layoutSubviews];
    
    [self bringBubbleViewToFront];
}

//Tao800NewPageTipTag
- (void)showPageTip:(NSString *)title detail:(NSString *)detail tipType:(Tao800PageTipType)tipType buttonTitle:(NSString*)btnTitle{
    Tao800NewScreenTipView *errorView1 = (Tao800NewScreenTipView *) [self.view viewWithTag:Tao800NewPageTipTag];
    
    NSString *paramTitle = nil;
    if (title) {
        paramTitle = title;
    } else if (detail) {
        paramTitle = detail;
    } else {
        paramTitle = @"";
    }
    
    if (errorView1) {
        [errorView1 removeFromSuperview];
    }
    
    CGRect loadingRect = [self getLoadingRect];
    
    Tao800NewScreenTipViewStyle style = Tao800NewScreenTipViewStyleDefault;
    if (btnTitle && btnTitle.length>0) {
        style = Tao800NewScreenTipViewStyleContainButton;
    }
    errorView1 = [[Tao800NewScreenTipView alloc] initWithTitle:title subtitle:detail delegate:self style:style];
    //    errorView1.titleLabel.font = [UIFont systemFontOfSize:17];
    //    errorView1.subtitleLabel.font = [UIFont systemFontOfSize:14];
    //    errorView1.titleLabel.textColor = TEXT_COLOR_BLACK1;
    //    errorView1.subtitleLabel.textColor = TEXT_COLOR_BLACK6;
    errorView1.tag = Tao800NewPageTipTag;
    errorView1.frame = loadingRect;
    if (btnTitle && btnTitle.length>0) {
        [errorView1.centerButton setTitle:btnTitle forState:UIControlStateNormal];
    }
    errorView1.backgroundColor = [UIColor whiteColor];
    errorView1.centerImageView.image = TBIMAGE(@"bundle://message_network_error@2x.png");
    [errorView1 setTag:Tao800NewPageTipTag];
    [self.view addSubview:errorView1];
    
    switch (tipType) {
            
        case Tao800PageTipTypeNetworkNotReachable:
            errorView1.centerImageView.image = TBIMAGE(@"bundle://message_network_not_reachable@2x.png");
            break;
        case Tao800PageTipTypeNetworkTimeout:
            break;
        case Tao800PageTipTypeNetworkServer500:
            errorView1.centerImageView.image = TBIMAGE(@"bundle://message_server_error@2x.png");
            break;
        case Tao800PageTipTypeNetworkServer404:
            errorView1.centerImageView.image = TBIMAGE(@"bundle://message_server_error@2x.png");
            break;
        case Tao800PageTipTypeNetworkError: {
            errorView1.centerImageView.image = TBIMAGE(@"bundle://message_network_error@2x.png");
        }
            break;
        case Tao800PageTipTypeNoData: {
            errorView1.centerImageView.image = TBIMAGE(@"bundle://message_smile@2x.png");
            //personal_remind_nodata_bg@2x
            errorView1.centerImageView.image = TBIMAGE(@"bundle://personal_remind_nodata_bg@2x.png");
            errorView1.centerButton.hidden = NO;
            errorView1.centerButton.backgroundColor = TEXT_COLOR_RED1;
        }
            break;
    }
    
    [errorView1 layoutSubviews];
    
    [self bringBubbleViewToFront];
}


- (void)hidePageTip {
    Tao800ScreenTipView *errorView1 = (Tao800ScreenTipView *) [self.view viewWithTag:Tao800PageTipTag];
    if (errorView1) {
        [errorView1 removeFromSuperview];
    }
    
    Tao800NewScreenTipView *errorView2 = (Tao800NewScreenTipView *) [self.view viewWithTag:Tao800NewPageTipTag];
    if (errorView2) {
        [errorView2 removeFromSuperview];
    }
}

- (void)showPopupLoadingView:(NSString *)message
                     subText:(NSString *)subText
                  fullScreen:(BOOL)fullScreen
               closeCallback:(Tao800LoadingViewCloseCallback)closeCallback {
    UIView *pView = nil;
    
    if (fullScreen) {
        pView = self.view.window;
    } else {
        pView = self.view;
    }
    
    Tao800LoadingView *label1 = (Tao800LoadingView *) [self.view viewWithTag:TBProgressLoadingTag];
    
    if (!label1) {
        CGRect rect = pView.bounds;
        
        Tao800LoadingView *label = [[Tao800LoadingView alloc]
                                    initWithFrame:rect
                                    text:message subText:subText];
        label.backgroundColor = [UIColor clearColor];
        label.activityLabel.label.textColor = [UIColor whiteColor];
        label.activityLabel.subLabel.textColor = [UIColor whiteColor];
        label.tag = TBProgressLoadingTag;
        [pView addSubview:label];
        if (closeCallback) {
            label.closeCallback = closeCallback;
            label.closeButton.hidden = NO;
        }
    }
    if (!fullScreen) {
        [pView bringSubviewToFront:self.tbNavigatorView];
    }
}

- (void)showPopupLoadingView:(NSString *)message subText:(NSString *)subText fullScreen:(BOOL)fullScreen {
    [self showPopupLoadingView:message subText:subText fullScreen:fullScreen closeCallback:NULL];
}

- (void)showPopupLoadingView:(NSString *)message fullScreen:(BOOL)fullScreen {
    [self showPopupLoadingView:message subText:nil fullScreen:fullScreen];
}

- (void)showPopupLoadingView:(NSString *)message
                  fullScreen:(BOOL)fullScreen
               closeCallback:(Tao800LoadingViewCloseCallback) closeCallback {
    [self showPopupLoadingView:message subText:nil fullScreen:fullScreen closeCallback:closeCallback];
}

- (void)hidePopupLoadingView {
    [self hideLoadingView];
}

- (void)showPageLoading2:(NSNumber*)show {
    [self showPageLoading:[show boolValue]];
}

- (void)showPageLoading:(BOOL)show {
    /*
    Tao800PageLoadingView *label1 = (Tao800PageLoadingView *) [self.view viewWithTag:TBPageLoadingViewTag];
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    if (show) {
        if (label1) {
            [self.view bringSubviewToFront:label1];
            return;
        }
        CGRect rect = [self getLoadingRect];
        Tao800PageLoadingView *label = [[Tao800PageLoadingView alloc]
                                             initWithFrame:rect
                                             style:UIActivityIndicatorViewStyleGray
                                             text:[dm getPrdLoadingTip]];
        label.backgroundColor = BACKGROUND_COLOR_GRAY1;
        label.tag = TBPageLoadingViewTag;
        [self.view addSubview:label];
        [self bringBubbleViewToFront];
    } else {
        if (label1) {
            [label1 stopAnimating];
            [label1 removeFromSuperview];
        }
    }
     */
    
    Tao800LoadingActivityLabel *label1 = (Tao800LoadingActivityLabel *) [self.view viewWithTag:TBLoadingActivityLabelTag];
    if (show) {
        if (label1) {
            [self.view bringSubviewToFront:label1];
            return;
        }
        CGRect rect = [self getLoadingRect];
        
        Tao800LoadingActivityLabel *label = [[Tao800LoadingActivityLabel alloc]
                                             initWithFrame:rect
                                             style:UIActivityIndicatorViewStyleGray
                                             text:@"努力加载中..."];
        Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
        label.subLabel.text = [dm getLoadingTip];
        label.backgroundColor = BACKGROUND_COLOR_GRAY1;
        
        label.tag = TBLoadingActivityLabelTag;
        [self.view addSubview:label];
        
        [self bringBubbleViewToFront];
        
    } else {
        if (label1) {
            [label1 removeFromSuperview];
        }
    }
    
}

- (void)dealError:(TBErrorDescription *)error {
    [self showPageLoading:NO];
    SEL sel = @selector(resetLoadState);
    if ([self respondsToSelector:sel]) {
        TB_PERFORM_SELECTOR_LEAK_WARNING([self performSelector:sel]);
    }
    
    [self showPageTip:@"网络连接错误"
               detail:nil
              tipType:Tao800PageTipTypeNetworkError];
}

- (void)didClickScreenTipView:(Tao800ScreenTipView *)messageView sender:(id)sender {
    self.model.pageNumber = 1;
    SEL sel = @selector(loadItems);
    if ([self respondsToSelector:sel]) {
        TB_PERFORM_SELECTOR_LEAK_WARNING([self performSelector:sel]);
    }
}

- (void)addTopHorizontalLine {
    UIImage *image = TBIMAGE(@"bundle://top_horizontal_line@2x.png");
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, self.view.frame.size.width, 4);
    layer.contents = (id) image.CGImage;
    [self.view.layer addSublayer:layer];
}

#pragma mark out链接 cType页面分类类型 分类id 聚频道-分类name，逛频道-分类id，专题-专题id
- (NSString *)serverFeedBackUrlString:(NSString *)urlStr dealId:(NSString *)dealId cType:(PageCategoryType)cType cId:(NSString *)cId {
    
    //3.1.2 新需求;2. 如果跳转地址不是http://out.zhe800.com，
    // 则客户端不在URL上追加信息：如平台，版本，产品名称，等等；就是严格按照API返回的URL跳转，不做任何变化
    if ([urlStr rangeOfString:@"out.zhe800.com"].length>0) {
        return urlStr;
    }
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"ttid" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:urlStr options:0 range:NSMakeRange(0, [urlStr length]) withTemplate:@"__temp__"];
    
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    //NSString *ttid = [NSString stringWithFormat:@"400000_21428298@zbbwx_iPhone_%@", dm.currentVersion];
    NSString *sid = [NSString stringWithFormat:@"t%@", dm.macAddress];
    
    NSString *firstSep = nil;
    if ([modifiedString rangeOfString:@"?"].length > 0) {
        firstSep = @"&";
    } else {
        firstSep = @"?";
    }
    
    NSMutableString *mString = [NSMutableString stringWithString:modifiedString];
    [mString appendFormat:@"%@type=web&sjs=1&platform=iPhone&source=tao800_app", firstSep];
    [mString appendFormat:@"&version=%@", dm.currentVersion];
    [mString appendFormat:@"&channelId=%@", dm.partner];
    [mString appendFormat:@"&deviceId=%@", dm.macAddress];
    [mString appendFormat:@"&dealId=%@", dealId];
    [mString appendFormat:@"&sid=%@", sid];
    
    if (dm.user.inviteCode != nil) {
        [mString appendFormat:@"&mId=%@", dm.user.inviteCode]; // 邀请码
    }
    
    [mString appendFormat:@"&sche=%@", @"zhe800"]; //增加此参数用于淘宝客户端回跳
    
    if (dm.city.cityId && dm.city.cityId > 0) {
        [mString appendFormat:@"&cityId=%@", dm.city.cityId]; // 城市id
    }
    
    [mString appendFormat:@"&cType=%d", cType]; // 页面分类类型
    
    if (cId && cId.length > 0) {
        [mString appendFormat:@"&cId=%@", cId]; // 页面分类类型id
    }
    
    //1、得到当前屏幕的尺寸：
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    CGSize size_screen = rect_screen.size;
    
    //2、获得scale：
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    // 增加分辨率参数 resolution 宽X高
    [mString appendFormat:@"&resolution=%gX%g", size_screen.width * scale_screen, size_screen.height * scale_screen];
    
    //[mString appendFormat:@"&ttid=%@", ttid];
    
    return mString;
}

- (NSString *)getNoNetworkHtml:(NSString *)error // 获取无网络时html内容
{
    //自定义网络错误时背景
    NSMutableString *string = [[NSMutableString alloc] initWithString:@""];
    
    //[string insertString:@"<body style=\"background-color:#FCF3E9;text-indent:2em;font-size:50px;\">" atIndex:0];
    [string insertString:@"<body>" atIndex:0];
    [string appendString:@"<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><font size=\"8\" color=\"gray\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;亲，页面加载失败！</font><br><br> <font size=\"6\" color=\"gray\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;此页面无法展示，请检查您的网络连接，或稍后重试。</font>"];
    [string appendString:@"</body>"];
    
    return string;
}

- (void)viewWillAppearDeal:(BOOL)animated {
    if (self.navigationController) {
        self.navigationController.navigationBar.hidden = NO;
        [Tao800ForwardSingleton sharedInstance].navigationController = (Tao800NavigationVCL *) self.navigationController;
    }
}

- (void)addBackButton {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = nil;
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [self addBackButtonToNavigator];
    
    CGRect rect = self.tbNavigatorView.frame;
    rect.size.height = TBDefaultRowHeight;
    rect.origin.y = self.view.height - rect.size.height;
    if (!NeedResetUIStyleLikeIOS7()) {
        rect.origin.y = rect.origin.y - 20;
    }
    self.tbNavigatorView.frame = rect;
}

@end
