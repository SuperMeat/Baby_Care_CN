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

    self.view.layer.cornerRadius = 8.0f;

    self.norecordLabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    
    [self.addRecordBtn  setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    [self.addRecordBtn  setTitle:@"添加" forState:UIControlStateNormal];
    [self.addRecordBtn  setAlpha:1];
    [self.addRecordBtn  setTitle:NSLocalizedString(@"Add", nil) forState:UIControlStateNormal];
    [self.addRecordBtn  addTarget:self action:@selector(addrecord:) forControlEvents:UIControlEventTouchUpInside];
    self.addRecordBtn .layer.cornerRadius = 5.0f;
    [self.view bringSubviewToFront:self.addRecordBtn];
    
    [self.scrollView setContentSize:CGSizeMake(300, 400)];
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    self.scrollView.showsHorizontalScrollIndicator=NO;
    [self.view bringSubviewToFront:self.scrollView];
    NSArray* array=[[SummaryDB dataBase] selectmedicinedetailforsummary];
    if ([array count] == 0) {
        [self.view bringSubviewToFront:self.norecordView];
        self.scrollView.hidden = YES;
        self.norecordView.hidden = NO;
    }
    else
    {
        self.scrollView.hidden = NO;
        self.norecordView.hidden = YES;

        [self makeDetailViews];
    }
    
}

-(void)makeDetailViews
{
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    //从数据库获取
    NSArray* array=[[SummaryDB dataBase] selectmedicinedetailforsummary];
    if ([array count]<=4) {
        self.scrollView.scrollEnabled = NO;
    }
    else
    {
        self.scrollView.scrollEnabled = YES;
    }

    for (int i=0; i<[array count]; i++)
    {
        SummaryItem *item = [array objectAtIndex:i];
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MedicineDetailView" owner:self options:nil];
        
        UIView *tmpCustomView = [nib objectAtIndex:0];
        [tmpCustomView setBackgroundColor:[ACFunction colorWithHexString:@"#c2c9f3"]];
        tmpCustomView.layer.cornerRadius = 8.0f;
        for (UIView *subView in tmpCustomView.subviews) {
            if (subView.tag == 101) {
                UILabel *time = (UILabel*)subView;
                
                time.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
                time.font = [UIFont systemFontOfSize:MIDTEXT];
                NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                [formater setDateFormat:@"HH:mm"];
                time.text =[formater stringFromDate:item.starttime];
                
            }
            
            if (subView.tag == 102) {
                UILabel *medicine = (UILabel*)subView;
                medicine.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
                medicine.font = [UIFont systemFontOfSize:MIDTEXT];
                medicine.text = item.medicinename;
            }
            
            if (subView.tag == 103) {
                UILabel *amount = (UILabel*)subView;
                amount.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
                amount.font = [UIFont systemFontOfSize:MIDTEXT];
                amount.text = [NSString stringWithFormat:@"%@%@", item.amount,item.danwei];
            }
            
            if (subView.tag == 104) {
                UIImageView *reminderImageView = (UIImageView*)subView;
                if (!item.isreminder) {
                    reminderImageView.hidden = YES;
                }
            }

        }
        
        CGRect tmpFrame = [[UIScreen mainScreen] bounds];
        
        [tmpCustomView setCenter:CGPointMake(tmpFrame.size.width / 2, 25+40*i)];
        
        [self.scrollView addSubview:tmpCustomView];
  
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
    UIImageView *addIamge1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height-130+17-64, 224/2.0, 204/2.0)];
    [addIamge1 setImage:[UIImage imageNamed:@"medicine_heart"]];
    [self.view addSubview:addIamge1];
    
    UIImageView *cutline = [[UIImageView alloc]initWithFrame:CGRectMake(0, WINDOWSCREEN-130-64, 320, 10)];
    [cutline setImage:[UIImage imageNamed:@"分界线"]];
    [self.view addSubview:cutline];
}


-(void)addrecord:(id)sender
{
    [self makeSave];
}

-(void)stop
{
    [saveView removeFromSuperview];
}

-(void)cancel
{
    [saveView removeFromSuperview];
}

-(void)makeSave
{
    if (saveView==nil) {
        saveView=[[save_medicineview alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-64-SAVEVIEW_YADDONVERSION+35, self.view.frame.size.width, self.view.frame.size.height)];
        
    }
    saveView.medicineSaveDelegate = self;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop) name:@"stop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancel) name:@"cancel" object:nil];

    [self makeNav];
    NSArray* array=[[SummaryDB dataBase] selectmedicinedetailforsummary];
    if ([array count] == 0) {
        [self.view bringSubviewToFront:self.norecordView];
        self.scrollView.hidden = YES;
        self.norecordView.hidden = NO;
    }
    else
    {
        self.scrollView.hidden = NO;
        self.norecordView.hidden = YES;
        
        [self makeDetailViews];
    }

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

-(void)sendMedicineSaveChanged:(NSString*)medicinename andAmount:(NSString*)amount andIsReminder:(BOOL)isReminder andstarttime:(NSDate*)newstarttime
{
    NSLog(@"sendMedicineSaveChanged:%@,%@,%d,%@",medicinename,amount,isReminder,newstarttime);
    //如果没有记录
    NSArray *array = [[SummaryDB dataBase]selectmedicinedetailforsummary];
    if ([array count] == 0)
    {
        self.norecordView.hidden = NO;
        self.scrollView.hidden = YES;
        [self.view bringSubviewToFront:self.norecordView];
    }
    else
    {
        self.scrollView.hidden = NO;
        self.norecordView.hidden = YES;
        [self.scrollView setContentSize:CGSizeMake(300, 368)];
        [self.scrollView setBackgroundColor:[UIColor clearColor]];
        self.scrollView.showsHorizontalScrollIndicator=NO;
        [self.view bringSubviewToFront:self.scrollView];
        [self makeDetailViews];
    }

}

-(void)sendMedicineReloadData
{
    
}
@end