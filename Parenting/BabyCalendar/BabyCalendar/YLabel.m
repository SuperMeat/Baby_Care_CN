//
//  YLabel.m
//  MySafedog
//
//  Created by will on 14-2-10.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "YLabel.h"

@implementation YLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(kColor_Zheline).CGColor);
//    CGContextMoveToPoint(context, self.width-5, self.height/2);
//    CGContextAddLineToPoint(context, self.width, self.height/2);
//    CGContextStrokePath(context);
    
    UILabel* vLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    [vLabel setBackgroundColor:[UIColor clearColor]];
    [vLabel setTextAlignment:NSTextAlignmentCenter];
    [vLabel setFont:[UIFont fontWithName:kFont size:9]];
    [vLabel setTextColor:UIColorFromRGB(kColor_Zheline_val)];
    [self addSubview:vLabel];
    vLabel.text = self.text;
}

@end
