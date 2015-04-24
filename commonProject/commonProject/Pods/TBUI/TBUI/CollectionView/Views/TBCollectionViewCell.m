//
//  TBCollectionViewCell.m
//  TBUI
//
//  Created by enfeng on 14-7-17.
//  Copyright (c) 2014年 com.tuan800.framework.ui. All rights reserved.
//

#import "TBCollectionViewCell.h"

@implementation TBCollectionViewCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse { 
    [super prepareForReuse];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
    if (_item != object) {
        _item = object;
    }
}

+ (NSString *) tbIdentifier {
    return nil;
}
@end
