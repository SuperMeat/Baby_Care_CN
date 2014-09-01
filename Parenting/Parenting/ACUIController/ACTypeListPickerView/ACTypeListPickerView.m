//
//  ACTypeListPickerView.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-8-6.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "ACTypeListPickerView.h"

@implementation ACTypeListPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
-(id)initWithFrame:(CGRect)frame TypeList:(NSArray*)list
{
    typelist = [[NSMutableArray alloc] initWithCapacity:0];
    [typelist addObjectsFromArray:list];
    self.delegate   = self;
    self.dataSource = self;
    self=[self initWithFrame:frame];
    
    return self;
}

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
    [lbl setTextAlignment:NSTextAlignmentCenter];
	NSString *ret=@"";
	switch (component) {
		case 0:
            ret = [typelist objectAtIndex:row];
            [self.typeListPickerViewDelegate sendTypeListSaveChanged:[typelist objectAtIndex:row]];
            break;
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
    switch (component) {
        case 0:
            [self.typeListPickerViewDelegate sendTypeListSaveChanged:[typelist objectAtIndex:row]];
            break;
        default:
            break;
    }
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 280;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 35;
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	switch (component) {
		case 0:
			return typelist.count;
        default:
			return 1;
	}
}
@end
