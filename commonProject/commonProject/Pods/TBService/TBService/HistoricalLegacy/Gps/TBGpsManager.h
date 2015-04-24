//
// Created by enfeng on 12-8-10.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TBLbsV2Api.h"
#import "TBGpsAddressVo.h"
#import "TBConstants.h"

@interface TBGpsManager : NSObject <TBLbsV2ApiDelegate, CLLocationManagerDelegate> {
    CLLocationCoordinate2D _coordinate2D;
    TBLbsV2Api *_lbsApi;
    CLLocationManager *_locationManager;

    TBGpsAddressVo *_gpsAddress;

    //自动刷新间隔，以秒为单位，默认50秒刷一次
    NSInteger _autoGpsTimeInterval;

    //手动刷新
    BOOL _isManual;

    //手动刷新时地址的获取
    BOOL _isManualAddress;

    TBGpsManagerState _gpsManagerState;
}
@property(nonatomic) CLLocationCoordinate2D coordinate2D;
@property(nonatomic, strong) TBGpsAddressVo *gpsAddress;
@property(nonatomic, strong) NSTimer *nsTimer;
@property(nonatomic) NSInteger autoGpsTimeInterval;
@property(nonatomic, strong) NSDate *locationManagerStartDate;
@property(nonatomic) TBGpsManagerState gpsManagerState;


+ (TBGpsManager *)sharedInstance;

- (CLLocationCoordinate2D)getOffsetGpsCoordinate;

/**
* 手动调用定位刷新
* 该方法被调用后会停止调用自动刷新功能
* 手动刷新结束后会继续
*/
- (void)startGps;

/**
* 更新坐标，但不发送通知
*/
- (void)startGpsWithoutNotification;

- (void)autoUpdateGps;

/**
* 从应用前台切换到后台时，要取消所有请求
*/
- (void) cancelRequest;
@end