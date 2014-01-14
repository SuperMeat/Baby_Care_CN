//
//  AdviseMasterViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-9-10.
//  Copyright (c) 2013年 爱摩信息科技. All rights reserved.
//

#import "AdviseMasterViewController.h"
#import "AdviseData.h"
#import "AdviseTableViewCell.h"
#import "TipsWebViewController.h"

#define originalHeight 25.0f
#define newHeight 100.0f
#define isOpen @"100.0f"
@interface AdviseMasterViewController ()
{
    NSMutableDictionary *dicClicked;
    CGFloat mHeight;
    NSInteger sectionIndex;
}
@end

@implementation AdviseMasterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        //self.title  = NSLocalizedString(@"btnadvise", nil);
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 100, 20)];
        titleView.backgroundColor=[UIColor clearColor];
        UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        titleText.backgroundColor = [UIColor clearColor];
        [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
        titleText.textColor = [UIColor whiteColor];
        [titleText setTextAlignment:NSTextAlignmentCenter];
        [titleText setText:NSLocalizedString(@"Tips", nil)];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    int lock  = [DataBase selectFromUserAdvise:ADVISE_TYPE_BATH];
    dataArray = [DataBase selectsuggestionbath:lock];
    mHeight = originalHeight;
    sectionIndex = 0;
    dicClicked = [NSMutableDictionary dictionaryWithCapacity:3];
    //[self.view setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    //[self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return [dataArray count];
    return 34;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   /*
    if (indexPath.row != 0) {
        static NSString *contentIndentifer = @"Container";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentIndentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentIndentifer];
        }
        AdviseData *ad = [dataArray objectAtIndex:indexPath.section];
        NSLog(@"row %d",indexPath.section);
        [cell setBackgroundColor:[UIColor clearColor]];
        
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.textLabel.text = ad.mContent;
        cell.textLabel.textColor = [UIColor colorWithRed:0x97/255.0 green:0x97/255.0 blue:0x97/255.0 alpha:0xFF/255.0];
        cell.textLabel.opaque =        NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
        cell.textLabel.numberOfLines = 20;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    static NSString *contentIndentifer = @"Title";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentIndentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentIndentifer];
    }
    NSString *str = @"Everything is OK!";
    NSLog(@"row %d",indexPath.section);
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.text = str;
    cell.textLabel.textColor = [UIColor colorWithRed:0x97/255.0 green:0x97/255.0 blue:0x97/255.0 alpha:0xFF/255.0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    */
    static NSString *CellIdentifier = @"Cell";
    
    UIImageView *tipsImageView;
    UILabel *tipsTitle;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AdviseTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    
    tipsImageView = (UIImageView*)[cell.contentView viewWithTag:1];
    tipsTitle     = (UILabel*)[cell.contentView viewWithTag:2];
    
    NSString *imageName,*title;
    //NSLog(@"%d",indexPath.section);
    if (indexPath.section < 5) {
        imageName = [NSString stringWithFormat:@"Feed_%d.jpg", indexPath.section + 1];
        title =[NSString stringWithFormat:@"Feed_T%d", indexPath.section + 1];
    }
    else if (indexPath.section < 10)
    {
        imageName = [NSString stringWithFormat:@"Sleep_%d.jpg", indexPath.section % 5 + 1];
         title =[NSString stringWithFormat:@"Sleep_T%d", indexPath.section % 5+ 1];
    }
    else if (indexPath.section < 16)
    {
        imageName = [NSString stringWithFormat:@"Bath_%d.jpg", indexPath.section % 10 + 1];
         title =[NSString stringWithFormat:@"Bath_T%d", indexPath.section % 10 + 1];
    }
    else if (indexPath.section < 21)
    {
        imageName = [NSString stringWithFormat:@"Diaper_%d.jpg", indexPath.section % 16 + 1];
        title = [NSString stringWithFormat:@"Diaper_T%d", indexPath.section % 16 + 1];

    }
    else
    {
        imageName = [NSString stringWithFormat:@"Play_%d.jpg", indexPath.section % 21 + 1];
        title = [NSString stringWithFormat:@"Play_T%d", indexPath.section % 21 + 1];
    }
    title = NSLocalizedString(title, nil);
    [tipsTitle setText:title];
    tipsTitle.numberOfLines = 0;
    tipsTitle.lineBreakMode=NSLineBreakByWordWrapping;
    tipsTitle.textAlignment=NSTextAlignmentCenter;
    tipsTitle.textColor = [UIColor colorWithRed:0xB3/255.0 green:0xB3/255.0 blue:0xB3/255.0 alpha:0xFF/255.0];
    [tipsTitle setFont:[UIFont fontWithName:@"Arial" size:15]];
    [tipsImageView setImage:[UIImage imageNamed:imageName]];
    [tipsImageView setFrame:CGRectMake(15, 15, 100, 60)];
    [tipsImageView setContentMode:UIViewContentModeScaleAspectFill];
    [cell.contentView addSubview:tipsTitle];
    [cell.contentView addSubview:tipsImageView];
    //cell.tipsTitle.text = @"Top breastfeeding tips";
    //cell.tipsTitle.textColor = [UIColor colorWithRed:0x97/255.0 green:0x97/255.0 blue:0x97/255.0 alpha:0xFF/255.0];
    
    return cell;

    
}
//Section的标题栏高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0)
//        return 46;
//    else
//        return 30.0f;
//    if (section == 0)
//        return 0;
//    else
//        return 10;
    if (section == 0)
        return 0;
    else
        return 1;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect headerFrame = CGRectMake(0, 0, 300, 30);
    CGFloat y = 2;
    if (section == 0) {
        headerFrame = CGRectMake(0, 0, 300, 100);
        y = 18;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
    [headerView setAlpha:0.5];
    //[headerView setBackgroundColor:[UIColor colorWithRed:0x97/255.0 green:0x97/255.0 blue:0x97/255.0 alpha:0xFF/255.0]];
    [headerView setBackgroundColor:[UIColor grayColor]];
    UILabel *dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, y, 240, 24)];//日期标签
    dateLabel.font=[UIFont boldSystemFontOfSize:16.0f];
    dateLabel.textColor = [UIColor colorWithRed:0.889 green:0.486 blue:0.882 alpha:1.000];
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

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row != 0) {
//        if ([[dicClicked objectForKey:indexPath] isEqualToString: isOpen])
//            return [[dicClicked objectForKey:indexPath] floatValue];
//        else
//            return originalHeight;
//    }
//    else {
//        return 25.0f;
//    }
    return 120;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
        if (targetCell.frame.size.height == originalHeight){
            [dicClicked setObject:isOpen forKey:indexPath];
        }
        else{
            [dicClicked removeObjectForKey:indexPath];
        }
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    NSString *url, *key;
    if (indexPath.section < 5) {
        key = [NSString stringWithFormat:@"Feed_%d", indexPath.section + 1];
    }
    else if (indexPath.section < 10)
    {
        key = [NSString stringWithFormat:@"Sleep_%d", indexPath.section %5+ 1];
    }
    else if (indexPath.section < 16)
    {
        key = [NSString stringWithFormat:@"Bath_%d", indexPath.section %10+ 1];
    }
    else if (indexPath.section < 21)
    {
        key = [NSString stringWithFormat:@"Diaper_%d", indexPath.section%16 + 1];
    }
    else
    {
        key = [NSString stringWithFormat:@"Play_%d", indexPath.section %21+ 1];
    }
    
    url = NSLocalizedString(key, nil);
    TipsWebViewController *tips = [[TipsWebViewController alloc] init];
    [tips setTipsUrl:url];
    [self.navigationController pushViewController:tips animated:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
