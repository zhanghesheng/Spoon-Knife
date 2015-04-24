//
//  Tao800ConfigTipBVO.m
//  tao800
//
//  Created by enfeng on 14-2-26.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800ConfigTipBVO.h"

@implementation Tao800ConfigTipBVO

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.tao800CloseLoginUrl forKey:@"tao800CloseLoginUrl"];
    [aCoder encodeObject:self.tao800OutProtocol forKey:@"tao800OutProtocol"];
    [aCoder encodeObject:@(self.tao800OutClose) forKey:@"tao800OutClose"];
    [aCoder encodeObject:@(self.isShowPreviewDealButton) forKey:@"isShowPreviewDealButton"];
    [aCoder encodeObject:self.showPreviewDealTime forKey:@"showPreviewDealTime"];
    [aCoder encodeObject:self.weixinScore forKey:@"weixinScore"];
    [aCoder encodeObject:self.isShowPhoneRechargeButton forKey:@"isShowPhoneRechargeButton"];
    [aCoder encodeObject:@(self.showFirstOrderEntry) forKey:@"showFirstOrderEntry"];
    [aCoder encodeObject:self.firstOrderUrl forKey:@"firstOrderUrl"];
    [aCoder encodeObject:self.qqScore forKey:@"qqScore"];
    [aCoder encodeObject:self.checkInRules forKey:@"checkInRules"];
    [aCoder encodeObject:@(self.weixinConcernSwitch) forKey:@"weixinConcernSwitch"];
    [aCoder encodeObject:self.inviteFriendsScoreReward forKey:@"inviteFriendsScoreReward"];
    [aCoder encodeObject:@(self.baoguangSwitch) forKey:@"baoguangSwitch"];
    [aCoder encodeObject:@(self.isUserDefineUrl) forKey:@"isUserDefineUrl"];
    [aCoder encodeBool:self.pushToShareSwitchIsOnOrOff forKey:@"pushToShareSwitchIsOnOrOff"];
    [aCoder encodeObject:self.pushToShareUrl forKey:@"pushToShareUrl"];
    [aCoder encodeBool:self.tao800SwitchTaobaoLogin forKey:@"tao800SwitchTaobaoLogin"];
    [aCoder encodeBool:self.enableDisplayTaobaoSaleCount forKey:@"enableDisplayTaobaoSaleCount"];
    [aCoder encodeObject:@(self.isDisplayIMSwitch) forKey:@"isDisplayIMSwitch"];
    [aCoder encodeObject:@(self.cpaOutNumber) forKey:@"cpaOutNumber"];

}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.tao800CloseLoginUrl = [aDecoder decodeObjectForKey:@"tao800CloseLoginUrl"];
        self.tao800OutProtocol = [aDecoder decodeObjectForKey:@"tao800OutProtocol"];
        self.tao800OutClose = (BOOL)[aDecoder decodeObjectForKey:@"tao800OutClose"];
        self.isShowPreviewDealButton = (BOOL)[aDecoder decodeObjectForKey:@"isShowPreviewDealButton"];
        self.showPreviewDealTime = [aDecoder decodeObjectForKey:@"showPreviewDealTime"];
        self.weixinScore = [aDecoder decodeObjectForKey:@"weixinScore"];
        self.isShowPhoneRechargeButton = [aDecoder decodeObjectForKey:@"isShowPhoneRechargeButton"];
        self.showFirstOrderEntry = (BOOL)[aDecoder decodeObjectForKey:@"showFirstOrderEntry"];
        self.firstOrderUrl = [aDecoder decodeObjectForKey:@"firstOrderUrl"];
        self.qqScore = [aDecoder decodeObjectForKey:@"qqScore"];
        self.checkInRules = [aDecoder decodeObjectForKey:@"checkInRules"];
        self.weixinConcernSwitch = (BOOL)[aDecoder decodeObjectForKey:@"weixinConcernSwitch"];
        self.inviteFriendsScoreReward = [aDecoder decodeObjectForKey:@"inviteFriendsScoreReward"];
        self.baoguangSwitch = (BOOL)[aDecoder decodeObjectForKey:@"baoguangSwitch"];
        self.isUserDefineUrl = (BOOL)[aDecoder decodeObjectForKey:@"isUserDefineUrl"];
        self.pushToShareSwitchIsOnOrOff = [aDecoder decodeBoolForKey:@"pushToShareSwitchIsOnOrOff"];
        self.pushToShareUrl = [aDecoder decodeObjectForKey:@"pushToShareUrl"];
        self.tao800SwitchTaobaoLogin = [aDecoder decodeBoolForKey:@"tao800SwitchTaobaoLogin"];

        self.isDisplayIMSwitch = (BOOL)[aDecoder decodeObjectForKey:@"isDisplayIMSwitch"];
        self.enableDisplayTaobaoSaleCount = (BOOL)[aDecoder decodeObjectForKey:@"enableDisplayTaobaoSaleCount"];
        self.cpaOutNumber = (int)[aDecoder decodeObjectForKey:@"cpaOutNumber"];
        
    }
    
    return self;
}

@end
