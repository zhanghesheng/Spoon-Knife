//
//  Tao800UploadFileManage.m
//  tao800
//
//  Created by Rose on 14/11/3.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800UploadFileManage.h"
#import <TBNetwork/ASINetworkQueue.h>
#import <TBNetwork/ASIHTTPRequest.h>
#import <TBCore/TBURLCache.h>
#import <TBUI/TBErrorDescription.h>
#import <TBUI/TBUICommon.h>
#import "Tao800NotifycationConstant.h"
#import "TBCore/TBCoreMacros.h"
#import "TBCore/NSDictionaryAdditions.h"

@interface Tao800UploadFileManage ()
@property(nonatomic, strong) NSMutableDictionary *downloadPhotoUrlDict;
@property(nonatomic, strong) NSMutableDictionary *uploadPhotoTagDict;

@property(nonatomic, strong) ASINetworkQueue *downloadPhotoRequestQueue;
@property(nonatomic, strong) ASINetworkQueue *uploadPhotoRequestQueue;

@property(nonatomic) dispatch_queue_t downloadPhotoURLQueue;
@property(nonatomic) dispatch_queue_t uploadPhotoQueue;
@end

@implementation Tao800UploadFileManage

- (instancetype)init {
    self = [super init];
    if (self) {
        self.downloadPhotoUrlDict = [[NSMutableDictionary alloc] init];
        self.uploadPhotoTagDict = [[NSMutableDictionary alloc] init];
        _downloadPhotoURLQueue = dispatch_queue_create("com.zhe800.downloadPhotoQueue",
                                                       DISPATCH_QUEUE_CONCURRENT);
        _uploadPhotoQueue = dispatch_queue_create("com.zhe800.uploadPhotoQueue",
                                                  DISPATCH_QUEUE_CONCURRENT);
        
        self.uploadPhotoRequestQueue = [[ASINetworkQueue alloc] init];
        self.downloadPhotoRequestQueue = [[ASINetworkQueue alloc] init];
        [self.downloadPhotoRequestQueue setMaxConcurrentOperationCount:3];
        [self.uploadPhotoRequestQueue setMaxConcurrentOperationCount:3];
    }
    return self;
}

//- (void)postDownloadFailNotification:(TBErrorDescription *)tbd {
//    
//    dispatch_sync(self.downloadPhotoURLQueue, ^{
//        [self.downloadPhotoUrlDict removeObjectForKey:tbd.urlString];
//        
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            TBDPRINT(@"图片下载失败");
//            NSDictionary *dict = @{
//                                   @"urlString" : tbd.urlString,
//                                   @"successful" : @(NO)
//                                   };
//            [[NSNotificationCenter defaultCenter] postNotificationName:Tao800ImageDownloadDidFinishNotification
//                                                                object:nil
//                                                              userInfo:dict];
//        });
//    });
//}


- (void)uploadFile:(NSData *)fileData tag:(NSString *)tag url:(NSString*)theUrl{
    if (!fileData) {
        return;
    }
    
    dispatch_barrier_async(self.uploadPhotoQueue, ^{
        NSString *string = self.uploadPhotoTagDict[tag];
        if (string) {
            return;
        }
        
        [self.uploadPhotoTagDict setValue:tag forKey:tag];
        [self upload:fileData tag:tag url:theUrl];
    });
}

- (void)upload:(NSData *)imageData tag:(NSString *)tag url:(NSString*)theUrl{
    
    __weak Tao800UploadFileManage *instance = self;
    NSString *uploadURLString = [NSString stringWithFormat:@"%@?source=replay",
                                 theUrl
                                 ];
    NSURL *url = [NSURL URLWithString:uploadURLString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *requestWeak = request;
    request.requestMethod = TBRequestMethodPost;
    NSString *name = [NSString stringWithFormat:@"%@.png", tag];
    [request setData:imageData withFileName:name andContentType:@"image/png" forKey:@"uploadImg"];
    request.userInfo = @{@"tag" : tag};
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:requestWeak];
        if (!dict) {
            NSString *tag1 = requestWeak.userInfo[@"tag"];
            TBErrorDescription *tbd = [instance getErrorDescription:requestWeak];
            tbd.tag = tag1;
            [instance postUploadFailNotification:tbd];
            return;
        }
        NSString *tag1 = requestWeak.userInfo[@"tag"];
//        NSDictionary *dataDict = [dict objectForKey:@"data" convertNSNullToNil:YES];
        //NSString *responseCode = [dict objectForKey:@"responsecode" convertNSNullToNil:YES];
//        NSString *urlPath = [dataDict objectForKey:@"url" convertNSNullToNil:YES];
        
        NSString *dataStr = [requestWeak responseString];
        NSString *codesign = [dict objectForKey:@"code" convertNSNullToNil:YES];
        
        //if (responseCode && [responseCode isEqualToString:@"_200"]) {
        //    imgURLString = imageUrlPath;
        //}
        [instance postUploadSuccessfulNotification:tag1 codeStatus:codesign imageData:imageData dict:dict responseData:dataStr];
    }];
    
    [request setFailedBlock:^{
        NSString *tag1 = requestWeak.userInfo[@"tag"];
        TBErrorDescription *tbd = [instance getErrorDescription:requestWeak];
        tbd.tag = tag1;
        [instance postUploadFailNotification:tbd];
    }];
    
    [self.uploadPhotoRequestQueue addOperation:request];
    [self.uploadPhotoRequestQueue go];
}

- (void)postUploadSuccessfulNotification:(NSString *)tag
                              codeStatus:(NSString *)thecode
                               imageData:(NSData *)imageData
                                    dict:(NSDictionary*) theDic
                            responseData:(NSString*)dataString
{
    if (!thecode || [thecode isEqualToString:@"1"]) {
        TBErrorDescription *tbd = [[TBErrorDescription alloc] init];
        tbd.tag = tag;
        [self postUploadFailNotification:tbd];
        return;
    }
    
    [[TBURLCache sharedCache] storeData:imageData forURL:thecode];
    __weak Tao800UploadFileManage *instance = self;
    
    dispatch_sync(self.uploadPhotoQueue, ^{
        [self.uploadPhotoTagDict removeObjectForKey:tag];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            TBDPRINT(@"图片上传成功");
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
            
            [dict setValue: @(YES) forKey:@"successful"];
            [dict setValue:dataString forKey:@"datastring"];
            [dict setValue:theDic forKey:@"dic"];
            [dict setValue:tag forKey:@"picName"];
            if (instance.successfullCallback) {
                instance.successfullCallback(dict);
            }
            
        });
    });
}

- (void)postUploadFailNotification:(TBErrorDescription *)tbd {
    
    dispatch_sync(self.uploadPhotoQueue, ^{
        [self.uploadPhotoTagDict removeObjectForKey:tbd.tag];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            TBDPRINT(@"图片上传失败");
//            NSDictionary *dict = @{
//                                   @"tag" : tbd.tag,
//                                   @"successful" : @(NO)
//                                   };
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
            
            [dict setValue:tbd.tag forKey:@"picName"];
            __weak Tao800UploadFileManage *instance = self;
            if (instance.failureCallback) {
                instance.failureCallback(dict);
            }
        });
    });
}

@end
