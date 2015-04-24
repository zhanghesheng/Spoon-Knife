//
//  TBModel.h
//  TBUI
//
//  Created by enfeng on 14-1-10.
//  Copyright (c) 2014年 com.tuan800.framework.ui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBErrorDescription.h"

@protocol TBModelDelegate;

@interface TBModel : NSObject {

@protected
    NSMutableArray *_items;
    NSInteger _pageSize;
    NSInteger _pageNumber;
    BOOL _hasNext;
    BOOL _loading;
}
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, weak) id <TBModelDelegate> delegate;

@property(nonatomic, assign) NSInteger pageSize;
@property(nonatomic, assign) NSInteger pageNumber;
@property(nonatomic, assign) BOOL hasNext;
@property(nonatomic, assign) BOOL loading;


- (void)loadItems:(NSDictionary *)params
       completion:(void (^)(NSDictionary *))completion
          failure:(void (^)(TBErrorDescription *))failure;
@end


@protocol TBModelDelegate <NSObject>

@optional

/**
 * model 请求结束后回调该方法
 * 所有数据相关内容都保存在Model中
 */
- (void)tbModelDidLoad:(TBModel *)tbModel;

/**
 * 当Model中的请求出现错误时回调该方法
 */
- (void)tbModel:(TBModel *)tbModel loadError:(TBErrorDescription *)errorDescription;

@end
