//
//  TN800StaticConstant.m
//  Tuan800
//
//  Created by enfeng yang on 11-10-26.
//  Copyright (c) 2011年 mac. All rights reserved.
//

#import "Tao800StaticConstant.h"

NSString *const AppName = @"tao800";
NSString *const DateFormatString1 = @"yyyy-MM-dd HH:mm:ss";

NSString *const DBFileName = @"tb.sqlite";
NSString *const CategoryFileName = @"category.txt";
NSString *const StartSellFileName = @"startsell.txt";
NSString *const AddressCityFileName = @"addressCity.txt";
NSString *const CategoryCacheFileName = @"v354category.txt";
NSString *const CategoryLocalFileName = @"v5tag.txt";

NSString *const DealOrderDefault = @"";
NSString *const DealOrderPrice = @"price";  // 价格最低
NSString *const DealOrderSalesVolume = @"saled";
NSString *const DealOrderPriced = @"priced";
NSString *const DealOrderPriceNew = @"publishTime";

const CGFloat Tao800DefaultTabbarHeight = 45;

#ifdef __IPHONE_7_0
NSString *const AppStoreCommentUrl = @"itms-apps://itunes.apple.com/app/id502804922";
#else
NSString *const AppStoreCommentUrl = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=502804922";
#endif

NSString *const Tao800DownloadingAppsRemindTipNotShowAgain = @"DownloadingAppsTipNotShowAgain";
NSString *const UserDefaultKeyHomeToday = @"UserDefaultKeyHomeToday";

#ifdef DEBUG
NSString *const Tao800PassportSessionURLPath = @"http://passport.xiongmaot.com/";
#else
NSString *const Tao800PassportSessionURLPath = @"https://passport.zhe800.com/";
#endif


NSString *const Tao800PaycChannelAlixPay = @"alipay";
NSString *const Tao800PaycChannelWexinPay = @"weixin";
NSString *const Tao800DealListVCLCountEachDayOut = @"countEachDayOut"; //30天内进入主页列表和分类列表详情页的次数
NSString *const UserDefaultKeyUGCSingletonNoteVisitZhe800Date = @"UserDefaultKeyUGCSingletonNoteVisitZhe800Date";   //90天内是否访问客户端统计
NSString *const UserDefaultKeyUGCSingletonNoteVisitSaunterDate = @"UserDefaultKeyUGCSingletonNoteVisitSaunterDate";   //90天内是否访问值得逛统计

NSString *const Tao800InviteFriendsWeixinShareURL = @"http://m.zhe800.com/download_weixinshare";
