//
//  FHExpandTableView.m
//  FHExpandTableView
//
//  Created by MADAO on 16/1/19.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "FHExpandTableView.h"
#import "FHExpandTableViewCell.h"

#define NUM_OF_SUBROWS @"numOfSubRows"
#define CAN_EXPAND @"canExpand"
#define DID_EXPAND @"didExpand"

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
            /**是否已经展开*/
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
    FHExpandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (cell == nil) {
        cell = [[FHExpandTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuse"];
    }
    if ([self.expandDelegate respondsToSelector:@selector(descriptionForRowAtIndexPath:withObj:)]) {
        NSString *desStr = [self.expandDelegate descriptionForRowAtIndexPath:indexPath withObj:[self getDataAtIndex:indexPath]];
        cell.textLabel.text = desStr;
    }
    else
    {
        NSString *str = [self getDataAtIndex:indexPath];
    //    NSString *title = self.dataArray[indexPath.section][indexPath.row][0];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",str];
    
    // Configure the cell...
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)  //除第一个Cell之外不能进行展开动作
    {
        if ([self.expandDelegate respondsToSelector:@selector(expandTableView:didSelectRowAtIndexPath:)]) {
            [self.expandDelegate expandTableView:tableView didSelectRowAtIndexPath:indexPath];
        }
        if ([self expendCellAtIndex:indexPath]) {
            [self reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else
    {
        
    }
}
/**返回Section中总行数（包括展开）*/
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
/**将某个Cell展开*/
- (BOOL)expendCellAtIndex:(NSIndexPath *)indexPath
{
    NSMutableDictionary *subRowDic = self.indexPathInfoDic[@(indexPath.section)];
    BOOL expend = [subRowDic[DID_EXPAND] boolValue];
    BOOL canExpend = [subRowDic[CAN_EXPAND] boolValue];
    if (canExpend) {
        NSLog(@"expend:%@",expend ? @"1":@"0");
        if (expend) {
            [subRowDic setValue:@(NO) forKey:DID_EXPAND];
        }
        else{
            [subRowDic setValue:@(YES) forKey:DID_EXPAND];
        }
        NSLog(@"%@",subRowDic);
        return YES;
    }
    return NO;
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
//- (NSInteger)numberOfSubRowsInIndex:(NSIndexPath *)indexPath
//{
//    NSInteger numOfSubRows = 0;
//    NSArray *rows = self.sectionInfoDic[@(indexPath.section)];
//    NSDictionary *row = rows[indexPath.row];
//    numOfSubRows = [row[NUM_OF_SUBROWS] integerValue];
//    return numOfSubRows;
//}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



@end
