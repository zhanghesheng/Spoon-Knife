//
//  Tao800AnalysisExposureConstant.m
//  Tao800Core
//
//  Created by enfeng on 15/3/10.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import "Tao800AnalysisExposureConstant.h"

NSString *const Tao800ExposureReferParam = @"ExposureReferParam";
NSString *const Tao800ExposurePostTypeParam = @"Tao800ExposurePostTypeParam";

@implementation Tao800AnalysisExposureConstant

+ (NSString *)postTypeWith:(Tao800AnalysisExposurePostType)postType {
    NSString *ret = @"";

    switch (postType) {

        case Tao800AnalysisExposurePostTypeHome: {
            ret = @"home";
        }
            break;
        case Tao800AnalysisExposurePostTypeJvTag: {
            ret = @"jutag";
        }
            break;
        case Tao800AnalysisExposurePostTypeMuYing: {
            ret = @"muyin";
        }
            break;
        case Tao800AnalysisExposurePostTypeSearch: {
            ret = @"searc";
        }
            break;
        case Tao800AnalysisExposurePostTypeBdlst: {
            ret = @"bdlst";
        }
            break;
        case Tao800AnalysisExposurePostTypeTopic: {
            ret = @"topic";
        }
            break;
        case Tao800AnalysisExposurePostTypePhone: {
            ret = @"phone";
        }
            break;
        case Tao800AnalysisExposurePostTypeToday: {
            ret = @"today";
        }
            break;
        case Tao800AnalysisExposurePostTypeYugao: {
            ret = @"yugao";
        }
            break;
        case Tao800AnalysisExposurePostTypeTen: {
            ret = @"ten";
        }
            break;
        case Tao800AnalysisExposurePostTypeMyFavorite: {
            ret = @"myfav";
        }
            break;
        case Tao800AnalysisExposurePostTypeCoupon:{
            ret = @"coupo";
        }break;
        case Tao800AnalysisExposurePostTypePromotionHome:{
            ret = @"home";
        } break;
    };

    return ret;
}

+ (NSString *)referWith:(Tao800ExposureRefer)exposureRefer {
    NSString *ret = @"scheme";
    switch (exposureRefer) {

        case Tao800ExposureReferHome: {
            ret = @"home";
        }
            break;
        case Tao800ExposureReferHomeTag: {
            ret = @"bottom";
        }
            break;
        case Tao800ExposureReferLaunchBigBanner: {
            ret = @"startup";
        }
            break;
        case Tao800ExposureReferHomePromotionGif: {
            ret = @"hang";
        }
            break;
        case Tao800ExposureReferHomeBanner: {
            ret = @"home";
        }
            break;
        case Tao800ExposureReferPush: {
            ret = @"push";
        }
            break;
        case Tao800ExposureReferTagBanner: {
            ret = @"jutag";
        }
            break;
        case Tao800ExposureReferHomeOperation: {
            ret = @"homeope";
        }
            break;
        case Tao800ExposureReferHomePromotionOperation: {
            ret = @"acthomeope";
        }
            break;
        case Tao800ExposureReferCalendar: {
            ret = @"calendar";
        };
            break;
        case Tao800ExposureReferMyCoupon:{
            ret = @"mycoupon";
        }break;
        case Tao800ExposureReferPromotionHome: {
            ret = @"home";
        }

            break;
    };
    return ret;
}

@end
