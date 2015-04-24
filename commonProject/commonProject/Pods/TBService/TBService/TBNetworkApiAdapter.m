//
//  TBNetworkApiAdapter.m
//  Core
//
//  Created by enfeng yang on 12-1-16.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import "TBNetworkApiAdapter.h"
#import "TBNetwork/TBNetworkWrapperAdapter.h"
 
static TBNetworkApiAdapter *_instance;
@implementation TBNetworkApiAdapter

@synthesize requestKey;
@synthesize requestTimeOut;
@synthesize networkStatus;

#pragma mark -
#pragma mark Singleton Methods

- (void)setRequestTimeOut:(NSInteger)pRequestTimeOut {
    TBNetworkWrapperAdapter *adapter = [TBNetworkWrapperAdapter sharedInstance];
    adapter.requestTimeOut = pRequestTimeOut;

    requestTimeOut = pRequestTimeOut;
}

- (void)setNetworkStatus:(NetworkStatus)pNetworkStatus {
    TBNetworkWrapperAdapter *adapter = [TBNetworkWrapperAdapter sharedInstance];
    adapter.networkStatus = pNetworkStatus;

    networkStatus = pNetworkStatus;
}

+ (TBNetworkApiAdapter*)sharedInstance
{
	@synchronized(self) {
        
        if (_instance == nil) {
            
            _instance = [[self alloc] init];
            _instance.requestTimeOut = 15;//超时，默认
            // Allocate/initialize any member variables of the singleton class here
            // example
			//_instance.member = @"";
        }
    }
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone

{
    @synchronized(self) {
        
        if (_instance == nil) {
            
            _instance = [super allocWithZone:zone];
            return _instance;  // assignment and return on first allocation
        }
    }
    
    return nil; //on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
 

#pragma mark -
#pragma mark Custom Methods

// Add your custom methods here

@end