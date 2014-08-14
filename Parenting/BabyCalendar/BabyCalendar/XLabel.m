//
//  XLabel.m
//  MySafedog
//
//  Created by will on 14-2-10.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "XLabel.h"

@implementation XLabel

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
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(kColor_Zheline).CGColor);
    CGContextMoveToPoint(context, self.width/2, 0);
    CGContextAddLineToPoint(context, self.width/2, 5);
    CGContextStrokePath(context);
    
    UILabel* vLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [vLabel setBackgroundColor:[UIColor clearColor]];
    [vLabel setFont:[UIFont fontWithName:kFont size:9]];
    [vLabel setTextColor:UIColorFromRGB(kColor_Zheline_val)];
    [vLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self addSubview:vLabel];
    vLabel.text = self.text;
}


@end
