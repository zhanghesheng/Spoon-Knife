//
//  Tao800BubblePopupView.h
//  tao800
//
//  Created by enfeng on 14-2-20.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBUI/TBUI.h"

@class Tao800BubblePopupView;

typedef enum _BubblePopupViewDirection {
    BubblePopupViewDirectionTop = 0,
    BubblePopupViewDirectionBottom
} BubblePopupViewDirection;

typedef void (^BubblePopupViewClickCallBack)(Tao800BubblePopupView *popupView, CGPoint point, UIEvent *event);

@interface Tao800BubblePopupView : UIView

@property(nonatomic, assign) CGFloat imageHeight;
@property(nonatomic, copy) BubblePopupViewClickCallBack clickCallBack;
@property (nonatomic, assign) BOOL isMainTouchView; //点击该视图响应关闭

/**
* 调用方式
* Tao800BubblePopupView *popupView = [[Tao800BubblePopupView alloc] initWithFrame:CGRectZero];
* popupView showInView(view);
* [popupView imageView:imageView showInRect:rect];
*/
- (void)showInView:(UIView *)view;

/**
*
* 弹出气泡
*
* 气泡为事先设计好的矩形图片，具体显示位置由调用者决定
*
* @param paramImageView TBImageView对象 需要传入初始坐标位置，传入提示按钮的中间坐标即可
* @param rect imageView的显示区域
*/
- (void)showBubbleView:(UIView *)paramImageView inRect:(CGRect)rect;

- (void)showBubbleView:(UIView *)paramImageView on:(UIView *)sender direction:(BubblePopupViewDirection)direction;

- (void)closeBubble;
@end
