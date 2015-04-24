//
//  TN800GlobalDataModel.h
//  iPad
//
//  Created by enfeng yang on 12-2-7.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import <Foundation/Foundation.h> 
#import "TBNetwork/Reachability.h"
#import "TBService/TBLogAnalysisBaseHeader.h"
#import "Tao800NetworkManager.h"
#import "TBService/TBUserVo.h"
#import "Tao800DealVo.h"
#import "Tao800TaobaoVo.h"
#import "Tao800TencentVo.h"
#import "Tao800SinaWeiboVo.h"
#import "TBService/TBGpsAddressVo.h"
#import "TBService/TBGpsManager.h"
#import "TBService/TBCityVo.h"
#import "Tao800MyGradeVo.h"
#import "Tao800ScoreVo.h"
#import "Tao800HeartWishBVO.h"
#import "TBService/TBGpsManagerV2.h"

//新老用户常量
typedef enum _Tao800UserType {
    Tao800UserTypeNew = 0,
    Tao800UserTypeOld = 1
} Tao800UserType;

//todo 用作应用每次启动后的判断
typedef enum _Tao800AppState {
    Tao800AppStateNewApp = 2,  //全新安装的app
    Tao800AppStateUpdateApp = 1, //升级安装的app
    Tao800AppStateNothing = 0  //安装后的状态
} Tao800AppState;

@class Tao800InfoPlistVo;
@class Tao800ConfigBVO;
@class Tao800AutoLoginManager;

@interface Tao800DataModelSingleton : NSObject <NSCoding> {
    
    TBUserVo *_user;
    NSString *_userPassword;
    NSDate *_signDate; // 上一次签到日期
    NSDate *_lastShowFanjifenDate; // 上一次显示反积分提示日期
    Tao800TaobaoVo *_taobaoVo;
    Tao800TencentVo *_tencentVo;
    Tao800SinaWeiboVo *_sinaWeiboVo;
    Tao800MyGradeVo *_myGradeVo;
    
    TBCityVo *_city;
    TBCityVo *_gpsCity;
    NSString *_location; //当前位置
    double _latitude; //纬度
    double _longitude; //经度
    TBGpsAddressVo *_addressVo; //定位信息VO
    TBGpsManagerV2 *_lbsModel;
    
    Tao800DealVo *_dailyRecommendDealVo; // 每日推荐vo
    NSDate *_lastGetDailyRecommendDate; //上一次获取每日推荐的时间
    
    BOOL _textMode;
    BOOL _acceptNotification;                   //是否打开通知
    BOOL _acceptCommentDailyNotification;       //是否打开每日推荐
    BOOL _acceptAlertWhenSaleBeginNotification; //是否打开开卖提醒
    BOOL _acceptCheckInNotification; //是否接收签到提醒
    
    
    TBLogAnalysisBaseHeader *_headerVo;
    BOOL _baseLogCommitted;
    
    NSDateFormatter *_dateFormatter;
    
    NSString *_currentVersion;
    NetworkStatus _networkStatus;
    
    Tao800NetworkManager *_networkManager;
    NSDate *_lastEnterAppDate; //上一次进入应用的时间，如20121012
    
    NSString *_oldCurrVersion; // 旧版本号
    
    int _currentModel; // 当前首页模式 0大图 1列表
    NSString *_firstStartDealWeb; // 是否第一次启动商品详情页面
    
    NSString *_platform; // 平台，iphone或ipad
    NSString *_product; // 产品，tao800,tao800_04等
    NSString *_partner; // 渠道号
    NSString *_weixinAppID; // 微信AppID
    
    NSMutableArray *_shops;
    NSMutableArray *_goods;
    
    BOOL IKnowButtonClickedFlag; //标示产品详情web界面，“我知道了”按钮是否点击
    NSString *recordedDate; //纪录值得逛点击时的日期
    
    NSString *_tao800CloseLoginUrl; //淘宝关闭登录后的提示配置
    
    BOOL _tao800OutClose; // webview是否开启白名单功能
    NSMutableDictionary *_tao800OutProtocol; //webview白名单
    BOOL _isShowPreviewDealButton;  // 是否显示精品预告按钮
    NSString *_showPreviewDealTime; // 显示精品预告商品时间，小时整数
    
    //用来过来淘宝链接，下载或者打开
    NSDictionary *_urlFilterDict;
    
    // v2.7.0新增
    NSString *_recommendCid;            // 设备被推荐的淘宝分类id值
    NSString *_isShowRechargeLotteryButton;    // 是否显示手机充值、购买彩票按钮 0(无)，1（只充值），2（只彩票），3（都有）
    
}
@property(nonatomic, strong) NSDictionary *urlFilterDict;
@property(nonatomic, strong) TBUserVo *user;
@property(nonatomic, strong) NSString *userPassword;
@property(nonatomic, strong) Tao800DealVo *dailyRecommendDealVo;
@property(nonatomic, strong) NSDate *lastGetDailyRecommendDate;
@property(nonatomic, strong) Tao800TaobaoVo *taobaoVo;
@property(nonatomic, strong) Tao800SinaWeiboVo *sinaWeiboVo;
@property(nonatomic, strong) Tao800TencentVo *tencentVo;

@property(nonatomic, strong) Tao800MyGradeVo *myGradeVo;
@property(nonatomic, strong) TBCityVo *city;
@property(nonatomic, strong) TBCityVo *gpsCity;
@property(nonatomic, copy) NSString *location;
@property(nonatomic, assign) double latitude;
@property(nonatomic, assign) double longitude;
@property(nonatomic, strong) TBGpsAddressVo *addressVo;
@property(nonatomic, strong) TBGpsManagerV2 *lbsModel;

@property(nonatomic, assign, getter=isTextMode) BOOL textMode;
@property(nonatomic, assign, getter=isAcceptNotification) BOOL acceptNotification;
@property(nonatomic, assign, getter=isAcceptAlertWhenSaleBeginNotification) BOOL acceptAlertWhenSaleBeginNotification;
@property(nonatomic, assign, getter=isAcceptCommentDailyNotification) BOOL acceptCommentDailyNotification;
@property(nonatomic, assign) BOOL acceptCheckInNotification;
@property(nonatomic, strong) TBLogAnalysisBaseHeader *headerVo;
@property(nonatomic, assign, getter=isBaseLogCommitted) BOOL baseLogCommitted; 

@property(nonatomic, readonly) NSDateFormatter *dateFormatter;
@property(nonatomic, readonly) NSString *currentVersion;
@property(nonatomic) NetworkStatus networkStatus;
@property(nonatomic, strong) NSDate *lastEnterAppDate;
@property(nonatomic, assign) int currentModel;
@property(nonatomic, strong) NSString *platform;
@property(nonatomic, strong) NSString *product;
@property(nonatomic, strong) NSString *partner;
@property(nonatomic, strong) NSString *weixinAppID;
@property(nonatomic, strong) NSDate *signDate;
@property(nonatomic, strong) NSString *firstStartDealWeb;
@property(nonatomic, strong) NSMutableArray *shops;
@property(nonatomic, strong) NSMutableArray *goods;
@property(nonatomic, assign) BOOL IKnowButtonClickedFlag;
@property(nonatomic, strong) NSDate *lastShowFanjifenDate;
@property(nonatomic, copy) NSString *recordedDate;
@property(nonatomic, strong) NSString *tao800CloseLoginUrl;
@property(nonatomic, strong) NSMutableDictionary *tao800OutProtocol;
@property(nonatomic, assign) BOOL tao800OutClose;
@property(nonatomic, assign) BOOL isShowPreviewDealButton;
@property(nonatomic, assign) BOOL isFirstComeToSaunter;
@property(nonatomic, strong) NSString *showPreviewDealTime;

@property(nonatomic, strong) NSString *oldCurrVersion;
@property(nonatomic, strong) NSMutableDictionary *categoryDealsCacheDict;
@property(nonatomic, strong) NSMutableDictionary *lotteryCacheDict;
@property(nonatomic, strong) NSMutableDictionary *promotionDealsCacheDict;
@property(nonatomic, strong) NSMutableDictionary *myRewardDealsCacheDict;
@property(nonatomic, strong) NSMutableDictionary * weixinAndQQFollowDic; //持久化微信和QQ关注的状态
@property(nonatomic, strong) NSMutableDictionary * onceRequestCheckInHistory; //用户是否请求成功过签到历史 持久化用
@property(nonatomic, strong) NSMutableDictionary *muyingBrandCacheDict; //母婴频道品牌分类缓存
@property(nonatomic, strong) NSMutableDictionary *muyingSingleCacheDict; //母婴频道单品分类缓存
@property(nonatomic, strong) NSMutableDictionary *brandCacheDict; //品牌团分类缓存


// v2.7.0新增
@property(nonatomic, strong) NSString *recommendCid;            // 设备被推荐的淘宝分类id值
@property(nonatomic, strong) NSString *weixinScore;             // 微信关注加分数
@property(nonatomic, strong) NSString *isShowPhoneRechargeButton;     //  是否显示手机充值、购买彩票按钮 0(无)，1（只充值），2（只彩票），3（都有）

//记录URL scheme值
@property(nonatomic, strong) Tao800InfoPlistVo *infoPlistVo;
@property(nonatomic, strong) Tao800ConfigBVO *configBVO;

@property(nonatomic, strong) NSMutableArray *favoriteDealIds;
@property(nonatomic, strong) NSMutableArray *favoriteShopIds;

@property(nonatomic, assign) Tao800UserType userType;   //用户类型
@property(nonatomic, assign) BOOL showFirstOrderEntry;
@property(nonatomic, assign) Tao800AppState tao800AppState;
@property(nonatomic, copy)NSString *firstOrderUrl;
@property(nonatomic, strong) Tao800ScoreVo * userScoreInfoVo; //用来查询登录状态下用户当前是否已经签过到

// v2.8.0新增
@property(nonatomic, assign) BOOL isClearTaobaoCookie; // 是否清除淘宝cookie
@property BOOL fromNew; //纪录新安装或覆盖安装
@property BOOL isSlip;//分类列表滑动判断

// v3.0.1新增
@property(nonatomic, strong) NSMutableArray *rechargePhones;     //充值过的手机号码数组
@property(nonatomic, strong) NSArray *saunterBanners; //值得逛banner
@property(nonatomic, strong) NSMutableDictionary *favoriteModelDict; //用于同步用户收藏


@property(nonatomic, strong) NSArray *loadingTipArray; //产品价值，loading提示
@property(nonatomic, strong) NSArray *prdTipArray;

@property(nonatomic, copy) NSString *documentDirectory; //序列化保存的目录

//v3.1.1
@property(nonatomic,assign) int totalScore;//个人总积分
//v3.5.3
@property (nonatomic, assign) int isWishReached;  //0表示没有心愿达成，1表示有心愿达成
@property (atomic, strong) Tao800HeartWishReachedBVO* heartReachedBvo;
@property (nonatomic) BOOL isCoverInstall;//首页显示蒙层用
@property (nonatomic) BOOL coverInstallFlag;

//group2_001增
@property(nonatomic, strong) NSMutableDictionary *statusBarClickCache;

//v3.2
@property(nonatomic, copy) NSString *searchKeyWord;//搜索关键字
@property(nonatomic, strong) NSMutableArray *saveDealLogs;         //缓存曝光打点数据
@property(nonatomic, strong) NSMutableArray *uploadingDealLogs;     //最终需要上传的打点数据
@property(nonatomic, copy) NSString *version;//排序版本号
@property(nonatomic, strong) NSDate *lastEnterDetailDate;           //最后进入聚频道主列表和分类页详情的日期
@property(nonatomic, strong) NSDate *lastEnterSaunterDate;          //最后进入值得逛的日期
//3.3
@property(nonatomic, copy) NSString *listVersion;//列表版本
@property(nonatomic, strong) NSMutableArray *saunterAllCategoryArrays;    //值得逛全部分类（2、3级分类在这里保存）

/*
 记录push然后分享的两个属性
 */
@property (nonatomic, assign) int userExistsFromAppTimes;
@property (nonatomic, assign) int userExistsThenPushTimes;
@property (nonatomic, assign) BOOL userFinishPushToShare;

@property (nonatomic, strong) NSMutableArray * remotePushArray;
@property BOOL enableStartSellMaskInPersonalHome;
@property BOOL fromScan;

@property (nonatomic, strong) NSMutableDictionary * userClickPersonalCenterDotDic; //用户点击个人中心红点的一个持久化的字典
@property (nonatomic, strong) Tao800AutoLoginManager * autoLoginManager;

@property (nonatomic, assign) BOOL userEverChooseAnIdetity;
@property (nonatomic, assign) BOOL enableShowPromotionHomePage;
@property (nonatomic, assign) BOOL enableShowCustomServerIMPage;

@property (nonatomic) BOOL displayAsGrid; //商品列表默认显示方式，YES :宫格 NO:列表

@property (nonatomic, copy) NSString* dealCounts;
/**
 * 重新加载收藏Model
 *
 * 用户登录时调用
 * 用户在注销操作时需要等待收藏同步完成之后再操作
 */
- (void) reloadFavoriteModel;

+ (Tao800DataModelSingleton *)sharedInstance;

- (BOOL)archive;

- (TBLogAnalysisBaseHeader *)getHeaderVo;

- (NSString *)apnsDeviceToken;

- (void)apnsDeviceToken:(NSString *)apnsDeviceToken;

- (BOOL)deviceTokenSendOk;

- (void)setDeviceTokenSendOk:(BOOL)sendOk;

- (NSString *)macAddress;

- (void)macAddress:(NSString *)macAddress;

- (NSArray *)getAllCities;

- (NSArray *)getHotCities;


//- (void) getRemoteCities;

/**
 * 当前选中的城市
 */
- (NSString *)currentCityId;

- (void)currentCityId:(NSString *)cityid;

/**
 * 判断 days天内应用的启动次数
 */
- (int)getAppStartCountOfDays:(int)days;

/**
 * 重置新老用户状态
 *
 * @param appStart 是否为应用启动
 */
- (void)resetUserState:(BOOL) appStart;

- (void)resetFavorites;

/**
 * 根据角色id获取角色名称
 */
- (NSString *)getUserRoleName:(NSString *)userRole;

/**
* @return 1 : 学生
*/
- (int)getUserStudentStatus;
/**
 * 获取用户角色
 * @return 1, 2, 3 ...
 */
- (NSString *)getUserRole;


/**
 * 获取首页5模块
 */
- (NSArray *)getOperationModel;

/**
 * 获取大促首页配置
 */
- (NSDictionary *)getPromotionHomeOperationModel;

/**
 * 获取首页推荐分类
 */
- (NSArray *)getTagsOfRecommend;

/**
 * 获取产品价值提示
 */
- (NSString*) getLoadingTip;

- (NSString *)getPrdLoadingTip;
/**
 * 刷新定位
 */
- (void)refreshGPS;
@end
