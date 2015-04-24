//
//  TBTableViewCTL.h
//  TBUI
//
//  Created by enfeng on 12-9-19.
//  Copyright (c) 2012年 com.tuan800.framework.ui. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TBBaseViewCTL.h"
#import "RefreshTableFooterView.h"
#import "RefreshTableHeaderView.h"

@protocol TBTableViewDataSourceInterface;

@interface TBTableViewCTL : TBBaseViewCTL <UITableViewDataSource,
        UITableViewDelegate,
        RefreshTableHeaderDelegate,
        RefreshTableFooterDelegate> {
    RefreshTableHeaderViewParam *_refreshTableHeaderViewParam;
 

    NSMutableArray *_items;
    BOOL _isLoading;
    int _pageSize;
    int _pageNum;
    BOOL _isNoMoreData;

    id <TBTableViewDataSourceInterface> _dataSource;
    UITableViewStyle _tableViewStyle;
}
@property(nonatomic, weak) IBOutlet UITableView *tableView;

@property(nonatomic, weak) RefreshTableHeaderView *refreshHeaderView;
@property(nonatomic, weak) RefreshTableFooterView *refreshFooterView;
@property (nonatomic, strong) RefreshTableHeaderViewParam * refreshTableHeaderViewParam;
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic) BOOL isLoading;
@property(nonatomic) int pageSize;
@property(nonatomic) int pageNum;
@property(nonatomic) BOOL isNoMoreData;
@property(nonatomic, strong) id <TBTableViewDataSourceInterface> dataSource;
@property(nonatomic) UITableViewStyle tableViewStyle;


- (void) didAddFooterView;

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
