//
//  Tao800RC4.h
//  Tao800Core
//
//  Created by suminjie on 15-3-2.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800RC4 : NSObject{
	//data members
	int i;
	int j;
	unsigned char s[256];
    NSString* key;
}

//properties
@property (nonatomic,retain) NSString* key;

- (void)initialize;
- (unsigned char)KSA;
- (void)swap:(int)iFirstArgument swap2:(int)iSecondArgument;
- (id)initWithKey:(NSString *)initKey;
- (NSString *)encryptString:(NSString *)sToEncrypt;
- (NSString *)decryptString:(NSString *)sToDecrypt;

@end