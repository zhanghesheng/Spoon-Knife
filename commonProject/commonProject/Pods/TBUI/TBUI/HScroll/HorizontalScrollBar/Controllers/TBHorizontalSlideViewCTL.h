//
// Created by enfeng on 12-5-31.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TBBaseViewCTL.h"

@protocol TBHorizontalSlideViewCTLDelegate <NSObject>
@required
- (NSInteger)index;

- (void)setIndex:(NSInteger)pg;

- (void)setObject:(NSObject *)obj;

- (void)setHParentController:(UIViewController *)ctl;

- (void)loadData;
@end


@interface TBHorizontalSlideViewCTL : TBBaseViewCTL <UIScrollViewDelegate> {
    UIScrollView *_pagingScrollView;

    NSMutableSet *_recycledPages;
    NSMutableSet *_visiblePages;

    // these values are stored off before we start rotation so we adjust our content offset appropriately during rotation
    int _firstVisiblePageIndexBeforeRotation;
    CGFloat _percentScrolledIntoFirstVisiblePage;

    Class _instanceClass;
    //必须为UIViewController的子类，必须实现HUI800HorizontalSlideViewCTLDelegate协议
    NSArray *_items;

    UIButton *_leftArrowButton;
    UIButton *_rightArrowButton;

    NSInteger _selectedPage;
}
@property(nonatomic, retain, setter = setItems:) NSArray *items;
@property(nonatomic, assign) Class instanceClass;

- (void)setItems:(NSArray *)paramItems;

- (CGSize)contentSizeForPagingScrollView;

- (void)tilePages;

- (void)toPage:(NSInteger)index;

- (void)hideArrowButton:(BOOL)hide;

- (NSArray *)visibleViews;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;

- (void)didShowPage:(UIViewController <TBHorizontalSlideViewCTLDelegate> *)controller;

- (void)didHidePage:(UIViewController <TBHorizontalSlideViewCTLDelegate> *)controller;

- (void)toPageWithAnimate:(NSInteger)index animate:(BOOL)animate;

//放开部分方法供子类调用
- (void)configurePage:(UIViewController <TBHorizontalSlideViewCTLDelegate> *)page forIndex:(NSUInteger)index;

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;
@end