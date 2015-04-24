//
//  NSDictionaryAdditions.m
//  Core
//
//  Created by enfeng on 13-10-12.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "NSDictionaryAdditions.h"
#import "TBCoreMacros.h"

@implementation NSDictionary (TBAdditions)

- (id)objectForKey:(id)aKey convertNSNullToNil:(BOOL)convertNSNull {
    id ret = [self objectForKey:aKey];
    if ([ret isKindOfClass:[NSNull class]]) {
        ret = nil;
    }
    return ret;
}

- (NSString *)JSONString:(BOOL)prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization
            dataWithJSONObject:self
                       options:(NSJSONWritingOptions) (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                         error:&error];

    if (!jsonData) {
        TBDPRINT(@"JSONString: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
@end
