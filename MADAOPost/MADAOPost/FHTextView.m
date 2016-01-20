//
//  FHTextView.m
//  Shire
//
//  Created by MADAO on 15/11/18.
//  Copyright © 2015年 LLJZ. All rights reserved.
//

#import "FHTextView.h"
#import <Masonry.h>
#define NORMAL_HEIGHT 45
#define SCALE 0.618

const CGFloat lineWidth = 0.05;

@implementation FHTextView
- (instancetype)initWithTip:(NSString *)tip
                placeholder:(NSString *)placeholder
                buttonTitle:(NSString *)title
                       type:(FHTextKeyboardType)type
{
    UIWindow *window=[[UIApplication sharedApplication]windows][0];
    if (self=[super initWithFrame:(CGRect){CGPointZero, {window.frame.size.width, NORMAL_HEIGHT}}]) {
        //控件初始化
        self.backgroundColor=[UIColor whiteColor];
        /**组件部分*/
        [self createTipLabelWithTip:tip];
        [self createTextFieldWithPlaceHolder:placeholder textColor:[UIColor blackColor] andKeyboardType:type];
        
        /**自定义按钮*/
        if (title != nil ) {
            self.btnCustom = [UIButton buttonWithType:UIButtonTypeSystem];
            self.btnCustom.backgroundColor = [UIColor whiteColor];
            [self.btnCustom setTitle:title forState:UIControlStateNormal];
            [self.btnCustom addTarget:self
                               action:@selector(btnCustomOnClicked:)
                     forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.btnCustom];
        }
        /**布局*/
        [self autoLayoutWithRectType];
    }
    return self;
}
#pragma mark - CreateComponent
- (void)createTipLabelWithTip:(NSString *)tip
{
    /**标签部分*/
    self.lblTip = [[UILabel alloc]init ];
    self.lblTip.backgroundColor = [UIColor whiteColor];
    self.lblTip.textColor = [UIColor darkGrayColor];
    self.lblTip.text = tip;
    self.lblTip.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.lblTip];
}
- (void)createTextFieldWithPlaceHolder:(NSString *)placeHolder textColor:(UIColor *)color andKeyboardType:(FHTextKeyboardType)type
{
    /**输入框*/
    self.textField = [[UITextField alloc] init];
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.textColor = color;
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.placeholder = placeHolder;
    [self.textField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    [self.textField addTarget:self
                       action:@selector(textDidChange:)
             forControlEvents:UIControlEventAllEditingEvents];
    switch (type) {
        case FHTextKeyboardTypeDefault:
            break;
        case FHTextKeyboardTypeNumOnly:
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case FHTextKeyboardTypePassword:
            self.textField.secureTextEntry = YES;
            
        default:
            break;
    }
    [self addSubview:self.textField];
}
#pragma mark - Layout
- (void)autoLayoutWithRectType
{
    [self.lblTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.leading.equalTo(self.mas_leading).with.offset(15);
        make.width.mas_equalTo(NORMAL_HEIGHT * 2);
    }];
    
    if (self.btnCustom) {
        [self.btnCustom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.trailing.equalTo(self.mas_trailing);
            make.width.mas_equalTo(NORMAL_HEIGHT * 2);
        }];
    }
    if ([self.btnCustom.titleLabel.text isEqualToString:@" "]){
        [self.btnCustom mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(5);
            make.bottom.equalTo(self.mas_bottom).with.offset(-5);
            make.trailing.equalTo(self.mas_trailing).with.offset(-15);
            make.width.mas_equalTo(30.f);
        }];
    }
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.leading.equalTo(self.lblTip.mas_trailing);
        if (self.btnCustom) {
            make.trailing.equalTo(self.btnCustom.mas_leading);
        }
        else{
            make.trailing.equalTo(self.mas_trailing);
        }
    }];
    [self drawSeparateLine];
}
- (void)drawSeparateLine
{
    UIBezierPath *upsideLine = [UIBezierPath bezierPath];
    [upsideLine moveToPoint:CGPointZero];
    [upsideLine addLineToPoint:CGPointMake(self.frame.size.width, 0)];
    
    UIBezierPath *downsideLine = [UIBezierPath bezierPath];
    [downsideLine moveToPoint:CGPointMake(0, self.frame.size.height)];
    [downsideLine addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    
    CAShapeLayer *upsideLayer = [CAShapeLayer layer];
    upsideLayer.path = upsideLine.CGPath;
    upsideLayer.lineWidth = lineWidth;
    upsideLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    upsideLayer.fillColor = [UIColor clearColor].CGColor;
    
    CAShapeLayer *downsideLayer = [CAShapeLayer layer];
    downsideLayer.path = downsideLine.CGPath;
    downsideLayer.lineWidth = lineWidth;
    downsideLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    downsideLayer.fillColor = [UIColor clearColor].CGColor;
    
    [self.layer addSublayer:upsideLayer];
    [self.layer addSublayer:downsideLayer];
}
- (void)layoutWithLineType
{
    [self.lblTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.leading.equalTo(self.mas_leading);
        make.width.mas_equalTo(NORMAL_HEIGHT * 1.5);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.leading.equalTo(self.lblTip.mas_trailing);
        make.trailing.equalTo(self.mas_trailing);
    }];
}
- (void)drawUnderLineWithColor:(UIColor *)color
{
    /**绘制下划线*/
    UIBezierPath *underLine = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointMake(NORMAL_HEIGHT * 1.5 + 2,NORMAL_HEIGHT - 2);
    CGPoint endPoint = CGPointMake(self.frame.size.width, startPoint.y);
    [underLine moveToPoint:startPoint];
    [underLine addLineToPoint:endPoint];
    
    CAShapeLayer *underLineLayer = [[CAShapeLayer alloc] init];
    underLineLayer.path = underLine.CGPath;
    underLineLayer.strokeColor = color.CGColor;
    underLineLayer.fillColor = [UIColor clearColor].CGColor;
    underLineLayer.lineWidth = 1.f;
    [self.layer addSublayer:underLineLayer];
}
- (instancetype)initWithLineTypeTip:(NSString *)tip
                        placeHolder:(NSString *)placeholder
                          lineColor:(UIColor *)color
                               type:(FHTextKeyboardType)type
{
    UIWindow *window=[[UIApplication sharedApplication]windows][0];
    if (self = [super init]) {
        self.frame = CGRectMake((1- SCALE)/2.f * window.frame.size.width, 0 , window.frame.size.width * SCALE, NORMAL_HEIGHT);
        [self createTipLabelWithTip:tip];
        [self createTextFieldWithPlaceHolder:placeholder textColor:color andKeyboardType:type];
        [self layoutWithLineType];
        [self drawUnderLineWithColor:color];
    }
    return self;
}
#pragma mark - Actions
- (void)textDidChange:(UITextField *)textField
{
    [self.delegate textFieldEditing:textField];
}
- (void)btnCustomOnClicked:(UIButton *)button
{
    [self.delegate buttonCustomeOnClicked:button];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
