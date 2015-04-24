//
// Created by enfeng on 12-6-6.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Tao800NetworkManager.h"
#import "Tao800DataModelSingleton.h"
#import "TBService/TBNetworkApiAdapter.h"
#import "TBCore/TBCore.h"
#import "TBCore/OpenUDID.h"
#import "Tao800Util.h"

#ifdef DEBUG
#define TBBNetTimeout 10
#else
#define TBBNetTimeout 90
#endif

@interface Tao800NetworkManager ()

@end

@implementation Tao800NetworkManager {

}

- (void)internetReachabilityChange {
    NetworkStatus status = [self.internetReachability currentReachabilityStatus];
    NSInteger timeout = TBBNetTimeout;
    switch (status) {
        case NotReachable: {
            break;
        }

        case ReachableViaWWAN: {
            timeout = TBBNetTimeout;
            if (self.internetReachability.connectionRequired) {
                //当前可能已经处于飞行模式
                status = NotReachable;
            }
            break;
        }

        case ReachableViaWiFi: {
            break;
        }
    }

    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    dm.networkStatus = status;

    NetworkStatus lastStatus = _lastNetworkStatus;

    _lastNetworkStatus = status;


    TBNetworkApiAdapter *serviceAdapter = [TBNetworkApiAdapter sharedInstance];
    serviceAdapter.requestTimeOut = timeout;
    serviceAdapter.networkStatus = _lastNetworkStatus;

    if (self.networkStatusBlock) {
        self.networkStatusBlock(status, lastStatus);
    }
}

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);

    if (curReach == self.internetReachability) {
        [self internetReachabilityChange];
    }
}

- (id)init {
    self = [super init];
    if (self) {
        
        // 设置deviceId mac地址
        Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
        NSString *macAddress = nil;
        if (dm.macAddress == nil || [dm.macAddress isEqualToString:@"02:00:00:00:00:00"]) {
            macAddress = [Tao800Util getDeviceId];
            [dm macAddress:macAddress];
            [dm archive];
        }
        
        dm.headerVo.macAddress = dm.macAddress;
        dm.headerVo.deviceId = dm.macAddress;

        self.internetReachability = [Reachability reachabilityForInternetConnection];
        [self.internetReachability startNotifier];
        [self internetReachabilityChange];
        

        //监听网络连接状态
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];

    }
    return self;
}

- (void)dealloc {

}
@end