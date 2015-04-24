//
//  TBBaseService.m
//  Tuan800API
//
//  Created by enfeng on 14-1-14.
//  Copyright (c) 2014年 com.tuan800.framework.Tuan800API. All rights reserved.
//

#import "TBBaseService.h"

@implementation TBBaseService

- (void)send:(TBASIFormDataRequest *)request {

    NSString *urlString = request.url.absoluteString;
    if ([urlString hasPrefix:@"https"]) {
//        SecIdentityRef identity1 = NULL;
//        SecTrustRef trust = NULL;

//        NSData *PKCS12Data1 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tuan800-passport" ofType:@"p12"]];

//        [TBCoreUtil extractIdentity:&identity1 andTrust:&trust fromPKCS12Data:PKCS12Data1];
//
//        [request setClientCertificateIdentity:identity1];

        NSData *cerFile1 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pass" ofType:@"cer"]];
        NSData *cerFile2 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sso" ofType:@"cer"]];

        SecCertificateRef cert1 = SecCertificateCreateWithData(NULL, (__bridge CFDataRef) cerFile1);
        SecCertificateRef cert2 = SecCertificateCreateWithData(NULL, (__bridge CFDataRef) cerFile2);

        NSArray *array = @[(__bridge id) cert1,
                (__bridge id) cert2];

        CFRelease(cert1);
        CFRelease(cert2);

        [request setClientCertificates:array];
        [request setValidatesSecureCertificate:YES];
    }

    [super send:request withRequestKey:YES];
}
@end
