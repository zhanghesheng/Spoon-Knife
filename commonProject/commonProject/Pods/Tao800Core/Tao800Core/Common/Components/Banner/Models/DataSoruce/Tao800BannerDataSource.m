//
//  Tao800BannerDataSource.m
//  tao800
//
//  Created by enfeng on 14/12/8.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBCore/TBCoreMacros.h>
#import <TBCore/NSString+Addition.h>
#import "Tao800BannerDataSource.h"
#import "Tao800BackgroundServiceManage.h"
#import "Tao800BannerItemView.h"

@interface Tao800BannerDataSource () {

}

@end

@implementation Tao800BannerDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        self.urlDict = [NSMutableDictionary dictionaryWithCapacity:10];
        self.bannerSize = CGSizeMake(50, 40);
    }
    return self;
}

#pragma mark --- TBImageViewDelegate Methods ---

- (NSString *)getUrlKey:(NSString *)urlString {
    return [urlString md5];
}

- (void)imageView:(TBImageView *)imageView didLoadImage:(UIImage *)image {
    if (image == nil) {
        return;
    }


    NSString *urlKey = [self getUrlKey:imageView.urlPath];

    if (urlKey == nil) {
        return;
    }
    self.urlDict[urlKey] = image;
    NSArray *sViews = self.cycleScrollView.subviews;
    for (UIView *v1 in sViews) {
        if ([v1 isKindOfClass:[Tao800BannerItemView class]]) {
            Tao800BannerItemView *vv = (Tao800BannerItemView *) v1;
            if (vv.imageView == imageView) {
                continue;
            }

            if ([vv.bannerVo.imageBigUrl isEqualToString:imageView.urlPath]) {
                vv.imageView.defaultImage = nil;
                vv.imageView.defaultImage = image;
            }
        }
    }
}

#pragma mark --- TBUICycleScrollViewDataSource Methods ---


- (NSInteger)numberOfPagesInScrollView:(TBUICycleScrollView *)scrollView {

    if (self.bannerArray == nil) {
        return 1;
    }
    return [self.bannerArray count];
}

- (TBUICycleScrollSubView *)scrollView:(TBUICycleScrollView *)scrollView pageAtIndex:(NSInteger)pageIndex {
    static NSString *identifier = @"bannerView";
    Tao800BannerItemView *pageView = (Tao800BannerItemView *) [scrollView dequeueReusablePage:identifier];
    if (!pageView) {
        pageView = [[Tao800BannerItemView alloc]
                initWithFrame:CGRectMake(0, 0, self.bannerSize.width, self.bannerSize.height)
              reuseIdentifier:identifier];
        pageView.pageSpacing = 0;
        pageView.imageView.delegate = self;
    }

    if (self.bannerArray != nil && [self.bannerArray count] > 0) {
        pageView.bannerVo = (self.bannerArray)[(uint) pageIndex];

        NSString *urlKey = [self getUrlKey:pageView.bannerVo.imageBigUrl];
        NSObject *obj = self.urlDict[urlKey];

        BOOL needResetImage = NO;
        if (obj) {

            //不做重复的图片请求
            if ([obj isKindOfClass:[UIImage class]]) {
                [pageView.imageView unsetImage];
                pageView.imageView.urlPath = pageView.bannerVo.imageBigUrl;
//                pageView.imageView.defaultImage = nil;
//                pageView.imageView.defaultImage = (UIImage *) obj;
            } else {
                needResetImage = YES;
            }
        } else {
            needResetImage = YES;
            if (urlKey) {
                self.urlDict[urlKey] = pageView.bannerVo.imageBigUrl;
            }
        }
        if (needResetImage) {
            [pageView.imageView unsetImage];
            pageView.imageView.defaultImage = TBIMAGE(@"bundle://common_banner_default@2x.png");

            //图片下载走后台队列 TBBBackgroundServiceSingleton#downloadImage
            UIImage *image = TBIMAGE(pageView.bannerVo.imageBigUrl);
            if (image) {
                pageView.imageView.urlPath = pageView.bannerVo.imageBigUrl;
            } else if (self.loadRemoteImageEnabled) {   //优先加载列表数据
                Tao800BackgroundServiceManage *backgroundServiceManage = [Tao800BackgroundServiceManage sharedInstance];
                [backgroundServiceManage downloadImage:pageView.bannerVo.imageBigUrl];
            }
        }
    } else {
        pageView.imageView.defaultImage = TBIMAGE(@"bundle://common_banner_default@2x.png");
    }

    return pageView;
}
@end
