//
// Created by enfeng on 12-12-12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TBUI/TBUI.h"
#import "TBUI/TBImageViewDelegate.h"

typedef void(^UserDidClickOneItem)(int bannerIndex, int bannerId); //第一个参数是点击的banner的顺序，第二个参数是bannerId

@interface Tao800HomeBannerView : TBUICycleScrollView <TBUICycleScrollViewDataSource,
        TBUICycleScrollViewDelegate, TBImageViewDelegate> {
    NSArray *_bannerArray;
    NSTimer *_nsTimer;
    int _bannerTimeInterval;
    CGFloat _pageSpacing;
    NSMutableDictionary *_urlDict;
}
@property(nonatomic, retain) NSArray *bannerArray;
@property(nonatomic, retain) NSTimer *nsTimer;
@property(nonatomic) int bannerTimeInterval;
@property(nonatomic) CGFloat pageSpacing;
@property (nonatomic, copy) UserDidClickOneItem userDidClickOneItem;

@property(nonatomic) BOOL loadRemoteImageEnabled; //是否可以加载远程图片

/**
 * 支持滚动
 */
- (void)startTimer;

- (void)stopTimer;

- (void) initData;

- (void)reloadBanner;

- (void)fireTimer:(NSTimer *)theTimer;
@end