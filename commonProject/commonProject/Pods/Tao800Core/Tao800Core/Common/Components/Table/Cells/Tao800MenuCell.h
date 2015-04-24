//
//  Tao800MenuCell.h
//  tao800
//
//  Created by enfeng on 14-3-3.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BaseCell.h"

@class Tao800MenuCell;

///----------------
/// @name Delegate
///----------------

/**
 The delegate of a `TLSwipeForOptionsCell` object must adopt the `TLSwipeForOptionsCellDelegate` protocol.
 */
@protocol Tao800MenuCellDelegate <NSObject>

- (void)cell:(Tao800MenuCell *)cell didShowMenu:(BOOL)isShowingMenu;

- (void)cellDidSelectFavorite:(Tao800MenuCell *)cell;

- (void)cellDidSelect:(Tao800MenuCell *)cell;


@end

@interface Tao800MenuCell : Tao800BaseCell 
///------------------
/// @name Properties
///------------------

/**
 The object that acts as the delegate of the receiving cell.
 
 @discussion The delegate must adopt the `TLSwipeForOptionsCellDelegate` protocol.
 */
@property(nonatomic, weak) id <Tao800MenuCellDelegate> delegate;

@property(nonatomic, weak) UIButton *menuButton1;


- (void)hideMenuOptions;

/**
 *
 *  设置按钮样式 
 */
- (void) resetMenuButton;
@end