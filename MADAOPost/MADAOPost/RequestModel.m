//
//  RequestModel.m
//  MADAOPost
//
//  Created by MADAO on 16/1/14.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "RequestModel.h"

@implementation RequestModel
- (instancetype)init
{
    if (self = [super init]) {
        self.params = [NSMutableArray new];
    }
    return self;
}
@end
