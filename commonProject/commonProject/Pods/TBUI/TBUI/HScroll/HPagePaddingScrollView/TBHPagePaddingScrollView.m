//
//  TBHPagePaddingScrollView.m
//  HGPageDeckSample
//
//  Created by Rotem Rubnov on 25/10/2010.
//  Copyright (C) 2010 100 grams software. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//


#import "TBHPagePaddingScrollView.h"
#import <QuartzCore/QuartzCore.h>


// -----------------------------------------------------------------------------------------------------------------------------------
//Internal view class, used by to TBHPagePaddingScrollView.
#pragma mark HGTouchView

@interface HGTouchView : UIView {
}
@property(nonatomic, strong) UIView *receiver;
@end


@implementation HGTouchView

@synthesize receiver;

- (void)dealloc {
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        return self.receiver; 
    }
    return nil;
}

@end




// -----------------------------------------------------------------------------------------------------------------------------------
#pragma mark - TBHPagePaddingScrollView private methods & properties

typedef enum {
    HGPageScrollViewUpdateMethodInsert,
    HGPageScrollViewUpdateMethodDelete,
    HGPageScrollViewUpdateMethodReload
} HGPageScrollViewUpdateMethod;


@interface TBHPagePaddingScrollView ()

// insertion/deletion/update of pages
- (TBPaddingPageView *)loadPageAtIndex:(NSInteger)index insertIntoVisibleIndex:(NSInteger)visibleIndex;

- (void)addPageToScrollView :(TBPaddingPageView *)page atIndex :(NSInteger)index;

- (void)insertPageInScrollView:(TBPaddingPageView *)page atIndex:(NSInteger)index animated:(BOOL)animated;

- (void)setFrameForPage:(UIView *)page atIndex:(NSInteger)index;

- (void)shiftPage :(UIView *)page withOffset :(CGFloat)offset;

- (void)setNumberOfPages :(NSInteger)number;

- (void)updateScrolledPage :(TBPaddingPageView *)page index :(NSInteger)index;

- (void)prepareForDataUpdate :(HGPageScrollViewUpdateMethod)method withIndexSet :(NSIndexSet *)set;

// managing selection and scrolling
- (void)updateVisiblePages;

- (void)setAlphaForPage :(UIView *)page;

- (void)setOpacity:(CGFloat)alpha forObstructionLayerOfPage:(TBPaddingPageView *)page;


@property(nonatomic, strong) NSIndexSet *indexesBeforeVisibleRange;
@property(nonatomic, strong) NSIndexSet *indexesWithinVisibleRange;
@property(nonatomic, strong) NSIndexSet *indexesAfterVisibleRange;

@end



// -----------------------------------------------------------------------------------------------------------------------------------
#pragma mark - TBHPagePaddingScrollView exception constants

#define kExceptionNameInvalidUpdate   @"HGPageScrollView DeletePagesAtIndexes Invalid Update"
#define kExceptionReasonInvalidUpdate @"The number of pages contained HGPageScrollView after the update (%d) must be equal to the number of pages contained in it before the update (%d), plus or minus the number of pages added or removed from it (%d added, %d removed)."



// -----------------------------------------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark - TBHPagePaddingScrollView implementation

@implementation TBHPagePaddingScrollView


@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

@synthesize indexesBeforeVisibleRange;
@synthesize indexesWithinVisibleRange;
@synthesize indexesAfterVisibleRange;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (_viewportWidth < 1) {
            _viewportWidth = 262;
            _pagePadding = 14;
        }

        CGFloat x = (self.frame.size.width - _viewportWidth) / 2;

        self.backgroundColor = [UIColor lightGrayColor];
        CGRect rect = CGRectMake(x, 0, _viewportWidth, self.frame.size.height);
        _scrollView = [[UIScrollView alloc] initWithFrame:rect];
//        _scrollView.backgroundColor = [UIColor purpleColor];
        [self addSubview:_scrollView];

        // set tap gesture recognizer for page selection
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureFrom:)];
        [_scrollView addGestureRecognizer:recognizer];
        recognizer.delegate = self;

        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = NO;
        _scrollView.decelerationRate = 1.0;//UIScrollViewDecelerationRateNormal;
        _scrollView.delaysContentTouches = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollViewTouch = [[HGTouchView alloc] initWithFrame:self.frame];
        [self addSubview:_scrollViewTouch];
        _scrollViewTouch.receiver = _scrollView;

        // default number of pages
        _numberOfPages = 1;

        // set initial visible indexes (page 0)
        _visibleIndexes.location = 0;
        _visibleIndexes.length = 1;

        _visiblePages = [[NSMutableArray alloc] initWithCapacity:9];
        _deletedPages = [[NSMutableArray alloc] initWithCapacity:0];
        _reusablePages = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    return self;
}

- (void)dealloc {

}


#pragma mark -
#pragma mark View Management

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _scrollView.contentSize = CGSizeMake(_numberOfPages * _scrollView.bounds.size.width, _scrollView.bounds.size.height);
}


#pragma mark -
#pragma mark Info


- (id)initWithFrame:(CGRect)frame padePadding:(CGFloat)pagePadding viewportWidth:(CGFloat)viewportWidth {
    _pagePadding = pagePadding;
    _viewportWidth = viewportWidth;
    self = [self initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (NSInteger)numberOfPages; {
    return _numberOfPages;
}


- (TBPaddingPageView *)pageAtIndex:(NSInteger)index;            // returns nil if page is not visible or the index is out of range
{
    if (index == NSNotFound || index < _visibleIndexes.location || index > _visibleIndexes.location + _visibleIndexes.length - 1) {
        return nil;
    }
    return [_visiblePages objectAtIndex:index - _visibleIndexes.location];
}



#pragma mark -
#pragma mark Page Selection


- (NSInteger)indexForSelectedPage; {
    return [self indexForVisiblePage :_selectedPage];
}

- (NSInteger)indexForVisiblePage :(TBPaddingPageView *)page; {
    NSInteger index = [_visiblePages indexOfObject:page];
    if (index != NSNotFound) {
        return _visibleIndexes.location + index;
    }
    return NSNotFound;
}


- (void)scrollToPageAtIndex :(NSInteger)index animated :(BOOL)animated; {
    CGPoint offset = CGPointMake(index * _scrollView.frame.size.width, 0);
    [_scrollView setContentOffset:offset animated:animated];
}


- (void)selectPageAtIndex :(NSInteger)index animated :(BOOL)animated; {
    // ignore if there are no pages or index is invalid
    if (index == NSNotFound || _numberOfPages == 0) {
        return;
    }

    if (index != [self indexForSelectedPage]) {

        // rebuild _visibleIndexes
        BOOL isLastPage = (index == _numberOfPages - 1);
        BOOL isFirstPage = (index == 0);
        NSInteger selectedVisibleIndex;
        if (_numberOfPages == 1) {
            _visibleIndexes.location = index;
            _visibleIndexes.length = 1;
            selectedVisibleIndex = 0;
        }
        else if (isLastPage) {
            _visibleIndexes.location = index - 1;
            _visibleIndexes.length = 2;
            selectedVisibleIndex = 1;
        }
        else if (isFirstPage) {
            _visibleIndexes.location = index;
            _visibleIndexes.length = 2;
            selectedVisibleIndex = 0;
        }
        else {
            _visibleIndexes.location = index - 1;
            _visibleIndexes.length = 3;
            selectedVisibleIndex = 1;
        }

        // update the scrollView content offset
        _scrollView.contentOffset = CGPointMake(index * _scrollView.frame.size.width, 0);

        // reload the data for the new indexes
        [self reloadData];

        // update _selectedPage
        _selectedPage = [_visiblePages objectAtIndex:selectedVisibleIndex];

        // update the page selector (pageControl)

    }

    NSInteger selectedIndex = [self indexForSelectedPage];
    if ([self.delegate respondsToSelector:@selector(pageScrollView:didSelectPageAtIndex:)]) {
        [self.delegate pageScrollView:self didSelectPageAtIndex:selectedIndex];
    }
}

#pragma mark -
#pragma mark PageScroller Data



- (void)reloadData; {
    NSInteger numPages = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfPagesInScrollView:)]) {
        numPages = [self.dataSource numberOfPagesInScrollView:self];
    }

    NSInteger selectedIndex = _selectedPage ? [_visiblePages indexOfObject:_selectedPage] : NSNotFound;

    // reset visible pages array
    [_visiblePages removeAllObjects];
    // remove all subviews from scrollView
    [[_scrollView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];

    [self setNumberOfPages:numPages];

    if (_numberOfPages > 0) {

        // reload visible pages
        for (int index = 0; index < _visibleIndexes.length; index++) {
            TBPaddingPageView *page = [self loadPageAtIndex:_visibleIndexes.location + index insertIntoVisibleIndex:index];
            [self addPageToScrollView:page atIndex:_visibleIndexes.location + index];
        }

        // this will load any additional views which become visible
        [self updateVisiblePages];

        // set initial alpha values for all visible pages
        [_visiblePages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self setAlphaForPage :obj];
        }];

        if (selectedIndex == NSNotFound) {
            // if no page is selected, select the first page
            _selectedPage = [_visiblePages objectAtIndex:0];
        }
        else {
            // refresh the page at the selected index (it might have changed after reloading the visible pages) 
            _selectedPage = [_visiblePages objectAtIndex:selectedIndex];
        }

        // update deck title and subtitle for selected page
//        NSInteger index = [self indexForSelectedPage];
    }

}


- (TBPaddingPageView *)loadPageAtIndex :(NSInteger)index insertIntoVisibleIndex :(NSInteger)visibleIndex {
    TBPaddingPageView *visiblePage = [self.dataSource pageScrollView:self viewForPageAtIndex:index];
//CGRect rect =    visiblePage.frame;
//    rect.size = CGSizeMake(222, 460);
//    visiblePage.frame = rect;

    if (visiblePage.reuseIdentifier) {
        NSMutableArray *reusables = [_reusablePages objectForKey:visiblePage.reuseIdentifier];
        if (!reusables) {
            reusables = [[NSMutableArray alloc] initWithCapacity :4];
        }
        if (![reusables containsObject:visiblePage]) {
            [reusables addObject:visiblePage];
        }
        [_reusablePages setObject:reusables forKey:visiblePage.reuseIdentifier];
    }

    // add the page to the visible pages array
    [_visiblePages insertObject:visiblePage atIndex:visibleIndex];

    return visiblePage;
}


// add a page to the scroll view at a given index. No adjustments are made to existing pages offsets. 
- (void)addPageToScrollView :(TBPaddingPageView *)page atIndex :(NSInteger)index {

    // configure the page frame
    [self setFrameForPage :page atIndex:index];

    if (!page.maskLayer) {
        [self setLayerPropertiesForPage:page];
    }

    // add the page to the scroller
    [_scrollView insertSubview:page atIndex:0];

}


- (void)setLayerPropertiesForPage:(TBPaddingPageView *)page {
    // add shadow (use shadowPath to improve rendering performance)
    page.layer.shadowColor = [[UIColor blackColor] CGColor];
    page.layer.shadowOffset = CGSizeMake(3.0f, 8.0f);
    page.layer.shadowOpacity = 0.3f;
    page.layer.shadowRadius = 7.0;
    page.layer.masksToBounds = NO;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:page.bounds];
    page.layer.shadowPath = path.CGPath;

    CALayer *layer1 = [[CALayer alloc] init];
    page.maskLayer = layer1;
//    CGSize size = page.identityFrame.size; //todo
    CGSize size = page.frame.size;
    // FIXME: Magic Numbers :S
    page.maskLayer.frame = CGRectMake(0, 0, size.width, size.height); //CGRectMake(64., 92., size.width, size.height);
//    size = page.layer.bounds.size;
//    page.maskLayer.bounds = CGRectMake(0., 0., size.width, size.height);
    page.maskLayer.backgroundColor = [[UIColor blackColor] CGColor];
    page.maskLayer.opaque = NO;
    page.maskLayer.opacity = 0.0f;
    [page.layer addSublayer:layer1];
}


// inserts a page to the scroll view at a given offset by pushing existing pages forward.
- (void)insertPageInScrollView :(TBPaddingPageView *)page atIndex :(NSInteger)index animated :(BOOL)animated {
    //hide the new page before inserting it
    //page.alpha = 0.0; 

    // add the new page at the correct offset
    [self addPageToScrollView:page atIndex:index];

    // shift pages at or after the new page offset forward
    [[_scrollView subviews] enumerateObjectsUsingBlock:^(id existingPage, NSUInteger idx, BOOL *stop) {

        if (existingPage != page && page.frame.origin.x <= ((UIView *) existingPage).frame.origin.x) {

            if (animated) {
                [UIView animateWithDuration:0.4 animations:^(void) {
                    [self shiftPage :existingPage withOffset:_scrollView.frame.size.width];
                }];
            }
            else {
                [self shiftPage :existingPage withOffset:_scrollView.frame.size.width];
            }
        }
    }];

    if (animated) {
        [UIView animateWithDuration:0.4 animations:^(void) {
            [self setAlphaForPage:page];
        }];
    }
    else {
        [self setAlphaForPage:page];
    }


}

- (void)setFrameForPage :(UIView *)page atIndex :(NSInteger)index; {
    CGRect rect = page.frame;
    rect.size = _scrollView.frame.size;
    rect.size.width = _scrollView.frame.size.width - _pagePadding;
    page.frame = rect;

    CGFloat contentOffset = index * _scrollView.frame.size.width;
//    CGFloat margin = (_scrollView.frame.size.width - page.frame.size.width) / 2;
    CGRect frame = page.frame;
//    frame.origin.x = contentOffset + margin;
    frame.origin.x = contentOffset + _pagePadding / 2;
    frame.origin.y = 0.0;

    page.frame = frame;

}


- (void)shiftPage :(UIView *)page withOffset :(CGFloat)offset {
    CGRect frame = page.frame;
    frame.origin.x += offset;
    page.frame = frame;

    // also refresh the alpha of the shifted page
    [self setAlphaForPage :page];

}



#pragma mark - insertion/deletion/reloading

- (void)prepareForDataUpdate :(HGPageScrollViewUpdateMethod)method withIndexSet :(NSIndexSet *)indexes {

    // check number of pages
    if ([self.dataSource respondsToSelector:@selector(numberOfPagesInScrollView:)]) {

        NSInteger newNumberOfPages = [self.dataSource numberOfPagesInScrollView:self];

        NSInteger expectedNumberOfPages;
        NSString *reason = nil;
        switch (method) {
            case HGPageScrollViewUpdateMethodDelete:
                expectedNumberOfPages = _numberOfPages - [indexes count];
                reason = [NSString stringWithFormat:kExceptionReasonInvalidUpdate, (int)newNumberOfPages, (int) _numberOfPages, 0, (int)[indexes count]];
                break;
            case HGPageScrollViewUpdateMethodInsert:
                expectedNumberOfPages = _numberOfPages + [indexes count];
                reason = [NSString stringWithFormat:kExceptionReasonInvalidUpdate, (int)newNumberOfPages, (int)_numberOfPages, (int)[indexes count], 0];
                break;
            case HGPageScrollViewUpdateMethodReload:
                reason = [NSString stringWithFormat:kExceptionReasonInvalidUpdate, (int)newNumberOfPages, (int)_numberOfPages, 0, 0];
            default:
                expectedNumberOfPages = _numberOfPages;
                break;
        }

        if (newNumberOfPages != expectedNumberOfPages) {
            NSException *exception = [NSException exceptionWithName:kExceptionNameInvalidUpdate reason:reason userInfo:nil];
            [exception raise];
        }
    }

    // separate the indexes into 3 sets:
    self.indexesBeforeVisibleRange = nil;
    self.indexesBeforeVisibleRange = [indexes indexesPassingTest:^BOOL(NSUInteger idx, BOOL *stop) {
        return (idx < _visibleIndexes.location);
    }];
    self.indexesWithinVisibleRange = nil;
    self.indexesWithinVisibleRange = [indexes indexesPassingTest:^BOOL(NSUInteger idx, BOOL *stop) {
        return (idx >= _visibleIndexes.location &&
                (_visibleIndexes.length > 0 ? idx < _visibleIndexes.location + _visibleIndexes.length : YES));
    }];

    self.indexesAfterVisibleRange = nil;
    self.indexesAfterVisibleRange = [indexes indexesPassingTest:^BOOL(NSUInteger idx, BOOL *stop) {
        return ((_visibleIndexes.length > 0 ? idx >= _visibleIndexes.location + _visibleIndexes.length : NO));
    }];

}


- (void)insertPagesAtIndexes:(NSIndexSet *)indexes animated :(BOOL)animated; {

    [self prepareForDataUpdate :HGPageScrollViewUpdateMethodInsert withIndexSet:indexes];

    // handle insertion of pages before the visible range. Shift pages forward.
    if ([self.indexesBeforeVisibleRange count] > 0) {
        [self setNumberOfPages :_numberOfPages + [self.indexesBeforeVisibleRange count]];
        [[_scrollView subviews] enumerateObjectsUsingBlock:^(id page, NSUInteger idx, BOOL *stop) {
            [self shiftPage:page withOffset:[self.indexesBeforeVisibleRange count] * _scrollView.frame.size.width];
        }];

        _visibleIndexes.location += [self.indexesBeforeVisibleRange count];

        // update scrollView contentOffset
        CGPoint contentOffset = _scrollView.contentOffset;
        contentOffset.x += [self.indexesBeforeVisibleRange count] * _scrollView.frame.size.width;
        _scrollView.contentOffset = contentOffset;

        // refresh the page control
//        [_pageSelector setCurrentPage:[self indexForSelectedPage]];

    }

    // handle insertion of pages within the visible range. 
    NSInteger selectedPageIndex = (_numberOfPages > 0) ? [self indexForSelectedPage] : 0;
    [self setNumberOfPages:_numberOfPages + [self.indexesWithinVisibleRange count]];
    [self.indexesWithinVisibleRange enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {

        TBPaddingPageView *page = [self loadPageAtIndex:idx insertIntoVisibleIndex:idx - _visibleIndexes.location];
        [self insertPageInScrollView:page atIndex:idx animated:animated];
        _visibleIndexes.length++;
        if (_visibleIndexes.length > 3) {

            TBPaddingPageView *page2 = [_visiblePages lastObject];
            [page2 removeFromSuperview];
            [_visiblePages removeObject:page2];

            _visibleIndexes.length--;
        }

    }];

    // update selected page if necessary
    if ([self.indexesWithinVisibleRange containsIndex:selectedPageIndex]) {
        [self updateScrolledPage:[_visiblePages objectAtIndex:(selectedPageIndex - _visibleIndexes.location)] index:selectedPageIndex];
    }

    // handle insertion of pages after the visible range
    if ([self.indexesAfterVisibleRange count] > 0) {
        [self setNumberOfPages:_numberOfPages + [self.indexesAfterVisibleRange count]];
    }


}

- (void)reloadPagesAtIndexes:(NSIndexSet *)indexes; {
    [self prepareForDataUpdate :HGPageScrollViewUpdateMethodReload withIndexSet:indexes];

    // only reload pages within the visible range
    [self.indexesWithinVisibleRange enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        TBPaddingPageView *page = [self pageAtIndex:idx];
        [_visiblePages removeObject :page]; // remove from visiblePages
        [page removeFromSuperview];          // remove from scrollView

        page = [self loadPageAtIndex:idx insertIntoVisibleIndex:idx - _visibleIndexes.location];
        [self addPageToScrollView:page atIndex:idx];
    }];
}


- (void)setNumberOfPages :(NSInteger)number {
    _numberOfPages = number;
    _scrollView.contentSize = CGSizeMake(_numberOfPages * _scrollView.bounds.size.width, _scrollView.bounds.size.height);
//    _pageSelector.numberOfPages = _numberOfPages;

}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(pageScrollViewWillBeginDragging:)]) {
        [self.delegate pageScrollViewWillBeginDragging:self];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.delegate respondsToSelector:@selector(pageScrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate pageScrollViewDidEndDragging:self willDecelerate:decelerate];
    }

    if (_isPendingScrolledPageUpdateNotification) {
        if ([self.delegate respondsToSelector:@selector(pageScrollView:didScrollToPage:atIndex:)]) {
            NSInteger selectedIndex = [_visiblePages indexOfObject:_selectedPage];
            [self.delegate pageScrollView:self didScrollToPage:_selectedPage atIndex:selectedIndex];
        }
        _isPendingScrolledPageUpdateNotification = NO;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(pageScrollViewWillBeginDecelerating:)]) {
        [self.delegate pageScrollViewWillBeginDecelerating:self];
    }

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(pageScrollViewDidEndDecelerating:)]) {
        [self.delegate pageScrollViewDidEndDecelerating:self];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // update the visible pages
    [self updateVisiblePages];

    // adjust alpha for all visible pages
    [_visiblePages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self setAlphaForPage :obj];
    }];


    CGFloat delta = scrollView.contentOffset.x - _selectedPage.frame.origin.x;
    BOOL toggleNextItem = (fabs(delta) > scrollView.frame.size.width / 2);
    if (toggleNextItem && [_visiblePages count] > 1) {

        NSInteger selectedIndex = [_visiblePages indexOfObject:_selectedPage];
        BOOL neighborExists = ((delta < 0 && selectedIndex > 0) || (delta > 0 && selectedIndex < [_visiblePages count] - 1));

        if (neighborExists) {

            NSInteger neighborPageVisibleIndex = [_visiblePages indexOfObject:_selectedPage] + (delta > 0 ? 1 : -1);
            TBPaddingPageView *neighborPage = [_visiblePages objectAtIndex:neighborPageVisibleIndex];
            NSInteger neighborIndex = _visibleIndexes.location + neighborPageVisibleIndex;

            [self updateScrolledPage:neighborPage index:neighborIndex];

        }

    }

}


- (void)updateScrolledPage :(TBPaddingPageView *)page index :(NSInteger)index {
    if (!page) {
        //todo
        _selectedPage = nil;
    }
    else {
        // notify delegate
        if ([self.delegate respondsToSelector:@selector(pageScrollView:willScrollToPage:atIndex:)]) {
            [self.delegate pageScrollView:self willScrollToPage:page atIndex:index];
        }

        // update title and subtitle
        //todo

        // set the page selector (page control)
        //todo
//        [_pageSelector setCurrentPage:index];

        // set selected page
        _selectedPage = page;
        //	NSLog(@"selectedPage: 0x%x (index %d)", page, index );

        if (_scrollView.dragging) {
            _isPendingScrolledPageUpdateNotification = YES;
        }
        else {
            // notify delegate again
            if ([self.delegate respondsToSelector:@selector(pageScrollView:didScrollToPage:atIndex:)]) {
                [self.delegate pageScrollView:self didScrollToPage:page atIndex:index];
            }
            _isPendingScrolledPageUpdateNotification = NO;
        }
    }

}


- (void)updateVisiblePages {
    CGFloat pageWidth = _scrollView.frame.size.width;

    //get x origin of left- and right-most pages in _scrollView's superview coordinate space (i.e. self)
    CGFloat leftViewOriginX = _scrollView.frame.origin.x - _scrollView.contentOffset.x + (_visibleIndexes.location * pageWidth);
    CGFloat rightViewOriginX = _scrollView.frame.origin.x - _scrollView.contentOffset.x + (_visibleIndexes.location + _visibleIndexes.length - 1) * pageWidth;

    if (leftViewOriginX > 0) {
        //new page is entering the visible range from the left
        if (_visibleIndexes.location > 0) { //is it not the first page?
            _visibleIndexes.length += 1;
            _visibleIndexes.location -= 1;
            TBPaddingPageView *page = [self loadPageAtIndex:_visibleIndexes.location insertIntoVisibleIndex:0];
            // add the page to the scroll view (to make it actually visible)
            [self addPageToScrollView:page atIndex:_visibleIndexes.location];

        }
    }
    else if (leftViewOriginX < -pageWidth) {
        //left page is exiting the visible range
        UIView *page = [_visiblePages objectAtIndex:0];
        [_visiblePages removeObject:page];
        [page removeFromSuperview]; //remove from the scroll view
        _visibleIndexes.location += 1;
        _visibleIndexes.length -= 1;
    }
    if (rightViewOriginX > self.frame.size.width) {
        //right page is exiting the visible range
        UIView *page = [_visiblePages lastObject];
        [_visiblePages removeObject:page];
        [page removeFromSuperview]; //remove from the scroll view
        _visibleIndexes.length -= 1;
    }
    else if (rightViewOriginX + pageWidth < self.frame.size.width) {
        //new page is entering the visible range from the right
        if (_visibleIndexes.location + _visibleIndexes.length < _numberOfPages) { //is is not the last page?
            _visibleIndexes.length += 1;
            NSInteger index = _visibleIndexes.location + _visibleIndexes.length - 1;
            TBPaddingPageView *page = [self loadPageAtIndex:index insertIntoVisibleIndex:_visibleIndexes.length - 1];
            [self addPageToScrollView:page atIndex:index];

        }
    }
}


- (void)setAlphaForPage :(UIView *)page {
    CGFloat delta = _scrollView.contentOffset.x - page.frame.origin.x;
    CGFloat step = self.frame.size.width;
    CGFloat alpha = fabs(delta / step) * 2. / 5.;
    if (alpha > 0.2) alpha = 0.2;
    if (alpha < 0.05) alpha = 0.;

    if ([page isKindOfClass:[TBPaddingPageView class]]) {
        [self setOpacity:alpha forObstructionLayerOfPage:(TBPaddingPageView *) page];
    }
    else {
        alpha = 1.0 - fabs(delta / step);
        if (alpha > 0.) alpha = 1.0;
        page.alpha = alpha;
    }
}

- (void)setOpacity:(CGFloat)alpha forObstructionLayerOfPage:(TBPaddingPageView *)page {
    [page.maskLayer setOpacity:alpha];
}


- (TBPaddingPageView *)dequeueReusablePageWithIdentifier:(NSString *)identifier;  // Used by the delegate to acquire an already allocated page, instead of allocating a new one
{
    TBPaddingPageView *reusablePage = nil;
    NSArray *reusables = [_reusablePages objectForKey:identifier];
    if (reusables) {
        NSEnumerator *enumerator = [reusables objectEnumerator];
        while ((reusablePage = [enumerator nextObject])) {
            if (![_visiblePages containsObject:reusablePage]) {
                [reusablePage prepareForReuse];
                break;
            }
        }
    }
    return reusablePage;
}


#pragma mark -
#pragma mark Handling Touches


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (!_scrollView.decelerating && !_scrollView.dragging) {
        return YES;
    }
    return NO;
}


- (void)handleTapGestureFrom:(UITapGestureRecognizer *)recognizer {
    if (!_selectedPage)
        return;

    NSInteger selectedIndex = [self indexForSelectedPage];

    [self selectPageAtIndex:selectedIndex animated:YES];

}

@end
