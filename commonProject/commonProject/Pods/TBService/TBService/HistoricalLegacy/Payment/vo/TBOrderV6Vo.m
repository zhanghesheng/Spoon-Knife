

#import "TBOrderV6Vo.h"

@implementation TBOrderV6Vo

@synthesize appointment = _appointment;
@synthesize clientMarkUsed = _clientMarkUsed;
@synthesize clientOrderStatus = _clientOrderStatus;
@synthesize clientOrderStatusDesc = _clientOrderStatusDesc;
@synthesize code = _code;
@synthesize content = _content;
@synthesize couponPrice = _couponPrice;
@synthesize createTime = _createTime;
@synthesize cue = _cue;
@synthesize daiGouType = _daiGouType;
@synthesize dealId = _dealId;
@synthesize expireTime = _expireTime;
@synthesize img = _img;
@synthesize mobile = _mobile;
@synthesize orderNo = _orderNo;
@synthesize orderProcess = _orderProcess;
@synthesize orderProcessDesc = _orderProcessDesc;
@synthesize orderStatus = _orderStatus;
@synthesize orderStatusDesc = _orderStatusDesc;
@synthesize orderStatusTime = _orderStatusTime;
@synthesize orderType = _orderType;
@synthesize passBookUrls = _passBookUrls;
@synthesize payMethod = _payMethod;
@synthesize payTime = _payTime;
@synthesize payment = _payment;
@synthesize productName = _productName;
@synthesize productNum = _productNum;
@synthesize productPackageId = _productPackageId;
@synthesize productPackageName = _productPackageName;
@synthesize productPackagePrice = _productPackagePrice;
@synthesize productPrice = _productPrice;
@synthesize readFlag = _readFlag;
@synthesize refund = _refund;
@synthesize refundDescription = _refundDescription;
@synthesize refundUrl = _refundUrl;
@synthesize shopId = _shopId;
@synthesize siteOrderNO = _siteOrderNO;
@synthesize subOrders = _subOrders;
@synthesize supplier = _supplier;
@synthesize tel = _tel;
@synthesize total = _total;
@synthesize url = _url;
@synthesize wpUrl = _wpUrl;
@synthesize lotteriesUrl = _lotteriesUrl;
@synthesize voucherType = _voucherType;
@synthesize wapCpsViewUrl = _wapCpsViewUrl;
@synthesize wapCpsPayUrl = _wapCpsPayUrl;
@synthesize couponNo = _couponNo;

@synthesize clientOrderStatusV6 = _clientOrderStatusV6;

- (TBOrderV6Status) clientOrderStatusV6 {
    return (TBOrderV6Status)self.clientOrderStatus.intValue;
}

- (TBPayMethodFlag) payMethodFlag {
    return (TBPayMethodFlag)self.payMethod.intValue;
}

- (id)init {
    self=[super init];
    if (self) {
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.appointment forKey:@"appointment"];
    [aCoder encodeObject:self.clientMarkUsed forKey:@"clientMarkUsed"];
    [aCoder encodeObject:self.clientOrderStatus forKey:@"clientOrderStatus"];
    [aCoder encodeObject:self.clientOrderStatusDesc forKey:@"clientOrderStatusDesc"];
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.couponPrice forKey:@"couponPrice"];
    [aCoder encodeObject:self.createTime forKey:@"createTime"];
    [aCoder encodeObject:self.cue forKey:@"cue"];
    [aCoder encodeObject:self.daiGouType forKey:@"daiGouType"];
    [aCoder encodeObject:self.dealId forKey:@"dealId"];
    [aCoder encodeObject:self.expireTime forKey:@"expireTime"];
    [aCoder encodeObject:self.img forKey:@"img"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.orderNo forKey:@"orderNo"];
    [aCoder encodeObject:self.orderProcess forKey:@"orderProcess"];
    [aCoder encodeObject:self.orderProcessDesc forKey:@"orderProcessDesc"];
    [aCoder encodeObject:self.orderStatus forKey:@"orderStatus"];
    [aCoder encodeObject:self.orderStatusDesc forKey:@"orderStatusDesc"];
    [aCoder encodeObject:self.orderStatusTime forKey:@"orderStatusTime"];
    [aCoder encodeObject:self.orderType forKey:@"orderType"];
    [aCoder encodeObject:self.passBookUrls forKey:@"passBookUrls"];
    [aCoder encodeObject:self.payMethod forKey:@"payMethod"];
    [aCoder encodeObject:self.payTime forKey:@"payTime"];
    [aCoder encodeObject:self.payment forKey:@"payment"];
    [aCoder encodeObject:self.productName forKey:@"productName"];
    [aCoder encodeObject:self.productNum forKey:@"productNum"];
    [aCoder encodeObject:self.productPackageId forKey:@"productPackageId"];
    [aCoder encodeObject:self.productPackageName forKey:@"productPackageName"];
    [aCoder encodeObject:self.productPackagePrice forKey:@"productPackagePrice"];
    [aCoder encodeObject:self.productPrice forKey:@"productPrice"];
    [aCoder encodeObject:self.readFlag forKey:@"readFlag"];
    [aCoder encodeObject:self.refund forKey:@"refund"];
    [aCoder encodeObject:self.refundDescription forKey:@"refundDescription"];
    [aCoder encodeObject:self.refundUrl forKey:@"refundUrl"];
    [aCoder encodeObject:self.shopId forKey:@"shopId"];
    [aCoder encodeObject:self.siteOrderNO forKey:@"siteOrderNO"];
    [aCoder encodeObject:self.subOrders forKey:@"subOrders"];
    [aCoder encodeObject:self.supplier forKey:@"supplier"];
    [aCoder encodeObject:self.tel forKey:@"tel"];
    [aCoder encodeObject:self.total forKey:@"total"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.wpUrl forKey:@"wpUrl"];
    [aCoder encodeObject:self.voucherType forKey:@"voucherType"];
    [aCoder encodeObject:self.wapCpsViewUrl forKey:@"wapCpsViewUrl"];
    [aCoder encodeObject:self.wapCpsPayUrl forKey:@"wapCpsPayUrl"];
    [aCoder encodeObject:self.couponNo forKey:@"couponNo"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self.appointment = [aDecoder decodeObjectForKey:@"appointment"];
    self.clientMarkUsed = [aDecoder decodeObjectForKey:@"clientMarkUsed"];
    self.clientOrderStatus = [aDecoder decodeObjectForKey:@"clientOrderStatus"];
    self.clientOrderStatusDesc = [aDecoder decodeObjectForKey:@"clientOrderStatusDesc"];
    self.code = [aDecoder decodeObjectForKey:@"code"];
    self.content = [aDecoder decodeObjectForKey:@"content"];
    self.couponPrice = [aDecoder decodeObjectForKey:@"couponPrice"];
    self.createTime = [aDecoder decodeObjectForKey:@"createTime"];
    self.cue = [aDecoder decodeObjectForKey:@"cue"];
    self.daiGouType = [aDecoder decodeObjectForKey:@"daiGouType"];
    self.dealId = [aDecoder decodeObjectForKey:@"dealId"];
    self.expireTime = [aDecoder decodeObjectForKey:@"expireTime"];
    self.img = [aDecoder decodeObjectForKey:@"img"];
    self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
    self.orderNo = [aDecoder decodeObjectForKey:@"orderNo"];
    self.orderProcess = [aDecoder decodeObjectForKey:@"orderProcess"];
    self.orderProcessDesc = [aDecoder decodeObjectForKey:@"orderProcessDesc"];
    self.orderStatus = [aDecoder decodeObjectForKey:@"orderStatus"];
    self.orderStatusDesc = [aDecoder decodeObjectForKey:@"orderStatusDesc"];
    self.orderStatusTime = [aDecoder decodeObjectForKey:@"orderStatusTime"];
    self.orderType = [aDecoder decodeObjectForKey:@"orderType"];
    self.passBookUrls = [aDecoder decodeObjectForKey:@"passBookUrls"];
    self.payMethod = [aDecoder decodeObjectForKey:@"payMethod"];
    self.payTime = [aDecoder decodeObjectForKey:@"payTime"];
    self.payment = [aDecoder decodeObjectForKey:@"payment"];
    self.productName = [aDecoder decodeObjectForKey:@"productName"];
    self.productNum = [aDecoder decodeObjectForKey:@"productNum"];
    self.productPackageId = [aDecoder decodeObjectForKey:@"productPackageId"];
    self.productPackageName = [aDecoder decodeObjectForKey:@"productPackageName"];
    self.productPackagePrice = [aDecoder decodeObjectForKey:@"productPackagePrice"];
    self.productPrice = [aDecoder decodeObjectForKey:@"productPrice"];
    self.readFlag = [aDecoder decodeObjectForKey:@"readFlag"];
    self.refund = [aDecoder decodeObjectForKey:@"refund"];
    self.refundDescription = [aDecoder decodeObjectForKey:@"refundDescription"];
    self.refundUrl = [aDecoder decodeObjectForKey:@"refundUrl"];
    self.shopId = [aDecoder decodeObjectForKey:@"shopId"];
    self.siteOrderNO = [aDecoder decodeObjectForKey:@"siteOrderNO"];
    self.subOrders = [aDecoder decodeObjectForKey:@"subOrders"];
    self.supplier = [aDecoder decodeObjectForKey:@"supplier"];
    self.tel = [aDecoder decodeObjectForKey:@"tel"];
    self.total = [aDecoder decodeObjectForKey:@"total"];
    self.url = [aDecoder decodeObjectForKey:@"url"];
    self.wpUrl = [aDecoder decodeObjectForKey:@"wpUrl"];
    self.lotteriesUrl = [aDecoder decodeObjectForKey:@"lotteriesUrl"];
    self.voucherType = [aDecoder decodeObjectForKey:@"voucherType"];
    self.wapCpsViewUrl = [aDecoder decodeObjectForKey:@"wapCpsViewUrl"];
    self.wapCpsPayUrl = [aDecoder decodeObjectForKey:@"wapCpsPayUrl"];
    self.couponNo = [aDecoder decodeObjectForKey:@"couponNo"];

    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    TBOrderV6Vo *beanCopy = [[[self class] allocWithZone:zone] init];
    beanCopy.appointment = [self.appointment copyWithZone:zone];
    beanCopy.clientMarkUsed = [self.clientMarkUsed copyWithZone:zone];
    beanCopy.clientOrderStatus = [self.clientOrderStatus copyWithZone:zone];
    beanCopy.clientOrderStatusDesc = [self.clientOrderStatusDesc copyWithZone:zone];
    beanCopy.code = [self.code copyWithZone:zone];
    beanCopy.content = [self.content copyWithZone:zone];
    beanCopy.couponPrice = [self.couponPrice copyWithZone:zone];
    beanCopy.createTime = [self.createTime copyWithZone:zone];
    beanCopy.cue = [self.cue copyWithZone:zone];
    beanCopy.daiGouType = [self.daiGouType copyWithZone:zone];
    beanCopy.dealId = [self.dealId copyWithZone:zone];
    beanCopy.expireTime = [self.expireTime copyWithZone:zone];
    beanCopy.img = [self.img copyWithZone:zone];
    beanCopy.mobile = [self.mobile copyWithZone:zone];
    beanCopy.orderNo = [self.orderNo copyWithZone:zone];
    beanCopy.orderProcess = [self.orderProcess copyWithZone:zone];
    beanCopy.orderProcessDesc = [self.orderProcessDesc copyWithZone:zone];
    beanCopy.orderStatus = [self.orderStatus copyWithZone:zone];
    beanCopy.orderStatusDesc = [self.orderStatusDesc copyWithZone:zone];
    beanCopy.orderStatusTime = [self.orderStatusTime copyWithZone:zone];
    beanCopy.orderType = [self.orderType copyWithZone:zone];
    beanCopy.passBookUrls = [self.passBookUrls copyWithZone:zone];
    beanCopy.payMethod = [self.payMethod copyWithZone:zone];
    beanCopy.payTime = [self.payTime copyWithZone:zone];
    beanCopy.payment = [self.payment copyWithZone:zone];
    beanCopy.productName = [self.productName copyWithZone:zone];
    beanCopy.productNum = [self.productNum copyWithZone:zone];
    beanCopy.productPackageId = [self.productPackageId copyWithZone:zone];
    beanCopy.productPackageName = [self.productPackageName copyWithZone:zone];
    beanCopy.productPackagePrice = [self.productPackagePrice copyWithZone:zone];
    beanCopy.productPrice = [self.productPrice copyWithZone:zone];
    beanCopy.readFlag = [self.readFlag copyWithZone:zone];
    beanCopy.refund = [self.refund copyWithZone:zone];
    beanCopy.refundDescription = [self.refundDescription copyWithZone:zone];
    beanCopy.refundUrl = [self.refundUrl copyWithZone:zone];
    beanCopy.shopId = [self.shopId copyWithZone:zone];
    beanCopy.siteOrderNO = [self.siteOrderNO copyWithZone:zone];
    beanCopy.subOrders = [self.subOrders copyWithZone:zone];
    beanCopy.supplier = [self.supplier copyWithZone:zone];
    beanCopy.tel = [self.tel copyWithZone:zone];
    beanCopy.total = [self.total copyWithZone:zone];
    beanCopy.url = [self.url copyWithZone:zone];
    beanCopy.wpUrl = [self.wpUrl copyWithZone:zone];
    beanCopy.lotteriesUrl = [self.lotteriesUrl copyWithZone:zone];
    beanCopy.voucherType = [self.voucherType copyWithZone:zone];
    beanCopy.wapCpsViewUrl = [self.wapCpsViewUrl copyWithZone:zone];
    beanCopy.wapCpsPayUrl = [self.wapCpsPayUrl copyWithZone:zone];
    beanCopy.couponNo = [self.couponNo copyWithZone:zone];

    return beanCopy;
}

 

-(void) dealloc {
    
}
 

@end