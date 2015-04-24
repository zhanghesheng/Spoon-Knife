//
//  Tao800StartLogDao.h
//  tao800
//
//  Created by enfeng on 14-3-3.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBService/Tuan800API.h>

@class Tao800StartLogVo;

@interface Tao800StartLogDao : TBBaseDao

- (void)saveUlog:(Tao800StartLogVo *)ulog;

- (NSArray *) getLogsBefore:(NSDate *) date;

- (Tao800StartLogVo *) getLogById:(NSString *) startId;

- (void) deleteUlogsWhereTimeLessThan:(NSDate*)date;
@end
