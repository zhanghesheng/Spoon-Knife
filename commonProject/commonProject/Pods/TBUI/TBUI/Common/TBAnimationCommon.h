//
//  TBAnimationCommon.h
//  Core
//
//  Created by enfeng yang on 12-7-2.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
 
const static int ANIMATION_UP = 1;
const static int ANIMATION_DOWN = 2;
const static int ANIMATION_LEFT = 3;
const static int ANIMATION_RIGHT = 4;
const static int ANIMATION_DANHUA = 5;
const static int ANIMATION_TUIJI = 6;
const static int ANIMATION_JIEKAI = 7;
const static int ANIMATION_FUGAN = 8;
const static int ANIMATION_LIFANGTI = 9;
const static int ANIMATION_XISHOU = 10;
const static int ANIMATION_FANZHUAN = 11;
const static int ANIMATION_BOWEN = 12;
const static int ANIMATION_JINGTOUKAI = 13;
const static int ANIMATION_JINGTOUGUAN = 14;
@interface TBAnimationCommon : NSObject
+(void)setAnimation:(UIView *) view type:(int) _type;
+(void)setTranAnimation:(UIView *) view type:(int) _type typeID:(int) _typeID;
@end

