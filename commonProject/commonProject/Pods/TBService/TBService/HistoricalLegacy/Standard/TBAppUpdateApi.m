//
//  TBAppUpdateApi.m
//  Core
//
//  Created by enfeng yang on 12-2-7.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import "TBAppUpdateApi.h"
#import "TBCore/NSString+Addition.h"

@implementation TBAppUpdateApi


@synthesize urlStr = _urlStr;

- (void)dealloc {
 
}

- (id)initWithUpdateUrl:(NSString *)purlStr {
    self = [super init];
    if (self) {
        self.urlStr = purlStr;
    }
    return self;
}

/**
 * 获取更新信息
 * @params
 *   key:currentVer(NSString*) 当前版本
 */
- (void)getUpdateVersion:(NSDictionary *)params {
    NSURL *url = [NSURL URLWithString:self.urlStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:@"GET"];
    request.serviceMethodFlag = APIAppUpdateGetUpdateVersion;
    request.serviceData = params;

    [self send:request];
}

- (int)neeUpdate:(NSDictionary *)params currentVersion:(NSString *)curStr {
    NSString *version = [params objectForKey:@"version"];
    NSString *min_version = [params objectForKey:@"min_version"];

    if ([curStr isEqualToString:version]) {
        return TBAppUpdateApiNoUpdate;
    }

    //比较版本
    NSArray *curArr = [curStr componentsSeparatedByString:@"."];
    NSArray *versionArr = [version componentsSeparatedByString:@"."];
    NSArray *minVersionArr = [min_version componentsSeparatedByString:@"."];

    int first = [[curArr objectAtIndex:0] intValue];
    int middle = [[curArr objectAtIndex:1] intValue];
    int last = [[curArr objectAtIndex:2] intValue];

    int rFirst = [[versionArr objectAtIndex:0] intValue];
    int rMiddle = [[versionArr objectAtIndex:1] intValue];
    int rLast = [[versionArr objectAtIndex:2] intValue];

    int minFirst = [[minVersionArr objectAtIndex:0] intValue];
    int minMiddle = [[minVersionArr objectAtIndex:1] intValue];
    int minLast = [[minVersionArr objectAtIndex:2] intValue];

    //比较最小版本与当前版本
    BOOL showTip = NO;
    BOOL mustUpdate = NO;

    if (minFirst > first) {
        showTip = YES;
        mustUpdate = YES;
    }
    else if (minFirst == first) {
        if (minMiddle > middle) {
            showTip = YES;
            mustUpdate = YES;
        }
        else if (minMiddle == middle && minLast > last) {
            showTip = YES;
            mustUpdate = YES;
        }
    }
    if (showTip && mustUpdate) {
        return TBAppUpdateApiMustUpdate;
    }

    //比较当前版本
    if (rFirst > first) {
        showTip = YES;
    } else if (rFirst == first) {
        if (rMiddle > middle) {
            showTip = YES;
        } else if (rMiddle == middle && rLast > last) {
            showTip = YES;
        }
    }
    if (showTip) {
        return TBAppUpdateApiHadUpdate;
    }
    return TBAppUpdateApiNoUpdate;
}

- (void)requestFinished:(TBASIFormDataRequest *)request {

    BOOL isHttpOk = [self isHttpStatusOk:request];
    if (!isHttpOk) return;

    NSString *resStr = [request responseString];
    NSDictionary *jsonDict = nil;
    @try {
        jsonDict = [resStr JSONValue];
    }
    @catch (NSException *exception) {
        jsonDict = [NSDictionary dictionary];
    }

    //NSDictionary *jsonDict = [resStr JSONValue];

    SEL sel = nil;
    NSObject *retObj = jsonDict;

    switch (request.serviceMethodFlag) {
        case APIAppUpdateGetUpdateVersion: {
            NSDictionary *dict = (NSDictionary *) request.serviceData;
            NSString *currVer = [dict objectForKey:@"currentVer"];
            NSString *description = [jsonDict objectForKey:@"description"];
            NSString *updateUrl = [jsonDict objectForKey:@"url"];
            int updateFlagInt = [self neeUpdate:jsonDict currentVersion:currVer];
            NSNumber *updateFlag = [NSNumber numberWithInt:updateFlagInt];
            retObj = [NSDictionary dictionaryWithObjectsAndKeys:updateFlag, @"flag",
                                                                description, @"description",
                                                                updateUrl, @"updateUrl",
                                                                nil];
            sel = @selector(getUpdateVersionFinish:);
        }
            break;

        default:
            break;
    };

    if (sel && self.delegate && [self.delegate respondsToSelector:sel]) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
      [self.delegate performSelector:sel withObject:retObj];
#pragma clang diagnostic pop
    }

    [super requestFinished:request];
}

@end
