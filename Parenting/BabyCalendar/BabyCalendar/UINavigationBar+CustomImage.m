//
//  UINavigationBar+CustomImage.m
//  MySafedog
//
//  Created by Will on 13-12-26.
//  Copyright (c) 2013年 will. All rights reserved.
//

#import "UINavigationBar+CustomImage.h"

@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
    UIImage* image = [UIImage imageNamed:@"navbg"];
    [image drawInRect:rect];
}
@end
