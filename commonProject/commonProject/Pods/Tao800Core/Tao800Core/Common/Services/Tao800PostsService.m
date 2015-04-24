//
//  Tao800PostsService.m
//  tao800
//
//  Created by wuzhiguang on 13-4-23.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PostsService.h"
#import "TBCore/TBCore.h"

@implementation Tao800PostsService

//发帖接口
/**
 *@params
 **/
- (void)publishPosts:(NSDictionary *)params {
    NSString *topicUrl = [params objectForKey:@"topicUrl"];
    NSString *subject = [params objectForKey:@"subject"];
    NSString *content = [params objectForKey:@"content"];
    NSData *attachment_1 = [params objectForKey:@"attachment_1"];
    NSData *attachment_2 = [params objectForKey:@"attachment_2"];
    NSData *attachment_3 = [params objectForKey:@"attachment_3"];
    NSData *attachment_4 = [params objectForKey:@"attachment_4"];
    NSString *order_id = [params objectForKey:@"order_id"];
    
    NSURL *url = [NSURL URLWithString:topicUrl];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ServicePublishPostsTag;
    request.allowCompressedResponse = YES;
    request.timeOutSeconds = 180;
    
    [request setPostValue:subject forKey:@"subject"];
    [request setPostValue:content forKey:@"content"];
    [request setPostValue:order_id forKey:@"order_id"];
    
    if (attachment_1 != nil) {
        [request setData:attachment_1 withFileName:@"topic.jpg" andContentType:@"image/jpeg" forKey:@"attachment_1"];
    }
    
    if (attachment_2 != nil) {
        [request setData:attachment_2 withFileName:@"topic.jpg" andContentType:@"image/jpeg" forKey:@"attachment_2"];
    }
    
    if (attachment_3 != nil) {
        [request setData:attachment_3 withFileName:@"topic.jpg" andContentType:@"image/jpeg" forKey:@"attachment_3"];
    }
    
    if (attachment_4 != nil) {
        [request setData:attachment_4 withFileName:@"topic.jpg" andContentType:@"image/jpeg" forKey:@"attachment_4"];
    }
    
    [self send:request];
}

- (void)requestFinished:(ASIHTTPRequest *)requestParam {
    TBASIFormDataRequest *request = (TBASIFormDataRequest *) requestParam;
    
    if (self.delegate == nil) {
        return;
    }
    
    NSDictionary *dict = [self getResponseJsonResult:request];
    if(dict == nil){ //网络错误
        return;
    }
    
    SEL sel = nil;
    NSObject *retObj = nil;
    
    switch (request.serviceMethodFlag) {
        case ServicePublishPostsTag:
        {
            sel = @selector(publishPostsFinish:);
            retObj = dict;
        }
            break;
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:sel]) {
        TB_PERFORM_SELECTOR_LEAK_WARNING([self.delegate performSelector:sel withObject:retObj]);
    }
    
    [super requestFinished:request];
}

- (void)dealloc {
}

@end
