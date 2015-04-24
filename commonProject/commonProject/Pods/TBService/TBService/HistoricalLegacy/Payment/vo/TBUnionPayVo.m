//
// Created by enfeng on 12-11-1.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TBUnionPayVo.h"

@implementation TBUnionPayVo {


}
@synthesize submitTime = _submitTime;
@synthesize senderSignature = _senderSignature;
@synthesize merchantId = _merchantId;
@synthesize order = _order;
@synthesize merchantCountry = _merchantCountry;
@synthesize type = _type;
@synthesize merchantName = _merchantName;
@synthesize resultURL = _resultURL;
@synthesize transAmount = _transAmount;
@synthesize terminalId = _terminalId;
@synthesize orderId = _orderId;
@synthesize version = _version;
@synthesize xmlData = _xmlData;
@synthesize sysProvider = _sysProvider;
@synthesize spId = _spId;


- (NSString *)toXmlString {
    if (_xmlData) {
        return _xmlData;
    }
    
    NSMutableString *retStr = [NSMutableString stringWithCapacity:2000];
    [retStr appendString:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>"];
    [retStr appendFormat:@"<cupMobile version=\"%@\" application=\"All\">", self.version];
    [retStr appendFormat:@"<transaction type=\"%@\">", self.type];
    [retStr appendFormat:@"<submitTime>%@</submitTime>", self.submitTime];
    [retStr appendFormat:@"<order id=\"%@\">", self.orderId];
    [retStr appendString:self.order];
    [retStr appendFormat:@"</order>"];
    [retStr appendFormat:@"<transAmount>%@</transAmount>", self.transAmount];
    [retStr appendFormat:@"<terminal id=\"%@\"/>", self.terminalId];
    [retStr appendFormat:@"<merchant name=\"%@\" country=\"%@\" id=\"%@\"/>",
                    self.merchantName, self.merchantCountry, self.merchantId];
    [retStr appendFormat:@"</transaction>"];
    [retStr appendFormat:@"<senderSignature>"];
    [retStr appendString:self.senderSignature];
    [retStr appendFormat:@"</senderSignature>"];
    [retStr appendFormat:@"</cupMobile>"];

    return retStr;
}

- (void)dealloc {

 
}

@end