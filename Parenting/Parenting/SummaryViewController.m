//
//  SummaryViewController.m
//  Parenting
//
//  Created by 家明 on 13-5-17.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "SummaryViewController.h"
#import "defaultAppDelegate.h"
#import "UMSocial.h"
#import "QuadCurveMenuItem.h"
#import "CustumCell.h"
#import "AdviseData.h"
#import "AdviseTableViewCell.h"
#import "TipsWebViewController.h"

#define originalHeight 25.0f
#define newHeight 100.0f
#define isOpen @"100.0f"

@interface SummaryViewController ()
{
    int currentAPICall;
    
    //AdviseList
    NSMutableDictionary *dicClicked;
    CGFloat mHeight;
    NSInteger sectionIndex;
}
@end

@implementation SummaryViewController
@synthesize dataArray;
@synthesize plotScrollView, plot,Mark;

+(id)summary
{
    
    __strong static id _sharedObject = nil;
    
    _sharedObject = [[self alloc] init]; // or some other init method
    
    return _sharedObject;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init
{
    self=[super init];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
        [self setting];
    }
    return self;
}

-(void)setting
{
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1]];
}

-(void)viewWillAppear:(BOOL)animated
{
    plotTag = 0;
    isScroll = YES;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 100, 20)];
    titleView.backgroundColor=[UIColor clearColor];
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
    titleText.textColor = [UIColor whiteColor];
    [titleText setTextAlignment:NSTextAlignmentCenter];
    [titleText setText:NSLocalizedString(@"navsummary", nil)];
    [titleView addSubview:titleText];
    
    self.navigationItem.titleView = titleView;

    backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(popback:) forControlEvents:UIControlEventTouchUpInside];
    backbutton.frame=CGRectMake(0, 0, 50, 41);
    backbutton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    UIBarButtonItem *backbar=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=backbar;

    [MobClick beginLogPageView:@"总结页面"];

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"gototips"]boolValue] == YES) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"gototips"];
    }
    else
    {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeIndeterminate;
//        hud.color = [UIColor grayColor];
//        hud.alpha = 0.5;
//        hud.labelText = NSLocalizedString(@"PlotLoading", nil);
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"justdoit"] boolValue] == YES) {
            NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(willShowView:) object:[NSNumber numberWithBool:YES]];
            [thread start];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"justdoit"];
        }
        else
        {
            NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(willShowView:) object:[NSNumber numberWithBool:NO]];
            [thread start];
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [menu setValue:[NSNumber numberWithBool:NO] forKey:@"expanding"];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"总结页面"];
}

-(void)willShowView:(NSNumber*)flag
{
    [self segmentSelected:(UIButton *)[self.view viewWithTag:101]];
    
    [self TimeSelected:(UIButton*)[self.view viewWithTag:201]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_title.png"]  forBarMetrics:UIBarMetricsDefault];
    if ([flag boolValue]==YES) {
        [self scrollUpadateData];
    }
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.Mark setFrame:CGRectMake(166 , 81+64 , 154, 37)];
    
    plotArray = [[NSMutableArray alloc] initWithCapacity:0];
    CGRect rx = [ UIScreen mainScreen ].bounds;
    plotScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50+15, 320, rx.size.height-64)];
    [self.view addSubview:plotScrollView];
    
    plotScrollView.contentSize = CGSizeMake(320 * [SummaryDB scrollWidthWithTag:0 andTableName:[self tableName:selectIndex]], 0);
    plotScrollView.delegate = self;
    plotScrollView.pagingEnabled = YES;
    plotScrollView.showsHorizontalScrollIndicator = NO;
    [plotScrollView setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1]];

    [self makeHeadSegement];
    [self makeTimeSegment];
    [self makeMenu];
    
    List =[[UITableView alloc]initWithFrame:CGRectMake(0, 50+64, 320, rx.size.height-64-49) style:UITableViewStylePlain];
    List.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];
    [self.view addSubview:List];
    List.delegate   = self;
    List.dataSource = self;
    List.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[self.view bringSubviewToFront:self.ExplainView];

    List.allowsSelectionDuringEditing=YES;
    
    //AdviseList init
    mHeight = originalHeight;
    sectionIndex = 0;
    dicClicked = [NSMutableDictionary dictionaryWithCapacity:3];
    Advise =[[UITableView alloc]initWithFrame:CGRectMake(0, 50+64, 320, rx.size.height-64-49) style:UITableViewStylePlain];
    Advise.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];
    [self.view addSubview:Advise];
    Advise.delegate=self;
    Advise.dataSource=self;
    Advise.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.view bringSubviewToFront:menu];
    
    UILabel *sign1=(UILabel*)[self.Mark viewWithTag:601];
    UILabel *sign2=(UILabel*)[self.Mark viewWithTag:602];
    UILabel *sign3=(UILabel*)[self.Mark viewWithTag:603];
    UILabel *sign4=(UILabel*)[self.Mark viewWithTag:604];
    UILabel *sign5=(UILabel*)[self.Mark viewWithTag:605];
    
    sign1.text=NSLocalizedString(@"Play", nil);
    sign2.text=NSLocalizedString(@"Bath", nil);
    sign3.text=NSLocalizedString(@"Feed", nil);
    sign4.text=NSLocalizedString(@"Sleep", nil);
    sign5.text=NSLocalizedString(@"Diaper", nil);
    //[self.view addSubview:Shareview];
    [self makePlotSegment];
    NSUserDefaults *db = [NSUserDefaults standardUserDefaults];
    [db setInteger:0 forKey:@"SHUIBIAN"];
    [db synchronize];

    // Do any additional setup after loading the view from its nib.
}

- (void)popback:(id)sender{
    NSString *str = @"1";
    NSUserDefaults *db = [NSUserDefaults standardUserDefaults];
    [db setObject:str forKey:@"MARK"];
    [db synchronize];
    self.tabBarController.selectedIndex = TABBAR_INDEX_ACTIVITY;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [Sharetext resignFirstResponder];
}

- (void)ShareBtn{
    
    [self hidenshareview];
  
    UIGraphicsBeginImageContext(CGSizeMake(plotScrollView.frame.size.width, plotScrollView.frame.size.height - 65));
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *parentImage=UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef imageRef = parentImage.CGImage;
    CGRect myImageRect=CGRectMake(plotScrollView.frame.origin.x, plotScrollView.frame.origin.y, plotScrollView.frame.size.width, plotScrollView.frame.size.height - 65);
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size=CGSizeMake(plotScrollView.frame.size.width,  plotScrollView.frame.size.height - 65);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* image = [UIImage imageWithCGImage:subImageRef];

    
    NSData *imagedata=UIImagePNGRepresentation(image);
     [imagedata writeToFile:SHAREPATH atomically:NO];
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    UIGraphicsEndImageContext();
    [UIView beginAnimations:@"ToggleViews" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView commitAnimations];
    UIImageView *imageview=(UIImageView*)[Shareview viewWithTag:10001];
    imageview.image=image;
    [self showshareview];
    [self Share];
}
-(void)Share
{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENGAPPKEY
                                      shareText:@"分享我的宝贝每一天的记录"
                                     shareImage:[UIImage imageWithContentsOfFile:SHAREPATH]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ,UMShareToRenren,UMShareToDouban,UMShareToEmail,UMShareToSms,UMShareToFacebook,UMShareToTwitter,nil]
                                       delegate:nil];
    
}

-(void)showshareview
{
    [self.view bringSubviewToFront:Shareview];
    [UIView setAnimationDuration:1];
    [UIView beginAnimations:nil context:nil];
    Shareview.frame=CGRectMake(20, 0, 280, 300);
    [UIView commitAnimations];
}

-(void)hidenshareview
{
    [UIView setAnimationDuration:1];
    [UIView beginAnimations:nil context:nil];
    Shareview.frame=CGRectMake(20, -300, 280, 300);
    Sharetext.text=@"";
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)segmentSelected:(UIButton *)sender
{
    sender.enabled=NO;
    List.hidden=YES;
    Advise.hidden=YES;
    plot.hidden=YES;
    Histogram.hidden=YES;
    Plotting.hidden=YES;
    //sender.titleLabel.textColor=[UIColor whiteColor];
    [[self.view viewWithTag:201] setHidden:YES];
    [[self.view viewWithTag:202] setHidden:YES];
    self.Mark.hidden=YES;
    UIButton *another1,*another2;
    if (sender.tag==101) {
        another1=(UIButton*)[self.view viewWithTag:102];
        another2=(UIButton*)[self.view viewWithTag:103];
        self.Mark.hidden=NO;
        plot.hidden=NO;
        if (!(selectIndex==4 ||selectIndex == 5)) {
            Histogram.hidden=NO;
            Plotting.hidden=NO;
        }
  
        [[self.view viewWithTag:201] setHidden:NO];
        [[self.view viewWithTag:202] setHidden:NO];
    }
    else if(sender.tag==102)
    {
        another1=(UIButton*)[self.view viewWithTag:101];
        another2=(UIButton*)[self.view viewWithTag:103];
        List.hidden=NO;
    }
    else
    {
        another1=(UIButton*)[self.view viewWithTag:101];
        another2=(UIButton*)[self.view viewWithTag:102];
        Advise.hidden = NO;
    }

    another1.enabled=YES;
    another2.enabled=YES;
}

-(void)makeHeadSegement
{
    UIButton *lable1_sum=[UIButton buttonWithType:UIButtonTypeCustom];
    [lable1_sum setBackgroundImage:[UIImage imageNamed:@"label1_sum"] forState:UIControlStateNormal];
    [lable1_sum setBackgroundImage:[UIImage  imageNamed:@"label1_sum_choose"] forState:UIControlStateDisabled];
    [lable1_sum addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
    lable1_sum.frame=CGRectMake(2, 23/2.0+64, 211/2.0, 65/2.0+1);
    lable1_sum.tag=101;
    [self.view addSubview:lable1_sum];
    
    UIButton *lable2_sum=[UIButton buttonWithType:UIButtonTypeCustom];
    [lable2_sum setBackgroundImage:[UIImage imageNamed:@"label2_sum"] forState:UIControlStateNormal];
    [lable2_sum setBackgroundImage:[UIImage imageNamed:@"label2_sum_choose"]  forState:UIControlStateDisabled];
    [lable2_sum addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
    lable2_sum.tag=102;
    lable2_sum.frame=CGRectMake(211/2.0+2, 23/2.0+64, 211/2.0, 65/2.0+1);
    [self.view addSubview:lable2_sum];
    
    UIButton *lable3_sum=[UIButton buttonWithType:UIButtonTypeCustom];
    [lable3_sum setBackgroundImage:[UIImage imageNamed:@"label3_sum"] forState:UIControlStateNormal];
    [lable3_sum setBackgroundImage:[UIImage imageNamed:@"label3_sum_choose"] forState:UIControlStateDisabled];
    [lable3_sum addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
    lable3_sum.frame=CGRectMake(211+2, 23/2.0+64, 211/2.0, 65/2.0+1);
    lable3_sum.tag=103;
    
    [self.view addSubview:lable3_sum];
    
}
-(void)makeTimeSegment
{
    float Y = 0.0;
    if ([ACFunction getSystemVersion] >= 7.0) {
        Y += 64.0;
    }
    CGRect rx = [ UIScreen mainScreen ].bounds;
    
    UIButton *week_sum=[UIButton buttonWithType:UIButtonTypeCustom];
    [week_sum setBackgroundImage:[UIImage imageNamed:@"btn_month"] forState:UIControlStateNormal];
    [week_sum setBackgroundImage:[UIImage  imageNamed:@"btn_week"] forState:UIControlStateDisabled];
    [week_sum addTarget:self action:@selector(TimeSelected:) forControlEvents:UIControlEventTouchUpInside];
    week_sum.frame=CGRectMake(320-7-142/2.0-5,  rx.size.height - 160+64+44-15, 142/2.0, 53/2.0);
    week_sum.tag=201;
    [self.view addSubview:week_sum];
    
    UIButton *month_sum=[UIButton buttonWithType:UIButtonTypeCustom];
    [month_sum setBackgroundImage:[UIImage imageNamed:@"btn_week"] forState:UIControlStateNormal];
    [month_sum setBackgroundImage:[UIImage imageNamed:@"btn_month"] forState:UIControlStateDisabled];
    [month_sum addTarget:self action:@selector(TimeSelected:) forControlEvents:UIControlEventTouchUpInside];
    month_sum.frame=CGRectMake(320-7-142/2.0-5,  rx.size.height-160+64+44-15, 142/2.0, 53/2.0);
    month_sum.tag=202;
    
    [self.view addSubview:month_sum];
    [self TimeSelected:week_sum];
}
-(void)TimeSelected:(UIButton*)sender
{
    sender.enabled=NO;
    UIButton *another1;
    if (sender.tag==201) {
        plotTag = 0;
        another1=(UIButton*)[self.view viewWithTag:202];
    }
    else if(sender.tag==202)
    {
        plotTag = 1;
        another1=(UIButton*)[self.view viewWithTag:201];
    }
    another1.enabled=YES;
    
    isScroll = NO;
    [plot removeFromSuperview];
    plotScrollView.contentSize = CGSizeMake([SummaryDB scrollWidthWithTag:plotTag andTableName:[self tableName:selectIndex]] * 320, 0);
      NSLog(@"%f，%f",plotScrollView.contentSize.height,plotScrollView.contentSize.width);
    for (MyCorePlot *plot_1 in plotArray) {
        [plot_1 removeFromSuperview];
    }
    [plotArray removeAllObjects];
    [self scrollUpadateData];

}

- (void)setName{
    NSUserDefaults *db = [NSUserDefaults standardUserDefaults];
  
    [plot setCorePlotName:[db objectForKey:@"NAME"]];
}

-(void)makeMenu
{
    QuadCurveMenuItem *menuitemplay = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"btn_playing"]
                                                      highlightedImage:[UIImage imageNamed:@"btn_playing_focus.png"]
                                                          ContentImage:[UIImage imageNamed:@"btn_playing"]
                                               highlightedContentImage:[UIImage imageNamed:@"btn_playing_focus.png"]];
    // Place MenuItem.
    QuadCurveMenuItem *menuitembath = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"btn_bath"]
                                                      highlightedImage:[UIImage imageNamed:@"btn_bath_focus"]
                                                          ContentImage:[UIImage imageNamed:@"btn_bath"]
                                               highlightedContentImage:[UIImage imageNamed:@"btn_bath_focus"]];
    // Music MenuItem.
    QuadCurveMenuItem *menuitemfeed = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"btn_feeding"]
                                                      highlightedImage:[UIImage imageNamed:@"btn_feeding_focus"]
                                                          ContentImage:[UIImage imageNamed:@"btn_feeding"]
                                               highlightedContentImage:[UIImage imageNamed:@"btn_feeding_focus"]];
    // Thought MenuItem.
    QuadCurveMenuItem *menuitemsleep = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"btn_sleeping"]
                                                       highlightedImage:[UIImage imageNamed:@"btn_sleeping_focus"]
                                                           ContentImage:[UIImage imageNamed:@"btn_sleeping"]
                                                highlightedContentImage:[UIImage imageNamed:@"btn_sleeping_focus"]];
    // Sleep MenuItem.
    QuadCurveMenuItem *menuitemdiaper = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"btn_diapers"]
                                                        highlightedImage:[UIImage imageNamed:@"btn_diapers_focus"]
                                                            ContentImage:[UIImage imageNamed:@"btn_diapers"]
                                                 highlightedContentImage:[UIImage imageNamed:@"btn_diapers_focus"]];
    
    // Sleep MenuItem.
    QuadCurveMenuItem *menuitemmedicine = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"btn_medicine"]
                                                                highlightedImage:[UIImage imageNamed:@"btn_medicine_focus"]
                                                                    ContentImage:[UIImage imageNamed:@"btn_medicine"]
                                                         highlightedContentImage:[UIImage imageNamed:@"btn_medicine_focus"]];
    
    NSArray *menus = [NSArray arrayWithObjects:menuitemplay, menuitembath, menuitemfeed, menuitemsleep, menuitemdiaper, menuitemmedicine,nil];
    CGRect rx = [ UIScreen mainScreen ].bounds;
    
    if(rx.size.height > 480){
        menu = [[QuadCurveMenu alloc] initWithFrame:CGRectMake(10, 42+64, 320, [UIScreen mainScreen].bounds.size.height-20-44- 49-10-50) menus:menus];
    }else{
        menu = [[QuadCurveMenu alloc] initWithFrame:CGRectMake(10, 42+64, 320, [UIScreen mainScreen].bounds.size.height-20-44 - 44-10-50) menus:menus];

    }
    [menu setBackgroundColor:[UIColor clearColor]];
    menu.delegate = self;
    [self.view addSubview:menu];
    
}

- (void)MenuSelectIndex:(int)index{
    
    [self quadCurveMenu:menu didSelectIndex:index];
}

-(void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    
    UIButton *btn=(UIButton*)[self.view viewWithTag:101];
    if ((idx==4)|| btn.enabled || (idx == 5)) {
        Plotting.hidden=YES;
        Histogram.hidden=YES;
    }
    else
    {
        Plotting.hidden=NO;
        Histogram.hidden=NO;
    }
    switch (idx) {
        case 0:
        {
            ListArray=[[SummaryDB dataBase] selectplayforsummary];
            [List reloadData];
            
            chooseAdvise = ADVISE_TYPE_PLAY;
            [Advise reloadData];
        }
            break;
        case 1:
        {
            ListArray=[[SummaryDB dataBase] selectbathforsummary];
            [List reloadData];
            
            chooseAdvise = ADVISE_TYPE_BATH;
            [Advise reloadData];
        }
            break;
        case 2:
        {
            ListArray=[[SummaryDB dataBase] selectfeedforsummary];
            [List reloadData];
            
            chooseAdvise = ADVISE_TYPE_FEED;
            [Advise reloadData];
        }
            break;
        case 3:
        {
            ListArray=[[SummaryDB dataBase] selectsleepforsummary];
            [List reloadData];
            
            chooseAdvise = ADVISE_TYPE_SLEEP;
            [Advise reloadData];
        }
            break;
        case 4:
        {
            ListArray=[[SummaryDB dataBase] selectdiaperforsummary];
            [List reloadData];
            
            chooseAdvise = ADVISE_TYPE_DIAPER;
            [Advise reloadData];
        }
            break;
        case 5:
        {
            ListArray=[[SummaryDB dataBase] selectmedicineforsummary];
            [List reloadData];
            
            chooseAdvise = ADVISE_TYPE_MEDICINE;
            [Advise reloadData];
        }
            break;

        default:
            break;
    }
    
    selectIndex = idx;
    plotScrollView.contentSize = CGSizeMake([SummaryDB scrollWidthWithTag:plotTag andTableName:[self tableName:selectIndex]] * 320, 0);
    for (MyCorePlot *plot_1 in plotArray) {
        [plot_1 removeFromSuperview];
    }
    [plotArray removeAllObjects];
    
    [self scrollUpadateData];
}

-(void)updaterecord:(NSInteger)idx
{
    UIButton *btn=(UIButton*)[self.view viewWithTag:101];
    if ((idx==4)||btn.enabled|| (idx == 5)) {
        Plotting.hidden=YES;
        Histogram.hidden=YES;
    }
    else
    {
        Plotting.hidden=NO;
        Histogram.hidden=NO;
    }
    switch (idx) {
        case -1:
        {
            ListArray=[[DataBase dataBase] selectAllforsummary];
            [List reloadData];
            
           
            chooseAdvise = ADVISE_TYPE_ALL;
            [Advise reloadData];
        }
            break;
        case 0:
        {
            ListArray=[[SummaryDB dataBase] selectplayforsummary];
            [List reloadData];
            
           
            chooseAdvise = ADVISE_TYPE_PLAY;
            [Advise reloadData];
        }
            break;
        case 1:
        {
            ListArray=[[SummaryDB dataBase] selectbathforsummary];
            [List reloadData];
            
            
            chooseAdvise = ADVISE_TYPE_BATH;
            [Advise reloadData];
        }
            break;
        case 2:
        {
            ListArray=[[SummaryDB dataBase] selectfeedforsummary];
            [List reloadData];
            
            
            chooseAdvise = ADVISE_TYPE_FEED;
            [Advise reloadData];
        }
            break;
        case 3:
        {
            ListArray=[[SummaryDB dataBase] selectsleepforsummary];
            [List reloadData];
            
            
            chooseAdvise = ADVISE_TYPE_SLEEP;
           
            [Advise reloadData];
        }
            break;
        case 4:
        {
            ListArray=[[SummaryDB dataBase] selectdiaperforsummary];
            [List reloadData];
            
           
            chooseAdvise = ADVISE_TYPE_DIAPER;
            [Advise reloadData];
        }
            break;
        case 5:
        {
            ListArray=[[SummaryDB dataBase] selectmedicineforsummary];
            [List reloadData];
            
           
            chooseAdvise = ADVISE_TYPE_MEDICINE;
            [Advise reloadData];
        }
            break;

        default:
            break;
    }
    
    for (MyCorePlot *plot_1 in plotArray) {
        [plot_1 removeFromSuperview];
    }
    [plotArray removeAllObjects];
    selectIndex = idx;
    [self scrollUpadateData];
}


- (NSString *)tableName:(int)tableTag{
    NSString *retStr;
    switch (tableTag) {
        case -1:
            selectIndex = 0;
            retStr = @"All";
            break;
        case 0:
            selectIndex = 0;
            retStr = @"Play";
            break;
        case 1:
            selectIndex = 1;
            retStr = @"Bath";
            break;
        case 2:
            selectIndex = 2;
            retStr = @"Feed";
            break;
        case 3:
            selectIndex = 3;
            retStr = @"Sleep";
            break;
        case 4:
            selectIndex = 4;
            retStr = @"Diaper";
            break;
        case 5:
            selectIndex = 5;
            retStr = @"Medicine";
            break;

    }
    return retStr;
}

- (void)viewDidUnload {
    [self setExplainView:nil];
    [self setMark:nil];
    [super viewDidUnload];
}
-(void)AlertWithTitle:(NSString *)title Message:(NSString*)message
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == Advise)
        return 1;
    else
        return ListArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView == Advise)
        //return AdviseArray.count;
        switch (chooseAdvise) {
            case ADVISE_TYPE_FEED:
                return 35;
                break;
            case ADVISE_TYPE_SLEEP:
                return 5;
                break;
            case ADVISE_TYPE_BATH:
                return 6;
                break;
            case ADVISE_TYPE_DIAPER:
                return 5;
                break;
            case ADVISE_TYPE_PLAY:
                return 13;
                break;
            case ADVISE_TYPE_MEDICINE:
                return 14;
                break;
            default:
                return 5;
                break;
        }
    else
        return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == List) {
        return nil;
    }
    
    CGRect headerFrame = CGRectMake(0, 0, 300, 30);
    CGFloat y = 2;
    if (section == 0) {
        headerFrame = CGRectMake(0, 0, 300, 100);
        y = 18;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
    [headerView setAlpha:0.5];
    [headerView setBackgroundColor:[UIColor colorWithRed:0x97/255.0 green:0x97/255.0 blue:0x97/255.0 alpha:0xFF/255.0]];
    UILabel *dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, y, 240, 24)];//日期标签
    dateLabel.font=[UIFont boldSystemFontOfSize:16.0f];
    dateLabel.textColor = [UIColor colorWithRed:0x97/255.0 green:0x97/255.0 blue:0x97/255.0 alpha:0xFF/255.0];
    dateLabel.backgroundColor=[UIColor clearColor];
    UILabel *ageLabel=[[UILabel alloc] initWithFrame:CGRectMake(216, y, 88, 24)];//年龄标签
    ageLabel.font=[UIFont systemFontOfSize:14.0];
    ageLabel.textAlignment=NSTextAlignmentCenter;
    ageLabel.textColor = [UIColor colorWithRed:0x97/255.0 green:0x97/255.0 blue:0x97/255.0 alpha:0xFF/255.0];;
    ageLabel.backgroundColor=[UIColor clearColor];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM dd,yyyy";
    //dateLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
    dateLabel.text = @"Everything is OK!";
    ageLabel.text = @"1岁 2天";
    
    //[headerView addSubview:dateLabel];
    //[headerView addSubview:ageLabel];
    return headerView;
}

- (void)deselect
{
    [List deselectRowAtIndexPath:[List indexPathForSelectedRow] animated:YES];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == List)
    {
        CustumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CustumCell" owner:self options:nil] lastObject];
            //灰色
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            //cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.minutesLable.textColor=cell.timeLable.textColor;
        SummaryItem *item=[ListArray objectAtIndex:indexPath.row];
        cell.timeLable.text = [ACDate dateForSummaryList:item.starttime];
        cell.minutesLable.text = item.duration;
        if ([item.type isEqualToString:@"Feed"])
        {
            if ([item.feedtype isEqualToString:@"0"])
            {
                cell.MarkLable.text = item.op_type;
                cell.minutesLable.text = item.amount;
            }
            else if ([item.feedtype isEqualToString:@"2"])
            {
                cell.MarkLable.text = item.op_type;
            }
            else
            {
                cell.MarkLable.text = @"哺乳";
            }
        }
        else if([item.type isEqualToString:@"Medicine"])
        {
            cell.MarkLable.text = item.medicinename;
            cell.minutesLable.text = [NSString stringWithFormat:@"%@%@",item.amount,item.danwei];
        }
        else
        {
           cell.MarkLable.text = NSLocalizedString(item.type, nil);
        }
        
        
        if ([item.duration isEqualToString:NSLocalizedString(@"XuXu", nil)]) {
            cell.minutesLable.textColor=[UIColor colorWithRed:0x82/255.0 green:0xC6/255.0 blue:0xE1/255.0 alpha:0xFF/255.0];
        }
        else if([item.duration isEqualToString:NSLocalizedString(@"XuXuBaBa", nil)])
        {
            cell.minutesLable.textColor=[UIColor colorWithRed:0xB6/255.0 green:0xB6/255.0 blue:0xB6/255.0 alpha:0xFF/255.0];
        }
        else if ([item.duration isEqualToString:NSLocalizedString(@"BaBa", nil)]) {
            cell.minutesLable.textColor=[UIColor colorWithRed:0xBC/255.0 green:0x97/255.0 blue:0x6A/255.0 alpha:0xFF/255.0];
        }
        else
        {
            cell.minutesLable.textColor=cell.timeLable.textColor;
        }
        
        return cell;
    }
    else if (tableView == Advise){
        static NSString *CellIdentifier = @"Cell";
        
        UIImageView *tipsImageView;
        UILabel *tipsTitle;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AdviseTableViewCell" owner:self options:nil] lastObject];
            //cell.selectionStyle=UITableViewCellSelectionStyleNone;
            //灰色
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        tipsImageView = (UIImageView*)[cell.contentView viewWithTag:1];
        tipsTitle     = (UILabel*)[cell.contentView viewWithTag:2];
        
        NSString *imageName,*title;
        switch (chooseAdvise) {
            case ADVISE_TYPE_FEED:
                if (indexPath.section < 35) {
                    imageName = [NSString stringWithFormat:@"Feed_%d.jpg", indexPath.section%5 + 1];
                    title =[NSString stringWithFormat:@"Feed_T%d", indexPath.section + 1];
                }
                break;
            case ADVISE_TYPE_SLEEP:
                if (indexPath.section < 5) {
                    imageName = [NSString stringWithFormat:@"Sleep_%d.jpg", indexPath.section + 1];
                    title =[NSString stringWithFormat:@"Sleep_T%d", indexPath.section + 1];
                }

                break;
            case ADVISE_TYPE_BATH:
                if (indexPath.section < 6) {
                    imageName = [NSString stringWithFormat:@"Bath_%d.jpg", indexPath.section + 1];
                    title =[NSString stringWithFormat:@"Bath_T%d", indexPath.section + 1];
                }
                break;
            case ADVISE_TYPE_DIAPER:
                if (indexPath.section < 5) {
                    imageName = [NSString stringWithFormat:@"Diaper_%d.jpg", indexPath.section + 1];
                    title =[NSString stringWithFormat:@"Diaper_T%d", indexPath.section + 1];
                }
                break;
            case ADVISE_TYPE_PLAY:
                if (indexPath.section < 13) {
                    imageName = [NSString stringWithFormat:@"Play_%d.jpg", indexPath.section + 1];
                    title =[NSString stringWithFormat:@"Play_T%d", indexPath.section + 1];
                }

                break;
            case ADVISE_TYPE_MEDICINE:
                if (indexPath.section < 14) {
                    imageName = [NSString stringWithFormat:@"Medicine_%d.jpg", indexPath.section + 1];
                    title =[NSString stringWithFormat:@"Medicine_T%d", indexPath.section + 1];
                }
                
                break;
            default:
                break;
        }
        title = NSLocalizedString(title, nil);
        tipsTitle.textColor = [UIColor colorWithRed:0xB3/255.0 green:0xB3/255.0 blue:0xB3/255.0 alpha:0xFF/255.0];
        [tipsTitle setText:title];
        tipsTitle.numberOfLines = 0;
        tipsTitle.lineBreakMode=NSLineBreakByWordWrapping;
        tipsTitle.textAlignment=NSTextAlignmentCenter;
        [tipsTitle setFont:[UIFont fontWithName:@"Arial" size:15]];
        [tipsImageView setImage:[UIImage imageNamed:imageName]];
        [tipsImageView setFrame:CGRectMake(15, 15, 100, 60)];
        [tipsImageView setContentMode:UIViewContentModeScaleAspectFill];
        [cell.contentView addSubview:tipsTitle];
        [cell.contentView addSubview:tipsImageView];
        return cell;
    }
    else
    {
        return NULL;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];

    if (tableView == List) {
        SummaryItem *item=[ListArray objectAtIndex:indexPath.row];
        [self showHistory:item];
    }
    else
    {
        if (indexPath.row != 0) {
            UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
            if (targetCell.frame.size.height == originalHeight){
                [dicClicked setObject:isOpen forKey:indexPath];
            }
            else{
                [dicClicked removeObjectForKey:indexPath];
            }
            [Advise reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        NSString *url, *key, *title, *imagePath;
        switch (chooseAdvise) {
            case ADVISE_TYPE_FEED:
                if (indexPath.section < 35) {
                    key = [NSString stringWithFormat:@"Feed_%d", indexPath.section + 1];
                    title =[NSString stringWithFormat:@"Feed_T%d", indexPath.section + 1];
                    imagePath = [NSString stringWithFormat:@"Feed_%d.jpg", indexPath.section + 1];
                }
                break;
            case ADVISE_TYPE_SLEEP:
                if (indexPath.section < 5) {
                    key = [NSString stringWithFormat:@"Sleep_%d", indexPath.section + 1];
                    title =[NSString stringWithFormat:@"Sleep_T%d", indexPath.section + 1];
                    imagePath = [NSString stringWithFormat:@"Sleep_%d.jpg", indexPath.section + 1];
                }
                break;
            case ADVISE_TYPE_BATH:
                if (indexPath.section < 6) {
                    key = [NSString stringWithFormat:@"Bath_%d", indexPath.section + 1];
                    title =[NSString stringWithFormat:@"Bath_T%d", indexPath.section + 1];
                    imagePath = [NSString stringWithFormat:@"Bath_%d.jpg", indexPath.section + 1];
                }
                break;
            case ADVISE_TYPE_DIAPER:
                if (indexPath.section < 5) {
                    key = [NSString stringWithFormat:@"Diaper_%d", indexPath.section + 1];
                    title =[NSString stringWithFormat:@"Diaper_T%d", indexPath.section + 1];
                    imagePath = [NSString stringWithFormat:@"Diaper_%d.jpg", indexPath.section + 1];
                }
                break;
            case ADVISE_TYPE_PLAY:
                if (indexPath.section < 13) {
                    key = [NSString stringWithFormat:@"Play_%d", indexPath.section + 1];
                    title =[NSString stringWithFormat:@"Play_T%d", indexPath.section + 1];
                    imagePath = [NSString stringWithFormat:@"Play_%d.jpg", indexPath.section + 1];
                }
                break;
            case ADVISE_TYPE_MEDICINE:
                if (indexPath.section < 14) {
                    key = [NSString stringWithFormat:@"Medicine_%d", indexPath.section + 1];
                    title =[NSString stringWithFormat:@"Medicine_T%d", indexPath.section + 1];
                    imagePath = [NSString stringWithFormat:@"Medicine_%d.jpg", indexPath.section + 1];
                }
                break;

            default:
                break;
        }
        
        url = NSLocalizedString(key, nil);
        
        TipsWebViewController *tips = [[TipsWebViewController alloc] init];
        [tips setTipsUrl:url];
        [tips setTipsTitle:NSLocalizedString(title, nil)];
        [tips setShowImage:imagePath];
        [self.navigationController pushViewController:tips animated:YES];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"gototips"];

    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//Section的标题栏高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == Advise)
    {
        if (section == 0)
            return 0;
        else
            return 1;
    }
    else
    {
        return 0;
    }
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == Advise) {
        return 120;
    }
    else
    {
        return 41.0f;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == List)
    {
        if (editingStyle==UITableViewCellEditingStyleDelete) {

        
        SummaryItem *item=[ListArray objectAtIndex:indexPath.row];

        SummaryDB *db=[SummaryDB dataBase];
        
        [db deleteWithStarttime:item.starttime];
        
        [self MenuSelectIndex:selectIndex];

        }
    }
}

-(void)showHistory:(SummaryItem*)item
{
    //NSLog(@"%@",item.type);
    if ([item.type isEqualToString:@"Feed"]) {
        
        feed=[[save_feedview alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height) Select:YES Start:item.starttime Duration:item.duration UpdateTime:item.updatetime CreateTime:item.createtime];
        feed.feedSaveDelegate = self;
        [feed loaddata];
        [self.view addSubview:feed];
    }
    else if ([item.type isEqualToString:@"Sleep"])
    {
        sleep=[[save_sleepview alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+SAVEVIEW_YADDONVERSION, self.view.frame.size.width, self.view.frame.size.height) Select:YES Start:item.starttime Duration:item.duration UpdateTime:item.updatetime CreateTime:item.createtime];
        sleep.sleepSaveDelegate = self;
       [sleep loaddata];
        [self.view addSubview:sleep];
    }
    else if ([item.type isEqualToString:@"Play"])
    {
        play=[[save_playview alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+SAVEVIEW_YADDONVERSION, self.view.frame.size.width, self.view.frame.size.height) Select:YES Start:item.starttime Duration:item.duration UpdateTime:item.updatetime CreateTime:item.createtime];
        play.playSaveDelegate = self;
        [play loaddata];
        [self.view addSubview:play];
    }
    else if ([item.type isEqualToString:@"Bath"])
    {
        bath=[[save_bathview alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+SAVEVIEW_YADDONVERSION, self.view.frame.size.width, self.view.frame.size.height) Select:YES Start:item.starttime Duration:item.duration UpdateTime:item.updatetime CreateTime:item.createtime];
        bath.bathSaveDelegate = self;
        [bath loaddata];
        [self.view addSubview:bath];
    }
    else if ([item.type isEqualToString:@"Medicine"])
    {
        medicine=[[save_medicineview alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height) Select:YES Start:item.starttime Duration:item.duration UpdateTime:item.updatetime CreateTime:item.createtime];
        medicine.medicineSaveDelegate = self;
        [medicine loaddata];
        [self.view addSubview:medicine];
    }
    else
    {
        diaper=[[save_diaperview alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-20, self.view.frame.size.width, self.view.frame.size.height) Select:YES Start:item.starttime UpdateTime:item.updatetime CreateTime:item.createtime];
        diaper.diaperSaveDelegate = self;
        [diaper loaddata];
        [self.view addSubview:diaper];
    }
    
}

- (void)scrollUpadateData{

    CGRect rx = [UIScreen mainScreen ].bounds;
    int range = [SummaryDB scrollWidthWithTag:plotTag andTableName:[self tableName:selectIndex]];
    int j = 0;
    for (int i = range - 1; i >= 0;i--)
    {
        NSArray *data   = [SummaryDB scrollData:i andTable:[self tableName:selectIndex] andFieldTag:plotTag];
        int maxmonthday = [SummaryDB getMonthMax:i];
        float maxyAxis  = 0.0f;
        for (NSArray *ar in data) {
            for (NSString *str in ar) {
                if ([str floatValue] > maxyAxis) {
                    maxyAxis = [str floatValue];
                }
            }
        }
        double xLength = 0.0f;
        if (0 == plotTag) {
            xLength = 7.0f;
        }else{
            xLength = 6.0f;
        }
       
        plot = [[MyCorePlot alloc] initWithFrame:CGRectMake(([SummaryDB scrollWidthWithTag:plotTag andTableName:[self tableName:selectIndex]] - j - 1) * 320, 0, 320, rx.size.height - 40 - 35 - 49-20) andTitle:[self tableName:selectIndex] andXplotRangeWithLocation:0.0f andXlength:xLength andYplotRangeWithLocation:0.0f andYlength:maxyAxis * 1.5 andDataSource:data andXAxisTag:plotTag andMaxDay:maxmonthday];
        [plot setBackgroundColor:[UIColor whiteColor]];
        [plotScrollView addSubview:plot];
        [self setName];
        [plotArray addObject:plot];
        j++;
    }
    
    [plotScrollView scrollRectToVisible:CGRectMake([SummaryDB scrollWidthWithTag:plotTag andTableName:[self tableName:selectIndex]] * 320 - 320, 0, 320, rx.size.height - 40 - 35 - 49-20) animated:NO];
    [self.Mark setFrame:CGRectMake(166, 64+46, 154, 37)];
    [self.view bringSubviewToFront:self.Mark];
}

//折线图切换
-(void)makePlotSegment
{
    Histogram=[UIButton buttonWithType:UIButtonTypeCustom];
    [Histogram setBackgroundImage:[UIImage imageNamed:@"btn_times"]  forState:UIControlStateNormal];
    [Histogram setBackgroundImage:[UIImage imageNamed:@"btn_times"] forState:UIControlStateHighlighted];
    [Histogram setBackgroundImage:[UIImage  imageNamed:@"btn_time"]  forState:UIControlStateDisabled];
    Histogram.contentMode=UIViewContentModeScaleAspectFill;
    Histogram.frame=CGRectMake(12, 50+64, 142/2.0, 52/2.0);
    [self.view addSubview:Histogram];
    
    Plotting=[UIButton buttonWithType:UIButtonTypeCustom];
    Plotting=[UIButton buttonWithType:UIButtonTypeCustom];
    [Plotting setBackgroundImage:[UIImage imageNamed:@"btn_times"]forState:UIControlStateNormal];
    [Plotting setBackgroundImage:[UIImage imageNamed:@"btn_times"]  forState:UIControlStateHighlighted];
    [Plotting setBackgroundImage:[UIImage  imageNamed:@"btn_time"] forState:UIControlStateDisabled];
    Plotting.frame=CGRectMake(12, 50+64, 142/2.0, 52/2.0);
    Plotting.contentMode=UIViewContentModeScaleToFill;
    [self.view addSubview:Plotting];
    
    if (selectIndex == 4 || selectIndex == 5) {
        Plotting.hidden = YES;
        Histogram.hidden = YES;
    }
    
    [Histogram addTarget:self action:@selector(PLotSelected:) forControlEvents:UIControlEventTouchUpInside];
    [Plotting addTarget:self action:@selector(PLotSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    Histogram.titleLabel.numberOfLines = 0;
    Plotting.titleLabel.numberOfLines  = 0;
    Plotting.titleLabel.textAlignment  = NSTextAlignmentCenter;
    [self PLotSelected:Histogram];
    Histogram.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}
-(void)PLotSelected:(UIButton*)sender
{
    NSUserDefaults *db = [NSUserDefaults standardUserDefaults];
    sender.enabled=NO;
    if (sender==Histogram) {
        Plotting.enabled=YES;
        [db setInteger:0 forKey:@"SHUIBIAN"];
    }
    else
    {
        Histogram.enabled=YES;
        [db setInteger:1 forKey:@"SHUIBIAN"];
    }
    
    [db synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATECOREPLOT" object:nil];
}

#pragma -mark save delegate 
-(void)sendDiaperSaveChanged:(NSString *)newstatus andstarttime:(NSDate *)newstarttime
{
    [self updaterecord:QCM_TYPE_DIAPER];
}

-(void)sendSleepSaveChanged:(int)duration andstarttime:(NSDate *)newstarttime
{
    [self updaterecord:QCM_TYPE_SLEEP];
}

-(void)sendPlaySaveChanged:(int)duration andstarttime:(NSDate *)newstarttime
{
    [self updaterecord:QCM_TYPE_PLAY];
}

-(void)sendBathSaveChanged:(int)duration andstarttime:(NSDate *)newstarttime
{
    [self updaterecord:QCM_TYPE_BATH];
}

-(void)sendFeedSaveChanged:(int)duration andIsFood:(BOOL)isfood andstarttime:(NSDate *)newstarttime
{
    [self updaterecord:QCM_TYPE_FEED];
}

-(void)sendMedicineSaveChanged:(NSString *)medicinename andAmount:(NSString *)amount andIsReminder:(BOOL)isReminder andstarttime:(NSDate *)newstarttime
{
    [self updaterecord:QCM_TYPE_MEDICINE];
}

-(void)sendMedicineReloadData
{
    [self updaterecord:QCM_TYPE_MEDICINE];
}

@end
