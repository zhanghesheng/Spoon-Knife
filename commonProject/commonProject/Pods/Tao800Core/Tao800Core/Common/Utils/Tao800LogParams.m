//
//  Tao800LogParams.m
//  tao800
//
//  Created by wuzhiguang on 12-11-27.
//  Copyright (c) 2012年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800LogParams.h"

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
 
 ------- v2.3新增的如下：---------
 收藏deal	  f
 店铺详情	      shop
 收藏店铺	      fshop
 积分deal	  dscore
 晒单	      shai
 ------- v2.3新增的如上：---------
 
 ----- 临时事件 -----
 签到	    t_check
 开卖提醒开关	t_clockset
 明日推荐开关	t_dailyset
 邀请好友积分	t_invite
 暂不签到	t_nocheck
 开卖提醒	t_clock
 
 ------ v2.3新增临时事件-------
 会员购登录	t_buylogin
 返积分登录	t_scorelogin
 */
NSString *const Event_R = @"r";
NSString *const Event_P = @"p";
NSString *const Event_S = @"s";
NSString *const Event_Pc = @"pc";
NSString *const Event_Lp = @"lp";
NSString *const Event_B = @"b";
NSString *const Event_Tb = @"tb";
NSString *const Event_Tsm = @"t_sm";
NSString *const Event_Tss = @"t_ss";
NSString *const Event_Tws = @"t_ws";
NSString *const Event_Webview = @"webview";
NSString *const Event_Today = @"today";
NSString *const Event_Tomorrow = @"tomorrow";
NSString *const Event_Mytb = @"mytb";
NSString *const Event_Mytbs = @"mytbs";
NSString *const Event_Tao = @"tao";
NSString *const Event_Tcheck = @"t_check";
NSString *const Event_Tclockset = @"t_clockset";
NSString *const Event_Tinvite = @"t_invite";
NSString *const Event_Tnocheck = @"t_nocheck";
NSString *const Event_Tdailyset = @"t_dailyset";
NSString *const Event_Tclock = @"t_clock";

NSString *const Event_F = @"f";
NSString *const Event_Shop = @"shop";
NSString *const Event_Fshop = @"fshop";
NSString *const Event_Dscore = @"dscore";
NSString *const Event_shai = @"shai";
NSString *const Event_Tbuylogin = @"t_buylogin";
NSString *const Event_Scorelogin = @"t_scorelogin";

// ----- 2.4版新增打点事件 -----
NSString *const Event_Torder = @"t_order";     //个人中心查订单
NSString *const Event_Tcart = @"t_cart";       //个人中心购物车
NSString *const Event_Tfreight = @"t_freight"; //个人中心查物流

// ----- 2.5版新增打点事件 -----
NSString *const Event_Hot = @"hot";
NSString *const Event_Init = @"init";

// ----- 2.7.0版新增打点事件  -----
NSString *const Event_Auction = @"";   //竞拍商品新高价
NSString *const Event_Cb = @"cb";      //分类banner
NSString *const Event_Wx = @"wx";      //微信关注
NSString *const Event_Tsdk = @"tsdk";  //进入淘宝SDK列表

// ----- 3.0版新增打点事件  -----
NSString *const Event_Identify = @"model";                  //身份选择
NSString *const Event_Category = @"ic";                     //首页banner下面的 方格入口
NSString *const Event_Show = @"ae";                         //曝光时记录(例如请求图片时)
NSString *const Event_Category_Left_Search = @"is";         //分类搜索(首页左 上方)
NSString *const Event_Category_Search = @"isearch";         //搜索框聚焦(分类搜索页)
NSString *const Event_Category_Choose = @"cc";              //分类选择(分类页 左侧)
NSString *const Event_Favorite_List = @"f";                 //列表收藏
NSString *const Event_Forenotice_Clock = @"clock";          //精品预告设置提醒
NSString *const Event_Concern_QQZone = @"qqz";              //关注qq空间
NSString *const Event_Ask_Friend = @"invote";               //￼￼￼￼￼￼￼￼￼￼￼￼￼￼邀请好友注册
NSString *const Event_QR_Code = @"qr";                      //二维码入口
NSString *const Event_QR_Code_Success = @"qrs";             //￼￼￼￼￼￼￼￼￼￼￼￼二维码扫描成功(设置提醒)
NSString *const Event_Login = @"ologin";                    //￼￼￼￼￼￼￼￼￼￼￼￼￼￼我要登陆(out提示 登录页面)
NSString *const Event_UserInfo = @"userinfo";               //个人中心
NSString *const Event_DisplayAsGrid = @"clist";             //切换列表模式

// ----- 3.1版新增打点事件  -----
NSString *const Event_Promotional_Banner = @"bl";           //大促banner
NSString *const Event_Baby = @"baby";                       //选择宝宝生日
NSString *const Event_Babyset = @"babyset";                 //母婴列表上方的 生日设置
NSString *const Event_Wishc = @"wishc";                     //点击许愿
NSString *const Event_Wish_Success = @"wish";               //许愿成功

// ----- 3.1.1版新增打点事件  -----
NSString *const Event_ScoreBuy = @"scorebuy";               //积分商城我要兑换

// ----- 3.2.1版新增打点事件  -----
NSString *const Event_CuClock = @"cuclock";                 //大促闹钟设置 （点击打开打点）
NSString *const Event_PushReceive = @"poll";                //push到达事件

// ----- 3.3版新增打点事件  -----
NSString *const Event_Gb = @"gb";                           //逛分类banner位
NSString *const Event_Gbi = @"gbi";                         //逛精选banner位
NSString *const Event_EarnScore = @"earnscore";             //积分商城 赚积分
NSString *const Event_Allc = @"allc";                       //分类选择 全部入口
NSString *const Event_Dsearch = @"dsearch";                 //每日十件 关联搜索

// ----- 3.4版新增打点事件  -----
NSString *const Event_Oobe = @"oobe";                       //结束引导页，包含新安装和升级


// ----- 3.5版本新增打点事件 -----
NSString * const Event_Push = @"pc"; // push触发事件（包含ios闹钟）
NSString * const Event_Banner = @"b"; // banner运营位 事件tag: b;
NSString * const Event_Open_TaobaoApp = @"taoapp"; //参数空
NSString * const Event_QrCode_Scan_Successfully = @"qrs"; //二维码扫描成功（设置提醒）
NSString * const Event_Launch_Input_Address = @"t_newadr"; //弹出地址填写提示
NSString * const Event_Save_Address = @"t_saveadr"; //地址填写保存


// ----- 3.5.2版本新增打点事件 -----
NSString *const Event_Rselect = @"rselect";     //列表为空时进入精选预告点击
NSString *const Event_Redit = @"redit";         //列表编辑完成后确认按钮点击

// ----- 3.5.3版本新增打点事件 -----

NSString *const Event_Bsc = @"bsc";       //首页分类入口（首页底部tab）

// ----- 3.6.4版本新增打点事件 -----
NSString *const Event_Suc = @"suc";       //分享成功

NSString *const Event_Roompic = @"roompic";  //虚拟试衣间某专题里面内图片点击

NSString *const Event_Roomdone = @"roomdone";  //虚拟试衣间拍照图片调整完成

NSString *const Event_Agemore = @"agemore"; //母婴点击其他年龄商品按钮

NSString *const Event_Brand = @"brand"; //品牌团tab点击打点
NSString *const Event_BN = @"bn";
// ----- 3.6.5版本新增打点事件 -----
NSString *const Event_Returnttp = @"returnttp"; //返回当前列表顶部


//3.6.6打点
NSString *const Event_Qiandaofh = @"qiandaofh";//签到复活打点
NSString *const Event_Oy_everyday = @"0y_everyday"; //每日领取抽奖码按钮点击
NSString *const Event_Oy_score = @"0y_score"; //积分兑换按钮

NSString *const Event_Oy_remind = @"0y_remind";//设置提醒
NSString *const Event_Oy_orderdp = @"0y_orderdp";//查看抽奖单
NSString *const Event_t_newadr = @"t_newadr";//弹出地址填写提示
NSString *const Event_t_saveadr = @"t_saveadr";//地址填写保存


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
 
 ------------2.3新增如下----------------
 收藏deal	 d	     String	  dealid
 店铺详情	     d	     String	  shopid
 　	m	String	0 今日精选；1 明日预报；2 逛便宜
 收藏店铺  	 d	     String	  shopid
 积分deal	 d	     String	  dealid
 晒单	     d	     String	  订单id
 ---------------------------
 */
NSString *const Event_R_PARAM_N = @"n";
NSString *const Event_P_PARAM_N = @"n";
NSString *const Event_S_PARAM_T = @"t";
NSString *const Event_S_PARAM_D = @"d";
NSString *const Event_Pc_PARAM_X = @"x";
NSString *const Event_Pc_PARAM_D = @"d";
NSString *const Event_Lp_PARAM_D = @"d";
NSString *const Event_B_PARAM_D = @"d";
NSString *const Event_Tb_PARAM_D = @"d";
NSString *const Event_Tsm_PARAM_T = @"t";
NSString *const Event_Webview_PARAM_D = @"d";
NSString *const Event_Webview_PARAM_M = @"m";
NSString *const Event_Today_PARAM_T = @"t";
NSString *const Event_Today_PARAM_C = @"c";
NSString *const Event_Today_PARAM_P = @"p";
NSString *const Event_Tomorrow_PARAM_T = @"t";
NSString *const Event_Tomorrow_PARAM_P = @"p";
NSString *const Event_Tclockset_PARAM_T = @"t";
NSString *const Event_Tdailyset_PARAM_T = @"t";
NSString *const Event_Tclock_PARAM_D = @"d";

NSString *const Event_F_PARAM_D = @"d";
NSString *const Event_Shop_PARAM_D = @"d";
NSString *const Event_Fshop_PARAM_D = @"d";
NSString *const Event_Dscore_PARAM_D = @"d";
NSString *const Event_shai_PARAM_D = @"d";
NSString *const Event_Shop_PARAM_M = @"m";

// ----- 2.4版新增打点参数 -----
NSString *const Event_Gb_PARAM_D = @"d";

// ------ 2.5版新増打点参数 ------
NSString *const Event_Hot_PARAM_D = @"d";   // bannerid
NSString *const Event_Init_PARAM_Mac = @"mac";
NSString *const Event_Init_PARAM_Openudid = @"openudid";
NSString *const Event_Init_PARAM_Fdid = @"fdid";

// ------ 2.7.0版新増打点参数 ------
NSString *const Event_Cb_PARAM_D = @"d";    // bannerid

// ------ 3.0版新增打点参数 -----
NSString *const Event_Identify_PARAM_T = @"t";          //身份选择
NSString *const Event_Identify_PARAM_S = @"s";          //身份选择
NSString *const Event_Category_PARAM_D = @"d";          //首页banner下面的 方格入口
NSString *const Event_Category_PARAM_C = @"c";          //首页banner下面的 方格入口
NSString *const Event_Show_PARAM_D = @"d";              //曝光时记录(例如请求图片时)
NSString *const Event_Show_PARAM_S = @"s";              //曝光时记录(例如请求图片时)
NSString *const Event_Show_PARAM_T = @"t";              //曝光时记录(例如请求图片时)
NSString *const Event_Favorite_List_PARAM_D = @"d";     //列表收藏
NSString *const Event_Favorite_List_PARAM_T = @"t";     //列表收藏
NSString *const Event_Forenotice_Clock_PARAM_D = @"d";  //精品预告设置提醒
NSString *const Event_QR_Code_Success_PARAM_D = @"d";   //￼￼￼￼￼￼￼￼￼￼￼￼二维码扫描成功(设置提醒)
NSString *const Event_DisplayAsGrid_PARAM_T = @"t";     //切换列表模式

// ----- 3.1版新增打点参数  -----
NSString *const Event_Promotional_Banner_D = @"d";      //大促banner
NSString *const Event_Baby_T = @"t";                    //选择宝宝生日
NSString *const Event_Baby_S = @"s";                    //选择宝宝生日 来源
NSString *const Event_Wishc_S = @"s";                   //点击许愿
NSString *const Event_Wish_Success_W = @"w";            //许愿成功

// ----- 3.1.1版新增打点参数  -----
NSString *const Event_ScoreBuy_D = @"d";                //积分商城我要兑换

// ----- 3.2版新增打点参数  -----
NSString *const Event_B_S = @"s";                       //首页banner 顺序打点

// ----- 3.3版新增打点参数  -----
NSString *const Event_Gb_D = @"d";                      //逛分类banner位
NSString *const Event_Dsearch_D = @"d";                 //每日十件 关联搜索

// ----- 3.4版新增打点参数  -----
NSString *const Event_School = @"school";               //身份选择是否为校园（学生）0 非校园，1 校园


// ----- 3.5版本新增打点参数 -----
NSString * const Event_Push_Id = @"d";                  // push id 退出push id：exit
NSString * const Event_Banner_Id = @"d";                // Banner Id
NSString * const Event_Banner_Order = @"s";             // Banner顺序 banner顺序，从左侧1-5
NSString * const Event_Banner_Position = @"t";           //Banner运营位 位置：1 首页，2 启动大图，3 分类，4 逛分类，5 大促悬挂，6 大促日历，7 0元抽奖
NSString * const Event_QrCode_Scan_Successfully_Deal_Id = @"d";       // 二维码扫描成功deal id
NSString * const Event_QrCode_Scan_Successfully_Type = @"t";          // 二维码扫描类型 0 开卖提醒；1 手机专享


// ----- 母婴新增打点 ---------

NSString * const Event_MuYing_Table_Switch = @"muying";  //母婴品牌 单品 切换 品牌p 单品 d

// ------母婴新增打点 -------------- 版本3.6.0 //事件名称
NSString * const Event_Muying_Categories = @"muying"; // 母婴最上面的不同的分类打点
NSString * const Event_List_More = @"listmore"; // 列表底部“更多”按钮 打点
NSString * const Event_About_UpGrade = @"aboutup";

// ----- 3.6.4新增打点 ---------
NSString * const Event_Suc_T = @"t";     //分享成功的分享方式
NSString * const Event_Suc_S = @"s";     //分享成功的分享来源
NSString * const Event_Suc_D = @"d";     //分享成功的分享内容
NSString * const Event_Brand_D = @"d";    //品牌团tab点击打点
// ----- 虚拟试衣间新增打点 ------
NSString * const Event_Roompic_D = @"d";           //虚拟试衣间 选择图片的ID
NSString * const Event_Roomdone_D = @"d";          //虚拟试衣间 拍照模板图片ID

NSString * const Event_Banner_U = @"u";
NSString * const Event_BN_S = @"s";

// ----- 3.6.5新增打点参数 ------
NSString * const Event_Ask_Friend_T = @"t";    //发红包拿奖金 入口位置
NSString * const Event_Forenotice_Clock_PARAM_T = @"t";      //0 精品预告  1 未开卖商品
NSString * const Event_Returnttp_S = @"s"; //返回当前列表顶部

//3.6.6
NSString * const Event_Oy_everyday_S = @"s"; //每日领取抽奖码按钮点击
NSString *const Event_Oy_score_S = @"s"; //积分兑换按钮
NSString *const Event_Oy_orderdp_S = @"s";


//---------UI名称对照表----------
/*
 名称       tag
 启动页	  launch
 今日精选  today
 明日预告  tomorrow
 值得买	  zhi
 */
NSString *const UI_Launch = @"launch";
// NSString *const UI_Today = @"today";
// NSString *const UI_Tomorrow = @"tomorrow";
NSString *const UI_Zhi = @"zhi";

NSString *const UI_Guang = @"guang";

@implementation Tao800LogParams

@end
