//
//  Tao800CategoryVo.m
//  tao800
//
//  Created by worker on 12-10-25.
//  Copyright (c) 2012年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800CategoryVo.h"
#import <TBCore/NSObjectAdditions.h>

@implementation Tao800CategoryVo

@synthesize categoryId = _categoryId;
@synthesize categoryName = _categoryName;
@synthesize urlName = _urlName;
@synthesize pic = _pic;

@synthesize catId = _catId;
@synthesize parentId = _parentId;
@synthesize isHaveNextLevel = _isHaveNextLevel;
@synthesize another = _another;
@synthesize parentUrlName = _parentUrlName;

- (id)init
{
    self=[super init];
    if (self) {
        _isHaveNextLevel = NO;
        _another = nil;
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.categoryId forKey:@"categoryId"];
    [aCoder encodeObject:self.categoryName forKey:@"categoryName"];
    [aCoder encodeObject:self.urlName forKey:@"urlName"];
    [aCoder encodeObject:self.pic forKey:@"pic"];
    
    [aCoder encodeObject:self.catId forKey:@"catId"];
    [aCoder encodeObject:self.parentId forKey:@"parentId"];
    [aCoder encodeObject:self.parentUrlName forKey:@"parentUrlName"];
    [aCoder encodeBool:self.isHaveNextLevel forKey:@"isHaveNextLevel"];
    [aCoder encodeObject:self.another forKey:@"another"];
    
    [aCoder encodeInt:self.tag forKey:@"tag"];
    [aCoder encodeObject:self.remoteUrl forKey:@"remoteUrl"];
    [aCoder encodeObject:self.queryUrl forKey:@"queryUrl"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self.categoryId = [aDecoder decodeIntForKey:@"categoryId"];
    self.categoryName = [aDecoder decodeObjectForKey:@"categoryName"];
    self.urlName = [aDecoder decodeObjectForKey:@"urlName"];
    self.parentUrlName = [aDecoder decodeObjectForKey:@"parentUrlName"];
    self.pic = [aDecoder decodeObjectForKey:@"dic"];
    
    self.catId = [aDecoder decodeObjectForKey:@"catId"];
    self.parentId = [aDecoder decodeObjectForKey:@"parentId"];
    self.isHaveNextLevel = [aDecoder decodeBoolForKey:@"isHaveNextLevel"];
    self.another = [aDecoder decodeObjectForKey:@"another"];
    
    self.tag = [aDecoder decodeIntForKey:@"tag"];
    self.remoteUrl = [aDecoder decodeObjectForKey:@"remoteUrl"];
    self.queryUrl = [aDecoder decodeObjectForKey:@"queryUrl"];
    return self;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    //不要对常量字符串调用mutablecopy,否则会导致内存泄露
    Tao800CategoryVo *TN800CategoryVoMutableCopy;
    TN800CategoryVoMutableCopy = [[[self class]allocWithZone:zone]init];
    TN800CategoryVoMutableCopy.categoryId = self.categoryId;
    TN800CategoryVoMutableCopy.catId = [self.catId copy];
    TN800CategoryVoMutableCopy.categoryName = [self.categoryName copy];
    TN800CategoryVoMutableCopy.parentId = [self.parentId copy];
    TN800CategoryVoMutableCopy.parentUrlName = [self.parentUrlName copy];
    TN800CategoryVoMutableCopy.pic = [self.pic copy];
    
    TN800CategoryVoMutableCopy.urlName = [self.urlName copy] ;
    TN800CategoryVoMutableCopy.another = [self.another copy];
    TN800CategoryVoMutableCopy.isHaveNextLevel = self.isHaveNextLevel;
    
    TN800CategoryVoMutableCopy.tag = self.tag;
    TN800CategoryVoMutableCopy.remoteUrl = [self.remoteUrl copy];
    TN800CategoryVoMutableCopy.queryUrl = [self.queryUrl copy];
    return (TN800CategoryVoMutableCopy);
}

+ (NSArray *)wrapperTags:(NSArray *)tags {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:20];
    for (NSDictionary *item in tags) {
        Tao800CategoryVo *vo = [[Tao800CategoryVo alloc] init];
        vo.categoryName = item[@"category_name"];
        NSString *tagId = item[@"tag_id"];
        if (tagId) {
            vo.categoryId = [tagId intValue];
        } else {
            vo.categoryId = [item[@"id"] intValue];
        }
        vo.urlName = item[@"url_name"];
        if ([vo.urlName isEqualToString:@"taomuying"]) {
            vo.urlName = @"muying";
        }
        vo.parentUrlName = item[@"parent_url_name"];
        if ([vo.parentUrlName isEqualToString:@"taomuying"]) {
            vo.parentUrlName = @"muying";
        }
        vo.pic = item[@"pic"];
        vo.queryUrl = item[@"query"];
        vo.remoteUrl = item[@"pic"];
        [vo resetNullProperty];
        if (vo.parentUrlName && vo.parentUrlName.length < 1) {
            vo.parentUrlName = nil;
        }
        [array addObject:vo];
    }
    return array;
}

- (void)dealloc {
    
}

@end
