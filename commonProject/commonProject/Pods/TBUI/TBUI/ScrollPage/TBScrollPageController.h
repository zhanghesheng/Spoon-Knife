//
//  TBScrollPageController.h
//  TBScrollPageDemo
//
//  Created by enfeng on 14-4-10.
//  Copyright (c) 2014年 enfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBScrollPageTopBar.h"
#import "TBBaseViewCTL.h"
#import "TBScrollPageView.h"

@protocol TBScrollPageControllerDelegate <NSObject>
@required
- (NSInteger)index;

- (void)setIndex:(NSInteger)pg;

- (void)setObject:(NSObject *)obj;

- (void)prepareForReuse;

@optional
- (id)getObject;
@end

@class TBScrollPageTopBar;

@interface TBScrollPageController : TBBaseViewCTL <UITableViewDataSource,
        TBScrollPageTopBarDelegate,
        UIScrollViewDelegate> {

    NSMutableDictionary *_recycledPages;
    NSMutableSet *_visiblePages;

    // these values are stored off before we start rotation so we adjust our content offset appropriately during rotation
    int _firstVisiblePageIndexBeforeRotation;

    NSArray *_items;

    NSInteger _selectedPage;
    NSInteger _clickedPage;

    CGFloat _percentScrolledIntoFirstVisiblePage;
}

@property(nonatomic, strong) NSMutableDictionary *recycledPages;
@property(nonatomic, strong) NSMutableSet *visiblePages;

@property(nonatomic, weak) TBScrollPageTopBar *scrollPageTopBar;
@property(nonatomic, weak) TBScrollPageView *pagingScrollView;

@property(nonatomic, strong, setter = setItems:) NSArray *items;

@property(nonatomic) NSInteger pageGap; //页面之间的间隔, 如page1和page5，两者之间的间隔就是5-1
@property(nonatomic) NSInteger moveToPageIndex; //移动到目标页，只用于页面间隔超过1

@property(nonatomic) CGRect viewRect;

-(TBScrollPageTopBar *)createTopBar:(CGRect)topBarRect;

- (void) setEnableDragToRight:(BOOL)enableDragToRight;//是否允许向右拖拽视图

/**
* 需要子类重写该方法
* 返回cell必须为TBScrollPageTopBarCell或其子类
*
* @return 默认返回 TBScrollPageTopBarCell 类, 或者返回TBScrollPageTopBarCell的子类
*/
- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object;

/**
* 子类可以重写该方法
* 选择topBar时调用该方法
*/
- (void)didSelectItemAtIndex:(NSIndexPath *)indexPath;

- (id)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)reloadData;

- (void)reloadSelectedData;

/**
* 子类需要重写该方法
*/
- (NSString *) getIdentifierByIndex:(uint ) index;


- (void)toPageAnimate:(NSInteger)index animate:(BOOL)animate;

/**
* 子类需要重写该方法
*/
- (UIViewController <TBScrollPageControllerDelegate> *)pageForRowAtIndex:(NSUInteger)index;

- (UIViewController <TBScrollPageControllerDelegate> *)dequeueReusablePageWithIdentifier:(NSString *)identifier;

-(void) didShowPage:(UIViewController<TBScrollPageControllerDelegate>*) controller;
@end
