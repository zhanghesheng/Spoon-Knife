//
//  Tao800StartNewsView.h
//  tao800
//
//  Created by worker on 12-10-24.
//  Copyright (c) 2012年 com.tuan800.tao800iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBUI/TBImageView.h"

@protocol Tao800StartNewsViewDelegate <NSObject>
@optional

- (void)startNewsViewTouchesMoved:(float)offsetX;

- (void)startNewsViewClosed;

@end

@interface Tao800StartNewsView : TBImageView {


}

@property(nonatomic, assign) BOOL dragEnable; // 是否支持拖拽
@property(nonatomic, assign) bool isClosed;

@property(nonatomic, weak) id <Tao800StartNewsViewDelegate> startNewsDelegate;

@property(nonatomic, weak) IBOutlet UIButton *detailButton; // 查看详情按钮
@property(nonatomic, weak) IBOutlet UIButton *skipOverButton; // 跳过按钮
@property(nonatomic, weak) IBOutlet UIView *shadowView; //底部阴影
 
@end
