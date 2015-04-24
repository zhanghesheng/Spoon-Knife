//
//  TBLogDao.h
//  Core
//
//  Created by enfeng yang on 12-2-7.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
 
#import "TBBaseDao.h"
#import "TBLogVo.h"

@interface TBLogDao : TBBaseDao
- (void) createTable;

- (void)saveUlog:(TBLogVo *)ulog;

- (TBLogVo *) getLastUlog;
 
- (NSArray *) getUlogs:(int)rowcount;

- (void) deleteUlogsWhereTimeLessThan:(NSDate*)date;
@end
