//
//  RequestCollection+CoreDataProperties.h
//  MADAOPost
//
//  Created by MADAO on 16/1/18.
//  Copyright © 2016年 MADAO. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RequestCollection.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestCollection (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *collectionName;
@property (nullable, nonatomic, retain) NSString *collectionBaseUrl;
@property (nullable, nonatomic, retain) NSNumber *collectionID;
@property (nullable, nonatomic, retain) NSSet<SingleRequest *> *collection_requests;

@end

@interface RequestCollection (CoreDataGeneratedAccessors)

- (void)addCollection_requestsObject:(SingleRequest *)value;
- (void)removeCollection_requestsObject:(SingleRequest *)value;
- (void)addCollection_requests:(NSSet<SingleRequest *> *)values;
- (void)removeCollection_requests:(NSSet<SingleRequest *> *)values;

@end

NS_ASSUME_NONNULL_END
