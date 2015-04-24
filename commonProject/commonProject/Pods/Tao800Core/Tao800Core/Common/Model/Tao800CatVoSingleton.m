//
//  Tao800CategoryModel.m
//  tao800
//
//  Created by worker on 12-10-29.
//  Copyright (c) 2012年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800CatVoSingleton.h"
#import "TBCore/TBCore.h"
#import "Tao800StaticConstant.h"
#import "TBCore/TBFileUtil.h"


static Tao800CatVoSingleton *_instance;

@implementation Tao800CatVoSingleton

#pragma mark ---- singleton methods -----------
+ (Tao800CatVoSingleton *)sharedInstance {
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (NSMutableArray *)getCategory
{
    if (_category && _category.count != 0 && ![_category isKindOfClass:[NSNull class]]) {
        return _category;
    }
    
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"v354category" ofType:@".txt"];
    //NSString *jsonPath = [TBFileUtil getDbFilePath:Zhe800CategoryFileName];
    
    NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:jsonPath];
    NSData *data = [fh readDataToEndOfFile];
    
    NSString *aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *categoryArr =(NSArray*) [aStr JSONValue];
    
//    NSMutableArray *result = [NSMutableArray arrayWithCapacity: [categoryArr count] + 1];
    
    // 增加全部分类
    Tao800CategoryVo *vo1 = [[Tao800CategoryVo alloc] init];
    vo1.categoryId = 0;
    vo1.categoryName = @"全部";
    vo1.urlName = @"";
    //[result addObject:vo1];
    
    //    TBBServiceZhe800CategoryVo *vo2 = [[TBBServiceZhe800CategoryVo alloc] init];
    //    vo2.categoryId = 20;
    //    vo2.categoryName = @"热门活动";
    //    vo2.urlName = @"";
    //    [result addObject:vo2];
    
//    for (NSDictionary *item in categoryArr) {
//        Tao800CategoryVo *vo = [[Tao800CategoryVo alloc] init];
//        vo.categoryId = [[item objectForKey:@"tagid"] intValue];
//        vo.categoryName = [item objectForKey:@"name"];
//        vo.urlName = [item objectForKey:@"urlname"];
//        [result addObject:vo];
//    }
    NSArray *array = @[];
    if ([categoryArr isKindOfClass:[NSArray class]]) {
        NSArray *tags = (NSArray *) categoryArr;
        array = [Tao800CategoryVo wrapperTags:tags];
    }

    //[result addObject:vo1];
    self.category = [NSMutableArray arrayWithArray:array];
    return _category;
}

-(NSString *)loadCategoryFromFile{
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"v354category" ofType:@".txt"];
    //NSString *jsonPath = [TBFileUtil getDbFilePath:Zhe800CategoryFileName];
    NSData *reader = [NSData dataWithContentsOfFile:jsonPath];
    NSString *aStr = [[NSString alloc] initWithData:reader
                                     encoding:NSUTF8StringEncoding];
    
//    NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:jsonPath];
//    NSData *data = [fh readDataToEndOfFile];
//    
//    NSString *aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return aStr;
}

// 把分类数据写入文件
- (void)setCategoryByString:(NSString *)categoryStr
{
    NSArray *arr = (NSArray*) [categoryStr JSONValue];
    if (arr == nil || arr.count == 0) {
        return;
    }
    
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"v354category" ofType:@".txt"];
    //创建数据缓冲
    NSMutableData *writer = [[NSMutableData alloc] init];
    [writer appendData:[categoryStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [writer writeToFile:jsonPath atomically:NO];
    
    //    NSData *reader = [NSData dataWithContentsOfFile:jsonPath];
    //    NSString *readStr = [[NSString alloc] initWithData:reader
    //                                 encoding:NSUTF8StringEncoding];
    //
    //    NSLog(@"%@",readStr);
    
    //self.category = [self convertJsonToCategory:arr];
}

//获取分类解析
-(NSMutableArray *)convertJsonToCategory:(NSArray *)categoryArr
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity: [categoryArr count] + 2];
    
    // 增加全部分类
    Tao800CategoryVo *vo1 = [[Tao800CategoryVo alloc] init];
    vo1.categoryId = 0;
    vo1.categoryName = @"全部";
    vo1.urlName = @"";
    [arr addObject:vo1];
    
    //    TBBServiceZhe800CategoryVo *vo2 = [[TBBServiceZhe800CategoryVo alloc] init];
    //    vo2.categoryId = 20;
    //    vo2.categoryName = @"热门活动";
    //    vo2.urlName = @"";
    //    [arr addObject:vo2];
    
    for (NSDictionary *item in categoryArr) {
        Tao800CategoryVo *vo = [[Tao800CategoryVo alloc] init];
        vo.categoryId = [[item objectForKey:@"tagid"] intValue];
        vo.categoryName = [item objectForKey:@"name"];
        vo.urlName = [item objectForKey:@"urlname"];
        
        [arr addObject:vo];
    }
    
    return arr;
}

/*
- (NSMutableArray *)getLevel1TestAry{
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:10];
    for(int i = 0; i<10; i++){
        Tao800CategoryVo *vo = [[Tao800CategoryVo alloc] init];
        vo.categoryId = i;
        vo.categoryName = [NSString stringWithFormat:@"categoryName %d",i];
        vo.urlName = [NSString stringWithFormat:@"urlName %d",i];
        vo.parentId = nil;
        if(i == 3 || i == 5){
            vo.isHaveNextLevel = YES;
        }
        SectionInfo *sectionInfo = [[SectionInfo alloc] init];
        sectionInfo.sectionData = vo;
        
        sectionInfo.open = YES;
        [sections addObject:sectionInfo];
        
    }
    return sections;
}
*/

- (NSString*)findButtonUrl:(Tao800CategoryVo*)catVo{
    NSString *urlPath = nil;
    if (!catVo.urlName) {
        catVo.imagePath = @"tao_cat_all";
    }else if([catVo.urlName isEqualToString:@"baoyou"]){
        catVo.imagePath = @"tao_cat_baoyou";//none
    }
    else if([catVo.urlName isEqualToString:@"muying"]){
        catVo.imagePath = @"tao_cat_mu";
    }else if([catVo.urlName isEqualToString:@"taofushi"]){
        catVo.imagePath = @"tao_cat_nv";
    }else if([catVo.urlName isEqualToString:@"taonanzhuang"]){
        catVo.imagePath = @"tao_cat_nan";//none
    }else if([catVo.urlName isEqualToString:@"taojujia"]){
        catVo.imagePath = @"tao_cat_jia";
    }else if([catVo.urlName isEqualToString:@"fengding"]){
        catVo.imagePath = @"tao_cat_fengding";//none
    }else if([catVo.urlName isEqualToString:@"taoxiebao"]){
        catVo.imagePath = @"tao_cat_xie";
    }else if([catVo.urlName isEqualToString:@"taopeishi"]){
        catVo.imagePath = @"tao_cat_pei";
    }else if([catVo.urlName isEqualToString:@"taomeishi"]){
        catVo.imagePath = @"tao_cat_mei";
    }else if([catVo.urlName isEqualToString:@"taodianqi"]){
        catVo.imagePath = @"tao_cat_shuma";//none
    }else if([catVo.urlName isEqualToString:@"taomeizhuang"]){
        catVo.imagePath = @"tao_cat_hua";
    }else if([catVo.urlName isEqualToString:@"taoqita"]){
        catVo.imagePath = @"tao_cat_wen";
    }else if([catVo.urlName isEqualToString:@"taocampus"]){
        catVo.imagePath = @"tao_cat_campus";
    }else if([catVo.urlName isEqualToString:@"taoold"]){
        catVo.imagePath = @"tao_cat_old";
    }else{
        catVo.imagePath = @"tao_cat_default";
    }
    urlPath = catVo.imagePath;
    return urlPath;
}

- (NSString*)fetchButtonUrl:(Tao800CategoryVo*)catVo{
    NSString *urlPath = [self findButtonUrl:catVo];
    NSString *string = [NSString stringWithFormat:@"bundle://%@_sel@2x.png",urlPath];
    return string;
}

- (NSString*)fetchButtonSelectedUrl:(Tao800CategoryVo*)catVo{
    NSString *urlPath = [self findButtonUrl:catVo];
    NSString *string = [NSString stringWithFormat:@"bundle://%@_sel@2x.png",urlPath];//_sel
    return string;
}

- (NSString*)fetchButtonHomeUrl:(Tao800CategoryVo*)catVo{
    NSString *urlPath = [self findButtonUrl:catVo];
    NSString *string = [NSString stringWithFormat:@"bundle://%@_home_v33@2x.png",urlPath];
    return string;
}

- (NSString*)getStringCategoryFromFile{
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"v5tag" ofType:@".txt"];
    NSData *reader = [NSData dataWithContentsOfFile:jsonPath];
    NSString *aStr = [[NSString alloc] initWithData:reader
                                           encoding:NSUTF8StringEncoding];
    return aStr;
}

- (NSMutableArray *)getCategoryFromFile{
    if (_categoryFromFile == nil) {
        _categoryFromFile = [NSMutableArray arrayWithCapacity:20];
    }
    return _categoryFromFile;
}

- (NSMutableArray *)getCustomCategory{
    if (_customCategory == nil) {
        _customCategory = [NSMutableArray arrayWithCapacity:20];
        //big cat
        for(int i = 0; i<13; i++){
            Tao800CategoryVo *vo = [[Tao800CategoryVo alloc] init];
            if(i == 0){
                vo.categoryId = 0;
                vo.categoryName =@"全部";
                vo.urlName = nil;
                vo.parentId = nil;
                vo.isHaveNextLevel = NO;
            }
            if (i == 1) {
                vo.categoryId = 1;
                vo.categoryName =@"9.9包邮";
                vo.urlName = @"baoyou";
                vo.parentId = nil;
                vo.isHaveNextLevel = NO;
            }
            if (i == 2) {
                vo.categoryId = 8;
                vo.categoryName =@"母婴";
                vo.urlName = @"muying";
                vo.parentId = nil;
                //vo.isHaveNextLevel = YES;
                //3.5.2母婴版本修改
                vo.isHaveNextLevel = NO;
            }
            if (i == 3) {
                vo.categoryId = 2;
                vo.categoryName =@"女装";
                vo.urlName = @"taofushi";
                vo.parentId = nil;
                //vo.isHaveNextLevel = NO;
                //v3.2.1
                vo.isHaveNextLevel = YES;
            }
            if (i == 4) {
                vo.categoryId = 11;
                vo.categoryName =@"男装";
                vo.urlName = @"taonanzhuang";
                vo.parentId = nil;
                vo.isHaveNextLevel = NO;
            }
            if (i == 5) {
                vo.categoryId = 7;
                vo.categoryName =@"居家";
                vo.urlName = @"taojujia";
                vo.parentId = nil;
                vo.isHaveNextLevel = NO;
            }
            if (i == 6) {
                vo.categoryId = 10;
                vo.categoryName =@"20元封顶";
                vo.urlName = @"fengding";
                vo.parentId = nil;
                vo.isHaveNextLevel = NO;
                
            }
            if (i == 7) {
                vo.categoryId = 4;
                vo.categoryName =@"鞋包";
                vo.urlName = @"taoxiebao";
                vo.parentId = nil;
                vo.isHaveNextLevel = NO;
            }
            if (i == 8) {
                vo.categoryId = 12;
                vo.categoryName =@"配饰";
                vo.urlName = @"taopeishi";
                vo.parentId = nil;
                vo.isHaveNextLevel = NO;
            }
            if (i == 9) {
                vo.categoryId = 6;
                vo.categoryName =@"美食";
                vo.urlName = @"taomeishi";
                vo.parentId = nil;
                vo.isHaveNextLevel = NO;
            }
            if (i == 10) {
                vo.categoryId = 5;
                vo.categoryName =@"数码家电";
                vo.urlName = @"taodianqi";
                vo.parentId = nil;
                vo.isHaveNextLevel = NO;
            }
            if (i == 11) {
                vo.categoryId = 3;
                vo.categoryName =@"化妆品";
                vo.urlName = @"taomeizhuang";
                vo.parentId = nil;
                vo.isHaveNextLevel = NO;
            }
            if (i == 12) {
                vo.categoryId = 9;
                vo.categoryName =@"文体";
                vo.urlName = @"taoqita";
                vo.parentId = nil;
                vo.isHaveNextLevel = NO;
            }
            
            [_customCategory addObject:vo];
        }
        
        //small cat
        
        for (int k = 1; k<5; k++) {
            //taofushi
            Tao800CategoryVo *vo = [[Tao800CategoryVo alloc] init];
            if(k == 1){
                vo.categoryId = 376;
                vo.categoryName = @"上衣";
                vo.urlName = @"shangyi";
                vo.parentId = @"2";
                vo.parentUrlName = @"taofushi";
            }
            if(k == 2){
                vo.categoryId = 378;
                vo.categoryName = @"裤裙";
                vo.urlName = @"kuqun";
                vo.parentId = @"2";
                vo.parentUrlName = @"taofushi";
            }
            if(k == 3){
                vo.categoryId = 380;
                vo.categoryName = @"内衣";
                vo.urlName = @"neiyi";
                vo.parentId = @"2";
                vo.parentUrlName = @"taofushi";
            }
            if(k == 4){
                vo.categoryId = 382;
                vo.categoryName = @"套装";
                vo.urlName = @"qita";
                vo.parentId = @"2";
                vo.parentUrlName = @"taofushi";
            }
            if (vo.urlName) {
                [_customCategory addObject:vo];
            }
        }
        
        for(int j = 1; j<6; j++){
            Tao800CategoryVo *vo = [[Tao800CategoryVo alloc] init];
            if(j == 1){
                vo.categoryId = 23;
                vo.categoryName = @"婴幼服饰";
                vo.urlName = @"yingyoufushi";
                vo.parentId = @"8";
                vo.parentUrlName = @"muying";
            }
            if(j == 2){
                vo.categoryId = 19;
                vo.categoryName = @"婴幼用品";
                vo.urlName = @"yingyouyongpin";
                vo.parentId = @"8";
                vo.parentUrlName = @"muying";
            }
            if(j == 3){
                vo.categoryId = 21;
                vo.categoryName = @"早教玩具";
                vo.urlName = @"zaojiaowanju";
                vo.parentId = @"8";
                vo.parentUrlName = @"muying";
            }
            if(j == 4){
                vo.categoryId = 17;
                vo.categoryName = @"婴幼食品";
                vo.urlName = @"yingyoushipin";
                vo.parentId = @"8";
                vo.parentUrlName = @"muying";
            }
            if(j == 5){
                vo.categoryId = 15;
                vo.categoryName = @"孕妈必备";
                vo.urlName = @"yunmabibei";
                vo.parentId = @"8";
                vo.parentUrlName = @"muying";
            }
            
            [_customCategory addObject:vo];
        }
        
        
    }
    return _customCategory;
}

//应该增加_netCategory 判断
-(Tao800CategoryVo *)fetchCatVoByUrlName:(NSString*)urlName{
    Tao800CategoryVo* cat = nil;
    
    [self getCustomCategory];
    for(Tao800CategoryVo *catVo in _customCategory){
        if (!urlName) {
            if (catVo.categoryId == 0 && !catVo.urlName) {
                return catVo;
            }
        }
        if (catVo.urlName && urlName && [catVo.urlName isEqualToString:urlName]) {
            return catVo;
        }
    }
    return cat;
}

-(Tao800CategoryVo*)fetchCatVoByUrlNameV2:(NSString *)urlName{
    Tao800CategoryVo* cat = nil;
    
    NSMutableArray* array = [self getCategory];
    for(Tao800CategoryVo *catVo in array){
        if (!urlName) {
            if (catVo.categoryId == 0 && !catVo.urlName) {
                return catVo;
            }
        }
        if (catVo.urlName && urlName && [catVo.urlName isEqualToString:urlName]) {
            return catVo;
        }
    }
    return cat;
}

/*
- (NSMutableArray *)getReallyLevel1{
    //[self getCustomCategory];
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:10];
    
    if(_netCategory && [_netCategory count]>0)
    {
        self.bigCat = [self fetchBigCat:_netCategory];
        for(Tao800CategoryVo* cat in _bigCat){
            if(!cat.parentUrlName){
                SectionInfo *sectionInfo = [[SectionInfo alloc] init];
                sectionInfo.sectionData = cat;
                sectionInfo.open = YES;
                [sections addObject:sectionInfo];
            }
        }
        
    }else{
        sections = [self getReallyLevel1TestAry];
    }
    
    return sections;
}
*/

/*
- (NSMutableArray *)getReallyLevel2:(TBBMenuController*)menu{
    NSMutableArray *sourceItems = [NSMutableArray arrayWithCapacity:10];
    //[self getCustomCategory];
    if(_netCategory && [_netCategory count]>0)
    {
        for(Tao800CategoryVo* cat in _bigCat){
            NSMutableArray *subItems = nil;
            if (cat.isHaveNextLevel) {
                subItems = [NSMutableArray arrayWithCapacity:10];
                
                NSMutableArray* smallArray = [self fetchSmallCat:_netCategory bigCat:cat];
                for(Tao800CategoryVo *small in smallArray){
                    Tao800FoldSectionSubListCategoryItem *cItem = [[Tao800FoldSectionSubListCategoryItem alloc] init];
                    cItem.categoryVo = small;
                    cItem.menu = menu;
                    [subItems addObject:cItem];
                }
                
            }
            else{
                
                subItems = [NSMutableArray arrayWithCapacity:10];
            }
            
            [sourceItems addObject:subItems];
        }
        
    }else{
        sourceItems = [self getReallyLevel2TestAry:menu];
    }
    return sourceItems;
}
*/
/*
- (NSMutableArray *)getReallyLevel1TestAry{
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:10];
    for(int i = 0; i<13; i++){
        Tao800CategoryVo *vo = [[Tao800CategoryVo alloc] init];
        if(i == 0){
            vo.categoryId = 0;
            vo.categoryName =@"全部";
            vo.urlName = nil;
            vo.parentId = nil;
            vo.isHaveNextLevel = NO;
        }
        if (i == 1) {
            vo.categoryId = 1;
            vo.categoryName =@"9.9包邮";
            vo.urlName = @"baoyou";
            vo.parentId = nil;
            vo.isHaveNextLevel = NO;
        }
        if (i == 2) {
            vo.categoryId = 8;
            vo.categoryName =@"母婴";
            vo.urlName = @"muying";
            vo.parentId = nil;
            //vo.isHaveNextLevel = YES;
            //3.5.2母婴版本修改
            vo.isHaveNextLevel = NO;
        }
        if (i == 3) {
            vo.categoryId = 2;
            vo.categoryName =@"女装";
            vo.urlName = @"taofushi";
            vo.parentId = nil;
            //vo.isHaveNextLevel = NO;
            //v3.2.1
            vo.isHaveNextLevel = YES;
        }
        if (i == 4) {
            vo.categoryId = 11;
            vo.categoryName =@"男装";
            vo.urlName = @"taonanzhuang";
            vo.parentId = nil;
            vo.isHaveNextLevel = NO;
        }
        if (i == 5) {
            vo.categoryId = 7;
            vo.categoryName =@"居家";
            vo.urlName = @"taojujia";
            vo.parentId = nil;
            vo.isHaveNextLevel = NO;
        }
        if (i == 6) {
            vo.categoryId = 10;
            vo.categoryName =@"20元封顶";
            vo.urlName = @"fengding";
            vo.parentId = nil;
            vo.isHaveNextLevel = NO;
            
        }
        if (i == 7) {
            vo.categoryId = 4;
            vo.categoryName =@"鞋包";
            vo.urlName = @"taoxiebao";
            vo.parentId = nil;
            vo.isHaveNextLevel = NO;
        }
        if (i == 8) {
            vo.categoryId = 12;
            vo.categoryName =@"配饰";
            vo.urlName = @"taopeishi";
            vo.parentId = nil;
            vo.isHaveNextLevel = NO;
        }
        if (i == 9) {
            vo.categoryId = 6;
            vo.categoryName =@"美食";
            vo.urlName = @"taomeishi";
            vo.parentId = nil;
            vo.isHaveNextLevel = NO;
        }
        if (i == 10) {
            vo.categoryId = 5;
            vo.categoryName =@"数码家电";
            vo.urlName = @"taodianqi";
            vo.parentId = nil;
            vo.isHaveNextLevel = NO;
        }
        if (i == 11) {
            vo.categoryId = 3;
            vo.categoryName =@"化妆品";
            vo.urlName = @"taomeizhuang";
            vo.parentId = nil;
            vo.isHaveNextLevel = NO;
        }
        if (i == 12) {
            vo.categoryId = 9;
            vo.categoryName =@"文体";
            vo.urlName = @"taoqita";
            vo.parentId = nil;
            vo.isHaveNextLevel = NO;
        }
        //        if(i == 3 || i == 5){
        //            vo.isHaveNextLevel = YES;
        //        }
        SectionInfo *sectionInfo = [[SectionInfo alloc] init];
        sectionInfo.sectionData = vo;
        
        sectionInfo.open = YES;
        [sections addObject:sectionInfo];
        
    }
    return sections;
}
*/

-(NSMutableArray*) sortCategoryArray:(NSMutableArray*)localArray remoteArray:(NSArray*)remote{
    NSMutableArray *sortArray = [[NSMutableArray alloc] init];
    if(remote!=nil && remote.count>0){
        [sortArray addObjectsFromArray:remote];
    }else{
        for(Tao800CategoryVo* localVo in localArray){
            BOOL findFlag = NO;
            for(Tao800CategoryVo* sortVo in sortArray){
                if (!localVo.parentUrlName && ![localVo.urlName isEqualToString: sortVo.urlName]) {
                    //find
                    findFlag = YES;
                    if (localVo.categoryId == 0) {
                        //findFlag = NO;
                    }
                }
            }
            if (!findFlag) {
                [sortArray addObject:localVo];
            }
        }
    }
    
    BOOL findFlag = NO;
    for(Tao800CategoryVo* sortVo in sortArray){
        if (!sortVo.urlName) {
            findFlag = YES;
        }
    }
    if (!findFlag) {
        Tao800CategoryVo *vo = [[Tao800CategoryVo alloc] init];
        vo.categoryId = 0;
        vo.categoryName =@"全部";
        vo.urlName = nil;
        vo.parentId = nil;
        vo.isHaveNextLevel = NO;
        vo.parentUrlName = nil;
        //[sortArray addObject:vo];
        [sortArray insertObject:vo atIndex:0];
    }
    return sortArray;
}

//
-(NSMutableArray*) fetchBigCat:(NSMutableArray*)holeArray{
    NSMutableArray *fetchArray = [NSMutableArray arrayWithCapacity:10];
    for(Tao800CategoryVo* remoteAndSort in holeArray){
        if(!remoteAndSort.parentUrlName){
            //计算isHaveNextLevel
            [self queryHaveNextLevel:remoteAndSort remoteAndSortMaybe:holeArray];
            [fetchArray addObject:remoteAndSort];
        }
    }
    
    return fetchArray;
}

-(NSMutableArray*) fetchSmallCat:(NSMutableArray*)holeArray bigCat:(Tao800CategoryVo*)cat{
    NSMutableArray *fetchArray = [NSMutableArray arrayWithCapacity:10];
    for(Tao800CategoryVo* remoteAndSort in holeArray){
        if (remoteAndSort.parentUrlName && cat.urlName && [cat.urlName isEqualToString:remoteAndSort.parentUrlName]) {
            [fetchArray addObject:remoteAndSort];
        }
    }
    //v3.2.1 暂时写死增加女装2级内容
    /*
     if ([cat.urlName isEqualToString:@"taofushi"]) {
         Tao800CategoryVo *vo = [[Tao800CategoryVo alloc] init];
         vo.categoryId = 230;
         vo.categoryName = @"女装测试1";
         vo.urlName = @"womantest1";
         vo.parentId = @"2";
         vo.parentUrlName = @"taofushi";
     
         vo = [[Tao800CategoryVo alloc] init];
         vo.categoryId = 190;
         vo.categoryName = @"女装测试2";
         vo.urlName = @"womantest2";
         vo.parentId = @"2";
         vo.parentUrlName = @"taofushi";
     
     }*/
    if (fetchArray && [fetchArray count]>0) {
        //Tao800CategoryVo *catvo = [fetchArray lastObject];
        Tao800CategoryVo *vo = [[Tao800CategoryVo alloc] init];
        vo.categoryId = cat.categoryId;//用大分类的id
        vo.categoryName = [NSString stringWithFormat:@"全部%@",cat.categoryName];
        vo.urlName = cat.urlName;
        vo.parentId = [NSString stringWithFormat:@"%d",cat.categoryId];
        vo.isHaveNextLevel = NO;
        vo.parentUrlName = nil;//cat.urlName;
        vo.another = [cat.categoryName mutableCopy];
        vo.remoteUrl = [cat.remoteUrl mutableCopy];
        [fetchArray insertObject:vo atIndex:0];
    }
    return fetchArray;
}


-(void)queryHaveNextLevel:(Tao800CategoryVo*)vo remoteAndSortMaybe:(NSMutableArray*)holeArray{
    for(Tao800CategoryVo* remoteAndSort in holeArray){
        if (vo.urlName && remoteAndSort.parentUrlName && [vo.urlName isEqualToString:remoteAndSort.parentUrlName]) {
            //vo.isHaveNextLevel = YES;
            //group2_014中恢复今日更新的分类,但只显示1级
            vo.isHaveNextLevel = NO;
            //3.5.2母婴版本修改
            if ([vo.urlName isEqualToString:@"muying"]) {
                vo.isHaveNextLevel = NO;
            }
        }
    }
}


/*
- (NSMutableArray *)getReallyLevel2TestAry:(TBBMenuController*)menu{
    NSMutableArray *sourceItems = [NSMutableArray arrayWithCapacity:10];
    for(int i = 0; i<13; i++){
        NSMutableArray *subItems = nil;
        
        if(i == 2){
            subItems = [NSMutableArray arrayWithCapacity:10];
            for(int j = 0; j<6; j++){
                Tao800CategoryVo *vo = [[Tao800CategoryVo alloc] init];
                if(j == 0){
                    vo.categoryId = 8;
                    vo.categoryName =@"全部母婴";
                    vo.urlName = @"muying";
                    vo.parentId = @"8";
                    vo.isHaveNextLevel = NO;
                    vo.parentUrlName = @"muying";
                    vo.another = @"母婴";
                }
                if(j == 1){
                    vo.categoryId = 23;
                    vo.categoryName = @"婴幼服饰";
                    vo.urlName = @"yingyoufushi";
                    vo.parentId = @"8";
                    vo.parentUrlName = @"muying";
                }
                if(j == 2){
                    vo.categoryId = 19;
                    vo.categoryName = @"婴幼用品";
                    vo.urlName = @"yingyouyongpin";
                    vo.parentId = @"8";
                    vo.parentUrlName = @"muying";
                }
                if(j == 3){
                    vo.categoryId = 21;
                    vo.categoryName = @"早教玩具";
                    vo.urlName = @"zaojiaowanju";
                    vo.parentId = @"8";
                    vo.parentUrlName = @"muying";
                }
                if(j == 4){
                    vo.categoryId = 17;
                    vo.categoryName = @"婴幼食品";
                    vo.urlName = @"yingyoushipin";
                    vo.parentId = @"8";
                    vo.parentUrlName = @"muying";
                }
                if(j == 5){
                    vo.categoryId = 15;
                    vo.categoryName = @"孕妈必备";
                    vo.urlName = @"yunmabibei";
                    vo.parentId = @"8";
                    vo.parentUrlName = @"muying";
                }
                Tao800FoldSectionSubListCategoryItem *cItem = [[Tao800FoldSectionSubListCategoryItem alloc] init];
                cItem.categoryVo = vo;
                cItem.menu = menu;
                [subItems addObject:cItem];
            }
        }else if(i == 3){
            subItems = [NSMutableArray arrayWithCapacity:10];
            for(int j = 0; j<5; j++){
                Tao800CategoryVo *vo = [[Tao800CategoryVo alloc] init];
                if(j == 0){
                    vo.categoryId = 2;
                    vo.categoryName =@"全部女装";
                    vo.urlName = @"taofushi";
                    vo.parentId = @"2";
                    vo.isHaveNextLevel = NO;
                    vo.parentUrlName = @"taofushi";
                    vo.another = @"女装";
                }
                if(j == 1){
                    vo.categoryId = 376;
                    vo.categoryName = @"上衣";
                    vo.urlName = @"shangyi";
                    vo.parentId = @"2";
                    vo.parentUrlName = @"taofushi";
                }
                if(j == 2){
                    vo.categoryId = 378;
                    vo.categoryName = @"裤裙";
                    vo.urlName = @"kuqun";
                    vo.parentId = @"2";
                    vo.parentUrlName = @"taofushi";
                }
                if(j == 3){
                    vo.categoryId = 380;
                    vo.categoryName = @"内衣";
                    vo.urlName = @"neiyi";
                    vo.parentId = @"2";
                    vo.parentUrlName = @"taofushi";
                }
                if (j == 4) {
                    vo.categoryId = 382;
                    vo.categoryName = @"套装";
                    vo.urlName = @"qita";
                    vo.parentId = @"2";
                    vo.parentUrlName = @"taofushi";
                }
                Tao800FoldSectionSubListCategoryItem *cItem = [[Tao800FoldSectionSubListCategoryItem alloc] init];
                cItem.categoryVo = vo;
                cItem.menu = menu;
                [subItems addObject:cItem];
            }
        }else{
            subItems = [NSMutableArray arrayWithCapacity:10];
        }
        
        [sourceItems addObject:subItems];
    }
    return sourceItems;
}
*/

/*
- (NSMutableArray *)getLevel2TestAry{
    NSMutableArray *sourceItems = [NSMutableArray arrayWithCapacity:10];
    for(int i = 0; i<10; i++){
        NSMutableArray *subItems = nil;
        
        if(i == 3 || i == 5){
            subItems = [NSMutableArray arrayWithCapacity:10];
            for(int j = 0; j<5; j++){
                Tao800CategoryVo *vo = [[Tao800CategoryVo alloc] init];
                vo.categoryId = j;
                vo.categoryName = [NSString stringWithFormat:@"categoryName %d and %d",i,j];
                vo.urlName = [NSString stringWithFormat:@"urlName %d and %d",i,j];
                vo.parentId = [NSString stringWithFormat:@"%d",i];
                
                Tao800FoldSectionSubListCategoryItem *cItem = [[Tao800FoldSectionSubListCategoryItem alloc] init];
                cItem.categoryVo = vo;
                [subItems addObject:cItem];
            }
        }else{
            subItems = [NSMutableArray arrayWithCapacity:10];
        }
        
        [sourceItems addObject:subItems];
    }
    return sourceItems;
}
*/

@end
