//
//  MyNoteView.m
//  BabyCalendar
//
//  Created by will on 14-7-28.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "MyNoteView.h"

@implementation MyNoteView

- (id)initWithFrame:(CGRect)frame {
	
    self = [super initWithFrame:frame];
    if (self) {
		[self setBackgroundColor:[UIColor whiteColor]];
//        self.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14];
        self.delegate = self;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	
    //Get the current drawing context
    CGContextRef context = UIGraphicsGetCurrentContext();
    //Set the line color and width
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(kColor_note_line).CGColor);
    CGContextSetLineWidth(context, 1.0f);
    
    
    //Start a new Path
    CGContextBeginPath(context);
	
    //Find the number of lines in our textView + add a bit more height to draw lines in the empty part of the view
    NSUInteger numberOfLines = (self.contentSize.height + self.bounds.size.height) / self.font.leading;
	
    //Set the line offset from the baseline. (I'm sure there's a concrete way to calculate this.)
    CGFloat baselineOffset = 6.0f;
	
    //iterate over numberOfLines and draw each line
    for (NSUInteger x = 1; x < numberOfLines; x++) {
        
        //0.5f offset lines up line with pixel boundary
        CGContextMoveToPoint(context, self.bounds.origin.x+5, self.font.leading*x + 0.5f + baselineOffset);
        //CGContextAddLineToPoint(context, self.bounds.size.width-5, self.font.leading*x + 0.5f + baselineOffset);
    }
	
    //Close our Path and Stroke (draw) it
    CGContextClosePath(context);
    CGContextStrokePath(context);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setNeedsDisplay];
}


@end
