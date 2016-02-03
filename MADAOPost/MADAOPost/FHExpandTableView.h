//
//  FHExpandTableView.h
//  FHExpandTableView
//
//  Created by MADAO on 16/1/19.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FHExpandTableViewDelegate <NSObject>
/**选中某行*/
- (void)expandTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
/**选中某行AccessoryButton*/
- (void)expandTableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
/**某行的数据显示*/
- (NSString *)descriptionForRowAtIndexPath:(NSIndexPath *)indexPath withObj:(id)obj;
@end

@interface FHExpandTableView : UITableView

@property (nonatomic, weak) id<FHExpandTableViewDelegate> expandDelegate;
/**数据数组*/
/**标准数据格式：数组中嵌套数组，建议最小单元数组中第一个元素为合集标题,如下：
 return @[
 @[@"Section0",@"s0r0",@"s0r1",@"s0r2",@"s0r3"],
 @[@"Section1",@"s1r0",@"s1r1"],
 @[@"Section2",@"s2r0"]
 ];
 */
@property (nonatomic, strong) NSArray *dataArray;

- (void)updateDataWithArray:(NSArray *)array;
@end
