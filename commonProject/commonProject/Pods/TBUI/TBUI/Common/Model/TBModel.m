//
//  TBModel.m
//  TBUI
//
//  Created by enfeng on 14-1-10.
//  Copyright (c) 2014年 com.tuan800.framework.ui. All rights reserved.
//

#import "TBModel.h"
#import "TBCore/TBCoreMacros.h"

@implementation TBModel

@synthesize items = _items;
@synthesize pageNumber = _pageNumber;
@synthesize pageSize = _pageSize;
@synthesize hasNext = _hasNext;
@synthesize loading = _loading;

- (void)loadItems:(NSDictionary *)params
       completion:(void (^)(NSDictionary *))completion
          failure:(void (^)(TBErrorDescription *))failure {

}

- (void)dealloc {

}

- (id)init {
    self = [super init];
    if (self) {
        self.items = [NSMutableArray arrayWithCapacity:200];
        self.pageSize = 20;
        self.pageNumber = 1;
    }
    return self;
}
@end
