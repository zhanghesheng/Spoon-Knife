//
//  TBStoryboardTableViewCTL.h
//  TBUI
//
//  Created by enfeng on 13-9-4.
//  Copyright (c) 2013年 com.tuan800.framework.ui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableFooterView.h"
#import "RefreshTableHeaderView.h"
#import "TBUIViewController+Tip.h"

@protocol TBTableViewDataSourceInterface;

@interface TBStoryboardTableViewCTL : UITableViewController <RefreshTableHeaderDelegate,
        RefreshTableFooterDelegate> {
 

    NSMutableArray *_items;
    BOOL _isLoading;
    int _pageSize;
    int _pageNum;
    BOOL _isNoMoreData;

    id <TBTableViewDataSourceInterface> _dataSource;

    NSDictionary *_paramDict;
}

@property(nonatomic, weak) RefreshTableHeaderView *refreshHeaderView;
@property(nonatomic, weak) RefreshTableFooterView *refreshFooterView;
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic) BOOL isLoading;
@property(nonatomic) int pageSize;
@property(nonatomic) int pageNum;
@property(nonatomic) BOOL isNoMoreData;
@property(nonatomic, strong) id <TBTableViewDataSourceInterface> dataSource;


@property(nonatomic, strong) NSDictionary *paramDict;

- (void)didAddFooterView;

/**
* 在表格头添加下拉箭头
*/
- (void)addHeaderRefreshView;

- (void)startRefreshHeaderLoading;

/**
* 在表格底部添加上提箭头
*/
- (void)addFooterRefreshView;

/**
* 子类需要重写该方法
*/
- (void)loadItems;

- (void)resetLoadState;

- (void)scrollToFirstRow;

- (void)doneLoadingHeaderRefresh;
@end
