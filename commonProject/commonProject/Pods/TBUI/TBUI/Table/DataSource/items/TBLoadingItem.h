//
// Created by enfeng on 13-6-3.
// Copyright (c) 2013 com.tuan800.framework.ui. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface TBLoadingItem : NSObject   {
    NSString *_text;
    BOOL _isGroupTable;
}
@property(nonatomic, copy) NSString *text;
@property(nonatomic) BOOL isGroupTable;
@end