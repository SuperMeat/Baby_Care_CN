//
//  UIBarButtonItem+CustomForNav.h
//  HuShuo
//
//  Created by ZhangJian on 7/15/11.
//  Copyright 2011 yaku.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIBarButtonItem(CustomForNav)

+(UIBarButtonItem*)customForTarget:(id)target
                             image:(NSString *)imageName
                             title:(NSString *)itemTitle
                            action:(SEL)func;

+(UIBarButtonItem*)customForTarget2:(id)target action1:(SEL)func1 action2:(SEL)func2;
+(UIBarButtonItem*)customForTarget3:(id)target
                              image:(NSString *)imageName
                              title:(NSString *)itemTitle
                             action:(SEL)func;
@end
