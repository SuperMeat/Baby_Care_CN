//
//  InformationCenterViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-11-11.
//  Copyright (c) 2013年 爱摩信息科技. All rights reserved.
//

#import "InformationCenterViewController.h"
#import "InfomationItem.h"
#import "SocialCircleViewController.h"
#import "NotifyViewController.h"
#import "MissionViewController.h"
#import "TipsMasterViewController.h"
#import "AdviseMasterViewController.h"

@interface InformationCenterViewController ()

@end

@implementation InformationCenterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self.view setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 200, 20)];
        titleView.backgroundColor=[UIColor clearColor];
        UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        titleText.backgroundColor = [UIColor clearColor];
        [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
        titleText.textColor = [UIColor whiteColor];
        [titleText setTextAlignment:NSTextAlignmentCenter];
        [titleText setText:NSLocalizedString(@"InformationCenter", nil)];
        [titleView addSubview:titleText];
        
        self.navigationItem.titleView = titleView;
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ( IOS7_OR_LATER )
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
         [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1]];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    //[self.tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *_array1 = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *_array2 = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *_array3 = [[NSMutableArray alloc] initWithCapacity:0];
    
    InfomationItem *itemNotify  = [[InfomationItem alloc]init];
    InfomationItem *itemTips    = [[InfomationItem alloc]init];
    InfomationItem *itemMission = [[InfomationItem alloc]init];
    
    itemNotify.name=@"消息中心";
    itemTips.name=@"小贴士";
    itemMission.name=@"任务中心";
    
    [_array1 addObject:itemNotify];
    
    [_array2 addObject:itemTips];
    
    [_array3 addObject:itemMission];
    
    //self.centerArray = [[NSArray alloc]initWithObjects:_array1,_array2,_array3, nil];
    self.centerArray = [[NSArray alloc]initWithObjects:_array2, nil];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView=nil;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator=NO;
    //    _settingTable.bounces=NO;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.centerArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.centerArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InformationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InformationCell"];
        cell.textLabel.font=[UIFont systemFontOfSize:17];
        cell.textLabel.textColor=[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell...
    InfomationItem *item=[[self.centerArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text=item.name;
    cell.accessoryView=item.accessView;
    cell.accessoryView.contentMode=UIViewContentModeScaleAspectFit;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    NSLog(@"indexpath:%d,%d", indexPath.section,indexPath.row);
    if (indexPath.section == -1) {
        NSLog(@"Go to Notify Page");
        NotifyViewController *notify = [[NotifyViewController alloc] init];
        [self.navigationController pushViewController:notify animated:YES];
    }
    else if (indexPath.section == 0) {
         AdviseMasterViewController *tipsMasterViewController = [[AdviseMasterViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:tipsMasterViewController animated:YES];
    }
    else
    {
        NSLog(@"Go to Mission Page");
        MissionViewController *mission = [[MissionViewController alloc]init];
        [self.navigationController pushViewController:mission animated:YES];
    }
   

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
}


@end
