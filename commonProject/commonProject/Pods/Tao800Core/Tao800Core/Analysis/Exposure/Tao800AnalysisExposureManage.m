//
//  Tao800AnalysisExposureManage.m
//  Tao800Core
//
//  Created by enfeng on 15/3/10.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <TBNetwork/ASINetworkQueue.h>
#import <TBNetwork/ASIFormDataRequest.h>
#import <TBNetwork/TBNetworkWrapper.h>
#import <TBCore/TBCoreUtil.h>
#import <TBCore/NSString+Addition.h>
#import "Tao800AnalysisExposureManage.h"
#import "Tao800AnalysisExposureConstant.h"
#import "Tao800AnalysisExposureContentVO.h"
#import "Tao800AnalysisExposureContentDealVO.h"

@interface Tao800AnalysisExposureManage ()
@property(nonatomic, strong) NSMutableDictionary *exposureContentDict;
@property(nonatomic, strong) dispatch_queue_t exposureContentQueue;
@property(nonatomic, strong) ASINetworkQueue *uploadQueue;

- (void)uploadExposureContent:(Tao800AnalysisExposureContentVO *)exposureContentVO;
- (void)uploadExposureContentUrl:(NSString *)urlString;
@end

@implementation Tao800AnalysisExposureManage

+ (id)shareInstance {
    static Tao800AnalysisExposureManage *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Tao800AnalysisExposureManage alloc] init];
    });
    return instance;
}

- (NSString *)JSONString:(BOOL)prettyPrint withObject:(id)object {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization
            dataWithJSONObject:object
                       options:(NSJSONWritingOptions) (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                         error:&error];

    if (!jsonData) {
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

-(NSString*)ifNSNumberChangeToNSString:(NSString*) postValue{
    if ([postValue isKindOfClass:[NSNumber class]]) {
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        postValue = [numberFormatter stringFromNumber:(NSNumber*)postValue];
    }
    return postValue;
}

- (NSString *)exposureContentUrlWith:(Tao800AnalysisExposureContentVO *)exposureContentVO {
    NSString *ret = @"http://analysis.tuanimg.com/bgl_v2.gif";
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:20];
    NSString *userId = @"";
    NSString *deviceId = @"";
    NSString *fromSource = @"";
    NSString *platform = @"";
    NSString *version = @"";
    NSString *channel = @"";
    NSString *userRole = @"";
    NSString *userType = @"";
    NSString *school = @"";
    NSString *child = @"";
    NSString *listVersion = @"";
    NSString *postType = nil;
    NSString *postValue = @"";
    NSString *refer = @"";

    if (exposureContentVO.exposureUserId) {userId = [self ifNSNumberChangeToNSString:exposureContentVO.exposureUserId];}
    if (exposureContentVO.exposureDeviceId) {deviceId = [self ifNSNumberChangeToNSString:exposureContentVO.exposureDeviceId];}
    if (exposureContentVO.exposureFromSource) {fromSource = [self ifNSNumberChangeToNSString:exposureContentVO.exposureFromSource];}
    if (exposureContentVO.exposurePlatform) {platform = [self ifNSNumberChangeToNSString:exposureContentVO.exposurePlatform];}
    if (exposureContentVO.exposureVersion) {version = [self ifNSNumberChangeToNSString:exposureContentVO.exposureVersion];}
    if (exposureContentVO.exposureChannel) {channel = [self ifNSNumberChangeToNSString:exposureContentVO.exposureChannel];}
    if (exposureContentVO.exposureUserRole) {userRole = [self ifNSNumberChangeToNSString:exposureContentVO.exposureUserRole];}
    if (exposureContentVO.exposureUserType) {userType = [self ifNSNumberChangeToNSString:exposureContentVO.exposureUserType];}
    if (exposureContentVO.exposureSchool) {school = [self ifNSNumberChangeToNSString:exposureContentVO.exposureSchool];}
    if (exposureContentVO.exposureChild) {child = [self ifNSNumberChangeToNSString:exposureContentVO.exposureChild];}
    if (exposureContentVO.exposureListVersion) {listVersion = [self ifNSNumberChangeToNSString:exposureContentVO.exposureListVersion];}
    if (exposureContentVO.exposurePostValue)
    {
        postValue = [self ifNSNumberChangeToNSString:exposureContentVO.exposurePostValue];
    }
    if (exposureContentVO.exposureRefer) {refer = [self ifNSNumberChangeToNSString:exposureContentVO.exposureRefer];}

    postType = [Tao800AnalysisExposureConstant postTypeWith:exposureContentVO.exposurePosType];
 
    [array addObject:[NSString stringWithFormat:@"uid=%@", [userId encoded]]];
    [array addObject:[NSString stringWithFormat:@"deviceid=%@", [deviceId encoded]]];
    [array addObject:[NSString stringWithFormat:@"fromsource=%@", [fromSource encoded]]];
    [array addObject:[NSString stringWithFormat:@"platform=%@", [platform encoded]]];
    [array addObject:[NSString stringWithFormat:@"version=%@", [version encoded]]];
    [array addObject:[NSString stringWithFormat:@"channel=%@", [channel encoded]]];
    [array addObject:[NSString stringWithFormat:@"userrole=%@", [userRole encoded]]];
    [array addObject:[NSString stringWithFormat:@"usertype=%@", [userType encoded]]];
    [array addObject:[NSString stringWithFormat:@"school=%@", [school encoded]]];
    [array addObject:[NSString stringWithFormat:@"child=%@", [child encoded]]];
    [array addObject:[NSString stringWithFormat:@"listversion=%@", [listVersion encoded]]];
    [array addObject:[NSString stringWithFormat:@"pos_type=%@", [postType encoded]]];
    [array addObject:[NSString stringWithFormat:@"pos_value=%@", [postValue encoded]]];
    [array addObject:[NSString stringWithFormat:@"refer=%@", [refer encoded]]];

    NSMutableArray *deals = [NSMutableArray arrayWithCapacity:exposureContentVO.deals.count];
    for (Tao800AnalysisExposureContentDealVO *dealVO in exposureContentVO.deals) {
        NSDictionary *dictItem = @{
                @"id" : dealVO.exposureDealId,
                @"n" : dealVO.exposureOrderIndex,
                @"time" : dealVO.exposureTime
        };
        [deals addObject:dictItem];
    }

    NSString *jsonString = [self JSONString:NO withObject:deals];
    jsonString = [jsonString encoded];
    [array addObject:[NSString stringWithFormat:@"deals=%@", jsonString]];

    NSString *paramString = [array componentsJoinedByString:@"&"];

    ret = [NSString stringWithFormat:@"%@?%@", ret, paramString];

    return ret;
}

- (void)addExposureBaseInfo:(Tao800AnalysisExposureContentVO *)exposureContentVO {

    dispatch_async(self.exposureContentQueue, ^{
        NSString *identifier = exposureContentVO.exposureIdentifier;
        id obj = self.exposureContentDict[identifier];
        if (obj) {
            return;
        }

        self.exposureContentDict[identifier] = exposureContentVO;
    });
}

- (void)removeExposureBaseInfo:(Tao800AnalysisExposureContentVO *)exposureContentVO {
    dispatch_async(self.exposureContentQueue, ^{
        NSString *identifier = exposureContentVO.exposureIdentifier;
        id obj = self.exposureContentDict[identifier];
        if (obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self uploadExposureContent:obj];
                [self.exposureContentDict removeObjectForKey:identifier];
            });
        }
    });
}

- (void)uploadExposureContent:(Tao800AnalysisExposureContentVO *)exposureContentVO {
    if (exposureContentVO.deals.count>0) {
        NSString *uploadUrlString = [self exposureContentUrlWith:exposureContentVO];
        [exposureContentVO.deals removeAllObjects];

        [self uploadExposureContentUrl:uploadUrlString];
    }
}

- (void)addExposureDeal:(Tao800AnalysisExposureContentDealVO *)exposureDeal {

    dispatch_async(self.exposureContentQueue, ^{
        Tao800AnalysisExposureContentVO *obj = self.exposureContentDict[exposureDeal.parentIdentifier];
        if (obj) {
            [obj.deals addObject:exposureDeal];
            if (obj.deals.count >= 6) {
                //发送曝光内容
                NSString *uploadUrlString = [self exposureContentUrlWith:obj];
                [obj.deals removeAllObjects];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self uploadExposureContentUrl:uploadUrlString];
                });
            }
        }
    });
}

- (id)init {
    if (self = [super init]) {
        self.exposureContentDict = [NSMutableDictionary dictionaryWithCapacity:10];

        self.exposureContentQueue = dispatch_queue_create("com.zhe800.exposureContentQueue",
                DISPATCH_QUEUE_SERIAL);

        self.uploadQueue = [[ASINetworkQueue alloc] init];
        [self.uploadQueue setMaxConcurrentOperationCount:3];
    }
    return self;
}

- (void)uploadExposureContentUrl:(NSString *)urlString {

    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.requestMethod = TBRequestMethodGet;

    __weak ASIFormDataRequest *weakRequest = request;

    [weakRequest setCompletionBlock:^{

    }];

    [weakRequest setFailedBlock:^{

    }];

    [self.uploadQueue addOperation:request];
    [self.uploadQueue go];
}

@end
