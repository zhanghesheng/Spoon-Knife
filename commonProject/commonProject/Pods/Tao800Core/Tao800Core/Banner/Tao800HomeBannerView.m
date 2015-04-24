//
// Created by enfeng on 12-12-12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Tao800HomeBannerView.h"
#import "Tao800HomeBannerItemView.h"
#import "TBCore/TBCore.h"
#import "Tao800ForwardSingleton.h"
#import "Tao800BackgroundServiceManage.h"
#import "Tao800NotifycationConstant.h"

//static const CGFloat PaddingLeft = 10;

@interface Tao800HomeBannerView ()
- (void)fireTimer:(NSTimer *)theTimer;

@property (nonatomic, assign) BOOL dragging;
@end

@implementation Tao800HomeBannerView {

}
@synthesize bannerArray = _bannerArray;
@synthesize nsTimer = _nsTimer;
@synthesize bannerTimeInterval = _bannerTimeInterval;
@synthesize pageSpacing = _pageSpacing;

- (NSString *)getUrlKey:(NSString *)urlString {
    return [urlString md5];
}

- (void)imageView:(TBImageView *)imageView didLoadImage:(UIImage *)image {
    if (image == nil) {
        return;
    }


    NSString *urlKey = [self getUrlKey:imageView.urlPath];
    //    TBDPRINT(">>>>>>>>....didLoadImage.....%@ %@", urlKey, imageView.imageUrlPath);

    if (urlKey == nil) {
        return;
    }
    [_urlDict setObject:image forKey:urlKey];
    NSArray *sViews = self.scrollView.subviews;
    for (UIView *v1 in sViews) {
        if ([v1 isKindOfClass:[Tao800HomeBannerItemView class]]) {
            Tao800HomeBannerItemView *vv = (Tao800HomeBannerItemView *) v1;
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

- (void)setBannerArray:(NSArray *)bannerArray {
    if (self.dragging) {
        //用户正在滑动，此时不做处理
        return;
    }

    if (_animating) {
        return;
    }
    [self stopTimer];
    self.scrollView.userInteractionEnabled = NO;
    [_urlDict removeAllObjects];
    if (bannerArray == nil || bannerArray.count <= 0) {
        return;
    }

    _bannerArray = bannerArray;
    if (self.bannerArray && self.bannerArray.count > 0) {
//        Tao800BannerVo *advert = [self.bannerArray objectAtIndex:0];
        _bannerTimeInterval = 5;
    } else {
        _bannerTimeInterval = 4;
    }

    if (_bannerArray.count<=1) {
        _pageControl.hidden = YES;
    } else {
        _pageControl.hidden = NO;
    }

    self.currentPage = 0;
    [self reloadData];
    self.scrollView.userInteractionEnabled = YES;
    [self startTimer];
}

//banner图片为一时，重载banner
- (void)reloadBanner
{
    if (_bannerArray &&[_bannerArray count] == 1) {
        [self reloadData];
    }
}

#pragma mark -------banner delegate
- (NSInteger)numberOfPagesInScrollView:(TBUICycleScrollView *)scrollView {

    if (self.bannerArray == nil) {
        return 1;
    }
    return [self.bannerArray count];
}

- (void)cycleScrollView:(TBUICycleScrollView *)scrollView didClickPageAtIndex:(NSInteger)index {
    if (self.bannerArray == nil || [self.bannerArray count] == 0) {
        return;
    }else {
        Tao800BannerVo *vo = [self.bannerArray objectAtIndex:index];
        if (!vo.bannerId) {
            return;
        }
        
        if (self.userDidClickOneItem) {
            self.userDidClickOneItem((int)index, [vo.bannerId intValue]);
        }

        [[Tao800ForwardSingleton sharedInstance] bannerForward:vo openByModel:YES bannerAtIndex:(int)index];
    }
}

- (TBUICycleScrollSubView *)scrollView:(TBUICycleScrollView *)scrollView pageAtIndex:(NSInteger)pageIndex {

    static NSString *identifier = @"bannerView";
    Tao800HomeBannerItemView *pageView = (Tao800HomeBannerItemView *) [scrollView dequeueReusablePage:identifier];
    if (!pageView) {
        pageView = [[Tao800HomeBannerItemView alloc]
                initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
              reuseIdentifier:identifier];
        pageView.pageSpacing = _pageSpacing;
        pageView.imageView.delegate = self;
    }

    if (self.bannerArray != nil && [self.bannerArray count] > 0) {
        pageView.bannerVo = [self.bannerArray objectAtIndex:
                (uint) pageIndex];

        NSString *urlKey = [self getUrlKey:pageView.bannerVo.imageBigUrl];
        NSObject *obj = [_urlDict objectForKey:urlKey];

        BOOL needResetImage = NO;
        if (obj) {

            //不做重复的图片请求
            if ([obj isKindOfClass:[UIImage class]]) {
                [pageView.imageView unsetImage];
                pageView.imageView.urlPath = nil;
                pageView.imageView.defaultImage = nil;
                pageView.imageView.defaultImage = (UIImage *) obj;
            } else {
                needResetImage = YES;
            }
        } else {
            needResetImage = YES;
            if (urlKey) {
               [_urlDict setObject:pageView.bannerVo.imageBigUrl forKey:urlKey];
            } 
        }
        if (needResetImage) {
            [pageView.imageView unsetImage];
            pageView.imageView.defaultImage = TBIMAGE(@"bundle://common_banner_default@2x.png");
            
            //图片下载走后台队列 TBBBackgroundServiceSingleton#downloadImage
            UIImage *image = TBIMAGE(pageView.bannerVo.imageBigUrl);
            if (image) {
                pageView.imageView.defaultImage = image;
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

- (void)cycleScrollViewWillBeginDragging:(TBUICycleScrollView *)scrollView {
    self.dragging = YES;
    [self stopTimer];
}

- (void)cycleScrollViewDidEndDragging:(TBUICycleScrollView *)scrollView willDecelerate:(BOOL)willDecelerate {
    self.dragging = NO;
    [self startTimer];
}

- (void) initData {
    _urlDict = [[NSMutableDictionary alloc] initWithCapacity:10];
    _bannerTimeInterval = 4;
    
    self.delegate = self;
    self.dataSource = self;
    
    self.pageControl.activeImage = TBIMAGE(@"bundle://home_dot_white@2x.png");
    self.pageControl.inactiveImage = TBIMAGE(@"bundle://home_dot_red@2x.png");
    
    self.scrollView.scrollsToTop = NO;
    
    _pageControl.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBanner) name:Tao800BackgroundServiceDownImageFinish object:nil];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rect = self.bounds;
    rect.origin.y = rect.size.height - 20;
    rect.size.height = 20;

    CGFloat width = (self.pageControl.numberOfPages + 1) * 16;
    rect.size.width = width;
    rect.origin.x = (self.width - rect.size.width) / 2;
    self.pageControl.frame = rect;
}

- (void) dealloc {
    if (self.nsTimer) {
        [self.nsTimer invalidate];
        self.nsTimer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        CGRect rect = self.frame;
        self = [self initWithFrame:rect];
    }
    return self;
}

- (void)stopTimer {
    if (self.nsTimer) {
        [self.nsTimer invalidate];
        self.nsTimer = nil;
    } else {
        //todo
        return;
    } 
}

- (void)startTimer {
    if (self.nsTimer) {
        [self.nsTimer invalidate];
    }
    //少于一条不用轮询
    if (self.bannerArray == nil || self.bannerArray.count < 2) {
        _scrollView.scrollEnabled = NO;
        return;
    }
    _scrollView.scrollEnabled = YES;
    self.nsTimer = [NSTimer scheduledTimerWithTimeInterval:_bannerTimeInterval
                                                    target:self
                                                  selector:@selector(fireTimer:)
                                                  userInfo:nil repeats:YES];
}

- (void)fireTimer:(NSTimer *)theTimer {
    int count = (uint) [self.bannerArray count];
    int tMax = count - 1;
    if (self.currentPage > tMax) {
        self.currentPage = 0;
    }
    int inx = (int) self.currentPage;
    if (inx < tMax) {
        inx++;
    } else {
        inx = 0;
    }
    [self setCenterPageIndex:inx oldIndex:self.currentPage animated:YES];
}

@end