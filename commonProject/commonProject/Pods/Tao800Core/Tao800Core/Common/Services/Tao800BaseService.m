//
//  Created by enfeng on 12-4-19.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Tao800BaseService.h"
#import "Tao800DataModelSingleton.h"

#if DEBUG
NSString *const UrlBase = @"http://m.api.xiongmaoz.com";
NSString *const UrlBaseNeedLogin = @"http://zapi.zhe800.com";
NSString *const UrlBaseTodo = @"http://m.api.zhe800.com";
NSString *const UrlSSO = @"https://sso.zhe800.com/jump_to";
#else
NSString* const UrlBase =@"http://m.api.zhe800.com";
NSString* const UrlBaseNeedLogin = @"http://zapi.zhe800.com";
NSString *const UrlBaseTodo = @"http://m.api.zhe800.com";
NSString *const UrlSSO = @"https://sso.zhe800.com/m/jump_to";
#endif


@implementation Tao800BaseService {

}

- (void)send:(TBASIFormDataRequest *)request {

    // 请求中增加user-agent参数
//    Tao800DataModelSingleton *da = [Tao800DataModelSingleton sharedInstance];
//    NSMutableString *str = [NSMutableString stringWithCapacity:6];
//    [str appendString:@"tbbz"];
//    [str appendFormat:@"|%@",da.headerVo.appName];
//    [str appendFormat:@"|%@",da.macAddress];
//    [str appendFormat:@"|%@",@"iPhone"];
//    [str appendFormat:@"|%@",da.currentVersion];
//    [str appendFormat:@"|%@",da.partner];
//    [request addRequestHeader:@"User-Agent" value:str];

    //NSLog(@"send url api:%@", request.url);

    [super send:request];
}

- (NSObject *)convertNSNullClass:(NSObject *)obj
{
    if ([obj isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return obj;
}

@end