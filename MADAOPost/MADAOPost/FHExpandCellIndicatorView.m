//
//  FHExpandCellIndicatorView.m
//  MADAOPost
//
//  Created by MADAO on 16/2/3.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "FHExpandCellIndicatorView.h"

@implementation FHExpandCellIndicatorView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
}
- (void)drawRect:(CGRect)rect
{
    /**绘制三角箭头*/
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds))];
    [trianglePath addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMaxY(self.bounds) - 15.f)];
    [trianglePath addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds))];
    [trianglePath addLineToPoint:CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds))];
    [self.indicatorColor setFill];
    [[UIColor clearColor] setStroke];
    [trianglePath fill];
}

@end
