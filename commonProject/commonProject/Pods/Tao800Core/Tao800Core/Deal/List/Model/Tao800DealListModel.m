//
//  Tao800DealListModel.m
//  tao800
//
//  Created by enfeng on 14-2-12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800DealListModel.h"
#import "Tao800DealListGridItem.h"
#import "Tao800DealListItem.h"
#import "Tao800LoadMoreItem.h"
#import "Tao800UGCSingleton.h"
#import "Tao800LogParams.h"
#import "Tao800PromotionEntranceVo.h"
#import "Tao800ExposureService.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800DealVo.h"
#import "TBCore/NSDictionaryAdditions.h"
#import "Tao800DataModelSingleton.h"

@interface Tao800DealListModel ()
@property(nonatomic, strong) Tao800ExposureService *exposureService;
@end

@implementation Tao800DealListModel
 /**
* 页面曝光打点
*/


- (void)writeLogString:(NSString*) logString exposureCtype:(int)exposureCtype{
    __weak Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    if ([dm.saveDealLogs containsObject:logString]) {
        return;
    }
    [dm.saveDealLogs addObject:logString];

    [dm.uploadingDealLogs addObject:logString];
    if (dm.uploadingDealLogs.count >=20) {
        
        NSDictionary *dict = @{@"c_type": @(exposureCtype),
                               @"params": dm.uploadingDealLogs};
        
        [self sendSaveDealLogs:dict
                    completion:^(NSDictionary *dictParam) {
                     } failure:^(TBErrorDescription *error) {
                                }];
    }

}

- (void)writeLogsExposureCtype:(int)exposureCtype{
    NSArray *tempArray = [self.dealLogs copy];
    
    [self.dealLogs removeAllObjects];
    dispatch_queue_t mainQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(mainQueue, ^(void) {
        for (NSString *logString in tempArray) {
            [self writeLogString:logString exposureCtype:exposureCtype];
        }
    });
}

- (id)init {
    self = [super init];
    if (self) {
        self.deals = [NSMutableArray arrayWithCapacity:100];
        self.dealLogs = [NSMutableArray arrayWithCapacity:100];
        self.exposureService = [[Tao800ExposureService alloc] init];
        self.dealDetailFrom = Tao800DealDetailFromHome;
        Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
        self.displayAsGrid = dm.displayAsGrid;
    }
    return self;
}

- (void)wrapperLoadMoreItem {
    for (NSObject *objItem in self.items) {
        if ([objItem isKindOfClass:[Tao800LoadMoreItem class]]) {
            [self.items removeObject:objItem];
            break;
        }
    }
    if (self.hasNext) {
        Tao800LoadMoreItem *item = [[Tao800LoadMoreItem alloc] init];
        item.loading = YES;
        item.text = @"努力加载中...";
        [self.items addObject:item];
    }
}

- (void)wrapperDealItems:(NSArray *)pDeals {
    int index = -1;
    for (Tao800DealVo *dealVo in pDeals) {
        Tao800DealListItem *item = [[Tao800DealListItem alloc] init];
        index++;
        item.dealVo = dealVo;
        item.sortId = 20 * ( (int)(self.pageNumber) - 1) + index;
        item.dealDetailFrom = self.dealDetailFrom;
        item.cId = self.cId;
        
        [self.items addObject:item];
    }
    [self wrapperLoadMoreItem];
}

- (void)wrapperGridItems:(NSArray *)pDeals {
    int index = -1;
    NSMutableArray *array = nil;
    Tao800DealListGridItem *item = nil;

    for (Tao800DealVo *dealVo in pDeals) {
        index++;
        if (index % 2 == 0) {
            array = [NSMutableArray arrayWithCapacity:2];
            item = [[Tao800DealListGridItem alloc] init];
            item.items = array;
            item.sortId = index;
            item.dealDetailFrom = self.dealDetailFrom;
            item.cId = self.cId;
            
            [self.items addObject:item];
        }
        [array addObject:dealVo];
    }
    [self wrapperLoadMoreItem];
}

- (void)wrapperItems {

    if (self.displayAsGrid) {
        [self wrapperGridItems:self.deals];
    } else {
        [self wrapperDealItems:self.deals];
    }
}

- (BOOL) dealAdded:(Tao800DealVo *)dealVo {
    for (Tao800DealVo *deal in self.deals) {
        if (![deal isKindOfClass:[Tao800DealVo class]]) {
            continue;
        }
        if (deal.dealId == dealVo.dealId) {
            return YES;
        }
    }
    return NO;
}

- (void)wrapperItems:(NSDictionary *)dict {
    NSArray *pItems = [dict objectForKey:@"items"];
    NSDictionary *meta = [dict objectForKey:@"meta"];
    NSNumber *hNumber = [meta objectForKey:@"has_next"];
    
    //deal 排重
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:pItems.count];
    for (Tao800DealVo *deal in pItems) {
        if ([self dealAdded:deal]) {
            continue;
        }
        [arr addObject:deal];
    }

    [self.deals addObjectsFromArray:arr];

    if (hNumber) {
        self.hasNext = [hNumber boolValue];
    } else {
        self.hasNext = pItems.count > 0;
    }

    if (self.displayAsGrid) {
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
        for (NSObject *item in self.items) {
            if (![item isKindOfClass:[Tao800DealListGridItem class]]) {
                [array addObject:item];
            }
        }
        self.items = array;

        [self wrapperGridItems:self.deals];
    } else {
        [self wrapperDealItems:arr];
    }

}

- (void)reloadItems {
    [self wrapperItems];
}

- (void)sendSaveDealLogs:(NSDictionary *)paramsExt
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure{
    __weak Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    
    NSString *ctype = paramsExt[@"c_type"];
    NSArray *dealLogArray = paramsExt[@"params"];
    
    NSString *url = [dealLogArray objectAtIndex:0] ;
    NSArray *array = [url componentsSeparatedByString:@","];
    //urlName
    url = array[2];

    NSMutableArray *logArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < [dealLogArray count]; i++) {
        NSString *str = [dealLogArray objectAtIndex:i];
        array = [str componentsSeparatedByString:@","];
        NSString *dealId = array[0];
        NSString *sortId = [array objectAtIndex:1];
        if (!dealId) {
            dealId = @"";
        }
        NSDictionary *dict = @{@"id": dealId,
                               @"x": sortId};
        [logArray addObject:dict];
    }
    
    NSString *deviceid = dm.macAddress;
    NSString *userid = dm.user.userId;
    NSString *version = dm.version;
    NSDictionary *dict = @{@"deals": logArray};
    
    if (!url) {
        url = @"";
    }
    if (!userid) {
        userid = @"";
    }
    if (!deviceid) {
        deviceid = @"";
    }
    if (!dict) {
        dict = @{@"deals": @[]};
    }
    if (!version) {
        version = @"0";
    }
    if (!ctype) {
        ctype = @"";
    }
    NSDictionary *params = @{@"url": url,
                             @"deviceid": deviceid,
                             @"userid": userid,
                             @"version": version,
                             @"div": [dict JSONString:NO],
                             @"c_type": ctype,
                             };
    //不管成功失败 都删除
    [dm.uploadingDealLogs removeAllObjects];
    
    [self.exposureService sendSaveDealLogs:params
                                completion:^(NSDictionary *dictParam) {
                                    //请求完成，清空曝光上传数组
//                                    [dm.uploadingDealLogs removeAllObjects];
//                                    [dm archive];
                                    completion(nil);
                                } failure:^(TBErrorDescription *error){
//                                    [dm.uploadingDealLogs removeAllObjects];
                                }];

}
@end
