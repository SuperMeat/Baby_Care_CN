//
//  save_bathview.m
//  Parenting
//
//  Created by user on 13-5-25.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "save_bathview.h"

@implementation save_bathview
@synthesize select,start,isshow,curduration;


-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self  makeSave];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame Select:(BOOL)_select Start:(NSDate*)_start Duration:(NSString *)_curduration UpdateTime:(long)updatetime CreateTime:(long)createtime
{
    self.start=_start;
    self.select=_select;
    _updatetime = updatetime;
    _createtime = createtime;
    
    NSArray *array = [_curduration componentsSeparatedByString:@":"];
    self.durationhour = [[array objectAtIndex:0] intValue];
    self.durationmin  = [[array objectAtIndex:1] intValue];
    self.durationsec  = [[array objectAtIndex:2] intValue];
    
    self.curduration = self.durationhour*60*60 + self.durationmin*60 + self.durationsec;

    self=[self initWithFrame:frame];
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

-(void)makeSave
{
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 290, 30)];
    title.text=NSLocalizedString(@"Confirm your activity",nil);
    title.textAlignment=NSTextAlignmentCenter;
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[UIColor grayColor];
    imageview=[[UIImageView alloc]init];
    imageview.bounds=CGRectMake(0, 0, 290, 260+30);
    imageview.center=CGPointMake(160, (460-44-49)/2+30);
    [self addSubview:imageview];
    [imageview addSubview:title];
    // saveView.backgroundColor=[UIColor colorWithWhite:0.4 alpha:0.3];
    
    imageview.backgroundColor=[ACFunction colorWithHexString:@"#f4f4f4"];
    imageview.layer.cornerRadius = 8.0f;
    imageview.userInteractionEnabled=YES;
    //imageview.image=[UIImage imageNamed:@"save_bg"];
    [imageview.image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    UILabel *date=[[UILabel alloc]initWithFrame:CGRectMake(10, 40, 100, 30)];
    
    UILabel *starttime=[[UILabel alloc]initWithFrame:CGRectMake(10, 80, 100, 30)];
    
    UILabel *duration=[[UILabel alloc]initWithFrame:CGRectMake(10, 120, 100, 30)];
    
    UILabel *remark=[[UILabel alloc]initWithFrame:CGRectMake(10, 160, 100, 30)];
    
    
    date.backgroundColor=[UIColor clearColor];
    starttime.backgroundColor=[UIColor clearColor];
    duration.backgroundColor=[UIColor clearColor];
    remark.backgroundColor=[UIColor clearColor];
    
    date.textColor=[UIColor grayColor];
    starttime.textColor=[UIColor grayColor];
    duration.textColor=[UIColor grayColor];
    remark.textColor=[UIColor grayColor];    
    date.text=NSLocalizedString(@"Date:",nil);
    starttime.text=NSLocalizedString(@"Start Time:",nil);
    duration.text=NSLocalizedString(@"Duration:",nil);
    remark.text=NSLocalizedString(@"Comments:",nil);
    
    
    date.textAlignment=NSTextAlignmentRight;
    starttime.textAlignment=NSTextAlignmentRight;
    duration.textAlignment=NSTextAlignmentRight;
    remark.textAlignment=NSTextAlignmentRight;
    
    [imageview addSubview:date];
    [imageview addSubview:starttime];
    [imageview addSubview:duration];
    [imageview addSubview:remark];
    
    datetext=[[UITextField alloc]initWithFrame:CGRectMake(115, 40, 150, 30)];
    [datetext setBackground:[UIImage imageNamed:@"panels_input"]];
    datetext.adjustsFontSizeToFitWidth=YES;
    [imageview addSubview:datetext];
    //datetext.enabled=NO;
    datetext.delegate  = self;
    datetext.inputView = datepicker;
    
    [datetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [datetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [datetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [datetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    datetext.textColor=[UIColor grayColor];
    starttimetext=[[UITextField alloc]initWithFrame:CGRectMake(115, 80, 150, 30)];
    [starttimetext setBackground:[UIImage imageNamed:@"panels_input"]];
    [imageview addSubview:starttimetext];

    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    //starttimetext.enabled=NO;
    starttimetext.delegate = self;
    starttimetext.inputView = starttimepicker;
    starttimetext.textColor=[UIColor grayColor];
    durationtext=[[UITextField alloc]initWithFrame:CGRectMake(115, 120, 150, 30)];
    [durationtext setBackground:[UIImage imageNamed:@"panels_input"]];
    [imageview addSubview:durationtext];

    [durationtext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [durationtext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [durationtext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [durationtext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    //durationtext.enabled=NO;
    durationtext.delegate = self;
    durationtext.inputView = durationpicker;
    hours   = [NSMutableArray arrayWithCapacity:100];
    for (int i=0; i<24; i++) {
        [hours addObject:[NSNumber numberWithInt:i]];
    }
    minutes = [NSMutableArray arrayWithCapacity:100];
    for (int j=0; j<60; j++) {
        [minutes addObject:[NSNumber numberWithInt:j]];
    }

    durationtext.textColor=[UIColor grayColor];
    UIImageView *remarkbg=[[UIImageView alloc]initWithFrame:CGRectMake(115, 160, 150, 30+30)];
    remarkbg.image=[UIImage imageNamed:@"panels_input"];
    remarkbg.userInteractionEnabled=YES;
    
    remarktext=[[UITextView alloc]initWithFrame:CGRectMake(-2, 0, 140, 30+30)];
    remarktext.backgroundColor=[UIColor clearColor];
    //    [remarktext setBackground:[UIImage imageNamed:@"save_text"]];
    [remarkbg addSubview:remarktext];
    remarktext.font=[UIFont systemFontOfSize:16];
    [imageview addSubview:remarkbg];
    remarktext.delegate=self;
    remarktext.textColor=[UIColor grayColor];
    //    [remarktext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    //    [remarktext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    //    [remarktext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    //    [remarktext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    
    
    
    UIButton *savebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    savebutton.frame=CGRectMake(200, 220+30, 70, 30);
    [savebutton setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    savebutton.layer.cornerRadius = 5.0f;
    [savebutton setTitle:NSLocalizedString(@"Save",nil) forState:UIControlStateNormal];
    [savebutton addTarget:self action:@selector(Save) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:savebutton];
    
    UIButton *canclebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    canclebutton.frame=CGRectMake(20, 220+30, 70, 30);
    [canclebutton setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    canclebutton.layer.cornerRadius = 5.0f;
    [canclebutton setTitle:NSLocalizedString(@"Cancle",nil) forState:UIControlStateNormal];
    [canclebutton addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:canclebutton];
    
 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)loaddata
{
    if (self.select) {
        
        SummaryDB *db=[SummaryDB dataBase];
        NSArray *array= [db searchFrombath:self.start];
        NSDate *date=(NSDate*)[array objectAtIndex:0];
        
        datetext.text=[ACDate dateFomatdate:date];
        
        
        durationtext.text=[ACDate getDurationfromdate:date second:[[array objectAtIndex:1] intValue] ] ;
        
        NSArray *array2 = [durationtext.text componentsSeparatedByString:@":"];
        self.durationhour = [[array2 objectAtIndex:0] intValue];
        self.durationmin  = [[array2 objectAtIndex:1] intValue];
        self.durationsec  = [[array2 objectAtIndex:2] intValue];
        
        starttimetext.text=[ACDate getStarttimefromdate:date];
        
        
        remarktext.text=[array objectAtIndex:2];
        
    }
    
    else
    {
        
        datetext.text=[ACDate getdateFormat];
        durationtext.text=[ACDate durationFormat];
        NSArray *array2 = [durationtext.text componentsSeparatedByString:@":"];
        self.durationhour = [[array2 objectAtIndex:0] intValue];
        self.durationmin  = [[array2 objectAtIndex:1] intValue];
        self.durationsec  = [[array2 objectAtIndex:2] intValue];
        starttimetext.text=[ACDate getStarttimeFormat];
    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    for (id key in imageview.subviews) {
        if ([key isKindOfClass:[UITextField class]]) {
            [key resignFirstResponder];
        }
    }
}

-(void)Save
{
    BabyDataDB *db=[BabyDataDB babyinfoDB];
    int duration = 0;
    if (select) {
        //[db updatebathRemark:remarktext.text Starttime:start];
        NSArray *array = [durationtext.text componentsSeparatedByString:@":"];
        duration = [[array objectAtIndex:0] intValue]*60*60 + [[array objectAtIndex:1]intValue]*60+[[array objectAtIndex:2]intValue];
        if (curstarttime == nil)
        {
            [db updateBathRecord:self.start Month:[ACDate getMonthFromDate:self.start] Week:[ACDate getWeekFromDate:self.start] WeekDay:[ACDate getWeekDayFromDate:self.start] Duration:duration BathType:@"" Remark:remarktext.text MoreInfo:@"" CreateTime:_createtime];
        }
        else
        {
            [db updateBathRecord:curstarttime Month:[ACDate getMonthFromDate:curstarttime] Week:[ACDate getWeekFromDate:curstarttime] WeekDay:[ACDate getWeekDayFromDate:curstarttime] Duration:duration BathType:@"" Remark:remarktext.text MoreInfo:@"" CreateTime:_createtime];
            curstarttime = nil;
        }

        [self removeFromSuperview];
    }
    else
    {
    //int duration;
    NSArray *arr=[durationtext.text componentsSeparatedByString:@":"];
        duration=[[arr objectAtIndex:0] intValue]*60*60+[[arr objectAtIndex:1]intValue]*60+[[arr objectAtIndex:2] intValue];
    
        if (curstarttime == nil) {
            long creattime = [ACDate getTimeStampFromDate:[ACDate date]];
            [db insertBabyBathRecord:creattime
                          UpdateTime:creattime
                           StartTime:[ACDate date]
                               Month:[ACDate getCurrentMonth]
                                Week:[ACDate getCurrentWeek]
                             Weekday:[ACDate getCurrentWeekDay]
                            Duration:duration BathType:@""
                              Remark:remarktext.text MoreInfo:@""
             ];
        }
        else
        {
            long creattime = [ACDate getTimeStampFromDate:[ACDate date]];
            [db insertBabyBathRecord:creattime
                          UpdateTime:creattime
                           StartTime:curstarttime
                               Month:[ACDate getMonthFromDate:curstarttime]
                                Week:[ACDate getWeekFromDate:curstarttime]
                             Weekday:[ACDate getWeekDayFromDate:curstarttime]
                            Duration:duration BathType:@""
                              Remark:remarktext.text MoreInfo:@""
             ];
            curstarttime = nil;
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:@"stop" object:[NSNumber numberWithInt:(duration)]];
    }
    
     [self.bathSaveDelegate sendBathSaveChanged:duration andstarttime:curstarttime];
}
-(void)cancle:(UIButton*)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancel" object:nil];
    [self removeFromSuperview];
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{

    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{

}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == datetext)
    {
        [self actionsheetShow];
        [datetext resignFirstResponder];
    }
    
    if (textField == starttimetext) {
        [self actionsheetStartTimeShow];
        [starttimetext resignFirstResponder];
    }
    
    if (textField == durationtext) {
        [self actionsheetDurationShow];
        [durationtext resignFirstResponder];
    }

}
-(void)textFieldDidEndEditing:(UITextField *)textField
{

}
-(void)keyboradshow
{
    if (!self.isshow) {
        NSTimeInterval animationDuration = 0.25f;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y-150, 320, 460-44-49);
        [UIView commitAnimations];
        self.isshow=YES;
    }
    
}
-(void)keyboradhidden
{
    if (self.isshow) {
        NSTimeInterval animationDuration = 0.25f;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y+150, 320, 460-44-49);
        [UIView commitAnimations];
        self.isshow=NO;
    }
    
}
- (void)keyboardWillShown:(NSNotification*)aNotification{
    [self keyboradshow];
}

-(void)keyboardWillHidden:(NSNotification*)aNotification
{
    [self keyboradhidden];
}

#pragma -mark sleep change time
-(void)updatedate:(UIDatePicker*)sender
{
    NSLog(@"updatedate:%@", sender);
    UIDatePicker *picker = sender;
    if (self.start == nil) {
        if (curstarttime == nil) {
            curstarttime = picker.date;
        }
        else
        {
            curstarttime = [ACDate getNewDateFromOldDate:picker.date andOldDate:curstarttime];
        }
    }
    else
    {
        if (curstarttime == nil) {
            curstarttime  = [ACDate getNewDateFromOldDate:picker.date andOldDate:self.start];
        }
        else
        {
            curstarttime  = [ACDate getNewDateFromOldDate:picker.date andOldDate:curstarttime];
        }
    }
    
    datetext.text = [ACDate dateFomatdate:curstarttime];
}


-(void)updatestarttime:(UIDatePicker*)sender
{
    NSLog(@"updatestarttime:%@", sender);
    UIDatePicker *picker = sender;
    if (self.start == nil)
    {
        if (curstarttime == nil) {
            curstarttime = picker.date;
        }
        else
        {
            curstarttime = [ACDate getNewDateFromOldTime:picker.date andOldDate:curstarttime];
        }
    }
    else
    {
        if (curstarttime == nil) {
            curstarttime = [ACDate getNewDateFromOldTime:picker.date andOldDate:self.start];
        }
        else
        {
            curstarttime = [ACDate getNewDateFromOldTime:picker.date andOldDate:curstarttime];
        }
    }
    
    starttimetext.text = [ACDate getStarttimefromdate:curstarttime];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"justdoit"];
}

-(void)actionsheetShow
{
    if (action == nil) {
        action = [[CustomIOS7AlertView alloc] init];
        [action setContainerView:[self createDateView]];
        [action setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
        [action setDelegate:self];
    }
    
    [action show];
}

-(void)actionsheetStartTimeShow
{
    if (action2 == nil) {
        action2 = [[CustomIOS7AlertView alloc] init];
        [action2 setContainerView:[self createStartimeView]];
        [action2 setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
        [action2 setDelegate:self];
    }
    
    [action2 show];
}

-(void)actionsheetDurationShow
{
    if (action3 == nil) {
        action3 = [[CustomIOS7AlertView alloc] init];
        [action3 setContainerView:[self createDurationView]];
        [action3 setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
        [action3 setDelegate:self];
    }
    
    [action3 show];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    // 确定
    if (buttonIndex == 1)
    {
        if (alertView == action3) {
            durationtext.text = [NSString stringWithFormat:@"%02d:%02d:%02d", self.durationhour,self.durationmin,self.durationsec];
        }
    }
    
    [alertView close];
}

- (UIDatePicker*)createDateView
{
    if (datepicker==nil) {
        datepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, datetext.frame.origin.y+45, 320, 100)];
        datepicker.datePickerMode=UIDatePickerModeDate;
        [datepicker addTarget:self action:@selector(updatedate:) forControlEvents:UIControlEventValueChanged];
    }
    
    datepicker.frame=CGRectMake(0, 0, 320, 100);
    
    return datepicker;
}

- (UIDatePicker*)createStartimeView
{
    if (starttimepicker==nil) {
        starttimepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, datetext.frame.origin.y+45, 320, 100)];
        starttimepicker.datePickerMode=UIDatePickerModeTime;
        [starttimepicker addTarget:self action:@selector(updatestarttime:) forControlEvents:UIControlEventValueChanged];
    }
    
    starttimepicker.frame=CGRectMake(0, 0, 320, 100);
    return starttimepicker;
}



- (DurationPickerView*)createDurationView
{
    if (durationpicker==nil) {
        durationpicker=[[DurationPickerView alloc]initWithFrame:CGRectMake(0, datetext.frame.origin.y, 320, 162)];
    }
    
    durationpicker.delegate   = self;
    durationpicker.dataSource = self;
    durationpicker.showsSelectionIndicator = YES;
    durationpicker.frame=CGRectMake(0, 0, 320, 162);
    [durationpicker selectRow:self.durationmin inComponent:1 animated:NO];
    [durationpicker selectRow:self.durationhour inComponent:0 animated:NO];
    
    return durationpicker;
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
    NSLog(@"pickerView : %d, %d",component, row);
    
    switch (component) {
        case 0:
            self.durationhour = row;
            break;
        case 1:
            self.durationmin  = row;
            break;
        default:
            break;
    }
    durationtext.text = [NSString stringWithFormat:@"%02d:%02d:%02d", self.durationhour,self.durationmin,self.durationsec];
    
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
			return 24;
		case 1:
			return 60;
        default:
			return 1;
	}
}

@end
