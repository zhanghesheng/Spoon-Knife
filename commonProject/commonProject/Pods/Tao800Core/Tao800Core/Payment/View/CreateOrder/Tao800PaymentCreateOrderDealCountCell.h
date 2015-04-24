//
//  Tao800PaymentCreateOrderDealCountCell.h
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PaymentCreateOrderBaseCell.h"

@interface Tao800PaymentCreateOrderDealCountCell : Tao800PaymentCreateOrderBaseCell
@property (weak, nonatomic) IBOutlet UITextField *countText;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@end
