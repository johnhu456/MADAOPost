//
//  FHTool.h
//  FHColorTool
//
//  Created by MADAO on 15/12/29.
//  Copyright © 2015年 MADAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef UIView_Frame_h
#import "UIView+Frame.h"
#define UIView_Frame_h
#endif

#define FH_FONT_SYSTEM_WITH_SIZE(x) [UIFont systemFontOfSize:x]
#define FH_FONT_THIN_WITH_SIZE(x) [UIFont fontWithName:@"STHeitiSC-Light" size:x]

#define FH_ColorWith(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]


#define WEAK_SELF __weak typeof(self) weakSelf = self 



@interface FHTool : NSObject

/**获取当前Window对象*/
+ (UIWindow *)getCurrentWindow;

@end
