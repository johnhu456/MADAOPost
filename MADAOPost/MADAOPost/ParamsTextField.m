//
//  PraramsTextField.m
//  MADAOPost
//
//  Created by MADAO on 16/1/13.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "ParamsTextField.h"
#import "FHTool.h"

#define HEIGHT_NORMAL 30.f
@implementation ParamsTextField
- (instancetype)initWithLabelText:(NSString *)text andPlaceHolder:(NSString *)placeHolder
{
    if (self = [super init]) {
        UIWindow *currentWindow = [FHTool getCurrentWindow];
        self.frame = CGRectMake(0,0,currentWindow.width,HEIGHT_NORMAL);
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self setupLabelsWithLabelText:text andPlaceHolder:placeHolder];
    }
    return self;
}
- (void)setupLabelsWithLabelText:(NSString *)text andPlaceHolder:(NSString *)placeHolder
{
    /**LeftView*/
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = text;
    tipLabel.font = FH_FONT_THIN_WITH_SIZE(14);
    tipLabel.frame = CGRectMake(15, 0, 60, HEIGHT_NORMAL);
    self.leftView = tipLabel;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    self.placeholder = placeHolder;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
