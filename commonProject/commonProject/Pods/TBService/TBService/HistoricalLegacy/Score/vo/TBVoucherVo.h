//
//  TBVoucherVo.h
//  Core
//
//  Created by fei lu on 12-10-29.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBVoucherVo : NSObject {
    NSString *_voucher_value;
    NSString *_voucher_expiration_time;
    NSString *_description;
    NSString *_title;
    NSString *_image;
    NSNumber *_max_count;
    NSNumber *_vid;
    NSString *_voucher_effective_time;
    NSNumber *_point_count;
}
@property(nonatomic, strong) NSString *voucher_value;
@property(nonatomic, strong) NSString *voucher_expiration_time;
@property(nonatomic, strong) NSString *description;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *image;
@property(nonatomic, strong) NSNumber *max_count;
@property(nonatomic, strong) NSNumber *vid;
@property(nonatomic, strong) NSString *voucher_effective_time;
@property(nonatomic, strong) NSNumber *point_count;
@end
