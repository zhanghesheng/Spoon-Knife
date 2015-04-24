//
//  Tao800BannerModel.m
//  tao800
//
//  Created by enfeng on 14/12/8.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BannerModel.h"
#import "Tao800WirelessService.h"

@interface Tao800BannerModel()
@property(nonatomic, strong) Tao800WirelessService *bannerService;
@end

@implementation Tao800BannerModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.bannerService = [[Tao800WirelessService alloc] init];
    }
    return self;
}

- (void)loadItems:(NSDictionary *)params
       completion:(void (^)(NSDictionary *))completion
          failure:(void (^)(TBErrorDescription *))failure {
    __weak Tao800BannerModel *instance = self;

    [self.bannerService removeAllRequestFromArray];

    [self.bannerService getBanners:params
                        completion:^(NSDictionary *dict) {
                            instance.bannerItems = dict[@"items"];
                            completion(dict);
                        }
                           failure:failure];
}

@end
