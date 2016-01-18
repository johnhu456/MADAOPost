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

+ (instancetype)sharedDataManager;

+ (NSManagedObjectContext *)managedObjectContext;
- (void)loadMagicalRecord;
#pragma mark - 参数值对保存
/**创建并保存*/
- (void)createArgumentsWithDic:(NSDictionary *)dictionary;

- (void)createSingleRequestWithDic:(NSDictionary *)dictionary;

@end
