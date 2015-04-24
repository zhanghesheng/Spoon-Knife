//
//  TBCustomTabBarViewCTL.h
//  CustomTabBar
//
//  Created by enfeng on 13-5-21.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBCustomTabBar.h"
#import "TBNavigationViewCTL.h"
enum {
    TBCustomTabBarTag = 32221
};

@interface TBCustomTabBarViewCTL : TBNavigationViewCTL<TBCustomTabBarDelegate> {
     int _selectedIndex;

     NSArray *_originalViewCTLS;
    Class _tabBarClass;
}
@property(nonatomic) int selectedIndex;
@property(nonatomic, copy) NSArray *originalViewCTLS;
@property(nonatomic, assign) Class tabBarClass;


@end
