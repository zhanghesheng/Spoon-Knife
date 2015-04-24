//
//  TBCoreUtil.m
//  Core
//
//  Created by enfeng on 14-5-21.
//  Copyright (c) 2014年 mac. All rights reserved.
//
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "TBCoreUtil.h"
#import "TBCoreMacros.h"
@implementation TBCoreUtil

+ (NSString *)getIpAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *) temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+ (UIImage *)imageWithColor:(UIColor *)color bounds:(CGRect)bounds {
    CGRect rect = bounds;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}


// Based on code from http://developer.apple.com/mac/library/documentation/Security/Conceptual/CertKeyTrustProgGuide/iPhone_Tasks/iPhone_Tasks.html

+ (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef *)outTrust fromPKCS12Data:(NSData *)inPKCS12Data {
    OSStatus securityError = errSecSuccess;

    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObject:@"" forKey:(__bridge id) kSecImportExportPassphrase];

    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import((__bridge CFDataRef) inPKCS12Data, (__bridge CFDictionaryRef) optionsDictionary, &items);

    if (securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef) tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
        *outTrust = (SecTrustRef) tempTrust;
    } else {
        TBDPRINT(@"Failed with error code %d", (int) securityError);
        return NO;
    }
    return YES;
}

+(OSStatus) extractIdentityAndTrust:(CFDataRef) inPKCS12Data
                        outIdentity:(SecIdentityRef *)outIdentity
                           outTrust:(SecTrustRef *)outTrust
                        keyPassword:(CFStringRef) keyPassword {

    OSStatus securityError = errSecSuccess;

    const void *keys[] = {kSecImportExportPassphrase};
    const void *values[] = {keyPassword};
    CFDictionaryRef optionsDictionary = NULL;

    /* Create a dictionary containing the passphrase if one
       was specified.  Otherwise, create an empty dictionary. */
    optionsDictionary = CFDictionaryCreate(
            NULL, keys,
            values, (keyPassword ? 1 : 0),
            NULL, NULL);  // 1

    CFArrayRef items = NULL;
    securityError = SecPKCS12Import(inPKCS12Data,
            optionsDictionary,
            &items);                    // 2

    if (securityError == 0) {                                   // 3
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(myIdentityAndTrust,
                kSecImportItemIdentity);
        CFRetain(tempIdentity);
        *outIdentity = (SecIdentityRef) tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
        CFRetain(tempTrust);
        *outTrust = (SecTrustRef) tempTrust;
    }


    if (optionsDictionary)                                      // 4
        CFRelease(optionsDictionary);

    if (items)
        CFRelease(items);

    return securityError;

}
@end
