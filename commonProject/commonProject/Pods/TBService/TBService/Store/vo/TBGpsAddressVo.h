//
//  TBGpsAddressVo.h
//  Core
//
//  Created by enfeng yang on 12-2-7.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TBGpsAddressStateNothing=-1,
    TBGpsAddressStateGetting,
    TBGpsAddressStateFail,
    TBGpsAddressStateSuccess
} TBGpsAddressState;
 
@interface TBGpsAddressVo : NSObject<NSCoding, NSCopying>{
    NSString *name;
    NSString *description;
    NSString *cityName;
    NSDate *created; 
    double latitude;
    double longitude; 
    BOOL gpsLocation;
    NSArray *quotations;
    NSString* address;

    TBGpsAddressState _addressState;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, assign) BOOL gpsLocation;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude; 

@property (nonatomic, strong) NSArray *quotations;
@property(nonatomic) TBGpsAddressState addressState;

- (id)copyWithZone:(NSZone *)zone;


@end
