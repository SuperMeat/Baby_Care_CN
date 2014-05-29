//
//  save_feedview.m
//  Parenting
//
//  Created by user on 13-5-25.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "save_feedview.h"
@implementation save_feedview
@synthesize feedway,select,start,breast,isshow,curduration;

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
    self.breast  = type;
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
    
    [self addSubview:starttimepicker];
    starttimepicker.hidden = YES;
    
    [self addSubview:foodtypepicker];
    foodtypepicker.hidden = YES;
    
}

-(void)makeSave
{
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 290, 30)];
    title.text=NSLocalizedString(@"Confirm your activity",nil);
    title.textAlignment=NSTextAlignmentCenter;
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[UIColor grayColor];
    imageview=[[UIImageView alloc]init];
    imageview.bounds=CGRectMake(0, 0, 290, 280+30+40);
    imageview.center=CGPointMake(160, (480-64)/2+30+40);
    [self addSubview:imageview];
    [imageview addSubview:title];
    
    [self makePickerView];
    imageview.backgroundColor=[ACFunction colorWithHexString:@"#f4f4f4"];
    //imageview.backgroundColor = [UIColor redColor];
    imageview.layer.cornerRadius = 8.0f;
    imageview.userInteractionEnabled=YES;
    [imageview.image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    UILabel *date = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 100, 30)];
    
    UILabel *starttime = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 100, 30)];
    
    UILabel *duration = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, 100, 30)];
    
    foodtypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,200, 100,30)];
    
    
    remark = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    Oz = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, 100, 30)];
    
    date.backgroundColor      = [UIColor clearColor];
    starttime.backgroundColor = [UIColor clearColor];
    duration.backgroundColor  = [UIColor clearColor];
    Oz.backgroundColor        = [UIColor clearColor];
    remark.backgroundColor    = [UIColor clearColor];
    foodtypeLabel.backgroundColor    = [UIColor clearColor];
    
    date.textColor=[UIColor grayColor];
    starttime.textColor=[UIColor grayColor];
    duration.textColor=[UIColor grayColor];
    Oz.textColor=[UIColor grayColor];
    foodtypeLabel.textColor=[UIColor grayColor];
    remark.textColor=[UIColor grayColor];
    
    date.text=NSLocalizedString(@"Date:",nil);
    starttime.text=NSLocalizedString(@"Start Time:",nil);
    duration.text=NSLocalizedString(@"Duration:",nil);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"metric"]==nil) {
        [[NSUserDefaults standardUserDefaults]setObject:@"Oz:" forKey:@"metric" ];
    }
    foodtypeLabel.text = @"食物类型:";
   
    Oz.text=NSLocalizedString([[NSUserDefaults standardUserDefaults] objectForKey:@"metric"],nil);
    remark.text=NSLocalizedString(@"Comments:",nil);
    date.textAlignment=NSTextAlignmentRight;
    starttime.textAlignment=NSTextAlignmentRight;
    duration.textAlignment=NSTextAlignmentRight;
    Oz.textAlignment=NSTextAlignmentRight;
    remark.textAlignment=NSTextAlignmentRight;
    foodtypeLabel.textAlignment = NSTextAlignmentRight;
    
    [imageview addSubview:date];
    [imageview addSubview:starttime];
    [imageview addSubview:duration];
    [imageview addSubview:Oz];
    [imageview addSubview:remark];
    [imageview addSubview:foodtypeLabel];
    
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
    
    starttimetext=[[UITextField alloc]initWithFrame:CGRectMake(115, 80, 150, 30)];
    
    starttimetext.textColor=[UIColor grayColor];
    [starttimetext setBackground:[UIImage imageNamed:@"panels_input"]];
    [imageview addSubview:starttimetext];
    
    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    //starttimetext.enabled=NO;
    starttimetext.delegate  = self;
    starttimetext.inputView = starttimepicker;
    
    durationtext=[[UITextField alloc]initWithFrame:CGRectMake(115, 120, 150, 30)];
    [durationtext setBackground:[UIImage imageNamed:@"panels_input"]];
    [imageview addSubview:durationtext];
    durationtext.textColor=[UIColor grayColor];;

    [durationtext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [durationtext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [durationtext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [durationtext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    //durationtext.enabled=NO;
    durationtext.delegate  = self;
    durationtext.inputView = durationpicker;
    hours   = [NSMutableArray arrayWithCapacity:100];
    for (int i=0; i<24; i++) {
        [hours addObject:[NSNumber numberWithInt:i]];
    }
    minutes = [NSMutableArray arrayWithCapacity:100];
    for (int j=0; j<60; j++) {
        [minutes addObject:[NSNumber numberWithInt:j]];
    }

    remarkbg=[[UIImageView alloc]initWithFrame:CGRectMake(115, 200, 150, 60)];
    remarkbg.image=[UIImage imageNamed:@"panels_input"];
    remarkbg.userInteractionEnabled=YES;
    
    remarktext=[[UITextView alloc]initWithFrame:CGRectMake(-2, 0, 160, 60)];
    remarktext.backgroundColor=[UIColor clearColor];
    remarktext.textColor=[UIColor grayColor];;
    [remarkbg addSubview:remarktext];
    [imageview addSubview:remarkbg];
    remarktext.delegate=self;
    [remarktext setFont:[UIFont systemFontOfSize:13]];

    Oztext=[[UITextField alloc]initWithFrame:CGRectMake(115, 160, 150, 30)];
    [Oztext setBackground:[UIImage imageNamed:@"panels_input"]];
    [imageview addSubview:Oztext];
    Oztext.textColor=[UIColor grayColor];
    Oztext.delegate=self;
    [Oztext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [Oztext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [Oztext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [Oztext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    Oztext.keyboardType=UIKeyboardTypeNumberPad;
    
    foodtypetext=[[UITextField alloc]initWithFrame:CGRectMake(115, 200, 150, 30)];
    [foodtypetext setBackground:[UIImage imageNamed:@"panels_input"]];
    [imageview addSubview:foodtypetext];
    foodtypetext.textColor=[UIColor grayColor];
    foodtypetext.delegate=self;
    [foodtypetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [foodtypetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [foodtypetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [foodtypetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    foodtypetext.keyboardType=UIKeyboardTypeNumberPad;

    
    left=[[UILabel alloc]initWithFrame:CGRectMake(115, 200-30, 50, 20)];
    left.text=NSLocalizedString(@"Left",nil);
    left.backgroundColor=[UIColor clearColor];
    left.textColor=[UIColor grayColor];
    [imageview addSubview:left];
    
    right=[[UILabel alloc]initWithFrame:CGRectMake(215, 200-30, 50, 20)];
    right.textColor=[UIColor grayColor];
    right.text=NSLocalizedString(@"Right",nil);
    right.backgroundColor=[UIColor clearColor];
    [imageview addSubview:right];
    
    leftbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame=CGRectMake(80, 200-30, 20, 20);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"radio.png"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"radio_focus.png"] forState:UIControlStateDisabled];
    [imageview addSubview:leftbutton];
    leftbutton.highlighted=NO;
    leftbutton.tag=1001;
    [leftbutton addTarget:self action:@selector(leftOrright:) forControlEvents:UIControlEventTouchUpInside];
    
    rightbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame=CGRectMake(180, 200-30, 20, 20);
    [rightbutton setBackgroundImage:[UIImage imageNamed:@"radio.png"] forState:UIControlStateNormal];
    [rightbutton setBackgroundImage:[UIImage imageNamed:@"radio_focus.png"] forState:UIControlStateDisabled];
    [imageview addSubview:rightbutton];
    rightbutton.highlighted=NO;
    rightbutton.tag=1002;
    [rightbutton addTarget:self action:@selector(leftOrright:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *savebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    savebutton.frame=CGRectMake(200, 270+40, 70, 30);
    [savebutton setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    savebutton.layer.cornerRadius = 5.0f;
    [savebutton setTitle:NSLocalizedString(@"Save",nil) forState:UIControlStateNormal];
    [savebutton addTarget:self action:@selector(Save) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:savebutton];
    
    UIButton *canclebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    canclebutton.frame=CGRectMake(20, 270+40, 70, 30);
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
        NSArray *array= [db searchFromfeed:start];
        NSDate *date=(NSDate*)[array objectAtIndex:0];
        
        datetext.text=[ACDate dateFomatdate:date];
        NSLog(@"%d",  [[array objectAtIndex:1] intValue] );
        
        durationtext.text=[ACDate getDurationfromdate:date second:[[array objectAtIndex:1] intValue] ] ;
        NSArray *array2 = [durationtext.text componentsSeparatedByString:@":"];
        
        self.durationhour = [[array2 objectAtIndex:0] intValue];
        self.durationmin  = [[array2 objectAtIndex:1] intValue];
        self.durationsec  = [[array2 objectAtIndex:2] intValue];
        
        starttimetext.text=[ACDate getStarttimefromdate:date];
        
        
        remarktext.text=[array objectAtIndex:4];
        self.foodtype = [array objectAtIndex:5];
        foodtypetext.text = self.foodtype;
        if ([[array objectAtIndex:2] intValue]==0) {
            Oz.hidden=NO;
            Oztext.text=[array objectAtIndex:3];
            Oztext.hidden=NO;
            leftbutton.hidden=YES;
            rightbutton.hidden=YES;
            left.hidden=YES;
            right.hidden=YES;
            remarkbg.center = CGPointMake(115+150/2.0, 200+60/2.0+40);
            remark.center   = CGPointMake(10+100/2.0, 200+30/2.0+40);
            foodtypetext.hidden = NO;
            foodtypeLabel.hidden = NO;
        }
        else
        {
            Oz.hidden=YES;
            Oztext.hidden=YES;
            leftbutton.hidden=NO;
            rightbutton.hidden=NO;
            left.hidden=NO;
            right.hidden=NO;
            foodtypeLabel.hidden = YES;
            foodtypetext.hidden = YES;
            remarkbg.center = CGPointMake(115+150/2.0, 200+60/2.0);
            remark.center   = CGPointMake(10+100/2.0, 200+30/2.0);
            if ([[array objectAtIndex:3] isEqual:@"left"]) {
                leftbutton.enabled=NO;
                rightbutton.enabled=YES;
            }
            else
            {
                leftbutton.enabled=YES;
                rightbutton.enabled=NO;
            }
        }
        
    }
    
    else
    {
        if ([self.feedway isEqualToString:@"bottle"]) {
            rightbutton.hidden=YES;
            leftbutton.hidden = YES;
            left.hidden=YES;
            right.hidden=YES;
            Oz.hidden=NO;
            Oztext.hidden=NO;
            foodtypeLabel.hidden = NO;
            foodtypetext.hidden = NO;

            remarkbg.center = CGPointMake(115+150/2.0, 200+60/2.0+40);
            remark.center   = CGPointMake(10+100/2.0, 200+30/2.0+40);
        }
        else{
            
            Oz.hidden=YES;
            Oztext.hidden=YES;
            leftbutton.hidden=NO;
            rightbutton.hidden=NO;
            left.hidden=NO;
            right.hidden=NO;
            foodtypeLabel.hidden = YES;
            foodtypetext.hidden = YES;

            remarkbg.center = CGPointMake(115+150/2.0, 200+60/2.0);
            remark.center   = CGPointMake(10+100/2.0, 200+30/2.0);
        }
        if ([self.breast isEqualToString:@"left"]) {
            leftbutton.enabled=NO;
            rightbutton.enabled=YES;
        }
        else
        {
            rightbutton.enabled=NO;
            leftbutton.enabled=YES;
        }
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

        if ([key isKindOfClass:[UIButton class]]) {
            [key resignFirstResponder];
        }
    }
    [remarktext resignFirstResponder];
    [foodtypetext resignFirstResponder];
}

-(void)Save
{
    BabyDataDB *db=[BabyDataDB babyinfoDB];
    int duration;
    NSArray *arr=[durationtext.text componentsSeparatedByString:@":"];
    duration=[[arr objectAtIndex:0] intValue]*60*60+[[arr objectAtIndex:1]intValue]*60+[[arr objectAtIndex:2] intValue];
    int way;
    UIButton *leftbtn=(UIButton *)[self viewWithTag:1001];
    NSString *oz;
    if ([self.feedway isEqualToString:@"bottle"]) {
        way=0;
        
        if (![Oztext.text length]>0) {
//            UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"FeedSaveTips", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alter show];
//            return;
            Oztext.text = @"0";
        }
        
        oz=Oztext.text;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"metric"] isEqualToString:@"Mls:"]) {
            oz=[NSString stringWithFormat:@"%@ml", oz];
        }
        else
        {
            oz=[NSString stringWithFormat:@"%@oz", oz];
        }

    }
    else
    {
        way=1;
        
        if (leftbtn.enabled) {
            oz=@"left";
        }
        else
        {
            oz=@"right";
        }

    }

    if (select) {
        if (Oztext.hidden) {
            if (leftbtn.enabled) {
                oz=@"left";
            }
            else
            {
                oz=@"right";
            }
        }
        else
        {
            oz=Oztext.text;
        }
        
        NSArray *array = [durationtext.text componentsSeparatedByString:@":"];
        duration = [[array objectAtIndex:0] intValue]*60*60 + [[array objectAtIndex:1]intValue]*60+[[array objectAtIndex:2]intValue];
        if (curstarttime == nil) {
            [db updateFeedRecord:self.start
                           Month:[ACDate getMonthFromDate:self.start]
                            Week:[ACDate getWeekFromDate:self.start]
                         WeekDay:[ACDate getWeekDayFromDate:self.start]
                        Duration:duration
                              Oz:Oztext.text
                        FoodType:self.foodtype
                          Remark:remarktext.text
                        MoreInfo:@""
                      CreateTime:_createtime];
        }
        else
        {
            [db updateFeedRecord:curstarttime
                           Month:[ACDate getMonthFromDate:curstarttime]
                            Week:[ACDate getWeekFromDate:curstarttime]
                         WeekDay:[ACDate getWeekDayFromDate:curstarttime]
                        Duration:duration
                              Oz:Oztext.text
                        FoodType:self.foodtype
                          Remark:remarktext.text
                        MoreInfo:@""
                      CreateTime:_createtime];

            curstarttime = nil;
        }

        [self removeFromSuperview];
    }
    
    else
    {
        if (curstarttime == nil)
        {
            long createtime = [ACDate getTimeStampFromDate:[ACDate date]];
            [db insertBabyFeedRecord:createtime
                          UpdateTime:createtime
                           StartTime:[ACDate date]
                               Month:[ACDate getCurrentMonth]
                                Week:[ACDate getCurrentWeek]
                             Weekday:[ACDate getCurrentWeekDay]
                            Duration:duration
                                  Oz:oz
                            FeedType:[NSString stringWithFormat:@"%d",way]
                            FoodType:self.foodtype
                              Remark:remarktext.text
                            MoreInfo:@""];
        }
        else
        {
            long createtime = [ACDate getTimeStampFromDate:[ACDate date]];
            [db insertBabyFeedRecord:createtime
                          UpdateTime:createtime
                           StartTime:curstarttime
                               Month:[ACDate getMonthFromDate:curstarttime]
                                Week:[ACDate getWeekFromDate:curstarttime]
                             Weekday:[ACDate getWeekDayFromDate:curstarttime]
                            Duration:duration
                                  Oz:oz
                            FeedType:[NSString stringWithFormat:@"%d",way]
                            FoodType:self.foodtype
                              Remark:remarktext.text
                            MoreInfo:@""];

            curstarttime = nil;
        }

        [self.feedSaveDelegate sendFeedReloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stop" object:[NSNumber numberWithInt:duration]];
    }
    
    
    [self.feedSaveDelegate sendFeedSaveChanged:duration andstarttime:curstarttime];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"justdoit"];
}
-(void)cancle:(UIButton*)sender
{
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancel" object:sender];
}


-(void)leftOrright:(UIButton *)sender
{
    sender.enabled=NO;
    UIButton *another;
    if (sender.tag==1001) {
        another=(UIButton*)[self viewWithTag:1002];
  
    }
    else
    {
        another=(UIButton*)[self viewWithTag:1001];
        
    }
    another.enabled=YES;
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
    
    if (textField == foodtypetext)
    {
        [self actionsheetFoodTypePicker];
        [foodtypetext resignFirstResponder];
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
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y+150, 320, 460);
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
        durationpicker=[[DurationPickerView alloc]initWithFrame:CGRectMake(0, datetext.frame.origin.y, 320, 162)];
    }
    
    durationpicker.delegate   = self;
    durationpicker.dataSource = self;
    durationpicker.showsSelectionIndicator = YES;
    durationpicker.frame=CGRectMake(0, 0, 320, 162);
    [durationpicker selectRow:self.durationmin inComponent:1 animated:NO];
    [durationpicker selectRow:self.durationhour inComponent:0 animated:NO];
    
    action3.bounds=CGRectMake(0, 0, 320, 200);
    
    [action3 addSubview:durationpicker];
    [action3 showInView:self.window];
}

-(void)actionsheetFoodTypePicker
{
    action4=[[UIActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    if (foodtypepicker==nil) {
        foodtypepicker = [[FoodTypePickerView alloc]initWithFrame:CGRectMake(0, foodtypetext.frame.origin.y+45, 320, 162) Type:@""];
        foodtypepicker.foodTypePickerViewDelegate = self;
    }
    
    if ([self.foodtype isEqualToString:@"母乳"]) {
        [foodtypepicker selectRow:0 inComponent:0 animated:YES];
    }
    else if ([self.foodtype isEqualToString:@"奶粉"])
    {
        [foodtypepicker selectRow:1 inComponent:0 animated:YES];
    }
    else if ([self.foodtype isEqualToString:@"水"])
    {
        [foodtypepicker selectRow:2 inComponent:0 animated:YES];
    }
    else if ([self.foodtype isEqualToString:@"辅食"])
    {
        [foodtypepicker selectRow:3 inComponent:0 animated:YES];
    }
    else
    {
        [foodtypepicker selectRow:0 inComponent:0 animated:YES];
        self.foodtype = @"母乳";
    }
    
    foodtypepicker.showsSelectionIndicator = YES;
    foodtypepicker.frame=CGRectMake(0, 0, 320, 162);
    
    action4.bounds=CGRectMake(0, 0, 320, 200);
    [action4 addSubview:foodtypepicker];
    [action4 showInView:self.window];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (actionSheet == action3) {
        durationtext.text = [NSString stringWithFormat:@"%02d:%02d:%02d", self.durationhour,self.durationmin,self.durationsec];
    }
    
    if (actionSheet == action4)
    {
        foodtypetext.text = self.foodtype;
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

#pragma -mark foodtypepickerviewdele gate
-(void)sendFeedTypeSaveChanged:(NSString*)type
{
    self.foodtype = type;
}
@end
