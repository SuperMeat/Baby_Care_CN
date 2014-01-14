//
//  MyLocalNofityViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-6.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import "MyLocalNofityViewController.h"
#import "LocalNotifyCell.h"
#import "CustomNotifyViewController.h"
#import "LocalNotify.h"

@interface MyLocalNofityViewController ()

@end

@implementation MyLocalNofityViewController

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
        [titleText setText:NSLocalizedString(@"LocalNotify", nil)];
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
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    notifylist = [DataBase selectNotifyTime:nil];
    [notifytableview reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    
    UIButton *remind = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [remind setFrame:CGRectMake(100.0f, 300.0f, 120.0f, 40.0f)];
    [remind setTitle:@"定制闹钟" forState:UIControlStateNormal];
    [remind addTarget:self action:@selector(clock:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:remind];
    
    notifylist = [DataBase selectNotifyTime:nil];
    
    if (notifytableview == nil) {
        notifytableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 15, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
        notifytableview.backgroundColor=[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        notifytableview.delegate=self;
        notifytableview.dataSource=self;
        notifytableview.showsVerticalScrollIndicator =NO;
        notifytableview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:notifytableview];
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updatedate:(UIDatePicker*)sender
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
    comps=[calendar components:unitFlags fromDate:sender.date];
    NSString* str = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d",[comps year],[comps month],[comps day],[comps hour],[comps minute],0];
    notifyDate = [currentdate dateFromString:str];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    [OpenFunction addLocalNotificationWithMessage:@"干嘛干嘛" FireDate:notifyDate AlarmKey:@"ddd"];
}

/**
 *	table view delegate
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [notifylist count]+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self actionsheetShow];
    CustomNotifyViewController *cnvc = [[CustomNotifyViewController alloc]init];
    if (indexPath.section < [notifylist count]) {
        LocalNotifyCell* tvc = (LocalNotifyCell*)[tableView cellForRowAtIndexPath:indexPath];
        [cnvc setLocalNotify:tvc.ln];
    }
    [self.navigationController pushViewController:cnvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [notifylist count])
    {
        return 90.0f;
    }
    return 50;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [notifylist count] )
    {
        LocalNotifyCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"Notify"];
        if (Cell == nil) {
            Cell = [[[NSBundle mainBundle] loadNibNamed:@"LocalNotifyCell" owner:self options:nil] lastObject];
            Cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        LocalNotify *ln      = [notifylist objectAtIndex:indexPath.section];
        Cell.title.text      = ln.title;
        if (ln.status == 1) {
            [Cell.notifyswitch setOn:YES];
        }
        else
        {
            [Cell.notifyswitch setOn:NO];
        }
        
        NSMutableString *strredundant = [[NSMutableString alloc] init];
        if (ln.redundant != nil && [ln.redundant isEqualToString:@"永不"] == NO) {
            if ([ln.redundant isEqualToString:@"日,六,"] == YES) {
                Cell.timedetail.text = [NSString stringWithFormat:@"周末 %@", ln.time];
            }
            else if ([ln.redundant isEqualToString:@"一,二,三,四,五,"] == YES)
            {
                Cell.timedetail.text = [NSString stringWithFormat:@"工作日 %@", ln.time];
            }
            else if ([ln.redundant isEqualToString:@"日,一,二,三,四,五,六,"]==YES)
            {
                Cell.timedetail.text = [NSString stringWithFormat:@"每天 %@", ln.time];

            }
            else
            {
                [strredundant appendString:@"每周"];
                [strredundant appendString:ln.redundant];
                Cell.timedetail.text = [NSString stringWithFormat:@"%@ %@", [strredundant substringToIndex:([strredundant length]-1)], ln.time];
            }
        }
        else
        {
            Cell.timedetail.text = @"暂无提醒时间";
        }

        Cell.ln              = ln;
        Cell.accessoryView.contentMode=UIViewContentModeScaleAspectFit;
        return Cell;

    }
    else
    {
        UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"NotifyAdd"];
        if (Cell == nil) {
            Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NotifyAdd"];
            Cell.textLabel.font=[UIFont systemFontOfSize:30];
            Cell.textLabel.textColor=[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0];
            Cell.textLabel.textAlignment = NSTextAlignmentCenter;
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        Cell.textLabel.text = @"添加提醒";
        Cell.accessoryView.contentMode=UIViewContentModeScaleAspectFit;
        return Cell;
    }
}

@end
