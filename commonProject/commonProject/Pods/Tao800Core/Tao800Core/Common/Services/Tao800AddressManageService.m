//
//  Tao800AddressManageService.m
//  tao800
//
//  Created by LeAustinHan on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800AddressManageService.h"
#import "Tao800AddressListVo.h"
#import "Tao800AddressBVO.h"
#import "TBCore/TBCore.h"
#import "Tao800StaticConstant.h"
#import "TBCore/TBFileUtil.h"
#import "Tao800AddressCityVo.h"
#import "TBUI/TBErrorDescription.h"
#import "Tao800DataModelSingleton.h"


#ifdef DEBUG
NSString *const AddressManageUrlBase = @"http://tbuy.m.zhe800.com";//@"http://buy.m.xiongmaoz.com";
#else
NSString *const AddressManageUrlBase = @"http://tbuy.m.zhe800.com";
#endif

@implementation Tao800AddressManageService

- (void)getAddressList:(NSDictionary *)paramt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/address", AddressManageUrlBase];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramt];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800AddressManageService *instance = self;
    
    [request setCompletionBlock:^{
    
    NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        NSDictionary *meta = nil;
        NSDictionary *objects = nil;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            meta = dict[@"ret"];
            objects = dict[@"data"];
        }
        
        if ([(NSString *)meta intValue] != 0) {
            TBErrorDescription *tbd = [[TBErrorDescription alloc] init];
            tbd.errorCode = [(NSString *)meta intValue];
            tbd.errorMessage = (NSString *)dict[@"msg"];
            failure(tbd);
            return;
        }
        else
        {
            NSArray *array = @[];
            if ([objects isKindOfClass:[NSArray class]]) {
                NSArray *addresslist = (NSArray *) objects;
                array = [Tao800AddressBVO wrapperAddressList:addresslist];
            }
            
            NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            array, @"items",
                                            nil];
            if(meta != nil){
                [retDict setObject:meta forKey:@"ret"];
            }
            completion(retDict);
        }
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}


- (void)getAddressDetail:(NSDictionary *)paramt
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@/address/queryAddressById", AddressManageUrlBase];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramt];
    [Tao800AddressBVO addUserInfo:params];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800AddressManageService *instance = self;
    
    [request setCompletionBlock:^{
        
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = nil;
        NSDictionary *objects = nil;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            meta = dict[@"ret"];
            objects = dict[@"data"];
        }
        
        if ([(NSString *)meta intValue] != 0) {
            TBErrorDescription *tbd = [[TBErrorDescription alloc] init];
            tbd.errorCode = [(NSString *)meta intValue];
            tbd.errorMessage = (NSString *)dict[@"msg"];
            failure(tbd);
            return;
        }
        if ([objects isKindOfClass:[NSDictionary class]]) {
            Tao800AddressListVo *vo = [Tao800AddressBVO wrapperAddressVo:objects];
            NSDictionary *retDict = @{@"items" : vo};
            completion(retDict);
        }
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];

}

//新增收货地址接口
- (void)addAddress:(NSDictionary *)paramt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure{

    NSString *urlString = [NSString stringWithFormat:@"%@/address/add", AddressManageUrlBase];
    NSURL *url = [NSURL URLWithString:urlString];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramt];
    [Tao800AddressBVO addUserInfo:params];
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800AddressManageService *instance = self;
    
    [self wrapperPostRequest:params request:request];
    
    [request setCompletionBlock:^{
        NSDictionary *dic = [instance getResponseJsonResult:pRequest];
        if (!dic) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        NSDictionary *meta = nil;
        NSDictionary *objects = nil;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            meta = dic[@"ret"];
            objects = dic[@"data"];
        }
        
        if ([(NSString *)meta intValue] != 0) {
            TBErrorDescription *tbd = [[TBErrorDescription alloc] init];
            tbd.errorCode = [(NSString *)meta intValue];
            tbd.errorMessage = (NSString *)dic[@"msg"];
            failure(tbd);
            return;
        }
        completion(dic);
        
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}


//修改收货地址接口
- (void)editAddress:(NSDictionary *)paramt
        completion:(void (^)(NSDictionary *))completion
           failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/address/edit", AddressManageUrlBase];
    NSURL *url = [NSURL URLWithString:urlString];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramt];
    [Tao800AddressBVO addUserInfo:params];
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800AddressManageService *instance = self;
    
    [self wrapperPostRequest:params request:request];
    
    [request setCompletionBlock:^{
        NSDictionary *dic = [instance getResponseJsonResult:pRequest];
        if (!dic) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = nil;
        NSDictionary *objects = nil;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            meta = dic[@"ret"];
            objects = dic[@"data"];
        }
        
        if ([(NSString *)meta intValue] != 0) {
            TBErrorDescription *tbd = [[TBErrorDescription alloc] init];
            tbd.errorCode = [(NSString *)meta intValue];
            tbd.errorMessage = (NSString *)dic[@"msg"];
            failure(tbd);
            return;
        }

        completion(dic);
        
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}

- (void)getDefaultAddress:(NSDictionary *)paramt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/address/default", AddressManageUrlBase];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramt];
    [Tao800AddressBVO addUserInfo:params];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800AddressManageService *instance = self;
    
    
    [request setCompletionBlock:^{
        
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = nil;
        NSDictionary *objects = nil;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            meta = dict[@"ret"];
            objects = dict[@"data"];
        }
        
        if ([(NSString *)meta intValue] != 0) {
            TBErrorDescription *tbd = [[TBErrorDescription alloc] init];
            tbd.errorCode = [(NSString *)meta intValue];
            tbd.errorMessage = (NSString *)dict[@"msg"];
            failure(tbd);
            return;
        }
        completion(dict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}


- (void)getDeleteAddress:(NSDictionary *)paramt
               completion:(void (^)(NSDictionary *))completion
                  failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/address/delete", AddressManageUrlBase];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramt];
    [Tao800AddressBVO addUserInfo:params];
    
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800AddressManageService *instance = self;
    
    
    [request setCompletionBlock:^{
        
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        NSDictionary *meta = nil;
        NSDictionary *objects = nil;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            meta = dict[@"ret"];
            objects = dict[@"data"];
        }
        
        if ([(NSString *)meta intValue] != 0) {
            TBErrorDescription *tbd = [[TBErrorDescription alloc] init];
            tbd.errorCode = [(NSString *)meta intValue];
            tbd.errorMessage = (NSString *)dict[@"msg"];
            failure(tbd);
            return;
        }
        completion(dict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}


- (void)getCitiesList:(void (^)(NSDictionary *))completion{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // 耗时操作
        NSString *jsonPath = [TBFileUtil getDbFilePath:AddressCityFileName];
        
        NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:jsonPath];
        NSData *data = [fh readDataToEndOfFile];
        
        NSString *aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSMutableArray *arr = (NSMutableArray *)[aStr JSONValue];
        
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:arr.count];
        
        for (NSDictionary *dic in arr) {
            Tao800AddressCityVo *vo = [[Tao800AddressCityVo alloc] init];
            vo.cityId = [dic objectForKey:@"id"];
            vo.name = [dic objectForKey:@"name"];
            vo.parentId = [dic objectForKey:@"parentid"];
            vo.pinyin = [dic objectForKey:@"pinyin"];
            [result addObject:vo];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 任务结束之后
            completion([NSDictionary dictionaryWithObject:result forKey:@"items"]);
        });
    });
}

- (void)getLocationProvince:(void (^)(NSDictionary *))completion{
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    TBCityVo *gpsCityVo = [[TBCityVo alloc] init];
    __block Tao800AddressCityVo *locationProvinceVo = [[Tao800AddressCityVo alloc] init];
    locationProvinceVo.cityId = @"-1";
    locationProvinceVo.name = @"北京";

    if (dm.lbsModel.gpsAddress.cityName) {
        gpsCityVo.name =  dm.lbsModel.gpsAddress.cityName;
    }
    else
    { //若找不到相应的省，则返回北京的id
        if ([locationProvinceVo.cityId isEqualToString:@"-1"]) {
            locationProvinceVo.cityId = @"110000";
        }
        Tao800AddressCityVo *locationCityVo = [[Tao800AddressCityVo alloc] init];
        locationCityVo.cityId = @"110000";
        locationCityVo.name = @"北京";
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:2];
        [dic setValue:locationProvinceVo forKey:@"locationProvince"];
        [dic setValue:locationCityVo forKey:@"locationCity"];
        completion(dic);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // 耗时操作
        NSString *jsonPath = [TBFileUtil getDbFilePath:AddressCityFileName];

        NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:jsonPath];
        NSData *data = [fh readDataToEndOfFile];

        NSString *aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSMutableArray *arr = (NSMutableArray *)[aStr JSONValue];

        NSMutableArray *provinceList = [NSMutableArray arrayWithCapacity:arr.count];
        Tao800AddressCityVo *locationCityVo = [[Tao800AddressCityVo alloc] init];
        locationCityVo.name = gpsCityVo.name;
        locationCityVo.cityId = @"-1";
        //NSMutableArray *cityList = [NSMutableArray arrayWithCapacity:arr.count];
        
        for (NSDictionary *dic in arr) {
            Tao800AddressCityVo *vo = [[Tao800AddressCityVo alloc] init];
            vo.cityId = [dic objectForKey:@"id"];
            vo.parentId = [dic objectForKey:@"parentid"];
            vo.name = [dic objectForKey:@"name"];
            vo.pinyin = [dic objectForKey:@"pinyin"];

            if ([locationCityVo.cityId isEqualToString:@"-1"]&&([vo.name rangeOfString:locationCityVo.name]).length > 0){
                locationCityVo = vo;
            }else if([vo.parentId isEqualToString:@"1"]){
                [provinceList addObject:vo];
            }
            
        }
       
        if ([locationCityVo.parentId isEqualToString:@"1"]) {
            locationProvinceVo = locationCityVo;
        }else if (![locationCityVo.cityId isEqualToString:@"-1"]&&provinceList.count){
            for(Tao800AddressCityVo *vo in provinceList){
                if([vo.cityId isEqualToString:locationCityVo.parentId]){
                    locationProvinceVo = vo;
                    break;
                }
            }
        }
        
        //若找不到相应的省，则返回北京的id
        if ([locationProvinceVo.cityId isEqualToString:@"-1"]) {
            locationProvinceVo.cityId = @"110000";
        }

        if (![locationCityVo.cityId isEqualToString:@"-1"]) {
            
        }else{
            for (NSDictionary *dic in arr) {
                Tao800AddressCityVo *vo = [[Tao800AddressCityVo alloc] init];
                vo.cityId = [dic objectForKey:@"id"];
                vo.parentId = [dic objectForKey:@"parentid"];
                vo.name = [dic objectForKey:@"name"];
                if([vo.parentId isEqualToString:locationProvinceVo.cityId]){
                    locationCityVo = vo;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 任务结束之后
            NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:2];
            [dic setValue:locationProvinceVo forKey:@"locationProvince"];
            [dic setValue:locationCityVo forKey:@"locationCity"];
            completion(dic);
        });
    });
}


@end
