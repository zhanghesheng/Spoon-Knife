//
//  Tao800FirstOrderCheckerModel.m
//  tao800
//
//  Created by hanyuan on 14-3-5.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800FirstOrderCheckerModel.h"
#import "Tao800DataModelSingleton.h"

//notification
NSString *const Tao800FirstOrderStateDidChangeNotifyCation = @"Tao800FirstOrderStateDidChangeNotifyCation";
//key
NSString *const Tao800FirstOrderUserDefaultKey = @"firstOrderKey";
NSString *const Tao800FirstOrderEntryKey = @"showEntry";
NSString *const Tao800FirstOrderMarkKey = @"showMark";

@interface Tao800FirstOrderCheckerModel()
@property(nonatomic, strong)Tao800PointService *service;
@end

@implementation Tao800FirstOrderCheckerModel

-(id)init{
    self = [super init];
    if(self){
        _service = [[Tao800PointService alloc] init];
    }
    return  self;
}

-(void)dealloc{
    
}

-(void)checkFirstOrderState{
    NSMutableDictionary *returnValue = [[NSMutableDictionary alloc] init];
    NSString *showEntry = @"NO";
    NSString *showMark = @"NO";
    if(![self checkConfigOpen]){ //后台开关关闭
        showEntry = @"NO";
        showMark = @"NO";
    }else{
        if(![self checkLogin]){ //未登陆，需显示入口
            showEntry = @"YES";
            if([self checkShowMark]){
                showMark = @"YES";
            }
        }else{ //已登陆
            if([self checkShowEntry]){ //缓存表明无订单，需要请求订单数据
                [self getOrders:nil];
                return;
            }
        }
    }
    
    [returnValue setObject:showEntry forKey:Tao800FirstOrderEntryKey];
    [returnValue setObject:showMark forKey:Tao800FirstOrderMarkKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Tao800FirstOrderStateDidChangeNotifyCation
                                                        object:nil
                                                      userInfo:returnValue];
}

-(void)notifyEntryState:(BOOL)open{
    NSDictionary *dict = [self modifiedEntryState:open];
    [[NSNotificationCenter defaultCenter] postNotificationName:Tao800FirstOrderStateDidChangeNotifyCation
                                                        object:nil
                                                      userInfo:dict];
}

-(void)notifyMarkState:(BOOL)show{
    NSDictionary *dict = [self modifiedMarkState:show];
    [[NSNotificationCenter defaultCenter] postNotificationName:Tao800FirstOrderStateDidChangeNotifyCation
                                                        object:nil
                                                      userInfo:dict];
}

-(NSDictionary *)modifiedEntryState:(BOOL)open{
    NSString *showEntryValue = @"NO";
    NSString *showMarkValue = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:Tao800FirstOrderUserDefaultKey]];
    if(open){
        showEntryValue = @"YES";
    }
    showMarkValue = [dict objectForKey:Tao800FirstOrderMarkKey];
    if(showMarkValue == nil){
        showMarkValue = @"YES";
    }
    [dict setObject:showEntryValue forKey:Tao800FirstOrderEntryKey];
    [dict setObject:showMarkValue forKey:Tao800FirstOrderMarkKey];
    [defaults setObject:dict forKey:Tao800FirstOrderUserDefaultKey];
    [defaults synchronize];
    return dict;
}

-(NSDictionary *)modifiedMarkState:(BOOL)show{
    NSString *showEntryValue = @"YES";
    NSString *showMarkValue = @"NO";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:Tao800FirstOrderUserDefaultKey]];
    if(show){
        showMarkValue = @"YES";
    }
    [dict setObject:showEntryValue forKey:Tao800FirstOrderEntryKey];
    [dict setObject:showMarkValue forKey:Tao800FirstOrderMarkKey];
    
    [defaults setObject:dict forKey:Tao800FirstOrderUserDefaultKey];
    [defaults synchronize];
    return dict;
}

-(BOOL)checkConfigOpen{
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    return dm.showFirstOrderEntry;
}

-(BOOL)checkLogin{
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    if(dm.user!=nil && dm.user.userId!=nil){
        return YES;
    }
    return NO;
}

-(BOOL)checkShowMark{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:Tao800FirstOrderUserDefaultKey]];
    if(dict==nil || dict.count==0){
        return YES;
    }else{
        NSString *showMark = [dict objectForKey:Tao800FirstOrderMarkKey];
        if([showMark isEqualToString:@"YES"]){
            return YES;
        }
    }
    return NO;
}

-(BOOL)checkShowEntry{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:Tao800FirstOrderUserDefaultKey]];
    if(dict==nil || dict.count==0){
        return YES;
    }else{
        NSString *showEntry = [dict objectForKey:Tao800FirstOrderEntryKey];
        if([showEntry isEqualToString:@"YES"]){
            return YES;
        }
    }
    return NO;
}

-(void)getOrders:(NSDictionary *)params{
    [self.service removeAllRequestFromArray];
    
    int pageNum = 1;
    int pageSize = 20;
    NSString *offset = [NSString stringWithFormat:@"%d", (pageNum-1)*pageSize];
    NSString *limit = [NSString stringWithFormat:@"%d", pageSize];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      limit, @"limit",
                                      offset, @"offset",
                                      nil];
    
    __weak Tao800FirstOrderCheckerModel *instance = self;
    [self.service getScoreFeedbackOrderList:paramDict
                              completion:^(NSDictionary *dic) {
                                  [instance getScoreFeedbackOrderListFinish:dic];
                              } failure:^(TBErrorDescription *error) {
                                  [instance didFirstOrderNetworkError];
                              }];
}

-(void)getScoreFeedbackOrderListFinish:(NSDictionary *)params{
    NSMutableDictionary *returnValue = [[NSMutableDictionary alloc] init];
    NSString *showEntry = @"NO";
    NSString *showMark = @"NO";
    
    NSArray *orders = [params objectForKey:@"items"];
    if(orders==nil || orders.count==0){
        showEntry = @"YES";
        if([self checkShowMark]){
            showMark = @"YES";
        }
        [self modifiedEntryState:YES];
    }else{
        [self modifiedEntryState:NO];
    }
    
    [returnValue setObject:showEntry forKey:Tao800FirstOrderEntryKey];
    [returnValue setObject:showMark forKey:Tao800FirstOrderMarkKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Tao800FirstOrderStateDidChangeNotifyCation
                                                        object:nil
                                                      userInfo:returnValue];
}


- (void)didFirstOrderNetworkError {
    NSMutableDictionary *returnValue = [[NSMutableDictionary alloc] init];
    NSString *showEntry = @"NO";
    NSString *showMark = @"NO";
    [returnValue setObject:showEntry forKey:Tao800FirstOrderEntryKey];
    [returnValue setObject:showMark forKey:Tao800FirstOrderMarkKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Tao800FirstOrderStateDidChangeNotifyCation
                                                        object:nil
                                                      userInfo:returnValue];
}

@end
