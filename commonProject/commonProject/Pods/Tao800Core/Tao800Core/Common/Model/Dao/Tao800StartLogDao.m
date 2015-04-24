//
//  Tao800StartLogDao.m
//  tao800
//
//  Created by enfeng on 14-3-3.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800StartLogDao.h"
#import "Tao800StartLogVo.h"

@implementation Tao800StartLogDao

- (void)createTable {
    NSString *sql = @"CREATE TABLE if not exists  \"start_log\" (\"start_id\" CHAR(8) PRIMARY KEY  NOT NULL , \"start_one\" INTEGER, \"start_updated\" DATETIME)";
    [self createTable:sql];
}

- (id)initWithPath:(NSString *)aPath {
    self = [super initWithPath:aPath];
    if (self) {
        [self createTable];
    }
    return self;
}

- (Tao800StartLogVo *)getTBLogVo:(FMResultSet *)rs {
    Tao800StartLogVo *ulog = [Tao800StartLogVo alloc];

    ulog.startId = [rs stringForColumn:@"start_id"];
    ulog.date = [rs dateForColumn:@"start_updated"];
    ulog.startCount = [rs intForColumn:@"start_one"];

    return ulog;
}

- (void)saveUlog:(Tao800StartLogVo *)ulog {
    NSString *sql = @"replace into start_log(start_id, start_updated, start_one) values(?, ?, ?);";
    [self.db executeUpdate:sql, ulog.startId, ulog.date, [NSNumber numberWithInt:ulog.startCount]];
}

- (NSArray *)getLogsBefore:(NSDate *)date {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:7];
    FMResultSet *rs = [self.db executeQuery:
            @"select * from start_log where start_updated<=?", date];
    while ([rs next]) {
        Tao800StartLogVo *ulog = [self getTBLogVo:rs];
        [array addObject:ulog];
    }
    [rs close];
    return array;
}

- (Tao800StartLogVo *)getLogById:(NSString *)startId {
    Tao800StartLogVo *ulog = nil;
    FMResultSet *rs = [self.db executeQuery:
            @"select * from start_log where start_id = ?", startId];
    if ([rs next]) {
        ulog = [self getTBLogVo:rs];
    }
    [rs close];
    return ulog;
}

- (void)deleteUlogsWhereTimeLessThan:(NSDate *)date {
    NSString *sql = @"delete from start_log where start_updated <= ?";
    [self.db executeUpdate:sql, date];
}
@end
