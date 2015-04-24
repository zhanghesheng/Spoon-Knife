//
//  NSString+Expand.h
//  Core
//
//  Created by enfeng yang on 12-1-10.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
 
@interface NSString (TBCoreString)

-(NSInteger)hexValue;

- (NSString *) md5;

//SHA1
- (NSString*) digest;

- (NSString *) sha512;

/**
 * 不对特殊字符编码，如（!*'\"();:@&=+$,/?%#[]%等不会做编码)
 */
- (NSString *) urlEncoded;

-(NSString *) urlDecoded;

- (NSString *) encoded;

- (NSString *) trim;
 

/**
 * Calculate the md5 hash of this string using CC_MD5.
 *
 * @return md5 hash of this string
 */
@property (nonatomic, readonly) NSString* md5Hash;

/**
 * Calculate the SHA1 hash of this string using CommonCrypto CC_SHA1.
 *
 * @return NSString with SHA1 hash of this string
 */
@property (nonatomic, readonly) NSString* sha1Hash;

/**
 * Returns a string with all HTML tags removed.
 */
- (NSString*)stringByRemovingHTMLTags;

/**
* 将json串转为字典
*/
- (id)JSONValue;


- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding;

- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding;

- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query;

- (NSString*)stringByAddingURLEncodedQueryDictionary:(NSDictionary*)query;
@end 
