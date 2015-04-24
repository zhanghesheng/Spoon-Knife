//
//  Tao800AddressListCell.h
//  tao800
//
//  Created by LeAustinHan on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BaseCell.h"

@interface Tao800AddressListCell : Tao800BaseCell

@property (weak, nonatomic) IBOutlet UILabel *name;//姓名

@property (weak, nonatomic) IBOutlet UILabel *mobile;   //手机号码

@property (weak, nonatomic) IBOutlet UILabel *addressDetail;     //详细地址

@property (weak, nonatomic) IBOutlet UIImageView *isSelectedTip;   //选中状态tip

@property (weak, nonatomic) IBOutlet UIImageView *isDefaultTip;//默认tip

@property (weak, nonatomic) IBOutlet UILabel *addressArea; //区域地址

@end