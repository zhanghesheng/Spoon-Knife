//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <sys/ucred.h>
#import "RefreshTableHeaderView.h"
#import "TBCore/TBCoreMacros.h"
#import "UIViewAdditions.h"
#import "TBUICommon.h"

#define TEXT_COLOR  [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]

@implementation RefreshTableHeaderViewParam

@synthesize lImage = _lImage;
@synthesize lImages = _lImages;
@synthesize rImage = _rImage;

- (void)dealloc
{
}
@end

@implementation RefreshTableHeaderView

@synthesize delegate = _delegate;
@synthesize isLoadingComplete;
@synthesize state = _state;
@synthesize param = _rtParam;
@synthesize backgroundView = _backgroundView;
@synthesize finishMessage = _finishMessage;

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

- (void)startCustomLoading {
    _rightImageView.hidden = NO;
    _leftImageView.image = nil;

    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = [NSNumber numberWithFloat:0];
    shake.toValue = [NSNumber numberWithFloat:2 * M_PI];
    shake.duration = 0.8;
    shake.autoreverses = NO;
    shake.repeatCount = MAXFLOAT;

    [_rightImageView.layer addAnimation:shake forKey:@"shakeAnimation"];

    _leftImageView.animationDuration = 0.3f;
    [_leftImageView startAnimating];
}

- (void)stopCustomLoading {
    [_rightImageView.layer removeAllAnimations];
    [_leftImageView stopAnimating];
    _leftImageView.image = self.param.lImage;
    _rightImageView.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (TBIsPad()) {
        CGFloat hPadding  = 60;
        CGSize size = [_lastUpdatedLabel.text sizeWithFont:_lastUpdatedLabel.font
                                    constrainedToSize:CGSizeMake(200, 300)];
        CGFloat width = size.width + hPadding + _arrowImage.frame.size.width;
        CGFloat x = (self.width - width)/2;

        [CATransaction begin];
        [CATransaction setValue:(id) kCFBooleanTrue
                         forKey:kCATransactionDisableActions];

        CGRect rect = _arrowImage.frame;
        rect.origin.x = x;
        _arrowImage.frame = rect;
        [CATransaction commit];

        rect = _activityView.frame;
        rect.origin.x = x-10;
        _activityView.frame = rect;
    }
}

- (id)initWithFrame:(CGRect)frame
              params:(RefreshTableHeaderViewParam*) param  {

    self = [super initWithFrame:frame];
    if (self) {
        self.finishMessage   = @"刷新成功";

        //添加一个背景视图
        UIScreen *screen = [UIScreen mainScreen];
        _backgroundView = [[UIView alloc] initWithFrame:screen.bounds];
        CGRect rect = _backgroundView.frame;
        rect.origin.y = frame.size.height-rect.size.height;
        _backgroundView.frame = rect;
        [self addSubview:_backgroundView];

        self.param = param;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        //self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        self.backgroundColor = [UIColor clearColor];

        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont boldSystemFontOfSize:13.0f];
        label.textColor = TEXT_COLOR;
        //label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        //label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;

        [self addSubview:label];
        _statusLabel = label;

        self.style = param.style;

        switch (self.style) {

            case RefreshTableHeaderViewStyleDefault: {
                label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
                label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                label.font = [UIFont systemFontOfSize:12.0f];
                label.textColor = TEXT_COLOR;
                //label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
                //label.shadowOffset = CGSizeMake(0.0f, 1.0f);
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = NSTextAlignmentCenter;

                [self addSubview:label];
                _lastUpdatedLabel = label;

                CALayer *layer = [CALayer layer];

                [CATransaction begin];
                [CATransaction setValue:(id) kCFBooleanTrue
                                 forKey:kCATransactionDisableActions];
                layer.frame = CGRectMake(25.0f, 20, 15.0f, 30.0f);
                layer.contentsGravity = kCAGravityResizeAspect;
                UIImage *image1 = TBIMAGE(@"bundle://blueArrow_custom.png");
                layer.contents = (id) image1.CGImage;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
                if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
                    layer.contentsScale = [[UIScreen mainScreen] scale];
                }
#endif

                [[self layer] addSublayer:layer];
                _arrowImage = layer;
                [CATransaction commit];

                UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc]
                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);

                [self addSubview:view];
                _activityView = view;

            }
                break;
            case RefreshTableHeaderViewStyleCustom: {
                CGRect leftRect = CGRectMake(5, 5, 96, 60);
                CGRect rRect = CGRectMake(frame.size.width-15, (frame.size.height-23)/2, 23, 23);

                _leftImageView = [[UIImageView alloc] initWithFrame:leftRect];
                _rightImageView = [[UIImageView alloc] initWithFrame:rRect];

                [self addSubview:_leftImageView];
                [self addSubview:_rightImageView];
                _leftImageView.animationImages = param.lImages;
                _rightImageView.image = param.rImage;

                _leftImageView.image = param.lImage;

                rect = label.frame;
//                rect.origin.y = (frame.size.height-rect.size.height)/2;
                rect.origin.x = rect.origin.x + 30;
                rect.origin.y = 15;
                label.frame = rect;

                CGFloat y = rect.origin.y + rect.size.height + 3;
                label = [[UILabel alloc] initWithFrame:CGRectMake(120.0f, y, self.frame.size.width, 16.0f)];
                label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                label.font = [UIFont systemFontOfSize:12.0f];
                label.textColor = TEXT_COLOR;
                //label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
                //label.shadowOffset = CGSizeMake(0.0f, 1.0f);
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = NSTextAlignmentLeft;

                [self addSubview:label];
                _lastUpdatedLabel = label;
            }
                break;
        }
        _rightImageView.hidden = YES;
        [self setState:EGOOPullRefreshNormal];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {

    }

    return self;
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {

    if ([self.delegate respondsToSelector:@selector(refreshTableHeaderDataSourceLastUpdated:)]) {

        NSDate *date = [self.delegate refreshTableHeaderDataSourceLastUpdated:self];

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //[formatter setAMSymbol:@"上午"];
        //[formatter setPMSymbol:@"下午"];
//        [formatter setDateFormat:@"yyyy/MM/dd hh:mm"];
        [formatter setDateFormat:@"MM/dd hh:mm"];
        _lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新: %@", [formatter stringFromDate:date]];
        [[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGOFooterRefreshTableView_LastRefresh"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    } else {

        _lastUpdatedLabel.text = nil;

    }

}

- (void)setStateForDefaultStyle:(EGOPullRefreshState)aState {

    switch (aState) {
        case EGOOPullRefreshPulling:

            _statusLabel.text = NSLocalizedString(@"list.header.loosen", @"松开即可更新...");
            [CATransaction begin];
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];

            break;
        case EGOOPullRefreshNormal:

            if (_state == EGOOPullRefreshPulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }

            _statusLabel.text = NSLocalizedString(@"list.header.default", @"下拉即可更新...");
            [_activityView stopAnimating];
            _activityView.hidden = YES;
            [CATransaction begin];
            [CATransaction setValue:(id) kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];

            [self refreshLastUpdatedDate];

            break;
        case EGOOPullRefreshLoading:
            _statusLabel.text = NSLocalizedString(@"list.header.loadding", @"读取中...");
            [_activityView startAnimating];
            _activityView.hidden = NO;
            [CATransaction begin];
            [CATransaction setValue:(id) kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = YES;
            [CATransaction commit];
            break;

        case EGOOPullRefreshComplete:
            _statusLabel.text = NSLocalizedString(@"list.header.loadcomplete", @"已到第一页");
            _arrowImage.hidden = YES;
            break;
        case EGOOPullRefreshSuccess: {
            [_activityView stopAnimating];
            _activityView.hidden = YES;
            _statusLabel.text = self.finishMessage;
            _arrowImage.hidden = YES;

        }
        default:
            break;
    }

    _state = aState;
}

- (void)setStateForCustomStyle:(EGOPullRefreshState)aState {

    switch (aState) {
        case EGOOPullRefreshPulling: {
            _statusLabel.text = NSLocalizedString(@"list.header.loosen", @"松开即可更新...");
            [CATransaction begin];
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
        }
            break;
        case EGOOPullRefreshNormal: {
            if (_state == EGOOPullRefreshPulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }

            _statusLabel.text = NSLocalizedString(@"list.header.default", @"下拉即可更新...");
            [self stopCustomLoading];

            [self refreshLastUpdatedDate];
        }


            break;
        case EGOOPullRefreshLoading: {
            _statusLabel.text = NSLocalizedString(@"list.header.loadding", @"读取中...");
            [self startCustomLoading];
        }

            break;

        case EGOOPullRefreshComplete: {
            _statusLabel.text = nil;
        }

            break;
        case EGOOPullRefreshSuccess: {
            _statusLabel.text = self.finishMessage;
            [self stopCustomLoading];

        }
        default:
            break;
    }

    _state = aState;
}

- (void)setState:(EGOPullRefreshState)aState {
    switch (self.style) {

        case RefreshTableHeaderViewStyleDefault: {

            [self setStateForDefaultStyle:aState];
        }
            break;
        case RefreshTableHeaderViewStyleCustom: {
            [self setStateForCustomStyle:aState];
        }
            break;
    }
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView isDragging:(BOOL)ispDragging {
    CGPoint offset = scrollView.contentOffset;

    if (offset.y == 0) {
        offset.y = -60;
        scrollView.contentOffset = offset;
    }
    [self setState:EGOOPullRefreshLoading];

    [UIView animateWithDuration:.2 animations:^() {
        scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
    }];
}

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {

    if (_state == EGOOPullRefreshLoading) {

        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, 60);
        scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);

    } else if (scrollView.isDragging) {

        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading:)]) {
            _loading = [_delegate refreshTableHeaderDataSourceIsLoading:self];
        }

        if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -REFRESH_HEADER_HEIGHT && scrollView.contentOffset.y < 0.0f && !_loading) {
            [self setState:EGOOPullRefreshNormal];
        } else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT && !_loading) {
            [self setState:EGOOPullRefreshPulling];
        }

        if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }

    }

}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {

    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading:)]) {
        _loading = [_delegate refreshTableHeaderDataSourceIsLoading:self];
    }

    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT && !_loading) {

        if ([_delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh:)]) {
            [_delegate refreshTableHeaderDidTriggerRefresh:self];
        }
        if (!isLoadingComplete) {
            [self setState:EGOOPullRefreshLoading];
        }

        [UIView animateWithDuration:.2 animations:^() {
            
            @try {
                scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
            }
            @catch (NSException *exception) {
                TBDPRINT(@"%@", @"下拉刷新出现异常001.");
            }
            @finally {
                
            }
        }];

    }

}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
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

        }];
    [self setState:EGOOPullRefreshNormal];
}

- (void)resetToDefaultState:(UIScrollView *)scrollView {
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    _statusLabel.text = NSLocalizedString(@"list.header.default", @"下拉即可更新...");
    [_statusLabel setBackgroundColor:[UIColor clearColor]];
    [_activityView stopAnimating];
    _arrowImage.hidden = NO;
    _arrowImage.transform = CATransform3DIdentity;
    [self setState:EGOOPullRefreshNormal];
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {

    [_leftImageView stopAnimating];
  
}


@end
