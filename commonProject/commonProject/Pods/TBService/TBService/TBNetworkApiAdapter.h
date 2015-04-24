//
//  TBNetworkApiAdapter.h
//  Core
//
//  Created by enfeng yang on 12-1-16.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBNetwork/Reachability.h"
 
@interface TBNetworkApiAdapter : NSObject {
    NSString *requestKey;
    NSInteger requestTimeOut;
    NetworkStatus networkStatus; 
}
@property (nonatomic, strong) NSString* requestKey;
@property (nonatomic, assign) NSInteger requestTimeOut;
@property (nonatomic, assign) NetworkStatus networkStatus;
+ (TBNetworkApiAdapter*) sharedInstance;
@end