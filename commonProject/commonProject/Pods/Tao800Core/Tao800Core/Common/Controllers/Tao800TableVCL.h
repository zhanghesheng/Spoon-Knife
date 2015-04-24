//
// Created by enfeng on 12-10-18.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TBUI/TBUI.h"
#import "TBBaseViewCTLAdditions.h"

typedef enum : NSUInteger {
    Tao800TableDirectionNone = 0,
    Tao800TableDirectionUp = 1,
    Tao800TableDirectionDown = 2,
} Tao800TableDirection;

@interface Tao800TableVCL : TBTableViewCTL {
}

// 用于判断是否加载更多的分页大小，由于服务器端不能保证返回的数据每页都是20条，所以用此参数。
+ (int)loadMorePageSize;

@property (nonatomic, strong) TBErrorDescription *netErrorDescription;
@property(nonatomic) CGPoint previousContentOffset;
@property (nonatomic) BOOL needShowLoadMore;
@property (nonatomic,readonly) Tao800TableDirection directionCurrent;

@property (nonatomic) BOOL enableShowPageTip; //比如登录、注册、修改密码等页面应该不需要显示

- (BOOL)resetLoadMoreItem:(NSObject *)item;

//隐藏和显示导航条等方法，子类如果需要此效果要自行实现
- (void)displayNavBar:(BOOL)show;
- (void)hideAction:(CGFloat)offsetYY with:(CGFloat)offsetY;

/**
 * 子类重写该方法，如果返回true，则在顶端添加statusbar背景, default : true
 */
- (BOOL) needRedrawStatusBar;
- (BOOL) needShowPrdValue;
@end