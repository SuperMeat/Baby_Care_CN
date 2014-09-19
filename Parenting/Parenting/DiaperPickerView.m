//
//  DiaperPickerView.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-5-8.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "DiaperPickerView.h"

@implementation DiaperPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame Type:(int)type Option:(int)option
{
    backgroundColorList = [[NSMutableArray alloc] initWithCapacity:5];
    descripeList        = [[NSMutableArray alloc] initWithCapacity:5];
    // 嘘嘘类包含嘘嘘
    if (option == DIAPER_OPTION_XUXU) {
        if (type == DIAPER_TYPE_AMOUNT) {
            [descripeList addObjectsFromArray:[NSArray arrayWithObjects:@"无",@"少量",@"正常",@"很多",@"溢出", nil]];
            [backgroundColorList addObjectsFromArray:[NSArray arrayWithObjects:[UIColor whiteColor],[UIColor lightGrayColor],[UIColor grayColor],[UIColor colorWithRed:0.393 green:1.000 blue:0.922 alpha:1.000],
                                                      [UIColor colorWithRed:0.365 green:0.796 blue:1.000 alpha:1.000],nil]];
        }
        else if (type == DIAPER_TYPE_COLOR)
        {
            [descripeList addObjectsFromArray:[NSArray arrayWithObjects:@"透明",@"较淡",@"偏黄",@"较黄",@"深黄", nil]];
            [backgroundColorList addObjectsFromArray:[NSArray arrayWithObjects:[UIColor whiteColor],[UIColor colorWithRed:0.875 green:0.879 blue:0.731 alpha:1.000],[UIColor colorWithRed:1.000 green:0.933 blue:0.527 alpha:1.000],[UIColor colorWithRed:1.000 green:0.798 blue:0.280 alpha:1.000],
                                                      [UIColor colorWithRed:1.000 green:0.677 blue:0.071 alpha:1.000],nil]];
        }
        else
        {
            [descripeList addObjectsFromArray:[NSArray arrayWithObjects:@"水样",@"较稀",@"正常",@"软干硬",@"很干硬", nil]];
            [backgroundColorList addObjectsFromArray:[NSArray arrayWithObjects:[UIColor colorWithRed:0.730 green:1.000 blue:0.861 alpha:1.000],[UIColor colorWithRed:0.875 green:0.879 blue:0.731 alpha:1.000],[UIColor colorWithRed:0.788 green:0.714 blue:0.317 alpha:1.000],[UIColor colorWithRed:0.555 green:0.388 blue:0.100 alpha:1.000],
                                                      [UIColor colorWithRed:0.352 green:0.258 blue:0.029 alpha:1.000],nil]];
        }
    }
    // 便便
    else
    {
        
    }
    
    self.delegate   = self;
    self.dataSource = self;
    _type = type;
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
            ret = [descripeList objectAtIndex:row];
            [lbl setBackgroundColor:[backgroundColorList objectAtIndex:row]];
            [lbl setAlpha:0.6];
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
    NSLog(@"pickerView : %i, %i",row,component);
    switch (component) {
        case 0:
            [self.diaperPickerViewDelegate sendDiaperSaveChanged:_type NewStatus:[descripeList objectAtIndex:row]];
            break;
        default:
            break;
    }
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 300;
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
			return descripeList.count;
        default:
			return 1;
	}
}

@end
