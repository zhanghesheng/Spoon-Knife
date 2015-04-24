//
//  TBHPagePaddingScrollView.h
//  HGPageDeckSample
//
//  Created by Rotem Rubnov on 25/10/2010.
//	Copyright (C) 2010 100 grams software
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

#import <UIKit/UIKit.h>
#import "TBPaddingPageView.h"

@class TBHPagePaddingScrollView;

// ------------------------------------------------------------------------------------------------------------------------------------------------------
// this protocol represents the data source for HGPageScrollerView. 
@protocol TBHPagePaddingScrollViewDataSource <NSObject>
@required
// Page display. Implementers should *always* try to reuse pageViews by setting each page's reuseIdentifier. 
// This mechanism works the same as in UITableViewCells.  
- (TBPaddingPageView *)pageScrollView:(TBHPagePaddingScrollView *)scrollView viewForPageAtIndex:(NSInteger)index;

@optional

- (NSInteger)numberOfPagesInScrollView:(TBHPagePaddingScrollView *)scrollView;   // Default is 1 if not implemented

@end


// ------------------------------------------------------------------------------------------------------------------------------------------------------
// this represents the display and behaviour of the TBHPagePaddingScrollView and its subviews.
@protocol TBHPagePaddingScrollViewDelegate <NSObject, UIScrollViewDelegate>

@optional

// Dragging
- (void)pageScrollViewWillBeginDragging:(TBHPagePaddingScrollView *)scrollView;

- (void)pageScrollViewDidEndDragging:(TBHPagePaddingScrollView *)scrollView willDecelerate:(BOOL)decelerate;

// Decelaration
- (void)pageScrollViewWillBeginDecelerating:(TBHPagePaddingScrollView *)scrollView;

- (void)pageScrollViewDidEndDecelerating:(TBHPagePaddingScrollView *)scrollView;

// Called before the page scrolls into the center of the view.
- (void)pageScrollView:(TBHPagePaddingScrollView *)scrollView willScrollToPage:(TBPaddingPageView *)page atIndex:(NSInteger)index;

// Called after the page scrolls into the center of the view.
- (void)pageScrollView:(TBHPagePaddingScrollView *)scrollView didScrollToPage:(TBPaddingPageView *)page atIndex:(NSInteger)index;

// Called after the user changes the selection.
- (void)pageScrollView:(TBHPagePaddingScrollView *)scrollView didSelectPageAtIndex:(NSInteger)index;


@end


// ------------------------------------------------------------------------------------------------------------------------------------------------------

@class HGTouchView;

@interface TBHPagePaddingScrollView : UIView <UIScrollViewDelegate, UIGestureRecognizerDelegate> {

@private
 

    UIScrollView *_scrollView;
    HGTouchView *_scrollViewTouch;

    NSInteger _numberOfPages;
    NSRange _visibleIndexes;
    NSMutableArray *_visiblePages;
    NSMutableArray *_deletedPages;
    NSMutableDictionary *_reusablePages;

    TBPaddingPageView *_selectedPage;

    BOOL _isPendingScrolledPageUpdateNotification;

    CGFloat _pagePadding;
    CGFloat _viewportWidth; //视图显示的宽度(不包括padding)
}


@property(nonatomic, weak) id <TBHPagePaddingScrollViewDataSource> dataSource;
@property(nonatomic, weak) id <TBHPagePaddingScrollViewDelegate> delegate;

- (id) initWithFrame:(CGRect)frame padePadding:(CGFloat) pagePadding viewportWidth:(CGFloat)viewportWidth;

- (NSInteger)numberOfPages;

- (TBPaddingPageView *)pageAtIndex:(NSInteger)index;            // returns nil if page is not visible or the index is out of range


// Selection

- (NSInteger)indexForSelectedPage;   // returns the index of the currently selected page.
- (NSInteger)indexForVisiblePage :(TBPaddingPageView *)page;   // returns the index of a page in the visible range

// Selects and deselects rows. These methods will not call the delegate methods (-pageScrollView:willSelectPageAtIndex: or pageScrollView:didSelectPageAtIndex:)
- (void)scrollToPageAtIndex  :(NSInteger)index animated :(BOOL)animated;

- (void)selectPageAtIndex    :(NSInteger)index animated :(BOOL)animated;


// Appearance

- (TBPaddingPageView *)dequeueReusablePageWithIdentifier:(NSString *)identifier;  // Used by the delegate to acquire an already allocated page, instead of allocating a new one

// Data
- (void)reloadData;



// Page insertion/deletion/reloading.

// insert on or more pages into the page scroller. 
// This method invokes TBHPagePaddingScrollViewDataSource method numberOfPagesInScrollView:. Specifically, it expects the new number of pages to be equal to the previous number of pages plus the number of inserted pages. If this is not the case an exception is thrown.
// Insertions are animated only if animated is set to YES and the insertion is into the visible page range.  
- (void)insertPagesAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated;


- (void)reloadPagesAtIndexes:(NSIndexSet *)indexes;


@end
