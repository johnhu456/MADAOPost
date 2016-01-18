//
//  SingleRequest+CoreDataProperties.h
//  MADAOPost
//
//  Created by MADAO on 16/1/18.
//  Copyright © 2016年 MADAO. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SingleRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SingleRequest (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *baseUrl;
@property (nullable, nonatomic, retain) NSNumber *method;
@property (nullable, nonatomic, retain) NSString *apiUrl;
@property (nullable, nonatomic, retain) NSNumber *requestID;
@property (nullable, nonatomic, retain) RequestCollection *request_collection;
@property (nullable, nonatomic, retain) NSSet<Arguments *> *request_arguments;

@end

@interface SingleRequest (CoreDataGeneratedAccessors)

- (void)addRequest_argumentsObject:(Arguments *)value;
- (void)removeRequest_argumentsObject:(Arguments *)value;
- (void)addRequest_arguments:(NSSet<Arguments *> *)values;
- (void)removeRequest_arguments:(NSSet<Arguments *> *)values;

@end

NS_ASSUME_NONNULL_END
