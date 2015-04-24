//
//  TBUICycleScrollView.h
//  universalT800
//
//  Created by enfeng on 13-1-17.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBPageControlExt.h"
@protocol TBUICycleScrollViewDelegate;
@protocol TBUICycleScrollViewDataSource;
@class TBUICycleScrollSubView;

@interface TBUICycleScrollView : UIView <UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    TBPageControlExt *_pageControl; 

    NSInteger _totalPages;
    NSInteger _curPage;

    NSMutableArray *_curViews;

    //里面的每一个值是一个数组
    NSCache *_cacheDict;

    BOOL _animating;
}

@property(nonatomic, readonly) UIScrollView *scrollView;
@property(nonatomic, readonly) TBPageControlExt *pageControl;
@property(nonatomic, assign) NSInteger currentPage;
@property(nonatomic, weak, setter = setDataSource:) id <TBUICycleScrollViewDataSource> dataSource;
@property(nonatomic, weak, setter = setDelegate:) id <TBUICycleScrollViewDelegate> delegate;
@property(nonatomic, strong) NSCache *cacheDict;
@property(nonatomic) BOOL animating;

- (void)reloadData;

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;

- (void)setCenterPageIndex:(NSUInteger)index oldIndex:(NSUInteger)oldIndex animated:(BOOL)animate;

- (UIView *)dequeueReusablePage:(NSString *)reusableIdentifier;
@end

@protocol TBUICycleScrollViewDelegate <NSObject>

@optional
- (void)cycleScrollView:(TBUICycleScrollView *)scrollView didClickPageAtIndex:(NSInteger)index;

- (void)cycleScrollViewWillBeginDragging:(TBUICycleScrollView *)scrollView;

- (void)cycleScrollViewDidEndDragging:(TBUICycleScrollView *)scrollView willDecelerate:(BOOL)willDecelerate;
@end

@protocol TBUICycleScrollViewDataSource <NSObject>

@required
- (NSInteger)numberOfPagesInScrollView:(TBUICycleScrollView *)scrollView;

- (TBUICycleScrollSubView *)scrollView:(TBUICycleScrollView *)scrollView pageAtIndex:(NSInteger)pageIndex;

@end
