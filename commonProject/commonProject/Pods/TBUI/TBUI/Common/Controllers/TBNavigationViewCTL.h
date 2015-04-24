//
//  TBNavigationViewCTL.h
//  Tuan800API
//
//  Created by enfeng on 12-10-12.
//  Copyright (c) 2012年 com.tuan800.framework.Tuan800API. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBUINavigationController.h"

extern NSString *const TBNavigationCTLPageTagKey;
extern NSString *const TBNavigationCTLIsModelKey;
extern NSString *const TBForwardKey;
extern NSString *const TBNavigationCTLLoadFromStoryboardKey;

@interface TBNavigationViewCTL : TBUINavigationController {
    NSMutableDictionary *_forwordDict;
}

/**
 * 处理页面跳转
 * 通过该类进行跳转的类必须是TBBaseViewCTL的子类
 *
 * @param targetClass 目标页面
 * @param params 传入页面的参数
 *        params 需要包括 key:TBNavigationCTLPageTagKey value:(NSNumber*)
 */
- (void) forwardTo:(Class) targetClass params:(NSDictionary*)params;

/**
 * 用来判断当前类是否可处理通知
 * 当前类可能会被创建多个，每个类都会接收到相同的通知，但不是每个类都要处理通知
 *
 * @param note 通知对象，里面包含传入页面的参数，既note.userInfo
 */
- (BOOL) canDealForward:(NSNotification*)note;

@end
