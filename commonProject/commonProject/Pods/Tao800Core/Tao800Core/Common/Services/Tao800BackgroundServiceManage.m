//
// Created by enfeng on 13-7-17.
// Copyright (c) 2013 enfeng. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Tao800BackgroundServiceManage.h"
#import "TBNetwork/TBNetwork.h"
#import "TBNetwork/ASIHTTPRequest.h"
#import "TBUI/TBUICommon.h"
#import "TBCore/TBCore.h"
#import "Tao800BackServiceOperation.h"
#import "Tao800NotifycationConstant.h"

static Tao800BackgroundServiceManage *_instance;

@interface Tao800BackgroundServiceManage ()

@property(nonatomic, strong) NSMutableDictionary *imageDict; //保存正在下载的图片路径
@end

@implementation Tao800BackgroundServiceManage {

}

- (id)init {
    self = [super init];
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:1]; //顺序执行

        self.imageDict = [[NSMutableDictionary alloc] init];

        _imageDownloadQueue = [[NSOperationQueue alloc] init];
        [_imageDownloadQueue setMaxConcurrentOperationCount:3];
    }

    return self;
}

- (BOOL)isContainOperationFlag:(TNOperationFlag)operationFlag {
    NSArray *operations = _queue.operations;
    if (operations == nil || operations.count < 1) {
        return NO;
    }

    for (Tao800BackServiceOperation *operation in operations) {
        if (operation.operationFlag == operationFlag) {
            return YES;
        }
    }

    return NO;
}

- (void)addOperation:(TNOperationFlag)operationFlag {
    @synchronized (self) {
        BOOL exist = [self isContainOperationFlag:operationFlag];
        if (exist) {
            return;
        }

        Tao800BackServiceOperation *operation4 = [[Tao800BackServiceOperation alloc] init];
        operation4.operationFlag = operationFlag;
        [_queue addOperation:operation4];
    }
}

- (void)autoLogin {

}

-(void)addLocalFavoriteDeals{
    [self addOperation:TNOperationFlagAddLocalDeals];
}

-(void)addLocalFavoriteShops{
    [self addOperation:TNOperationFlagAddLocalShops];
}

- (void)loadFavoriteDealIds {
    [self addOperation:TNOperationFlagGetFavoriteDealIds];
}

- (void)loadFavoriteShopIds {
    [self addOperation:TNOperationFlagGetFavoriteShopIds];
}

- (void)loadOperationModel{
    [self addOperation:TNOperationFlagGetOperationModel];
}

-(void)loadPromotionOperationModel{
    [self addOperation:TNOperationFlagGetPromotionHomeOperationModel];
}

- (void)loadTagsOfRecommend {
    [self addOperation:TNOperationFlagGetTagsOfRecommend];
}

- (void)loadTagList{
    [self addOperation:TNOperationFlagGetListTag];
}

+ (id)sharedInstance {
    static Tao800BackgroundServiceManage *instance = nil;
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)loadCid {
    [self addOperation:TNOperationFlagGetCid];
}

- (void)downloadImage:(NSString *)imageUrl {

    @synchronized (self) {
        NSString *string = self.imageDict[imageUrl];
        if (string) {
            return;
        }
        BOOL exists = [[TBURLCache sharedCache] hasImageForURL:imageUrl fromDisk:YES];
        if (exists) {
            return;
        }
        if(!imageUrl) {
            return;
        }

        [self.imageDict setValue:imageUrl forKey:imageUrl];

        NSURL *url = [NSURL URLWithString:imageUrl];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(requestDone:)];
        [request setDidFailSelector:@selector(requestWentWrong:)];
        [_imageDownloadQueue addOperation:request];
    }
}

#pragma mark ---下载图片的回调---

- (void)requestDone:(ASIHTTPRequest *)request {
    NSData *response = request.responseData;
    NSString *imageUrlString = request.originalURL.absoluteString;

    dispatch_queue_t mainQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(mainQueue, ^(void) {
        UIImage *image = DataToImage(response);

        if (image == nil) {
            [self.imageDict removeObjectForKey:request.originalURL.absoluteString];
        } else {
            NSData *imageData = UIImagePNGRepresentation(image);
            [[TBURLCache sharedCache] storeImage:image forURL:imageUrlString];
            [[TBURLCache sharedCache] storeData:imageData forURL:imageUrlString];

            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *url2 = request.originalURL.absoluteString;
                [self.imageDict removeObjectForKey:url2];
                //图片保存完成
                [[NSNotificationCenter defaultCenter]
                        postNotificationName:Tao800BackgroundServiceDownImageFinish
                                      object:nil
                                    userInfo:@{@"imageUrl":url2}
                ];
            });
        }
    });
}

- (void)requestWentWrong:(ASIHTTPRequest *)request {
    [self.imageDict removeObjectForKey:request.originalURL.absoluteString];
    //TBDPRINT(@"图片下载失败：%@", request.originalURL);
}


@end