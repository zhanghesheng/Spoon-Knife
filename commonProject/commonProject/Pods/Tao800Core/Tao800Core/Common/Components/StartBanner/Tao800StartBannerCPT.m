//
//  Tao800StartBannerCPT.m
//  tao800
//
//  Created by enfeng on 14/12/12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800StartBannerCPT.h"
#import "TBUI/TBUI.h"
#import "Tao800ConfigManage.h"
#import "Tao800StartInfoVo.h"
#import "Tao800FunctionCommon.h"
#import "Tao800StartBannerVCL.h"
#import "Tao800ForwardSegue.h"

@implementation Tao800StartBannerCPT

+ (void)displayOn:(TBBaseViewCTL *)targetController closeCallback:(TBBGoBackBlock) closeCallback {

    //判断是否有开机广告图数据及广告图片是否下载
    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    NSArray *array = [configManage getStartBigBannerData];
    if (array.count > 0) {
        Tao800StartInfoVo *startInfoVo = array[0];
        UIImage *image = nil;
        // 判断是否是iphone5分辨率
        if (TBIsAfterIphone4()) {
            image = [[TBURLCache sharedCache] imageForURL:startInfoVo.bigImageUrl];
        } else {
            image = [[TBURLCache sharedCache] imageForURL:startInfoVo.normalImageUrl];
        }
        //如果数据没有过期并且图片已经加载
        if (image && !CompareDateIsSmall(startInfoVo.expireTime)) {

            Tao800StartBannerVCL *startBannerVCL = [Tao800ForwardSegue
                    LoadViewControllerFromStoryboard:@"Tao800StartBanner"
                                     classIdentifier:@"Tao800StartBannerVCL"];
            [startBannerVCL setParameters:@{
                    @"startInfoVo" : startInfoVo,
                    @"image" : image
            }];
            [targetController.window addSubview:startBannerVCL.view];

            [targetController addChildViewController:startBannerVCL];

            startBannerVCL.goBackBlock = closeCallback;
        } else {
            closeCallback(YES, nil);
        }
    } else {
        closeCallback(YES, nil);
    }

}
@end
