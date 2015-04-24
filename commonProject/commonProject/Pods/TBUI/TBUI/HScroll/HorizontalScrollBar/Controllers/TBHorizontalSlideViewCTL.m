//
// Created by enfeng on 12-5-31.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TBHorizontalSlideViewCTL.h"

#import "TBUI.h"

@interface TBHorizontalSlideViewCTL (ext)
- (UIViewController <TBHorizontalSlideViewCTLDelegate> *)dequeueRecycledPage;

- (CGRect)frameForPagingScrollView;

- (CGRect)frameForPageAtIndex:(NSUInteger)index;

- (void)callBack;

- (void)nextPage;

- (void)prePage;

- (void)hideArrowButton:(BOOL)hide;

- (void)toPageAnimate:(NSInteger)index animate:(BOOL)animate;
@end

@implementation TBHorizontalSlideViewCTL
@synthesize instanceClass = _instanceClass;
@synthesize items = _items;

- (void)didShowPage:(UIViewController <TBHorizontalSlideViewCTLDelegate> *)controller {

}

- (void)didHidePage:(UIViewController <TBHorizontalSlideViewCTLDelegate> *)controller {

}

- (NSArray *)visibleViews {
    NSInteger vCount = [_visiblePages count];
    if (vCount < 1) return nil;

    return [_visiblePages allObjects];
}

- (void)hideArrowButton:(BOOL)hide {
    _leftArrowButton.hidden = NO;
    _rightArrowButton.hidden = NO;
    NSInteger vCount = [_visiblePages count];
    if (vCount > 1) return;

    UIViewController <TBHorizontalSlideViewCTLDelegate> *page = nil;
    for (page in _visiblePages) {
        break;
    }

    if (!hide) {
        if (page.index <= 0) {
            _leftArrowButton.hidden = YES;
        }
        if (page.index >= [_items count] - 1) {
            _rightArrowButton.hidden = YES;
        }
    }
    if (self.items || self.items.count<1) {
        _leftArrowButton.hidden = YES;
        _rightArrowButton.hidden = YES;
    }
}

- (void)nextPage {
    NSInteger ct = [_items count] - 1;
    if (_selectedPage >= ct) {
        _selectedPage = ct;
        return;
    }
    NSInteger inx = _selectedPage + 1;
    [self toPageAnimate:inx animate:YES];
}

- (void)prePage {
    if (_selectedPage <= 0) {
        _selectedPage = 0;
        return;
    }
    NSInteger inx = _selectedPage - 1;
    [self toPageAnimate:inx animate:YES];
}

- (void)setItems:(NSArray *)paramItems {
 
    _items = paramItems;
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    NSInteger count = _items.count;
    if (count == 0) {
        [_pagingScrollView removeAllSubviews];
        return;
    }
    if (_selectedPage <= 0 || _selectedPage > count) {
        [self toPage:0];
    } else {
        [self toPage:_selectedPage];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];

    _pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
    _pagingScrollView.pagingEnabled = YES;
//    _pagingScrollView.backgroundColor = [UIColor blackColor];

    _pagingScrollView.showsVerticalScrollIndicator = NO;
    [_pagingScrollView setCanCancelContentTouches:NO];
    _pagingScrollView.showsHorizontalScrollIndicator = NO;

    _pagingScrollView.delegate = self;
    _pagingScrollView.pagingEnabled = YES;
    _pagingScrollView.directionalLockEnabled = YES;

    [self.view addSubview:_pagingScrollView];

    // Step 2: prepare to tile content
    _recycledPages = [[NSMutableSet alloc] init];
    _visiblePages = [[NSMutableSet alloc] init];


    UIImage *leftImg = TBIMAGE(@"bundle://pre_arrow.png");
    UIImage *rightImg = TBIMAGE(@"bundle://next_arrow.png");

    CGFloat imgWidth = leftImg.size.width;
    CGFloat imgHeight = leftImg.size.height;

    _leftArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [_leftArrowButton setBackgroundImage:leftImg forState:UIControlStateNormal];
    [_rightArrowButton setBackgroundImage:rightImg forState:UIControlStateNormal];

    CGFloat x = 0;
    CGFloat y = (pagingScrollViewFrame.size.height - imgHeight) / 2;

    _leftArrowButton.frame = CGRectMake(x, y, imgWidth, imgHeight);
    [_leftArrowButton addTarget:self action:@selector(prePage) forControlEvents:UIControlEventTouchUpInside];
    x = pagingScrollViewFrame.size.width - imgWidth;

    _rightArrowButton.frame = CGRectMake(x, y, imgWidth, imgHeight);
    [_rightArrowButton addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];


    [self.view addSubview:_leftArrowButton];
    [self.view addSubview:_rightArrowButton];

    _leftArrowButton.hidden = YES;
    _rightArrowButton.hidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) clearSubControllers {
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
    
    [self clearSubControllers];
}


- (void)dealloc {
    [self clearSubControllers];
}

#pragma mark -

#pragma mark Tiling and page configuration

- (void)toPageWithAnimate:(NSInteger)index animate:(BOOL)animate {
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    CGFloat x = pagingScrollViewFrame.size.width * index;
    CGFloat y = pagingScrollViewFrame.origin.y;
    CGRect rt = CGRectMake(x, y, pagingScrollViewFrame.size.width, pagingScrollViewFrame.size.height);
    [_pagingScrollView scrollRectToVisible:rt animated:animate];
}

- (void)toPage:(NSInteger)index {
    [self toPageWithAnimate:index animate:NO];
    [self tilePages];
    [self callBack];
}

- (void)toPageAnimate:(NSInteger)index animate:(BOOL)animate {
    [self toPageWithAnimate:index animate:animate];
}

- (void)tilePages {
    if (_items == nil) {
        return;
    }
    
    if (_items && _items.count<1) {
        return;
    }

    // Calculate which pages are visible
    CGRect visibleBounds = _pagingScrollView.bounds;

    int firstNeededPageIndex = (int) floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex = (int) floorf((CGRectGetMaxX(visibleBounds) - 1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex = MIN(lastNeededPageIndex, (int)[_items count] - 1);

    // Recycle no-longer-visible pages
    for (UIViewController <TBHorizontalSlideViewCTLDelegate> *page in _visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [_recycledPages addObject:page];
            [page.view removeFromSuperview];
            [page viewDidDisappear:NO];
            [self didHidePage:page];
        }
    }

    [_visiblePages minusSet:_recycledPages];

    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {

        if (![self isDisplayingPageForIndex:index]) {

            UIViewController <TBHorizontalSlideViewCTLDelegate> *page = [self dequeueRecycledPage];

            if (page == nil) {
                page = [[_instanceClass alloc] init];
                SEL sel = @selector(setHParentController:);
                if ([page respondsToSelector:sel]) {
                    [(id<TBHorizontalSlideViewCTLDelegate>)page setHParentController:self];
                }
//                [self addChildViewController:page];
            }

            [self configurePage:page forIndex:index];

            [_pagingScrollView addSubview:page.view];
            if (_items) {
                NSObject *obj = [_items objectAtIndex:index];
                [page setObject:obj];
                [page loadData];
            }
            [page viewWillAppear:NO];
            [page viewDidAppear:NO];
            [_visiblePages addObject:page];

//            [self didShowPage:page];

            [self hideArrowButton:NO];
        }

    }

}

- (UIViewController <TBHorizontalSlideViewCTLDelegate> *)dequeueRecycledPage {
    UIViewController <TBHorizontalSlideViewCTLDelegate> *page = [_recycledPages anyObject];

    if (page) {
        [_recycledPages removeObject:page];
    }

    return page;
}

- (UIViewController <TBHorizontalSlideViewCTLDelegate> *) getDisplayingPageForIndex:(NSUInteger)index {
    
    UIViewController <TBHorizontalSlideViewCTLDelegate> *page = nil;
    
    for (page in _visiblePages) {
        if (page.index == index) { 
            break;
        }
    }
    
    return page;
    
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {

    BOOL foundPage = NO;

    for (UIViewController <TBHorizontalSlideViewCTLDelegate> *page in _visiblePages) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }

    return foundPage;

}

- (void)configurePage:(UIViewController <TBHorizontalSlideViewCTLDelegate> *)page forIndex:(NSUInteger)index {
    [page setIndex:index];
    page.view.frame = [self frameForPageAtIndex:index];
    _selectedPage = index;
}

#pragma mark -

#pragma mark ScrollView delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self hideArrowButton:YES];
    _leftArrowButton.hidden = YES;
    _rightArrowButton.hidden = YES;
    [self tilePages];
}

- (void)callBack {
    [self hideArrowButton:YES];
    NSArray *arr = self.visibleViews;
    NSUInteger count = [arr count];
    if (count < 1) {
        return;
    }
    count = self.items.count;
    UIViewController <TBHorizontalSlideViewCTLDelegate> *page = [arr objectAtIndex:0];
    _selectedPage = page.index;
    if (count < 1 || count == 1) {
        _leftArrowButton.hidden = YES;
        _rightArrowButton.hidden = YES;
    } else {
        NSInteger temp = count - 1;
        if (_selectedPage == 0) {
            _leftArrowButton.hidden = YES;
            _rightArrowButton.hidden = NO;
        } else if (_selectedPage > 0 && _selectedPage < temp) {
            _leftArrowButton.hidden = NO;
            _rightArrowButton.hidden = NO;
        } else {
            _leftArrowButton.hidden = NO;
            _rightArrowButton.hidden = YES;
        }
    }

    [self didShowPage:page];
//    if (_items) {
//        NSObject *obj = [_items objectAtIndex:page.index];
//        [page setObject:obj];
//        [page loadData];
//    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self callBack];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self callBack];
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
    CGRect frame = self.view.frame;
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);

    return frame;

}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {

    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in

    // landscape orientation, the frame will still be in portrait because the _pagingScrollView is the root view controller's

    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape

    // because it has a rotation transform applied.

    CGRect bounds = _pagingScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;

    return pageFrame;
}

- (CGSize)contentSizeForPagingScrollView {

    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = _pagingScrollView.bounds;
    return CGSizeMake(bounds.size.width * [_items count], bounds.size.height);
}

@end