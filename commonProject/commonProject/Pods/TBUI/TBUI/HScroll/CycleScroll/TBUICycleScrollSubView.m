//
//  TBUICycleScrollSubView.m
//  universalT800
//
//  Created by enfeng on 13-1-18.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "TBUICycleScrollSubView.h"

@implementation TBUICycleScrollSubView
@synthesize reuseIdentifier = _reuseIdentifier;

- (void) initContent {
    self.reuseIdentifier = @"circleScrollView";
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initContent];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)identifier {
    self = [super initWithFrame:frame];
    if (self) {
        [self initContent];
        self.reuseIdentifier = identifier;
    }
    return self;
}

- (void)dealloc {
 
}

@end
