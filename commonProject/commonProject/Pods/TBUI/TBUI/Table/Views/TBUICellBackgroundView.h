//
//  TBUICellBackgroundView.h
//  TBUI
//
//  Created by enfeng on 12-12-6.
//  Copyright (c) 2012年 com.tuan800.framework.ui. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    TBCellBackgroundViewPositionNothing = 0, //不做绘制
    TBCellBackgroundViewPositionSingle,
    TBCellBackgroundViewPositionTop,
    TBCellBackgroundViewPositionBottom,
    TBCellBackgroundViewPositionMiddle
} TBCellBackgroundViewPosition;

@interface TBUICellBackgroundView : UIView {
    TBCellBackgroundViewPosition _position;
    UIColor *_lineColor;
    UIColor *_bgRGBAColor;
    CGFloat _radius;
    CGFloat _lineWidth;
}

@property(nonatomic) TBCellBackgroundViewPosition position;
@property(nonatomic) CGFloat radius;
@property(nonatomic, strong) UIColor *lineColor;
@property(nonatomic) CGFloat lineWidth;
@property(nonatomic, strong) UIColor *bgRGBAColor;


@end