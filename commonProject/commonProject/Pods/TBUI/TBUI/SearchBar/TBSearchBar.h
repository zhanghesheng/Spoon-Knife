//
//  TBSeachBar.h
//  CustomSearchBarDemo
//
//  Created by enfeng on 13-12-15.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TBSearchBar;

@protocol TBSearchBarDelegate <NSObject>
@optional
- (BOOL)tbSearchBarShouldBeginEditing:(TBSearchBar *)searchBar;                      // return NO to not become first responder
- (void)tbSearchBarTextDidBeginEditing:(TBSearchBar *)searchBar;                     // called when text starts editing
- (BOOL)tbSearchBarShouldEndEditing:(TBSearchBar *)searchBar;                        // return NO to not resign first responder
- (void)tbSearchBarTextDidEndEditing:(TBSearchBar *)searchBar;                       // called when text ends editing
- (void)tbSearchBar:(TBSearchBar *)searchBar textDidChange:(NSString *)searchText;   // called when text changes (including clear)
- (BOOL)tbSearchBar:(TBSearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

- (void)tbSearchBarSearchButtonClicked:(TBSearchBar *)searchBar;                     // called when keyboard search button pressed
- (void)tbSearchBarLeftViewButtonClicked:(TBSearchBar *)searchBar;
- (void)tbSearchBarCancelButtonClicked:(TBSearchBar *) searchBar;                    // called when cancel button pressed

- (void)tbResetSubViewSizeByFlag:(BOOL)flag;

@end

@interface TBSearchBar : UIView<UITextFieldDelegate>

@property (nonatomic, weak) UITextField *searchTextField;
@property (nonatomic, weak) UIButton *cancelButton;
@property (nonatomic, weak) id<TBSearchBarDelegate> delegate;
@property (nonatomic, weak) id<TBSearchBarDelegate> searchDisplayDelegate;  //用于
@property (nonatomic) BOOL needShowCancelButton;

@property (nonatomic) CGFloat horizontalPadding;
@property (nonatomic) CGFloat verticalPadding;
@property (nonatomic) CGFloat cancelButtonWidth;

@property (nonatomic) BOOL pNeedLayoutSubviews;

- (void)layoutCancelButton;
- (void)layoutCancelButton:(BOOL) animated;
- (void)cancelAction;
@end
