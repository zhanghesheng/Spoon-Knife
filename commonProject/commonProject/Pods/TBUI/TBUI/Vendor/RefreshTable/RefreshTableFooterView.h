//
//  RefreshTableFooterView.h
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enorm. All rights reserved.



#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    OPullFooterRefreshPulling = 0,
    OPullFooterRefreshNormal,
    OPullFooterRefreshLoading,
    OPullFooterRefreshLoadingComplete,
} PullFooterRefreshState;

@protocol RefreshTableFooterDelegate;

@interface RefreshTableFooterView : UIView {
 
    PullFooterRefreshState _state;

    UILabel *_lastUpdatedLabel;
    UILabel *_statusLabel;
    CALayer *_arrowImage;
    UIActivityIndicatorView *_activityView;

    BOOL IsLoading;
    BOOL IsLoadComplete;

    BOOL _needResetOffsetToZero;
}
@property(nonatomic, assign) BOOL IsLoadComplete, IsLoading;
@property(nonatomic, strong) CALayer *_arrowImage;
@property(nonatomic, strong) UILabel *_statusLabel;
@property(nonatomic, weak) id <RefreshTableFooterDelegate> delegate;
@property(nonatomic) PullFooterRefreshState state;
@property(nonatomic) BOOL needResetOffsetToZero;


- (void)loadDataComplete;

- (void)resetState;

- (void)resetToDefaultState:(UIScrollView *)scrollView;

- (void) stopAnimate:(UIScrollView *)scrollView;

- (void)refreshLastUpdatedDate;

- (void)Footer_RefreshScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)Footer_RefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;

- (void)Footer_RefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

- (void)setState:(PullFooterRefreshState)aState;

- (void)setActivityStyle:(UIActivityIndicatorViewStyle)style;
@end

@protocol RefreshTableFooterDelegate<NSObject>
- (void)RefreshTableFooterDidTriggerRefresh:(RefreshTableFooterView *)view;

- (BOOL)RefreshTableFooterDataSourceIsLoading:(RefreshTableFooterView *)view;
@optional
- (NSDate *)RefreshTableFooterDataSourceLastUpdated:(RefreshTableFooterView *)view;
@end
