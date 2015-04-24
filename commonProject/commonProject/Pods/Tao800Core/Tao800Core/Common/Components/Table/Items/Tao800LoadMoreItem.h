//
// Created by enfeng on 13-7-1.
// Copyright (c) 2013 enfeng. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface Tao800LoadMoreItem : NSObject {
    NSString *_text;
    BOOL _loading;
    BOOL _waitForLoading; //如，出现网络错误
}
@property(nonatomic, copy) NSString *text;
@property(nonatomic) BOOL loading;
@property(nonatomic) BOOL waitForLoading;
@end