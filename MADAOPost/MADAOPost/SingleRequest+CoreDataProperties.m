//
//  SingleRequest+CoreDataProperties.m
//  MADAOPost
//
//  Created by MADAO on 16/1/18.
//  Copyright © 2016年 MADAO. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SingleRequest+CoreDataProperties.h"

@implementation SingleRequest (CoreDataProperties)

@dynamic baseUrl;
@dynamic method;
@dynamic apiUrl;
@dynamic requestID;
@dynamic request_collection;
@dynamic request_arguments;

@end

@implementation SingleRequest (CoreDataGeneratedAccessors)
- (void)addRequest_argumentsObject:(Arguments *)value
{
    NSMutableSet *flowDetail = [self.request_arguments mutableCopy];
    [flowDetail addObject:value];
    self.request_arguments = [flowDetail copy];
}
- (void)removeRequest_argumentsObject:(Arguments *)value;
{
    NSMutableSet *flowDetail = [self.request_arguments mutableCopy];
    [flowDetail removeObject:value];
    self.request_arguments = [flowDetail copy];
}
- (void)addRequest_arguments:(NSSet<Arguments *> *)values
{
    
}
- (void)removeRequest_arguments:(NSSet<Arguments *> *)values
{
    
}

@end