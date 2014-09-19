//
//  save_diaperview.m
//  Parenting
//
//  Created by user on 13-5-25.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "save_diaperview.h"
#import "DiaperPickerView.h"

@implementation save_diaperview
@synthesize status=_status,select,start,isshow;

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


-(id)initWithFrame:(CGRect)frame Select:(BOOL)_select Start:(NSDate*)_start UpdateTime:(long)updatetime CreateTime:(long)createtime
{
    self.start=_start;
    self.select=_select;
    _createtime = createtime;
    _updatetime = updatetime;
    self=[self initWithFrame:frame];
    return self;
}

-(id)initWithFrame:(CGRect)frame Status:(NSString*)status
{
    self.status=status;
    return [self initWithFrame:frame];
}

-(void)makeSave
{
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 290, 30)];
    title.text=NSLocalizedString(@"Confirm your activity",nil);
    title.textAlignment=NSTextAlignmentCenter;
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[UIColor grayColor];
    imageview=[[UIImageView alloc]init];
    imageview.bounds=CGRectMake(0, 0, 290, 260+30+60+20);
    imageview.center=CGPointMake(160, (460-44-49)/2+30+60+20);
    [self addSubview:imageview];
    [imageview addSubview:title];
    
    [self makeDatePicker];
    
    imageview.backgroundColor=[ACFunction colorWithHexString:@"#f4f4f4"];
    imageview.layer.cornerRadius = 8.0f;
    imageview.userInteractionEnabled=YES;
    [imageview.image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    UILabel *date=[[UILabel alloc]initWithFrame:CGRectMake(10, 40, 100, 30)];
    
    UILabel *starttime=[[UILabel alloc]initWithFrame:CGRectMake(10, 80, 100, 30)];
    
    
    UILabel *remark=[[UILabel alloc]initWithFrame:CGRectMake(10, 120, 100, 30)];
    
    UILabel *Activity=[[UILabel alloc]initWithFrame:CGRectMake(10, 160, 100, 30)];
    
    UILabel *Amount=[[UILabel alloc]initWithFrame:CGRectMake(10, 160+50, 100, 30)];
    
    UILabel *Color=[[UILabel alloc]initWithFrame:CGRectMake(10, 160+50+40, 100, 30)];
    
    if (Hard == nil) {
        Hard = [[UILabel alloc]initWithFrame:CGRectMake(10, 160+50+40+40, 100, 30)];
    }
    
    date.backgroundColor=[UIColor clearColor];
    starttime.backgroundColor=[UIColor clearColor];

    Activity.backgroundColor=[UIColor clearColor];
    remark.backgroundColor=[UIColor clearColor];
    
    Amount.backgroundColor = [UIColor clearColor];
    Color.backgroundColor  = [UIColor clearColor];
    Hard.backgroundColor   = [UIColor clearColor];
    
    date.textColor=[UIColor grayColor];
    starttime.textColor=[UIColor grayColor];
    Activity.textColor=[UIColor grayColor];
    remark.textColor  =[UIColor grayColor];
    Amount.textColor = [UIColor grayColor];
    Color.textColor  = [UIColor grayColor];
    Hard.textColor   = [UIColor grayColor];
    
    date.text=NSLocalizedString(@"Date:",nil);
    starttime.text=NSLocalizedString(@"Start Time:",nil);
    Activity.text=NSLocalizedString(@"Activity:",nil);
    remark.text=NSLocalizedString(@"Comments:",nil);
    Amount.text = @"量:";
    Color.text  = @"颜色:";
    Hard.text   = @"粘稠度:";
    
    dirty=[UIButton buttonWithType:UIButtonTypeCustom];
    dirty.frame=CGRectMake(225, 160, 87/2.0, 87/2.0);
    [dirty setBackgroundImage:[UIImage imageNamed:@"panels_icon_dirty"] forState:UIControlStateNormal];
    [dirty setBackgroundImage:[UIImage imageNamed:@"panels_icon_dirty_choose"] forState:UIControlStateDisabled];
    [imageview addSubview:dirty];
    dirty.tag=201;
    [dirty addTarget:self action:@selector(changeStatus:) forControlEvents:
     UIControlEventTouchUpInside];
    
    dry=[UIButton buttonWithType:UIButtonTypeCustom];
    dry.frame=CGRectMake(115, 160, 87/2.0, 87/2.0);
    [dry setBackgroundImage:[UIImage imageNamed:@"panels_icon_both"] forState:UIControlStateNormal];
    [dry setBackgroundImage:[UIImage imageNamed:@"panels_icon_both_choose"] forState:UIControlStateDisabled];
    [imageview addSubview:dry];
    dry.tag=202;
    [dry addTarget:self action:@selector(changeStatus:) forControlEvents:
     UIControlEventTouchUpInside];
    
    wet=[UIButton buttonWithType:UIButtonTypeCustom];
    wet.frame=CGRectMake(170, 160, 87/2.0, 87/2.0);
    [wet setBackgroundImage:[UIImage imageNamed:@"panels_icon_wet"] forState:UIControlStateNormal];
    [wet setBackgroundImage:[UIImage imageNamed:@"panels_icon_wet_choose"] forState:UIControlStateDisabled];
    [imageview addSubview:wet];
    wet.tag=203;
    [wet addTarget:self action:@selector(changeStatus:) forControlEvents:
     UIControlEventTouchUpInside];
    
    date.textAlignment=NSTextAlignmentRight;
    starttime.textAlignment=NSTextAlignmentRight;
   
    Activity.textAlignment=NSTextAlignmentRight;
    remark.textAlignment=NSTextAlignmentRight;
    
    Amount.textAlignment = NSTextAlignmentRight;
    Color.textAlignment  = NSTextAlignmentRight;
    Hard.textAlignment   = NSTextAlignmentRight;
    
    [imageview addSubview:date];
    [imageview addSubview:starttime];
    [imageview addSubview:Activity];
    [imageview addSubview:remark];
    [imageview addSubview:Amount];
    [imageview addSubview:Color];
    [imageview addSubview:Hard];
    
    datetext=[[UITextField alloc]initWithFrame:CGRectMake(115, 40, 150, 30)];
    [datetext setBackground:[UIImage imageNamed:@"panels_input"]];
    datetext.adjustsFontSizeToFitWidth=YES;
    [imageview addSubview:datetext];
    datetext.delegate = self;
    datetext.inputView = datepicker;
    
    datetext.textColor=[UIColor grayColor];
    
    [datetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [datetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [datetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [datetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    
    starttimetext=[[UITextField alloc]initWithFrame:CGRectMake(115, 80, 150, 30)];
    [starttimetext setBackground:[UIImage imageNamed:@"panels_input"]];
    [imageview addSubview:starttimetext];
    starttimetext.textColor=[UIColor grayColor];
    
    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    starttimetext.delegate = self;
    starttimetext.inputView = starttimepicker;
    
    UIImageView *remarkbg=[[UIImageView alloc]initWithFrame:CGRectMake(115, 120, 150, 30)];
    remarkbg.image=[UIImage imageNamed:@"panels_input"];
    remarkbg.userInteractionEnabled=YES;
    
    remarktext=[[UITextView alloc]initWithFrame:CGRectMake(-2, 0, 140, 30)];
    remarktext.backgroundColor=[UIColor clearColor];
    remarktext.textColor=[UIColor grayColor];
    remarktext.font=[UIFont systemFontOfSize:13];
    [remarkbg addSubview:remarktext];
    [imageview addSubview:remarkbg];
    remarktext.delegate=self;
    
    amounttext=[[UITextField alloc]initWithFrame:CGRectMake(115, 160+10+87/2.0, 150, 30)];
    [amounttext setBackground:[UIImage imageNamed:@"panels_input"]];
    amounttext.adjustsFontSizeToFitWidth=YES;
    [imageview addSubview:amounttext];
    amounttext.delegate = self;
    amounttext.inputView = datepicker;
    
    amounttext.textColor=[UIColor grayColor];
    
    [amounttext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [amounttext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [amounttext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [amounttext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    
    colortext=[[UITextField alloc]initWithFrame:CGRectMake(115, 160+50+87/2.0, 150, 30)];
    [colortext setBackground:[UIImage imageNamed:@"panels_input"]];
    colortext.adjustsFontSizeToFitWidth=YES;
    [imageview addSubview:colortext];
    colortext.delegate = self;
    colortext.inputView = datepicker;
    
    colortext.textColor=[UIColor grayColor];
    
    [colortext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [colortext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [colortext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [colortext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    
    hardtext=[[UITextField alloc]initWithFrame:CGRectMake(115, 160+50+40+87/2.0, 150, 30)];
    [hardtext setBackground:[UIImage imageNamed:@"panels_input"]];
    hardtext.adjustsFontSizeToFitWidth=YES;
    [imageview addSubview:hardtext];
    hardtext.delegate = self;
    hardtext.inputView = datepicker;
    
    hardtext.textColor=[UIColor grayColor];
    
    [hardtext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [hardtext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [hardtext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [hardtext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    
    UIButton *savebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    savebutton.frame=CGRectMake(200, 220+30+60+20, 70, 30);
    [savebutton setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    savebutton.layer.cornerRadius = 5.0f;
    [savebutton setTitle:NSLocalizedString(@"Save",nil) forState:UIControlStateNormal];
    [savebutton addTarget:self action:@selector(Save:) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:savebutton];
    
    UIButton *canclebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    canclebutton.frame=CGRectMake(20, 220+30+60+20, 70, 30);
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

-(void)changeStatus:(UIButton*) sender
{
    switch (sender.tag) {
        case 201:
            self.status = @"BaBa";
            dirty.enabled = NO;
            dry.enabled = YES;
            wet.enabled = YES;
            Hard.hidden = NO;
            hardtext.hidden = NO;
            break;
        case 202:
            self.status = @"XuXuBaBa";
            dirty.enabled = YES;
            dry.enabled   = NO;
            wet.enabled   = YES;
            Hard.hidden = NO;
            hardtext.hidden = NO;
            break;
        case 203:
            self.status = @"XuXu";
            dirty.enabled = YES;
            dry.enabled   = YES;
            wet.enabled   = NO;
            Hard.hidden = YES;
            hardtext.hidden = YES;
            break;
        default:
            break;
    }
}

-(void)loaddata
{
    if (self.select) {
        
        SummaryDB *db=[SummaryDB dataBase];

        NSArray *array= [db searchFromdiaper:self.start];
        NSDate *date=(NSDate*)[array objectAtIndex:0];
        
        self.start = date;
        
        datetext.text=[ACDate dateFomatdate:date];
        
        
        starttimetext.text=[ACDate getStarttimefromdate:date];
        
        
        remarktext.text=[array objectAtIndex:1];
        
        self.status=[array objectAtIndex:2];
        NSLog(@"%@",self.status);
        if ([self.status isEqualToString:@"XuXu"]) {
            wet.enabled=NO;
            Hard.hidden = YES;
            hardtext.hidden = YES;
        }
        else if ([self.status isEqualToString:@"BaBa"])
        {
            dirty.enabled=NO;
            Hard.hidden = NO;
            hardtext.hidden = NO;
        }
        else if([self.status isEqualToString:@"XuXuBaBa"])
        {
            dry.enabled=NO;
            Hard.hidden = NO;
            hardtext.hidden = NO;
        }
        
        self.amount = [array objectAtIndex:3];
        amounttext.text = self.amount;
        self.color  = [array objectAtIndex:4];
        colortext.text = self.color;
        self.hard   = [array objectAtIndex:5];
        hardtext.text = self.hard;
    }
    else
    {
        datetext.text=[ACDate dateFomatdate:[ACDate date]];
        starttimetext.text=[ACDate getStarttimefromdate:[ACDate date]];
        if ([self.status isEqualToString:@"XuXu"]) {
            wet.enabled=NO;
            dry.enabled=YES;
            dirty.enabled=YES;
            
            Hard.hidden = YES;
            hardtext.hidden = YES;
        }
        else if ([self.status isEqualToString:@"BaBa"])
        {
            dirty.enabled=NO;
            dry.enabled=YES;
            wet.enabled=YES;
            Hard.hidden = NO;
            hardtext.hidden = NO;
        }
        else if([self.status isEqualToString:@"XuXuBaBa"])
        {
            dry.enabled=NO;
            wet.enabled=YES;
            dirty.enabled=YES;
            Hard.hidden = NO;
            hardtext.hidden = NO;
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    for (id key in imageview.subviews) {
        if ([key isKindOfClass:[UITextField class]]) {
            [key resignFirstResponder];
        }
    }
    [remarktext resignFirstResponder];
}

-(void)Save:(UIButton*)sender
{
    BabyDataDB *db=[BabyDataDB babyinfoDB];
    if (select)
    {
        if (curstarttime == nil) {
            [db updateDiaperRecord:self.start Month:[ACDate getMonthFromDate:self.start] Week:[ACDate getWeekFromDate:self.start] WeekDay:[ACDate getWeekDayFromDate:self.start] Status:self.status Amount:self.amount Color:self.color Hard:self.hard Remark:remarktext.text MoreInfo:@"" CreateTime:_createtime];
        }
        else
        {
            [db updateDiaperRecord:curstarttime Month:[ACDate getMonthFromDate:curstarttime] Week:[ACDate getWeekFromDate:curstarttime] WeekDay:[ACDate getWeekDayFromDate:curstarttime] Status:self.status Amount:self.amount Color:self.color Hard:self.hard Remark:remarktext.text MoreInfo:@"" CreateTime:_createtime];
        }
        
        [self removeFromSuperview];
    }
    else{
        if (!self.status) {
            self.status=@"";
        }
        
        if (curstarttime == nil) {
            long createtime = [ACDate getTimeStampFromDate:[NSDate date]];
            [db insertBabyDiaperRecord:createtime UpdateTime:createtime StartTime:[ACDate date] Month:[ACDate getCurrentMonth] Week:[ACDate getCurrentWeek] Weekday:[ACDate getCurrentWeekDay] Status:self.status Amount:self.amount Color:self.color Hard:self.hard Remark:remarktext.text MoreInfo:@""];
        }
        else
        {
            long createtime = [ACDate getTimeStampFromDate:[NSDate date]];
            [db insertBabyDiaperRecord:createtime UpdateTime:createtime StartTime:curstarttime Month:[ACDate getMonthFromDate:curstarttime] Week:[ACDate getWeekFromDate:curstarttime] Weekday:[ACDate getWeekDayFromDate:curstarttime] Status:self.status Amount:self.amount Color:self.color Hard:self.hard Remark:remarktext.text MoreInfo:@""];

            curstarttime = nil;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stop" object:nil];
        
        [self.diaperSaveDelegate sendDiaperReloadData];
    }
    
    //自动上传数据
    //[UpLoadController checkDiaperUpload:1];
    
    [self.diaperSaveDelegate sendDiaperSaveChanged:self.status andstarttime:self.start];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"justdoit"];
}

-(void)cancle:(UIButton*)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancel" object:nil];
    [self removeFromSuperview];
}

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
    
    [action2 show];}


-(void)actionsheetDiaperPickerAmout
{
    if (action3 == nil) {
        action3 = [[CustomIOS7AlertView alloc] init];
        [action3 setContainerView:[self createAmountSelectView]];
        [action3 setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
        [action3 setDelegate:self];
    }

   [action3 show];
}

-(void)actionsheetDiaperPickerColor
{
    if (action4 == nil) {
        action4 = [[CustomIOS7AlertView alloc] init];
        [action4 setContainerView:[self createColorSelectView]];
        [action4 setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
        [action4 setDelegate:self];
    }
    
    [action4 show];
}

-(void)actionsheetDiaperPickerHard
{
    if (action5 == nil) {
        action5 = [[CustomIOS7AlertView alloc] init];
        [action5 setContainerView:[self createHardSelectView]];
        [action5 setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
        [action5 setDelegate:self];
    }
    
    [action5 show];
}

#pragma mark - CustomIOS7AlertView delegate
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    // 确定
    if (buttonIndex == 1)
    {
        if (alertView == action3) {
            amounttext.text = [NSString stringWithFormat:@"%@", self.amount];
        }
        
        if (alertView == action4) {
            colortext.text = [NSString stringWithFormat:@"%@", self.color];
        }
        
        if (alertView == action5) {
            hardtext.text = [NSString stringWithFormat:@"%@", self.hard];
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

- (DiaperPickerView *)createAmountSelectView
{
    if (diaperPickerView1==nil)
    {
        diaperPickerView1 = [[DiaperPickerView alloc]initWithFrame:CGRectMake(0, amounttext.frame.origin.y+45, 320, 162) Type:DIAPER_TYPE_AMOUNT Option:DIAPER_OPTION_XUXU];
        diaperPickerView1.diaperPickerViewDelegate = self;
    }
    
    if ([self.amount isEqualToString:@"无"]) {
        [diaperPickerView1 selectRow:0 inComponent:0 animated:YES];
    }
    else if ([self.amount isEqualToString:@"少量"])
    {
        [diaperPickerView1 selectRow:1 inComponent:0 animated:YES];
    }
    else if ([self.amount isEqualToString:@"正常"])
    {
        [diaperPickerView1 selectRow:2 inComponent:0 animated:YES];
    }
    else if ([self.amount isEqualToString:@"很多"])
    {
        [diaperPickerView1 selectRow:3 inComponent:0 animated:YES];
    }
    else if ([self.amount isEqualToString:@"溢出"])
    {
        [diaperPickerView1 selectRow:4 inComponent:0 animated:YES];
    }
    else
    {
        [diaperPickerView1 selectRow:0 inComponent:0 animated:YES];
        self.amount = @"无";
    }
    
    diaperPickerView1.showsSelectionIndicator = YES;
    diaperPickerView1.frame=CGRectMake(0, 0, 320, 162);
    
    return diaperPickerView1;
}

-(DiaperPickerView*)createColorSelectView
{
    if (diaperPickerView2==nil) {
        diaperPickerView2 = [[DiaperPickerView alloc]initWithFrame:CGRectMake(0, colortext.frame.origin.y+45, 320, 162) Type:DIAPER_TYPE_COLOR Option:DIAPER_OPTION_XUXU];
        diaperPickerView2.diaperPickerViewDelegate = self;
    }
    
    if ([self.color isEqualToString:@"透明"]) {
        [diaperPickerView2 selectRow:0 inComponent:0 animated:YES];
    }
    else if ([self.color isEqualToString:@"较淡"])
    {
        [diaperPickerView2 selectRow:1 inComponent:0 animated:YES];
    }
    else if ([self.color isEqualToString:@"偏黄"])
    {
        [diaperPickerView2 selectRow:2 inComponent:0 animated:YES];
    }
    else if ([self.color isEqualToString:@"较黄"])
    {
        [diaperPickerView2 selectRow:3 inComponent:0 animated:YES];
    }
    else if ([self.color isEqualToString:@"深黄"])
    {
        [diaperPickerView2 selectRow:4 inComponent:0 animated:YES];
    }
    else
    {
        [diaperPickerView2 selectRow:0 inComponent:0 animated:YES];
        self.color = @"透明";
    }
    
    diaperPickerView2.showsSelectionIndicator = YES;
    
    diaperPickerView2.frame=CGRectMake(0, 0, 320, 162);
    return diaperPickerView2;
}

-(DiaperPickerView*)createHardSelectView
{
    if (diaperPickerView3==nil) {
        diaperPickerView3 = [[DiaperPickerView alloc]initWithFrame:CGRectMake(0, hardtext.frame.origin.y+45, 320, 162) Type:DIAPER_TYPE_HARD Option:DIAPER_OPTION_XUXU];
        diaperPickerView3.diaperPickerViewDelegate = self;
    }
    
    if ([self.hard isEqualToString:@"水样"]) {
        [diaperPickerView3 selectRow:0 inComponent:0 animated:YES];
    }
    else if ([self.hard isEqualToString:@"较稀"])
    {
        [diaperPickerView3 selectRow:1 inComponent:0 animated:YES];
    }
    else if ([self.hard isEqualToString:@"正常"])
    {
        [diaperPickerView3 selectRow:2 inComponent:0 animated:YES];
    }
    else if ([self.hard isEqualToString:@"软干硬"])
    {
        [diaperPickerView3 selectRow:3 inComponent:0 animated:YES];
    }
    else if ([self.hard isEqualToString:@"很干硬"])
    {
        [diaperPickerView3 selectRow:4 inComponent:0 animated:YES];
    }
    else
    {
        [diaperPickerView3 selectRow:0 inComponent:0 animated:YES];
        self.hard = @"水样";
    }
    
    diaperPickerView3.showsSelectionIndicator = YES;
    diaperPickerView3.frame=CGRectMake(0, 0, 320, 162);
    
    return diaperPickerView3;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
   
}

-(void)makeDatePicker
{
    [self addSubview:datepicker];
    datepicker.hidden=YES;
    
    [self addSubview:starttimepicker];
    starttimepicker.hidden = YES;
    
    [self addSubview:diaperPickerView1];
    diaperPickerView1.hidden = YES;
    
    [self addSubview:diaperPickerView2];
    diaperPickerView2.hidden = YES;
    
    [self addSubview:diaperPickerView3];
    diaperPickerView3.hidden = YES;
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
    
    if (textField == amounttext) {
        [self actionsheetDiaperPickerAmout];
        [amounttext resignFirstResponder];
    }
    
    if (textField == colortext) {
        [self actionsheetDiaperPickerColor];
        [colortext resignFirstResponder];
    }
    
    if (textField == hardtext) {
        [self actionsheetDiaperPickerHard];
        [hardtext resignFirstResponder];
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
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-150, 320, 460);
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
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+150, 320, 460);
        [UIView commitAnimations];
        self.isshow=NO;
    }
}

- (void)keyboardWillShown:(NSNotification*)aNotification
{
    [self keyboradshow];
}

-(void)keyboardWillHidden:(NSNotification*)aNotification
{
    [self keyboradhidden];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(void)sendDiaperSaveChanged:(int)type NewStatus:(NSString*)newstatus
{
    if (type == DIAPER_TYPE_AMOUNT)
    {
        self.amount = newstatus;
    }
    else if (type == DIAPER_TYPE_COLOR)
    {
        self.color = newstatus;
    }
    else
    {
        self.hard  = newstatus;
    }
}


@end
