//
//  RefreshTableFooterView.m
//  Demo
//
//


#define  RefreshViewHeight 50.0f

#import "RefreshTableFooterView.h"
#import "TBCore/TBCoreMacros.h"
#import "TBUICommon.h"
#import "UIViewAdditions.h"

//#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define TEXT_COLOR  [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]
#define FLIP_ANIMATION_DURATION 0.18f


@implementation RefreshTableFooterView

@synthesize _arrowImage;
@synthesize _statusLabel;
@synthesize IsLoadComplete;
@synthesize IsLoading;
@synthesize state = _state;
@synthesize needResetOffsetToZero = _needResetOffsetToZero;


- (void)setActivityStyle:(UIActivityIndicatorViewStyle)style {
    if (_activityView == nil) return;
    _activityView.activityIndicatorViewStyle = style;

    if (style == UIActivityIndicatorViewStyleWhite) {
        _lastUpdatedLabel.textColor = [UIColor whiteColor];
        _statusLabel.textColor = [UIColor whiteColor];
    } else {
        _lastUpdatedLabel.textColor = TEXT_COLOR;
        _statusLabel.textColor = TEXT_COLOR;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (TBIsPad()) {
        CGFloat hPadding = 60;
        CGSize size = [_statusLabel.text sizeWithFont:_statusLabel.font
                                         constrainedToSize:CGSizeMake(200, 300)];
        CGFloat width = size.width + hPadding + _arrowImage.frame.size.width;
        CGFloat x = (self.width - width) / 2;

        [CATransaction begin];
        [CATransaction setValue:(id) kCFBooleanTrue
                         forKey:kCATransactionDisableActions];

        CGRect rect = _arrowImage.frame;
        rect.origin.x = x;
        _arrowImage.frame = rect;
        [CATransaction commit];

        rect = _activityView.frame;
        rect.origin.x = x - 10;
        _activityView.frame = rect;
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _needResetOffsetToZero = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        //self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        self.backgroundColor = [UIColor clearColor];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, RefreshViewHeight - 20.0f, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = TEXT_COLOR;
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _lastUpdatedLabel = label;

        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, RefreshViewHeight - 38.0f, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont boldSystemFontOfSize:13.0f];
        label.textColor = TEXT_COLOR;
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _statusLabel = label;

        CALayer *layer = [CALayer layer];

        [CATransaction begin];
        [CATransaction setValue:(id) kCFBooleanTrue
                         forKey:kCATransactionDisableActions];
        layer.frame = CGRectMake(25.0f, RefreshViewHeight - RefreshViewHeight, 15.0f, 30.0f);
        layer.contentsGravity = kCAGravityResizeAspect;
        UIImage *image1 = TBIMAGE(@"bundle://blueArrow_custom.png");
        layer.contents = (id) image1.CGImage;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            layer.contentsScale = [[UIScreen mainScreen] scale];
        }
#endif

        [[self layer] addSublayer:layer];
        [CATransaction commit];

        _arrowImage = layer;

        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        view.frame = CGRectMake(25.0f, RefreshViewHeight - 38.0f, 20.0f, 20.0f);
        [view setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        //[view setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:view];
        _activityView = view;

        self.IsLoadComplete = NO;
        self.IsLoading = NO;

        [self setState:OPullFooterRefreshNormal];

    }

    return self;

}


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {

    if ([self.delegate respondsToSelector:@selector(RefreshTableFooterDataSourceLastUpdated:)]) {

//		NSDate *date = [_delegate RefreshTableFooterDataSourceLastUpdated:self];
//		
//		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//		[formatter setAMSymbol:@"上午"];
//		[formatter setPMSymbol:@"下午"];
//		[formatter setDateFormat:@"yyyy/MM/dd hh:mm:a"];
//		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新: %@", [formatter stringFromDate:date]];
//        
        [[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"RefreshTableView_LastRefresh"];
        [[NSUserDefaults standardUserDefaults] synchronize];
//		[formatter release];

    } else {

        _lastUpdatedLabel.text = nil;

    }

}

- (void)setState:(PullFooterRefreshState)aState {

    switch (aState) {
        case OPullFooterRefreshPulling:

            _statusLabel.text = NSLocalizedString(@"list.footer.loosen", @"松开即可更新...");
            [CATransaction begin];
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];

            break;
        case OPullFooterRefreshNormal:

            if (_state == OPullFooterRefreshPulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }

            _statusLabel.text = NSLocalizedString(@"list.footer.default", @"上拉即可加载更多...");
            [_activityView stopAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id) kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];

            [self refreshLastUpdatedDate];

            break;
        case OPullFooterRefreshLoading: {
            _statusLabel.text = NSLocalizedString(@"list.footer.loadding", @"更多数据读取中...");
            [_activityView startAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id) kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = YES;
            [CATransaction commit];
        }
            break;
        case OPullFooterRefreshLoadingComplete:
            _statusLabel.text = NSLocalizedString(@"list.footer.loadcomplete", @"已到最后一页");
            _arrowImage.hidden = YES;
            break;
        default:
            break;
    }

    _state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

//手指屏幕上不断拖动调用此方法
- (void)Footer_RefreshScrollViewDidScroll:(UIScrollView *)scrollView {

    if (_state == OPullFooterRefreshLoading) {
//        CGFloat offset = -RefreshViewHeight;
//        if (scrollView.contentSize.height > scrollView.frame.size.height) {
//            offset = scrollView.contentSize.height - scrollView.frame.size.height;
//            offset = -offset - RefreshViewHeight;
//        }

        scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, RefreshViewHeight, 0.0f);

    } else if (scrollView.isDragging) {

        BOOL _loading = NO;
        if ([self.delegate respondsToSelector:@selector(RefreshTableFooterDataSourceIsLoading:)]) {
            _loading = [_delegate RefreshTableFooterDataSourceIsLoading:self];
        }

        CGFloat compareHeight_1 = scrollView.contentOffset.y + (scrollView.frame.size.height);
        CGFloat compareHeight_2 = scrollView.contentSize.height + RefreshViewHeight;
        if (scrollView.contentSize.height < scrollView.frame.size.height) {
            compareHeight_2 = scrollView.frame.size.height + RefreshViewHeight;
        }
        if (_state == OPullFooterRefreshPulling
                && compareHeight_1 < compareHeight_2
                && scrollView.contentOffset.y > 0.0f
                && !_loading) {
            [self setState:OPullFooterRefreshNormal];
        } else if (_state == OPullFooterRefreshNormal
                && compareHeight_1 > compareHeight_2
                && !_loading) {
            [self setState:OPullFooterRefreshPulling];
        }

        if (scrollView.contentInset.bottom != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }

    }

}

//当用户停止拖动，并且手指从屏幕中拿开的的时候调用此方法
- (void)Footer_RefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {

    BOOL _loading = NO;
    if ([self.delegate respondsToSelector:@selector(RefreshTableFooterDataSourceIsLoading:)]) {
        _loading = [_delegate RefreshTableFooterDataSourceIsLoading:self];
    }

    CGFloat compareHeight_1 = scrollView.contentOffset.y + (scrollView.frame.size.height);
    CGFloat compareHeight_2 = scrollView.contentSize.height + RefreshViewHeight;
    if (scrollView.contentSize.height < scrollView.frame.size.height) {
        compareHeight_2 = scrollView.frame.size.height + RefreshViewHeight;
    }

    if (compareHeight_1 > compareHeight_2 && !_loading) {

        //view停止等待效果
        [self setState:OPullFooterRefreshLoading];

        [UIView animateWithDuration:.2 animations:^() {
            scrollView.contentInset = UIEdgeInsetsMake(-RefreshViewHeight, 0.0f, 0.0f, 0.0f);
        }];

        //加载数据
        if ([self.delegate respondsToSelector:@selector(RefreshTableFooterDidTriggerRefresh:)]) {
            [self.delegate RefreshTableFooterDidTriggerRefresh:self];
        }
    }
}

//当页面刷新完毕调用此方法，[delegate RefreshScrollViewDataSourceDidFinishedLoading: scrollView];
- (void)Footer_RefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    //完成后将view从页面消失
    if (scrollView) {
        @try {
            [UIView animateWithDuration:.3 animations:^() {
                [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
            }];
        }
        @catch (NSException *exception) {
            [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        }
        @finally {

        }
    }

    //[self removeFromSuperview];
    self.frame = CGRectMake(self.frame.size.width, self.frame.size.height, self.frame.size.width, scrollView.contentSize.height);
    [self setState:OPullFooterRefreshNormal];
}

//数据加载完成时调用
- (void)loadDataComplete {
    //_delegate=nil;
    _statusLabel.text = NSLocalizedString(@"list.footer.loadcomplete", @"已到最后一页");
    //[_statusLabel setBackgroundColor:[UIColor redColor]];
    [_activityView stopAnimating];
    IsLoadComplete = YES;
    _arrowImage.hidden = YES;
    //self.delegate=nil;
}

- (void)resetState {
    _statusLabel.text = NSLocalizedString(@"list.footer.default", @"上拉即可加载更多...");
    [_statusLabel setBackgroundColor:[UIColor clearColor]];
    [_activityView startAnimating];
    IsLoadComplete = NO;
    _arrowImage.hidden = NO;
}

- (void)resetToDefaultState:(UIScrollView *)scrollView {
    if (_needResetOffsetToZero) {
        [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    }

    _statusLabel.text = NSLocalizedString(@"list.footer.default", @"上拉即可加载更多...");
    [_statusLabel setBackgroundColor:[UIColor clearColor]];
    [_activityView stopAnimating];
    IsLoadComplete = NO;
    _arrowImage.hidden = NO;
    CGFloat height = scrollView.contentSize.height;
    if (height < scrollView.frame.size.height) {
        height = scrollView.frame.size.height;
    }

    self.frame = CGRectMake(self.frame.size.width, height, self.frame.size.width, self.frame.size.height);
    _arrowImage.transform = CATransform3DIdentity;
    [self setState:OPullFooterRefreshNormal];
}

- (void)stopAnimate:(UIScrollView *)scrollView {
    if (IsLoadComplete) {
        [self loadDataComplete];
    } else {
        [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        _statusLabel.text = NSLocalizedString(@"list.footer.default", @"上拉即可加载更多...");
        [_statusLabel setBackgroundColor:[UIColor clearColor]];
        [_activityView stopAnimating];
        IsLoadComplete = NO;
        _arrowImage.hidden = NO;
        self.frame = CGRectMake(self.frame.size.width, scrollView.contentSize.height, self.frame.size.width, self.frame.size.height);
        _arrowImage.transform = CATransform3DIdentity;
        [self setState:OPullFooterRefreshNormal];
    }
}
#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
}


@end
