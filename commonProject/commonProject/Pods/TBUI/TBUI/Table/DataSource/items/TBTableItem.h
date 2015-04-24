//
// Created by enfeng on 13-1-24.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TBTableItem : NSObject <NSCoding> {
    id _userInfo;
}

@property (nonatomic, strong) id userInfo;

@end