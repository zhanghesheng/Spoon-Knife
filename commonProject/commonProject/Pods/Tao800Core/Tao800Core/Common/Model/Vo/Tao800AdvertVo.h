//
// Created by enfeng on 12-5-28.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface Tao800AdvertVo : NSObject  {

    NSString *_message;
    NSString *_data;
    NSString *_aId;
    NSString *_title;
    NSString *_advertType;
    NSString *_imgUrl;
    
    BOOL _show_model;
}

@property(nonatomic,retain) NSString *message;
@property(nonatomic,retain) NSString *data;
@property(nonatomic,retain) NSString *aId;
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *advertType;
@property(nonatomic,retain) NSString *imgUrl;

@property(nonatomic,assign) BOOL show_model;

@end