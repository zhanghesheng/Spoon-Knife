//
//  TBUICycleScrollSubView.h
//  universalT800
//
//  Created by enfeng on 13-1-18.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBUICycleScrollSubView : UIView {
     NSString *_reuseIdentifier;
}
@property(nonatomic, copy) NSString *reuseIdentifier;


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)identifier;
@end
