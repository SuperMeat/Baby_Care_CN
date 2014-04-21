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
    
//    temp.headimage=[UIImage imageNamed:@"icon_temperature.png"];
//    humi.headimage=[UIImage imageNamed:@"icon_humidity.png"];
//    light.headimage=[UIImage imageNamed:@"icon_light.png"];
//    sound.headimage=[UIImage imageNamed:@"icon_sound.png"];
//    pm.headimage=[UIImage imageNamed:@"icon_pm2.5.png"];
//    uv.headimage=[UIImage imageNamed:@"icon_uv.png"];
    
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

    tempDetail = [[UILabel alloc] initWithFrame:CGRectMake(376/2.0-10, 372/2.0*PNGSCALE-110*PNGSCALE-155/2.0*PNGSCALE, 246/2.0*PNGSCALE+50, 155/2.0*PNGSCALE)];
    [tempDetail setBackgroundColor:[UIColor clearColor]];
    [tempDetail setTextColor:[ACFunction colorWithHexString:@"#69becc"]];
    tempDetail.textAlignment = NSTextAlignmentCenter;
    //tempDetail.text =@"0℃";
    tempDetail.font = [UIFont fontWithName:@"Arial" size:70*PNGSCALE];
    [self addSubview:tempDetail];
    
    weatherStatus = [[UILabel alloc] initWithFrame:CGRectMake(20,155/2.0*PNGSCALE,100,15)];
    weatherStatus.text = @"获取中";
    [weatherStatus setBackgroundColor:[UIColor clearColor]];
    weatherStatus.font = [UIFont fontWithName:@"Arial" size:12];
    weatherStatus.textAlignment = NSTextAlignmentLeft;
    [weatherStatus setTextColor:[ACFunction colorWithHexString:@"#7a7a7a"]];
    [self addSubview:weatherStatus];
    
    airDetail = [[UILabel alloc] initWithFrame:CGRectMake(20,155/2.0*PNGSCALE+2+15, 100, 15)];
    airDetail.text = @"污染指数:暂无";
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
    [todayView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *todayLabel = [[UILabel alloc] initWithFrame:CGRectMake(320/3.0/2.0-50, 0, 100, 20)];
    todayLabel.text  =@"今天";
    todayLabel.textColor = [ACFunction colorWithHexString:@"#69becc"];
    todayLabel.textAlignment = NSTextAlignmentCenter;
    todayLabel.font = [UIFont fontWithName:@"Arial" size:15];
    [todayView addSubview:todayLabel];
    
    statusSmallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 22, 118/2.0*WEATHERICONSCALE, 132/2.0*WEATHERICONSCALE)];
    [statusSmallImageView setImage:[UIImage imageNamed:@"icon_cloudy"]];
    [todayView addSubview:statusSmallImageView];
    
    temp1 = [[UILabel alloc] initWithFrame:CGRectMake(70, 22, 30, 15)];
    temp1.text = @"获取中";
    temp1.textAlignment = NSTextAlignmentCenter;
    temp1.textColor = [ACFunction colorWithHexString:@"#69becc"];
    temp1.font = [UIFont fontWithName:@"Arial" size:12];
    [todayView addSubview:temp1];
    
    cutlineToday = [[UIImageView alloc] initWithFrame:CGRectMake(70, 22+2+15, 30, 1)];
    [cutlineToday setImage:[UIImage imageNamed:@"line_dotted_blue"]];
    [todayView addSubview:cutlineToday];
    
    temp2 = [[UILabel alloc] initWithFrame:CGRectMake(70, 22+19, 30, 15)];
    temp2.text = @"获取中";
    temp2.textAlignment = NSTextAlignmentCenter;
    temp2.textColor = [ACFunction colorWithHexString:@"#69becc"];
    temp2.font = [UIFont fontWithName:@"Arial" size:12];
    [todayView addSubview:temp2];
    
    smallStatus = [[UILabel alloc] initWithFrame:CGRectMake(320/3.0/2.0-50, 80-22, 100, 20)];
    smallStatus.text = @"获取中";
    smallStatus.font = [UIFont fontWithName:@"Arial" size:12];
    smallStatus.textAlignment = NSTextAlignmentCenter;
    smallStatus.textColor = [ACFunction colorWithHexString:@"#69becc"];
    [todayView addSubview:smallStatus];
    
    [self addSubview:todayView];
    
    tomorrowView = [[UIView alloc]initWithFrame:CGRectMake(320/3.0, 200-80, 320/3.0, 80)];
    [tomorrowView setBackgroundColor:[UIColor clearColor]];
    UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(320/3.0/2.0-50, 0, 100, 20)];
    Label2.text  =@"明天";
    Label2.textColor = [ACFunction colorWithHexString:@"#7a7a7a"];
    Label2.textAlignment = NSTextAlignmentCenter;
    Label2.font = [UIFont fontWithName:@"Arial" size:15];
    [tomorrowView addSubview:Label2];

    statusTomorrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 22, 118/2.0*WEATHERICONSCALE, 132/2.0*WEATHERICONSCALE)];
    [statusTomorrowImageView setImage:[UIImage imageNamed:@"icon_cloudy"]];
    [tomorrowView addSubview:statusTomorrowImageView];
    
    temp21 = [[UILabel alloc] initWithFrame:CGRectMake(70, 22, 30, 15)];
    temp21.text = @"获取中";
    temp21.textAlignment = NSTextAlignmentCenter;
    temp21.textColor = [ACFunction colorWithHexString:@"#7a7a7a"];
    temp21.font = [UIFont fontWithName:@"Arial" size:12];
    [tomorrowView addSubview:temp21];
    
    cutlineTomorrow = [[UIImageView alloc] initWithFrame:CGRectMake(70, 22+2+15, 30, 1)];
    [cutlineTomorrow setImage:[UIImage imageNamed:@"line_dotted_grey"]];
    [tomorrowView addSubview:cutlineTomorrow];
    
    temp22 = [[UILabel alloc] initWithFrame:CGRectMake(70, 22+19, 30, 15)];
    temp22.text = @"获取中";
    temp22.textAlignment = NSTextAlignmentCenter;
    temp22.textColor = [ACFunction colorWithHexString:@"#7a7a7a"];
    temp22.font = [UIFont fontWithName:@"Arial" size:12];
    [tomorrowView addSubview:temp22];
    
    tomorrowStatus = [[UILabel alloc] initWithFrame:CGRectMake(320/3.0/2.0-50, 80-22, 100, 20)];
    tomorrowStatus.text = @"获取中";
    tomorrowStatus.font = [UIFont fontWithName:@"Arial" size:12];
    tomorrowStatus.textAlignment = NSTextAlignmentCenter;
    tomorrowStatus.textColor = [ACFunction colorWithHexString:@"#7a7a7a"];
    [tomorrowView addSubview:tomorrowStatus];
    
    [self addSubview:tomorrowView];
    
    aftertomorrowView = [[UIView alloc]initWithFrame:CGRectMake(320-320/3.0, 200-80, 320/3.0, 80)];
    [aftertomorrowView setBackgroundColor:[UIColor clearColor]];
    UILabel *Label3= [[UILabel alloc] initWithFrame:CGRectMake(320/3.0/2.0-50, 0, 100, 20)];
    Label3.text  =@"后天";
    Label3.textColor = [ACFunction colorWithHexString:@"#7a7a7a"];
    Label3.textAlignment = NSTextAlignmentCenter;
    Label3.font = [UIFont fontWithName:@"Arial" size:15];
    [aftertomorrowView addSubview:Label3];
    
    statusAfterTomorrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 22, 118/2.0*WEATHERICONSCALE, 132/2.0*WEATHERICONSCALE)];
    [statusAfterTomorrowImageView setImage:[UIImage imageNamed:@"icon_cloudy"]];
    [aftertomorrowView addSubview:statusAfterTomorrowImageView];
    
    temp31 = [[UILabel alloc] initWithFrame:CGRectMake(70, 22, 30, 15)];
    temp31.text = @"获取中";
    temp31.textAlignment = NSTextAlignmentCenter;
    temp31.textColor = [ACFunction colorWithHexString:@"#7a7a7a"];
    temp31.font = [UIFont fontWithName:@"Arial" size:12];
    [aftertomorrowView addSubview:temp31];
    
    cutlineAfterTomorrow = [[UIImageView alloc] initWithFrame:CGRectMake(70, 22+2+15, 30, 1)];
    [cutlineAfterTomorrow setImage:[UIImage imageNamed:@"line_dotted_grey"]];
    [aftertomorrowView addSubview:cutlineAfterTomorrow];
    
    temp32 = [[UILabel alloc] initWithFrame:CGRectMake(70, 22+19, 30, 15)];
    temp32.text = @"获取中";
    temp32.textAlignment = NSTextAlignmentCenter;
    temp32.textColor = [ACFunction colorWithHexString:@"#7a7a7a"];
    temp32.font = [UIFont fontWithName:@"Arial" size:12];
    [aftertomorrowView addSubview:temp32];
    
    aftertomorrowStatus = [[UILabel alloc] initWithFrame:CGRectMake(320/3.0/2.0-50, 80-22, 100, 20)];
    aftertomorrowStatus.text = @"获取中";
    aftertomorrowStatus.font = [UIFont fontWithName:@"Arial" size:12];
    aftertomorrowStatus.textAlignment = NSTextAlignmentCenter;
    aftertomorrowStatus.textColor = [ACFunction colorWithHexString:@"#7a7a7a"];
    [aftertomorrowView addSubview:aftertomorrowStatus];
    
    [self addSubview:aftertomorrowView];
    
    UIImageView *cutline1 = [[UIImageView alloc] initWithFrame:CGRectMake(320/3.0+1, 120, 1, 80)];
    [cutline1 setImage:[UIImage imageNamed:@"cutline_y"]];
    [self addSubview:cutline1];
    
    UIImageView *cutline2 = [[UIImageView alloc] initWithFrame:CGRectMake(320/3.0+1+320/3.0+1, 120, 1, 80)];
    [cutline2 setImage:[UIImage imageNamed:@"cutline_y"]];
    [self addSubview:cutline2];
    
    NSDictionary* dictoday = [[Weather weather]getWeatherDetail:0];
    if (dictoday != nil) {
        weatherStatus.text = [dictoday objectForKey:@"zwx_s"];
        airDetail.text     = [NSString stringWithFormat:@"污染指数:%@",[dictoday objectForKey:@"pollution_l"]];
        
        smallStatus.text   = [dictoday objectForKey:@"weatherstatus"];
        [statusBigImageView setImage:[self getweathericon:smallStatus.text]];
        [statusSmallImageView setImage:[self getweathericon:smallStatus.text]];
        
        temp1.text = [NSString stringWithFormat:@"%d℃",[[dictoday objectForKey:@"temperature1"] intValue]];
        temp2.text = [NSString stringWithFormat:@"%d℃",[[dictoday objectForKey:@"temperature2"] intValue]];
        
        wearDetail  = [dictoday objectForKey:@"chy_shuoming"];
        confortable = [dictoday objectForKey:@"ssd_s"];
        ktDetail    = [dictoday objectForKey:@"ktk_l"];
        xcDetail    = [dictoday objectForKey:@"xcz_s"];
        gmDetail    = [dictoday objectForKey:@"gm_l"];
        gmsDetail   = [dictoday objectForKey:@"gm_s"];
        ydDetail    = [dictoday objectForKey:@"yd_s"];

    }
    
    NSDictionary* dic2moro = [[Weather weather]getWeatherDetail:1];
    if (dic2moro != nil) {
        tomorrowStatus.text = [dic2moro objectForKey:@"weatherstatus"];
        [statusTomorrowImageView setImage:[self getweathericon:tomorrowStatus.text]];
        
        temp21.text = [NSString stringWithFormat:@"%d℃",[[dic2moro objectForKey:@"temperature1"] intValue]];
        temp22.text = [NSString stringWithFormat:@"%d℃",[[dic2moro objectForKey:@"temperature2"] intValue]];
    }
    
    NSDictionary* dicafter = [[Weather weather]getWeatherDetail:2];
    if (dicafter != nil) {
        aftertomorrowStatus.text = [dicafter objectForKey:@"weatherstatus"];
        [statusAfterTomorrowImageView setImage:[self getweathericon:aftertomorrowStatus.text]];
        temp31.text = [NSString stringWithFormat:@"%d℃",[[dicafter objectForKey:@"temperature1"] intValue]];
        temp32.text = [NSString stringWithFormat:@"%d℃",[[dicafter objectForKey:@"temperature2"] intValue]];
    }

    [[Weather weather] getweather:^(NSDictionary *weatherDict) {
        NSDictionary *dict=weatherDict;
        NSLog(@"weDic %@", dict);
        
        if([[dict objectForKey:@"temp"] length]>0)
        {
            tempDetail.text =[NSString stringWithFormat:@"%@℃",[dict objectForKey:@"temp"]];
        }
        if ([[dict objectForKey:@"humidity"] length]>0) {
            humiDetail.text = [NSString stringWithFormat:@"湿度:%@%%",[dict objectForKey:@"humidity"]];
        }
        
        if (CUSTOMER_COUNTRY == 1) {
            if ([[dict objectForKey:@"PM25"] length]>0) {
                int pmvalue = [[dict objectForKey:@"PM25"] intValue];
                if (pmvalue > 0) {
                    airDetail.text = [NSString stringWithFormat:@"空气指数:%@",[dict objectForKey:@"PM25"]];
                }
            }
            
        }
        
        
    }];
    
}

-(void)refreshweather
{
    mAlTemp.mAdviseId = 0;
    mAlHumi.mAdviseId = 0;
    [self updatedataarray];
}

-(NSString*)getChuanYiAdvise
{
    return [NSString stringWithFormat:@"【穿衣指数】%@,%@\n\r", wearDetail,confortable];;
}

-(NSString*)getOutSideAdvise
{
    return [NSString stringWithFormat:@"【空调指数】%@\r【洗车指数】%@", ktDetail,xcDetail];
}

-(NSString*)getHealthAdvise
{
    return [NSString stringWithFormat:@"【运动指数】%@\r【感冒指数】%@,%@", ydDetail,gmDetail,gmsDetail];
}

-(UIImage*)getweathericon:(NSString*)status
{
   NSArray *array = [[NSArray alloc] initWithObjects:@"云",@"雨",@"雷",@"阴",@"晴",@"雪",nil];
    for (NSString *key in array) {
        NSRange range=[status rangeOfString:key];
        if(range.location!=NSNotFound)
        {
            if ([key isEqualToString:@"云"]) {
                return [UIImage imageNamed:@"icon_cloudy"];

            }
            else if ([key isEqualToString:@"雨"])
            {
                return [UIImage imageNamed:@"icon_little_rainy"];
            }
            else if ([key isEqualToString:@"雷"])
            {
                return [UIImage imageNamed:@"icon_thurderrain"];
            }
            else if ([key isEqualToString:@"阴"])
            {
                return [UIImage imageNamed:@"icon_yin"];
            }
            else if ([key isEqualToString:@"晴"])
            {
                if ([ACDate getCurrentHour] >= 18 || [ACDate getCurrentHour] <= 6) {
                    return [UIImage imageNamed:@"icon_moon"];
                };
                return [UIImage imageNamed:@"icon_sunny"];
            }
        }

    }
    
    return nil;
}

-(void)updatedataarray
{
    NSDictionary* dictoday = [[Weather weather]getWeatherDetail:0];
    if (dictoday != nil) {
        weatherStatus.text = [dictoday objectForKey:@"zwx_s"];
        airDetail.text     = [NSString stringWithFormat:@"污染指数:%@",[dictoday objectForKey:@"pollution_l"]];
        
        smallStatus.text   = [dictoday objectForKey:@"weatherstatus"];
        [statusBigImageView setImage:[self getweathericon:smallStatus.text]];
        [statusSmallImageView setImage:[self getweathericon:smallStatus.text]];

        temp1.text = [NSString stringWithFormat:@"%d℃",[[dictoday objectForKey:@"temperature1"] intValue]];
        temp2.text = [NSString stringWithFormat:@"%d℃",[[dictoday objectForKey:@"temperature2"] intValue]];
        wearDetail  = [dictoday objectForKey:@"chy_shuoming"];
        confortable = [dictoday objectForKey:@"ssd_s"];
        ktDetail    = [dictoday objectForKey:@"ktk_l"];
        xcDetail    = [dictoday objectForKey:@"xcz_s"];
        gmDetail    = [dictoday objectForKey:@"gm_l"];
        gmsDetail   = [dictoday objectForKey:@"gm_s"];
        ydDetail    = [dictoday objectForKey:@"yd_s"];

    }
    
    NSDictionary* dic2moro = [[Weather weather]getWeatherDetail:1];
    if (dic2moro != nil) {
        tomorrowStatus.text = [dic2moro objectForKey:@"weatherstatus"];
        [statusTomorrowImageView setImage:[self getweathericon:tomorrowStatus.text]];

        temp21.text = [NSString stringWithFormat:@"%d℃",[[dic2moro objectForKey:@"temperature1"] intValue]];
        temp22.text = [NSString stringWithFormat:@"%d℃",[[dic2moro objectForKey:@"temperature2"] intValue]];
    }
    
    NSDictionary* dicafter = [[Weather weather]getWeatherDetail:2];
    if (dicafter != nil) {
        aftertomorrowStatus.text = [dicafter objectForKey:@"weatherstatus"];
                [statusAfterTomorrowImageView setImage:[self getweathericon:aftertomorrowStatus.text]];
        temp31.text = [NSString stringWithFormat:@"%d℃",[[dicafter objectForKey:@"temperature1"] intValue]];
        temp32.text = [NSString stringWithFormat:@"%d℃",[[dicafter objectForKey:@"temperature2"] intValue]];
    }
    
    [[Weather weather] getweather:^(NSDictionary *weatherDict) {
        NSDictionary *dict=weatherDict;
        NSLog(@"weDic %@", dict);
        
        if([[dict objectForKey:@"temp"] length]>0)
        {
            tempDetail.text = [NSString stringWithFormat:@"%@℃",[dict objectForKey:@"temp"]];
            
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
                    airDetail.text = [NSString stringWithFormat:@"空气指数: %@",[dict objectForKey:@"PM25"]];
                    Environmentitem *itemPM25 = [dataarray objectAtIndex:2];
                    [dataarray replaceObjectAtIndex:2 withObject:itemPM25];
                }
            }
            
        }
        
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
