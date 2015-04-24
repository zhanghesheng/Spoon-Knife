//
//  TBCollectionViewCTL.h
//  TBUI
//
//  Created by enfeng on 14-7-17.
//  Copyright (c) 2014年 com.tuan800.framework.ui. All rights reserved.
//

#import "TBBaseViewCTL.h"
#import "RefreshTableHeaderView.h"
#import "RefreshTableFooterView.h"

@interface TBCollectionViewCTL : TBBaseViewCTL <
        UICollectionViewDelegate,
        UICollectionViewDataSource,
        UIScrollViewDelegate,
        RefreshTableHeaderDelegate,
        RefreshTableFooterDelegate>

@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic, strong) id <UICollectionViewDataSource> dataSource;
@property(nonatomic, strong) RefreshTableHeaderViewParam *refreshTableHeaderViewParam;
@property(nonatomic, weak) RefreshTableHeaderView *refreshHeaderView;
@property(nonatomic, weak) RefreshTableFooterView *refreshFooterView;

- (void)startRefreshHeaderLoading;

/**
* 子类需要重写该方法
*/
- (void)loadItems;

- (void)resetLoadState;

- (void)doneLoadingHeaderRefresh;


/**
* 在表格头添加下拉箭头
*/
- (void)addHeaderRefreshView;

/**
* 在表格底部添加上提箭头
*/
- (void)addFooterRefreshView;
@end
