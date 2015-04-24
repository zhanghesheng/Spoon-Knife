//
//  Tao800RefreshTableHeaderView.m
//  tao800
//
//  Created by enfeng on 14-3-6.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800RefreshTableHeaderView.h"
#import "Tao800StyleSheet.h"
#import "Tao800ActivityIndicatorView.h"

CGFloat const RefreshHeaderBgImageWidth = 130;
CGFloat const RefreshHeaderBgImageHeight = 20;

CGFloat const RefreshHeaderBgImageWidth2 = 340/2;
CGFloat const RefreshHeaderBgImageHeight2 = 36/2;

typedef enum : NSUInteger {
    Tao800RefreshHeaderPrdViewWidth = 332/2,
    Tao800RefreshHeaderPrdViewHeight = 820/2,
    Tao800RefreshHeaderCloudWidth = 320,
    Tao800RefreshHeaderCloudHeight = 60,
} Tao800RefreshHeaderPrd;

@interface Tao800RefreshTableHeaderView ()

@property(nonatomic, weak) UIImageView *tipImageView;
@property(nonatomic, weak) TBImageView *cloudImageView;
@end

@implementation Tao800RefreshTableHeaderView

- (id)initWithFrameAndPrdValue:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self constructWithFrame:frame prdSupported:YES];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Tao800PrdValueView" owner:self options:nil];
        self.prdValueView = (Tao800PrdValueView *)[nib objectAtIndex:0];
        [_backgroundView addSubview:_prdValueView];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        [self constructWithFrame:frame prdSupported:NO];
    }
    return self;
}

-(void)constructWithFrame:(CGRect)frame prdSupported:(BOOL)flag{
    self.finishMessage = @"刷新成功";
    
    //添加一个背景视图
    UIScreen *screen = [UIScreen mainScreen];
    _backgroundView = [[UIView alloc] initWithFrame:screen.bounds];
    CGRect rect = _backgroundView.frame;
    rect.origin.y = frame.size.height - rect.size.height;
    _backgroundView.frame = rect;
    [self addSubview:_backgroundView];
    
    //_backgroundView.backgroundColor = [UIColor yellowColor];
    
    rect = CGRectZero;
    rect.size = CGSizeMake(RefreshHeaderBgImageWidth, RefreshHeaderBgImageHeight);
    rect.origin.x = (self.width - rect.size.width) / 2;
    rect.origin.y = _backgroundView.height - rect.size.height - 60;
    UIImage *image = nil;
    if (flag) {
        image = TBIMAGE(@"bundle://message_header_tip2@2x.png");
    }else{
        image = TBIMAGE(@"bundle://message_header_tip@2x.png");
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.tipImageView = imageView;
    
    [_backgroundView addSubview:imageView];
    imageView.frame = rect;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
                                                               frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textColor = TEXT_COLOR_BLACK4;
    label.backgroundColor = [UIColor clearColor];
    
    [self addSubview:label];
    _statusLabel = label;
    
    CALayer *layer = [CALayer layer];
    
    [CATransaction begin];
    [CATransaction setValue:(id) kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    layer.frame = CGRectMake(25.0f, 20, 22.0f, 22.0f);
    layer.contentsGravity = kCAGravityResizeAspect;
    UIImage *image1 = TBIMAGE(@"bundle://message_up_arrow@2x.png");
    layer.contents = (id) image1.CGImage;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        layer.contentsScale = [[UIScreen mainScreen] scale];
    }
#endif
    
    [[self layer] addSublayer:layer];
    _arrowImage = layer;
    [CATransaction commit];
    
    Tao800ActivityIndicatorView *view = [[Tao800ActivityIndicatorView alloc]
                                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
    view.centerImageView.image = TBIMAGE(@"bundle://message_small_loading@2x.png");
    [self addSubview:view];
    _activityView = (UIActivityIndicatorView*) view;
    
    [self setState:EGOOPullRefreshNormal];
    if (flag) {
        TBImageView* cloud = [[TBImageView alloc] initWithFrame:CGRectZero];
        self.cloudImageView = cloud;
        self.cloudImageView.urlPath = @"bundle://common_cloud_home@2x.png";
        self.cloudImageView.backgroundColor = [UIColor clearColor];
        [self insertSubview:self.cloudImageView belowSubview:_statusLabel];
        self.backgroundColor = [UIColor colorWithHex:0xFED631];
        self.tipImageView.backgroundColor = [UIColor colorWithHex:0xFED631];
        _backgroundView.backgroundColor = [UIColor colorWithHex:0xFED631];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat x = 0;//([UIScreen mainScreen].bounds.size.width - 320)/2;
    CGRect bgRect = _backgroundView.frame;
    CGFloat h = Tao800RefreshHeaderPrdViewHeight;
    CGFloat y = (bgRect.size.height - h) - self.size.height - 15;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    self.prdValueView.frame = CGRectMake(x, y, w, h);
    
    CGFloat hGap = 5;
    CGFloat downOffset = 2;

    //设置提示文字位置
    CGRect rect = _statusLabel.frame;
    rect.size = [_statusLabel.text sizeWithFont:_statusLabel.font
                              constrainedToSize:CGSizeMake(200, 300)];

    CGFloat sumWidth = rect.size.width + hGap + _arrowImage.frame.size.width;
    CGFloat imageX = (self.width - sumWidth) / 2;
    rect.origin.x = imageX + hGap + _arrowImage.frame.size.width;
    rect.origin.y = (self.height - rect.size.height) / 2 + downOffset;
    _statusLabel.frame = rect;

    //设置箭头位置
    [CATransaction begin];
    [CATransaction setValue:(id) kCFBooleanTrue
                     forKey:kCATransactionDisableActions];

    rect = _arrowImage.frame;
    rect.origin.x = imageX;
    rect.origin.y = (self.height - _arrowImage.frame.size.height) / 2 + downOffset;
    _arrowImage.frame = rect;
    [CATransaction commit];

    //设置loading位置
    _activityView.frame = rect;

    //
    if (self.cloudImageView) {
        rect.size = CGSizeMake(RefreshHeaderBgImageWidth2, RefreshHeaderBgImageHeight2);
        rect.origin.x = (self.width - rect.size.width) / 2;
        rect.origin.y = _backgroundView.height - rect.size.height - 60;
        self.tipImageView.frame = rect;

        w = Tao800RefreshHeaderCloudWidth;
        h = Tao800RefreshHeaderCloudHeight;
        x = (self.width - w)/2;
        y = (self.height - Tao800RefreshHeaderCloudHeight);
        self.cloudImageView.frame = CGRectMake(x, y, w, h);
    }else{
        rect.size = CGSizeMake(RefreshHeaderBgImageWidth, RefreshHeaderBgImageHeight);
        rect.origin.x = (self.width - rect.size.width) / 2;
        rect.origin.y = _backgroundView.height - rect.size.height - 60;
        self.tipImageView.frame = rect;

    }
}

- (void)setStateForDefaultStyle:(EGOPullRefreshState)aState {
    if (aState == EGOOPullRefreshSuccess) {
        [_activityView stopAnimating];
        _statusLabel.text = self.finishMessage;
        [CATransaction begin];
        [CATransaction setValue:(id) kCFBooleanTrue forKey:kCATransactionDisableActions];
        _arrowImage.hidden = NO;
        _arrowImage.transform = CATransform3DIdentity;
        [CATransaction commit];
        UIImage *image1 = TBIMAGE(@"bundle://message_refresh_ok@2x.png");
        _arrowImage.contents = (id) image1.CGImage;

        _state = aState;
    } else {
        UIImage *image1 = TBIMAGE(@"bundle://message_up_arrow@2x.png");
        _arrowImage.contents = (id) image1.CGImage;
        [super setStateForDefaultStyle:aState];
    }
    [self layoutSubviews];
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {

    if (self.tableViewCTL) {
        //兼容老代码
        if (self.tableViewCTL.pageNum>1) {
            return;
        }
    }

    [UIView animateWithDuration:.3 animations:^() {

        @try {
            CGPoint offset = scrollView.contentOffset;
            offset.y = 0;
            if (scrollView) {
                scrollView.contentOffset = offset;
                [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
            }
        }
        @catch (NSException *exception) {
            TBDPRINT(@"%@", @"下拉刷新出现异常.");
        }
        @finally {

        }

    }                completion:^(BOOL finish) {
        if (_state == EGOOPullRefreshSuccess) {
            _statusLabel.text = self.finishMessage;
            UIImage *image1 = TBIMAGE(@"bundle://message_up_arrow@2x.png");
            _arrowImage.contents = (id) image1.CGImage;
            [self setState:EGOOPullRefreshNormal];
        }
    }];

    if (_state != EGOOPullRefreshSuccess) {
        [self setState:EGOOPullRefreshNormal];
    }
}
@end
