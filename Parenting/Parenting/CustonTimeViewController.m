//
//  CustonTimeViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-19.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import "CustonTimeViewController.h"

@interface CustonTimeViewController ()

@end

@implementation CustonTimeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 100, 20)];
        titleView.backgroundColor=[UIColor clearColor];
        UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        titleText.backgroundColor = [UIColor clearColor];
        [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
        titleText.textColor = [UIColor whiteColor];
        [titleText setTextAlignment:NSTextAlignmentCenter];
        [titleText setText:NSLocalizedString(@"重复", nil)];
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
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    UIButton *backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    backbutton.frame=CGRectMake(0, 0, 50, 41);
    backbutton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [backbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backbar=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=backbar;
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(0, 0, 50, 41);
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,30);
    [rightButton setTitle:@"全选" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(chooseAll:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBar;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    chooseCount = 0;
    if (_tag1 == 102) {
        [self.btn1 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn1.tag = _tag1;
        chooseCount++;
    }
    
    if (_tag2 == 202) {
        [self.btn2 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn2.tag = _tag2;
        chooseCount++;
    }
    
    if (_tag3 == 302) {
        [self.btn3 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn3.tag = _tag3;
        chooseCount++;
    }
    
    if (_tag4 == 402) {
        [self.btn4 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn4.tag = _tag4;
        chooseCount++;
    }
    
    if (_tag5 == 502) {
        [self.btn5 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn5.tag = _tag5;
        chooseCount++;
    }
    
    if (_tag6 == 602) {
        [self.btn6 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn6.tag = _tag6;
        chooseCount++;
    }
    
    if (_tag7 == 702) {
        [self.btn7 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn7.tag = _tag7;
        chooseCount++;
    }
    
    self.imageview1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapgesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectbtn1)];
    [self.imageview1 addGestureRecognizer:tapgesture1];
    
    self.imageview2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapgesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectbtn2)];
    [self.imageview2 addGestureRecognizer:tapgesture2];
    
    self.imageview3.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapgesture3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectbtn3)];
    [self.imageview3 addGestureRecognizer:tapgesture3];
    
    self.imageview4.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapgesture4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectbtn4)];
    [self.imageview4 addGestureRecognizer:tapgesture4];
    
    self.imageview5.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapgesture5=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectbtn5)];
    [self.imageview5 addGestureRecognizer:tapgesture5];
    
    self.imageview6.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapgesture6=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectbtn6)];
    [self.imageview6 addGestureRecognizer:tapgesture6];
    
    self.imageview7.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapgesture7=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectbtn7)];
    [self.imageview7 addGestureRecognizer:tapgesture7];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.custonTimedelegate sendSelected:self.btn1.tag andbtn2tag:self.btn2.tag andbtn3tag:self.btn3.tag andbtn4tag:self.btn4.tag andbtn5tag:self.btn5.tag andbtn6tag:self.btn6.tag andbtn7tag:self.btn7.tag];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)chooseAll:(UIButton *)sender
{
    BOOL isAll = NO;
    if (self.btn1.tag == 102
        && self.btn2.tag == 202
        && self.btn3.tag == 302
        && self.btn4.tag == 402
        && self.btn5.tag == 502
        && self.btn6.tag == 602
        && self.btn7.tag == 702)
    {
        isAll = YES;
    }
    
    if (isAll) {
        if (self.btn1.tag == 102) {
            [self.btn1 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
            self.btn1.tag = 101;
        }
        
        if (self.btn2.tag == 202) {
            [self.btn2 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
            self.btn2.tag = 201;
        }

        if (self.btn3.tag == 302) {
            [self.btn3 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
            self.btn3.tag = 301;
        }

        if (self.btn4.tag == 402) {
            [self.btn4 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
            self.btn4.tag = 401;
        }

        if (self.btn5.tag == 502) {
            [self.btn5 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
            self.btn5.tag = 501;
        }

        if (self.btn6.tag == 602) {
            [self.btn6 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
            self.btn6.tag = 601;
        }

        if (self.btn7.tag == 702) {
            [self.btn7 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
            self.btn7.tag = 701;
        }

        chooseCount = 0;
    }
    else
    {
        if (self.btn1.tag == 101) {
            [self.btn1 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
            self.btn1.tag = 102;
        }
        
        if (self.btn2.tag == 201) {
            [self.btn2 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
            self.btn2.tag = 202;
        }
        
        if (self.btn3.tag == 301) {
            [self.btn3 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
            self.btn3.tag = 302;
        }
        
        if (self.btn4.tag == 401) {
            [self.btn4 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
            self.btn4.tag = 402;
        }
        
        if (self.btn5.tag == 501) {
            [self.btn5 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
            self.btn5.tag = 502;
        }
        
        if (self.btn6.tag == 601) {
            [self.btn6 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
            self.btn6.tag = 602;
        }
        
        if (self.btn7.tag == 701) {
            [self.btn7 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
            self.btn7.tag = 702;
        }
        
        chooseCount = 6;
    }
}

- (IBAction)selectbtn1:(UIButton *)sender
{
    if (sender.tag == 101) {
        [self.btn1 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn1.tag = 102;
    }
    else
    {
        [self.btn1 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn1.tag = 101;
    }
}

- (void)selectbtn1
{
    if (self.btn1.tag == 101) {
        [self.btn1 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn1.tag = 102;
    }
    else
    {
        [self.btn1 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn1.tag = 101;
    }
}

- (void)selectbtn2
{
    if (self.btn2.tag == 201) {
        [self.btn2 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn2.tag = 202;
    }
    else
    {
        [self.btn2 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn2.tag = 201;
    }
}

- (void)selectbtn3
{
    if (self.btn3.tag == 301) {
        [self.btn3 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn3.tag = 302;
    }
    else
    {
        [self.btn3 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn3.tag = 301;
    }
}

- (void)selectbtn4
{
    if (self.btn4.tag == 401) {
        [self.btn4 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn4.tag = 402;
    }
    else
    {
        [self.btn4 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn4.tag = 401;
    }
}

- (void)selectbtn5
{
    if (self.btn5.tag == 501) {
        [self.btn5 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn5.tag = 502;
    }
    else
    {
        [self.btn5 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn5.tag = 501;
    }
}

- (void)selectbtn6
{
    if (self.btn6.tag == 601) {
        [self.btn6 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn6.tag = 602;
    }
    else
    {
        [self.btn6 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn6.tag = 601;
    }
}

- (void)selectbtn7
{
    if (self.btn7.tag == 701) {
        [self.btn7 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn7.tag = 702;
    }
    else
    {
        [self.btn7 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn7.tag = 701;
    }
}

- (IBAction)selectbtn2:(UIButton *)sender
{
    if (sender.tag == 201) {
        [self.btn2 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn2.tag = 202;
    }
    else
    {
        [self.btn2 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn2.tag = 201;
    }
}

- (IBAction)selectbtn3:(UIButton *)sender
{
    if (sender.tag == 301) {
        [self.btn3 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn3.tag = 302;
    }
    else
    {
        [self.btn3 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn3.tag = 301;
    }
}

- (IBAction)selectbtn4:(UIButton *)sender
{
    if (sender.tag == 401) {
        [self.btn4 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn4.tag = 402;
    }
    else
    {
        [self.btn4 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn4.tag = 401;
    }
}

- (IBAction)selectbtn5:(UIButton *)sender
{
    if (sender.tag == 501) {
        [self.btn5 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn5.tag = 502;
    }
    else
    {
        [self.btn5 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn5.tag = 501;
    }
}

- (IBAction)selectbtn6:(UIButton *)sender
{
    if (sender.tag == 601) {
        [self.btn6 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn6.tag = 602;
    }
    else
    {
        [self.btn6 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn6.tag = 601;
    }
}
- (IBAction)selectbtn7:(UIButton *)sender
{
    if (sender.tag == 701) {
        [self.btn7 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn7.tag = 702;
    }
    else
    {
        [self.btn7 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn7.tag = 701;
    }
}

-(void)setCreatetime:(NSDate *)createtime
{
    self.createtime = createtime;
}

-(void)setSelected:(int)tag1 andbtn2tag:(int)tag2 andbtn3tag:(int)tag3 andbtn4tag:(int)tag4 andbtn5tag:(int)tag5 andbtn6tag:(int)tag6 andbtn7tag:(int)tag7
{
    _tag1 = tag1;
    _tag2 = tag2;
    _tag3 = tag3;
    _tag4 = tag4;
    _tag5 = tag5;
    _tag6 = tag6;
    _tag7 = tag7;
}

@end
