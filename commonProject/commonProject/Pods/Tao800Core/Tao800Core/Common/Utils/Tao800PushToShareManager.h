//
//  Tao800PushToShareManager.h
//  tao800
//
//  Created by tuan800 on 14-9-11.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

/*
 
 */

#import <Foundation/Foundation.h>

@interface Tao800PushToShareManager : NSObject

@property (nonatomic, assign) int userExistTimes;
@property (nonatomic, assign) int pushToShareTimes; //最多三次

+(Tao800PushToShareManager *)shareInstance;
-(void)takeARecordWhenUserExit; // 用户推出客户端 调用
-(void)addPushToShareNotification;

-(void)addScoreForUserAfterPushToShareSuccessful;//推送分享成功后给用户加积分
-(void)requestInformationToCheckIfUserFinishPushToShare;
-(void)deleteLocalCheckInRemindNotification;

@end
