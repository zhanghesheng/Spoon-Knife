//
//  Tao800DealListVCL.h
//  tao800
//
//  Created by enfeng on 14-2-12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800TableVCL.h"
#import "TLOverlayView.h"
#import "Tao800DealListCell.h"
#import "Tao800StaticConstant.h"
#import "Tao800DealVo.h"
#import "Tao800BannerVo.h"
#import "Tao800AddToWishTipView.h"
#import "Tao800GuaranteeView.h"
#import "Tao800CustomStatueBar.h"


#import "Tao800AnalysisExposureContentVO.h"
#import "Tao800AnalysisExposureConstant.h"

@class Tao800AnalysisExposureContentVO;

typedef enum {
    Tao800DealListPageTagDefault, //默认
    Tao800DealListPageTagWishList, //心愿单
    Tao800DealListTopButtonDisplayOffset=800
} Tao800DealListPageTag;

@interface Tao800DealListVCL : Tao800TableVCL <Tao800MenuCellDelegate, TLOverlayViewDelegate, Tao800AddToWishTipViewDelegate,Tao800CustomStatueBarDelegate>

/**
* 定义详情页来源
* 子类必须赋值
*/
@property(nonatomic, assign) Tao800DealDetailFrom dealDetailFrom;
@property(nonatomic, strong) Tao800BannerVo *bannerVo; // 用于out链接

@property(nonatomic, strong) Tao800DealVo *selectedDeal;
@property (nonatomic, weak) UIButton *switchButton;
@property (nonatomic, weak) UIButton *toTopButton; 

@property(nonatomic, assign) BOOL enableAutoLoadItems; //是否可以自动加载
@property(nonatomic, assign) float tableHeight; 

@property(nonatomic) BOOL isSwitching; //正在切换视图


//group2_001增加状态栏点击提示用
@property(nonatomic,strong,getter=getcustomStatusBar) Tao800CustomStatueBar* customStatusBar;
@property(nonatomic) Tao800TableDirection lastDirection;
@property(nonatomic) Tao800TableDirection beforeLastDirection;
@property(nonatomic,strong) NSDate* lastSlideTime;
@property(nonatomic,strong) NSDate* beforeLastSlideTime;
@property(nonatomic) BOOL isStatusTipAppear;


@property(nonatomic, strong) Tao800AnalysisExposureContentVO *exposureContentVO;

/**
* 用于自动加载下一页
*/
- (void) scrollToLoadItems:(UIScrollView *)scrollView;

/**
* 子类需要重写该方法
* 写法参照Tao800HomeVCL
*/
- (void)reloadTableData;

- (void)reloadTableFrame;

- (void)dealFavoriteError:(TBErrorDescription *)error;

- (void)saveFavoriteState:(Tao800DealVo*) dealVo;

- (void)loginNotify:(NSNotification *)note;

- (void) logout:(NSNotification *)note;

- (NSIndexPath*) getSwitchTargetIndexPath;

- (void)hideSwitchButton:(BOOL)show;

- (void)displayNavBar:(BOOL)show;

- (void)hideSafeView:(BOOL)show;

-(void)doLoginAction;

//母婴分类需要，暴露以下方法
- (void)clickItem:(id)sender;

- (void)openDealPage:(Tao800DealVo *)deal sortId:(int)sortId;
//可供不同子类实现，解决下拉刷新成功提示不显示问题，默认调用父类方法
- (void)resetLoadStateSupper;

- (void)resetSwitchButton:(UIScrollView *)scrollView;

/**
* 兼容老接口
*/
- (NSString *) getCID ;

//户端返回顶端按钮统计打点，需要单独处理的字类重写
-(void)logReturnTop;

- (NSInteger) getDealIndexWithCell:(UITableViewCell*) cell;

//子类重写该方法，返回子类的类名用来记录点击过 group2_001增加状态栏点击提示用
- (NSString*)touchStatusBarChild;
//子类重写该方法 group2_001 子类显示状态栏上的提示信息，可配置状态栏颜色，显示方式等。
- (void)showStatusMessage;

- (void)changeFavoriteState:(id)sender; //解决警告问题，添加声明

/**
 * 获取底部栏的高度，子类可以重写该方法
 */
- (CGFloat) bottomBarHeight;

- (void) hideFloatButton;

/**
* 宫格和列表切换时是否允许动画
*/
- (BOOL) enableSwitchAnimation;

/**
* 用于曝光打点，子类可以重写该方法
*
*/
- (Tao800AnalysisExposureContentVO*) getExposureContentVo;

/**
* 子类可以重写该方法, 对于那种顶部切换的必须要重写该方法
* viewDidLoad 中会调用该方法
*/
- (void) initExposureContent;

- (void) layoutFloatButton;

/**
* 上报曝光打点，检查所有符合条件的商品
*
* 如果子类中cell没有用到 Tao800DealListItem则需要重写该方法
*/
- (void)checkExposureItems;
@end
