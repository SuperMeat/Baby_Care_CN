//
//  BLEWeatherView.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-1-8.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "BLEWeatherView.h"
#import "Environmentitem.h"
#import "EnvironmentAdviceDB.h"
#import "WeatherAdviseViewController.h"
@implementation BLEWeatherView
@synthesize dataarray;
+(id)weatherview
{
    
    __strong static WeatherView *_sharedObject = nil;
    
    _sharedObject =  [[self alloc] init]; // or some other init metho
    
    return _sharedObject;
}

-(void)dealloc
{
    [gettimer invalidate];
}

-(id)init
{
    self=[super init];
    if (self){
        self.frame = CGRectMake(0, 0, 320, 200);
        getDataTimeInterval = 1.0;
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
    
    temp.headimage  = [UIImage imageNamed:@"icon_temperature.png"];
    humi.headimage  = [UIImage imageNamed:@"icon_humidity.png"];
    light.headimage = [UIImage imageNamed:@"icon_light.png"];
    sound.headimage = [UIImage imageNamed:@"icon_sound.png"];
    pm.headimage    = [UIImage imageNamed:@"icon_pm2.5.png"];
    uv.headimage    = [UIImage imageNamed:@"icon_uv.png"];
    
    dataarray = [[NSMutableArray alloc]initWithCapacity:0];
    [dataarray addObject:temp];
    [dataarray addObject:humi];
    [dataarray addObject:light];
    [dataarray addObject:sound];
    [dataarray addObject:uv];
    [dataarray addObject:pm];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(self.bounds.origin.x+(320-277*PNGSCALE)/2.0, self.bounds.origin.y+5, self.bounds.size.width*PNGSCALE-43*PNGSCALE, self.bounds.size.height*PNGSCALE+19) style:UITableViewStyleGrouped];
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.showsHorizontalScrollIndicator = NO;
    table.showsVerticalScrollIndicator   = NO;
    table.backgroundColor = [UIColor clearColor];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundView=nil;
    table.bounces=NO;
    
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:table];
    
    gettimer = [NSTimer scheduledTimerWithTimeInterval: getDataTimeInterval
                                                target: self
                                              selector: @selector(handleTimer:)
                                              userInfo: nil
                                               repeats: YES];

    //[[BLEWeather bleweather] getbleweather:^(NSDictionary *weatherDict) {
        NSDictionary *dict=[[BLEWeather bleweather] getbleweather];
        NSLog(@"weDic %@", dict);
        
        if([[dict objectForKey:@"temp"] length]>0)
        {
            temp.detail=[NSString stringWithFormat:@"%@℃",[dict objectForKey:@"temp"]];
        }
        
        if ([[dict objectForKey:@"humidity"] length]>0) {
            humi.detail=[NSString stringWithFormat:@"%@%%",[dict objectForKey:@"humidity"]];
        }
        
        if ([[dict objectForKey:@"light"] length]>0) {
            light.detail=[NSString stringWithFormat:@"%@",[dict objectForKey:@"light"]];
        }
        
        if ([[dict objectForKey:@"maxsound"] length]>0) {
            sound.detail=[NSString stringWithFormat:@"%@",[dict objectForKey:@"maxsound"]];
        }
        
        if ([[dict objectForKey:@"uv"] length]>0) {
            uv.detail=[NSString stringWithFormat:@"%@",[dict objectForKey:@"uv"]];
        }
    
        if ([[dict objectForKey:@"pm"] length]>0) {
            pm.detail=[NSString stringWithFormat:@"%@",[dict objectForKey:@"pm"]];
        }

    
        [dataarray replaceObjectAtIndex:0 withObject:temp];
        [dataarray replaceObjectAtIndex:1 withObject:humi];
        [dataarray replaceObjectAtIndex:2 withObject:light];
        [dataarray replaceObjectAtIndex:3 withObject:sound];
        [dataarray replaceObjectAtIndex:4 withObject:uv];
        [dataarray replaceObjectAtIndex:5 withObject:pm];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UITableView *tab=table;
            [tab reloadData];
        });
   // }];
}

- (void) handleTimer: (NSTimer *) timer
{
    if ([[BLEWeatherController bleweathercontroller] isConnected]) {
        [self refreshweather];
    }
}

-(void)refreshweather
{
    mAlTemp.mAdviseId = 0;
    mAlHumi.mAdviseId = 0;
    [self updatebledataarray];
}

-(void)updatebledataarray
{
    Environmentitem *temp=[[Environmentitem alloc]init];
    Environmentitem *humi=[[Environmentitem alloc]init];
    Environmentitem *light=[[Environmentitem alloc]init];
    Environmentitem *sound=[[Environmentitem alloc]init];
    Environmentitem *uv=[[Environmentitem alloc]init];
    Environmentitem *pm=[[Environmentitem alloc]init];
  
    //  [[BLEWeather bleweather] getbleweather:^(NSDictionary *weatherDict) {
        NSDictionary *dict=[[BLEWeather bleweather]getbleweather];
        NSLog(@"weDic %@", dict);
        
        if([[dict objectForKey:@"temp"] length]>0)
        {
            temp.detail=[NSString stringWithFormat:@"%@℃",[dict objectForKey:@"temp"]];
            NSArray *arr = [EnvironmentAdviceDB selectSuggestionByCondition:ENVIR_SUGGESTION_TYPE_TEMP andValue:[NSNumber numberWithInt:[[dict objectForKey:@"temp"] intValue]]];                        if ([arr count]>0) {
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
        
        if ([[dict objectForKey:@"light"] length]>0) {
            light.detail=[NSString stringWithFormat:@"%@",[dict objectForKey:@"light"]];
        }
        
        if ([[dict objectForKey:@"maxsound"] length]>0) {
            sound.detail=[NSString stringWithFormat:@"%@",[dict objectForKey:@"maxsound"]];
        }
        
        if ([[dict objectForKey:@"uv"] length]>0) {
            uv.detail=[NSString stringWithFormat:@"%@",[dict objectForKey:@"uv"]];
        }
    
        if ([[dict objectForKey:@"pm25"] length]>0)
        {
            pm.detail=[NSString stringWithFormat:@"%@",[dict    objectForKey:@"pm25"]];
        }

    
        Environmentitem *itemTemp = [dataarray objectAtIndex:0];
        itemTemp.detail = temp.detail;
        [dataarray replaceObjectAtIndex:0 withObject:itemTemp];
        
        Environmentitem *itemHumi = [dataarray objectAtIndex:1];
        itemHumi.detail = humi.detail;
        [dataarray replaceObjectAtIndex:1 withObject:itemHumi];
        
        Environmentitem *itemLight = [dataarray objectAtIndex:2];
        itemLight.detail = light.detail;
        [dataarray replaceObjectAtIndex:2 withObject:itemLight];
        
        Environmentitem *itemSound = [dataarray objectAtIndex:3];
        itemSound.detail = sound.detail;
        [dataarray replaceObjectAtIndex:3 withObject:itemSound];
        
        Environmentitem *itemUV = [dataarray objectAtIndex:4];
        itemUV.detail = uv.detail;
        [dataarray replaceObjectAtIndex:4 withObject:itemUV];
    
        Environmentitem *itemPM = [dataarray objectAtIndex:5];
        itemPM.detail = pm.detail;
        [dataarray replaceObjectAtIndex:5 withObject:itemPM];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UITableView *tab=table;
            [tab reloadData];
        });
   // }];
    
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
        //Cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UV"]];
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 554/2.0*PNGSCALE, 83/2.0*PNGSCALE)];
        if (indexPath.section == 0) {
            Cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"temp"]];
            //[image setImage:[UIImage imageNamed:@"temp"]];
        }
        
        if (indexPath.section == 1) {
            Cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"humidity"]];
            //[image setImage:[UIImage imageNamed:@"humidity"]];
        }
        
        if (indexPath.section == 2) {
            Cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"light"]];
            //[image setImage:[UIImage imageNamed:@"UV"]];
        }
        
        if (indexPath.section == 3) {
            Cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noice"]];
            //[image setImage:[UIImage imageNamed:@"light"]];
        }
        
        if (indexPath.section == 4) {
            Cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UV"]];
            //[image setImage:[UIImage imageNamed:@"noice"]];
        }
        
        if (indexPath.section == 5) {
            Cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pm25"]];
            //[image setImage:[UIImage imageNamed:@"pm25"]];
        }
        
       
        [Cell.contentView addSubview:image];
        Cell.backgroundColor = [UIColor clearColor];
        image.tag=104;
        Cell.textLabel.backgroundColor=[UIColor clearColor];
        Cell.detailTextLabel.backgroundColor=[UIColor clearColor];
        Cell.selectionStyle=UITableViewCellSelectionStyleNone;
        Cell.textLabel.textColor=[ACFunction colorWithHexString:@"#96999b"];
        Cell.textLabel.font = [UIFont systemFontOfSize:12];
        Cell.detailTextLabel.textColor=[UIColor whiteColor];
    }
    Environmentitem *item=[dataarray objectAtIndex:indexPath.section];
    Cell.imageView.image=item.headimage;
    
    //Cell.textLabel.text=item.title;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 80, 83/2.0*PNGSCALE)];
    title.textColor = [ACFunction colorWithHexString:@"#96999b"];
    title.font      = [UIFont fontWithName:@"Arvial" size:13];
    
    UIImageView *image=(UIImageView*)[Cell.contentView viewWithTag:104];
    title.text = item.title;
    UIImageView *levelImage = [[UIImageView alloc] initWithFrame:CGRectMake(image.frame.size.width-20-46/2.0*PNGSCALE, image.frame.size.height/2.0-41/2.0*PNGSCALE, 46/2.0*PNGSCALE, 41/2.0*PNGSCALE)];
    
    UILabel *weatherDetail = [[UILabel alloc]initWithFrame:CGRectMake(image.frame.size.width/2.0, 0, 50, image.frame.size.height)];
    weatherDetail.font = [UIFont fontWithName:@"Arvial" size:13];
    weatherDetail.textAlignment = NSTextAlignmentCenter;
    weatherDetail.textColor = [ACFunction colorWithHexString:@"#96999b"];
    [image addSubview:title];
    [image addSubview:levelImage];
    [image addSubview:weatherDetail];
    [image setBackgroundColor:[UIColor clearColor]];
    if (item.detail.length>0) {
        Cell.detailTextLabel.text=item.detail;
        [Cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
        //image.image=[UIImage imageNamed:@"icon_connected.png"];
    }
    else
    {
        //Cell.detailTextLabel.text=@"_______";
        //Cell.detailTextLabel.text=NSLocalizedString(@"WeatherDetail", nil);
        //[Cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
        weatherDetail.text = @"0";
        [levelImage setImage:[UIImage imageNamed:@"icon_grey"]];
    }
    return Cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83/2.0*PNGSCALE;
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
