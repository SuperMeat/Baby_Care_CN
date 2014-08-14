//
//  AddIemView.m
//  BabyCalendar
//
//  Created by will on 14-6-26.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "AddIemView.h"

@implementation AddIemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (IBAction)editeAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addIemViewDidEdite)]) {
        [self.delegate addIemViewDidEdite];
    }
}

- (IBAction)addAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addIemViewDidAdd)]) {
        [self.delegate addIemViewDidAdd];
    }
}
@end
