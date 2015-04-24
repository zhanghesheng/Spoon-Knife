//
//  Tao800PaymentCreateOrderReceiverTitleCell.h
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PaymentCreateOrderBaseCell.h"

@class Tao800PaymentCreateOrderReceiverErrorCell;

@protocol Tao800PaymentCreateOrderReceiverErrorCellDelegate <NSObject>
@optional
-(void)gotoAdressFromError:(Tao800PaymentCreateOrderReceiverErrorCell *)cell;
@end

@interface Tao800PaymentCreateOrderReceiverErrorCell : Tao800PaymentCreateOrderBaseCell
@property(nonatomic, weak)id<Tao800PaymentCreateOrderReceiverErrorCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIView *customContent;
@property (weak, nonatomic) IBOutlet UIButton *gotoAdressBtn;
@end
