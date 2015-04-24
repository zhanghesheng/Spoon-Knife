//
// Created by enfeng on 12-8-10.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CoreLocation/CoreLocation.h>
#import "TBGpsManager.h"
#import "TBCore/GeoTransfer.h"
#import "TBCore/TBCoreMacros.h"

#define MaxDistance 200

static TBGpsManager *_instance;

@interface TBGpsManager () {
    NSTimer *_nsTimer;
    NSDate *_locationManagerStartDate;
}

- (void)stopTimer;

- (void)restartTimer;
@end

@implementation TBGpsManager
@synthesize coordinate2D = _coordinate2D;
@synthesize gpsAddress = _gpsAddress;
@synthesize nsTimer = _nsTimer;
@synthesize autoGpsTimeInterval = _autoGpsTimeInterval;
@synthesize locationManagerStartDate = _locationManagerStartDate;
@synthesize gpsManagerState = _gpsManagerState;


- (id)init {
    self = [super init];
    if (self) {
        _lbsApi = [[TBLbsV2Api alloc] init];
        _lbsApi.delegate = self;
        self.autoGpsTimeInterval = 30;
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;

        _gpsManagerState = TBGpsManagerStateUpdating;

        TBGpsAddressVo *addressVo = [[TBGpsAddressVo alloc] init];
        self.gpsAddress = addressVo;
    }
    return self;
}

+ (TBGpsManager *)sharedInstance {
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

#pragma mark -----custom method-------
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

- (void)dealloc {
 
}

- (void)threadUpdateGps:(NSObject *)obj {
//   ios4.x 版本会提示NSDate autoreleased with no pool in place - just leaking
//    self.locationManagerStartDate = [NSDate date];
    [_locationManager startUpdatingLocation];
}

- (void)intervalStartGps {
    //如果前一次请求没有完成则取消
    [_lbsApi removeAllRequestFromArray];

    self.gpsAddress.addressState = TBGpsAddressStateGetting;
    _gpsManagerState = TBGpsManagerStateUpdating;
    [_locationManager stopUpdatingLocation];
    BOOL ret = [CLLocationManager locationServicesEnabled];
    if (!ret) {
        _gpsManagerState = TBGpsManagerStateFail;
        self.gpsAddress.addressState = TBGpsAddressStateFail;
        [[NSNotificationCenter defaultCenter] postNotificationName:TBGpsManagerDidErrorNotification object:nil];
        return;
    }
    self.locationManagerStartDate = [NSDate date];
 
    
    @autoreleasepool {
        [NSThread detachNewThreadSelector:@selector(threadUpdateGps:) toTarget:self withObject:nil];
    }
}

- (void)startGps {
    //停止自动定位功能
    [self stopTimer];
    _isManual = YES;
    _isManualAddress = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:TBGpsManagerDidStartNotification object:nil];
    [self intervalStartGps];
}

- (void)startGpsWithoutNotification {
    [self stopTimer];
    [self intervalStartGps];
}

- (void)autoUpdateGps {
    [self restartTimer];
}

- (void)cancelRequest {
    [_lbsApi removeAllRequestFromArray];
}


#pragma mark
#pragma ------------- 定时器 --------------------

- (void)fireTimer:(NSTimer *)theTimer {
    [self intervalStartGps];
}

- (void)restartTimer {
    [self stopTimer];
    _isManual = NO;
    self.nsTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoGpsTimeInterval
                                                    target:self
                                                  selector:@selector(fireTimer:)
                                                  userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if (_nsTimer) {
        [_nsTimer invalidate];
    }
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

    //定位失败通知
    if (_isManual) {
        _isManual = NO;

        NSInteger errorCode = [error code];
        NSNumber *errorNum = [NSNumber numberWithInteger:errorCode];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:errorNum forKey:@"errorCode"];
        [[NSNotificationCenter defaultCenter] postNotificationName:TBGpsManagerDidErrorNotification object:nil userInfo:dictionary];

        //重新调用自动刷新
//        [self restartTimer];
    }
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
            //超过100米，重取地址
            needUpdateAddress = YES;
        }

        self.coordinate2D = newLocation.coordinate;
    }

    if (self.gpsAddress.addressState == TBGpsAddressStateFail || self.gpsAddress.address == nil) {
        needUpdateAddress = YES;
    }

    if (needUpdateAddress) {
        self.gpsAddress.address = @"...";
        self.gpsAddress.cityName = nil;
        CLLocationCoordinate2D coordinate = [self getOffsetGpsCoordinate];
        [_lbsApi getAddressByCoordinateFromGoogle:coordinate];

        //发送通知
        if (_isManual) {
            _isManual = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:TBGpsManagerDidSuccessNotification object:nil];

            //重新调用自动刷新
            //        [self restartTimer];
        }
    } else {
        self.gpsAddress.addressState = TBGpsAddressStateSuccess;
        if (_isManual) {
            _isManual = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:TBGpsManagerDidSuccessNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:TBGpsManagerDidGetAddressNotification object:nil];
        }
    }

}

- (void)getAddressByCoordinateFromGoogleFinish:(NSDictionary *)dictParam {
    self.gpsAddress = (TBGpsAddressVo *) [dictParam objectForKey:@"addressVo"];
    self.gpsAddress.addressState = TBGpsAddressStateSuccess;
    //发送通知
    if (_isManualAddress) {
        _isManualAddress = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:TBGpsManagerDidGetAddressNotification object:nil];
    }
}

- (void)didNetworkError:(NSDictionary *)params {
    self.gpsAddress.addressState = TBGpsAddressStateFail;
    //发送通知
    if (_isManualAddress) {
        _isManualAddress = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:TBGpsManagerDidGetAddressNotification object:nil];
    }
}

@end