//
//  Tao800SoftVo.h
//  tao800
//
//  Created by worker on 12-10-31.
//  Copyright (c) 2012年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800SoftVo : NSObject <NSCopying, NSCoding>{
    NSString *_minVersion;
    NSString *_url;
    NSString *_version;
    BOOL _mustUpdate;
    NSString *_softDescription;
}
@property(nonatomic, copy) NSString *minVersion;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *version;
@property(nonatomic, copy) NSString *softDescription;
@property(nonatomic, copy) NSString *minimumSystemVersion;
@property(nonatomic) BOOL mustUpdate;

- (id)copyWithZone:(NSZone *)zone;
@end
