//
//  TBCollectionViewCTL.m
//  TBUI
//
//  Created by enfeng on 14-7-17.
//  Copyright (c) 2014年 com.tuan800.framework.ui. All rights reserved.
//

#import "TBCollectionViewCTL.h"
#import "TBUICommon.h"

@implementation TBCollectionViewCTL

- (void)addHeaderRefreshView {
    // 下拉刷新
    if (self.refreshHeaderView == nil) {
        CGRect rHeaderRect = CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 300, REFRESH_HEADER_HEIGHT);
        RefreshTableHeaderView *ref = [[RefreshTableHeaderView alloc]
                initWithFrame:rHeaderRect
                       params:self.refreshTableHeaderViewParam];
        self.refreshHeaderView = ref;
        self.refreshHeaderView.delegate = self;

        [self.collectionView addSubview:self.refreshHeaderView];
        [_refreshHeaderView setActivityStyle:UIActivityIndicatorViewStyleGray];
    }
    [self.refreshHeaderView refreshLastUpdatedDate];
}

- (void)addFooterRefreshView {
    if (_refreshFooterView == nil) {
        CGRect rect = CGRectMake(0, 3320, 320, REFRESH_HEADER_HEIGHT);
        RefreshTableFooterView *fView = [[RefreshTableFooterView alloc] initWithFrame:rect];

        _refreshFooterView = fView;
        _refreshFooterView.delegate = self;
        [self.collectionView addSubview:self.refreshFooterView];
        [_refreshFooterView setActivityStyle:UIActivityIndicatorViewStyleGray];
    }

    [_refreshFooterView refreshLastUpdatedDate];
}

- (void)loadView {
    [super loadView];
    if (TBIsPad()) {
        self.viewRectPad = fetRealRectWithParameters(self.view.frame);
    }
}

- (void)startRefreshHeaderLoading {

    if (self.model.loading) {
        return;
    }
    self.model.loading = YES;

    [_refreshHeaderView setState:EGOOPullRefreshLoading];
    CGPoint offset = self.collectionView.contentOffset;

    if (offset.y == 0) {
        offset.y = -REFRESH_HEADER_HEIGHT;
        self.collectionView.contentOffset = offset;
    }
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.collectionView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.collectionView];
}

- (void)loadItems {

}

- (void)resetLoadState {

    if ([self.topViewController isKindOfClass:[self class]]) {
        BOOL loading = self.model.loading;

        if (loading) {
            if (self.refreshFooterView.IsLoading) {
                [self doneLoadingFooterRefresh];
            } else {
                [self doneLoadingHeaderRefresh];
            }
        }
    } else {
//        [self.refreshFooterView resetToDefaultState:self.collectionView];
        [self.refreshFooterView stopAnimate:self.collectionView];
        [self.refreshHeaderView resetToDefaultState:self.collectionView];
    }

    self.refreshFooterView.IsLoading = NO;
    self.model.loading = NO;
}

- (void)doneLoadingHeaderRefresh {
    self.model.loading = NO;

    //隐藏
    SEL sel = @selector(egoRefreshScrollViewDataSourceDidFinishedLoading:);
    //先等待前面的loading动画
    [self.refreshHeaderView setState:EGOOPullRefreshSuccess];
    [self.refreshHeaderView performSelector:sel withObject:self.collectionView afterDelay:1];
}

- (void)doneLoadingFooterRefresh {

    self.model.loading = NO;
    _refreshFooterView.IsLoading = NO;

    //隐藏
    SEL sel = @selector(Footer_RefreshScrollViewDataSourceDidFinishedLoading:);
    //先等待前面的loading动画
    [self.refreshFooterView performSelector:sel withObject:self.collectionView afterDelay:.2];
}

- (void)setDataSource:(id <UICollectionViewDataSource>)dataSource {
    if (dataSource != _dataSource) {
        _dataSource = dataSource;
        _collectionView.dataSource = nil;
    }

    _collectionView.dataSource = _dataSource;
    [_collectionView reloadData];
}

#pragma mark --- UICollectionDataSource Methods ---

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark --- RefreshHeaderView Delegate Methods ---

- (BOOL)refreshTableHeaderDataSourceIsLoading:(RefreshTableHeaderView *)view {
    return self.model.loading;
}

- (void)refreshTableHeaderDidTriggerRefresh:(RefreshTableHeaderView *)view {

    if (self.model.loading) {
        return;
    }
    self.model.loading = YES;
    self.model.pageNumber = 1;

    [self loadItems];
}

- (NSDate *)refreshTableHeaderDataSourceLastUpdated:(RefreshTableHeaderView *)view {
    return [NSDate date];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView != self.tableView) {
//        return;
//    }
    CGFloat wd = scrollView.frame.size.width;

    BOOL footerIsLoading = (_refreshFooterView.state == OPullFooterRefreshLoading);
    BOOL headerIsLoading = (_refreshHeaderView.state == EGOOPullRefreshLoading);

    //上提
    CGFloat tableViewHeight = scrollView.frame.size.height;
    CGFloat height = tableViewHeight + scrollView.contentOffset.y;
    CGFloat readyShowFooterHeight = scrollView.contentSize.height;
    if (readyShowFooterHeight < tableViewHeight) {
        readyShowFooterHeight = tableViewHeight;
    }

    if (_refreshFooterView.delegate != nil && !_refreshFooterView.IsLoadComplete && height > readyShowFooterHeight
            && !headerIsLoading
            ) {
        CGFloat ht = scrollView.contentSize.height;
        if (ht < scrollView.frame.size.height) {
            ht = scrollView.frame.size.height;
        }
        _refreshFooterView.frame = CGRectMake(0, ht, wd, REFRESH_HEADER_HEIGHT);
        [_refreshFooterView Footer_RefreshScrollViewDidScroll:scrollView];
    }

    //下拉刷新
    if (_refreshHeaderView && _refreshHeaderView.delegate != nil && scrollView.contentOffset.y < 0
            && !footerIsLoading) {
        _refreshHeaderView.frame = CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, wd, REFRESH_HEADER_HEIGHT);
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (scrollView != self.tableView) {
//        return;
//    }

    //当footer进入loading时不再响应header事件
    //当header进入loading时不再响应footer事件
    BOOL footerIsLoading = (_refreshFooterView.state == OPullFooterRefreshLoading);
    BOOL headerIsLoading = (_refreshHeaderView.state == EGOOPullRefreshLoading);

    //向下拉时contentOffset.y的值为负数
    if (_refreshHeaderView
            && _refreshHeaderView.delegate != nil && scrollView.contentOffset.y < 0
            && !footerIsLoading
            ) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }

    CGFloat tableViewHeight = scrollView.frame.size.height;
    CGFloat ht = tableViewHeight + scrollView.contentOffset.y;
    CGFloat readyShowFooterHeight = scrollView.contentSize.height;

    if (_refreshFooterView
            && _refreshFooterView.delegate != nil && !_refreshFooterView.IsLoadComplete
            && ht > readyShowFooterHeight
            && !headerIsLoading
            ) {
        [_refreshFooterView Footer_RefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark --- RefreshTableFooterView Delegate Methods ---
- (void)RefreshTableFooterDidTriggerRefresh:(RefreshTableFooterView *)view {

    if (self.model.loading) {
        return;
    }

    self.model.loading = YES;
    self.refreshFooterView.IsLoading = YES;

    if (!self.model.hasNext) {
        return;
    }
    self.model.pageNumber += 1;


    [self loadItems];
}

- (BOOL)RefreshTableFooterDataSourceIsLoading:(RefreshTableFooterView *)view {
    return self.model.loading;
}

- (NSDate *)RefreshTableFooterDataSourceLastUpdated:(RefreshTableFooterView *)view {
    return [NSDate date];
}

- (void)dealloc
{
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
}
@end
