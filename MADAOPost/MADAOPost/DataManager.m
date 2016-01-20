//
//  DataManager.m
//  MADAOPost
//
//  Created by MADAO on 16/1/18.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "DataManager.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation DataManager

#pragma mark - Core Data部分

+ (instancetype)sharedDataManager
{
    static DataManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[DataManager alloc] init];
    });
    
    return _sharedManager;
}
+ (NSManagedObjectContext *)managedObjectContext
{
    return [NSManagedObjectContext MR_defaultContext];
}
- (void)loadMagicalRecord
{
    [MagicalRecord setupCoreDataStack];
}
#pragma mark - 参数值对保存
- (void)createArgumentsWithDic:(NSDictionary *)dictionary
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        Arguments *newArgument = [Arguments MR_createEntityInContext:localContext];
        newArgument.key = [DataParser stringInDictionary:dictionary forKey:@"key"];
        newArgument.value = [DataParser stringInDictionary:dictionary forKey:@"value"];
    }];
}
- (void)createSingleRequestWithDic:(NSDictionary *)dictionary
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        SingleRequest *newRequest = [SingleRequest MR_createEntityInContext:localContext];
        newRequest.baseUrl = [DataParser stringInDictionary:dictionary forKey:@"baseUrl"];
        newRequest.method = [DataParser numberInDictionary:dictionary forKey:@"method"];
        newRequest.apiUrl = [DataParser stringInDictionary:dictionary forKey:@"apiUrl"];
        newRequest.requestID = [DataParser numberInDictionary:dictionary forKey:@"requestID"];
    }];
}
#pragma mark - 数组相关
+ (NSArray *)sortedArrayBySortNSSet:(NSSet *)set withKeys:(NSArray *)keys ascending:(BOOL)ascend
{
    NSMutableArray *sortKeyArray = [NSMutableArray new];
    for (id keyStr in keys) {
        if ([keyStr isKindOfClass:[NSString class]]) {
            NSSortDescriptor *sortDes = [[NSSortDescriptor alloc] initWithKey:@"argumentID" ascending:YES];
            [sortKeyArray addObject:sortDes];
        }
    }
    NSArray *resultArray = [set sortedArrayUsingDescriptors:[sortKeyArray copy]];
    return resultArray;
}

+ (NSArray *)expendArray:(NSArray *)array withObject:(id)obj atIndex:(NSInteger)index
{
    NSMutableArray *tempArray = [array mutableCopy];
    [tempArray insertObject:obj atIndex:index];
    return [tempArray copy];
}


@end
