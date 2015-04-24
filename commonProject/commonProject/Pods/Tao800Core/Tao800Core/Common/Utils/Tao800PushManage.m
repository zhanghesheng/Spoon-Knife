//
//  Tao800PushManage.m
//  tao800
//
//  Created by enfeng on 12-8-29.
//
//

#import "Tao800PushManage.h"
#import "Tao800DataModelSingleton.h"
#import "TBCore/TBCoreMacros.h"

#import "Tao800NotifycationConstant.h"
#import "Tao800UGCSingleton.h"
#import "Tao800LogParams.h"
//#import "Tao800ForwardSingleton.h"
#import "Tao800BaseService.h"
#import "Tao800BannerVo.h"
#import "Tao800ForwardSingleton.h"
#import "Tao800ConfigManage.h"
#import "Tao800ForwardSegue.h"
#import "Tao800WirelessService.h"
#import "Tao800RemotePushBVO.h"


enum {
    PushTypeText = 0,                 //首页
    PushTypeLink = 1,                 //url链接
    PushTypeCategory = 8,             //分类
    PushTypeFanJiFenTongZhi = 20,     //返积分通知
    PushTypeDealDetail = 22,          //商品详情页
    PushTypeZhiDeGuangFenLei = 25,    //值得逛分类
    PushTypeSign = 27,                //签到页
    PushTypeTopicActivity = 28,       //专题
    PushTypeOpenGroupRemind = 31,     //开团提醒
    PushTypeAuctionDeal = 32,         //更高竞拍
    PushTypeZhe800MallOrderDetail = 33, //商城订单详情
    PushTypeBrandProducts = 34,         //某个品牌商品列表
    PushTypeTenProductsEveryDay = 35,   //每日十件
    PushTypeLottery = 36,               //0元抽奖
    PushTypeTopicLock = 37,//
    PushTypeWishList = 38,              //心愿单
    PushTypeMyCoopons = 39,             //我的优惠券
    //PushTypeCampusProducts = 8080,  //!!! 命中到校园目前没有这个需求
};

typedef enum : NSUInteger {
    Tao800PushHomePageTagDefault = 0,
    Tao800PushHomePageTagCoupons = 11,
} Tao800PushPageTagCoupons;

#if DEBUG
NSString *const ZMallOrderUrl = @"http://h5.m.xiongmaoz.com/orders/h5/get_order_detail?order_id=";
#else
NSString* const ZMallOrderUrl =@"http://th5.m.zhe800.com/orders/h5/get_order_detail?order_id=";
#endif

@interface Tao800PushManage ()
@property(nonatomic,copy) NSString *pushID;
@property(nonatomic,assign) int pushType2;
@property(nonatomic)Tao800PushPageTagCoupons pageTag;
@end

static Tao800PushManage * instance = nil;

@implementation Tao800PushManage {

}
@synthesize pushDict = _pushDict;
@synthesize aPNSApi = _aPNSApi;

- (id)init {
    self = [super init];
    if (self) {
        _aPNSApi = [[TBApnsApi alloc] init];
        _aPNSApi.delegate = self;
        _aPNSApi.baseURLApnsProviderAddToken = UrlBase;
        _aPNSApi.baseURLPushLoginLogout = UrlBase;
        self.pageTag = Tao800PushHomePageTagDefault;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleLoginEvent:)
                                                     name:Tao800SettingLoginCTLDidCheckLoginNotifyCation
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+(Tao800PushManage *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Tao800PushManage alloc]init];
    });
    
    return instance;
}

#pragma mark 跳转到wap页面
- (void)forwardToLink:(NSString *)urlStr {
    Tao800BannerVo *vo = [[Tao800BannerVo alloc] init];
    vo.bannerType = [NSNumber numberWithInt:1];
    vo.wapUrl = urlStr;
    vo.pushId = self.pushID;
    vo.exposureRefer = Tao800ExposureReferPush;
    [[Tao800ForwardSingleton sharedInstance] bannerForward:vo openByModel:YES bannerAtIndex:-1];
}

#pragma mark 跳转到商品分类页面
- (void)forwardToCategory:(NSString *)urlName {
    Tao800BannerVo *vo = [[Tao800BannerVo alloc] init];
    vo.bannerType = [NSNumber numberWithInt:2];
    vo.value = urlName;
    vo.dealDetailFrom = Tao800DealDetailFromPush;
    vo.pushId = self.pushID;
    [[Tao800ForwardSingleton sharedInstance] bannerForward:vo openByModel:YES bannerAtIndex:-1];
}

#pragma mark 跳转到商品详情页面
- (void)forwardToDealDetail:(NSString *)dealId {
    Tao800BannerVo *vo = [[Tao800BannerVo alloc] init];
    vo.bannerType = [NSNumber numberWithInt:22];
    vo.value = dealId;
    vo.dealDetailFrom = Tao800DealDetailFromPush;
    vo.pushId = self.pushID;
    [[Tao800ForwardSingleton sharedInstance] bannerForward:vo openByModel:YES bannerAtIndex:-1];
}

#pragma mark 跳转到专题页面
- (void)forwardToTopicActivity:(NSString *)topicId {
    
    Tao800BannerVo *vo = [[Tao800BannerVo alloc] init];
    vo.bannerType = [NSNumber numberWithInt:100];
    vo.value = topicId;
    vo.dealDetailFrom = Tao800DealDetailFromPush;
    vo.pushId = self.pushID;
    vo.exposureRefer = Tao800ExposureReferPush;
    [[Tao800ForwardSingleton sharedInstance] bannerForward:vo openByModel:YES bannerAtIndex:-1];
}

#pragma mark 跳转到专题页面
- (void)forwardToTopicLockActivity:(NSString *)topicId {
    
    Tao800BannerVo *vo = [[Tao800BannerVo alloc] init];
    vo.bannerType = [NSNumber numberWithInt:370];
    vo.value = topicId;
    vo.dealDetailFrom = Tao800DealDetailFromPush;
    vo.pushId = self.pushID;
    [[Tao800ForwardSingleton sharedInstance] bannerForward:vo openByModel:YES bannerAtIndex:-1];
}

#pragma mark 跳转到值得逛商品分类页面
- (void)forwardToZhiDeGuangFenLei:(NSString *)tagId {
    Tao800BannerVo *vo = [[Tao800BannerVo alloc] init];
    vo.bannerType = [NSNumber numberWithInt:8];
    vo.value = tagId;
    vo.dealDetailFrom = Tao800DealDetailFromPush;
    vo.pushId = self.pushID;
    [[Tao800ForwardSingleton sharedInstance] bannerForward:vo openByModel:YES bannerAtIndex:-1];
}

#pragma mark 跳转到签到页面
- (void)forwardToSign {
    Tao800BannerVo *vo = [[Tao800BannerVo alloc] init];
    vo.bannerType = [NSNumber numberWithInt:5];
    vo.pushId = self.pushID;
    [[Tao800ForwardSingleton sharedInstance] bannerForward:vo openByModel:YES bannerAtIndex:-1];
}

#pragma mark 打开开卖提醒页面中的开团提醒选项
- (void)forwardToOpenGroupRemindPage {
    [[Tao800ForwardSingleton sharedInstance] openMyRemindPage:@{@"selectedSegmentIndex": @"1"}];
}

#pragma mark 跳转到拍卖详情页面
- (void)forwardToAuctionDetail:(NSString *)id {
    if (![self getCurrentRootViewController]) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:id, @"urlName", nil];
        [[Tao800ForwardSingleton sharedInstance] openScoreAuctionDetailPage:dict];
    }
}

#pragma mark 跳转到zhe800商城订单详情
-(void)forwardToZMallOrderDetail:(NSDictionary *)dict{
    NSString *title = @"";
    NSString *orderId = dict[@"u"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", ZMallOrderUrl, orderId];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionaryWithCapacity:2];
    [dict2 setValue:urlStr forKey:@"url"];
    [dict2 setValue:title forKey:@"title"];
    [dict2 setValue:@"TBBWebViewCTL@Tao800InteractionWapWebVCL" forKey:TBBForwardSegueIdentifierKey];
    
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    if(dm.user==nil || dm.user.userId==nil){
        [dict2 setValue:@(YES) forKey:@"isreload"];
        [dict2 setValue:@(YES) forKey:@"loginFirst"];
        [[Tao800ForwardSingleton sharedInstance] openLoginPage:dict2 completion:^(NSDictionary *dictx){}];
    }else{
        [[Tao800ForwardSingleton sharedInstance] openPage:dict2 completion:^(NSDictionary *dictx) {}];
    }
}

#pragma mark 切换到品牌团
-(void)forwardToBrandProducts{
    //NSDictionary * theDic = self.pushDict;
    
    //应该在这里发个通知
    [[NSNotificationCenter defaultCenter] postNotificationName:Tao800ChangeToBrandPageRemoteNotification object:nil userInfo:nil];
}

#pragma mark 每日十件商品列表
-(void)forwardToTenProductsEveryDay:(NSString *)pushId{
    //只可能是走客户端 不可以能网页，因为网页的话 自然就走网页的push了。
    [[Tao800ForwardSingleton sharedInstance] openTenProductsEverydayPage:pushId];
}

#pragma mark 0元抽奖
-(void)forwardToLottery{
    NSString *lotteryId = [self.pushDict objectForKey:@"u"];
    if(lotteryId!=nil && lotteryId.length>0){
        //注意lotteryId需要增加 @"useId":@"" 才管用否责调用不依赖id的本期抽奖接口
        NSDictionary *dict = @{TBBForwardSegueIdentifierKey : @"Lottery@Tao800LotteryScrollPageVCL ",
                               @"lotteryId" : lotteryId,@"useId":@""};
        [Tao800ForwardSegue ForwardTo:dict sourceController:[Tao800ForwardSingleton sharedInstance].navigationController];
    }
}

- (void)forwardToWishList {
    //点击许愿 来源：个人中心
    [[Tao800UGCSingleton sharedInstance] paramsLog:Event_Wishc params:@{Event_Wishc_S : @"3"}];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Tao800HeartWish@Tao800HeartWishListVCL", TBBForwardSegueIdentifierKey,
                          self.pushID,@"cId",@(Tao800DealDetailFromPush),@"pageFrom",
                          nil];
    [Tao800ForwardSegue ForwardTo:dict sourceController:[Tao800ForwardSingleton sharedInstance].navigationController];
}

- (void)openLoginPage {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    if (!dm.user.userId) {
        [[Tao800ForwardSingleton sharedInstance] openLoginPage:nil];
    }
    
}

-(void)forwardToMyCoopons {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    if (dm.user == nil || dm.user.userId == nil) {
        [self openLoginPage];
        self.pageTag = Tao800PushHomePageTagCoupons;
        return;
    }
    
#ifdef DEBUG
    NSURL *url = [NSURL URLWithString:@"http://h5.m.xiongmaoz.com/h5/coupons/my"];
#else
    NSURL *url = [NSURL URLWithString:@"http://th5.m.zhe800.com/h5/coupons/my"];
    //H5测试用
    //NSURL *url = [NSURL URLWithString:@"http://static.m.zhe800.com/ms/zhe800h5/app/demo/callnative.html"];
#endif
    /*
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"TBBWebViewCTL@Tao800WebVCL", TBBForwardSegueIdentifierKey,
                          @"YES", TBNavigationCTLIsModelKey,
                          url, @"url",
                          nil];
     */
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Tao800DealDetail@Tao800DealDetailOurWebVCL", TBBForwardSegueIdentifierKey,
                          @"YES", TBNavigationCTLIsModelKey,
                          url, @"url",
                          nil];
    [Tao800ForwardSegue ForwardTo:dict sourceController:[Tao800ForwardSingleton sharedInstance].navigationController];
}

- (void)handleLoginEvent:(NSNotification *)nt {
    SEL sel = nil;
    if (self.pageTag == Tao800PushHomePageTagCoupons) {
        //[self forwardToMyCoopons];
        sel = @selector(forwardToMyCoopons);
        [self performSelector:sel withObject:nil afterDelay:.7];
        [self performSelector:@selector(resetPagTag) withObject:nil afterDelay:.9];
    }
}

- (void)resetPagTag {
    self.pageTag = Tao800PushHomePageTagDefault;
}
/*
#pragma mark 校园专区商品列表
-(void)forwardToCampusProducts{
    [[Tao800ForwardSingleton sharedInstance] openCampusProductsPage:nil];
}*/

#pragma mark -
- (BOOL)getCurrentRootViewController {

    UIViewController *result = [[UIViewController alloc] init];

    // Try to find the root view controller programmically

    // Find the top window (that is not an alert view or other window)

    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];

    if (topWindow.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];

        for (topWindow in windows) {
            if (topWindow.windowLevel == UIWindowLevelNormal)

                break;

        }

    }

    UIView *rootView = [[topWindow subviews] objectAtIndex:0];

    id nextResponder = [rootView nextResponder];

    if ([nextResponder isKindOfClass:[UIViewController class]])

        result = nextResponder;

    else if (topWindow.rootViewController != nil && [topWindow respondsToSelector:@selector(rootViewController)])

        result = topWindow.rootViewController;

    else

            NSAssert(NO, @"ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");

    return NO;
}

#pragma mark 显示push
- (void)showPush:(NSDictionary *)userInfo active:(BOOL)applicationIsActive {
//    NSLog(@"pushinfo=%@",userInfo);

    //删除应用图标上的数据
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:0];

    NSDictionary *apsDict = [userInfo objectForKey:@"aps"];
    NSString *alertString = [apsDict objectForKey:@"alert"];


    NSNumber *paramType = [userInfo objectForKey:@"p"]; // 参数p的意义 0：首页，1：wapUrl，8：分类
    NSString *paramValue = [userInfo objectForKey:@"u"];
    NSString *pushId = [userInfo objectForKey:@"i"];    //pushid
    if (!pushId) {
        pushId = @"";
    }
    
    self.pushID = pushId;
    if (paramType == nil) return;

    [[Tao800UGCSingleton sharedInstance] commitLog:YES];

    int pType = [paramType intValue];
    self.pushType2 = pType;

    
    [[Tao800UGCSingleton sharedInstance] paramsLog:Event_PushReceive params:@{Event_Pc_PARAM_D: pushId}];
    
    NSString *pushMessage = alertString; //[userInfo objectForKey:@"m"];
    pushMessage = [pushMessage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (pushMessage == nil || [pushMessage length] < 1) {
        pushMessage = [userInfo objectForKey:@"m"];
    }

    switch (pType) {
        case PushTypeLink: {
            if (paramValue == nil) {
                return;
            }
            if (applicationIsActive && pushMessage) {
                self.pushDict = userInfo;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:pushMessage
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"查看", nil];
                alert.tag = PushTypeLink;
                [alert show];

            } else {
                [self forwardToLink:paramValue];
            }
        }
            break;
        case PushTypeCategory: { // push分类
            if (applicationIsActive && pushMessage) {
                self.pushDict = userInfo;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:pushMessage
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"查看", nil];
                alert.tag = PushTypeCategory;
                [alert show];

            } else {
                [self forwardToCategory:paramValue];
            }
        }
            break;
        case PushTypeZhiDeGuangFenLei: { // push值得逛分类
            if (applicationIsActive && pushMessage) {
                self.pushDict = userInfo;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:pushMessage
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"查看", nil];
                alert.tag = PushTypeZhiDeGuangFenLei;
                [alert show];

            } else {
                [self forwardToZhiDeGuangFenLei:paramValue];
            }
        }
            break;
        case PushTypeFanJiFenTongZhi: { // 返积分通知，起到启动客户端作用，后续版本再优化
            if (applicationIsActive && pushMessage) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:pushMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];

            }
        }
            break;

        case PushTypeSign: { // push到签到页
            if (applicationIsActive && pushMessage) {
                self.pushDict = userInfo;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:pushMessage
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"查看", nil];
                alert.tag = PushTypeSign;
                [alert show];

            } else {
                [self forwardToSign];
            }
        }
            break;
        case PushTypeDealDetail: { // push到商品详情页
            if (applicationIsActive && pushMessage) {
                self.pushDict = userInfo;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:pushMessage
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"查看", nil];
                alert.tag = PushTypeDealDetail;
                [alert show];

            } else {
                [self forwardToDealDetail:paramValue];
            }
        }
            break;
        case PushTypeTopicActivity: {//Push到 活动专题列表页
            if (applicationIsActive && pushMessage) {
                self.pushDict = userInfo;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:pushMessage
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"查看", nil];
                alert.tag = PushTypeTopicActivity;
                [alert show];
            } else {
                [self forwardToTopicActivity:paramValue];
            }
        }
            break;
            
        case PushTypeTopicLock:{
            if (applicationIsActive && pushMessage) {
                self.pushDict = userInfo;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:pushMessage
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"查看", nil];
                alert.tag = PushTypeTopicLock;
                [alert show];
            } else {
                [self forwardToTopicActivity:paramValue];
            }
            
        }
            break;
        case PushTypeOpenGroupRemind: { // 开团提醒

            if (applicationIsActive && pushMessage) {
                self.pushDict = userInfo;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:pushMessage
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"查看", nil];
                alert.tag = PushTypeOpenGroupRemind;
                [alert show];

            } else {
                [self forwardToOpenGroupRemindPage];
            }

        }
            break;
        case PushTypeAuctionDeal: { // push更高竞拍
            if (applicationIsActive && pushMessage) {
                self.pushDict = userInfo;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"有人对您竞拍的商品再次加价，进去看看吧。"]
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"查看", nil];
                alert.tag = PushTypeAuctionDeal;
                [alert show];

            } else {
                [self forwardToAuctionDetail:paramValue];
            }
        }
            break;
        case PushTypeZhe800MallOrderDetail:{ //zhe800商城订单改变push
            if (paramValue == nil) {
                return;
            }
            if (applicationIsActive && pushMessage) {
                self.pushDict = userInfo;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:pushMessage
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"查看", nil];
                alert.tag = PushTypeZhe800MallOrderDetail;
                [alert show];
                
            } else {
                [self forwardToZMallOrderDetail:userInfo];
            }
        }
            break;
        case PushTypeTenProductsEveryDay:{ //每日十件
            self.pushDict = userInfo;
            if (applicationIsActive && pushMessage) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:pushMessage
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"查看", nil];
                alert.tag = PushTypeTenProductsEveryDay;
                [alert show];
                
            } else {
                [self forwardToTenProductsEveryDay:pushId];
            }
        }
            break;
        case PushTypeBrandProducts:{ // 某一品牌的商品
            self.pushDict = userInfo;
            if (applicationIsActive && pushMessage) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:pushMessage
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"查看", nil];
                alert.tag = PushTypeBrandProducts;
                [alert show];
                
            } else {
                [self forwardToBrandProducts];
            }
        }
            break;
        case PushTypeLottery:{ // 某一品牌的商品
            self.pushDict = userInfo;
            if (applicationIsActive && pushMessage) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:pushMessage
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"查看", nil];
                alert.tag = PushTypeLottery;
                [alert show];
                
            } else {
                [self forwardToLottery];
            }
        }
            break;
            
        case PushTypeWishList:{ // 心愿单
            self.pushDict = userInfo;
            if (applicationIsActive && pushMessage) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:pushMessage
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"查看", nil];
                alert.tag = PushTypeWishList;
                [alert show];
                
            } else {
                [self forwardToWishList];
            }
        }
            break;
        case PushTypeMyCoopons:{ // 优惠券
            self.pushDict = userInfo;
            if (applicationIsActive && pushMessage) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:pushMessage
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"查看", nil];
                alert.tag = PushTypeMyCoopons;
                [alert show];
                
            } else {
                [self forwardToMyCoopons];
            }
        }
            break;
            /*
        case PushTypeCampusProducts:{ //校园专区
            self.pushDict = userInfo;
            if (applicationIsActive && pushMessage) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:pushMessage
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"查看", nil];
                alert.tag = PushTypeCampusProducts;
                [alert show];
                
            } else {
                [self forwardToCampusProducts];
            }
        }
            break;
             */
        default: {
            //普通文本信息或首页
            if (applicationIsActive && pushMessage) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:pushMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }
    }
}

#pragma mark alert弹窗按钮事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *paramValue = [self.pushDict objectForKey:@"u"];
    //NSString *pushMessage = [self.pushDict objectForKey:@"m"];
    
    if (buttonIndex == 0) {
        //取消 进行打点
        [[Tao800UGCSingleton sharedInstance] paramsLog:Event_Push params:[NSDictionary dictionaryWithObjectsAndKeys:@"exit",Event_Push_Id, nil]];
    }else {
        if (self.pushType2 == PushTypeWishList) {
            [[Tao800UGCSingleton sharedInstance] paramsLog:Event_Pc params:@{Event_Pc_PARAM_D: @"wish"}];
        }else{
            [[Tao800UGCSingleton sharedInstance] paramsLog:Event_Pc params:[NSDictionary dictionaryWithObjectsAndKeys:self.pushID, Event_Pc_PARAM_D, nil]];
        }
    }

    switch (alertView.tag) {
        case PushTypeLink: {
            if (buttonIndex == 1) {
                [self forwardToLink:paramValue];
            }
        }
            break;
        case PushTypeCategory: {
            if (buttonIndex == 1) {
                [self forwardToCategory:paramValue];
            }
        }
            break;
        case PushTypeZhiDeGuangFenLei: {
            if (buttonIndex == 1) {
                [self forwardToZhiDeGuangFenLei:paramValue];
            }
        }
            break;
        case PushTypeSign: {
            if (buttonIndex == 1) {
                [self forwardToSign];
            }
        }
            break;
        case PushTypeDealDetail: {
            if (buttonIndex == 1) {
                [self forwardToDealDetail:paramValue];
            }
        }
            break;
        case PushTypeTopicActivity: {
            if (buttonIndex == 1) {
                [self forwardToTopicActivity:paramValue];
            }
        }
            break;
        case PushTypeTopicLock: {
            if (buttonIndex == 1) {
                [self forwardToTopicLockActivity:paramValue];
            }
        }
            break;
        case PushTypeOpenGroupRemind: {
            if (buttonIndex == 1) {
                [self forwardToOpenGroupRemindPage];
            }
        }
            break;
        case PushTypeAuctionDeal: {
            if (buttonIndex == 1) {
                [self forwardToAuctionDetail:paramValue];
            }
        }
            break;
        case PushTypeZhe800MallOrderDetail:{
            if(buttonIndex == 1){
                [self forwardToZMallOrderDetail:self.pushDict];
            }
        }
            break;
        case PushTypeBrandProducts:{
            if (buttonIndex == 1) {
                [self forwardToBrandProducts];
            }
        }
            break;
        case PushTypeTenProductsEveryDay:{
            if (buttonIndex == 1) {
                [self forwardToTenProductsEveryDay:self.pushID];
            }
        }
            break;
        case PushTypeLottery:{
            if(buttonIndex == 1){
                [self forwardToLottery];
            }
        }
            break;
        case PushTypeWishList:{
            if(buttonIndex == 1){
                [self forwardToWishList];
            }
        }
            break;
        case PushTypeMyCoopons:{
            if(buttonIndex == 1){
                [self forwardToMyCoopons];
            }
        }
            break;
       /* case PushTypeCampusProducts:{
            if (buttonIndex == 1) {
                [self forwardToCampusProducts];
            }
        }
            break;*/
        default:
            break;
    }
}

#pragma mark -
- (void)sendToken:(NSString *)token pushType:(Tao800PushManageProviderPushType)pPushType {
    if (token == nil) {
        return;
    }

    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];

    UIDevice *device = [UIDevice currentDevice];
    NSString *macAddress = [Tao800DataModelSingleton sharedInstance].macAddress;
    NSString *receiveMsg = @"1";
    if (pPushType == Tao800PushManageProviderCancelPush) {
        receiveMsg = @"0";
    }
    NSString *product = dm.product;
    NSString *platform = [device model];
    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    NSString *userRole = [configManage getUserIdentity];
    if (!userRole) {
        userRole = @"";
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            macAddress, @"macAddress",
            token, @"deviceToken",
            product, @"product",
            platform, @"platform",
            receiveMsg, @"recievemsg",
            userRole, @"userRole",
            @(dm.userType),@"userType",
            nil];
    if(dm.user && dm.user.userId){
        [dict setObject:dm.user.userId forKey:@"userId"];
    }
    [_aPNSApi sendDeviceToken:dict];
}

- (void)sendDeviceTokenFinish:(NSDictionary *)params {
    NSNumber *status = [params objectForKey:@"status"];
    if (status.intValue == 0) {
        [Tao800DataModelSingleton sharedInstance].deviceTokenSendOk = YES;
        [[Tao800DataModelSingleton sharedInstance] archive];
    }
}

- (void)clearRemoteNotification:(UIApplication *)application fore:(BOOL)force {
    if (application.applicationIconBadgeNumber > 0) {
        [application setApplicationIconBadgeNumber:0];
    }

    if (force) {
        [application setApplicationIconBadgeNumber:1];
        [application setApplicationIconBadgeNumber:0];
    }
}

#pragma mark 手动请求远程通知，作为本地通知来push
- (void)loadRemoteNotifications{
    
    if (!self.tao800Service) {
        self.tao800Service = [[Tao800Service alloc]init];
    }
    
    NSMutableDictionary * paraDic = [NSMutableDictionary new];
    [paraDic setObject:@"iphone" forKey:@"platform"];
    [paraDic setObject:@"tao800" forKey:@"product"];
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    NSString * currentCityId = dm.city.cityId;
    if (currentCityId) {
        [paraDic setObject:currentCityId forKey:@"cityid"];
    }
    
    NSString * channelId = [dm partner];
    if (channelId) {
        [paraDic setObject:channelId forKey:@"channelid"];
    }
    
    NSString * madAddressString = dm.headerVo.macAddress;
    if (madAddressString) {
        [paraDic setObject:madAddressString forKey:@"mac"];
    }
    
    __weak Tao800PushManage * weakInstance = self;
    [self.tao800Service getRemotePushes:paraDic completion:^(NSArray * responseArray) {
        
        [weakInstance deleteRemoteNotificationsBeforeOneDay];
        [weakInstance deleteAllPushNotificationIfFinishLoadRemoteItems];
        [weakInstance wrapperPushesItems:responseArray];
    } failue:^(TBErrorDescription * error) {
        
        
    }];
}

-(void)wrapperPushesItems:(NSArray * )theWholePushArray{
    
    NSMutableArray * pushItemsArray = [NSMutableArray new];
    
    for (NSDictionary * onePushDic in theWholePushArray) {
        NSDictionary * apsDic = [onePushDic objectForKey:@"aps"];
        NSString * pushIdString = [onePushDic objectForKey:@"i"];
        NSString * pushAlertString = [apsDic objectForKey:@"alert"];
        NSString * pushTimeString = [onePushDic objectForKey:@"bt"];
        NSString * pushDetaiString = [apsDic objectForKey:@"m"];
        NSString * pushSound = [apsDic objectForKey:@"sound"];
        int pushBadge = [[apsDic objectForKey:@"badge"] intValue];
        
        NSString * timeString = [NSString stringWithFormat:@"%@", pushTimeString];
        NSDate * theTime = [self dateFromString:timeString];
        NSDate * dateNow = [NSDate date];
        NSComparisonResult compareResult = [theTime compare:dateNow];
        if (compareResult == NSOrderedAscending) {
            continue;
        }else if(compareResult == NSOrderedDescending){
            //go 加入到通知中心
        }else if(compareResult == NSOrderedSame){
            continue;
        }
        
        BOOL appJustFinishedPushIn24Hours = [self checkIfTheNotificationDidPushedIn24Hour:pushIdString];
        if (appJustFinishedPushIn24Hours) {
            continue;
        }else{
            //go
        }
        
        Tao800RemotePushBVO * remotePushItem = [Tao800RemotePushBVO new];
        remotePushItem.pushId = pushIdString;
        remotePushItem.pushTime = pushTimeString;
        remotePushItem.pushAlert = pushAlertString;
        remotePushItem.pushDetailMessage = pushDetaiString;
        remotePushItem.pushSound = pushSound;
        remotePushItem.pushDic = onePushDic;
        remotePushItem.pushBadge = pushBadge;
        
        [pushItemsArray addObject:remotePushItem];
    }
    
    
    UIApplication * currentApp  = [UIApplication sharedApplication];
    for (int i = 0; i < pushItemsArray.count; i++) {
        Tao800RemotePushBVO * onePush = [pushItemsArray objectAtIndex:i];
        UILocalNotification * onePushNotification = [UILocalNotification new];
        onePushNotification.timeZone = [NSTimeZone systemTimeZone];
        onePushNotification.soundName = UILocalNotificationDefaultSoundName;//default sound
        onePushNotification.alertBody = onePush.pushAlert;
        onePushNotification.applicationIconBadgeNumber = onePush.pushBadge;
        
        NSMutableDictionary * pushInfoDic = [NSMutableDictionary new];
        NSString * pushKey = [self remotePushNotificationKey:onePush.pushId];
        [pushInfoDic setObject:pushKey forKey:pushKey];
        for (NSString * onePushKey in onePush.pushDic) {
            [pushInfoDic setObject:[onePush.pushDic objectForKey:onePushKey] forKey:onePushKey];
        }
        
        onePushNotification.userInfo = pushInfoDic;
        
        NSString * timeString = [NSString stringWithFormat:@"%@", onePush.pushTime];
        NSDate * theFireTime = [self dateFromString:timeString];
        
        [onePushNotification setFireDate:theFireTime];
        [onePushNotification setTimeZone:[NSTimeZone systemTimeZone]];
        [currentApp scheduleLocalNotification:onePushNotification];
    }
}

-(void)deleteAllPushNotificationIfFinishLoadRemoteItems{
    UIApplication * currentApp = [UIApplication sharedApplication];
    NSArray *localNotificationArray = [currentApp scheduledLocalNotifications];
    for (UILocalNotification * notification in localNotificationArray) {
        NSDictionary * userDic = notification.userInfo;
        for (NSString * notificationKey in userDic.allKeys) {
            if (notificationKey && [notificationKey hasPrefix:Tao800RemoteNotificationKeyPrefix]) {
                [currentApp cancelLocalNotification:notification];
            }
        }
    }
}

- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

-(NSString *)remotePushNotificationKey:(NSString *)pushIdString{
    NSString * key = [NSString stringWithFormat:@"%@%@", Tao800RemoteNotificationKeyPrefix, pushIdString];
    return key;
}


-(void)deleteRemoteNotificationsBeforeOneDay{
    //删除24小时之前曾经弹出过的通知的信息
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    if (dm.remotePushArray) {
        NSMutableArray * pushArray = [NSMutableArray new];
        for (Tao800RemotePushBVO * remoteNotification in dm.remotePushArray) {
            NSDate * timeNow = [NSDate date];
            NSDate * pushTime = [self dateFromString:remoteNotification.pushTime];
            NSTimeInterval interval = [timeNow timeIntervalSince1970] - [pushTime timeIntervalSince1970];
            if (interval < 24 * 60 * 60) {
                [pushArray addObject:remoteNotification];
            }
        }
        
        dm.remotePushArray = pushArray;
        [dm archive];
    }
}


-(BOOL)checkIfTheNotificationDidPushedIn24Hour:(NSString *)pushIdString{
    BOOL finishPushed = NO;
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    if (dm.remotePushArray) {
        for (Tao800RemotePushBVO * remoteNotification in dm.remotePushArray) {
            if ([remoteNotification.pushId isEqual:pushIdString]) {
                finishPushed = YES;
                break;
            }
        }
    }
    return finishPushed;
}

//如果弹出过push通知，那么记录一下
-(void)addToDmIfNotificationFinishedPushed:(NSDictionary *)onePushDic{
    if (!onePushDic) {
        return;
    }
    
    //NSDictionary * apsDic = [onePushDic objectForKey:@"aps"];
    NSString * pushIdString = [onePushDic objectForKey:@"i"];
    NSString * pushTimeString = [onePushDic objectForKey:@"bt"];
    
    Tao800RemotePushBVO * pushItem = [Tao800RemotePushBVO new];
    pushItem.pushId = pushIdString;
    pushItem.pushTime = pushTimeString;
    
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    if (!dm.remotePushArray) {
        dm.remotePushArray = [NSMutableArray new];
    }else{
        //
    }
    
    [dm.remotePushArray addObject:pushItem];
    [dm archive];
}

@end