//
//  TBUICycleScrollView.m
//  universalT800
//
//  Created by enfeng on 13-1-17.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "TBUICycleScrollView.h"

#import "TBUICycleScrollSubView.h"

@interface TBUICycleScrollView() {

}
@end

@implementation TBUICycleScrollView

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize currentPage = _curPage;
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize cacheDict = _cacheDict;
@synthesize animating = _animating;

- (void)dealloc {
}

- (void) initContent {
    _cacheDict = [[NSCache alloc] init];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    
    CGRect rect = self.bounds;
    rect.origin.y = rect.size.height - 30;
    rect.size.height = 30;
    _pageControl = [[TBPageControlExt alloc] initWithFrame:rect];
    _pageControl.userInteractionEnabled = NO;
    
    [self addSubview:_pageControl];
    
    _curPage = 0;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initContent];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initContent];
    }
    return self;
}

- (void)setDataSource:(id <TBUICycleScrollViewDataSource>)datasource {
    _dataSource = datasource;
    [self reloadData];
}

- (void)reloadData {
    _totalPages = [_dataSource numberOfPagesInScrollView:self];
    if (_totalPages == 0) {
        return;
    }
    _pageControl.numberOfPages = _totalPages;
    [self loadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _scrollView.frame = self.bounds;
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);

    CGRect rect = self.bounds;
    rect.origin.y = rect.size.height - 30;
    rect.size.height = 30;
    self.pageControl.frame = rect;
}

- (void)loadData {

    _pageControl.currentPage = _curPage;

    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if ([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }

    [self getDisplayImagesWithCurpage:_curPage];
    
    static BOOL gestureAdded = NO;
    if (!_curViews || _curViews.count<3) {
        return;
    }

    for (int i = 0; i < 3; i++) {
        UIView *pageView = [_curViews objectAtIndex:i];
        pageView.userInteractionEnabled = YES;
        NSArray *gesArray = [pageView gestureRecognizers];
        if (gesArray.count<1) {
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [pageView addGestureRecognizer:singleTap];
        }
        CGRect rect = pageView.frame;
        rect.origin.x = 0;
        pageView.frame = rect;
        
        pageView.frame = CGRectOffset(pageView.frame, pageView.frame.size.width * i, 0);
        
        [_scrollView addSubview:pageView];
        [pageView layoutSubviews];
    }
    gestureAdded = YES;

    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

- (void) addToCache:(TBUICycleScrollSubView*) view {
    NSMutableArray *array = [_cacheDict objectForKey:view.reuseIdentifier];
    if (array==nil) {
        array = [NSMutableArray arrayWithCapacity:3];
        [_cacheDict setObject:array forKey:view.reuseIdentifier];
    }
    if (array.count<1) {
        if(view != nil){
            [array addObject:view];
        }
        
    } else {
        BOOL inCache = NO;
        for (UIView *item in array) {
            if (item == view) {
                inCache = YES;
            }
        }
        if (inCache) {
            //如果已经存在于缓存中
            return;
        }
        if(view != nil){
            [array addObject:view];
        }
    }
}

- (void)getDisplayImagesWithCurpage:(NSInteger)page {

    NSInteger pre = [self validPageValue:_curPage - 1];
    NSInteger last = [self validPageValue:_curPage + 1];
    
    if (!_curViews) {
        _curViews = [[NSMutableArray alloc] init];
    }
    
    [_curViews removeAllObjects];

    TBUICycleScrollSubView *preView = [_dataSource scrollView:self pageAtIndex:pre];
    if (!preView) {
        return;
    }
    [self addToCache:preView];
    [_curViews addObject:preView];
    
    TBUICycleScrollSubView *centerView = [_dataSource scrollView:self pageAtIndex:page];
    if (!centerView) {
        return;
    }
    [self addToCache:centerView];
    [_curViews addObject:centerView];
    
    TBUICycleScrollSubView *lastView = [_dataSource scrollView:self pageAtIndex:last];
    if (!lastView) {
        return;
    }
    [self addToCache:lastView];
    [_curViews addObject:lastView];
}

- (NSInteger)validPageValue:(NSInteger)value {

    if (value == -1) value = _totalPages - 1;
    if (value == _totalPages) value = 0;

    return value;

}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didClickPageAtIndex:)]) {
        [_delegate cycleScrollView:self didClickPageAtIndex:_curPage];
    }
}

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index {
    if (index == _curPage) {
        [_curViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++) {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];
            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            [_scrollView addSubview:v];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;

    //往下翻一张
    if (x >= (2 * self.frame.size.width)) {
        _curPage = [self validPageValue:_curPage + 1];
        [self loadData];
    }

    //往上翻
    if (x <= 0) {
        _curPage = [self validPageValue:_curPage - 1];
        [self loadData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {

//    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];  //会造成动画重叠
    [self loadData];

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_delegate && [_delegate respondsToSelector:@selector(cycleScrollViewWillBeginDragging:)]) {
        [_delegate cycleScrollViewWillBeginDragging:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)willDecelerate {
    if (_delegate && [_delegate respondsToSelector:@selector(cycleScrollViewDidEndDragging:willDecelerate:)]) {
        [_delegate cycleScrollViewDidEndDragging:self willDecelerate:willDecelerate];
    }
}

- (void)setCenterPageIndex:(NSUInteger)index oldIndex:(NSUInteger)oldIndex animated:(BOOL)animate {
    NSInteger maxIndex = _totalPages-1;
    if (index>maxIndex) {
        return;
    }
    CGFloat width = _scrollView.frame.size.width;
  
    if (animate && !_animating) {
        _animating = YES;
        [UIView animateWithDuration:.2 animations:^{
            [_scrollView setContentOffset:CGPointMake(width+width, 0) animated:YES];
        } completion:^(BOOL finish){
            [self loadData];
            _animating = NO;
        }];
    } else {
        [self loadData];
        _animating = NO;
    }
}

- (BOOL) isInCurViews:(UIView*)pView {
    for (UIView *view in _curViews) {
        if (view == pView) {
            return YES;
        }
    }
    return NO;
}

- (UIView *)dequeueReusablePage:(NSString *)reusableIdentifier {
    NSMutableArray *array = [_cacheDict objectForKey:reusableIdentifier];
    
    if (array == nil || array.count<1) {//没有缓存
        return nil;
    }
    
    //先判断当前显示的视图中是否存在reusableIdentifier对应的视图
    if (_curViews == nil) {
        //视图还没开始显示, 直接从缓存中取出一条 
        return [array objectAtIndex:0]; 
    } else {
        for (UIView *view in array) {
            //如果缓存中的视图并未处于显示状态，则从缓存中取出
            if (![self isInCurViews:view]) {
                return view;
            }
        }
    }
    return nil;
}

@end
