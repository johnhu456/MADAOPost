//
//  DetailRequestViewController.h
//  MADAOPost
//
//  Created by MADAO on 16/1/13.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleRequest+CoreDataProperties.h"
//针对返回做的跳转回调
@protocol DetailRequestVCDelegate <NSObject>

- (void)collectionVCNeedReload:(BOOL)reload;
- (void)mainVCNeedReload:(BOOL)reload;
@end

@interface DetailRequestViewController : UIViewController
@property (nonatomic, weak) id<DetailRequestVCDelegate>delegate;
@property (nonatomic, strong) SingleRequest *request;
@end
