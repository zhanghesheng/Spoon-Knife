//
//  Tao800AddressDetailModel.m
//  tao800
//
//  Created by LeAustinHan on 14-5-27.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800AddressDetailModel.h"

@implementation Tao800AddressDetailModel
@synthesize addressManageService = _addressManageService;

-(id)init{
    self = [super init];
    if (self) {
        _addressManageService = [[Tao800AddressManageService alloc] init];
    }
    return self;
}

@end
