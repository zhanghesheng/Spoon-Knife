//
//  TBScrollPageController.m
//  TBScrollPageDemo
//
//  Created by enfeng on 14-4-10.
//  Copyright (c) 2014年 enfeng. All rights reserved.
//

#import "TBScrollPageController.h"
#import "TBScrollPageTopBarCell.h"
#import "TBScrollPageTopBarItem.h"

#import <objc/runtime.h>
#import "TBUICommon.h"

@interface TBScrollPageController () {

}

@end

@implementation TBScrollPageController

@synthesize pagingScrollView = _pagingScrollView;
@synthesize recycledPages = _recycledPages;
@synthesize visiblePages = _visiblePages;

- (void) setEnableDragToRight:(BOOL)enableDragToRight {
    self.pagingScrollView.enableDragToRight = enableDragToRight;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.viewRect = CGRectZero;
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.viewRect = CGRectZero;
    }
    return self;
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat y = 0;
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:@"7" options:NSNumericSearch] != NSOrderedAscending) {
        y = 20;
    }
    
    if (self.viewRect.size.width>1) {
        self.view.frame = self.viewRect;
    }

//    TBScrollPageTopBar *pageTopBar = [[TBScrollPageTopBar alloc] initWithFrame:
//            CGRectMake(0, y, self.view.frame.size.width, 40)];
    TBScrollPageTopBar *pageTopBar = [self createTopBar:CGRectMake(0, y, self.view.frame.size.width, 40)];

    if (TBIsPad()) {
//        pageTopBar = [[TBScrollPageTopBar alloc] initWithFrame:
//                      CGRectMake(0, y, 1024, 40)];
        pageTopBar = [self createTopBar:CGRectMake(0, y, 1024, 40)];
        CGRect rect = self.view.frame;
        CGFloat w = fetchRealWidthWithParameters(rect.size.width, rect.size.height);
        CGFloat h = fetchRealHeightWithParameters(rect.size.width, rect.size.height);
        rect.size.height = h;
        rect.size.width = w;
        self.view.frame = rect;
    }
    
    //NSLog(@"viewrect = %@", NSStringFromCGRect(self.view.frame));
    [self.view addSubview:pageTopBar];
    self.scrollPageTopBar = pageTopBar;

    self.scrollPageTopBar.dataSource = self;
    self.scrollPageTopBar.barDelegate = self;


    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];

    TBScrollPageView *pScrollView = [[TBScrollPageView alloc] initWithFrame:pagingScrollViewFrame];
    self.pagingScrollView = pScrollView;

    _pagingScrollView.pagingEnabled = YES;
    _pagingScrollView.showsVerticalScrollIndicator = NO;
    [_pagingScrollView setCanCancelContentTouches:NO];
    _pagingScrollView.showsHorizontalScrollIndicator = NO;

    _pagingScrollView.delegate = self;
    _pagingScrollView.pagingEnabled = YES;
    _pagingScrollView.directionalLockEnabled = YES;
    _pagingScrollView.scrollsToTop = NO;

    [self.view addSubview:pScrollView];

    self.recycledPages = [[NSMutableDictionary alloc] init];
    self.visiblePages = [[NSMutableSet alloc] init]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(TBScrollPageTopBar *)createTopBar:(CGRect)topBarRect{
    TBScrollPageTopBar *pageTopBar = [[TBScrollPageTopBar alloc] initWithFrame:topBarRect];
    return pageTopBar;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (void)reloadData {
    [self.scrollPageTopBar reloadData];

    if (self.items.count > 0) {
        [self.scrollPageTopBar selectItem:0];
        [self toPage:0];
    }
}

- (void)reloadSelectedData {
    [self.scrollPageTopBar reloadData];
    
    if (self.items.count > 0 && _selectedPage<=self.items.count) {
        [self.scrollPageTopBar selectItem:_selectedPage];
        [self toPage:_selectedPage];
    }
}

- (UIViewController <TBScrollPageControllerDelegate> *)pageForRowAtIndex:(NSUInteger)index {
    return nil;
}

- (NSString *)getNameFromClass:(Class)pClass {
    const char *className = class_getName(pClass);
    NSString *identifier = [[NSString alloc] initWithBytesNoCopy:(char *) className
                                                          length:strlen(className)
                                                        encoding:NSASCIIStringEncoding freeWhenDone:NO];
    return identifier;
}

#pragma mark - TBScrollPageTopBar 相关方法 -

- (id)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.items.count) {
        return [self.items objectAtIndex:(NSUInteger) indexPath.row];
    } else {
        return nil;
    }
}

- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
    return [TBScrollPageTopBarCell class];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self tableView:tableView objectForRowAtIndexPath:indexPath];

    Class cellClass = [self tableView:tableView cellClassForObject:object];
//    NSString *identifier = NSStringFromClass(cellClass);

    NSString *identifier = [self getNameFromClass:cellClass];

    UITableViewCell *cell =
            (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:identifier];
    }

    if ([cell isKindOfClass:[TBScrollPageTopBarCell class]]) {
        [(TBScrollPageTopBarCell *) cell setObject:object];
    }

    return cell;
}

- (void)didSelectItemAtIndex:(NSIndexPath *)indexPath {
    if (self.items == nil || [self.items count] == 0) {
        return;
    }

//    self.selectedIndex = index;

    [self.scrollPageTopBar selectRowAtIndexPath:indexPath
                                       animated:YES scrollPosition:UITableViewScrollPositionMiddle];

    //等待表格动画结束
    [self toPageAnimate:(uint) indexPath.row animate:YES];
}

- (NSArray *)visibleViews {
    NSInteger vCount = [_visiblePages count];
    if (vCount < 1) return nil;

    return [_visiblePages allObjects];
}

- (void)setItems:(NSArray *)paramItems {
    if (_items) {
        //[_items release];
        _items = nil;
    }
    _items = paramItems;//[paramItems retain];
    
    [_scrollPageTopBar reloadData];
    
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    NSUInteger count = _items.count;
    if (count == 0) {
        while (_pagingScrollView.subviews.count) {
            UIView *child = _pagingScrollView.subviews.lastObject;
            [child removeFromSuperview];
        }
        return;
    }
    if (_selectedPage <= 0 || _selectedPage > count) {
        [self toPage:0];
    } else {
        [self toPage:_selectedPage];
    }
}


#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)clearSubControllers {
    //    NSArray *arr = [self childViewControllers];
    //    if (arr == nil || arr.count<1)
    //    {
    //        return;
    //    }
    //
    //    for (UIViewController *ctl in arr) {
    //        [ctl removeFromParentViewController];
    //    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    _selectedPage = -1;
    _clickedPage = -1;

    [self clearSubControllers];

    _pagingScrollView.delegate = nil;
}


- (UIViewController <TBScrollPageControllerDelegate> *)dequeueReusablePageWithIdentifier:(NSString *)identifier {
    UIViewController <TBScrollPageControllerDelegate> *page = nil;

    if ([self.recycledPages objectForKey:identifier]) {
        page = [self.recycledPages objectForKey:identifier];

        if (page) {
            // Found a reusable view, remove it from the set
            [self.recycledPages removeObjectForKey:identifier];
        }
    }
    return page;
}

- (void)didShowPage:(UIViewController <TBScrollPageControllerDelegate> *)controller {

}


- (void)dealloc {
    [self clearSubControllers];
    _pagingScrollView.delegate = nil;
}


#pragma mark -

#pragma mark Tiling and page configuration

- (void)toPageWithAnimate:(NSUInteger)index animate:(BOOL)animate {
    if (!self.items || self.items.count < 1) {
        return;
    }

    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    CGFloat x = pagingScrollViewFrame.size.width * index;
    CGFloat y = pagingScrollViewFrame.origin.y;
    CGRect rt = CGRectMake(x, y, pagingScrollViewFrame.size.width, pagingScrollViewFrame.size.height);

    //每次跳转之前只会有一个可见页面，也只允许一个
    UIViewController <TBScrollPageControllerDelegate> *currentPage = [self.visiblePages anyObject];
    NSInteger currentIndex = currentPage.index;
    int m1 = (int)currentIndex - (int)index;
    self.pageGap = abs(m1);

    //当动画结束后需要恢复页面的真正位置
    if (self.pageGap > 1) {
        //如果页面间隔大于1
        UIViewController <TBScrollPageControllerDelegate> *page = [self pageForRowAtIndex:index];

        NSInteger targetIndex;
        if (index > currentIndex) {
            //将目标视图移动到当前视图的右边
            targetIndex = currentIndex + 1;
        } else {
            //将目标视图移动到当前视图的左边
            targetIndex = currentIndex - 1;
        }
        [page setIndex:index];
        self.moveToPageIndex = index;
        page.view.frame = [self frameForPageAtIndex:(uint) targetIndex];
        _selectedPage = index;
        [_pagingScrollView addSubview:page.view];

        [_visiblePages addObject:page];
        NSObject *obj = [_items objectAtIndex:index];
        [page setObject:obj];

        rt.origin.x = pagingScrollViewFrame.size.width * targetIndex;
    }

    [_pagingScrollView scrollRectToVisible:rt animated:animate];
}

- (void)toPage:(NSInteger)index {
    [self toPageWithAnimate:(uint) index animate:NO];
    [self tilePages];
    [self callBack];
}

- (void)toPageAnimate:(NSInteger)index animate:(BOOL)animate {
    _clickedPage = index;
    [self toPageWithAnimate:(uint) index animate:animate];
}

- (NSString *)getIdentifierByIndex:(uint)index {

    return nil;
}

- (void)tilePages {
    if (_items == nil || _items.count < 1 || self.pageGap > 1) {
        return;
    }

    // Calculate which pages are visible
    CGRect visibleBounds = _pagingScrollView.bounds;
    if (TBIsPad()) {
        CGFloat w = fetchRealWidthWithParameters(visibleBounds.size.width, visibleBounds.size.height);
        CGFloat h = fetchRealHeightWithParameters(visibleBounds.size.width, visibleBounds.size.height);
        visibleBounds.size.width = w;
        visibleBounds.size.height = h;
    }
    
    int firstNeededPageIndex = (int) floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex = (int) floorf((CGRectGetMaxX(visibleBounds) - 1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex = MIN(lastNeededPageIndex, (int)[_items count] - 1);

    // Recycle no-longer-visible pages
    NSMutableSet *nSet = [NSMutableSet setWithCapacity:2];

    for (UIViewController <TBScrollPageControllerDelegate> *page in _visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            NSString *identifier = [self getNameFromClass:[page class]];
            [_recycledPages setValue:page forKey:identifier];
            [page.view removeFromSuperview];
            [page prepareForReuse];

            [nSet addObject:page];
        }
    }

    [_visiblePages minusSet:nSet];

    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {

        if (![self isDisplayingPageForIndex:(uint) index]) {

            NSString *identifier = [self getIdentifierByIndex:(uint) index];
            UIViewController <TBScrollPageControllerDelegate> *page = [self dequeueReusablePageWithIdentifier:identifier];

            if (page == nil) {
                //page = [[_instanceClass alloc] init];
                page = [self pageForRowAtIndex:(uint) index];
            }

            [self configurePage:page forIndex:(uint) index];

            [_pagingScrollView addSubview:page.view];
            if (_items) {
                if (_clickedPage != -1) {
                    if (index == _clickedPage) {
                        NSObject *obj = [_items objectAtIndex:(uint) index];
                        [page setObject:obj];
                    }
                    _clickedPage = -1;
                } else {
                    NSObject *obj = [_items objectAtIndex:(uint) index];
                    [page setObject:obj];
                }
            }
            [page viewWillAppear:NO];
            [page viewDidAppear:NO];
            [_visiblePages addObject:page];
        } else {

            //用于页面通知，刷新列表, toPage
            for (UIViewController <TBScrollPageControllerDelegate> *page in _visiblePages) {
                if (page.index == index) {
                    if ([page respondsToSelector:@selector(getObject)]) {
                        id pageObj = [page getObject];
                        NSObject *obj = [_items objectAtIndex:(uint) index];
                        if (obj != pageObj) {
                            [page setObject:obj];
                        }
                    }
                    break;
                }
            }
        }
    }
}

- (UIViewController <TBScrollPageControllerDelegate> *)getDisplayingPageForIndex:(NSUInteger)index {

    UIViewController <TBScrollPageControllerDelegate> *page = nil;

    for (page in _visiblePages) {
        if (page.index == index) {
            break;
        }
    }

    return page;

}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {

    BOOL foundPage = NO;

    for (UIViewController <TBScrollPageControllerDelegate> *page in _visiblePages) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }

    return foundPage;

}

- (void)configurePage:(UIViewController <TBScrollPageControllerDelegate> *)page forIndex:(NSUInteger)index {
    [page setIndex:index];
    page.view.frame = [self frameForPageAtIndex:index];
    _selectedPage = index;
}

#pragma mark -

#pragma mark ScrollView delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self tilePages];
}

- (void)callBack {

    //恢复页面真正位置
    if (self.pageGap > 1) {

        NSMutableSet *nSet = [NSMutableSet setWithCapacity:2];
        for (UIViewController <TBScrollPageControllerDelegate> *page in _visiblePages) {
            if (page.index != self.moveToPageIndex) {
                NSString *identifier = [self getNameFromClass:[page class]];
                [_recycledPages setValue:page forKey:identifier];
                [page.view removeFromSuperview];
                [page prepareForReuse];
                [nSet addObject:page];
            }
        }
        [_visiblePages minusSet:nSet];

        UIViewController <TBScrollPageControllerDelegate> *page = _visiblePages.anyObject;
        [self configurePage:page forIndex:(uint) page.index];

        CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
        CGFloat x = pagingScrollViewFrame.size.width * page.index;
        CGFloat y = pagingScrollViewFrame.origin.y;
        CGRect rt = CGRectMake(x, y, pagingScrollViewFrame.size.width, pagingScrollViewFrame.size.height);
        [_pagingScrollView scrollRectToVisible:rt animated:NO];

        self.pageGap = 0;
    }

    NSArray *arr = self.visibleViews;
    NSUInteger count = [arr count];
    if (count < 1) {
        return;
    }
    count = self.items.count;
    UIViewController <TBScrollPageControllerDelegate> *page = [arr objectAtIndex:0];
    _selectedPage = page.index;

    [self didShowPage:page];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self callBack];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self callBack];
    _clickedPage = -1;
}

#pragma mark -

#pragma mark View controller rotation methods
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // here, our _pagingScrollView bounds have not yet been updated for the new interface orientation. So this is a good
    // place to calculate the content offset that we will need in the new orientation
    CGFloat offset = _pagingScrollView.contentOffset.x;
    CGFloat pageWidth = _pagingScrollView.bounds.size.width;

    if (offset >= 0) {
        _firstVisiblePageIndexBeforeRotation = (int) floorf(offset / pageWidth);
        _percentScrolledIntoFirstVisiblePage = (offset - (_firstVisiblePageIndexBeforeRotation * pageWidth)) / pageWidth;
    } else {
        _firstVisiblePageIndexBeforeRotation = 0;
        _percentScrolledIntoFirstVisiblePage = offset / pageWidth;
    }

}



#pragma mark -

#pragma mark  Frame calculations

#define PADDING  0

- (CGRect)frameForPagingScrollView {

    //    CGRect frame = [[UIScreen mainScreen] bounds];
    CGRect frame;
    if (TBIsPad()) {
        frame = self.view.frame;
        frame.origin.x -= PADDING;
        CGFloat w = fetchRealWidthWithParameters(frame.size.width, frame.size.height);
        CGFloat h = fetchRealHeightWithParameters(frame.size.width, frame.size.height);
        if (w == 1044) {
            w = w - 20;
        }
        if (h == 812) {
            h = h -44;
        }
        w += (2 * PADDING);
        //frame.size.width += (2 * PADDING);
        frame.size.width = w;
        frame.size.height = h;
        frame.origin.y = self.scrollPageTopBar.frame.origin.y + self.scrollPageTopBar.frame.size.height;
        frame.size.height = frame.size.height - frame.origin.y;
        frame.origin.x = 0;
    }else{
        frame = self.view.frame;
        frame.origin.x -= PADDING;
        frame.size.width += (2 * PADDING);
        frame.origin.y = self.scrollPageTopBar.frame.origin.y + self.scrollPageTopBar.frame.size.height;
        frame.size.height = frame.size.height - frame.origin.y;
    }
    
    return frame;

}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {

    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in

    // landscape orientation, the frame will still be in portrait because the _pagingScrollView is the root view controller's

    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape

    // because it has a rotation transform applied.

    CGRect pageFrame;

    if (TBIsPad()) {
        CGRect bounds = _pagingScrollView.bounds;
        pageFrame = bounds;
        CGFloat w = fetchRealWidthWithParameters(bounds.size.width, bounds.size.height);
        CGFloat h = fetchRealHeightWithParameters(bounds.size.width, bounds.size.height);
        pageFrame.size.width = w;
        pageFrame.size.height = h;
        pageFrame.size.width -= (2 * PADDING);
        pageFrame.origin.x = (w * index) + PADDING;
    }else{
        CGRect bounds = _pagingScrollView.bounds;
        pageFrame = bounds;
        pageFrame.size.width -= (2 * PADDING);
        pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    }
    return pageFrame;
}

- (CGSize)contentSizeForPagingScrollView {

    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = _pagingScrollView.bounds;
    if (TBIsPad()){
        CGFloat w = fetchRealWidthWithParameters(bounds.size.width, bounds.size.height);
        CGFloat h = fetchRealHeightWithParameters(bounds.size.width, bounds.size.height);
        return CGSizeMake(w * [_items count], h);
    }
    return CGSizeMake(bounds.size.width * [_items count], bounds.size.height);
}
@end
