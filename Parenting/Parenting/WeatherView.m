//
//  WeatherView.m
//  Parenting
//
//  Created by user on 13-5-30.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "WeatherView.h"
#import "Environmentitem.h"
#import "EnvironmentAdviceDB.h"
#import "WeatherAdviseViewController.h"

@implementation WeatherView
@synthesize dataarray;
+(id)weatherview
{

    __strong static WeatherView *_sharedObject = nil;

      _sharedObject =  [[self alloc] init]; // or some other init metho

    return _sharedObject;
}

-(id)init
{
    self=[super init];
    if (self){
        self.frame = CGRectMake(0, 0, 320, 200);
        
//        self.backgroundColor=[UIColor redColor];
    }
    return self;
}

-(void)makeview
{
    [self makeView];
}

-(void)makeView
{
    dataarray =[[NSMutableArray alloc]init];
    Environmentitem *temp = [[Environmentitem alloc]init];
    Environmentitem *humi = [[Environmentitem alloc]init];
    Environmentitem *light= [[Environmentitem alloc]init];
    Environmentitem *sound= [[Environmentitem alloc]init];
    Environmentitem *pm   = [[Environmentitem alloc]init];
    Environmentitem *uv   = [[Environmentitem alloc]init];
    
    temp.tag  = 1;
    humi.tag  = 2;
    light.tag = 3;
    sound.tag = 4;
    pm.tag    = 5;
    uv.tag    = 6;
    
    temp.title=NSLocalizedString(@"Temperature",nil);
    humi.title=NSLocalizedString(@"Humidity",nil);
    light.title=NSLocalizedString(@"Light",nil);
    sound.title=NSLocalizedString(@"Sound",nil);
    pm.title=NSLocalizedString(@"PM2.5",nil);
    uv.title=NSLocalizedString(@"UV",nil);
    
    temp.headimage=[UIImage imageNamed:@"icon_temperature.png"];
    humi.headimage=[UIImage imageNamed:@"icon_humidity.png"];
    light.headimage=[UIImage imageNamed:@"icon_light.png"];
    sound.headimage=[UIImage imageNamed:@"icon_sound.png"];
    pm.headimage=[UIImage imageNamed:@"icon_pm2.5.png"];
    uv.headimage=[UIImage imageNamed:@"icon_uv.png"];
    
    dataarray=[[NSMutableArray alloc]initWithCapacity:0];
    [dataarray addObject:temp];
    [dataarray addObject:humi];

    if (CUSTOMER_COUNTRY == 0)
    {
        [dataarray addObject:uv];
    }
    else
    {
        [dataarray addObject:pm];
    }

//    table = [[UITableView alloc]initWithFrame:CGRectMake(self.bounds.origin.x+10, self.bounds.origin.y+8, self.bounds.size.width-20, self.bounds.size.height) style:UITableViewStyleGrouped];
//    table.separatorStyle = UITableViewCellSeparatorStyleNone;
//    table.backgroundColor=[UIColor clearColor];
//    table.delegate = self;
//    table.dataSource = self;
//    table.backgroundView=nil;
//    table.bounces=NO;
//    
//    [self setBackgroundColor:[UIColor whiteColor]];
    //[self addSubview:table];

    tempDetail = [[UILabel alloc] initWithFrame:CGRectMake(376/2.0, 372/2.0*PNGSCALE-110*PNGSCALE-155/2.0*PNGSCALE, 246/2.0*PNGSCALE, 155/2.0*PNGSCALE)];
    [tempDetail setBackgroundColor:[UIColor clearColor]];
    [tempDetail setTextColor:[ACFunction colorWithHexString:@"#69becc"]];
    tempDetail.textAlignment = NSTextAlignmentCenter;
    tempDetail.text =@"0";
    tempDetail.font = [UIFont fontWithName:@"Arial" size:80*PNGSCALE];
    [self addSubview:tempDetail];
    
    weatherStatus = [[UILabel alloc] initWithFrame:CGRectMake(20,155/2.0*PNGSCALE,100,15)];
    weatherStatus.text = @"超级龙卷风";
    [weatherStatus setBackgroundColor:[UIColor clearColor]];
    weatherStatus.font = [UIFont fontWithName:@"Arial" size:12];
    weatherStatus.textAlignment = NSTextAlignmentLeft;
    [weatherStatus setTextColor:[ACFunction colorWithHexString:@"#7a7a7a"]];
    [self addSubview:weatherStatus];
    
    airDetail = [[UILabel alloc] initWithFrame:CGRectMake(20,155/2.0*PNGSCALE+2+15, 100, 15)];
    airDetail.text = @"空气质量指数:暂无";
    airDetail.font = [UIFont fontWithName:@"Arial" size:12];
    airDetail.textAlignment = NSTextAlignmentLeft;
    [airDetail setTextColor:[ACFunction colorWithHexString:@"#7a7a7a"]];
    [self addSubview:airDetail];
    
    humiDetail = [[UILabel alloc] initWithFrame:CGRectMake(20,155/2.0*PNGSCALE+2+15+15, 100, 15)];
    humiDetail.text = @"湿度:0%";
    humiDetail.font = [UIFont fontWithName:@"Arial" size:12];
    humiDetail.textAlignment = NSTextAlignmentLeft;
    [humiDetail setTextColor:[ACFunction colorWithHexString:@"#7a7a7a"]];
    [self addSubview:humiDetail];
    
    statusBigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(376/2.0+5, 372/2.0*PNGSCALE-110*PNGSCALE-155/2.0*PNGSCALE+155/2.0*PNGSCALE-10, 118/2.0, 132/2.0)];
    [statusBigImageView setImage:[UIImage imageNamed:@"icon_cloudy"]];
    [self addSubview:statusBigImageView];
    
    todayView = [[UIView alloc]initWithFrame:CGRectMake(0, 200-80, 320/3.0, 80)];
    [todayView setBackgroundColor:[UIColor redColor]];
    [self addSubview:todayView];
    
    tomorrowView = [[UIView alloc]initWithFrame:CGRectMake(320/3.0, 200-80, 320/3.0, 80)];
    [tomorrowView setBackgroundColor:[UIColor blueColor]];
    [self addSubview:tomorrowView];
    
    afertomorrowView = [[UIView alloc]initWithFrame:CGRectMake(320-320/3.0, 200-80, 320/3.0, 80)];
    [afertomorrowView setBackgroundColor:[UIColor yellowColor]];
    [self addSubview:afertomorrowView];
    
    [[Weather weather] getweather:^(NSDictionary *weatherDict) {
        NSDictionary *dict=weatherDict;
        NSLog(@"weDic %@", dict);
        
        if([[dict objectForKey:@"temp"] length]>0)
        {
            temp.detail=[NSString stringWithFormat:@"%@℃",[dict objectForKey:@"temp"]];
            tempDetail.text =[NSString stringWithFormat:@"%@°",[dict objectForKey:@"temp"]];
        }
        if ([[dict objectForKey:@"humidity"] length]>0) {
            humi.detail=[NSString stringWithFormat:@"%@%%",[dict objectForKey:@"humidity"]];
            humiDetail.text = [NSString stringWithFormat:@"湿度:%@%%",[dict objectForKey:@"humidity"]];
        }
        
        if (CUSTOMER_COUNTRY == 1) {
            if ([[dict objectForKey:@"PM25"] length]>0) {
                int pmvalue = [[dict objectForKey:@"PM25"] intValue];
                if (pmvalue > 0) {
                    pm.detail=[NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"PM25"],[OpenFunction getpm25description:pmvalue]];
                    airDetail.text = [NSString stringWithFormat:@"空气指数:%@",[dict objectForKey:@"PM25"]];
                    [dataarray replaceObjectAtIndex:2 withObject:pm];
                }
            }
            
        }
        
        [dataarray replaceObjectAtIndex:0 withObject:temp];
        [dataarray replaceObjectAtIndex:1 withObject:humi];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UITableView *tab=table;
            [tab reloadData];
        });
    }];
    
}

-(void)refreshweather
{
    mAlTemp.mAdviseId = 0;
    mAlHumi.mAdviseId = 0;
    [self updatedataarray];
}

-(void)updatedataarray
{
    Environmentitem *temp=[[Environmentitem alloc]init];
    Environmentitem *humi=[[Environmentitem alloc]init];
    //  Environmentitem *light=[[Environmentitem alloc]init];
    //  Environmentitem *sound=[[Environmentitem alloc]init];
    Environmentitem *pm=[[Environmentitem alloc]init];
    //  Environmentitem *uv=[[Environmentitem alloc]init];
    
    [[Weather weather] getweather:^(NSDictionary *weatherDict) {
        NSDictionary *dict=weatherDict;
        NSLog(@"weDic %@", dict);
        
        if([[dict objectForKey:@"temp"] length]>0)
        {
            temp.detail=[NSString stringWithFormat:@"%@℃",[dict objectForKey:@"temp"]];
            tempDetail.text = [NSString stringWithFormat:@"%@°",[dict objectForKey:@"temp"]];
            
            NSArray *arr = [EnvironmentAdviceDB selectSuggestionByCondition:ENVIR_SUGGESTION_TYPE_TEMP andValue:[NSNumber numberWithInt:[[dict objectForKey:@"temp"] intValue]]];

            if ([arr count]>0) {
                AdviseLevel *al = [arr objectAtIndex:0];
                NSArray *a2 = [EnvironmentAdviceDB selectSuggestionBySid:al.mAdviseId andCondition:ENVIR_SUGGESTION_TYPE_TEMP];
                if ([a2 count]>0) {
                   AdviseData* ad = [a2 objectAtIndex:0];
                    tempcontent = ad.mContent;
                    templevel   = al.mLevel;
                    mAdTemp = ad;
                    mAlTemp = al;
                }
            }
            
        }
        if ([[dict objectForKey:@"humidity"] length]>0) {
            humi.detail=[NSString stringWithFormat:@"%@ %%",[dict objectForKey:@"humidity"]];
            humiDetail.text = [NSString stringWithFormat:@"湿度:%@%%",[dict objectForKey:@"humidity"]];

            NSArray *arr = [EnvironmentAdviceDB selectSuggestionByCondition:ENVIR_SUGGESTION_TYPE_HUMI andValue:[NSNumber numberWithInt:[[dict objectForKey:@"humidity"] intValue]]];
            
            if ([arr count]>0) {
                AdviseLevel *al = [arr objectAtIndex:0];
                NSArray *a2 = [EnvironmentAdviceDB selectSuggestionBySid:al.mAdviseId andCondition:ENVIR_SUGGESTION_TYPE_HUMI];
                if ([a2 count]>0) {
                    AdviseData* ad = [a2 objectAtIndex:0];
                    tempcontent = ad.mContent;
                    templevel   = al.mLevel;
                    mAdHumi = ad;
                    mAlHumi = al;
                }
            }
        }
        
        if (CUSTOMER_COUNTRY == 1) {
            if ([[dict objectForKey:@"PM25"] length]>0) {
                int pmvalue = [[dict objectForKey:@"PM25"] intValue];
                if (pmvalue > 0) {
                    pm.detail=[NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"PM25"],[OpenFunction getpm25description:pmvalue]];
                    airDetail.text = [NSString stringWithFormat:@"空气指数: %@",[dict objectForKey:@"PM25"]];
                    Environmentitem *itemPM25 = [dataarray objectAtIndex:2];
                    itemPM25.detail = pm.detail;
                    [dataarray replaceObjectAtIndex:2 withObject:itemPM25];
                }
            }
            
        }
        
        Environmentitem *itemTemp = [dataarray objectAtIndex:0];
        itemTemp.detail = temp.detail;
        [dataarray replaceObjectAtIndex:0 withObject:itemTemp];
        
        Environmentitem *itemHumi = [dataarray objectAtIndex:1];
        itemHumi.detail = humi.detail;
        [dataarray replaceObjectAtIndex:1 withObject:itemHumi];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UITableView *tab=table;
            [tab reloadData];
        });
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataarray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (Cell==nil) {
        Cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ID"];
        Cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_env.png"]];
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(150, 2, 30, 30)];
        [Cell.contentView addSubview:image];
        Cell.backgroundColor = [UIColor clearColor];
        image.tag=104;
        Cell.textLabel.backgroundColor=[UIColor clearColor];
        Cell.detailTextLabel.backgroundColor=[UIColor clearColor];
        Cell.selectionStyle=UITableViewCellSelectionStyleNone;
        Cell.textLabel.textColor=[UIColor colorWithRed:0x76/255.0 green:0x72/255.0 blue:0x71/255.0 alpha:0xFF/255.0];
        Cell.textLabel.font=[UIFont systemFontOfSize:15];
        Cell.detailTextLabel.textColor=[UIColor whiteColor];
    }
    Environmentitem *item=[dataarray objectAtIndex:indexPath.section];
    Cell.imageView.image=item.headimage;

    Cell.textLabel.text=item.title;
    UIImageView *image=(UIImageView*)[Cell.contentView viewWithTag:104];
    
    if (item.detail.length>0) {
        Cell.detailTextLabel.text=item.detail;
        [Cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
        image.image=[UIImage imageNamed:@"icon_connected.png"];
    }
    else
    {
        //Cell.detailTextLabel.text=@"_______";
        Cell.detailTextLabel.text=NSLocalizedString(@"WeatherDetail", nil);
        [Cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
        image.image=[UIImage imageNamed:@"icon_notconnected.png"];
    }
    return Cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 33;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d,%d",indexPath.section, indexPath.row);
    if (indexPath.section == 0 && mAlTemp.mAdviseId > 0) {
        NSString *title;
        switch (mAlTemp.mLevel) {
            case 1:
                title = @"Excellent";
                break;
            case 2:
                title = @"Good";
                break;
            case 3:
                title = @"Bad";
                break;
            default:
                break;
        }
        
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:title contentText:mAdTemp.mContent leftButtonTitle:nil rightButtonTitle:@"OK"];
        [alert show];
    }
    
    if (indexPath.section == 1 && mAlHumi.mAdviseId > 0) {
        NSString *title;
        switch (mAlHumi.mLevel) {
            case 1:
                title = @"Excellent";
                break;
            case 2:
                title = @"Good";
                break;
            case 3:
                title = @"Bad";
                break;
            default:
                break;
        }
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:title contentText:mAdHumi.mContent leftButtonTitle:nil rightButtonTitle:@"OK"];
        [alert show];
    }
}
@end
