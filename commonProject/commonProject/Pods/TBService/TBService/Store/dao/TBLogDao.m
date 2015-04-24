//
//  TBLogDao.m
//  Core
//
//  Created by enfeng yang on 12-2-7.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import "TBLogDao.h"

@implementation TBLogDao

- (TBLogVo *)getTBLogVo:(FMResultSet *)rs {
    TBLogVo *ulog = [TBLogVo alloc];
    
    ulog.logtime = [rs dateForColumn:@"log_time"];
    ulog.content = [rs stringForColumn:@"log_content"]; 
    ulog.contentSize = [rs intForColumn:@"log_size"]; 
    
    return ulog;
}

- (void)createTable {
    NSString *sql = @"CREATE TABLE if not exists  \"ulog\" (\"log_time\" DATETIME PRIMARY KEY ,\"log_content\" TEXT,\"log_size\" INTEGER)";
    [self createTable:sql];
}

- (void)saveUlog:(TBLogVo *)ulog {
    NSString *sql = @"insert into ulog(log_time, log_content, log_size) values(?, ?, ?);";
    [self.db executeUpdate:sql, ulog.logtime, ulog.content, [NSNumber numberWithInt:ulog.contentSize]];
} 

- (TBLogVo *)getLastUlog {
    
    TBLogVo* ulog = nil;
    FMResultSet *rs = [self.db executeQuery:@"select * from ulog order by log_time limit 1", [NSNumber numberWithBool:YES]];
    if ([rs next]) {
        ulog = [self getTBLogVo:rs]; 
    }
    [rs close];
    return ulog;
}

//貌似按时间删除没起作用
-(void) deleteUlog:(TBLogVo*)ulog {
    NSString *sql = @"delete from ulog where log_time=?";
    [self.db executeUpdate:sql, ulog.logtime];
} 

- (NSArray *)getUlogs:(int)rowcount {
    NSMutableArray *ns = [NSMutableArray arrayWithCapacity:20];
    NSString *sql = [NSString stringWithFormat:@"select * from ulog order by log_time limit ?"];
    FMResultSet *rs = [self.db executeQuery:sql,[NSNumber numberWithInt:rowcount]];
    while ([rs next]) { 
        [ns addObject:[self getTBLogVo:rs]];
    }
    [rs close];
    return ns;
}

- (void) deleteUlogsWhereTimeLessThan:(NSDate*)date {
    NSString *sql = @"delete from ulog where log_time<=?";
    [self.db executeUpdate:sql, date];
}

@end
