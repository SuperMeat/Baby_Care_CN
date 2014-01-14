	//
//  save_playview.m
//  Parenting
//
//  Created by user on 13-5-25.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "save_playview.h"

@implementation save_playview
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
-(id)initWithFrame:(CGRect)frame Select:(BOOL)_select Start:(NSDate*)_start Duration:(NSString*)_curduration

{
    self.start=_start;
    self.select=_select;
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
    imageview.bounds=CGRectMake(0, 0, 290, 260);
    imageview.center=CGPointMake(160, (460-44-49)/2);
    [self addSubview:imageview];
    [imageview addSubview:title];
    // saveView.backgroundColor=[UIColor colorWithWhite:0.4 alpha:0.3];
    
    imageview.backgroundColor=[UIColor clearColor];
    imageview.userInteractionEnabled=YES;
    imageview.image=[UIImage imageNamed:@"save_bg.png"];
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
    [datetext setBackground:[UIImage imageNamed:@"save_text.png"]];
    datetext.adjustsFontSizeToFitWidth=YES;
    [imageview addSubview:datetext];

    [datetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [datetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [datetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [datetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    //datetext.enabled=NO;
    datetext.delegate = self;
    datetext.inputView = datepicker;
    
    datetext.textColor=[UIColor grayColor];
    starttimetext=[[UITextField alloc]initWithFrame:CGRectMake(115, 80, 150, 30)];
    [starttimetext setBackground:[UIImage imageNamed:@"save_text.png"]];
    [imageview addSubview:starttimetext];
    starttimetext.textColor=[UIColor grayColor];
    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    //starttimetext.enabled=NO;
    starttimetext.delegate = self;
    starttimetext.inputView = starttimepicker;
    
    durationtext=[[UITextField alloc]initWithFrame:CGRectMake(115, 120, 150, 30)];
    [durationtext setBackground:[UIImage imageNamed:@"save_text.png"]];
    [imageview addSubview:durationtext];
    durationtext.textColor=[UIColor grayColor];
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
    
    UIImageView *remarkbg=[[UIImageView alloc]initWithFrame:CGRectMake(115, 160, 150, 30)];
    remarkbg.image=[UIImage imageNamed:@"save_text.png"];
    remarkbg.userInteractionEnabled=YES;
    
    remarktext=[[UITextView alloc]initWithFrame:CGRectMake(-2, 0, 140, 30)];
    remarktext.backgroundColor=[UIColor clearColor];
    remarktext.textColor=[UIColor grayColor];
    //    [remarktext setBackground:[UIImage imageNamed:@"save_text.png"]];
    [remarkbg addSubview:remarktext];
    remarktext.font=[UIFont systemFontOfSize:16];
    [imageview addSubview:remarkbg];
    remarktext.delegate=self;
    //    [remarktext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    //    [remarktext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    //    [remarktext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    //    [remarktext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    
    
    
    UIButton *savebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    savebutton.frame=CGRectMake(200, 220, 70, 30);
    [savebutton setBackgroundImage:[UIImage imageNamed:@"btn2.png"] forState:UIControlStateNormal];
    [savebutton setTitle:NSLocalizedString(@"Save",nil) forState:UIControlStateNormal];
    [savebutton addTarget:self action:@selector(Save) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:savebutton];
    
    UIButton *canclebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    canclebutton.frame=CGRectMake(20, 220, 70, 30);
    [canclebutton setBackgroundImage:[UIImage imageNamed:@"btn2.png"] forState:UIControlStateNormal];
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
        
        DataBase *db=[DataBase dataBase];
        NSArray *array= [db searchFromplay:self.start];
        NSDate *date=(NSDate*)[array objectAtIndex:0];
        
        datetext.text=[currentdate dateFomatdate:date];
        
        
        durationtext.text=[currentdate getDurationfromdate:date second:[[array objectAtIndex:1] intValue] ] ;
        
        NSArray *array2 = [durationtext.text componentsSeparatedByString:@":"];
        self.durationhour = [[array2 objectAtIndex:0] intValue];
        self.durationmin  = [[array2 objectAtIndex:1] intValue];
        self.durationsec  = [[array2 objectAtIndex:2] intValue];
        
        starttimetext.text=[currentdate getStarttimefromdate:date];
        remarktext.text=[array objectAtIndex:2];
        
    }
    
    else
    {
        
        datetext.text=[currentdate getdateFormat];
        durationtext.text=[currentdate durationFormat];
        
        NSArray *array = [durationtext.text componentsSeparatedByString:@":"];
        self.durationhour = [[array objectAtIndex:0] intValue];
        self.durationmin  = [[array objectAtIndex:1] intValue];
        self.durationsec  = [[array objectAtIndex:2] intValue];

        starttimetext.text=[currentdate getStarttimeFormat];
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
    
    DataBase *db=[DataBase dataBase];
    int duration=0;
    if (select) {
        
        NSArray *array = [durationtext.text componentsSeparatedByString:@":"];
        duration = [[array objectAtIndex:0] intValue]*60*60 + [[array objectAtIndex:1]intValue]*60+[[array objectAtIndex:2]intValue];
        if (curstarttime == nil) {
            [db updateplayRemark:self.start Month:[currentdate getMonthFromDate:self.start] Week:[currentdate getWeekFromDate:self.start] WeekDay:[currentdate getWeekDayFromDate:self.start] Duration:duration Remark:remarktext.text OldStartTime:self.start];
        }
        else
        {
            [db updateplayRemark:curstarttime Month:[currentdate getMonthFromDate:curstarttime] Week:[currentdate getWeekFromDate:curstarttime] WeekDay:[currentdate getWeekDayFromDate:curstarttime] Duration:duration  Remark:remarktext.text OldStartTime:self.start];
            curstarttime = nil;
        }

        //[db updateplayRemark:remarktext.text Starttime:start];
         [self removeFromSuperview];
    }
    else{
    //int duration;
    NSArray *arr=[durationtext.text componentsSeparatedByString:@":"];
       duration=[[arr objectAtIndex:0] intValue]*60*60+[[arr objectAtIndex:1]intValue]*60+[[arr objectAtIndex:2] intValue];
    
    //[db insertplayStarttime:[currentdate getStarttime] Month:[currentdate getMonth] Week:[currentdate getWeek] WeekDay:[currentdate getWeekDay] Duration:(duration) Remark:remarktext.text];
        if (curstarttime == nil) {
            [db insertplayStarttime:[currentdate date] Month:[currentdate getCurrentMonth] Week:[currentdate getCurrentWeek] WeekDay:[currentdate getCurrentWeekDay] Duration:(duration) Remark:remarktext.text];
        }
        else
        {
            [db insertplayStarttime:curstarttime Month:[currentdate getMonthFromDate:curstarttime] Week:[currentdate getWeekFromDate:curstarttime] WeekDay:[currentdate getWeekDayFromDate:curstarttime] Duration:(duration) Remark:remarktext.text];
            curstarttime = nil;
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:@"stop" object:[NSNumber numberWithInt:(duration)]];
    }
    
    [self.playSaveDelegate sendPlaySaveChanged:duration andstarttime:curstarttime];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"justdoit"];

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
            curstarttime = [currentdate getNewDateFromOldDate:picker.date andOldDate:curstarttime];
        }
    }
    else
    {
        if (curstarttime == nil) {
            curstarttime  = [currentdate getNewDateFromOldDate:picker.date andOldDate:self.start];
        }
        else
        {
            curstarttime  = [currentdate getNewDateFromOldDate:picker.date andOldDate:curstarttime];
        }
    }
    
    datetext.text = [currentdate dateFomatdate:curstarttime];
}

-(void)actionsheetShow
{
    action=[[UIActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    if (datepicker==nil) {
        datepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, datetext.frame.origin.y+45, 320, 100)];
        datepicker.datePickerMode=UIDatePickerModeDate;
        [datepicker addTarget:self action:@selector(updatedate:) forControlEvents:UIControlEventValueChanged];
    }
    
    datepicker.frame=CGRectMake(0, 0, 320, 100);
    
    action.bounds=CGRectMake(0, 0, 320, 200);
    [action addSubview:datepicker];
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    if ([window.subviews containsObject:self]) {
        [action showInView:self];
    } else {
        [action showInView:window];
    }
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
            curstarttime = [currentdate getNewDateFromOldTime:picker.date andOldDate:curstarttime];
        }
    }
    else
    {
        if (curstarttime == nil) {
            curstarttime = [currentdate getNewDateFromOldTime:picker.date andOldDate:self.start];
        }
        else
        {
            curstarttime = [currentdate getNewDateFromOldTime:picker.date andOldDate:curstarttime];
        }
    }

    
    starttimetext.text = [currentdate getStarttimefromdate:curstarttime];
}

-(void)actionsheetStartTimeShow
{
    action2=[[UIActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    if (starttimepicker==nil) {
        starttimepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, datetext.frame.origin.y+45, 320, 100)];
        starttimepicker.datePickerMode=UIDatePickerModeTime;
        [starttimepicker addTarget:self action:@selector(updatestarttime:) forControlEvents:UIControlEventValueChanged];
    }
    
    starttimepicker.frame=CGRectMake(0, 0, 320, 100);
    
    action2.bounds=CGRectMake(0, 0, 320, 200);
    [action2 addSubview:starttimepicker];
    [action2 showInView:self.window];
}

-(void)actionsheetDurationShow
{
    action3=[[UIActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    if (durationpicker==nil) {
        durationpicker=[[DurationPickerView alloc]initWithFrame:CGRectMake(0, datetext.frame.origin.y+45, 320, 100)];
    }
    
    durationpicker.delegate   = self;
    durationpicker.dataSource = self;
    durationpicker.showsSelectionIndicator = YES;
    
    [durationpicker selectRow:self.durationmin inComponent:1 animated:NO];
    [durationpicker selectRow:self.durationhour inComponent:0 animated:NO];
    
    durationpicker.frame=CGRectMake(0, 0, 320, 100);
    
    action3.bounds=CGRectMake(0, 0, 320, 200);
    
    [action3 addSubview:durationpicker];
    [action3 showInView:self.window];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (action3 == actionSheet) {
        durationtext.text = [NSString stringWithFormat:@"%02d:%02d:%02d", self.durationhour,self.durationmin,self.durationsec];
    }
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
