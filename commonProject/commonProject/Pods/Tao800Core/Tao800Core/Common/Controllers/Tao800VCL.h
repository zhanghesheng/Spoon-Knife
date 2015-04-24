//
// Created by enfeng on 12-10-18.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TBUI/TBUI.h"
#import "TBBaseViewCTLAdditions.h"

@interface Tao800VCL : TBBaseViewCTL {
}

@property (nonatomic) BOOL enableShowPageTip; //比如登录、注册、修改密码等页面应该不需要显示 , 在这些页面设置为false

/**
 * 子类重写该方法，如果返回true，则在顶端添加statusbar背景, default : true
 */
- (BOOL) needRedrawStatusBar;
@end