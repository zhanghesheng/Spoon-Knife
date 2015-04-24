//
//  TBCoreMacros.h
//  Core
//
//  Created by enfeng yang on 12-1-10.
//  Copyright (c) 2012年 mac. All rights reserved.
//

///////////////////////////////////////////////////////////////////////////////////////////////////
// Safe releases

#import "TBURLCache.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define TB_RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }
#define TB_INVALIDATE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }

// Release a CoreFoundation object safely.
#define TB_RELEASE_CF_SAFELY(__REF) { if (nil != (__REF)) { CFRelease(__REF); __REF = nil; } }

//#define TBIMAGE(_IMAGENAME) [[ImageCache sharedInstance] getImageByName:_IMAGENAME]
#define TBIMAGE(_URL) [[TBURLCache sharedCache] imageForURL:_URL]

#ifdef DEBUG
#define TBDPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define TBDPRINT(xx, ...)  ((void)0)

#endif // #ifdef DEBUG

#define TB_IS_After_iOS7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define TB_PERFORM_SELECTOR_LEAK_WARNING(__STUFF) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
__STUFF; \
_Pragma("clang diagnostic pop") \
} while (0)