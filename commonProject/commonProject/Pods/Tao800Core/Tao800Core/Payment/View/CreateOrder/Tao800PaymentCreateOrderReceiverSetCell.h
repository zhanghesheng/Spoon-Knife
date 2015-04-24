//
//  Tao800PaymentCreateOrderReceiverSetCell.h
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PaymentCreateOrderBaseCell.h"

@class Tao800PaymentCreateOrderReceiverSetCell;

@protocol Tao800PaymentCreateOrderReceiverSetCellDelegate <NSObject>
@optional
-(void)gotoAdressFromSetting:(Tao800PaymentCreateOrderReceiverSetCell *)cell;
@end

@interface Tao800PaymentCreateOrderReceiverSetCell : Tao800PaymentCreateOrderBaseCell
@property(nonatomic, weak)id<Tao800PaymentCreateOrderReceiverSetCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIView *customContent;
@property (weak, nonatomic) IBOutlet UIButton *setButton;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@end

