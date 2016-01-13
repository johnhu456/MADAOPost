//
//  FHTool.h
//  FHColorTool
//
//  Created by MADAO on 15/12/29.
//  Copyright © 2015年 MADAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef FHTool_h
#define FHTool_h
#define FH_FONT_SYSTEM_WITH_SIZE(x) [UIFont systemFontOfSize:x]
#define FH_FONT_THIN_WITH_SIZE(x) [UIFont fontWithName:@"STHeitiSC-Light" size:x]
#endif

#ifndef UIView_Frame_h
    #import "UIView+Frame.h"
    #define UIView_Frame_h
#endif

@interface FHTool : NSObject

/**获取当前Window对象*/
+ (UIWindow *)getCurrentWindow;

@end
