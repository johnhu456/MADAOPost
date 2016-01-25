//
//  FHTextView.h
//  Shire
//
//  Created by MADAO on 15/11/18.
//  Copyright © 2015年 LLJZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    FHTextKeyboardTypeDefault = 0,
    FHTextKeyboardTypePassword,
    FHTextKeyboardTypeNumOnly,
} FHTextKeyboardType;

@protocol FHTextViewDelegate <NSObject>
@optional
- (void)buttonCustomeOnClicked:(UIButton *)button;
/**输入框正在输入*/
- (void)textFieldEditing:(UITextField *)textField;

@end

@interface FHTextView : UIView

/**代理*/
@property (nonatomic, strong) id<FHTextViewDelegate> delegate;
/**标签Label*/
@property (nonatomic, strong, nonnull) UILabel *lblTip;
/**输入框*/
@property (nonatomic, strong, nonnull) UITextField *textField;
/**自定义按钮*/
@property (nonatomic, strong, nullable) UIButton *btnCustom;
/**
 *  框式输入框，如下：
 *    --------------------------
 *   |左标签 |   输入区域   | 按钮 |
 *    --------------------------
 *
 *  @param tip         左标签标题
 *  @param placeholder 输入框placeholder
 *  @param title       按钮标题（不需要按钮则为nil）
 *
 *  @return 
 */
- (instancetype)initWithRectTypeTip:(NSString *)tip
                        placeholder:(NSString *)placeholder
                        buttonTitle:(NSString *)title
                             height:(CGFloat)height
                               type:(FHTextKeyboardType)type;
/**
 *  线式输入框，如下：
 *  标签 ____________________
 *
 *  @param tip         标签标题
 *  @param placeholder placeholder
 *  @param color       下划线颜色
 *
 *  @return 
 */
- (instancetype)initWithLineTypeTip:(NSString *)tip
                        placeHolder:(NSString *)placeholder
                          lineColor:(UIColor *)color
                               size:(CGSize)size
                               type:(FHTextKeyboardType)type;

NS_ASSUME_NONNULL_END
@end