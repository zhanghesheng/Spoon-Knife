//
//  Tao800ShareSocialBVO.m
//  tao800
//
//  Created by enfeng on 14/11/20.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBShareKit/TBShareVo.h>
#import "Tao800ShareSocialBVO.h"
#import "TBCore/NSDictionaryAdditions.h"
#import "Tao800DealVo.h"
#import "Tao800ShareVo.h"
#import "Tao800FunctionCommon.h"
#import "Tao800ShareDealItem.h"
#import "Tao800LotteryDetailHeaderVo.h"
#import "Tao800MyLuckyDrawVo.h"
#import "TBCore/TBCore.h"

@implementation Tao800ShareSocialBVO
+ (Tao800ShareSocialBVO *)wrapperShareSocialBVO:(NSDictionary *)item {
    Tao800ShareSocialBVO *shareSocialBVO = [[Tao800ShareSocialBVO alloc] init];
    
    shareSocialBVO.contentId = [item objectForKey:@"id" convertNSNullToNil:YES];
    NSNumber *shareType = [item objectForKey:@"share_type" convertNSNullToNil:YES];
    shareSocialBVO.socialType = (Tao80ShareSocialType) shareType.intValue;
    
    shareSocialBVO.shareMethod = [item objectForKey:@"share_method" convertNSNullToNil:YES];
    shareSocialBVO.shareTitle = [item objectForKey:@"share_title" convertNSNullToNil:YES];
    shareSocialBVO.shareSmallPic = [item objectForKey:@"share_small_pic" convertNSNullToNil:YES];
    shareSocialBVO.shareLink = [item objectForKey:@"share_link" convertNSNullToNil:YES];
    shareSocialBVO.recommendPic = [item objectForKey:@"recommend_pic" convertNSNullToNil:YES];
    shareSocialBVO.recommendLink = [item objectForKey:@"recommend_link" convertNSNullToNil:YES];
    shareSocialBVO.infos = [item objectForKey:@"infos" convertNSNullToNil:YES];
    shareSocialBVO.images = [item objectForKey:@"images" convertNSNullToNil:YES];
    shareSocialBVO.lastUpdated = [NSDate date];
    
    return shareSocialBVO;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.contentId = [coder decodeObjectForKey:@"self.contentId"];
        self.socialType = (Tao80ShareSocialType) [coder decodeIntForKey:@"self.socialType"];
        self.shareMethod = [coder decodeObjectForKey:@"self.shareMethod"];
        self.shareTitle = [coder decodeObjectForKey:@"self.shareTitle"];
        self.shareSmallPic = [coder decodeObjectForKey:@"self.shareSmallPic"];
        self.shareLink = [coder decodeObjectForKey:@"self.shareLink"];
        self.recommendPic = [coder decodeObjectForKey:@"self.recommendPic"];
        self.recommendLink = [coder decodeObjectForKey:@"self.recommendLink"];
        self.infos = [coder decodeObjectForKey:@"self.infos"];
        self.images = [coder decodeObjectForKey:@"self.images"];
        self.lastUpdated = [coder decodeObjectForKey:@"self.lastUpdated"];
        self.dealId = [coder decodeObjectForKey:@"self.dealId"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.contentId forKey:@"self.contentId"];
    [coder encodeInt:self.socialType forKey:@"self.socialType"];
    [coder encodeObject:self.shareMethod forKey:@"self.shareMethod"];
    [coder encodeObject:self.shareTitle forKey:@"self.shareTitle"];
    [coder encodeObject:self.shareSmallPic forKey:@"self.shareSmallPic"];
    [coder encodeObject:self.shareLink forKey:@"self.shareLink"];
    [coder encodeObject:self.recommendPic forKey:@"self.recommendPic"];
    [coder encodeObject:self.recommendLink forKey:@"self.recommendLink"];
    [coder encodeObject:self.infos forKey:@"self.infos"];
    [coder encodeObject:self.images forKey:@"self.images"];
    [coder encodeObject:self.lastUpdated forKey:@"self.lastUpdated"];
    [coder encodeObject:self.dealId forKey:@"self.dealId"];
}

- (NSArray *)shareMethodArray {
    return [self.shareMethod componentsSeparatedByString:@","];
}

+ (NSString *)defaultShareMethod {
    return [NSString stringWithFormat:@"%d,%d", (int)Tao80ShareMethodWeixin, (int)Tao80ShareMethodFriends];
}

- (Tao800ShareVo *)shareVoWithDeal:(Tao800ShareDealItem *)shareDealItem shareVo:(Tao800ShareVo *)shareVoParam {
    //分享文本。分享文本和图片会返回多值，客户端随机取一个展示。
    // 分享文本是模板形式，包含标题、原价、现价和是否包邮，需要客户端自行替换。
    // %title%代表标题；%list_price%代表原价；%price%代表现价；%baoyou%代表包邮。
    Tao800ShareVo *shareVo = [[Tao800ShareVo alloc] init];
    
    shareVo.appTitle = @"折800";
    shareVo.shareUrl = self.shareLink;
    shareVo.title = self.shareTitle;
    
    uint ct = (uint) (self.infos.count - 1);
    uint index = 0;
    BOOL isBaoyou = NO;
    NSString *dealId = nil;
    if (self.infos.count > 0) {
        index = arc4random_uniform(ct);
        shareVo.message = self.infos[index];
    }
    
    ct =  (uint) (self.images.count - 1);
    
    if (self.images.count > 0) {
        index = arc4random_uniform(ct);
        shareVo.imageNormal = self.images[index];
    }
    if (self.shareSmallPic && self.shareSmallPic.length>0) {
        shareVo.imageNormal = self.shareSmallPic;
    }
    
    shareVo.needAppendTuan800Download = NO;
    int price = 0;
    NSString *dealTitle = nil;
    int listPrice = 0;
    
    NSString *shareTitle = nil;
    
    if (shareDealItem.dealVo) {
        price = shareDealItem.dealVo.price;
        listPrice = shareDealItem.dealVo.listPrice;
        dealTitle = shareDealItem.dealVo.shortTitle;
        isBaoyou = shareDealItem.dealVo.isBaoyou;
        dealId = [NSString stringWithFormat:@"%d", shareDealItem.dealVo.dealId];
        if (shareDealItem.dealVo.sourceType==Tao800DealSourceTypeMall) {
            //特卖商城
            shareTitle = @"折800特卖天天11.11";
        } else {
            shareTitle = @"这个商品我喜欢~哪个土豪帮我拿下？";
        }
        
    } else if (shareDealItem.lotteryDetailHeaderVo) {
        price = shareDealItem.lotteryDetailHeaderVo.price;
        listPrice = shareDealItem.lotteryDetailHeaderVo.listPrice;
        if (self.socialType == Tao80ShareSocialTypeLuckyDraw){
            //0元
            shareVo.title = self.shareTitle;
            if(!shareVo.title){
                shareVo.title = @"奖品大放送，万一中了呢！";
            }
            dealTitle = shareVo.title;
        }else{
            dealTitle = shareDealItem.lotteryDetailHeaderVo.title;
        }
        isBaoyou = YES;
        dealId = shareDealItem.lotteryDetailHeaderVo.dealId;
    } else {
        price = shareDealItem.myLuckyDrawVo.price;
        listPrice = shareDealItem.myLuckyDrawVo.originPrice;
        dealTitle = shareDealItem.myLuckyDrawVo.title;
        isBaoyou = shareDealItem.myLuckyDrawVo.isBaoyou;
        dealId = [NSString stringWithFormat:@"%d",shareDealItem.myLuckyDrawVo.dealId];
    }
    
    if (shareVo.message && shareVo.message.trim.length > 0) {
        NSString *price2 = FenToYuanFormat(price);
        NSString *listPrice2 = FenToYuanFormat(listPrice);
        
        NSMutableString *mString = [NSMutableString stringWithString:shareVo.message];
        NSRange range = [mString rangeOfString:@"%title%"];
        
        if (range.length > 0) {
            if (dealTitle) {
                [mString replaceCharactersInRange:range withString:dealTitle];
            }
        }
        
        range = [mString rangeOfString:@"%list_price%"];
        if (range.length > 0) {
            [mString replaceCharactersInRange:range withString:listPrice2];
        }
        
        range = [mString rangeOfString:@"%price%"];
        if (range.length > 0) {
            [mString replaceCharactersInRange:range withString:price2];
        }
        
        range = [mString rangeOfString:@"%baoyou%"];
        NSString *baoyou = nil;
        if (isBaoyou) {
            baoyou = @"包邮";
        } else {
            baoyou = @"不包邮";
        }
        if (range.length > 0) {
            [mString replaceCharactersInRange:range withString:baoyou];
        }
        shareVo.message = mString;
    } else {
        shareVo.message = shareVoParam.message;
        if (self.socialType == Tao80ShareSocialTypeLuckyDraw){
            shareVo.message = shareDealItem.lotteryBVO.title;
        }
    }
    
    if (!shareVo.title) {
        if (shareTitle) {
            shareVo.title = shareTitle;
        } else {
            shareVo.title = shareVoParam.title;
        }
    }
    if (!shareVo.shareUrl || shareVo.shareUrl.trim.length < 1) {
        shareVo.shareUrl = shareVoParam.shareUrl;
    }
    if (self.socialType == Tao80ShareSocialTypeLuckyDraw){
        if (!shareVo.imageNormal && shareDealItem.lotteryBVO.listImage && shareDealItem.lotteryBVO.listImage.count>0) {
            shareVo.imageNormal = [shareDealItem.lotteryBVO.listImage objectAtIndex:0];
        }
    }else{
        if (!shareVo.imageNormal) {
            shareVo.imageNormal = shareVoParam.imageNormal;
        }
    }
    
    
    NSString *shareUrl = nil;
    
    if (self.socialType == Tao80ShareSocialTypeLuckyDraw) {
        shareUrl = shareDealItem.lotteryBVO.sharedUrl;
        if (!shareUrl) {
            shareUrl = [NSString stringWithFormat:@"http://m.zhe800.com/h5/lottery_deal/%@/%d", dealId, (int) self.socialType];
        }
        
    } else if (self.socialType == Tao80ShareSocialTypeMall) {
        shareUrl = [NSString stringWithFormat:@"http://m.zhe800.com/h5/deal/%@/%d", dealId, (int)self.socialType];
    } else if (self.socialType == Tao80ShareSocialTypeTaobao) {
        shareUrl = [NSString stringWithFormat:@"http://m.zhe800.com/h5/deal/%@/%d", dealId,(int) self.socialType];
    } else if (self.socialType == Tao80ShareSocialTypeUnlock) {
        shareUrl = [NSString stringWithFormat:@"http://m.zhe800.com/h5/deal/%@/%d", dealId,(int) self.socialType];
    }
    if (shareUrl) {
        shareVo.shareUrl = shareUrl;
    }
    if (!self.dealId) {
        self.dealId = [NSString stringWithFormat:@"%d",shareDealItem.dealVo.dealId];
    }
    
    return shareVo;
}


@end
