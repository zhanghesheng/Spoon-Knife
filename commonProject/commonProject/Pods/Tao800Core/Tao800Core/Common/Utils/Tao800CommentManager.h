//
//  TBBCommentManager.h
//  universalT800
//
//  Created by hanyuan on 13-12-30.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800AlertView.h"

typedef void (^Tao800CommentManagerCallback)(BOOL didClose);

@interface Tao800CommentManager : NSObject<Tao800AlertViewDelegate>
@property BOOL commentViewShow;
@property (nonatomic, copy) Tao800CommentManagerCallback callBack;

-(void)showCommentInfoForNewUser;
-(void)showCommentInfoForOldUser;

/**
 * add by enfeng
 * 所有窗口的显示走 Tao800ForwardSingleton
 */
- (void) showCommentInfo:(BOOL) firstInstall callBack:(Tao800CommentManagerCallback) callBackParam;
@end
