//
//  TBCustomTabBar.h
//  CustomTabBar
//
//  Created by enfeng on 13-5-21.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TBCustomTabBarDelegate;

@interface TBCustomTabBar : UIView { 
    int _selectedIndex;
}
@property(nonatomic, weak) id <TBCustomTabBarDelegate> delegate;
@property(nonatomic) int selectedIndex;


+ (CGFloat)tabBarHeight;
@end

@protocol TBCustomTabBarDelegate <NSObject>
- (void)tabBar:(TBCustomTabBar *)tabBar didSelectItem:(id)sender atIndex:(int)index;
@end
