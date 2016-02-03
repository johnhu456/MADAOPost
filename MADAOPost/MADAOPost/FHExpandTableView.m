//
//  FHExpandTableView.m
//  FHExpandTableView
//
//  Created by MADAO on 16/1/19.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "FHExpandTableView.h"
#import "FHExpandTableViewCell.h"
#import "FHExpandNormalTableViewCell.h"

#define NUM_OF_SUBROWS @"numOfSubRows"
#define CAN_EXPAND @"canExpand"
#define DID_EXPAND @"didExpand"

typedef enum : NSUInteger {
    CellStateExpand = 0,
    CellStateUnExpand,
    CellStateFail
} CellState;
@interface FHExpandTableView()<UITableViewDelegate,UITableViewDataSource>
/**数据信息字典*/
@property (nonatomic, strong) NSMutableDictionary *indexPathInfoDic;
@end
@implementation FHExpandTableView

- (NSMutableDictionary *)indexPathInfoDic
{
    /**处理数据信息，转换成可以读取的字典格式*/
    if (_indexPathInfoDic == nil) {
        _indexPathInfoDic = [NSMutableDictionary dictionary];
        
        NSInteger numberOfSections = self.dataArray.count;
        for (NSInteger section = 0; section < numberOfSections; section++)
        {
            NSArray *rowArrayInSection = self.dataArray[section];

            NSInteger numberOfSubrows = rowArrayInSection.count ;
            /**能否展开*/
            BOOL isExpandedInitially = numberOfSubrows > 1 ? YES : NO;
            /**是否展开*/
            BOOL isExpanded = NO;
            NSMutableDictionary *rowInfo = [NSMutableDictionary dictionaryWithObjects:@[@(isExpandedInitially),@(isExpanded),@(numberOfSubrows)]
                                                                              forKeys:@[CAN_EXPAND,DID_EXPAND,NUM_OF_SUBROWS]];
            
            [_indexPathInfoDic setObject:rowInfo forKey:@(section)];
        }
    }
    return _indexPathInfoDic;
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.indexPathInfoDic allKeys].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfExpandedSubrowsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHExpandTableViewCell *collectionCell = [tableView dequeueReusableCellWithIdentifier:@"collectionCell"];
    FHExpandNormalTableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:@"normalCell"];
    if (collectionCell == nil) {
        collectionCell = [[FHExpandTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"collectionCell"];
    }
    if (normalCell == nil) {
        normalCell = [[FHExpandNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"normalCell"];
    }
    if ([self.expandDelegate respondsToSelector:@selector(descriptionForRowAtIndexPath:withObj:)]) {
        NSString *desStr = [self.expandDelegate descriptionForRowAtIndexPath:indexPath withObj:[self getDataAtIndex:indexPath]];
        collectionCell.textLabel.text = desStr;
        normalCell.textLabel.text = desStr;
    }
    else
    {
        NSString *str = [self getDataAtIndex:indexPath];
    //    NSString *title = self.dataArray[indexPath.section][indexPath.row][0];
        collectionCell.textLabel.text = [NSString stringWithFormat:@"%@",str];
    
    // Configure the cell...
    }
    if (indexPath.row == 0) {
        return collectionCell;
    }
    else
        return normalCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.expandDelegate respondsToSelector:@selector(expandTableView:didSelectRowAtIndexPath:)]) {
            [self.expandDelegate expandTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    CellState currentState = [self expendCellAtIndex:indexPath];
    switch (currentState) {
        case CellStateFail:
            return;
            break;
        case CellStateExpand:
        {
            [self beginUpdates];
            NSMutableArray *waitChange = [[NSMutableArray alloc] init];
            for (int i= 0 ; i < [self numberOfExpandedSubrowsInSection:indexPath.section]; i++) {
                if (i != 0) {
                    [waitChange addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                }
            }
            [self insertRowsAtIndexPaths:waitChange withRowAnimation:UITableViewRowAnimationAutomatic];
            [self endUpdates];
 
        }
            break;
        case CellStateUnExpand:
        {
            [self beginUpdates];
            NSMutableArray *waitChange = [[NSMutableArray alloc] init];
            for (int i= 0 ; i < [self numberOfTotalExpandedSubrowsInSection:indexPath.section]; i++) {
                if (i != 0) {
                    [waitChange addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                }
            }
            [self deleteRowsAtIndexPaths:waitChange withRowAnimation:UITableViewRowAnimationTop];
            [self endUpdates];

        }
            break;
        default:
            break;
    }
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([self.expandDelegate respondsToSelector:@selector(expandTableView:accessoryButtonTappedForRowWithIndexPath:)]) {
            [self.expandDelegate expandTableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
        }
}
/**返回Section中总行数（当前状态）*/
- (NSInteger)numberOfExpandedSubrowsInSection:(NSInteger)section
{
    NSInteger totalExpandedSubrows = 0;
    
    NSDictionary *rowInfo = self.indexPathInfoDic[@(section)];
    if ([rowInfo[DID_EXPAND] boolValue] == YES) {
         totalExpandedSubrows += [rowInfo[NUM_OF_SUBROWS] integerValue];
    }
    else
    {
        totalExpandedSubrows += 1;
    }
    return totalExpandedSubrows;
}
/**返回Section中总行数（包括展开）*/
- (NSInteger)numberOfTotalExpandedSubrowsInSection:(NSInteger)section
{
    NSInteger totalExpandedSubrows = 0;
    
    NSDictionary *rowInfo = self.indexPathInfoDic[@(section)];
    totalExpandedSubrows += [rowInfo[NUM_OF_SUBROWS] integerValue];

    return totalExpandedSubrows;
}
/**将某个Cell展开*/
- (CellState)expendCellAtIndex:(NSIndexPath *)indexPath
{
    NSMutableDictionary *subRowDic = self.indexPathInfoDic[@(indexPath.section)];
    NSLog(@"before:%@",subRowDic);

    BOOL expend = [subRowDic[DID_EXPAND] boolValue];
    BOOL canExpend = [subRowDic[CAN_EXPAND] boolValue];
    if (canExpend) {
        FHExpandTableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
        if (expend) {
            [subRowDic setValue:@(NO) forKey:DID_EXPAND];
            cell.expand = NO;
            return CellStateUnExpand;
        }
        else{
            [subRowDic setValue:@(YES) forKey:DID_EXPAND];
            cell.expand = YES;
            return CellStateExpand;
        }
    }
    return CellStateFail;
}
/**获得某行Cell信息*/
- (id)getDataAtIndex:(NSIndexPath *)indexPath
{
    id obj = self.dataArray[indexPath.section][indexPath.row];
    return obj;
}

#pragma mark - PublicMethod
- (void)updateDataWithArray:(NSArray *)array
{
    self.dataArray = array;
    /**已经展开的Section数组*/
    NSMutableArray *expendedSectionArray = [NSMutableArray new];
    for (id key in self.indexPathInfoDic.allKeys) {
        if ([key isKindOfClass:[NSNumber class]]) {
            NSDictionary *sectionInfo = self.indexPathInfoDic[key];
            if ([sectionInfo[DID_EXPAND] boolValue]) {
                //当前已经展开
                [expendedSectionArray addObject:key];
            }
        }
        else
            return;
    }
    self.indexPathInfoDic = nil;
    for (NSNumber *key in expendedSectionArray) {
        [self expendCellAtIndex:[NSIndexPath indexPathForRow:0 inSection:[key integerValue]]];
        [self reloadData];
    }
}




@end
