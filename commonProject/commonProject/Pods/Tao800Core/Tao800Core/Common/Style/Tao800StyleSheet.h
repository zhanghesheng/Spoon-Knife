//
//  Tao800StyleSheet.h
//  tao800
//
//  Created by worker on 12-10-23.
//  Copyright (c) 2012年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBUI/UIColor+Hex.h"

//红色背景
#define BACKGROUND_COLOR_RED1 [UIColor colorWithHex:0xE63955]

//边框颜色， 灰色
#define BORDER_COLOR_GRAY1 [UIColor colorWithHex:0xD3D3D3]

#define BORDERLINE_COLOR_GRAY1 [UIColor colorWithHex:0xE5E5E5]
#define BORDERLINE_COLOR_GRAY2 [UIColor colorWithHex:0xDDDDDD]
#define BORDERLINE_COLOR_GRAY3 [UIColor colorWithHex:0xF5F5F5]
//灰色背景
#define BACKGROUND_COLOR_GRAY1 [UIColor colorWithHex:0xF0F0F0]
//灰色背景 收藏背景
#define BACKGROUND_COLOR_GRAY2 [UIColor colorWithHex:0xF6F6F6]

//积分商城segbar 底色灰
#define BACKGROUND_COLOR_GRAT2 [UIColor colorWithHex:0xF9F9F9]
#define BACKGROUND_COLOR_GRAT3 [UIColor colorWithHex:0xDDDDDD]

#define TEXT_COLOR_BLACK1 [UIColor colorWithHex:0x333333]
#define TEXT_COLOR_BLACK2 [UIColor colorWithHex:0x444444]
#define TEXT_COLOR_BLACK3 [UIColor colorWithHex:0x666666]
#define TEXT_COLOR_BLACK4 [UIColor colorWithHex:0xA0A0A0]
#define TEXT_COLOR_BLACK5 [UIColor colorWithHex:0xD1D1D1]
#define TEXT_COLOR_BLACK6 [UIColor colorWithHex:0x848484]
#define TEXT_COLOR_BLACK7 [UIColor colorWithHex:0x677487]
#define TEXT_COLOR_BLACK8 [UIColor colorWithHex:0x9B9B9B]
#define TEXT_COLOR_BLACK9 [UIColor colorWithHex:0x5d646f]
#define TEXT_COLOR_BLACK10 [UIColor colorWithHex:0x3e4346]
#define TEXT_COLOR_BLACK11 [UIColor colorWithHex:0xD0D0D0]
#define TEXT_COLOR_BLACK12 [UIColor colorWithHex:0xACACAC]
#define TEXT_COLOR_BLACK13 [UIColor colorWithHex:0x959595]
#define TEXT_COLOR_BLACK14 [UIColor colorWithHex:0x697486]


#define TEXT_COLOR_GRAT1 [UIColor colorWithHex:0x848484]
//文字灰色
#define TEXT_COLOR_GRAY1 [UIColor colorWithHex:0xbbbbbb]
#define TEXT_COLOR_GRAY2 [UIColor colorWithHex:0xe7e7e7]
#define TEXT_COLOR_GRAY3 [UIColor colorWithHex:0xfee1e4]
#define TEXT_COLOR_GRAY4 [UIColor colorWithHex:0xe5e5e5]



#define TEXT_COLOR_RED1 [UIColor colorWithHex:0xE63B53]
#define TEXT_COLOR_RED2 [UIColor colorWithHex:0xED818D]
#define TEXT_COLOR_RED3 [UIColor colorWithHex:0xE53352]

#define TEXT_COLOR_PINK [UIColor colorWithHex:0xFB7893]

extern CGFloat const ButtonCornerRadius;

#define V3_18PX_FONT [UIFont systemFontOfSize:11]
#define V3_20PX_FONT [UIFont systemFontOfSize:12]
#define V3_22PX_FONT [UIFont systemFontOfSize:13]
#define V3_24PX_FONT [UIFont systemFontOfSize:14]
#define V3_26PX_FONT [UIFont systemFontOfSize:15]
#define V3_28PX_FONT [UIFont systemFontOfSize:16]
#define V3_30PX_FONT [UIFont systemFontOfSize:17]
#define V3_34PX_FONT [UIFont systemFontOfSize:18]
#define V3_36PX_FONT [UIFont systemFontOfSize:19]

///////////////////////颜色///////////////////////
//常规文字
#define V550ColorNormal [UIColor colorWithHex:0x333333]

//阐述详情类，描述性文字，文字区域较大的地方使用
#define V550ColorDescription [UIColor colorWithHex:0x666666]

//比较淡的文字颜色
#define V550ColorLight [UIColor colorWithHex:0x999999]
//手机充值纪录，充值状态文字颜色
#define V550MobileRecordStatusColor [UIColor colorWithHex:0xff6076]


//团800 6.0
#define CELL_LINE_COLOR [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.02/255.0 alpha:1]
//团800 6.0 分割线
#define V600BackgroundDarkColor [UIColor colorWithHex:0xF2F2F2]


//00 全局组件高度
#define HorizontalLayerHeight 0
#define HorizontalBarHeight 32
#define NavigationBarHeight 44
#define Tao800BrandHorizontalBarHeight 44

//０１主体配色系统

// TabbarItem的图片选中状态颜色
#define TabBarItemImageSelectedColor [UIColor colorWithHex:0xff644e]
// Tabbar文字普通状态颜色
#define TabBarTextNormalColor [UIColor whiteColor]
// Tabbar文字选中状态颜色
#define TabBarTextSelectedColor [UIColor colorWithHex:0xff644e]
// Tabbar文字字体大小
#define TabBarTextFont [UIFont systemFontOfSize:12]

// 导航条背景色
#define NavBarBackColor [UIColor colorWithRed:172.0/255.0 green:60.0/255.0 blue:38.0/255.0 alpha:1]
#define NavBarBackImage [UIImage imageNamed:@"nav_bg@2x.png"]
// 全局背景色
#define kGlobalBackgroundColor [UIColor colorWithHex:0xf2f2f2]
// 分割线颜色
#define kSeparatorColor [UIColor colorWithHex:0xbababa]

//０２关于字色

//主要内容文字颜色，如：商品标题
#define kGlobelColor1 [UIColor colorWithHex:0x242424]
//全局灰色文字颜色
#define kGlobelColor2 [UIColor colorWithHex:0x686868]
//个别辅助性文字色，如：原价
#define kGlobelColor3 [UIColor colorWithHex:0x767676]
//个别需要强调的字色，如：价格
#define kGlobelColor4 [UIColor colorWithHex:0xff4e35]
//全局橙色文字或图片颜色
#define kGlobelColor5 [UIColor colorWithHex:0xff6445]
//全局绿色文字或图片颜色
#define kGlobelColor6 [UIColor colorWithHex:0x63c000]
//全局黄色文字或图片姿色
#define kGlobelColor7 [UIColor colorWithHex:0xffa800]
//全局红色文字或图片姿色
#define kGlobelColor8 [UIColor colorWithHex:0xff3600]

//０３关于字号

//顶部导航条标题和详情页标题
#define kGlobelFont20 [UIFont boldSystemFontOfSize:20]
//界面中的主题
#define kGlobelFont16 [UIFont systemFontOfSize:16]
//常规内容文字
#define kGlobelFont14 [UIFont systemFontOfSize:14]
//长段落文字(规范里的１１都按照１２)
#define kGlobelFont12 [UIFont systemFontOfSize:12]
//仅作显示时间
//#define kGlobelFont10 [UIFont systemFontOfSize:11]

//０４布局间距
#define kGlobeSpac25 25
#define kGlobeSpac20 20
#define kGlobeSpac10 10
#define kGlobeSpac7  7
#define kGlobeSpac5  5

//０５字体高度
#define kGlobeFontHeight16 16
#define kGlobeFontHeight14 14
#define kGlobeFontHeight12 12

//线条颜色
#define GlobalLineColor RGBCOLOR(209, 209, 209)

@interface Tao800StyleSheet : NSObject

@end
