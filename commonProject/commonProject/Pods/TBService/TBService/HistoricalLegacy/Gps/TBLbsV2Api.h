//
// Created by enfeng on 12-8-10.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>
#import "TBConstants.h"
#import "TBBaseNetworkApi.h"

@protocol TBLbsV2ApiDelegate <TBBaseNetworkDelegate>
@optional

- (void)getAddressByCoordinateFromGoogleFinish:(NSDictionary *)params;

- (void)getCoordinateByAddressFromGoogleFinish:(NSDictionary *)params;

- (void)getCoordinateByAddressFinish:(NSDictionary*) params;
@end


@interface TBLbsV2Api : TBBaseNetworkApi {
    CLLocationCoordinate2D _currentCoordinate2D;
}

@property(nonatomic) CLLocationCoordinate2D currentCoordinate2D;

/**
* 根据经纬度获取地址
*/
- (void)getAddressByCoordinateFromGoogle:(CLLocationCoordinate2D)coordinate;

/**
* 根据地址获取经纬度
*/
- (void)getCoordinateByAddressFromGoogle:(NSString *)address;
@end
