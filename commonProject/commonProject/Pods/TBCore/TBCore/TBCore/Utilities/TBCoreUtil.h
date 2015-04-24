//
//  TBCoreUtil.h
//  Core
//
//  Created by enfeng on 14-5-21.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TBCoreUtil : NSObject

+ (NSString*) getIpAddress;

/**
* 根据颜色值生成图片
*/
+ (UIImage *)imageWithColor:(UIColor *)color bounds:(CGRect)bounds;

/**
*
*/
+ (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef *)outTrust fromPKCS12Data:(NSData *)inPKCS12Data;

/**
 * p12证书验证
 */
+(OSStatus) extractIdentityAndTrust:(CFDataRef) inPKCS12Data
                        outIdentity:(SecIdentityRef *)outIdentity
                           outTrust:(SecTrustRef *)outTrust
                        keyPassword:(CFStringRef) keyPassword;
@end
