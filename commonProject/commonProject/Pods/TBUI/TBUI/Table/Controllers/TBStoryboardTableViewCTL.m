//
//  TBStoryboardTableViewCTL.m
//  TBUI
//
//  Created by enfeng on 13-9-4.
//  Copyright (c) 2013年 com.tuan800.framework.ui. All rights reserved.
//

#import "TBStoryboardTableViewCTL.h"
#import "TBTableViewDataSource.h"
#import "TBTableViewCell.h"
#import "TBUICommon.h"


@interface TBStoryboardTableViewCTL ()

@end

@implementation TBStoryboardTableViewCTL

@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize refreshFooterView = _refreshFooterView;
@synthesize items = _items;
@synthesize isLoading = _isLoading;
@synthesize pageSize = _pageSize;
@synthesize pageNum = _pageNum;
@synthesize isNoMoreData = _isNoMoreData;
@synthesize dataSource = _dataSource;
@synthesize paramDict = _paramDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.items = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    _refreshFooterView.delegate = nil;
    _refreshHeaderView.delegate = nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.items = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self resetLoadState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didAddFooterView {

}

- (void)addHeaderRefreshView {
    // 下拉刷新
    if (self.refreshHeaderView == nil) {
        CGRect rHeaderRect = CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 300, REFRESH_HEADER_HEIGHT);
        RefreshTableHeaderView *ref = [[RefreshTableHeaderView alloc] initWithFrame:rHeaderRect];
        self.refreshHeaderView = ref;
        self.refreshHeaderView.delegate = self;

        [self.tableView addSubview:self.refreshHeaderView];
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
        [self.tableView addSubview:fView];
        [_refreshFooterView setActivityStyle:UIActivityIndicatorViewStyleGray];
    }

    [_refreshFooterView refreshLastUpdatedDate];
    [self didAddFooterView];
}

- (void)startRefreshHeaderLoading {
    if (_isLoading) {
        return;
    }
    _isLoading = YES;

    [_refreshHeaderView setState:EGOOPullRefreshLoading];
    CGPoint offset = self.tableView.contentOffset;

    if (offset.y == 0) {
        offset.y = -REFRESH_HEADER_HEIGHT;
        self.tableView.contentOffset = offset;
    }
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.tableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
}

- (void)doneLoadingHeaderRefresh {
    self.isLoading = NO;
    //隐藏
    SEL sel = @selector(egoRefreshScrollViewDataSourceDidFinishedLoading:);
    //先等待前面的loading动画
    [self.refreshHeaderView performSelector:sel withObject:self.tableView afterDelay:.2];
}

- (void)doneLoadingFooterRefresh {

    //  model should call this when its done loading
    //_reloading = NO;
    _isLoading = NO;
    _refreshFooterView.IsLoading = NO;

    //隐藏
    SEL sel = @selector(Footer_RefreshScrollViewDataSourceDidFinishedLoading:);
    //先等待前面的loading动画
    [self.refreshFooterView performSelector:sel withObject:self.tableView afterDelay:.2];
}

- (void)resetLoadState {

    if ([self.topViewController isKindOfClass:[self class]]) {
        if (self.isLoading) {
            if (self.refreshFooterView.IsLoading) {
                [self doneLoadingFooterRefresh];
            } else {
                [self doneLoadingHeaderRefresh];
            }
        }
    } else {
//        [self.refreshFooterView resetToDefaultState:self.tableView];
        [self.refreshFooterView stopAnimate:self.tableView];
        [self.refreshHeaderView resetToDefaultState:self.tableView];
    }

    self.isLoading = NO;
    self.refreshFooterView.IsLoading = NO;
}

- (void)loadItems {

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView.dataSource isKindOfClass:[TBTableViewDataSource class]]) {
        id <TBTableViewDataSourceInterface> dataSource = (id <TBTableViewDataSourceInterface>) tableView.dataSource;

        id object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
        Class cls = [dataSource tableView:tableView cellClassForObject:object];
        return [cls tableView:tableView rowHeightForObject:object];
    }
    return TBDefaultRowHeight;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.tableView) {
        return;
    }
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
    if (scrollView != self.tableView) {
        return;
    }

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

#pragma mark -
#pragma mark RefreshTableHeaderDelegate Methods
- (BOOL)refreshTableHeaderDataSourceIsLoading:(RefreshTableHeaderView *)view {
    return self.isLoading;
}

- (void)refreshTableHeaderDidTriggerRefresh:(RefreshTableHeaderView *)view {
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;

    self.pageNum = 1;
    [self loadItems];
}

- (void)RefreshTableFooterDidTriggerRefresh:(RefreshTableFooterView *)view {
    if (self.isLoading) {
        return;
    }

    self.isLoading = YES;
    self.refreshFooterView.IsLoading = YES;

    if (self.isNoMoreData) {
        return;
    }
    self.pageNum += 1;
    [self loadItems];
}

- (NSDate *)refreshTableHeaderDataSourceLastUpdated:(RefreshTableHeaderView *)view {
    return [NSDate date];
}

- (BOOL)RefreshTableFooterDataSourceIsLoading:(RefreshTableFooterView *)view {
    return self.isLoading;
}

- (NSDate *)RefreshTableFooterDataSourceLastUpdated:(RefreshTableFooterView *)view {
    return [NSDate date];
}

- (void)setDataSource:(id <TBTableViewDataSourceInterface>)dataSource {
    if (dataSource != _dataSource) {
        _dataSource = dataSource;
        self.tableView.dataSource = nil;
    }

    self.tableView.dataSource = _dataSource;
    [self.tableView reloadData];
}


- (void)scrollToFirstRow {
    if (self.tableView.contentOffset.y < 0) {
        return;
    }

    TBTableViewDataSource *dc = (TBTableViewDataSource *) self.dataSource;

    if (dc && dc.items && dc.items.count > 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (void) assignParamDict:(NSDictionary *) sParamDict {
    self.paramDict = sParamDict;
}
@end
