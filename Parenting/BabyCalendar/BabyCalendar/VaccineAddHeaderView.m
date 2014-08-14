//
//  VaccineAddHeaderView.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "VaccineAddHeaderView.h"

@implementation VaccineAddHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = UIColorFromRGB(kColor_val_headView);
    
    _textView.textColor = UIColorFromRGB(kColor_val_infoText);
    _textView.font = [UIFont fontWithName:kFont size:12.0f];
}

@end
