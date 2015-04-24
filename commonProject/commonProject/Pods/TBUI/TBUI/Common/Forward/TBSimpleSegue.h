//
//  TBSimpleSegue.h
//  TBUI
//
//  Created by 恩锋 杨 on 15/1/7.
//  Copyright (c) 2015年 com.tuan800.framework.ui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBSimpleSegue : UIStoryboardSegue
@property(nonatomic, strong) NSDictionary *forwardParams;
@property(nonatomic) BOOL cancel;
 
@end
