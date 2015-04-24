//
//  Tao800BannerDataSource.h
//  tao800
//
//  Created by enfeng on 14/12/8.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TBUI/TBUICycleScrollView.h>
#import <TBUI/TBImageViewDelegate.h>

@interface Tao800BannerDataSource : NSObject<TBUICycleScrollViewDataSource, TBImageViewDelegate>

@property (nonatomic) CGSize bannerSize;
@property(nonatomic, retain) NSArray *bannerArray;
@property(nonatomic) BOOL loadRemoteImageEnabled; //是否可以加载远程图片

@property (nonatomic, strong) NSMutableDictionary *urlDict;

@property (nonatomic, weak) TBUICycleScrollView *cycleScrollView;
@end
