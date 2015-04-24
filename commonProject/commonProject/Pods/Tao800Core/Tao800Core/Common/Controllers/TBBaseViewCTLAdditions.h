//
// Created by enfeng on 12-10-23.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <TBUI/TBBaseViewCTL.h>
#import <TBNetwork/TBNetworkWrapper.h>
#import <Foundation/Foundation.h>
#import "TBService/Tuan800API.h"
#import "Tao800ScreenTipView.h"
#import "Tao800DealVo.h"
#import "Tao800LoadingView.h"
#import "Tao800NewScreenTipView.h"

#define Tao800RedStatusBar (8009) 

typedef enum _Tao800PageTipType {
    Tao800PageTipTypeNetworkNotReachable, //网络断开   当前处于无网络状态，请检查设置
    Tao800PageTipTypeNetworkTimeout, //网络连接超时    当前网络不稳定，点击屏幕重新加载
    Tao800PageTipTypeNetworkServer500, //服务器出现500错误  工程师们正在抢修，请稍后再试
    Tao800PageTipTypeNetworkServer404, //服务器出现404错误  工程师们正在抢修，请稍后再试
    Tao800PageTipTypeNetworkError, //网络连接错误
    Tao800PageTipTypeNoData, //无数据提示
} Tao800PageTipType;

typedef enum PageCategoryType {
    PageCategoryTypeDealToday = 0, //聚频道
    PageCategoryTypeCheap, // 逛频道
    PageCategoryTypeTopic, // 专题
} PageCategoryType;

@interface TBBaseViewCTL (Tao800Category) <TBBaseNetworkDelegate, Tao800ScreenTipViewDelegate,Tao800NewScreenTipViewDelegate>

- (void)didNetworkError:(NSDictionary *)params;

/**
* 为导航添加返回按钮
*/
- (void)addBackButtonToNavigator;

- (void)goBackFromNavigator;

- (void)resetStyleForIOS7;


#pragma mark -显示在页面内的Loading -

- (void)showPageLoading:(BOOL)show;

#pragma mark - 显示在页面内的文本提示 -

/**
* 显示在整个页面中的提示
*
* @param title
* @param detail
* @param tipType 参照 Tao800PageTipType 说明
*/
- (void)showPageTip:(NSString *)title detail:(NSString *)detail tipType:(Tao800PageTipType)tipType;
- (void)showPageTip:(NSString *)title detail:(NSString *)detail tipType:(Tao800PageTipType)tipType buttonTitle:(NSString*)btnTitle;

- (void)showNoDataPageTip:(NSString *)title detail:(NSString *)detail hideButton:(BOOL) hideButton;

- (void)hidePageTip;

#pragma mark - 悬浮Loading -

/**
* 显示一个盖在页面上打Loading框
*/
- (void)showPopupLoadingView:(NSString *)message fullScreen:(BOOL)fullScreen;

- (void)showPopupLoadingView:(NSString *)message fullScreen:(BOOL)fullScreen closeCallback:(Tao800LoadingViewCloseCallback) closeCallback;

- (void)showPopupLoadingView:(NSString *)message subText:(NSString *)subText fullScreen:(BOOL)fullScreen;

- (void)hidePopupLoadingView;

/**
* 处理Service接口的错误回调
*
*/
- (void)dealError:(TBErrorDescription *)error;

- (void)addBackButton;

- (void)addTopHorizontalLine;

- (NSString *)getNoNetworkHtml:(NSString *)error; // 获取无网络时html内容
- (void)viewWillAppearDeal:(BOOL)animated;

- (void)bringBubbleViewToFront;
@end