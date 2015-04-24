//
//  Tao800StartManage.m
//  tao800
//
//  Created by enfeng on 14-2-26.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/TBErrorDescription.h>
#import "Tao800StartManage.h"
#import "Tao800WirelessService.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800ConfigBVO.h"
#import "Tao800ConfigTipBVO.h"
#import "Tao800ConfigManage.h"
#import "Tao800FirstOrderCheckerModel.h"
#import "Tao800BackgroundServiceManage.h"
#import "Tao800StartInfoVo.h"
#import "Tao800DealService.h"
#import "Tao800CookieManager.h"
#import "Tao800NotifycationConstant.h"

#import "TBCore/TBCore.h"

@interface Tao800StartManage ()
@property(nonatomic, strong) Tao800WirelessService *wirelessService;
@property(nonatomic, strong) Tao800DealService *dealService;
@property(nonatomic, strong) Tao800ConfigManage *configManage;
@property(nonatomic, strong) Tao800FirstOrderCheckerModel *firstOrderChecker;


/**
* 获取wapUrl处理策略
* 如 淘宝跳转等的处理
*/
- (void)loadWapUrlStrategy;

/**
* 获取启动图
*/
- (void)loadStartImage;

/**
* 获取首页开机广告图
*/
- (void)loadStartBanner;

@end

@implementation Tao800StartManage

- (id)init {
    self = [super init];
    if (self) {
        self.wirelessService = [[Tao800WirelessService alloc] init];
        self.dealService = [[Tao800DealService alloc] init];
        self.configManage = [[Tao800ConfigManage alloc] init];
        _firstOrderChecker = [[Tao800FirstOrderCheckerModel alloc] init];
    }
    return self;
}

- (void)loadStartData {
    [self loadRemoteConfig];
    [self loadWapUrlStrategy];
//    [self loadStartImage]; //不需要启动图
    [self loadStartBanner];
}

- (void)loadRemoteConfig {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];

    NSDictionary *dict = @{
            @"product" : dm.product,
            @"platform" : dm.platform,
            @"trackid" : dm.partner,
            @"cityid" : dm.city.cityId,
    };
    [self.wirelessService getConfigs:dict
                         completioin:^(NSDictionary *ret) {
                             Tao800ConfigBVO *configBVO = ret[@"item"];
                             dm.configBVO = configBVO;

                             //todo temp 兼容
                             dm.isClearTaobaoCookie = configBVO.configTipBVO.isClearTaobaoCookie;
                             dm.tao800OutClose = configBVO.configTipBVO.tao800OutClose;
                             dm.tao800CloseLoginUrl = configBVO.configTipBVO.tao800CloseLoginUrl;
                             dm.tao800OutProtocol = configBVO.configTipBVO.tao800OutProtocol;
                             dm.isShowPreviewDealButton = configBVO.configTipBVO.isShowPreviewDealButton;
                             dm.showPreviewDealTime = configBVO.configTipBVO.showPreviewDealTime;
                             dm.weixinScore = configBVO.configTipBVO.weixinScore;
                             dm.isShowPhoneRechargeButton = configBVO.configTipBVO.isShowPhoneRechargeButton;
                             dm.showFirstOrderEntry = configBVO.configTipBVO.showFirstOrderEntry;
                             dm.firstOrderUrl = configBVO.configTipBVO.firstOrderUrl;
                             
                             [Tao800CookieManager autoRemoveCookie];
                             
                             [self.firstOrderChecker checkFirstOrderState];
                             
                             [[NSNotificationCenter defaultCenter] postNotificationName:Tao800CheckConfigDidFinishedNotifycation
                                                                                 object:nil
                                                                               userInfo:nil];
                         }
                              failue:^(TBErrorDescription *error) {
                              }];
}

- (void)loadNewRemoteConfig{
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    
    NSDictionary *dict = @{
                           @"keys" : @"tao800.im.customerservice.switch",
                           @"product" : dm.product,
                           @"platform" : dm.platform,
                           @"trackid" : dm.partner,
                           @"version" :dm.currentVersion,
                           @"minversion" :@"0"//暂时传0
                           };
    [self.wirelessService getNewConfigs:dict
                            completioin:^(NSDictionary *dic) {
        
                            } failue:^(TBErrorDescription *error) {
        
                            }];
}

- (void)loadWapUrlStrategy {

    [self.wirelessService getTaoBaoURLFilterStrategy:nil
                                         completioin:^(NSDictionary *params) {
                                             NSDictionary *dict = params[@"sites"];
                                             if (dict) {
                                                 [Tao800DataModelSingleton sharedInstance].urlFilterDict = params;
                                             }
                                         } failue:^(TBErrorDescription *errorDescription) {

    }];
}

- (void)loadStartImage {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];

    NSDictionary *dict = @{
            @"productkey" : dm.product,
            @"platform" : dm.platform,
            @"channelid" : dm.partner,
            @"cityid" : dm.city.cityId,
            @"startType" : @"0",
    };

    __weak Tao800ConfigManage *configInstance = self.configManage;

    [self.wirelessService getBannersOfStart:dict
                                completioin:^(NSDictionary *ret) {
                                    NSArray *items = ret[@"items"];

                                    if (items.count > 0) {
                                        Tao800StartInfoVo *startInfoVo = [items objectAtIndex:0];
                                        [[Tao800BackgroundServiceManage sharedInstance] downloadImage:startInfoVo.normalImageUrl];
                                        [[Tao800BackgroundServiceManage sharedInstance] downloadImage:startInfoVo.bigImageUrl];
                                        [configInstance saveStartImageDatas:items];
                                    }
                                }
                                     failue:^(TBErrorDescription *error) {
                                     }];
}

- (void)loadStartBanner {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];

    NSDictionary *dict = @{
            @"productkey" : dm.product,
            @"platform" : dm.platform,
            @"channelid" : dm.partner,
            @"cityid" : dm.city.cityId,
            @"startType" : @"1",
    };

    __weak Tao800ConfigManage *configInstance = self.configManage;

    [self.wirelessService getBannersOfStart:dict
                                completioin:^(NSDictionary *ret) {
                                    NSArray *items = ret[@"items"];
                                    if (items.count > 0) {
                                        Tao800StartInfoVo *startInfoVo = [items objectAtIndex:0];

                                        UIImage *image =[[TBURLCache sharedCache] imageForURL:startInfoVo.normalImageUrl fromDisk:YES];
                                        if (!image) {
                                           [[Tao800BackgroundServiceManage sharedInstance] downloadImage:startInfoVo.normalImageUrl];
                                        }
                                        image =[[TBURLCache sharedCache] imageForURL:startInfoVo.bigImageUrl fromDisk:YES];
                                        if (!image) {
                                            [[Tao800BackgroundServiceManage sharedInstance] downloadImage:startInfoVo.bigImageUrl];
                                        }
                                        [configInstance saveStartBigBannerData:items];
                                    }
                                }
                                     failue:^(TBErrorDescription *error) {
                                     }];
}


@end
