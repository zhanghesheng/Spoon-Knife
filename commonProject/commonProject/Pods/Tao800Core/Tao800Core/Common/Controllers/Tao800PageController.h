//
//  Tao800PageController.h
//  tao800
//
//  Created by enfeng on 14-3-10.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class Tao800ShareVo;

@interface Tao800PageController : NSObject {
    UINavigationController *_navigationController;
}
@property(nonatomic) UINavigationController *navigationController;

+ (id)shareInstance;

@end
