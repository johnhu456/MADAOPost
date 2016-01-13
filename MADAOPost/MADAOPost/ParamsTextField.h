//
//  PraramsTextField.h
//  MADAOPost
//
//  Created by MADAO on 16/1/13.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParamsTextField : UITextField
/**
 *  一个简洁的输入框，只有LeftView，下划线。
 *
 *  @param text        LeftView提示文本
 *  @param placeHolder PlaceHolder提示文本
 *
 *  @return self
 */
- (instancetype)initWithLabelText:(NSString *)text andPlaceHolder:(NSString *)placeHolder;
@end
