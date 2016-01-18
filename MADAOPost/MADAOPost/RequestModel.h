//
//  RequestModel.h
//  MADAOPost
//
//  Created by MADAO on 16/1/14.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestModel : NSObject
/**base URL*/
@property (nonatomic, strong) NSString* baseUrl;
/**aip URL*/
@property (nonatomic, strong) NSString* apiUrl;
/**参数字典的数组*/
@property (nonatomic, strong) NSMutableArray *params;
/**方法*/
@property (nonatomic, assign) BOOL isPost;
@end
