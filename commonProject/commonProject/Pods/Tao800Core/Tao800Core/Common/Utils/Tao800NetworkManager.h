//
// Created by enfeng on 12-6-6.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TBNetwork/Reachability.h"

typedef void (^Tao800NetworkStatusBlock)(NetworkStatus currentStatus, NetworkStatus lastNetworkStatus);

@interface Tao800NetworkManager : NSObject {
    NetworkStatus _lastNetworkStatus;
}
@property(nonatomic) Reachability *hostReachability;
@property(nonatomic) Reachability *internetReachability;
@property(nonatomic) Reachability *wifiReachability;

@property (nonatomic, copy) Tao800NetworkStatusBlock networkStatusBlock;

@end