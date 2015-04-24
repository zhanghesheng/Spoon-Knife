//
// Created by enfeng on 13-4-15.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TBUI/TBUI.h"


@interface Tao800BorderCellBackgroundView : TBUICellBackgroundView {
    //YES， 画虚线
    BOOL _needDrawDash;
    BOOL _hideBottomLine;
    CGFloat _hPadding;

    BOOL _needDrawBottomLine;
}
@property(nonatomic) BOOL needDrawDash;
@property(nonatomic) BOOL hideBottomLine;
@property(nonatomic) CGFloat hPadding;
@property(nonatomic) BOOL needDrawBottomLine;


@end