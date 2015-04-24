//
//  UILabelAddtions.m
//  NSAttributedStringDemo
//
//  Created by enfeng on 14-1-29.
//  Copyright (c) 2014年 enfeng. All rights reserved.
//
#import "UIColor+Hex.h"
#import "UILabelAddtions.h"
#import "TBCore/NSString+Addition.h"

@interface UILabelAddtionsComponent : NSObject
@property (nonatomic, strong) NSDictionary *attributeDict;
@property (nonatomic, assign) NSRange range;
@end

@implementation UILabelAddtionsComponent

@end

@implementation UILabel (Category)


- (void) styleAttributedText:(NSString*) styleText {

    NSError *error = NULL;
    NSRegularExpression *fontRegex = [NSRegularExpression
                                  regularExpressionWithPattern:@"<font(.+?)>(.+?)</font>"
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:&error];
    

    NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:
                                          @"\\s+" options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    
    NSRegularExpression *regex3 = [NSRegularExpression regularExpressionWithPattern:
                                   @"\\s*?=\\s*" options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    
    
    NSRegularExpression *regexComponent = [NSRegularExpression regularExpressionWithPattern:
                                   @"\\s*?(\\w+?='.+?')" options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    
    NSArray *arr = [fontRegex matchesInString:styleText options:NSMatchingAnchored range:NSMakeRange(0, [styleText length])];


    NSMutableArray *componentArray = [NSMutableArray array];
    NSMutableArray *textArray = [NSMutableArray arrayWithCapacity:6];
    
    NSInteger lPositoin = 0;
    
    for (NSTextCheckingResult *result in arr) {
        NSString *tag = [styleText substringWithRange:[result rangeAtIndex:1]];
        NSString *content = [styleText substringWithRange:[result rangeAtIndex:2]];
        
        NSMutableString *str = [NSMutableString stringWithString:tag];
        [regex3 replaceMatchesInString:str options:0 range:NSMakeRange(0, [str length]) withTemplate:@"="];
        [regex2 replaceMatchesInString:str options:0 range:NSMakeRange(0, [str length]) withTemplate:@" "];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:6];
        NSArray *tagArritureArr = [regexComponent matchesInString:str options:NSMatchingAnchored range:NSMakeRange(0, [str length])];
        
        for (NSTextCheckingResult *rr in tagArritureArr) {
            NSString *tagArriture = [str substringWithRange:[rr rangeAtIndex:1]];
            NSArray *tArr = [tagArriture componentsSeparatedByString:@"="];
            if (tArr.count != 2) {
                continue;
            }
            [dict setValue:tArr[1] forKey:tArr[0]];
        }
 
        NSString *color = dict[@"color"];
        color = [color substringWithRange:NSMakeRange(2, color.length-3)];
        
        NSString *fontName = dict[@"face"];
        fontName = [fontName substringWithRange:NSMakeRange(1, fontName.length-2)];
        
        NSString *fontSize = dict[@"size"];
        fontSize = [fontSize substringWithRange:NSMakeRange(1, fontSize.length-2)];
        
        NSString *fontLine = dict[@"line"];
        fontLine = [fontLine substringWithRange:NSMakeRange(1, fontLine.length-2)];
        
        NSInteger colorNum = [color hexValue];
        
        UILabelAddtionsComponent *cp = [[UILabelAddtionsComponent alloc] init];
        
        NSMutableDictionary *attributeDict = [NSMutableDictionary dictionaryWithCapacity:5];
        NSRange range = NSMakeRange(lPositoin, content.length);
        
        if (color) {
            UIColor *pColor=[UIColor colorWithHex:colorNum];
            [attributeDict setValue:pColor forKey:NSForegroundColorAttributeName];
        }
        
        if (fontName && fontSize) {
            UIFont *font=nil;
            if (fontName.length<1) {
                font = [UIFont systemFontOfSize:fontSize.integerValue];
            } else {
                 font=[UIFont fontWithName:fontName size:fontSize.integerValue];
            }
            [attributeDict setValue:font forKey:NSFontAttributeName];
        } else if (fontSize) {
            UIFont *font=  [UIFont systemFontOfSize:fontSize.integerValue];
            [attributeDict setValue:font forKey:NSFontAttributeName];
        }
        
        if (fontLine) {
            if ([fontLine isEqualToString:@"u"]) {
                [attributeDict setValue:[NSNumber numberWithInt:NSUnderlineStyleSingle] forKey:NSUnderlineStyleAttributeName];
            }
        }
        
        lPositoin = lPositoin + content.length;
        
        cp.attributeDict = attributeDict;
        cp.range = range;
        
        [componentArray addObject:cp];
        [textArray addObject:content];
    }
    
    NSString *txt = [textArray componentsJoinedByString:@""];
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:txt];

    for (UILabelAddtionsComponent *item in componentArray) {
        for (NSString *key in item.attributeDict) {
            [attString addAttribute:key value:item.attributeDict[key] range:item.range];
        }
    }
    
    self.attributedText = attString;
}

@end
