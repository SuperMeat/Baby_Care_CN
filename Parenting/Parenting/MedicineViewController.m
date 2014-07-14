//
//  MedicineViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-7-8.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "MedicineViewController.h"

@interface MedicineViewController ()

@end

@implementation MedicineViewController
@synthesize summary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"吃药"];
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ( IOS7_OR_LATER )
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        
    }
    return self;
}

-(id)init
{
    self=[super init];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)SetNextTimeReminder:(UIButton *)sender
{
    if (sender.tag == 101) {
        [sender setImage:[UIImage imageNamed:@"radio_focus"] forState:UIControlStateNormal];
        sender.tag = 102;
    }
   else
   {
       [sender setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
       sender.tag = 101;
   }
}

+(id)shareViewController
{
    
    static dispatch_once_t pred = 0;
    __strong static MedicineViewController* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}



-(void)makeNav
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110 , 100, 20)];
    titleView.backgroundColor=[UIColor clearColor];
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
    titleText.textColor = [UIColor whiteColor];
    [titleText setTextAlignment:NSTextAlignmentCenter];
    [titleText setText:NSLocalizedString(@"Medicine", nil)];
    [titleView addSubview:titleText];
    
    self.navigationItem.titleView = titleView;
    
    UIButton *backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 28)];
    title.backgroundColor = [UIColor clearColor];
    [title setTextAlignment:NSTextAlignmentCenter];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.text =NSLocalizedString(@"navback", nil);
    title.font = [UIFont systemFontOfSize:14];
    [backbutton addSubview:title];
    
    
    [backbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    backbutton.frame=CGRectMake(0, 0, 44, 28);
    
    
    UIBarButtonItem *backbar=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=backbar;
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 28)];
    title1.backgroundColor = [UIColor clearColor];
    [title1 setTextAlignment:NSTextAlignmentCenter];
    title1.textColor = [UIColor whiteColor];
    title1.text = NSLocalizedString(@"navsummary", nil);
    title1.font = [UIFont systemFontOfSize:14];
    [rightButton addSubview:title1];
    
    
    [rightButton addTarget:self action:@selector(pushSummaryView:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame=CGRectMake(0, 0, 44, 28);
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBar;
    
}

-(void)makeView
{
    UIImageView *backIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [backIV setImage:[UIImage imageNamed:@"pattern1"]];
    [self.view addSubview:backIV];

    [self.view bringSubviewToFront:self.detailView];
    self.view.layer.cornerRadius = 8.0f;
    
    self.detailTimeLabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    self.detailTimeLabel.font = [UIFont systemFontOfSize:MIDTEXT];
    
    self.detailTimeHour.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    self.detailTimeHour.font = [UIFont systemFontOfSize:MIDTEXT];

    self.detailTimeYear.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    self.detailTimeYear.font = [UIFont systemFontOfSize:MIDTEXT];

    self.detailMedicineLabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    self.detailMedicineLabel.font = [UIFont systemFontOfSize:MIDTEXT];
    
    self.detailMedicine.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    self.detailMedicine.font = [UIFont systemFontOfSize:MIDTEXT];
    
    self.detailMedicineAmount.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    self.detailMedicineAmount.font = [UIFont systemFontOfSize:MIDTEXT];

    self.detailTimeInternalLabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    self.detailTimeInternalLabel.font = [UIFont systemFontOfSize:MIDTEXT];
    self.detailTimeInternal.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    self.detailTimeInternal.font = [UIFont systemFontOfSize:MIDTEXT];
    
    self.setTimeLabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    self.setTimeLabel.font = [UIFont systemFontOfSize:MOREMIDTEXT];
    
    self.norecordLabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    
    [self.addRecordBtn  setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    [self.addRecordBtn  setTitle:@"添加" forState:UIControlStateNormal];
    [self.addRecordBtn  setAlpha:1];
    [self.addRecordBtn  setTitle:NSLocalizedString(@"Add", nil) forState:UIControlStateNormal];
    [self.addRecordBtn  addTarget:self action:@selector(addrecord:) forControlEvents:UIControlEventTouchUpInside];
    self.addRecordBtn .layer.cornerRadius = 5.0f;
    [self.view bringSubviewToFront:self.addRecordBtn];
    
    if (0) {
        [self.view bringSubviewToFront:self.norecordView];
        self.detailView.hidden = YES;
    }
    else
    {
        [self.view bringSubviewToFront:self.detailView];
        [self.view bringSubviewToFront:self.setTimeBtn];
        [self.view bringSubviewToFront:self.setTimeLabel];
    }
}

-(void)makeAdvise
{
    NSArray *adviseArray = [[UserLittleTips dataBase]selectLittleTipsByAge:1 andCondition:QCM_TYPE_SLEEP];
    
    ad=[[AdviseScrollview alloc]initWithArray:adviseArray];
    
    adviseImageView = [[UIImageView alloc] init];
    [adviseImageView setFrame:CGRectMake(0, WINDOWSCREEN-130-64, 320, 130)];
    [adviseImageView setBackgroundColor:[ACFunction colorWithHexString:@"#f6f6f6"]];
    adviseImageView.userInteractionEnabled = YES;
    [adviseImageView addSubview:ad];
    [self.view addSubview:adviseImageView];
    CGRect frame = [[UIScreen mainScreen] bounds];
    UIImageView *addIamge1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height-130+17-64, 198/2.0, 190/2.0)];
    [addIamge1 setImage:[UIImage imageNamed:@"婴儿车"]];
    [self.view addSubview:addIamge1];
    
    UIImageView *addIamge = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-153/2.0, frame.size.height-114/2.0-64, 153/2.0, 114/2.0)];
    [addIamge setImage:[UIImage imageNamed:@"奶嘴"]];
    [self.view addSubview:addIamge];
    
    UIImageView *cutline = [[UIImageView alloc]initWithFrame:CGRectMake(0, WINDOWSCREEN-130-64, 320, 10)];
    [cutline setImage:[UIImage imageNamed:@"分界线"]];
    [self.view addSubview:cutline];
}


-(IBAction)addrecord:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"addplaynow"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[ACDate date] forKey:@"timerOn"];
    [[NSUserDefaults standardUserDefaults] setObject:@"play" forKey:@"ctl"];
    
    [self makeSave];
}

-(void)makeSave
{
    if (saveView==nil) {
        saveView=[[save_medicineview alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-64-SAVEVIEW_YADDONVERSION, self.view.frame.size.width, self.view.frame.size.height)];
    }
    [saveView loaddata];
    [self.view addSubview:saveView];

}

- (void)pushSummaryView:(id)sender{
    summary = [SummaryViewController summary];
    [summary MenuSelectIndex:5];
    [self.navigationController pushViewController:summary animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"吃药"];
    self.hidesBottomBarWhenPushed = YES;
    [self makeNav];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeView];
    [self makeAdvise];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
