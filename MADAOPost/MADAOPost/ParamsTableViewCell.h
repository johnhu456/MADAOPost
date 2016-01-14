//
//  ParamsTableViewCell.h
//  MADAOPost
//
//  Created by MADAO on 16/1/13.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParamsTextField.h"

@interface ParamsTableViewCell : UITableViewCell

@property (nonatomic, strong) ParamsTextField *ptfKey;
@property (nonatomic, strong) ParamsTextField *ptfValue;

@end
