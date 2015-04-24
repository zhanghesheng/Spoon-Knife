//
// Created by enfeng on 12-11-1.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface TBUnionPayVo : NSObject   {
    NSString *_senderSignature;
    NSString *_merchantId;
    NSString *_order;
    NSString *_merchantCountry;
    NSString *_type;
    NSString *_merchantName;
    NSString *_resultURL;
    NSString *_submitTime;
    NSString *_transAmount;
    NSString *_terminalId;
    NSString *_orderId;
    NSString *_version;
    
    NSString *_xmlData;
    NSString *_sysProvider;
    NSString *_spId;
}
@property(nonatomic, copy) NSString *submitTime;
@property(nonatomic, copy) NSString *senderSignature;
@property(nonatomic, copy) NSString *merchantId;
@property(nonatomic, copy) NSString *order;
@property(nonatomic, copy) NSString *merchantCountry;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *merchantName;
@property(nonatomic, copy) NSString *resultURL;
@property(nonatomic, copy) NSString *transAmount;
@property(nonatomic, copy) NSString *terminalId;
@property(nonatomic, copy) NSString *orderId;
@property(nonatomic, copy) NSString *version;
@property(nonatomic, copy) NSString *xmlData;
@property(nonatomic, copy) NSString *sysProvider;
@property(nonatomic, copy) NSString *spId;


- (NSString *) toXmlString;

@end