//
//  SCGIFImageView.m
//  TestGIF
//
//  Created by shichangone on 11-7-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SCGIFImageView.h"
#import <ImageIO/ImageIO.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSRunLoop.h>

@implementation SCGIFImageFrame
@synthesize image = _image;
@synthesize duration = _duration;


- (void)dealloc
{
    //[_image release];
    //[super dealloc];
}

@end

@interface SCGIFImageView ()

- (void)resetTimer;

- (void)showNextImage;

@end

@implementation SCGIFImageView
@synthesize imageFrameArray = _imageFrameArray;
@synthesize timer = _timer;
@synthesize animating = _animating;
@synthesize myRunLoop;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.threadArray = [NSMutableArray arrayWithCapacity:5];
    }
    return self;
}

- (void)dealloc
{
    [self resetTimer];
    if (self.threadArray && self.threadArray.count>0) {
        for(NSThread* thread in self.threadArray){
            [thread cancel];
        }
    }
    //[_imageFrameArray release];
    //[_timer release];
    //[super dealloc];
}

- (void)resetTimer {
    if (_timer && _timer.isValid) {
        [_timer invalidate];
    }
    
    self.timer = nil;
}

- (void)setData:(NSData *)imageData {
    if (!imageData) {
        return;
    }
    [self resetTimer];
    _runLoopFlag = NO;
    if (_loopref && _obsvr) {
        CFRunLoopRemoveObserver(*_loopref, *_obsvr, kCFRunLoopDefaultMode);
        CFRelease(*_obsvr);
        _loopref = nil;
        _obsvr = nil;
    }
    
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    size_t count = CGImageSourceGetCount(source);
    
    NSMutableArray* tmpArray = [NSMutableArray array];
    
    for (size_t i = 0; i < count; i++) {
        SCGIFImageFrame* gifImage = [[SCGIFImageFrame alloc] init];
        
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        gifImage.image = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        
        NSDictionary* frameProperties = (NSDictionary*)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source, i, NULL));
        gifImage.duration = [[[frameProperties objectForKey:(NSString*)kCGImagePropertyGIFDictionary] objectForKey:(NSString*)kCGImagePropertyGIFDelayTime] doubleValue];
        //NSLog(@"duration = %g",gifImage.duration);
        
        if (NeedResetUIStyleLikeIOS7()) {
            gifImage.duration = MAX(gifImage.duration/3, 0.01);
        }else{
            gifImage.duration = MAX(gifImage.duration/4, 0.01);
        }
        
        //NSLog(@"duration/n = %g",gifImage.duration);
        
        
        [tmpArray addObject:gifImage];
        
        CGImageRelease(image);
    }
    CFRelease(source);
    
    self.imageFrameArray = nil;
    if (tmpArray.count > 1) {
        self.imageFrameArray = tmpArray;
        _currentImageIndex = -1;
        _animating = YES;
        
        UIScreen * screen = [UIScreen mainScreen];
        if(CGRectGetHeight(screen.bounds)>480){
            @synchronized (self) {
                [self resetTimer];
                [self performSelector:@selector(createThread) withObject:nil afterDelay:.1];
            }
        }else{
            [self showNextImage];
        }
        //[self showNextImage];
        /*
        @synchronized (self) {
            [self resetTimer];
            [self performSelector:@selector(createThread) withObject:nil afterDelay:.1];
        }*/
        
    } else {
        self.image = [UIImage imageWithData:imageData];
    }
}

-(void)createThread{
    _runLoopFlag = YES;
    [NSThread detachNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
}

- (void)startThread
{
    @autoreleasepool {
        NSThread* thread = [NSThread currentThread];
        [self.threadArray addObject:thread];
        //[thread setThreadPriority:1];
        //setThreadPriority
        _currentImageIndex = (++_currentImageIndex) % _imageFrameArray.count;
        SCGIFImageFrame* gifImage = [_imageFrameArray objectAtIndex:_currentImageIndex];
        [super setImage:[gifImage image]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
        [thread setName:currentDateStr];
        
        // Code benefitting from a local autorelease pool.
        //获得当前thread的Run loop
        self.myRunLoop = [NSRunLoop currentRunLoop];
        
        //设置Run loop observer的运行环境
        //CFRunLoopObserverContext context = {0, self, NULL, NULL, NULL};
        CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
        
        //创建Run loop observer对象
        //第一个参数用于分配observer对象的内存
        //第二个参数用以设置observer所要关注的事件，详见回调函数myRunLoopObserver中注释
        //第三个参数用于标识该observer是在第一次进入run loop时执行还是每次进入run loop处理时均执行
        //第四个参数用于设置该observer的优先级
        //第五个参数用于设置该observer的回调函数
        //第六个参数用于设置该observer的运行环境
        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                                kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
        _obsvr = &observer;
        if (observer)
        {
            //将Cocoa的NSRunLoop类型转换成Core Foundation的CFRunLoopRef类型
            CFRunLoopRef cfLoop = [myRunLoop getCFRunLoop];
            _loopref = &cfLoop;
            //将新建的observer加入到当前thread的run loop
            CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
            
            //创建定时器并把它手工方式添加到当前线程的run loop
            NSDate* futureDate = [NSDate dateWithTimeIntervalSinceNow:gifImage.duration];
            NSTimer* myTimer = [[NSTimer alloc] initWithFireDate:futureDate
                                                        interval:gifImage.duration
                                                          target:self
                                                        selector:@selector(doFireTimer:)
                                                        userInfo:nil
                                                         repeats:YES];
            self.myTmr = myTimer;
            [myRunLoop addTimer:myTimer forMode:NSDefaultRunLoopMode];
            
            //创建定时器并以默认模式把它添加到当前线程的run loop
            //[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(doFireTimer2:) userInfo:nil repeats:YES];
            
            //NSInteger loopCount = 10;
            do
            {
                //NSLog(@"RunLoop开始运行----------- current loopCount:%d",loopCount);
                
                // Run the run loop 10 times to let the timer fire.
                //启动当前thread的loop直到所指定的时间到达，在loop运行时，run loop会处理所有来自与该run loop联系的input source的数据
                //对于本例与当前run loop联系的input source有两个Timer类型的source。
                //Timer每隔0.5或1秒发送触发事件给run loop，run loop检测到该事件时会调用相应的处理方法。
                
                //由于在run loop添加了observer且设置observer对所有的run loop行为都感兴趣。
                //当调用runUnitDate方法时，observer检测到run loop启动并进入循环，observer会调用其回调函数，第二个参数所传递的行为是kCFRunLoopEntry。
                //observer检测到run loop的其它行为并调用回调函数的操作与上面的描述相类似。
                [myRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:gifImage.duration]];
                
                //当run loop的运行时间到达时，会退出当前的run loop。observer同样会检测到run loop的退出行为并调用其回调函数，第二个参数所传递的行为是kCFRunLoopExit。
                //NSLog(@"RunLoop结束运行");
                
                //loopCount--;
                
            }
            while (_runLoopFlag);
            
            if (myTimer && myTimer.isValid) {
                [myTimer invalidate];
            }

            //CFRunLoopRemoveObserver(cfLoop, observer, kCFRunLoopDefaultMode);
            //CFRelease(observer);
        }

        
    }
}

void myRunLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    switch (activity) {
            //The entrance of the run loop, before entering the event processing loop.
            //This activity occurs once for each call to CFRunLoopRun and CFRunLoopRunInMode
            // Runloop入口
        case kCFRunLoopEntry:
            //NSLog(@"run loop entry");
            break;
            //Inside the event processing loop before any timers are processed
            //Runloop何时处理一个定时器
        case kCFRunLoopBeforeTimers:
            //NSLog(@"run loop before timers");
            break;
            //Inside the event processing loop before any sources are processed
            //Runloop何时处理一个输入源
        case kCFRunLoopBeforeSources:
            //NSLog(@"run loop before sources");
            break;
            //Inside the event processing loop before the run loop sleeps, waiting for a source or timer to fire.
            //This activity does not occur if CFRunLoopRunInMode is called with a timeout of 0 seconds.
            //It also does not occur in a particular iteration of the event processing loop if a version 0 source fires
            //Runloop何时进入睡眠状态
        case kCFRunLoopBeforeWaiting:
            //NSLog(@"run loop before waiting");
            break;
            //Inside the event processing loop after the run loop wakes up, but before processing the event that woke it up.
            //This activity occurs only if the run loop did in fact go to sleep during the current loop
            //Runloop何时被唤醒，但在唤醒之前要处理的事件
        case kCFRunLoopAfterWaiting:
            //NSLog(@"run loop after waiting");
            break;
            //The exit of the run loop, after exiting the event processing loop.
            //This activity occurs once for each call to CFRunLoopRun and CFRunLoopRunInMode
            //Runloop终止
        case kCFRunLoopExit:
            //NSLog(@"run loop exit");
            break;
            
        default:
            break;
    }
}


- (void)doFireTimer:(id)sel
{
    if (!_animating) {
        //NSLog(@"_animating = NO");
        return;
    }
    //NSThread* thread = [NSThread currentThread];
    //NSLog(@"%@",thread.name);

    _currentImageIndex = (++_currentImageIndex) % _imageFrameArray.count;
    SCGIFImageFrame* gifImage = [_imageFrameArray objectAtIndex:_currentImageIndex];
    //[super setImage:[gifImage image]];
    self.layer.contents = (id) [gifImage image].CGImage;
}



- (void)setImage:(UIImage *)image {
    [super setImage:image];
    [self resetTimer];
    self.imageFrameArray = nil;
    _animating = NO;
}

- (void)showNextImage {
    if (!_animating) {
        return;
    }
    
    _currentImageIndex = (++_currentImageIndex) % _imageFrameArray.count;
    SCGIFImageFrame* gifImage = [_imageFrameArray objectAtIndex:_currentImageIndex];
    //[super setImage:[gifImage image]];
    self.layer.contents = (id) [gifImage image].CGImage;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:gifImage.duration target:self selector:@selector(showNextImage) userInfo:nil repeats:NO];
}

- (void)setAnimating:(BOOL)animating {
    if (_imageFrameArray.count < 2) {
        _animating = animating;
        return;
    }
    
    if (!_animating && animating) {
        //continue
        _animating = animating;
        if (!_timer) {
            UIScreen * screen = [UIScreen mainScreen];
            if(CGRectGetHeight(screen.bounds)>480){
                @synchronized (self) {
                    [self resetTimer];
                    [self performSelector:@selector(createThread) withObject:nil afterDelay:.1];
                }
            }else{
                [self showNextImage];
            }
        }
    } else if (_animating && !animating) {
        //stop
        _animating = animating;
        [self resetTimer];
        _runLoopFlag = NO;
        if (self.myTmr && self.myTmr.isValid) {
            [self.myTmr invalidate];
        }
        if (_loopref && _obsvr){
            CFRunLoopRemoveObserver(*_loopref, *_obsvr, kCFRunLoopDefaultMode);
            CFRelease(*_obsvr);
            _loopref = nil;
            _obsvr = nil;
        }
        if (self.threadArray && self.threadArray.count>0) {
            for(NSThread* thread in self.threadArray){
                [thread cancel];
            }
        }
    }
}

@end
