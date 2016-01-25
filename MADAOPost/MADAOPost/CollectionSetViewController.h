//
//  CollectionSetViewController.h
//  MADAOPost
//
//  Created by MADAO on 16/1/20.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestCollection.h"

//针对返回做的跳转回调
@protocol CollectionSetVCDelegate <NSObject>

- (void)mainVCNeedReload:(BOOL)reload;

@end

@interface CollectionSetViewController : UIViewController
/**Collection*/
@property (nonatomic, strong) RequestCollection *collection;

@property (nonatomic, weak) id<CollectionSetVCDelegate>delegate;
@end
