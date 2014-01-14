//
//  CustomNotifyViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-18.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import "CustomNotifyViewController.h"
#import "CustonTimeViewController.h"
#import "AlarmKey.h"
@interface CustomNotifyViewController ()

@end

@implementation CustomNotifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Custom initialization
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 100, 20)];
        titleView.backgroundColor=[UIColor clearColor];
        UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        titleText.backgroundColor = [UIColor clearColor];
        [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
        titleText.textColor = [UIColor whiteColor];
        [titleText setTextAlignment:NSTextAlignmentCenter];
        [titleText setText:NSLocalizedString(@"自定义消息", nil)];
        [titleView addSubview:titleText];
        
        self.navigationItem.titleView = titleView;
        self.hidesBottomBarWhenPushed=YES;
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ( IOS7_OR_LATER )
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70
        if (self.ln == nil) {
            self.ln = [[LocalNotify alloc] init];
        }
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.ln.createtime != NULL) {
       [self changelocalnotify];
        [DataBase updateNotifyTime:self.ln.createtime andNotifyTime:self.ln.time andRedundant:self.ln.redundant andTitle:self.ln.title];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    [self.myScrollView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    self.myScrollView.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+50) ;
    [self.myScrollView setScrollEnabled:YES];
    _myScrollView.showsHorizontalScrollIndicator=NO;
    self.myScrollView.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    [self.view addSubview:self.myScrollView];
    
    hours   = [NSMutableArray arrayWithCapacity:100];
    for (int i=0; i<24; i++) {
        [hours addObject:[NSNumber numberWithInt:i]];
    }
    minutes = [NSMutableArray arrayWithCapacity:100];
    for (int j=0; j<60; j++) {
        [minutes addObject:[NSNumber numberWithInt:j]];
    }
 
    self.btnredundant.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [self.textfieldTimeTip setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [self.textfieldTimeTip setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [self.textfieldTimeTip setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [self.textfieldTimeTip setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    self.textfieldTimeTip.userInteractionEnabled = YES;
    [self.textfieldTimeTip setTextColor:[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0]];
    self.textfieldTimeTip.delegate = self;
    
    [self.textfieldTitleTip setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [self.textfieldTitleTip setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [self.textfieldTitleTip setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [self.textfieldTitleTip setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    self.textfieldTitleTip.userInteractionEnabled = YES;
    [self.textfieldTitleTip setTextColor:[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0]];
    
    [self.btnredundant.titleLabel setTextAlignment:NSTextAlignmentCenter];

    
    if (self.ln.createtime != nil) {
        self.textfieldTitleTip.text = self.ln.title;
        self.textfieldTimeTip.text  = self.ln.time;
        
        if (self.labelredundant == nil) {
            self.labelredundant = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 45)];
        }
        
        if (self.ln.redundant != nil && [self.ln.redundant isEqualToString:@"永不"] == NO) {
            NSMutableString *lnStr = [NSMutableString stringWithCapacity:100];
            [lnStr appendString:@"每周"];
            [lnStr appendString:self.ln.redundant];
            
            [self.labelredundant setTextAlignment:NSTextAlignmentCenter];
            [self.labelredundant setTextColor:[UIColor colorWithRed:0.906 green:0.623 blue:0.599 alpha:1.000]];
            [self.labelredundant setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:15]];
            [self.labelredundant setBackgroundColor:[UIColor clearColor]];
            if ([self.ln.redundant isEqualToString:@"日,六,"]==YES) {
               [self.labelredundant setText:@"周末"];
            }
            else if ([self.ln.redundant isEqualToString:@"一,二,三,四,五,"]==YES)
            {
                [self.labelredundant setText:@"工作日"];
            }
            else if ([self.ln.redundant isEqualToString:@"日,一,二,三,四,五,六,"]==YES)
            {
                [self.labelredundant setText:@"每天"];
            }
            else
            {
              [self.labelredundant setText:[lnStr substringToIndex:([lnStr length]-1)]];
            }
            
            [self.btnredundant addSubview:self.labelredundant];
            
            self.btnredundant.titleLabel.text = @"";
        }
        else
        {
            self.btnredundant.titleLabel.text = @"永不";
        }
    }
    
    UIButton *deletebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [deletebutton setBackgroundImage:[UIImage imageNamed:@"task_top_delet"] forState:UIControlStateNormal];
    
    [deletebutton addTarget:self action:@selector(deletenotify) forControlEvents:UIControlEventTouchUpInside];
    deletebutton.frame=CGRectMake(0, 0, 30, 30);
    
    
    UIBarButtonItem *rightbar=[[UIBarButtonItem alloc]initWithCustomView:deletebutton];
    self.navigationItem.rightBarButtonItem=rightbar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)deletenotify
{
    UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"你是否要删除该提醒?", nil) delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是",nil];
    [alter show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //先取消所有
        NSArray* delarray = [[NSArray alloc]initWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
        for (NSString *str in delarray) {
            NSString *key = [NSString stringWithFormat:@"%@%@", self.ln.createtime, str];
            [OpenFunction deleteLocalNotification:key];
        }

        [DataBase deleteNotifyTime:self.ln.createtime];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)save:(UIButton *)sender
{
    self.ln.title     = self.textfieldTitleTip.text;
    self.ln.time      = self.textfieldTimeTip.text;
    
    if (self.ln.title != nil && self.ln.time != nil)
    {
        if (self.ln.redundant != nil && [self.ln.redundant isEqualToString:@"永不"]==NO) {
            if (self.ln.createtime != nil)
            {
                [self changelocalnotify];
            }
            
            if (self.ln.createtime == nil)
            {
                NSDate* createtime = [currentdate date];
                self.ln.createtime = createtime;
                [self changelocalnotify];
                [DataBase insertNotifyTime:self.ln.createtime andNotifyTime:self.ln.time andRedundant:self.ln.redundant andTitle:self.ln.title];
            }
            else
            {
                [self changelocalnotify];
                [DataBase updateNotifyTime:self.ln.createtime andNotifyTime:self.ln.time andRedundant:self.ln.redundant andTitle:self.ln.title];
            }
        }
        
        if (self.ln.redundant == nil || [self.ln.redundant isEqualToString:@"永不"] == YES) {
            if (self.ln.createtime == nil)
            {
                NSDate* createtime = [currentdate date];
                self.ln.createtime = createtime;
                [self changelocalnotify];
                [DataBase insertNotifyTime:self.ln.createtime andNotifyTime:self.ln.time andRedundant:self.ln.redundant andTitle:self.ln.title];
            }
        }
        
        if ([self.ln.redundant isEqualToString:@"永不"] == YES && self.ln.createtime != nil) {
            [self changelocalnotify];
            [DataBase updateNotifyTime:self.ln.createtime andNotifyTime:self.ln.time andRedundant:self.ln.redundant andTitle:self.ln.title];
        }
        
        
        [self.navigationController popViewControllerAnimated:YES];

    }
    
}

#pragma mark UIPickerViewDelegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [hours objectAtIndex:row];
    }
    else
    {
        return [minutes objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
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
    self.textfieldTimeTip.text = [NSString stringWithFormat:@"%02d:%02d", self.durationhour,self.durationmin];

}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
		case 0:
			return 24;
		case 1:
			return 60;
        default:
			return 1;
	}

}

#pragma -mark textfield delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (id view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
    }

    if ([UIApplication sharedApplication].statusBarStyle != UIStatusBarStyleLightContent)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)actionsheetDurationShow
{
    action3=[[UIActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    if (durationpicker==nil) {
        durationpicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, self.textfieldTimeTip.frame.origin.y+45, 320, 100)];
    }
    
    durationpicker.delegate   = self;
    durationpicker.dataSource = self;
    durationpicker.showsSelectionIndicator = YES;
    durationpicker.frame      = CGRectMake(0, 0, 320, 100);
    if (self.ln.time != nil) {
        NSArray *array = [self.ln.time componentsSeparatedByString:@":"];
        self.durationhour = [[array objectAtIndex:0] intValue];
        self.durationmin  = [[array objectAtIndex:1] intValue];
    }
    [durationpicker selectRow:self.durationmin  inComponent:1 animated:NO];
    [durationpicker selectRow:self.durationhour inComponent:0 animated:NO];
    
    action3.bounds=CGRectMake(0, 0, 320, 200);
    
    [action3 addSubview:durationpicker];
    
    [action3 showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (actionSheet == action3) {
        self.textfieldTimeTip.text = [NSString stringWithFormat:@"%02d:%02d", self.durationhour,self.durationmin];
        self.ln.time = self.textfieldTimeTip.text;
        ischanged = YES;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.textfieldRedundant)
    {
        
    }
    
    if (textField == self.textfieldTitleTip) {
        self.ln.title = self.textfieldTitleTip.text;
        ischanged     = YES;
    }
    
    if (textField == self.textfieldTimeTip) {
        [self actionsheetDurationShow];
        [self.textfieldTimeTip resignFirstResponder];
    }
}


- (IBAction)setredundant:(UIButton *)sender
{
    if (self.ctvc == nil) {
        self.ctvc = [[CustonTimeViewController alloc] init];
        if (self.ln.redundant != nil && [self.ln.redundant isEqualToString:@"永不"] == NO)
        {
            NSString *str = [self.ln.redundant substringToIndex:([self.ln.redundant length]-1)];
            NSArray *array  = [str componentsSeparatedByString:@","];
            int tag1=101,tag2=201,tag3=301,tag4=401,tag5=501,tag6=601,tag7=701;
            for (NSString *str in array)
            {
                if ([str isEqualToString:@"日"]) {
                    tag1 = 102;
                }
                if ([str isEqualToString:@"一"]) {
                    tag2 = 202;
                }
                if ([str isEqualToString:@"二"]) {
                    tag3 = 302;
                }
                
                if ([str isEqualToString:@"三"]) {
                    tag4 = 402;
                }
                if ([str isEqualToString:@"四"]) {
                    tag5 = 502;
                }
                if ([str isEqualToString:@"五"]) {
                    tag6 = 602;
                }
                if ([str isEqualToString:@"六"]) {
                    tag7 = 702;
                }
            }
            [self.ctvc setSelected:tag1 andbtn2tag:tag2 andbtn3tag:tag3 andbtn4tag:tag4 andbtn5tag:tag5 andbtn6tag:tag6 andbtn7tag:tag7];
        }
       
        self.ctvc.custonTimedelegate = self;
    }
    
    [self.navigationController pushViewController:self.ctvc animated:YES];
}

-(void)setLocalNotify:(LocalNotify*)ln
{
    self.ln = ln;
}

- (void)keyboardWillShown:(NSNotification*)aNotification
{
    //[self keyboradshow];
}

-(void)keyboardWillHidden:(NSNotification*)aNotification
{
    //[self keyboradhidden];
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
            ret = [NSString stringWithFormat:@"%d%@",number,NSLocalizedString(@"时", nil)];
            break;
		case 1:
            number=[(NSNumber*)[minutes objectAtIndex:row] intValue];
            ret = [NSString stringWithFormat:@"%d%@",number,NSLocalizedString(@"分", nil)];
            break;
        default:
            break;
            
	}
    
	[lbl setText:ret];
	[lbl setFont:[UIFont fontWithName:@"Arival-MTBOLD" size:70]];
	[v addSubview:lbl];
	return v;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 80;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 35;
}

#pragma mark -
#pragma mark UIPickerViewDataSource


-(void)keyboradshow
{
    
    NSTimeInterval animationDuration = 0.25f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    _myScrollView.contentOffset=CGPointMake(_myScrollView.contentOffset.x, _myScrollView.contentOffset.y+20);
    
    [UIView commitAnimations];
    
}

-(void)keyboradhidden
{
    NSTimeInterval animationDuration = 0.25f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    _myScrollView.contentOffset=CGPointMake(_myScrollView.contentOffset.x, _myScrollView.contentOffset.y-20);
    [UIView commitAnimations];
}

-(void)sendSelected:(int)tag1 andbtn2tag:(int)tag2 andbtn3tag:(int)tag3 andbtn4tag:(int)tag4 andbtn5tag:(int)tag5 andbtn6tag:(int)tag6 andbtn7tag:(int)tag7
{
    NSMutableString *redundant = [[NSMutableString alloc] initWithCapacity:100];
    NSMutableString *dbredundant = [[NSMutableString alloc] initWithCapacity:100];
    [redundant appendString:@"每周"];
    if (tag1 == 102) {
        
        [dbredundant appendString:@"日,"];
        [redundant appendString:@"日,"];
    }
    
    if (tag2 == 202) {
        [dbredundant appendString:@"一,"];
        [redundant appendString:@"一,"];
    }
    
    if (tag3 == 302) {
        [dbredundant appendString:@"二,"];
        [redundant appendString:@"二,"];
    }
    
    if (tag4 == 402) {
        [dbredundant appendString:@"三,"];
        [redundant appendString:@"三,"];
    }
    
    if (tag5 == 502) {
        [dbredundant appendString:@"四,"];
        [redundant appendString:@"四,"];
    }
    
    if (tag6 == 602) {
        [dbredundant appendString:@"五,"];
        [redundant appendString:@"五,"];
    }
    
    if (tag7 == 702) {
        [dbredundant appendString:@"六,"];
        [redundant appendString:@"六,"];
    }
    
    if ([redundant isEqualToString:@"每周"]) {
        [self.labelredundant removeFromSuperview];
        self.ln.redundant = @"永不";
        self.btnredundant.titleLabel.text = @"永不";
    }
    else
    {
        if (self.labelredundant == nil) {
            self.labelredundant = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 45)];
        }
        
        [self.labelredundant setTextAlignment:NSTextAlignmentCenter];
        [self.labelredundant setTextColor:[UIColor colorWithRed:0.906 green:0.623 blue:0.599 alpha:1.000]];
        [self.labelredundant setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:15]];
        [self.labelredundant setBackgroundColor:[UIColor clearColor]];
        self.ln.redundant = dbredundant;
        if ([self.ln.redundant isEqualToString:@"日,六,"]==YES) {
            [self.labelredundant setText:@"周末"];
        }
        else if ([self.ln.redundant isEqualToString:@"一,二,三,四,五,"]==YES)
        {
            [self.labelredundant setText:@"工作日"];
        }
        else if ([self.ln.redundant isEqualToString:@"日,一,二,三,四,五,六,"]==YES)
        {
            [self.labelredundant setText:@"每天"];
        }
        else
        {
            [self.labelredundant setText:[redundant substringToIndex:([redundant length]-1)]];
        }

        [self.btnredundant addSubview:self.labelredundant];
        self.btnredundant.titleLabel.text = @"";
        ischanged = YES;
    }
    
}

-(void)changelocalnotify
{
    if (self.ln.redundant != nil && [self.ln.redundant isEqualToString:@"永不"] == NO)
    {
        NSString *str = [self.ln.redundant substringToIndex:([self.ln.redundant length]-1)];
        NSArray *array  = [str componentsSeparatedByString:@","];
        if (self.ln.status == 1) {
            //再重新更新
            for (NSString *str in array) {
                NSString *key = [NSString stringWithFormat:@"%@%@", self.ln.createtime, str];
                [OpenFunction addLocalNotification:self.ln.title RepeatDay:str FireDate:self.ln.time AlarmKey:key];
            }
        }

    }
}
@end
