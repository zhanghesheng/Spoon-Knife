//
// Created by enfeng on 12-8-10.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TBLbsV2Api.h"
#import "TBCore/NSString+Addition.h"

#import "TBGpsAddressVo.h"

NSString *const UrlMapsGoogle = @"http://maps.google.com/maps/api/geocode/json";
NSString *const UrlGoogleDituQuery = @"http://ditu.google.cn/maps/geo";

@implementation TBLbsV2Api {

}
- (void)getAddressByCoordinateFromGoogle:(CLLocationCoordinate2D)coordinate {
    NSString *mapUrl = [NSString stringWithFormat:@"%@?latlng=%f,%f&sensor=true&language=zh-CN", UrlMapsGoogle,
                                                  coordinate.latitude, coordinate.longitude];

    NSURL *url = [NSURL URLWithString:mapUrl];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.serviceMethodFlag = APILBSGetAddressByCoordinateGoogle;
    request.requestMethod = TBRequestMethodGet;
    [request setDelegate:self];
    [self sendWithoutRequestKey:request];
}

- (void)getCoordinateByAddressFromGoogle:(NSString *)address {
    NSString *path = [NSString stringWithFormat:@"%@?q=%@", UrlGoogleDituQuery, address];
    path = [path urlEncoded];
    NSURL *url = [NSURL URLWithString:path];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.serviceMethodFlag = APILBSGetCoordinateByAddressGoogle;
    request.requestMethod = TBRequestMethodGet;
    [request setDelegate:self];
    [self sendWithoutRequestKey:request];
}

- (void)callAddressByCoordinate:(TBGpsAddressVo *)ta {
    SEL sel = @selector(getAddressByCoordinateFromGoogleFinish:);
    if (self.delegate && [self.delegate respondsToSelector:sel]) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:ta, @"addressVo", nil];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.delegate performSelector:sel withObject:params];
#pragma clang diagnostic pop
    }
}

- (NSArray *)reversedArray:(NSArray *)pArr {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[pArr count]];
    NSEnumerator *enumerator = [pArr reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

- (NSString *)convertJsonToAddress:(NSDictionary *)areaDict {
    NSString *ret = nil;

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:4];
    NSString *pName = nil;
    for (NSDictionary *item in areaDict) {
        NSArray *ay = [item objectForKey:@"types"];
        NSString *t1 = [ay objectAtIndex:0];

        if ([t1 isEqualToString:@"locality"]) {
            pName = [item objectForKey:@"short_name"];
            pName = [NSString stringWithFormat:@"%@市", pName];
            [dict setObject:pName forKey:[NSNumber numberWithInt:0]];
        } else if ([t1 isEqualToString:@"sublocality"]) {
            pName = [item objectForKey:@"short_name"];
            [dict setObject:pName forKey:[NSNumber numberWithInt:1]];
        } else if ([t1 isEqualToString:@"route"]) {
            pName = [item objectForKey:@"short_name"];
            [dict setObject:pName forKey:[NSNumber numberWithInt:2]];
        } else if ([t1 isEqualToString:@"street_number"]) {
            pName = [item objectForKey:@"short_name"];
            [dict setObject:pName forKey:[NSNumber numberWithInt:3]];
        }
    }
    NSArray *sortedKeys = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSArray *objects = [dict objectsForKeys:sortedKeys notFoundMarker:[NSNull null]];

    if (objects) {
        ret = [objects componentsJoinedByString:@""];
    }
    return ret;
}

- (void)doGetGetAddressByCoordinate:(NSDictionary *)dict {
    NSString *status = [dict objectForKey:@"status"];
    TBGpsAddressVo *ta = [[TBGpsAddressVo alloc] init];
    ta.addressState = TBGpsAddressStateFail;
    if ([status isEqualToString:@"ZERO_RESULTS"]) {
        [self callAddressByCoordinate:ta];
        return;
    }

    NSArray *arr = [dict objectForKey:@"results"];
    if (![arr isKindOfClass:[NSArray class]]) {
        [self callAddressByCoordinate:ta];
        return;
    }
    if ([arr count] < 1) {
        [self callAddressByCoordinate:ta];
        return;
    }

    NSString *address = nil;
    NSString *cityName = nil;
    @try {
        NSDictionary *ad = [arr objectAtIndex:0];
        address = [ad objectForKey:@"formatted_address"];
        NSDictionary *areaDict = [ad objectForKey:@"address_components"];

        for (NSDictionary *item in areaDict) {
            NSArray *ay = [item objectForKey:@"types"];
            NSString *t1 = [ay objectAtIndex:0];
            if ([t1 isEqualToString:@"locality"]) {
                cityName = [item objectForKey:@"short_name"];
            }
        }
        NSString *str = [self convertJsonToAddress:areaDict];
        if (str) {
            address = str;
        }
    }
    @catch (NSException *exception) {

    }
    @finally {

    }
    if (address == nil) {
        [self callAddressByCoordinate:ta];
        return;
    }

    ta.addressState = TBGpsAddressStateSuccess;
    ta.address = address;
    ta.cityName = cityName;
    [self callAddressByCoordinate:ta];
}

- (void)coordinateByAddressCallback:(NSDictionary *)params {
    SEL sel = @selector(getCoordinateByAddressFinish:);
    if (self.delegate && [self.delegate respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.delegate performSelector:sel withObject:params];
#pragma clang diagnostic pop
    }
}

- (void)doGetCoordinateByAddress:(NSDictionary *)dict {
    NSArray *qret = [dict objectForKey:@"Placemark"];
    NSString *lat = @"0";
    NSString *lon = @"0";
    if (!qret || [qret count] < 1) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:lat, @"latitude", lon, @"longitude", nil];
        [self coordinateByAddressCallback:params];
        return;
    }

    NSDictionary *ad = [qret objectAtIndex:0];
    ad = [ad objectForKey:@"Point"];

    NSArray *ctArr = [ad objectForKey:@"coordinates"];
    if (!ctArr || [ctArr count] < 2) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:lat, @"latitude", lon, @"longitude", nil];
        [self coordinateByAddressCallback:params];
        return;
    }
    lat = [ctArr objectAtIndex:1];
    lon = [ctArr objectAtIndex:0];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:lat, @"latitude", lon, @"longitude", nil];
    [self coordinateByAddressCallback:params];
}

- (void)requestFinished:(TBASIFormDataRequest *)requestx {
    TBASIFormDataRequest *request = (TBASIFormDataRequest *) requestx;
    BOOL isError = [self isResponseDidNetworkError:request];
    if (isError) {
        ASIDownloadCache *sharedCache = [ASIDownloadCache sharedCache];
        [sharedCache removeCachedDataForURL:request.url];
        return;
    }
    NSString *ret = [request responseString];
    ret = [ret trim];

    NSDictionary *dict = nil;
    @try {
        dict = [ret JSONValue];
    }
    @catch (NSException *exception) {
        dict = [NSDictionary dictionary];
    }
    if (dict == nil) {
        dict = [NSDictionary dictionary];
    }
    switch (request.serviceMethodFlag) {
        case APILBSGetAddressByCoordinateGoogle:
            [self doGetGetAddressByCoordinate:dict];
            break;
        case APILBSGetCoordinateByAddressGoogle:
            [self doGetCoordinateByAddress:dict];
            break;
        default:
            break;
    }
    [super requestFinished:request];
}

@end