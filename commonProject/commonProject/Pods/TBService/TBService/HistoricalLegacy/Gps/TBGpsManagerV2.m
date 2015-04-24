//
// Created by enfeng on 13-6-3.
// Copyright (c) 2013 enfeng. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "TBCore/GeoTransfer.h"
#import "TBCore/TBCoreMacros.h"
#import "TBGpsManagerV2.h"

static TBGpsManagerV2 *_instance;

#define MaxDistance 200

@interface TBGpsManagerV2()

- (void) appUnavailable;
@end

@implementation TBGpsManagerV2 {

}

- (void) appUnavailable {

    //取消所有请求
    [_lbsApi removeAllRequestFromArray];
}

- (id)init {
    self = [super init];
    if (self) {
        _lbsApi = [[TBLbsV2Api alloc] init];
        _lbsApi.delegate = self;
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;

        _gpsManagerState = TBGpsManagerStateNothing;

        TBGpsAddressVo *addressVo = [[TBGpsAddressVo alloc] init];
        self.gpsAddress = addressVo;
        self.gpsAddress.addressState = TBGpsAddressStateNothing;

        [[NSNotificationCenter defaultCenter]
                addObserver:self selector:@selector(appUnavailable)
//                       name:UIApplicationProtectedDataWillBecomeUnavailable
                       name:UIApplicationWillResignActiveNotification
                     object:nil];
    }
    return self;
}

+ (TBGpsManagerV2 *)sharedInstance {
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized (self) {

        if (_instance == nil) {

            _instance = [super allocWithZone:zone];
            return _instance;  // assignment and return on first allocation
        }
    }

    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)startGps {
    [[NSNotificationCenter defaultCenter] postNotificationName:TBGpsManagerDidStartNotification object:nil];

    self.gpsAddress.addressState = TBGpsAddressStateNothing;
    _gpsManagerState = TBGpsManagerStateUpdating;

    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        #if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        [_locationManager requestWhenInUseAuthorization];
        #else
        #endif
    }

    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        #if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        [_locationManager requestAlwaysAuthorization];
        #else
        #endif
    }

    [_locationManager stopUpdatingLocation];
    BOOL ret = [CLLocationManager locationServicesEnabled];
    if (!ret) {
        _gpsManagerState = TBGpsManagerStateFail;
        self.gpsAddress.addressState = TBGpsAddressStateFail;
        [[NSNotificationCenter defaultCenter] postNotificationName:TBGpsManagerDidErrorNotification object:nil];
        return;
    }
 
    _locationManagerStartDate = [NSDate date];
    
    @autoreleasepool {
        [NSThread detachNewThreadSelector:@selector(threadUpdateGps:) toTarget:self withObject:nil];
    }
}

- (void)stopGps {

    //取消所有请求
    [_lbsApi removeAllRequestFromArray];

    _gpsManagerState = TBGpsManagerStateNothing;
    [_locationManager stopUpdatingLocation];
}

- (void)threadUpdateGps:(NSObject *)obj {
//   ios4.x 版本会提示NSDate autoreleased with no pool in place - just leaking
//    self.locationManagerStartDate = [NSDate date];
    [_locationManager startUpdatingLocation];
}

- (CLLocationCoordinate2D)getOffsetGpsCoordinate {
    CLLocationCoordinate2D retCoordinate2D;

    //通过gps获取的点需要做转换
    double x = 0;
    double y = 0;
    getEncryPoint(self.coordinate2D.longitude, self.coordinate2D.latitude, &x, &y);
    retCoordinate2D.longitude = x;
    retCoordinate2D.latitude = y;
    return retCoordinate2D;
}

#pragma mark
#pragma ------------- 定位代理方法 -----------------
- (BOOL)isValidLocation:(CLLocation *)newLocation
        withOldLocation:(CLLocation *)oldLocation {
    if (_locationManagerStartDate == nil) {
        return NO;
    }

    // Filter out nil locations
    if (!newLocation) {
        return NO;
    }

    // Filter out points by invalid accuracy
    if (newLocation.horizontalAccuracy < 0) {
        return NO;
    }

    // Filter out points that are out of order
    NSTimeInterval secondsSinceLastPoint =
            [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];

    if (secondsSinceLastPoint < 0) {
        return NO;
    }

    // Filter out points created before the manager was initialized
    NSTimeInterval secondsSinceManagerStarted =
            [newLocation.timestamp timeIntervalSinceDate:_locationManagerStartDate];

    if (secondsSinceManagerStarted < 0) {
        return NO;
    }

    // The newLocation is good to use
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [_locationManager stopUpdatingHeading];

    _gpsManagerState = TBGpsManagerStateFail;
    self.gpsAddress.addressState = TBGpsAddressStateFail;

    NSInteger errorCode = [error code];
    NSNumber *errorNum = [NSNumber numberWithInteger:errorCode];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:errorNum forKey:@"errorCode"];
    [[NSNotificationCenter defaultCenter] postNotificationName:TBGpsManagerDidErrorNotification object:nil userInfo:dictionary];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    if (![self isValidLocation:newLocation withOldLocation:oldLocation]) {
        return;
    }
    [_locationManager stopUpdatingLocation];
    _gpsManagerState = TBGpsManagerStateSuccess;

    BOOL needUpdateAddress = NO;

    if (self.coordinate2D.latitude == 0) {
        self.coordinate2D = newLocation.coordinate;
        needUpdateAddress = YES;
    } else {
        CLLocation *currLocation = [[CLLocation alloc] initWithLatitude:self.coordinate2D.latitude
                                                              longitude:self.coordinate2D.longitude];
        double dis = [currLocation distanceFromLocation:newLocation];

        if (dis > MaxDistance) {
            //超过 MaxDistance 米，重取地址
            needUpdateAddress = YES;
        }

        self.coordinate2D = newLocation.coordinate;
    }

    //定位成功
    [[NSNotificationCenter defaultCenter] postNotificationName:TBGpsManagerDidSuccessNotification object:nil];

    if (self.gpsAddress.addressState == TBGpsAddressStateGetting && !needUpdateAddress) {
        //避免重复获取地址
        return;
    } else {
        //取消之前的请求
        [_lbsApi removeAllRequestFromArray];
    }

    if (self.gpsAddress.addressState == TBGpsAddressStateFail
            || self.gpsAddress.address == nil
            || self.gpsAddress.cityName == nil
            ) {
        needUpdateAddress = YES;
    }

    if (needUpdateAddress) {
        self.gpsAddress.addressState = TBGpsAddressStateGetting;
        self.gpsAddress.address = nil;
        self.gpsAddress.cityName = nil;
        CLLocationCoordinate2D coordinate = [self getOffsetGpsCoordinate];

        //发送通知，开始获取地址
        [[NSNotificationCenter defaultCenter] postNotificationName:TBGpsManagerGettingAddressNotification object:nil];
        [_lbsApi getAddressByCoordinateFromGoogle:coordinate];
    } else {
        self.gpsAddress.addressState = TBGpsAddressStateSuccess;
        [[NSNotificationCenter defaultCenter] postNotificationName:TBGpsManagerDidGetAddressNotification object:nil];
    }

}

- (void)getAddressByCoordinateFromGoogleFinish:(NSDictionary *)dictParam {
    self.gpsAddress = (TBGpsAddressVo *) [dictParam objectForKey:@"addressVo"];
    self.gpsAddress.addressState = TBGpsAddressStateSuccess;

    [[NSNotificationCenter defaultCenter] postNotificationName:TBGpsManagerDidGetAddressNotification object:nil];
}

- (void)didNetworkError:(NSDictionary *)params {
    self.gpsAddress.addressState = TBGpsAddressStateFail;

    [[NSNotificationCenter defaultCenter] postNotificationName:TBGpsManagerDidGetAddressNotification object:nil];
}

@end