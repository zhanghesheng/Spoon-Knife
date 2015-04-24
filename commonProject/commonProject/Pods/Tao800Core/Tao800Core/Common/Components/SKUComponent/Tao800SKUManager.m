//
//  Tao800SKUManager.m
//  tao800
//
//  Created by hanyuan on 14-5-5.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800SKUManager.h"
#import "Tao800SKUPropertyVo.h"
#import "Tao800SKUCombinationVo.h"

@interface Tao800SKUManager()
//[[Tao800SKUPropertyVo1, Tao800SKUPropertyVo2...],[Tao800SKUPropertyVo1, Tao800SKUPropertyVo2...], ...]
@property(nonatomic, strong)NSMutableArray *dimesionList;

//[{relation:[vId1(in dimension1),vId2(in dimension2)...], sigleProperty:[Tao800SKUPropertyVo1(in dimension1),Tao800SKUPropertyVo2(in dimension2)...], property:Tao800SKUCombinationVo}, {}, ...]
@property(nonatomic, strong)NSMutableArray *relationList;

//relationList的子集，根据所选的属性筛选出来的可能组合
@property(nonatomic, strong)NSMutableArray *availableRelationList;

//relationList的子集，选中sku的唯一组合
@property(nonatomic, strong)NSMutableArray *selectedRelationList;

//[{dimension:0, vId:1001}, {dimension:1, vId:2001}, ...]
//由于用户选择维度的顺序是不定的，所以数组元素不一定是按dimension1，2，3排序
@property(nonatomic, strong)NSMutableArray *selectedPropertyList;
@end

@implementation Tao800SKUManager

-(id)init{
    self = [super init];
    if(self){
        _dimesionList = [[NSMutableArray alloc] init];
        _relationList = [[NSMutableArray alloc] init];
        _availableRelationList = [[NSMutableArray alloc] init];
        _selectedRelationList = [[NSMutableArray alloc] init];
        _selectedPropertyList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id)initWithSKUInfo:(NSDictionary *)info{
    self = [super init];
    if(self){
        _dimesionList = [[NSMutableArray alloc] init];
        _relationList = [[NSMutableArray alloc] init];
        _availableRelationList = [[NSMutableArray alloc] init];
        _selectedRelationList = [[NSMutableArray alloc] init];
        _selectedPropertyList = [[NSMutableArray alloc] init];
        
        [self updateSKUInfo:info];
    }
    return self;
}

-(void)updateSKUInfo:(NSDictionary *)info{
    if(info == nil || info.count==0){
        return;
    }
    //清空原有数据
    for(NSMutableArray *oneDimension in self.dimesionList){
        [oneDimension removeAllObjects];
    }
    [self.relationList removeAllObjects];
    [self.availableRelationList removeAllObjects];
    [self.selectedPropertyList removeAllObjects];
    
    //解析sku数据
    NSArray *SKUKeys = [info allKeys];
    for(NSString *oneKey in SKUKeys){
        NSDictionary *oneCombination = [info objectForKey:oneKey];
        NSDictionary *pro1 = [oneCombination objectForKey:@"prop_1"];
        Tao800SKUPropertyVo *proVo1 = [[Tao800SKUPropertyVo alloc] init];
        //解析第一个维度
        if(pro1 != nil){
            proVo1.vId = [pro1 objectForKey:@"vId"];
            proVo1.pId = [pro1 objectForKey:@"pId"];
            proVo1.pName = [pro1 objectForKey:@"pName"];
            proVo1.vName = [pro1 objectForKey:@"vName"];
            
            NSMutableArray *dimension1 = nil;
            if(self.dimesionList.count <= 0){
                dimension1 = [[NSMutableArray alloc] init];
                [self.dimesionList addObject:dimension1];
            }else{
                dimension1 = [self.dimesionList objectAtIndex:0];
            }
            if(proVo1.pId!=nil && proVo1.pId.length>0 && proVo1.vId!=nil && proVo1.vId.length>0){
                //按vId从小到大排序，去除重复项
                int index = 0;
                for(Tao800SKUPropertyVo *oneProVo in dimension1){
                    if([proVo1.vId compare:oneProVo.vId] == NSOrderedAscending){
                        proVo1.selectState = SKUSelectedState_Unavailable;
                        [dimension1 insertObject:proVo1 atIndex:index];
                        break;
                    }else if([proVo1.vId compare:oneProVo.vId] == NSOrderedSame){
                        proVo1 = oneProVo;
                        break;
                    }
                    ++index;
                }
                if(index == dimension1.count){
                    proVo1.selectState = SKUSelectedState_Unavailable;
                    [dimension1 addObject:proVo1];
                }
            }else{
                proVo1 = nil;
            }
        }
        
        //解析第二个维度
        NSArray *pro2s = [oneCombination objectForKey:@"prop_2"];
        if(pro2s!=nil && pro2s.count>0){
            for(NSDictionary *pro2 in pro2s){
                Tao800SKUPropertyVo *proVo2 = [[Tao800SKUPropertyVo alloc] init];
                proVo2.vId = [pro2 objectForKey:@"vId"];
                proVo2.pId = [pro2 objectForKey:@"pId"];
                proVo2.pName = [pro2 objectForKey:@"pName"];
                proVo2.vName = [pro2 objectForKey:@"vName"];
                
                NSMutableArray *dimension2 = nil;
                if(self.dimesionList.count <= 1){
                    dimension2 = [[NSMutableArray alloc] init];
                    [self.dimesionList addObject:dimension2];
                }else{
                    dimension2 = [self.dimesionList objectAtIndex:1];
                }
                if(proVo2.pId!=nil && proVo2.pId.length>0 && proVo2.vId!=nil && proVo2.vId.length>0){
                    //按vId从小到大排序，去除重复项
                    int index = 0;
                    for(Tao800SKUPropertyVo *oneProVo in dimension2){
                        if([proVo2.vId compare:oneProVo.vId] == NSOrderedAscending){
                            proVo2.selectState = SKUSelectedState_Unavailable;
                            [dimension2 insertObject:proVo2 atIndex:index];
                            break;
                        }else if([proVo2.vId compare:oneProVo.vId] == NSOrderedSame){
                            proVo2 = oneProVo;
                            break;
                        }
                        ++index;
                    }
                    if(index == dimension2.count){
                        proVo2.selectState = SKUSelectedState_Unavailable;
                        [dimension2 addObject:proVo2];
                    }
                }else{
                    proVo2 = nil;
                }
                
                //建立对应关系
                if(proVo1!=nil || proVo2!=nil){
                    NSDictionary *combinProperty = [pro2 objectForKey:@"property"];
                    Tao800SKUCombinationVo *combine = [[Tao800SKUCombinationVo alloc] init];
                    combine.availableCount = [[combinProperty objectForKey:@"activeProductCount"] intValue];
                    combine.curPrice = [NSString stringWithFormat:@"%@", [combinProperty objectForKey:@"curPrice"]];
                    combine.orgPrice = [NSString stringWithFormat:@"%@", [combinProperty objectForKey:@"orgPrice"]];
                    
                    if(combine.availableCount > 0){
                        NSMutableArray *relations = [[NSMutableArray alloc] init];
                        NSMutableArray *sigleProperty = [[NSMutableArray alloc] init];
                        if(proVo1 != nil){
                            proVo1.selectState = SKUSelectedState_Available;
                            [relations addObject:proVo1.vId];
                            [sigleProperty addObject:proVo1];
                        }
                        if(proVo2){
                            proVo2.selectState = SKUSelectedState_Available;
                            [relations addObject:proVo2.vId];
                            [sigleProperty addObject:proVo2];
                        }
                        NSDictionary *element = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 combine, @"property",
                                                 relations, @"relation",
                                                 sigleProperty, @"sigleProperty",
                                                 nil];
                        [self.relationList addObject:element];
                    }
                }
            }
        }
    }
    NSArray *d1 = [self.dimesionList objectAtIndex:0];
    NSArray *d2 = [self.dimesionList objectAtIndex:1];
    if(d1.count < 1){
        [self.dimesionList removeObjectAtIndex:0];
    }
    if(d2.count < 1){
        [self.dimesionList removeObjectAtIndex:1];
    }
}

-(NSArray *)queryPropertyList:(int)dimensionIndex{
    if(dimensionIndex < 0){
        return nil;
    }
    if(self.dimesionList!=nil && self.dimesionList.count>dimensionIndex){
        NSArray *oneDimension = [self.dimesionList objectAtIndex:dimensionIndex];
        return oneDimension;
    }
    return nil;
}

-(NSArray *)querySKUCombinationList{
    return self.selectedRelationList;
}

-(int)queryDimensionCount{
    int count = 0;
    if(self.dimesionList!=nil && self.dimesionList.count>0){
        count = (int)(self.dimesionList.count);
    }
    return count;
}

-(NSArray *)querySelectedPropertyList{
    return self.selectedPropertyList;
}

-(void)updatePropertySelectState:(int)dimensionIndex propertyId:(NSString *)propertyId{
    //更新选择的属性列表
    int indexToDel = -1;
    int index = 0;
    for(NSMutableDictionary *selectedNode in self.selectedPropertyList){
        NSNumber *dimension = [selectedNode objectForKey:@"dimension"];
        NSString *vId = [selectedNode objectForKey:@"vId"];
        if([dimension intValue] == dimensionIndex){
            if([propertyId isEqualToString:vId]){
                indexToDel = index;
            }else{
                [selectedNode setObject:propertyId forKey:@"vId"];
            }
            break;
        }
        ++index;
    }
    if(index == self.selectedPropertyList.count){ //此维度属性没有被选择过
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:dimensionIndex], @"dimension",
                              propertyId, @"vId",
                              nil];
        [self.selectedPropertyList addObject:dict];
    }else{ //此维度属性被选择过
        if(indexToDel != -1){ //两次选择同一属性，则取消选择
            [self.selectedPropertyList removeObjectAtIndex:indexToDel];
        }else{ //选择了同一维度的不同属性，则替换原属性
            //什么都不做
        }
    }
    
    //根据被选择的属性列表，选出唯一的关系列表
    [self.selectedRelationList removeAllObjects];
    for(NSDictionary *element in self.relationList){
        NSArray *relations = [element objectForKey:@"relation"];
        int findCount = 0;
        for(NSDictionary *selectedNode in self.selectedPropertyList){
            int selectedDimension = [[selectedNode objectForKey:@"dimension"] intValue];
            NSString *selectedVId = [selectedNode objectForKey:@"vId"];
            NSString *vId = [relations objectAtIndex:selectedDimension];
            if([selectedVId isEqualToString:vId]){
                ++findCount;
            }
        }
        if(findCount == self.selectedPropertyList.count){
            [self.selectedRelationList addObject:element];
        }
    }
    
    //根据被选择的属性列表，选出有效的关系列表
    [self.availableRelationList removeAllObjects];
    self.availableRelationList = [NSMutableArray arrayWithArray:self.relationList];
    NSMutableArray *tmpAvailableList = [[NSMutableArray alloc] init];
    NSMutableArray *tmpList = [[NSMutableArray alloc] init];
    
    for(NSDictionary *selectedNode in self.selectedPropertyList){
        int selectedDimension = [[selectedNode objectForKey:@"dimension"] intValue];
        NSString *selectedVId = [selectedNode objectForKey:@"vId"];
        //找到包含selectedNode的有效关系
        for(NSDictionary *element in self.availableRelationList){
            NSArray *relations = [element objectForKey:@"relation"];
            NSString *vId = [relations objectAtIndex:selectedDimension];
            if([selectedVId isEqualToString:vId]){
                [tmpAvailableList addObject:element];
            }
        }
        //追加虽然不包含selectedNode，但是包含与selectedNode同一维度属性的有效关系
        for(NSDictionary *elementU in self.availableRelationList){
            NSArray *relationsU = [elementU objectForKey:@"relation"];
            for(NSDictionary *elementA in tmpAvailableList){
                NSArray *relationsA = [elementA objectForKey:@"relation"];
                BOOL shouldAdd = YES;
                for(int i=0; i<relationsA.count; ++i){
                    if(i != selectedDimension){
                        NSString *vidU = [relationsU objectAtIndex:i];
                        NSString *vidA = [relationsA objectAtIndex:i];
                        if(![vidU isEqualToString:vidA]){
                            shouldAdd = NO;
                        }
                    }
                }
                if(shouldAdd){
                    [tmpList addObject:elementU];
                }
            }
        }
        [tmpAvailableList addObjectsFromArray:tmpList];
        [tmpList removeAllObjects];
        self.availableRelationList = [NSMutableArray arrayWithArray:tmpAvailableList];
        [tmpAvailableList removeAllObjects];
    }
    
    //重置状态
    for(int i=0; i<self.dimesionList.count; ++i){
        NSMutableArray *oneDimension = [self.dimesionList objectAtIndex:i];
        for(int j=0; j<oneDimension.count; ++j){
            Tao800SKUPropertyVo *pVo = [oneDimension objectAtIndex:j];
            BOOL defaultAvailable = NO;
            for(NSDictionary *element in self.relationList){
                NSArray *relations = [element objectForKey:@"relation"];
                NSString *vId = [relations objectAtIndex:i];
                if([vId isEqualToString:pVo.vId]){
                    pVo.selectState = SKUSelectedState_Available;
                    defaultAvailable = YES;
                    break;
                }
            }
            if(!defaultAvailable){
                pVo.selectState = SKUSelectedState_Unavailable;
            }
        }
    }
    
    //根据被选属性列表合有效关系列表，更新属性的选择状态
    for(NSDictionary *selectedNode in self.selectedPropertyList){
        int selectedDimension = [[selectedNode objectForKey:@"dimension"] intValue];
        NSString *selectedVId = [selectedNode objectForKey:@"vId"];
        BOOL isDimensionSelected = NO;
        
        for(int i=0; i<self.dimesionList.count; ++i){
            if(selectedDimension == i){
                isDimensionSelected = YES;
            }else{
                isDimensionSelected = NO;
            }
            NSMutableArray *oneDimension = [self.dimesionList objectAtIndex:i];
            for(int j=0; j<oneDimension.count; ++j){
                Tao800SKUPropertyVo *pVo = [oneDimension objectAtIndex:j];
                
                if(isDimensionSelected){
                    //判断是否被选中
                    if([selectedVId isEqualToString:pVo.vId]){
                        pVo.selectState = SKUSelectedState_Selected;
                    }
                }else{
                    //判断是否可选
                    BOOL isAvailable = NO;
                    for(NSDictionary *element in self.availableRelationList){
                        NSArray *relations = [element objectForKey:@"relation"];
                        NSString *vId = [relations objectAtIndex:i];
                        if(pVo.selectState == SKUSelectedState_Selected){
                            isAvailable = YES;
                        }else{
                            if([vId isEqualToString:pVo.vId]){
                                pVo.selectState = SKUSelectedState_Available;
                                isAvailable = YES;
                                break;
                            }
                        }
                    }
                    if(!isAvailable){
                        pVo.selectState = SKUSelectedState_Unavailable;
                    }
                }
            }
        }
    }
}

@end
