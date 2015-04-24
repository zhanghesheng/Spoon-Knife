//
//  Tao800HorizontalSlideVCL.h
//  tao800
//
//  Created by adminName on 14-2-17.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800VCL.h"
#import <Foundation/Foundation.h>

@protocol Tao800HorizontalSlideVCLDelegate <NSObject>
@required
- (NSInteger)index;

- (void)setIndex:(NSInteger)pg;

- (void)setObject:(NSObject *)obj;

- (void)setHParentController:(UIViewController *)ctl;

- (void)loadData;

- (void)prepareForReuse;

@optional
- (id)getObject;
@end

@interface Tao800HorizontalSlideVCL : Tao800VCL <UIScrollViewDelegate> {
    UIScrollView *_pagingScrollView;

    NSMutableSet *_recycledPages;
    NSMutableSet *_visiblePages;

    // these values are stored off before we start rotation so we adjust our dealContent offset appropriately during rotation
    int _firstVisiblePageIndexBeforeRotation;
    CGFloat _percentScrolledIntoFirstVisiblePage;

    __weak Class _instanceClass;
    //必须为UIViewController的子类，必须实现HUI800HorizontalSlideViewCTLDelegate协议
    NSArray *_items;

    UIButton *_leftArrowButton;
    UIButton *_rightArrowButton;

    NSInteger _selectedPage;
    NSInteger _clickedPage;
}
@property(nonatomic, strong, setter = setItems:) NSArray *items;
@property(nonatomic, weak) Class instanceClass;

@property(nonatomic) int pageGap; //页面之间的间隔
@property(nonatomic) int moveToPageIndex; //移动到目标页，只用于页面间隔超过1

@property (nonatomic) CGFloat scrollViewTopMargin; //temp todo

- (void)setItems:(NSArray *)paramItems;

- (CGSize)contentSizeForPagingScrollView;

- (void)tilePages;

- (void)toPage:(NSInteger)index;

- (void)configurePage:(UIViewController <Tao800HorizontalSlideVCLDelegate> *)page forIndex:(NSUInteger)index;

- (void)hideArrowButton:(BOOL)hide;

- (void)hideArrowButtonAlltime;

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;

- (NSArray *)visibleViews;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;

- (void)didShowPage:(UIViewController <Tao800HorizontalSlideVCLDelegate> *)controller;

- (void)didHidePage:(UIViewController <Tao800HorizontalSlideVCLDelegate> *)controller;

- (void)toPageAnimate:(NSInteger)index animate:(BOOL)animate;

- (void)toPageWithAnimate:(NSInteger)index animate:(BOOL)animate;
@end

