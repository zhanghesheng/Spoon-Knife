//
//  TBShareVo.h
//  universalT800
//
//  Created by enfeng on 13-11-28.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBShareVo : NSObject <NSCoding, NSCopying>

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *appTitle;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, strong) NSDictionary *data;
@property(nonatomic, strong) NSNumber *order;
@property(nonatomic, copy) NSString *imageNormal;
@property(nonatomic, copy) NSString *imageSmall;
@property(nonatomic, copy) NSString *shareUrl;
@property(nonatomic, copy) NSString *previewText;

@property (nonatomic, assign) BOOL needAppendTuan800Download;

- (id)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;

- (id)copyWithZone:(NSZone *)zone;
@end
