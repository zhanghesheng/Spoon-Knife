//
//  EGORefreshTableHeaderView.h
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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define FLIP_ANIMATION_DURATION 0.18f
#define REFRESH_HEADER_HEIGHT 65.0f

typedef enum {
    EGOOPullRefreshPulling = 0,
    EGOOPullRefreshNormal,
    EGOOPullRefreshLoading,
    EGOOPullRefreshComplete,
    EGOOPullRefreshSuccess,   //用于成功提示
    EGOOPullRefreshError,   //刷新失败
} EGOPullRefreshState;

typedef enum {
    RefreshTableHeaderViewStyleDefault,
    RefreshTableHeaderViewStyleCustom, //左边是图片动画，右边是loading动画
} RefreshTableHeaderViewStyle;

@protocol RefreshTableHeaderDelegate;

@interface RefreshTableHeaderViewParam:NSObject {
    NSArray *_lImages;
    UIImage *_rImage;
    UIImage *_lImage;
}

@property (nonatomic) RefreshTableHeaderViewStyle style;
@property (nonatomic, strong) NSArray *lImages;
@property (nonatomic, strong) UIImage *rImage;
@property (nonatomic, strong) UIImage *lImage;
@end

@interface RefreshTableHeaderView : UIView {
 
    EGOPullRefreshState _state;

    UILabel *_lastUpdatedLabel;
    UILabel *_statusLabel;
    CALayer *_arrowImage;
    UIActivityIndicatorView *_activityView;
    BOOL isLoadingComplete;

    UIImageView *_leftImageView;
    UIImageView *_rightImageView;
    
    RefreshTableHeaderViewParam *_rtParam;
    UIView* _backgroundView;
    NSString *_finishMessage;
}
- (id)initWithFrame:(CGRect)frame
             params:(RefreshTableHeaderViewParam*) param;
- (void)setState:(EGOPullRefreshState)aState;

@property(nonatomic, weak) id <RefreshTableHeaderDelegate> delegate;
@property(nonatomic, assign) BOOL isLoadingComplete;
@property(nonatomic) EGOPullRefreshState state;
@property(nonatomic) RefreshTableHeaderViewStyle style;
@property(nonatomic, strong) RefreshTableHeaderViewParam *param;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, copy) NSString *finishMessage;


- (void)refreshLastUpdatedDate;

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView isDragging:(BOOL)ispDragging;

- (void)setActivityStyle:(UIActivityIndicatorViewStyle)style;
- (void)setStateForDefaultStyle:(EGOPullRefreshState)aState;
- (void)resetToDefaultState:(UIScrollView *)scrollView;
- (void)setStateForCustomStyle:(EGOPullRefreshState)aState;
@end

@protocol RefreshTableHeaderDelegate<NSObject>
- (void)refreshTableHeaderDidTriggerRefresh:(RefreshTableHeaderView *)view;

- (BOOL)refreshTableHeaderDataSourceIsLoading:(RefreshTableHeaderView *)view;
@optional
- (NSDate *)refreshTableHeaderDataSourceLastUpdated:(RefreshTableHeaderView *)view;
@end
