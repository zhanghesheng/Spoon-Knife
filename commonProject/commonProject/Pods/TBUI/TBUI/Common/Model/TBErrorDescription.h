//
//  TBErrorDescription.h
//  TBUI
//
//  Created by enfeng on 14-1-10.
//  Copyright (c) 2014年 com.tuan800.framework.ui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBErrorDescription : NSObject {
    NSInteger _errorCode;
    NSString *_errorMessage;
    NSObject *_userInfo; //用户自定义信息
}
@property (nonatomic) NSInteger errorCode;
@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, strong) NSObject *userInfo;
@property (nonatomic) BOOL isCancelled;
@end
