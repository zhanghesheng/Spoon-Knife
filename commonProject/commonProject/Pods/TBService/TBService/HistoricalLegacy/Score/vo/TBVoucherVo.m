//
//  TBVoucherVo.m
//  Core
//
//  Created by fei lu on 12-10-29.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import "TBVoucherVo.h"

@implementation TBVoucherVo
@synthesize voucher_value = _voucher_value;
@synthesize voucher_expiration_time = _voucher_expiration_time;
@synthesize description = _description;
@synthesize title = _title;
@synthesize image = _image;
@synthesize max_count = _max_count;
@synthesize vid = _vid;
@synthesize voucher_effective_time = _voucher_effective_time;
@synthesize point_count = _point_count;

- (void)dealloc
{
 
}
@end
