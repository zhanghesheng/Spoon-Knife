//
//  Tao800LogParams.h
//  tao800
//
//  Created by wuzhiguang on 12-11-9.
//  Copyright (c) 2012年 com.tuan800.tao800iphone. All rights reserved.
//
#import <Foundation/Foundation.h>
//---------事件名称/tag对照表----------
/*
 事件名称	tag
 进入界面	r
 退出页面	p
 分享推荐给好友	s
 push触发事件	pc
 启动详情点击	lp
 Banner位点击	b
 优质商品点击（明日预报）	tb
 推送通知（开关的选择）	t_sm
 去appstore评分（设置）	t_ss
 去appstore评分（弹窗）	t_ws
 查看deal详情  webview
 列表请求（今日精选）	today
 列表请求（明日精选）	tomorrow
 我的淘宝（deal页）mytb
 我的淘宝（设置）mytbs
 淘宝账户登录	tao
 
 ----- 临时事件 -----
 签到	    t_check
 开卖提醒开关	t_clockset
 明日推荐开关	t_dailyset
 邀请好友积分	t_invite
 暂不签到	t_nocheck
 开卖提醒	t_clock
 
 ----- 2.4版新增打点事件 -----
 逛banner位	gb
 值得买	r
 个人中心查订单	t_order
 个人中心购物车	t_cart
 个人中心查物流	t_freight
 
 ----- 2.5版新增打点事件 -----
 活动专题   hot
 启动时发送ios映射关系  init
 
 */
extern NSString *const Event_R;
extern NSString *const Event_P;
extern NSString *const Event_S;
extern NSString *const Event_Pc;
extern NSString *const Event_Pc_PARAM_D;
extern NSString *const Event_Lp;
extern NSString *const Event_B;
extern NSString *const Event_Tb;
extern NSString *const Event_Tsm;
extern NSString *const Event_Tss;
extern NSString *const Event_Tws;
extern NSString *const Event_Webview;
extern NSString *const Event_Today;
extern NSString *const Event_Tomorrow;
extern NSString *const Event_Mytb;
extern NSString *const Event_Mytbs;
extern NSString *const Event_Tao;
extern NSString *const Event_Tcheck;
extern NSString *const Event_Tclockset;
extern NSString *const Event_Tinvite;
extern NSString *const Event_Tnocheck;
extern NSString *const Event_Tdailyset;
extern NSString *const Event_Tclock;

extern NSString *const Event_F;
extern NSString *const Event_Shop;
extern NSString *const Event_Fshop;
extern NSString *const Event_Dscore;
extern NSString *const Event_shai;
extern NSString *const Event_Tbuylogin;
extern NSString *const Event_Scorelogin;

// ----- 2.4版新增打点事件 -----
extern NSString *const Event_Gb;
extern NSString *const Event_Torder;
extern NSString *const Event_Tcart;
extern NSString *const Event_Tfreight;

// ----- 2.5版新增打点事件 -----
extern NSString *const Event_Hot;
extern NSString *const Event_Init;

// ----- 2.7.0版新增打点事件  -----
extern NSString *const Event_Auction; //竞拍商品新高价
extern NSString *const Event_Cb;      //分类banner
extern NSString *const Event_Wx;      //微信关注
extern NSString *const Event_Tsdk;    //进入淘宝SDK列表

// ----- 3.0版新增打点事件  -----
extern NSString *const Event_Identify;//身份选择
extern NSString *const Event_Category;//首页banner下面的 方格入口
extern NSString *const Event_Show;//曝光时记录(例如请求图片时)
extern NSString *const Event_Category_Left_Search;//分类搜索(首页左 上方)
extern NSString *const Event_Category_Search;//搜索框聚焦(分类搜索页)
extern NSString *const Event_Category_Choose;//分类选择(分类页 左侧)
extern NSString *const Event_Favorite_List;//列表收藏
extern NSString *const Event_Forenotice_Clock;//精品预告设置提醒
extern NSString *const Event_Concern_QQZone;//关注qq空间
extern NSString *const Event_Ask_Friend;//￼￼￼￼￼￼￼￼￼￼￼￼￼￼邀请好友注册
extern NSString *const Event_QR_Code;//二维码入口
extern NSString *const Event_QR_Code_Success;//￼￼￼￼￼￼￼￼￼￼￼￼二维码扫描成功(设置提醒)
extern NSString *const Event_Login;//￼￼￼￼￼￼￼￼￼￼￼￼￼￼我要登陆(out提示 登录页面)
extern NSString *const Event_UserInfo;//个人中心
extern NSString *const Event_DisplayAsGrid;//切换列表模式

// ----- 3.1版新增打点事件  -----
extern NSString *const Event_Promotional_Banner;//大促banner
extern NSString *const Event_Baby;              //选择宝宝生日
extern NSString *const Event_Babyset;           //母婴列表上方的 生日设置
extern NSString *const Event_Wishc;             //点击许愿
extern NSString *const Event_Wish_Success;      //许愿成功

// ----- 3.1.1版新增打点事件  -----
extern NSString *const Event_ScoreBuy;          //积分商城我要兑换

// ----- 3.2.1版新增打点事件  -----
extern NSString *const Event_CuClock;           //大促闹钟设置 （点击打开打点）
extern NSString *const Event_PushReceive;       //push到达事件

// ----- 3.3版新增打点事件  -----
extern NSString *const Event_Gb;                //逛分类banner位
extern NSString *const Event_Gbi;               //逛精选banner位
extern NSString *const Event_EarnScore;         //积分商城 赚积分
extern NSString *const Event_Allc;              //分类选择 全部入口
extern NSString *const Event_Dsearch;           //每日十件 关联搜索

// ----- 3.4版新增打点事件  -----
extern NSString *const Event_Oobe;                //结束引导页，包含新安装和升级



// ----- 3.5版本新增打点事件 -----
extern NSString * const Event_Push; // push触发事件（包含ios闹钟）
extern NSString * const Event_Banner; // banner运营位 事件tag: b;
extern NSString * const Event_Open_TaobaoApp; //参数空
extern NSString * const Event_QrCode_Scan_Successfully; //二维码扫描成功（设置提醒）
extern NSString * const Event_Launch_Input_Address; //弹出地址填写提示
extern NSString * const Event_Save_Address; //地址填写保存

// ----- 3.5.2版本新增打点事件 -----
extern NSString *const Event_Rselect;   //列表为空时进入精选预告点击
extern NSString *const Event_Redit;     //列表编辑完成后确认按钮点击

// ----- 3.5.3版本新增打点事件 -----

extern NSString *const Event_Bsc;       //首页分类入口（首页底部tab）

// ----- 3.6.4版本新增打点事件 -----
extern NSString *const Event_Suc;       //分享成功
extern NSString *const Event_BN;        //底部导航
extern NSString *const Event_Roompic;   //虚拟试衣间某专题里面内图片点击
extern NSString *const Event_Roomdone;  //虚拟试衣间拍照图片调整完成
extern NSString *const Event_Agemore;   //母婴点击其他年龄商品按钮
extern NSString *const Event_Brand;     //品牌团tab点击打点

// ----- 3.6.5版本新增打点事件 -----
extern NSString *const Event_Returnttp; //返回当前列表顶部
extern NSString *const Event_Agemore; //母婴点击其他年龄商品按钮
extern NSString *const Event_Brand; //品牌团tab点击打点

// ----- 3.6.6 新增打点
extern NSString *const Event_Qiandaofh; //签到复活打点
extern NSString *const Event_Oy_everyday; //每日领取抽奖码按钮点击
extern NSString *const Event_Oy_score; //积分兑换按钮

extern NSString *const Event_Oy_remind;//设置提醒
extern NSString *const Event_Oy_orderdp;//查看抽奖单
extern NSString *const Event_t_newadr;//弹出地址填写提示
extern NSString *const Event_t_saveadr;//地址填写保存

//---------事件及对应参数列表----------
/*
 事件名称       参数      类型	含义
 进入界面       n	String	ui名称
 退出界面       n	String	ui名称
 分享推荐给好友	t	String	分享方式 0 微信；1新浪微博；2腾讯微博；3开心；4人人；5 短信；6 邮件
 d	String	dealid
 push激活统计	x	String	messageid
 启动详情点击     d	String	bannerid
 Banner点击       d	String	bannerid
 优质商品点击（明日预报）	d	String	商品id
 推送设置       t	String	0 不推送；1推送
 查看Deal详情	d	String	deal id
 m	String	0 今日精选；1 明日预报
 列表请求（今日精选）	t	String	0 来自大图；1 来自列表
 c	String	分类id
 p	String	分页页码
 列表请求（明日精选）	t	String	0 来自大图；1 来自列表
 p	String	分页页码
 开卖提醒开关     t	String	0 关，1 开
 明日推荐开关     t	String	0 关，1 开
 开卖提醒        d	String	deal id
 
 ------ 2.4版新増打点参数 ------
 逛banner位	d	String  bannerid
 值得买		n	String  "zhi"
 
 ------ 2.5版新増打点参数 ------
 活动专题	 d	String  bannerid
 启动时发送	mac String  mac地址
 openudid  String  openudid
 fdid  String  广告id
 
 */
extern NSString *const Event_R_PARAM_N;
extern NSString *const Event_P_PARAM_N;
extern NSString *const Event_S_PARAM_T;
extern NSString *const Event_S_PARAM_D;
extern NSString *const Event_Pc_PARAM_X;
extern NSString *const Event_Lp_PARAM_D;
extern NSString *const Event_B_PARAM_D;
extern NSString *const Event_Tb_PARAM_D;
extern NSString *const Event_Tsm_PARAM_T;
extern NSString *const Event_Webview_PARAM_D;
extern NSString *const Event_Webview_PARAM_M;
extern NSString *const Event_Today_PARAM_T;
extern NSString *const Event_Today_PARAM_C;
extern NSString *const Event_Today_PARAM_P;
extern NSString *const Event_Tomorrow_PARAM_T;
extern NSString *const Event_Tomorrow_PARAM_P;
extern NSString *const Event_Tclockset_PARAM_T;
extern NSString *const Event_Tdailyset_PARAM_T;
extern NSString *const Event_Tclock_PARAM_D;

extern NSString *const Event_F_PARAM_D;
extern NSString *const Event_Shop_PARAM_D;
extern NSString *const Event_Fshop_PARAM_D;
extern NSString *const Event_Dscore_PARAM_D;
extern NSString *const Event_shai_PARAM_D;
extern NSString *const Event_Shop_PARAM_M;

// ------ 2.4版新増打点参数 ------
extern NSString *const Event_Gb_PARAM_D;    // bannerid

// ------ 2.5版新増打点参数 ------
extern NSString *const Event_Hot_PARAM_D;   // bannerid
extern NSString *const Event_Init_PARAM_Mac;
extern NSString *const Event_Init_PARAM_Openudid;
extern NSString *const Event_Init_PARAM_Fdid;

// ------ 2.7.0版新増打点参数 ------
extern NSString *const Event_Cb_PARAM_D;    // bannerid

// ------ 3.0版新増打点参数 ------
extern NSString *const Event_Identify_PARAM_T;//身份选择
extern NSString *const Event_Identify_PARAM_S;//身份选择
extern NSString *const Event_Category_PARAM_D;//首页banner下面的 方格入口
extern NSString *const Event_Category_PARAM_C;//首页banner下面的 方格入口
extern NSString *const Event_Show_PARAM_D;//曝光时记录(例如请求图片时)
extern NSString *const Event_Show_PARAM_S;//曝光时记录(例如请求图片时)
extern NSString *const Event_Show_PARAM_T;//曝光时记录(例如请求图片时)
extern NSString *const Event_Favorite_List_PARAM_D;//列表收藏
extern NSString *const Event_Favorite_List_PARAM_T;//列表收藏
extern NSString *const Event_Forenotice_Clock_PARAM_D;//精品预告设置提醒
extern NSString *const Event_QR_Code_Success_PARAM_D;//￼￼￼￼￼￼￼￼￼￼￼￼二维码扫描成功(设置提醒)
extern NSString *const Event_DisplayAsGrid_PARAM_T;//切换列表模式

// ----- 3.1版新增打点参数 -----
extern NSString *const Event_Promotional_Banner_D;//大促banner
extern NSString *const Event_Baby_T;              //选择宝宝生日
extern NSString *const Event_Baby_S;              //选择宝宝生日 来源
extern NSString *const Event_Wishc_S;             //点击许愿
extern NSString *const Event_Wish_Success_W;      //许愿成功

// ----- 3.1.1版新增打点参数  -----
extern NSString *const Event_ScoreBuy_D;          //积分商城我要兑换

// ----- 3.2版新增打点参数  -----
extern NSString *const Event_B_S;                       //首页banner 顺序打点

// ----- 3.3版新增打点参数  -----
extern NSString *const Event_Gb_D;                //逛分类banner位
extern NSString *const Event_Dsearch_D;           //每日十件 关联搜索

// ----- 3.4版新增打点参数  -----
extern NSString *const Event_School;              //身份选择是否为校园（学生）0 非校园，1 校园



// ----- 3.5版本新增打点参数 -----
NSString * const Event_Push_Id;                  // push id 退出push id：exit
NSString * const Event_Banner_Id ;                // Banner Id
NSString * const Event_Banner_Order;             // Banner顺序 banner顺序，从左侧1-5
NSString * const Event_Banner_Position;           //Banner运营位 位置：1 首页，2 启动大图，3 分类，4 逛分类，5 大促悬挂，6 大促日历，
NSString * const Event_QrCode_Scan_Successfully_Deal_Id;       // 二维码扫描成功deal id
NSString * const Event_QrCode_Scan_Successfully_Type;          // 二维码扫描类型 0 开卖提醒；1 进入详情打点

// ----- 母婴新增打点 ---------

NSString * const Event_MuYing_Table_Switch;         //母婴品牌 单品 切换 品牌p 单品 d
//版本3.6.0 新增打点
// ------母婴新增打点 --------------
extern NSString * const Event_Muying_Categories;    // 母婴最上面的不同的分类打点
extern NSString * const Event_List_More;            // 列表底部“更多”按钮 打点
extern NSString * const Event_About_UpGrade;        //升级打点

//版本3.6.4 新增打点
extern NSString * const Event_Suc_T;        //分享成功的分享方式
extern NSString * const Event_Suc_S;        //分享成功的分享来源
extern NSString * const Event_Suc_D;        //分享成功的分享内容
extern NSString * const Event_Brand_D;      //品牌团tab点击打点
// ------虚拟试衣间新增打点 --------------
extern NSString * const Event_Roompic_D;    //选择的图片ID
extern NSString * const Event_Roomdone_D;   //拍照模板图片ID
extern NSString * const Event_Banner_U;   //用户身份角色，拼接方式：新老用户_用户身份_是否学生 如：新用户女学生 0_4_0，老用户男，1_1_0
extern NSString * const Event_BN_S;

// ------ 3.6.5新增打点参数 -------
extern NSString *const Event_Ask_Friend_T;
extern NSString *const Event_Forenotice_Clock_PARAM_T;      //0 精品预告  1 未开卖商品
extern NSString *const Event_Returnttp_S;                   //返回当前列表顶部

// ------ 3.6.6新增打点参数-------
extern NSString *const Event_Oy_everyday_S; //每日领取抽奖码按钮点击
extern NSString *const Event_Oy_score_S; //积分兑换按钮
extern NSString *const Event_Oy_orderdp_S;

//---------UI名称对照表----------
/*
 名称       tag
 启动页	  launch
 今日精选  today
 明日预告  tomorrow
 值得买	  zhi
 */
extern NSString *const UI_Launch;
extern NSString *const UI_Zhi;
extern NSString *const UI_Guang;

typedef NS_ENUM(NSInteger, LogParamShare) {
    LogParamShareWeixin = 0,
    LogParamShareFriends = 10
};

@interface Tao800LogParams : NSObject

@end
