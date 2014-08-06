//
//  save_medicineview.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-7-14.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "save_medicineview.h"

@implementation save_medicineview
@synthesize feedway,select,start,isshow,curduration;

-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.foodtype = @"";
        [self  makeSave];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame FeedWay:(NSString*)way Breasttype:(NSString*)type
{
    self.feedway = way;
    self=[self initWithFrame:frame];
    
    return self;
}

-(id)initWithFrame:(CGRect)frame Select:(BOOL)_select Start:(NSDate*)_start Duration:(NSString *)_curduration UpdateTime:(long)updatetime CreateTime:(long)createtime
{
    self.start=_start;
    self.select=_select;
    NSArray *array = [_curduration componentsSeparatedByString:@":"];
    self.durationhour = [[array objectAtIndex:0] intValue];
    self.durationmin  = [[array objectAtIndex:1] intValue];
    self.durationsec  = [[array objectAtIndex:2] intValue];
    
    self.curduration = self.durationhour*60*60 + self.durationmin*60 + self.durationsec;
    _createtime = createtime;
    _updatetime = updatetime;
    NSLog(@"init feed duration:%d",self.curduration);
    
    self=[self initWithFrame:frame];
    return self;
}

-(void)makePickerView
{
    [self addSubview:datepicker];
    datepicker.hidden=YES;
    
}

-(void)makeSave
{
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 290, 30)];
    title.text=NSLocalizedString(@"吃药信息",nil);
    title.textAlignment=NSTextAlignmentCenter;
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[UIColor grayColor];
    title.font = [UIFont systemFontOfSize:20];
    imageview=[[UIImageView alloc]init];
    imageview.bounds=CGRectMake(0, 0, 290, 280+30+10);
    imageview.center=CGPointMake(160, (480-64)/2+30+10);
    [self addSubview:imageview];
    [imageview addSubview:title];
    
    [self makePickerView];
    imageview.backgroundColor=[ACFunction colorWithHexString:@"#f4f4f4"];
    imageview.layer.cornerRadius = 8.0f;
    imageview.userInteractionEnabled=YES;
    [imageview.image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    UILabel *date = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 100, 30)];
    
    UILabel *starttime = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 100, 30)];
    
    UILabel *duration = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, 100, 30)];
    
    UILabel *amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, 100, 30)];

    UILabel *amountDW = [[UILabel alloc]initWithFrame:CGRectMake(115, 160, 100, 30)];

    UILabel *interalLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, 100, 30)];

    UILabel *interaltip = [[UILabel alloc]initWithFrame:CGRectMake(115, 200, 100, 30)];
    
    setNextTimeButton = [[UIButton alloc]initWithFrame:CGRectMake(60, 243, 23, 23)];
    [setNextTimeButton setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [setNextTimeButton setImage:[UIImage imageNamed:@"radio_focus"] forState:UIControlStateHighlighted];
    [setNextTimeButton addTarget:self  action:@selector(SetNextTimeReminder:) forControlEvents:UIControlEventTouchUpInside];
    setNextTimeButton.tag = 101;

    UILabel *setnexttimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 240, 200, 30)];


    date.backgroundColor      = [UIColor clearColor];
    starttime.backgroundColor = [UIColor clearColor];
    duration.backgroundColor  = [UIColor clearColor];
    amountLabel.backgroundColor = [UIColor clearColor];
    amountDW.backgroundColor  = [UIColor clearColor];
    interalLabel.backgroundColor = [UIColor clearColor];
    interaltip.backgroundColor = [UIColor clearColor];
    setnexttimeLabel.backgroundColor = [UIColor clearColor];
    
    date.textColor             = [UIColor grayColor];
    starttime.textColor        = [UIColor grayColor];
    duration.textColor         = [UIColor grayColor];
    amountLabel.textColor      = [UIColor grayColor];
    amountDW.textColor         = [UIColor grayColor];
    interalLabel.textColor     = [UIColor grayColor];
    interaltip.textColor       = [UIColor grayColor];
    setnexttimeLabel.textColor = [UIColor grayColor];
    
    date.text=NSLocalizedString(@"吃药时间",nil);
    starttime.text=NSLocalizedString(@"药品名称",nil);
    duration.text=NSLocalizedString(@"药品描述",nil);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"metric"]==nil) {
        [[NSUserDefaults standardUserDefaults]setObject:@"Oz:" forKey:@"metric" ];
    }
    amountLabel.text = @"每次用量";
    amountDW.text = @"单位";
    interalLabel.text = @"时间间隔";
    interaltip.text = @"小时";
    setnexttimeLabel.text = @"为下一次吃药设置闹钟";
    
    date.textAlignment=NSTextAlignmentRight;
    starttime.textAlignment=NSTextAlignmentRight;
    duration.textAlignment=NSTextAlignmentRight;
    amountLabel.textAlignment = NSTextAlignmentRight;
    amountDW.textAlignment = NSTextAlignmentRight;
    interalLabel.textAlignment = NSTextAlignmentRight;
    interaltip.textAlignment = NSTextAlignmentRight;
    setnexttimeLabel.textAlignment = NSTextAlignmentLeft;
    
    [imageview addSubview:date];
    [imageview addSubview:starttime];
    [imageview addSubview:duration];
    [imageview addSubview:amountLabel];
    [imageview addSubview:amountDW];
    [imageview addSubview:interalLabel];
    [imageview addSubview:interaltip];
    [imageview addSubview:setNextTimeButton];
    [imageview addSubview:setnexttimeLabel];
    
    datetext=[[UITextField alloc]initWithFrame:CGRectMake(115, 40, 150, 30)];
    [datetext setBackground:[UIImage imageNamed:@"panels_input"]];
    datetext.adjustsFontSizeToFitWidth=YES;
    [imageview addSubview:datetext];
    datetext.textColor=[UIColor grayColor];
    
    [datetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [datetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [datetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [datetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    //datetext.enabled=NO;
    datetext.delegate = self;
    datetext.inputView = datepicker;
    
    medicinenametext=[[UITextField alloc]initWithFrame:CGRectMake(115, 80, 150, 30)];
    
    medicinenametext.textColor=[UIColor grayColor];
    [medicinenametext setBackground:[UIImage imageNamed:@"panels_input"]];
    [imageview addSubview:medicinenametext];
    
    [medicinenametext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [medicinenametext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [medicinenametext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [medicinenametext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    medicinenametext.keyboardType=UIKeyboardTypeDefault;
    
    medicinedesptext=[[UITextField alloc]initWithFrame:CGRectMake(115, 120, 150, 30)];
    [medicinedesptext setBackground:[UIImage imageNamed:@"panels_input"]];
    [imageview addSubview:medicinedesptext];
    medicinedesptext.textColor=[UIColor grayColor];;
    
    [medicinedesptext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [medicinedesptext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [medicinedesptext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [medicinedesptext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];

    amounttext=[[UITextField alloc]initWithFrame:CGRectMake(115, 160, 60, 30)];
    [amounttext setBackground:[UIImage imageNamed:@"panels_input"]];
    [imageview addSubview:amounttext];
    amounttext.keyboardType = UIKeyboardTypeDecimalPad;
    amounttext.textColor=[UIColor grayColor];
    
    [amounttext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [amounttext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [amounttext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [amounttext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];

    danweitext=[[UITextField alloc]initWithFrame:CGRectMake(220, 160, 45, 30)];
    [danweitext setBackground:[UIImage imageNamed:@"panels_input"]];
    [imageview addSubview:danweitext];
    danweitext.delegate  = self;
    danweitext.inputView = typelistPickerView;
    danweitext.textColor=[UIColor grayColor];;
    
    [danweitext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [danweitext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [danweitext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [danweitext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];

    timeinternaltext=[[UITextField alloc]initWithFrame:CGRectMake(115, 200, 60, 30)];
    [timeinternaltext setBackground:[UIImage imageNamed:@"panels_input"]];
    [imageview addSubview:timeinternaltext];
    timeinternaltext.textColor=[UIColor grayColor];;
    timeinternaltext.keyboardType = UIKeyboardTypeDecimalPad;
    [timeinternaltext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [timeinternaltext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [timeinternaltext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [timeinternaltext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];

    UIButton *savebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    savebutton.frame=CGRectMake(200, 270+10, 70, 30);
    [savebutton setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    savebutton.layer.cornerRadius = 5.0f;
    [savebutton setTitle:NSLocalizedString(@"Save",nil) forState:UIControlStateNormal];
    [savebutton addTarget:self action:@selector(Save) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:savebutton];
    
    UIButton *canclebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    canclebutton.frame=CGRectMake(20, 270+10, 70, 30);
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
    if (self.select)
    {
        SummaryDB *db  = [SummaryDB dataBase];
        NSArray *array = [db searchFrommedicine:start];
        NSDate *date   = (NSDate*)[array objectAtIndex:0];
        curstarttime   = date;
        datetext.text  = [ACDate dateDetailFomatdate:date];
        medicinedesptext.text=[array objectAtIndex:4];
        medicinenametext.text=[array objectAtIndex:1];
        amounttext.text = [array objectAtIndex:2];
        danweitext.text = [array objectAtIndex:3];
        timeinternaltext.text = [array objectAtIndex:6];
        oldIsReminder = [[array objectAtIndex:5]intValue];
        oldstarttime  = datetext.text;
        oldmedicine   = medicinenametext.text;
        if ([[array objectAtIndex:5]intValue]==0) {
            setNextTimeButton.tag = 101;
            [setNextTimeButton setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
            isReminder = NO;
        }
        else
        {
            setNextTimeButton.tag = 102;
            [setNextTimeButton setImage:[UIImage imageNamed:@"radio_focus"] forState:UIControlStateNormal];
            isReminder = YES;
        }
    }
    else
    {
        curstarttime = [ACDate date];
        datetext.text=[ACDate dateDetailFomatdate:curstarttime];
        medicinedesptext.text=@"";
        medicinenametext.text=@"";
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    for (id key in imageview.subviews) {
        if ([key isKindOfClass:[UITextField class]]) {
            [key resignFirstResponder];
        }
        
        if ([key isKindOfClass:[UIButton class]]) {
            [key resignFirstResponder];
        }
    }
    
    [danweitext resignFirstResponder];
}

-(void)setReminder
{
    //先把之前的删除
    [self deleteReminder];
    
    if (![self checkReminderTime]) {
        return;
    }
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[curstarttime timeIntervalSince1970]];
    long time = [timeSp intValue] + 3600 * timeinternaltext.text.doubleValue;
    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    
    NSLog(@"timeSpln:%lf",timeinternaltext.text.doubleValue); //时间戳的值
    
    NSDate *reminderdate = [NSDate dateWithTimeIntervalSince1970:time];
    
    [ACFunction addLocalNotificationWithMessage:[NSString stringWithFormat:@"您该给宝宝喂食%@%@%@了~",amounttext.text,danweitext.text,medicinenametext.text] FireDate:reminderdate AlarmKey:[NSString stringWithFormat:@"%@_%@", datetext.text,medicinenametext.text]];
}

-(void)deleteReminder
{
      [ACFunction deleteLocalNotification:[NSString stringWithFormat:@"%@_%@",oldstarttime, oldmedicine]];
}

-(BOOL)checkReminderTime
{
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[curstarttime timeIntervalSince1970]];
    long time = [timeSp intValue] + 3600 * timeinternaltext.text.doubleValue;
    
    NSDate *now = [ACDate date];
    NSString *nowtimeSp = [NSString stringWithFormat:@"%ld", (long)[now timeIntervalSince1970]];
    long nowtime = [nowtimeSp intValue];
    
    if (time < nowtime)
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}

- (void)SetNextTimeReminder:(UIButton *)sender
{
    if (sender.tag == 101) {
        if (![self checkReminderTime]) {
            UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"您设置的提醒时间小于当前时间,无法提醒哦~", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
        }
        else
        {
            [sender setImage:[UIImage imageNamed:@"radio_focus"] forState:UIControlStateNormal];
            sender.tag = 102;
            isReminder = YES;
        }
    
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        sender.tag = 101;
        isReminder = NO;
      
    }
}

-(void)Save
{
    BabyDataDB *db=[BabyDataDB babyinfoDB];
    if (select)
    {
        if (curstarttime == nil)
        {
            [db updateMedicineRecord:self.start Month:[ACDate getMonthFromDate:self.start] Week:[ACDate getWeekFromDate:self.start] WeekDay:[ACDate getWeekDayFromDate:self.start]
                            Medicine:medicinenametext.text Description:medicinedesptext.text Amount:amounttext.text Danwei:danweitext.text Timegap:timeinternaltext.text IsReminder:isReminder MoreInfo:@"" CreateTime:_createtime];
        }
        else
        {
            [db updateMedicineRecord:curstarttime Month:[ACDate getMonthFromDate:curstarttime] Week:[ACDate getWeekFromDate:curstarttime] WeekDay:[ACDate getWeekDayFromDate:curstarttime]
                            Medicine:medicinenametext.text Description:medicinedesptext.text Amount:amounttext.text Danwei:danweitext.text Timegap:timeinternaltext.text IsReminder:isReminder MoreInfo:@"" CreateTime:_createtime];
        }
        
        if (isReminder && (oldIsReminder != isReminder))
        {
            [self setReminder];
        }
        else
        {
            if(!isReminder)
            {
                [self deleteReminder];
            }
        }

        
        [self removeFromSuperview];
    }
    else
    {
        if (curstarttime == nil)
        {
            long createtime = [ACDate getTimeStampFromDate:[ACDate date]];
            [db insertBabyMedicineRecord:createtime UpdateTime:createtime StartTime:[ACDate date] Month:[ACDate getCurrentMonth] Week:[ACDate getCurrentWeek] Weekday:[ACDate getCurrentWeekDay] Medicine:medicinenametext.text Description:medicinedesptext.text Amount:amounttext.text Danwei:danweitext.text Timegap:timeinternaltext.text IsReminder:isReminder MoreInfo:@""];
        }
        else
        {
            long createtime = [ACDate getTimeStampFromDate:[ACDate date]];
            self.start = curstarttime;
            [db insertBabyMedicineRecord:createtime UpdateTime:createtime StartTime:curstarttime Month:[ACDate getMonthFromDate:curstarttime] Week:[ACDate getWeekFromDate:curstarttime] Weekday:[ACDate getWeekDayFromDate:curstarttime] Medicine:medicinenametext.text Description:medicinedesptext.text Amount:amounttext.text Danwei:danweitext.text Timegap:timeinternaltext.text IsReminder:isReminder MoreInfo:@""];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:@"stop" object:nil];
        
        if (isReminder) {
            [self setReminder];
        }

    }
    
    
    [self.medicineSaveDelegate sendMedicineReloadData];
    [self.medicineSaveDelegate sendMedicineSaveChanged:medicinenametext.text andAmount:[NSString stringWithFormat:@"%@%@",amounttext.text,danweitext.text] andIsReminder:isReminder andstarttime:self.start];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"justdoit"];
}
-(void)cancle:(UIButton*)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancel" object:sender];
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
    
    if (textField == danweitext) {
        [self actionsheetShowTypeList];
        [danweitext resignFirstResponder];
    }
//    if (textField == medicinenametext) {
//        [self actionsheetStartTimeShow];
//        [medicinenametext resignFirstResponder];
//    }
    
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
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y-135, 320, 460-44-49);
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
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y+135, 320, 460);
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
    curstarttime  = picker.date;
    datetext.text = [ACDate dateDetailFomatdate:curstarttime];
}

-(void)actionsheetShow
{
    action=[[UIActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    if (datepicker==nil) {
        datepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, datetext.frame.origin.y+45, 320, 100)];
        datepicker.datePickerMode=UIDatePickerModeDateAndTime;
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


-(void)actionsheetShowTypeList
{
    actionType=[[UIActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    if (typelistPickerView==nil) {
        typelistPickerView=[[ACTypeListPickerView alloc]initWithFrame:CGRectMake(0, danweitext.frame.origin.y+45, 320, 100) TypeList:@[@"毫升",@"片",@"颗",@"包"]];
        typelistPickerView.typeListPickerViewDelegate = self;
    }
    
    typelistPickerView.frame=CGRectMake(0, 0, 320, 100);
    
    actionType.bounds=CGRectMake(0, 0, 320, 200);
    [actionType addSubview:typelistPickerView];
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    if ([window.subviews containsObject:self]) {
        [actionType showInView:self];
    } else {
        [actionType showInView:window];
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
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
            ret = [NSString stringWithFormat:@"%d %@",number,NSLocalizedString(@"DurationHour", nil)];
            break;
		case 1:
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

-(void)sendTypeListSaveChanged:(NSString*)type
{
    danweitext.text = type;
}

@end
