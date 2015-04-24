//
//  Tao800PaymentCreateOrderVCL.h
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800TableVCL.h"
#import "Tao800PaymentCreateOrderReceiverTitleCell.h"
#import "Tao800PaymentCreateOrderReceiverErrorCell.h"
#import "Tao800PaymentCreateOrderReceiverSetCell.h"

@interface Tao800PaymentCreateOrderVCL : Tao800TableVCL  <UITextFieldDelegate,
Tao800PaymentCreateOrderReceiverTitleCellDelegate, Tao800PaymentCreateOrderReceiverSetCellDelegate,
Tao800PaymentCreateOrderReceiverErrorCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *bottomPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (IBAction)handleMinusBtnAction;

- (IBAction)handlePlusBtnAction;
- (IBAction)submitAction:(id)sender;
@end
