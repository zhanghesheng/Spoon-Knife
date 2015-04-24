//
//  NSString+Expand.m
//  Core
//
//  Created by enfeng yang on 12-1-10.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import "NSString+Addition.h"
#import "NSData+Addition.h"
#import <CommonCrypto/CommonDigest.h> 
#import "TBMarkupStripper.h"

@implementation NSString (TBCoreString)

-(NSInteger)hexValue
{
    CFStringRef cfSelf = (__bridge CFStringRef)self;
    UInt8 buffer[64];
    const char *cptr;
    
    if((cptr = CFStringGetCStringPtr(cfSelf, kCFStringEncodingMacRoman)) == NULL) {
        CFRange range     = CFRangeMake(0L, CFStringGetLength(cfSelf));
        CFIndex usedBytes = 0L;
        CFStringGetBytes(cfSelf, range, kCFStringEncodingUTF8, '?', false, buffer, 60L, &usedBytes);
        buffer[usedBytes] = 0;
        cptr              = (const char *)buffer;
    }
    
    return((NSInteger)strtol(cptr, NULL, 16));
}

- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    size_t t1 = strlen(cStr);
    CC_LONG len1 = (CC_LONG)t1;
    CC_MD5( cStr, len1, result ); // This is the md5 call
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];  
}

-(NSString*) digest
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
 
    CC_LONG len1 = (CC_LONG)(data.length);
    CC_SHA1(data.bytes, len1, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

-(NSString *) urlEncoded {
    //先做一次decode
    NSString *dString = [self urlDecoded];
    
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                    NULL,
                                                                    (__bridge CFStringRef)dString,
                                                                    NULL,
                                                                    NULL,
                                                                    kCFStringEncodingUTF8 ));
}

-(NSString *) urlDecoded {
    return CFBridgingRelease(
            CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8));
}

-(NSString *) encoded {
    NSString *dString = [self urlDecoded];
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                    NULL,
                                                                    (__bridge CFStringRef)dString,
                                                                    NULL,
//                                                                    (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                      (CFStringRef)@":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`",
                                                                     kCFStringEncodingUTF8 )); 
}

-(NSString*) trim {
    NSString *ret = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return ret;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)md5Hash {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
} 

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)sha1Hash {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1Hash];
}


- (NSString *) sha512  {
    
    const char *s = [self cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
    CC_LONG len1 = (CC_LONG)(keyData.length);
    CC_SHA512(keyData.bytes, len1, digest);
    
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    
    NSString *des = [out description];
    
    NSMutableString *ss = [NSMutableString stringWithString:des];
    NSRange range1 = [ss rangeOfString:@"<"];
    [ss replaceCharactersInRange:range1 withString:@""];
    range1 = [ss rangeOfString:@">"];
    [ss replaceCharactersInRange:range1 withString:@""];
    
    range1 = [ss rangeOfString:ss];
 
    NSError *error = NULL;
    NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
    NSString *pattern = @"\\s+";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:regexOptions error:&error];
    if (error) {
        NSLog(@"Couldn't create regex with given string and options");
    }
    
    [regex replaceMatchesInString:ss options:NSMatchingReportProgress range:range1 withTemplate:@""];
    
    return ss;
}


- (NSString*)stringByRemovingHTMLTags {
    TBMarkupStripper * stripper = [[TBMarkupStripper alloc] init];
    return [stripper parse:self];
//    NSRange r;
//    NSString *s = [[self copy] autorelease];
//    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
//        s = [s stringByReplacingCharactersInRange:r withString:@""];
//    return s;
}

- (id)JSONValue {

    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dict = nil;
    @try {
        dict = [NSJSONSerialization JSONObjectWithData:data
                                               options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves
                                                 error:&error];
    }
    @catch (NSException *e) {
        dict = [NSDictionary dictionary];
    }

    return dict;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
* Copied and pasted from http://www.mail-archive.com/cocoa-dev@lists.apple.com/msg28175.html
* Deprecated
*/
- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:self];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                    stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                    stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }

    return [NSDictionary dictionaryWithDictionary:pairs];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:self];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 1 || kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                    stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSMutableArray* values = [pairs objectForKey:key];
            if (nil == values) {
                values = [NSMutableArray array];
                [pairs setObject:values forKey:key];
            }
            if (kvPair.count == 1) {
                [values addObject:[NSNull null]];

            } else if (kvPair.count == 2) {
                NSString* value = [[kvPair objectAtIndex:1]
                        stringByReplacingPercentEscapesUsingEncoding:encoding];
                [values addObject:value];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query {
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [query keyEnumerator]) {
        NSString* value = [query objectForKey:key];
        value = [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
        value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        NSString* pair = [NSString stringWithFormat:@"%@=%@", key, value];
        [pairs addObject:pair];
    }

    NSString* params = [pairs componentsJoinedByString:@"&"];
    if ([self rangeOfString:@"?"].location == NSNotFound) {
        return [self stringByAppendingFormat:@"?%@", params];

    } else {
        return [self stringByAppendingFormat:@"&%@", params];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)stringByAddingURLEncodedQueryDictionary:(NSDictionary*)query {
    NSMutableDictionary* encodedQuery = [NSMutableDictionary dictionaryWithCapacity:[query count]];

    for (NSString* key in [query keyEnumerator]) {
        NSParameterAssert([key respondsToSelector:@selector(encoded)]);
        NSString* value = [query objectForKey:key];
        NSParameterAssert([value respondsToSelector:@selector(encoded)]);
        value = [value encoded];
        NSString *key1 = [key encoded];
        [encodedQuery setValue:value forKey:key1];
    }

    return [self stringByAddingQueryDictionary:encodedQuery];
}

@end