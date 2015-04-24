//
//  Tao800NoDataView.h
//  tao800
//
//  Created by enfeng on 14/11/25.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBUI/TBUI.h"

@interface Tao800NoDataView : UIView
@property (weak, nonatomic) IBOutlet UIView *tipBackgroundView;
@property (weak, nonatomic) IBOutlet TBImageView *centerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end
