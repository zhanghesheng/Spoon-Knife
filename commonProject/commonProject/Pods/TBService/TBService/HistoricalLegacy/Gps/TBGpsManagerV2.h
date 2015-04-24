//
// Created by enfeng on 13-6-3.
// Copyright (c) 2013 enfeng. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TBLbsV2Api.h"
#import "TBGpsAddressVo.h"
#import "TBConstants.h"

@interface TBGpsManagerV2 : NSObject <TBLbsV2ApiDelegate, CLLocationManagerDelegate> {
    CLLocationCoordinate2D _coordinate2D;
    TBLbsV2Api *_lbsApi;
    CLLocationManager *_locationManager;
    TBGpsAddressVo *_gpsAddress;
    TBGpsManagerState _gpsManagerState;
    NSDate *_locationManagerStartDate;
}

@property(nonatomic) CLLocationCoordinate2D coordinate2D;

@property(nonatomic, strong) TBGpsAddressVo *gpsAddress;

@property(nonatomic) TBGpsManagerState gpsManagerState;

@property(nonatomic, readonly) NSDate *locationManagerStartDate;

+ (TBGpsManagerV2 *)sharedInstance;

- (CLLocationCoordinate2D)getOffsetGpsCoordinate;

- (void)startGps;

- (void) stopGps;
@end