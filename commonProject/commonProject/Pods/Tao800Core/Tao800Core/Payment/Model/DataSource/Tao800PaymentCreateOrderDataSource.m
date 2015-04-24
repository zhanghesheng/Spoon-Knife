//
//  Tao800PaymentCreateOrderDataSource.m
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PaymentCreateOrderDataSource.h"
#import "Tao800PaymentCreateOrderCarriageItem.h"
#import "Tao800PaymentCreateOrderCarriageCell.h"
#import "Tao800PaymentCreateOrderCarriageDescriptionItem.h"
#import "Tao800PaymentCreateOrderCarriageDescriptionCell.h"
#import "Tao800PaymentCreateOrderDealCountCell.h"
#import "Tao800PaymentCreateOrderDealCountItem.h"
#import "Tao800PaymentCreateOrderDealCell.h"
#import "Tao800PaymentCreateOrderDealItem.h"
#import "Tao800PaymentCreateOrderPayMethodItem.h"
#import "Tao800PaymentCreateOrderPayMethodCell.h"
#import "Tao800PaymentCreateOrderReceiverItem.h"
#import "Tao800PaymentCreateOrderReceiverCell.h"
#import "Tao800PaymentCreateOrderReceiverSetCell.h"
#import "Tao800PaymentCreateOrderReceiverSetItem.h"
#import "Tao800PaymentCreateOrderReceiverTitleCell.h"
#import "Tao800PaymentCreateOrderReceiverTitleItem.h"
#import "Tao800PaymentCreateOrderTitleCell.h"
#import "Tao800PaymentCreateOrderTitleItem.h"
#import "Tao800PaymentCreateOrderReceiverBottomItem.h"
#import "Tao800PaymentCreateOrderReceiverBottomCell.h"
#import "Tao800PaymentCreateOrderReceiverErrorItem.h"
#import "Tao800PaymentCreateOrderReceiverErrorCell.h"

@implementation Tao800PaymentCreateOrderDataSource
- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
    if ([object isKindOfClass:[Tao800PaymentCreateOrderCarriageItem class]]) {
        return [Tao800PaymentCreateOrderCarriageCell class];
    } else if ([object isKindOfClass:[Tao800PaymentCreateOrderCarriageDescriptionItem class]]) {
        return [Tao800PaymentCreateOrderCarriageDescriptionCell class];
    } else if ([object isKindOfClass:[Tao800PaymentCreateOrderDealCountItem class]]) {
        return [Tao800PaymentCreateOrderDealCountCell class];
    } else if ([object isKindOfClass:[Tao800PaymentCreateOrderDealItem class]]) {
        return [Tao800PaymentCreateOrderDealCell class];
    } else if ([object isKindOfClass:[Tao800PaymentCreateOrderPayMethodItem class]]) {
        return [Tao800PaymentCreateOrderPayMethodCell class];
    } else if ([object isKindOfClass:[Tao800PaymentCreateOrderReceiverItem class]]) {
        return [Tao800PaymentCreateOrderReceiverCell class];
    } else if ([object isKindOfClass:[Tao800PaymentCreateOrderReceiverSetItem class]]) {
        return [Tao800PaymentCreateOrderReceiverSetCell class];
    } else if ([object isKindOfClass:[Tao800PaymentCreateOrderReceiverTitleItem class]]) {
        return [Tao800PaymentCreateOrderReceiverTitleCell class];
    }else if ([object isKindOfClass:[Tao800PaymentCreateOrderReceiverErrorItem class]]) {
        return [Tao800PaymentCreateOrderReceiverErrorCell class];
    } else if ([object isKindOfClass:[Tao800PaymentCreateOrderTitleItem class]]) {
        return [Tao800PaymentCreateOrderTitleCell class];
    } else if ([object isKindOfClass:[Tao800PaymentCreateOrderReceiverBottomItem class]]) {
        return [Tao800PaymentCreateOrderReceiverBottomCell class];
    }

    else {
        return [super tableView:tableView cellClassForObject:object];
    }

}
@end
