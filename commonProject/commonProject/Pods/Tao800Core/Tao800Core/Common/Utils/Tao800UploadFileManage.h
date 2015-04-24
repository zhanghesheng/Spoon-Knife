//
//  Tao800UploadFileManage.h
//  tao800
//
//  Created by Rose on 14/11/3.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBService/Tuan800API.h>

typedef void (^Tao800UploadFileManageCallback)(NSDictionary* responseData);

@interface Tao800UploadFileManage : TBBaseNetworkApi

@property (nonatomic, copy) Tao800UploadFileManageCallback successfullCallback;
@property (nonatomic, copy) Tao800UploadFileManageCallback failureCallback;
 

//- (void)downloadPhoto:(NSString *)imageURLString;

- (void)uploadFile:(NSData *)fileData tag:(NSString *) tag url:(NSString*)theUrl;

@end
