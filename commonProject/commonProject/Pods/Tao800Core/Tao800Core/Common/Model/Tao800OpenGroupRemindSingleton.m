//
//  Tao800OpenGroupRemindSingleton.m
//  tao800
//
//  Created by worker on 13-10-30.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800OpenGroupRemindSingleton.h"
#import "TBCore/TBFileUtil.h"
#import "Tao800StaticConstant.h"
#import "TBCore/TBCore.h"
#import "Tao800FunctionCommon.h"
#import "TBCore/TBCoreMacros.h"

const static NSString* archiveFileName = @"openGroupRemind.dat";

static Tao800OpenGroupRemindSingleton *_instance;

@implementation Tao800OpenGroupRemindSingleton

@synthesize dataArray = _dataArray;

+ (Tao800OpenGroupRemindSingleton *)sharedInstance
{
    @synchronized (self) {
        if (_instance == nil) {
            
            // 获取基础目录
            NSString* documentDirectory = [TBFileUtil getDocumentBaseDir];
            // 获取基础文件
            NSString* documentArchivePath =[documentDirectory stringByAppendingFormat:@"/%@", archiveFileName];
            // 获取缓存目录
            NSString *cacheDirectory = [TBFileUtil getCacheDirWithCreate:NO];
            // 获取缓存文件
            NSString* cacheArchivePath =[cacheDirectory stringByAppendingFormat:@"/%@", archiveFileName];
            
            // 判断缓存文件是否存在
            NSFileManager *fm = [NSFileManager defaultManager];
            if ([fm fileExistsAtPath:cacheArchivePath]) {
                // 存在
                //剪切文件
                BOOL moveResult = [TBFileUtil moveFile:cacheArchivePath ToFile:documentArchivePath forceMove:YES];
                if (moveResult) {
                    _instance = [NSKeyedUnarchiver unarchiveObjectWithFile:documentArchivePath];//retian
                }else {
                    // 剪切失败
                    _instance = [NSKeyedUnarchiver unarchiveObjectWithFile:documentArchivePath] ;
                }
            }else {
                // 不存在
                _instance = [NSKeyedUnarchiver unarchiveObjectWithFile:documentArchivePath];
            }
        }
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

-(BOOL) archive {
	NSString* documentDirectory = [TBFileUtil getBaseDir];
	return [NSKeyedArchiver archiveRootObject:self
									   toFile:[documentDirectory stringByAppendingFormat:@"/%@", archiveFileName]];
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.dataArray forKey:@"dataArray"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    
    self.dataArray = [aDecoder decodeObjectForKey:@"dataArray"];
    
	return self;
}


// 获取数据列表
- (NSMutableArray *)getDataArray {
    if (_dataArray) {
        return _dataArray;
    }
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    return _dataArray;
}

// 把数据写入文件
- (void)save:(Tao800DealVo *)dealVo {
    if (dealVo == nil) {
        return;
    }
    
    // 判断是否存在此数据，存在则更新此数据 
    if ([self getByDealId:dealVo.dealId]) {
        [self updateByDealVo:dealVo];
    }else {
        [[self getDataArray] addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:dealVo.dealId],@"dealId",
                                        dealVo,@"dealVo",nil]];
    }
    
    [self archive];
}

// 根据dealId查询对应的数据
- (NSMutableDictionary *)getByDealId:(int)dealId {
    NSMutableArray *dataArray = [self dataArray];
    for (int i=0; i<dataArray.count; i++) {
        NSMutableDictionary *dic = [dataArray objectAtIndex:i];
        if ([[dic objectForKey:@"dealId"] intValue] == dealId) {
            return dic;
        }
    }
    
    return nil;
}

// 根据dealVo删除对应的数据
- (void)deleteByDealVo:(Tao800DealVo *)dealVo {
    NSMutableArray *dataArray = [self dataArray];
    for (int i=0; i<dataArray.count; i++) {
        NSMutableDictionary *dic = [dataArray objectAtIndex:i];
        if ([[dic objectForKey:@"dealId"] intValue] == dealVo.dealId) {
            [dataArray removeObjectAtIndex:i];
            break;
        }
    }
    
    [self archive];
}

// 根据dealVo更新对应的数据
- (void)updateByDealVo:(Tao800DealVo *)dealVo {
    NSMutableArray *dataArray = [self dataArray];
    for (int i=0; i<dataArray.count; i++) {
        NSMutableDictionary *dic = [dataArray objectAtIndex:i];
        if ([[dic objectForKey:@"dealId"] intValue] == dealVo.dealId) {
            [dic setObject:dealVo forKey:@"dealVo"];
            break;
        }
    }
    
    [self archive];
}

@end
