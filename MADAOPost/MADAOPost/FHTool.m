//
//  FHTool.m
//  FHColorTool
//
//  Created by MADAO on 15/12/29.
//  Copyright © 2015年 MADAO. All rights reserved.
//

#import "FHTool.h"

@implementation FHTool

+(UIWindow *)getCurrentWindow
{
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    return window;
}

@end
