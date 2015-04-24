//
//  Tao800PaymentCreateOrderReceiverTitleCell.h
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PaymentCreateOrderBaseCell.h"
#import "Tao800RightArrowButton.h"

@class Tao800PaymentCreateOrderReceiverTitleCell;

@protocol Tao800PaymentCreateOrderReceiverTitleCellDelegate <NSObject>
@optional
-(void)gotoAdressFromTitle:(Tao800PaymentCreateOrderReceiverTitleCell *)cell;
@end

@interface Tao800PaymentCreateOrderReceiverTitleCell : Tao800PaymentCreateOrderBaseCell
@property(nonatomic, weak)id<Tao800PaymentCreateOrderReceiverTitleCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIView *customContent;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet Tao800RightArrowButton *editButton;
@end
