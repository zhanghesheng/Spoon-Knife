//
// Created by enfeng on 12-8-6.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TBPaymentParamResultVo.h"


@implementation TBPaymentParamResultVo {

}

@synthesize partner = _partner;
@synthesize sellerid = _sellerid;
@synthesize outTradeNo = _outTradeNo;
@synthesize subject = _subject;
@synthesize body = _body;
@synthesize totalFee = _totalFee;
@synthesize notifyUrl = _notifyUrl;
@synthesize sign = _sign;
@synthesize signType = _signType;
@synthesize seller = _seller;
@synthesize pubKey = _pubKey;

@synthesize tokenId = _tokenId;
@synthesize bargainorId = _bargainorId;

@synthesize md5Key = _md5Key;
@synthesize callBackUrl = _callBackUrl;
@synthesize sellerAccountName = _sellerAccountName;

- (NSString *)encodeString:(NSString *)str {
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
            NULL,
            (CFStringRef) str,
            NULL,
            (CFStringRef) @"!*'\"();:@&=+$,/?%#[]% ",
            kCFStringEncodingUTF8));
}

- (NSString *)alixStr {

    NSString *psign = [_sign stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    psign = [self encodeString:psign];
    NSMutableString *oStr = [NSMutableString stringWithFormat:@"partner=\"%@\"", _partner];
    [oStr appendString:@"&"];
    [oStr appendFormat:@"seller=\"%@\"", _seller];
    [oStr appendString:@"&"];

    [oStr appendFormat:@"out_trade_no=\"%@\"", _outTradeNo];
    [oStr appendString:@"&"];

    [oStr appendFormat:@"subject=\"%@\"", _subject];
    [oStr appendString:@"&"];

    [oStr appendFormat:@"body=\"%@\"", _body];
    [oStr appendString:@"&"];

    [oStr appendFormat:@"total_fee=\"%@\"", _totalFee];
    [oStr appendString:@"&"];

    [oStr appendFormat:@"notify_url=\"%@\"", _notifyUrl];
    [oStr appendString:@"&"];

    [oStr appendFormat:@"sign=\"%@\"", psign];
    [oStr appendString:@"&"];

    [oStr appendFormat:@"sign_type=\"%@\"", _signType];
    //NSLog(@"ostr----->%@",oStr);
    return oStr;
}

-(NSURL *)tenPayWapUrl{
    NSString *tenPayUrl = @"https://wap.tenpay.com/cgi-bin/wappayv2.0/wappay_gate.cgi?token_id=";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",tenPayUrl,_tokenId]];
    return url;
}
- (void)dealloc {
 
}

@end