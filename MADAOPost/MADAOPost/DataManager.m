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
@end
