//
//  DataManager.h
//  MADAOPost
//
//  Created by MADAO on 16/1/18.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataParser.h"
#import "SingleRequest+CoreDataProperties.h"
#import "RequestCollection+CoreDataProperties.h"
#import "Arguments+CoreDataProperties.h"

@interface DataManager : NSObject

/**Core Data相关*/
+ (instancetype)sharedDataManager;

+ (NSManagedObjectContext *)managedObjectContext;

- (void)loadMagicalRecord;

#pragma mark - 参数值对保存
/**创建并保存*/
- (void)createArgumentsWithDic:(NSDictionary *)dictionary;

- (void)createSingleRequestWithDic:(NSDictionary *)dictionary;

/**
 *  对NSSet进行排序处理
 *
 *  @param set    要排序的NSSet对象
 *  @param key    关键字数组（string类）
 *  @param ascend 升序降序
 *
 *  @return 排序后数组
 */
+ (NSArray *)sortedArrayBySortNSSet:(NSSet *)set withKeys:(NSArray *)keys ascending:(BOOL)ascend;

/**
 *  扩展普通数组
 *
 *  @param array 要扩展数组对象
 *  @param obj   所要插入对象
 *  @param index 位置
 *
 *  @return 扩展后数组
 */
+ (NSArray *)expendArray:(NSArray *)array withObject:(id)obj atIndex:(NSInteger)index;

@end
