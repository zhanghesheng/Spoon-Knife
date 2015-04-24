//
//  TBFeedBackReplyVo.h
//  Tuan800API
//
//  Created by worker on 13-10-15.
//  Copyright (c) 2013年 com.tuan800.framework.Tuan800API. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBFeedBackReplyVo : NSObject {
    NSString *_relpyId;
    NSString *_msg;
    NSString *_content;
    NSString *_createTime;
}

@property(nonatomic, strong) NSString *relpyId;
@property(nonatomic, strong) NSString *msg;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *createTime;

@end
