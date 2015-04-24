//
//  SCGIFImageView.h
//  TestGIF
//
//  Created by shichangone on 11-7-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TBCore/TBCore.h>

@interface SCGIFImageFrame : NSObject {
    
}
@property (nonatomic) double duration;
@property (nonatomic, retain) UIImage* image;

@end

@interface SCGIFImageView : UIImageView {
    NSInteger _currentImageIndex;
}
@property (nonatomic, retain) NSArray* imageFrameArray;
@property (nonatomic, retain) NSTimer* timer;

//Setting this value to pause or continue animation;
@property (nonatomic) BOOL animating;
@property (nonatomic,retain)NSRunLoop *myRunLoop;
@property (atomic,assign) BOOL runLoopFlag;
@property (atomic) CFRunLoopRef* loopref;
@property (atomic) CFRunLoopObserverRef* obsvr;
@property (atomic,weak) NSTimer* myTmr;
@property (atomic) NSMutableArray* threadArray;

- (void)setData:(NSData*)imageData;

@end
