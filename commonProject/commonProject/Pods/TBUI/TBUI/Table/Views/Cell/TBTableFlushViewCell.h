//
// Created by enfeng on 13-1-24.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TBTableViewBaseCell.h"

@class TBTableViewItem;

@interface TBTableFlushViewCell : TBTableViewBaseCell {
    TBTableViewItem*  _item;
    UIView*           _view;
}

@property (nonatomic, readonly, strong) TBTableViewItem*  item;
@property (nonatomic, readonly, strong) UIView*           view;

@end
