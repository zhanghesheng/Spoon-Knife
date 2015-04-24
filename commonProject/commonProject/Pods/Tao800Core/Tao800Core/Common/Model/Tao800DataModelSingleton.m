//  TN800GlobalDataModel.m
//  iPad
//
//  Created by enfeng yang on 12-2-7.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import "Tao800DataModelSingleton.h"
#import "TBCore/TBFileUtil.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "TBCore/GeoTransfer.h"
#import "TBCore/TBCoreMacros.h"
#import "Tao800StaticConstant.h"
#import "Tao800UGCSingleton.h"
#import "TBCore/TBCore.h"
#import "TBUI/TBUI.h"
#import "TBCore/OpenUDID.h"
#import "Tao800NotifycationConstant.h"
#import "Tao800InfoPlistVo.h"
#import "Tao800ConfigBVO.h"
#import "Tao800ConfigManage.h"
#import "Tao800StartLogDao.h"
#import "Tao800CatVoSingleton.h"
#import "Tao800FavoriteModel.h"
#import "Tao800AutoLoginManager.h"
#import "Tao800Util.h"

const static NSString *archiveFileName = @"tao800iphone.dat";
static Tao800DataModelSingleton *_instance;

NSString *const CityMd5StringKey = @"CityMd5StringKey";
NSString *const TN800DataModelSingletonCityDidChangeNotification = @"TN800DataModelSingletonCityDidChangeNotification";
NSString *const M800DataModelSingletonCityDidChangeNotification = @"M800DataModelSingletonCityDidChangeNotification";

#define kTBBaseGlobalModelCity @"9901"
#define kTBBaseGlobalModelDeviceToken  @"9902"

@interface Tao800DataModelSingleton ()

@property(nonatomic, strong) NSDictionary *userRoleDict;
@end

@implementation Tao800DataModelSingleton
@synthesize urlFilterDict = _urlFilterDict;
@synthesize user = _user;
@synthesize userPassword = _userPassword;
@synthesize dailyRecommendDealVo = _dailyRecommendDealVo;
@synthesize lastGetDailyRecommendDate = _lastGetDailyRecommendDate;
@synthesize taobaoVo = _taobaoVo;
@synthesize tencentVo = _tencentVo;
@synthesize sinaWeiboVo = _sinaWeiboVo;

@synthesize myGradeVo = _myGradeVo;
@synthesize city = _city;
@synthesize gpsCity = _gpsCity;
@synthesize location = _location;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize addressVo = _addressVo;
@synthesize lbsModel = _lbsModel;

@synthesize signDate = _signDate;
@synthesize textMode = _textMode;
@synthesize acceptNotification = _acceptNotification;
@synthesize acceptAlertWhenSaleBeginNotification = _acceptAlertWhenSaleBeginNotification;
@synthesize acceptCommentDailyNotification = _acceptCommentDailyNotification;
@synthesize acceptCheckInNotification = _acceptCheckInNotification;
@synthesize headerVo = _headerVo;
@synthesize baseLogCommitted = _baseLogCommitted;

@synthesize dateFormatter = _dateFormatter;
@synthesize currentVersion = _currentVersion;
@synthesize networkStatus = _networkStatus;
@synthesize lastEnterAppDate = _lastEnterAppDate;
@synthesize currentModel = _currentModel;
@synthesize firstStartDealWeb = _firstStartDealWeb;

@synthesize platform = _platform;
@synthesize product = _product;
@synthesize partner = _partner;
@synthesize weixinAppID = _weixinAppID;
@synthesize shops = _shops;
@synthesize goods = _goods;
@synthesize IKnowButtonClickedFlag;
@synthesize lastShowFanjifenDate = _lastShowFanjifenDate;
@synthesize recordedDate;
@synthesize tao800CloseLoginUrl = _tao800CloseLoginUrl;
@synthesize tao800OutProtocol = _tao800OutProtocol;
@synthesize tao800OutClose = _tao800OutClose;
@synthesize isShowPreviewDealButton = _isShowPreviewDealButton;
@synthesize showPreviewDealTime = _showPreviewDealTime;

@synthesize oldCurrVersion = _oldCurrVersion;

@synthesize recommendCid = _recommendCid;
@synthesize weixinScore = _weixinScore;
@synthesize isShowPhoneRechargeButton = _isShowRechargeLotteryButton;
@synthesize userScoreInfoVo = _userScoreInfoVo;
@synthesize weixinAndQQFollowDic = _weixinAndQQFollowDic;
@synthesize totalScore = _totalScore;
@synthesize searchKeyWord = _searchKeyWord;
@synthesize version = _version;
@synthesize lastEnterSaunterDate = _lastEnterSaunterDate;
@synthesize userExistsFromAppTimes;
@synthesize userExistsThenPushTimes;
@synthesize userFinishPushToShare;

#pragma mark -
#pragma mark Singleton Methods

- (void)loadCurrentVer {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Info" withExtension:@"plist"];
    NSDictionary *dict2 = [[NSDictionary alloc] initWithContentsOfURL:url];
    _currentVersion = [dict2 objectForKey:@"CFBundleShortVersionString"];
    NSString *bundleVersion = [dict2 objectForKey:@"CFBundleVersion"];
    _infoPlistVo.bundleVersion = bundleVersion;
    
    NSArray *urlTypes = [dict2 objectForKey:@"CFBundleURLTypes"];
    for (NSDictionary *itemDict in urlTypes) {
        NSArray *schemes = [itemDict objectForKey:@"CFBundleURLSchemes"];
        NSString *bundle = [itemDict objectForKey:@"CFBundleURLName"];
        NSString *scheme = [schemes objectAtIndex:0];
        @try {
            scheme = scheme.lowercaseString;
            [_infoPlistVo setValue:scheme forKey:bundle];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
    _infoPlistVo.versionShortName = _currentVersion;
    
    if (self.oldCurrVersion.length == 0) {
        self.tao800AppState = Tao800AppStateNewApp;
        self.fromNew = YES;
        [self archive];
    } else if (![self.currentVersion isEqualToString:self.oldCurrVersion]) {
        self.tao800AppState = Tao800AppStateUpdateApp;
        self.fromNew = NO;
        [self archive];
    } else {
        self.tao800AppState = Tao800AppStateNothing;
    }
    
}

#pragma mark 加载程序配置文件
- (void)loadApplicationConfig {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ApplicationConfig" withExtension:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfURL:url];
    self.platform = [dic objectForKey:@"platform"];
    self.product = [dic objectForKey:@"product"];
    self.partner = [dic objectForKey:@"partner"];
    self.weixinAppID = [dic objectForKey:@"weixinAppID"];
    self.displayAsGrid = [[dic objectForKey:@"displayAsGrid"] boolValue]; 
}

- (int)getAppStartCountOfDays:(int)days {
    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    NSDate *date = [configManage getAppInstallUpdateDate];
    if (!date) {
        date = [NSDate date];
    }
    date = [date dateByAddingTimeInterval:60 * 60 * 24 * days];
    NSString *dbPath = [TBFileUtil getDbFilePath:TBStoreDBFileName];
    Tao800StartLogDao *logDao = [[Tao800StartLogDao alloc] initWithPath:dbPath];
    NSArray *array = [logDao getLogsBefore:date];
    return (uint)array.count;
}

- (void)resetUserState:(BOOL)appStart {
    
    /////////////如果用户已经登录，则判断为老用户，否则按7天内条件判断
    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    NSString *uState = [configManage getUserState];
    if (uState) {
        self.userType = (Tao800UserType) (uState.intValue);
    } else {
        if (self.tao800AppState == Tao800AppStateUpdateApp) {
            //升级安装
            self.userType = Tao800UserTypeOld;
            NSString *str = [NSString stringWithFormat:@"%d", self.userType];
            [configManage saveUserState:str];
        } else {
            if (self.user && self.user.userId && appStart) {
                self.userType = Tao800UserTypeOld;
                NSString *str = [NSString stringWithFormat:@"%d", self.userType];
                [configManage saveUserState:str];
            } else {
                //判断7天内是否有过一次登录
                int count = [self getAppStartCountOfDays:7];
                if (count >= 2) {
                    self.userType = Tao800UserTypeOld;
                    NSString *str = [NSString stringWithFormat:@"%d", self.userType];
                    [configManage saveUserState:str];
                } else {
                    self.userType = Tao800UserTypeNew;
                }
            }
        }
        
    }
}

- (void)resetFavorites {
    ////////////////////////////////////////判断用户登录状态////////////////////////////////////////////
    //获取收藏
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    if (dm.user == nil || dm.user.userId == nil) { //用户未登陆
        self.favoriteDealIds = nil;
        self.favoriteShopIds = nil;
        return;
    }
    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    NSArray *array = [configManage getFavoriteDealIdsOfUser:self.user];
    if (array) {
        self.favoriteDealIds = [NSMutableArray arrayWithArray:array];
    }
    array = [configManage getFavoriteShopIdsOfUser:self.user];
    if (array) {
        self.favoriteShopIds = [NSMutableArray arrayWithArray:array];
    }
}

- (NSString *)getUserRoleName:(NSString *)userRole {
    return self.userRoleDict[userRole];
}

- (int)getUserStudentStatus {
    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    NSString *userStudentIdentity = [configManage getUserStudentIdentity];

    if ([userStudentIdentity isEqualToString:@"YES"]) {
        return 1;
    }
    return 0;
}

- (NSString *)getUserRole {
    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    return [configManage getUserIdentity];
}

- (NSArray *)getOperationModel{
    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    return [configManage getOperationModel];
}

- (NSDictionary *)getPromotionHomeOperationModel{
    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    return [configManage getPromotionHomeSettingModel];
}

- (NSArray *)getTagsOfRecommend {
    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    return [configManage getTagsOfRecommend];
}

- (NSString *)getLoadingTip {
    static int index = -1;
    index++;
    if (index >= self.loadingTipArray.count -1) {
        index = 0;
    }
    return self.loadingTipArray[index];
}

- (NSString *)getPrdLoadingTip {
    static int index = -1;
    index++;
    if (index >= self.prdTipArray.count -1) {
        index = 0;
    }
    return self.prdTipArray[index];
}

- (void)reloadFavoriteModel {
    if (self.user && self.user.userId) {
        if (!self.favoriteModelDict) {
            self.favoriteModelDict = [NSMutableDictionary dictionaryWithCapacity:2];
        }
        Tao800FavoriteModel *model = [self.favoriteModelDict objectForKey:self.user.userId];
        if (!model) {
            model = [[Tao800FavoriteModel alloc] init];
            [self.favoriteModelDict setValue:model forKey:self.user.userId];
        }
    }
}

- (void)initData {
    if (!self.documentDirectory) {
        self.documentDirectory = [TBFileUtil getDocumentBaseDir];
    }
    
    self.categoryDealsCacheDict = [NSMutableDictionary dictionaryWithCapacity:10];
    self.lotteryCacheDict = [NSMutableDictionary dictionaryWithCapacity:10];
    self.promotionDealsCacheDict = [NSMutableDictionary dictionaryWithCapacity:10];
    self.myRewardDealsCacheDict = [NSMutableDictionary dictionaryWithCapacity:10];
    self.muyingBrandCacheDict = [NSMutableDictionary dictionaryWithCapacity:10];
    self.muyingSingleCacheDict = [NSMutableDictionary dictionaryWithCapacity:10];
    self.brandCacheDict = [NSMutableDictionary dictionaryWithCapacity:10];
    
    _infoPlistVo = [[Tao800InfoPlistVo alloc] init];
    
    if (!self.myGradeVo) {
        self.myGradeVo = [[Tao800MyGradeVo alloc] init];
    }
    
    [self reloadFavoriteModel];
    
    if (!self.statusBarClickCache) {
        self.statusBarClickCache = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    self.prdTipArray = @[
                         @"专业砍价师\n狠心砍至全网超底价",
                         @"专业质检师\n再选出20%优质商品",
                         @"专业招募师\n洽谈商家并验收样品",
                         @"专业甄选师\n严选出20%热门商品"
                         ];
    
    self.loadingTipArray = @[
                             @"聚折扣商品全部经人工验货哦~",
                             @"用折800，半年省出一iPhone",
                             @"天天折800，不再被人宰！",
                             @"1折起包邮，给力每一天！",
                             @"妹纸们手起刀落替你砍价",
                             @"每日三嗨：吃饭睡觉折800",
                             @"没有人比我们更心疼你钱包",
                             //            @"心动吧，首次购买送5元哦",
                             //@"下手吧，买贵了8倍赔差价",
                             @"共享吧，邀请好友送80积分",
                             @"商品全人工砍价，9.9还包邮",
                             @"设置身份，订制属于你的商品",
                             @"商品来自淘宝天猫精挑细选",
                             @"折800，便宜一样有好货",
                             @"每晚8点上新，疯狂夜场开抢",
                             @"淘宝双十一39，折800只要9.9",
                             @"折800-您的私人砍价师",
                             @"商品经9大工序验货才上线",
                             @"签到攒积分可换购商品哦 ",
                             @"折800能充话费、买彩票啦",
                             @"设置宝宝生日，优选适龄商品",
                             @"品牌团，打折的名牌",
                             @"值得逛，为爱美的你省钱",
                             @"折800积分能免费兑换商品哦",
                             @"折800，69元搞定全身行头"
                             ];
    
    
    //1--男；2--有为青年；3--大叔；4--女；5--潮女；6--辣妈
    self.userRoleDict = @{
                          @"1" : @"男",
                          @"2" : @"男",
                          @"3" : @"男",
                          @"4" : @"女",
                          @"5" : @"女",
                          @"6" : @"辣妈",
                          };
    
    if (self.shops == nil) {
        self.shops = [NSMutableArray arrayWithCapacity:0];
    }
    
    if (self.goods == nil) {
        self.goods = [NSMutableArray arrayWithCapacity:0];
    }
    
    //必须放在城市初始化前
    [self loadCurrentVer];
    self.isSlip = NO;
    if (self.city == nil) {
        TBCityVo *firstLoadCity = [[TBCityVo alloc] init];
        firstLoadCity.name = @"北京";
        firstLoadCity.cityId = @"1";
        firstLoadCity.longitude = 116.394997;
        firstLoadCity.latitude = 39.925487;
        firstLoadCity.flag = 1;
        firstLoadCity.pinyin = @"beijing";
        self.city = firstLoadCity;
    }
    
    Tao800UGCSingleton *ugc = [Tao800UGCSingleton sharedInstance];
    [[Tao800CatVoSingleton sharedInstance] getCustomCategory];
    [ugc StartLogTimer];
    
    [self loadApplicationConfig];
    
    [TBFileUtil copyAppDbFileToDocument:DBFileName];
    //拷贝数据库文件
    _networkManager = [[Tao800NetworkManager alloc] init];
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:DateFormatString1];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(setCurrentCity:)
    //                                                 name: TB_SWITCH_CITY_NOTIFICATION_NAME
    //                                               object:nil];
    //定位地址获取成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setModelGpsCity)
                                                 name:TBGpsManagerDidSuccessNotification
                                               object:nil];
    //注册获取地址成功的处理函数
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadAddressByCoordinate:)
                                                 name:TBGpsManagerDidGetAddressNotification
                                               object:nil];
    
    //定位失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationError) name:TBGpsManagerDidErrorNotification object:nil];
    
    self.lbsModel = [TBGpsManagerV2 sharedInstance];
    //    [self.lbsModel startGps];
    
    //拷贝文件
    if (!self.urlFilterDict) {
        NSString *appPath = [[NSBundle mainBundle] resourcePath];
        NSString *jsonPath = [appPath stringByAppendingPathComponent:@"urlFilter.json"];
        NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:jsonPath];
        NSData *data = [fh readDataToEndOfFile];
        
        NSString *aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.urlFilterDict = [aStr JSONValue];
        
    }     
    
    /////////////////////判断新老用户状态
    [self resetUserState:YES];
    
    [self resetFavorites];
    //充值过的手机号码数组
    if (self.rechargePhones == nil) {
        self.rechargePhones = [NSMutableArray arrayWithCapacity:0];
    }
    
    
    //开卖提醒一直开着 v3.1需求
    self.acceptAlertWhenSaleBeginNotification = YES;
    
    //v3.2 曝光打点数据
    if (!self.saveDealLogs) {
        self.saveDealLogs = [NSMutableArray arrayWithCapacity:0];
    }
    if (!self.uploadingDealLogs) {
        self.uploadingDealLogs = [NSMutableArray arrayWithCapacity:0];
    }
    if (!self.saunterAllCategoryArrays) {
        self.saunterAllCategoryArrays = [NSMutableArray arrayWithCapacity:5];
    }
    self.fromScan = NO;
    
    
    self.autoLoginManager = [[Tao800AutoLoginManager alloc] init];
}

+ (Tao800DataModelSingleton *)sharedInstance {
    @synchronized (self) {
        if (_instance == nil) {
            // 获取基础目录
            NSString *documentDirectory = [TBFileUtil getDocumentBaseDir];
            // 获取基础文件
            NSString *documentArchivePath = [documentDirectory stringByAppendingFormat:@"/%@", archiveFileName];
            // 获取缓存目录
            NSString *cacheDirectory = [TBFileUtil getCacheDirWithCreate:NO];
            // 获取缓存文件
            NSString *cacheArchivePath = [cacheDirectory stringByAppendingFormat:@"/%@", archiveFileName];
            
            // 判断缓存文件是否存在
            NSFileManager *fm = [NSFileManager defaultManager];
            if ([fm fileExistsAtPath:cacheArchivePath]) {
                // 存在
                //剪切文件
                BOOL moveResult = [TBFileUtil moveFile:cacheArchivePath ToFile:documentArchivePath forceMove:YES];
                if (moveResult) {
                    _instance = [NSKeyedUnarchiver unarchiveObjectWithFile:documentArchivePath];
                    _instance.documentDirectory = documentDirectory;
                    [_instance initData];
                } else {
                    _instance = [NSKeyedUnarchiver unarchiveObjectWithFile:documentArchivePath];
                    _instance.documentDirectory = documentDirectory;
                    [_instance initData];
                }
            } else {
                // 不存在
                _instance = [NSKeyedUnarchiver unarchiveObjectWithFile:documentArchivePath];
                _instance.documentDirectory = documentDirectory;
                [_instance initData];
            }
        }
        if (_instance == nil) {
            _instance = [[self alloc] init];
            _instance.acceptNotification = YES;
            _instance.acceptAlertWhenSaleBeginNotification = YES;
            _instance.acceptCommentDailyNotification = YES;
            [_instance initData];
        }
        
    }
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized (self) {
        
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
            return _instance;  // assignment and return on first allocation
        }
    }
    
    return nil; //on subsequent allocation attempts return nil
}

#pragma mark ------------custom Methods--------------
- (BOOL)archive {
    return [NSKeyedArchiver archiveRootObject:self
                                       toFile:[self.documentDirectory stringByAppendingFormat:@"/%@", archiveFileName]];
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.user forKey:@"user"];
    [aCoder encodeObject:self.userPassword forKey:@"userPassword"];
    [aCoder encodeObject:self.taobaoVo forKey:@"taobaoVo"];
    [aCoder encodeObject:self.tencentVo forKey:@"tencentVo"];
    [aCoder encodeObject:self.sinaWeiboVo forKey:@"sinaWeiboVo"];
    
    [aCoder encodeObject:self.myGradeVo forKey:@"myGradeVo"];
    [aCoder encodeObject:self.dailyRecommendDealVo forKey:@"dailyRecommendDealVo"];
    [aCoder encodeObject:self.lastGetDailyRecommendDate forKey:@"lastGetDailyRecommendDate"];
    [aCoder encodeObject:self.signDate forKey:@"signDate"];
    [aCoder encodeObject:self.firstStartDealWeb forKey:@"firstStartDealWeb"];
    
    [aCoder encodeBool:self.textMode forKey:@"textMode"];
    [aCoder encodeBool:self.acceptNotification forKey:@"acceptNotification"];
    [aCoder encodeBool:self.acceptCommentDailyNotification forKey:@"acceptCommentDailyNotification"];
    [aCoder encodeBool:self.acceptAlertWhenSaleBeginNotification forKey:@"acceptAlertWhenSaleBeginNotification"];
    [aCoder encodeBool:self.acceptCheckInNotification forKey:@"acceptCheckInNotification"];
    
    [aCoder encodeBool:self.baseLogCommitted forKey:@"baseLogCommitted"];
    [aCoder encodeInt:self.currentModel forKey:@"currentModel"];
    
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.gpsCity forKey:@"gpsCity"];
    [aCoder encodeObject:self.shops forKey:@"shops"];
    [aCoder encodeObject:self.goods forKey:@"goods"];
    [aCoder encodeBool:self.IKnowButtonClickedFlag forKey:@"IKnowButtonClickedFlag"];
    [aCoder encodeObject:self.lastShowFanjifenDate forKey:@"lastShowFanjifenDate"];
    
    [aCoder encodeObject:self.recordedDate forKey:@"recordedDate"];
    [aCoder encodeObject:self.urlFilterDict forKey:@"urlFilterDict"];
    
    [aCoder encodeObject:self.oldCurrVersion forKey:@"oldCurrVersion"];
    
    [aCoder encodeObject:self.recommendCid forKey:@"recommendCid"];
    [aCoder encodeObject:self.isShowPhoneRechargeButton forKey:@"isShowPhoneRechargeButton"];
    
    [aCoder encodeObject:self.configBVO forKey:@"configBVO"];
    [aCoder encodeObject:self.userScoreInfoVo forKey:@"userScoreInfoVo"];
    [aCoder encodeObject:self.heartReachedBvo forKey:@"heartReachedBvo"];
    [aCoder encodeBool:self.isCoverInstall forKey:@"isCoverInstall"];
    
    [aCoder encodeBool:self.isClearTaobaoCookie forKey:@"isClearTaobaoCookie"];
    [aCoder encodeObject:self.lastEnterAppDate forKey:@"lastEnterAppDate"];
    
    [aCoder encodeBool:self.fromNew forKey:@"fromNew"];
    
    [aCoder encodeObject:self.rechargePhones forKey:@"rechargePhones"];
    
    [aCoder encodeObject:self.weixinAndQQFollowDic forKey:@"weixinAndQQFollowDic"];
    [aCoder encodeObject:self.onceRequestCheckInHistory forKey:@"onceRequestCheckInHistory"];
    [aCoder encodeObject:self.favoriteModelDict forKey:@"favoriteModelDict"];
    [aCoder encodeObject:self.statusBarClickCache forKey:@"statusBarClickCache"];
    [aCoder encodeInt:self.totalScore forKey:@"totalScore"];
    [aCoder encodeObject:self.searchKeyWord forKey:@"searchKeyWord"];
    [aCoder encodeObject:self.saveDealLogs forKey:@"saveDealLogs"];
    [aCoder encodeObject:self.uploadingDealLogs forKey:@"uploadingDealLogs"];
    [aCoder encodeObject:self.version forKey:@"version"];
    [aCoder encodeObject:self.lastEnterDetailDate forKey:@"lastEnterDetailDate"];
    [aCoder encodeObject:self.lastEnterSaunterDate forKey:@"lastEnterSaunterDate"];
    [aCoder encodeObject:self.listVersion forKey:@"listVersion"];
    
    [aCoder encodeInt:userExistsFromAppTimes forKey:@"userExistsFromAppTimes"];
    [aCoder encodeInt:userExistsThenPushTimes forKey:@"userExistsThenPushTimes"];
    [aCoder encodeBool:userFinishPushToShare forKey:@"userFinishPushToShare"];
    [aCoder encodeObject:self.remotePushArray forKey:@"remotePushArray"];
    [aCoder encodeBool:self.enableStartSellMaskInPersonalHome forKey:@"enableStartSellMaskInPersonalHome"];
    
    
    [aCoder encodeObject:self.userClickPersonalCenterDotDic forKey:@"userClickPersonalCenterDotDic"];
    [aCoder encodeBool:self.userEverChooseAnIdetity forKey:@"userEverChooseAnIdetity"];
    [aCoder encodeBool:self.enableShowPromotionHomePage forKey:@"enableShowPromotionHomePage"];
    [aCoder encodeBool:self.enableShowCustomServerIMPage forKey:@"enableShowCustomServerIMPage"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self.user = [aDecoder decodeObjectForKey:@"user"];
    self.userPassword = [aDecoder decodeObjectForKey:@"userPassword"];
    self.taobaoVo = [aDecoder decodeObjectForKey:@"taobaoVo"];
    self.tencentVo = [aDecoder decodeObjectForKey:@"tencentVo"];
    self.sinaWeiboVo = [aDecoder decodeObjectForKey:@"sinaWeiboVo"];
    self.myGradeVo = [aDecoder decodeObjectForKey:@"myGradeVo"];
    self.dailyRecommendDealVo = [aDecoder decodeObjectForKey:@"dailyRecommendDealVo"];
    self.lastGetDailyRecommendDate = [aDecoder decodeObjectForKey:@"lastGetDailyRecommendDate"];
    self.signDate = [aDecoder decodeObjectForKey:@"signDate"];
    self.firstStartDealWeb = [aDecoder decodeObjectForKey:@"firstStartDealWeb"];
    
    self.textMode = [aDecoder decodeBoolForKey:@"textMode"];
    self.acceptNotification = [aDecoder decodeBoolForKey:@"acceptNotification"];
    self.acceptCommentDailyNotification = [aDecoder decodeBoolForKey:@"acceptCommentDailyNotification"];
    self.acceptAlertWhenSaleBeginNotification = [aDecoder decodeBoolForKey:@"acceptAlertWhenSaleBeginNotification"];
    self.acceptCheckInNotification = [aDecoder decodeBoolForKey:@"acceptCheckInNotification"];
    
    self.baseLogCommitted = [aDecoder decodeBoolForKey:@"baseLogCommitted"];
    self.currentModel = [aDecoder decodeIntForKey:@"currentModel"];
    
    self.city = [aDecoder decodeObjectForKey:@"city"];
    self.gpsCity = [aDecoder decodeObjectForKey:@"gpsCity"];
    self.shops = [aDecoder decodeObjectForKey:@"shops"];
    self.goods = [aDecoder decodeObjectForKey:@"goods"];
    self.IKnowButtonClickedFlag = [aDecoder decodeBoolForKey:@"IKnowButtonClickedFlag"];
    self.lastShowFanjifenDate = [aDecoder decodeObjectForKey:@"lastShowFanjifenDate"];
    self.recordedDate = [aDecoder decodeObjectForKey:@"recordedDate"];
    self.urlFilterDict = [aDecoder decodeObjectForKey:@"urlFilterDict"];
    
    self.oldCurrVersion = [aDecoder decodeObjectForKey:@"oldCurrVersion"];
    
    self.recommendCid = [aDecoder decodeObjectForKey:@"recommendCid"];
    self.isShowPhoneRechargeButton = [aDecoder decodeObjectForKey:@"isShowPhoneRechargeButton"];
    
    self.configBVO = [aDecoder decodeObjectForKey:@"configBVO"];
    self.userScoreInfoVo = [aDecoder decodeObjectForKey:@"userScoreInfoVo"];
    self.heartReachedBvo = [aDecoder decodeObjectForKey:@"heartReachedBvo"];
    self.isCoverInstall = [aDecoder decodeBoolForKey:@"isCoverInstall"];
    
    self.isClearTaobaoCookie = [aDecoder decodeBoolForKey:@"isClearTaobaoCookie"];
    self.lastEnterAppDate = [aDecoder decodeObjectForKey:@"lastEnterAppDate"];
    
    self.fromNew = [aDecoder decodeBoolForKey:@"fromNew"];
    
    self.weixinAndQQFollowDic = [aDecoder decodeObjectForKey:@"weixinAndQQFollowDic"];
    
    
    self.onceRequestCheckInHistory = [aDecoder decodeObjectForKey:@"onceRequestCheckInHistory"];
    
    self.rechargePhones = [aDecoder decodeObjectForKey:@"rechargePhones"];
    self.favoriteModelDict = [aDecoder decodeObjectForKey:@"favoriteModelDict"];
    self.statusBarClickCache = [aDecoder decodeObjectForKey:@"statusBarClickCache"];
    self.totalScore = [aDecoder decodeIntForKey:@"totalScore"];
    self.searchKeyWord = [aDecoder decodeObjectForKey:@"searchKeyWord"];
    self.saveDealLogs = [aDecoder decodeObjectForKey:@"saveDealLogs"];
    self.uploadingDealLogs = [aDecoder decodeObjectForKey:@"uploadingDealLogs"];
    self.version = [aDecoder decodeObjectForKey:@"version"];
    self.lastEnterDetailDate = [aDecoder decodeObjectForKey:@"lastEnterDetailDate"];
    self.lastEnterSaunterDate = [aDecoder decodeObjectForKey:@"lastEnterSaunterDate"];
    self.listVersion = [aDecoder decodeObjectForKey:@"listVersion"];
    self.userExistsThenPushTimes = [aDecoder decodeIntForKey:@"userExistsThenPushTimes"];
    self.userExistsFromAppTimes = [aDecoder decodeIntForKey:@"userExistsFromAppTimes"];
    self.userFinishPushToShare = [aDecoder decodeBoolForKey:@"userFinishPushToShare"];
    self.remotePushArray = [aDecoder decodeObjectForKey:@"remotePushArray"];
    self.enableStartSellMaskInPersonalHome = [aDecoder decodeBoolForKey:@"enableStartSellMaskInPersonalHome"];
    
    self.userClickPersonalCenterDotDic = [aDecoder decodeObjectForKey:@"userClickPersonalCenterDotDic"];
    self.userEverChooseAnIdetity = [aDecoder decodeBoolForKey:@"userEverChooseAnIdetity"];
    self.enableShowPromotionHomePage = [aDecoder decodeBoolForKey:@"enableShowPromotionHomePage"];
    self.enableShowCustomServerIMPage = [aDecoder decodeBoolForKey:@"enableShowCustomServerIMPage"];
    
    return self;
}

/**
 * 获取基础信息，不包含手机号、渠道ID
 */
- (TBLogAnalysisBaseHeader *)getHeaderVo {
    if (_headerVo == nil) {
        _headerVo = [[TBLogAnalysisBaseHeader alloc] init];
        UIDevice *device = [UIDevice currentDevice];
        UIScreen *screen = [UIScreen mainScreen];
        NSString *resolution = [NSString stringWithFormat:@"%d*%d",
                                (int) screen.currentMode.size.width,
                                (int) screen.currentMode.size.height];
        
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = info.subscriberCellularProvider;
        
        //        NSString *deviceIdentifier = [OpenUDID value];  //todo
        //        if (RequireSysVerGreaterOrEqual(@"7.0")) {
        //            _headerVo.deviceId = deviceIdentifier;
        //        } else {
        //            _headerVo.deviceId = self.macAddress;
        //        }
        
        _headerVo.deviceId = self.macAddress;
        _headerVo.macAddress = self.macAddress;
        _headerVo.systemName = @"iPhone";// e.g. 系统类型
        _headerVo.phoneModel = TBMachine();//e.g. @"iPhone", @"iPod touch" ,@"iPad"　设备型号;
        _headerVo.phoneVersion = [device systemVersion];// e.g. @"4.0"
        _headerVo.resolution = resolution;
        _headerVo.carrier = carrier;
        _headerVo.appName = _product;
        _headerVo.appVersion = self.currentVersion;
        _headerVo.partner = _partner;
        _headerVo.platform = @"iPhone"; // 平台类型
        
        [TBBaseNetworkApi setLLogAnalysisBaseHeader:_headerVo]; // 设置tbbz
    }
    return _headerVo;
}

//不需要该方法
- (void)dealloc {
}

/**
 * apns推送服务用的token
 */
- (NSString *)apnsDeviceToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"apnsDeviceToken"];
}

- (void)apnsDeviceToken:(NSString *)apnsDeviceToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:apnsDeviceToken forKey:@"apnsDeviceToken"];
}

- (BOOL)deviceTokenSendOk {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"deviceTokenSendOk"];
}

- (void)setDeviceTokenSendOk:(BOOL)sendOk {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sendOk forKey:@"deviceTokenSendOk"];
}

/**
 * 硬件网卡地址
 */
- (NSString *)macAddress {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *macAddress = [defaults objectForKey:@"macAddress"];
    if (!macAddress) {
        macAddress = [Tao800Util getDeviceId];
        [self macAddress:macAddress];
    }
    return macAddress;
}

- (void)macAddress:(NSString *)macAddress {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:macAddress forKey:@"macAddress"];
}

- (void)setCurrentCity:(NSNotification *)ns {
    if (ns.userInfo == nil) return;
    
    TBCityVo *xcity = [ns.userInfo objectForKey:@"city"];
    if (xcity) {
        if (self.city == nil) {//第一次安装
            self.city = xcity;
        } else {
            self.city = xcity;
        }
        
        [self archive];
        
        //通知其他视图更新
        [[NSNotificationCenter defaultCenter] postNotificationName:M800DataModelSingletonCityDidChangeNotification object:nil];
    }
}

- (void)reloadAddressByCoordinate:(id)sender {
    TBGpsManagerV2 *lbsModel = self.lbsModel;
    TBGpsAddressVo *addressVo = lbsModel.gpsAddress;
    NSArray *allCityArr = [self getAllCities];
    for (TBCityVo *cityVo in allCityArr) {
        if ([addressVo.cityName isEqualToString:cityVo.name]) {
            self.city = cityVo;
            [self archive];
        }
    }
}

- (void)locationError {
    
}

- (void)setModelGpsCity {
    TBDPRINT(@"定位成功");
    NSArray *cities = [self getAllCities];
    for (TBCityVo *city in cities) {
        
        if ([city.name isEqualToString:self.lbsModel.gpsAddress.cityName]) {
            NSLog(@"self.lbsModel.gpsAddress.cityName:%@", self.lbsModel.gpsAddress.cityName);
            self.gpsCity = city;
            self.city = self.gpsCity;
            break;
        }
    }
}

- (NSArray *)getAllCities {
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"txt"];
    NSString *_jsonContent = [[NSString alloc] initWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *jsonDic = [_jsonContent JSONValue];
    
    NSMutableArray *cityArr = [jsonDic objectForKey:@"cities"];
    
    NSMutableArray *allCityArr = [NSMutableArray arrayWithCapacity:cityArr.count];
    for (NSDictionary *city in cityArr) {
        TBCityVo *cityVo = [[TBCityVo alloc] init];
        cityVo.cityId = [city objectForKey:@"id"];
        cityVo.name = [city objectForKey:@"name"];
        cityVo.pinyin = [city objectForKey:@"pinyin"];
        cityVo.latitude = [[city objectForKey:@"latitude"] doubleValue];
        cityVo.longitude = [[city objectForKey:@"longitude"] doubleValue];
        cityVo.flag = [[city objectForKey:@"flag"] intValue];
        [allCityArr addObject:cityVo];
    }
    return allCityArr;
    
}

- (NSArray *)getHotCities {
    NSArray *allArr = [self getAllCities];
    NSMutableArray *hotCities = [NSMutableArray arrayWithCapacity:0];
    for (TBCityVo *cityVo in allArr) {
        if (cityVo.flag == 1) {
            [hotCities addObject:cityVo];
        }
    }
    return hotCities;
}

/**
 * 当前选中的城市
 */
- (NSString *)currentCityId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kTBBaseGlobalModelCity];
}

- (void)currentCityId:(NSString *)cityid {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:cityid forKey:kTBBaseGlobalModelCity];
}

- (void)refreshGPS {
    if (self) {
        [self.lbsModel startGps];
    }
}

@end
