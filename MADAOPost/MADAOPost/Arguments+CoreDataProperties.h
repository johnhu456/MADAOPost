//
//  Arguments+CoreDataProperties.h
//  MADAOPost
//
//  Created by MADAO on 16/1/18.
//  Copyright © 2016年 MADAO. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Arguments.h"

NS_ASSUME_NONNULL_BEGIN

@interface Arguments (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *key;
@property (nullable, nonatomic, retain) NSString *value;
@property (nullable, nonatomic, retain) NSNumber *argumentID;
@property (nullable, nonatomic, retain) SingleRequest *argument_request;

@end

NS_ASSUME_NONNULL_END
