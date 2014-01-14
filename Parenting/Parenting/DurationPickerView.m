//
//  DurationPickerView.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-11-1.
//  Copyright (c) 2013年 爱摩信息科技. All rights reserved.
//

#import "DurationPickerView.h"

@implementation DurationPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        hours   = [NSMutableArray arrayWithCapacity:100];
        for (int i=0; i<24; i++) {
            [hours addObject:[NSNumber numberWithInt:i]];
        }
        minutes = [NSMutableArray arrayWithCapacity:100];
        for (int j=0; j<60; j++) {
            [minutes addObject:[NSNumber numberWithInt:j]];
        }
        //seconds = [NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3], [NSNumber numberWithInt:4], nil];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
	UIView *v=[[UIView alloc]
               initWithFrame:CGRectMake(0,0,
                                        [self pickerView:pickerView widthForComponent:component],
                                        [self pickerView:pickerView rowHeightForComponent:component])];
	[v setOpaque:TRUE];
	[v setBackgroundColor:[UIColor clearColor]];
	UILabel *lbl=nil;
    lbl= [[UILabel alloc]
          initWithFrame:CGRectMake(8,0,
                                   [self pickerView:pickerView widthForComponent:component],
                                   [self pickerView:pickerView rowHeightForComponent:component])];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
	NSString *ret=@"";
    int number=0;
	switch (component) {
		case 0:
            number=[(NSNumber*)[hours objectAtIndex:row] intValue];
            ret = [NSString stringWithFormat:@"%d %@",number,NSLocalizedString(@"DurationHour", nil)];
            break;
		case 1:
            number=[(NSNumber*)[minutes objectAtIndex:row] intValue];
            ret = [NSString stringWithFormat:@"%d %@",number,NSLocalizedString(@"DurationMin", nil)];
            break;
//        case 2:
//            number=[(NSNumber*)[seconds objectAtIndex:row] intValue];
//            ret = [NSString stringWithFormat:@"%d %@",number];
//            break;
        default:
            break;
            
	}

	[lbl setText:ret];
	[lbl setFont:[UIFont fontWithName:@"Arival-MTBOLD" size:70]];
	[v addSubview:lbl];
	return v;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"pickerView : %d, %d",row,component);
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 80;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 35;
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	switch (component) {
		case 0:
			return hours.count;
		case 1:
			return minutes.count;
        //case 2:
        //    return seconds.count;
		default:
			return 1;
	}
}


@end
