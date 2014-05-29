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
    
    __strong static BLEWeatherView *_sharedObject = nil;
    
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
        self.frame = CGRectMake(0, 0, 320, 200+YADD);
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
    
    temp.title = NSLocalizedString(@"Temperature",nil);
    humi.title = NSLocalizedString(@"Humidity",nil);
    light.title= NSLocalizedString(@"Light",nil);
    sound.title= NSLocalizedString(@"Sound",nil);
    pm.title   = NSLocalizedString(@"PM2.5",nil);
    uv.title   = NSLocalizedString(@"UV",nil);
    
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
    table.delegate   = self;
    table.dataSource = self;
    table.backgroundView=nil;
    table.bounces=NO;
    
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:table];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"BLE_ENV"] != nil)
    {
        gettimer = [NSTimer scheduledTimerWithTimeInterval: getDataTimeInterval
                                                target: self
                                              selector: @selector(handleTimer:)
                                              userInfo: nil
                                               repeats: YES];
    }
    
    //[[BLEWeather bleweather] getbleweather:^(NSDictionary *weatherDict) {
        NSDictionary *dict=[[BLEWeather bleweather] getbleweather];
        NSLog(@"weDic %@", dict);
    
        if([[dict objectForKey:@"temp"] length]>0)
        {
            temp.detail=[NSString stringWithFormat:@"%@℃",[dict objectForKey:@"temp"]];
            if ([[dict objectForKey:@"temp"]intValue] == 0) {
                temp.level = 0;
            }
        }
        
        if ([[dict objectForKey:@"humidity"] length]>0) {
            humi.detail=[NSString stringWithFormat:@"%@%%",[dict objectForKey:@"humidity"]];
            if ([[dict objectForKey:@"humidity"]intValue] == 0) {
                humi.level = 0;
            }
        }
        
        if ([[dict objectForKey:@"light"] length]>0) {
            light.detail=[NSString stringWithFormat:@"%@",[dict objectForKey:@"light"]];
            if ([[dict objectForKey:@"light"]doubleValue] == 0) {
                light.level = 0;
            }
        }
        
        if ([[dict objectForKey:@"maxsound"] length]>0) {
            sound.detail=[NSString stringWithFormat:@"%@",[dict objectForKey:@"maxsound"]];
            if ([[dict objectForKey:@"maxsound"]doubleValue] == 0) {
                sound.level = 0;
            }
        }
        
        if ([[dict objectForKey:@"uv"] length]>0) {
            uv.detail=[NSString stringWithFormat:@"%@",[dict objectForKey:@"uv"]];
            if ([[dict objectForKey:@"uv"]intValue] == 0) {
                uv.level = 0;
            }
        }
    
        if ([[dict objectForKey:@"pm"] length]>0) {
            pm.detail=[NSString stringWithFormat:@"%@",[dict objectForKey:@"pm"]];
            if ([[dict objectForKey:@"pm"]intValue] == 0) {
                pm.level = 0;
            }
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
            NSArray *arr = [EnvironmentAdviceDB selectSuggestionByCondition:ENVIR_SUGGESTION_TYPE_TEMP andValue:[NSNumber numberWithInt:[[dict objectForKey:@"temp"] intValue]]];
            if ([arr count]>0) {
                AdviseLevel *al = [arr objectAtIndex:0];
                NSArray *a2 = [EnvironmentAdviceDB selectSuggestionBySid:al.mAdviseId andCondition:SUGGESTION_DB_TYPE_TEMP];
                if ([a2 count]>0) {
                    AdviseData* ad = [a2 objectAtIndex:0];
                    mAdTemp = ad;
                    mAlTemp = al;
                    temp.level = al.mLevel;
                }
            }
            
        }
        
        if ([[dict objectForKey:@"humidity"] length]>0) {
            humi.detail=[NSString stringWithFormat:@"%@ %%",[dict objectForKey:@"humidity"]];
             NSArray *arr = [EnvironmentAdviceDB selectSuggestionByCondition:ENVIR_SUGGESTION_TYPE_HUMI andValue:[NSNumber numberWithInt:[[dict objectForKey:@"humidity"] intValue]]];
            
            if ([arr count]>0) {
                AdviseLevel *al = [arr objectAtIndex:0];
                NSArray *a2 = [EnvironmentAdviceDB selectSuggestionBySid:al.mAdviseId andCondition:SUGGESTION_DB_TYPE_HUMI];
                if ([a2 count]>0) {
                    AdviseData* ad = [a2 objectAtIndex:0];
                    mAdHumi = ad;
                    mAlHumi = al;
                    humi.level = al.mLevel;
                }
            }
        }
        
        if ([[dict objectForKey:@"light"] length]>0) {
            light.detail=[NSString stringWithFormat:@"%@",[dict objectForKey:@"light"]];
            NSArray *arr = [EnvironmentAdviceDB selectSuggestionByCondition:ENVIR_SUGGESTION_TYPE_LIGHT andValue:[NSNumber numberWithInt:[[dict objectForKey:@"light"] intValue]]];
            
            if ([arr count]>0) {
                AdviseLevel *al = [arr objectAtIndex:0];
                NSArray *a2 = [EnvironmentAdviceDB selectSuggestionBySid:al.mAdviseId andCondition:SUGGESTION_DB_TYPE_LIGHT];
                if ([a2 count]>0) {
                    AdviseData* ad = [a2 objectAtIndex:0];
                    mAdLight = ad;
                    mAlLight = al;
                    light.level = al.mLevel;
                }
            }
        }
    
        if ([[dict objectForKey:@"maxsound"] length]>0) {
            sound.detail=[NSString stringWithFormat:@"%@",[dict objectForKey:@"maxsound"]];
            NSArray *arr = [EnvironmentAdviceDB selectSuggestionByCondition:ENVIR_SUGGESTION_TYPE_NOICE andValue:[NSNumber numberWithInt:[[dict objectForKey:@"maxsound"] intValue]]];
            
            if ([arr count]>0) {
                AdviseLevel *al = [arr objectAtIndex:0];
                NSArray *a2 = [EnvironmentAdviceDB selectSuggestionBySid:al.mAdviseId andCondition:SUGGESTION_DB_TYPE_NOICE];
                if ([a2 count]>0) {
                    AdviseData* ad = [a2 objectAtIndex:0];
                    mAdNoice = ad;
                    mAlNoice = al;
                    sound.level = al.mLevel;
                }
            }
        }
    
        if ([[dict objectForKey:@"uv"] length]>0) {
            uv.detail=[NSString stringWithFormat:@"%@",[dict objectForKey:@"uv"]];
            NSArray *arr = [EnvironmentAdviceDB selectSuggestionByCondition:ENVIR_SUGGESTION_TYPE_UV andValue:[NSNumber numberWithInt:[[dict objectForKey:@"uv"] intValue]]];
            
            if ([arr count]>0) {
                AdviseLevel *al = [arr objectAtIndex:0];
                NSArray *a2 = [EnvironmentAdviceDB selectSuggestionBySid:al.mAdviseId andCondition:SUGGESTION_DB_TYPE_UV];
                if ([a2 count]>0) {
                    AdviseData* ad = [a2 objectAtIndex:0];
                    mAdUV    = ad;
                    mAlUV    = al;
                    uv.level = al.mLevel;
                }
            }
        }
    
        if ([[dict objectForKey:@"pm"] length]>0)
        {
            pm.detail=[NSString stringWithFormat:@"%@",[dict    objectForKey:@"pm"]];
            NSArray *arr = [EnvironmentAdviceDB selectSuggestionByCondition:ENVIR_SUGGESTION_TYPE_PM25 andValue:[NSNumber numberWithInt:[[dict objectForKey:@"pm"] intValue]]];
            
            if ([arr count]>0) {
                AdviseLevel *al = [arr objectAtIndex:0];
                NSArray *a2 = [EnvironmentAdviceDB selectSuggestionBySid:al.mAdviseId andCondition:SUGGESTION_DB_TYPE_PM25];
                if ([a2 count]>0) {
                    AdviseData* ad = [a2 objectAtIndex:0];
                    mAdPM25 = ad;
                    mAlPM25 = al;
                    pm.level = al.mLevel;
                }
            }
        }

    
        Environmentitem *itemTemp = [dataarray objectAtIndex:0];
        itemTemp.detail = temp.detail;
        itemTemp.level  = temp.level;
        [dataarray replaceObjectAtIndex:0 withObject:itemTemp];
        
        Environmentitem *itemHumi = [dataarray objectAtIndex:1];
        itemHumi.detail = humi.detail;
        itemHumi.level  = humi.level;
        [dataarray replaceObjectAtIndex:1 withObject:itemHumi];
        
        Environmentitem *itemLight = [dataarray objectAtIndex:2];
        itemLight.detail = light.detail;
        itemLight.level  = light.level;
        [dataarray replaceObjectAtIndex:2 withObject:itemLight];
        
        Environmentitem *itemSound = [dataarray objectAtIndex:3];
        itemSound.detail = sound.detail;
        itemSound.level  = sound.level;
        [dataarray replaceObjectAtIndex:3 withObject:itemSound];
        
        Environmentitem *itemUV = [dataarray objectAtIndex:4];
        itemUV.detail = uv.detail;
        itemUV.level = uv.level;
        [dataarray replaceObjectAtIndex:4 withObject:itemUV];
    
        Environmentitem *itemPM = [dataarray objectAtIndex:5];
        itemPM.detail = pm.detail;
        itemPM.level = pm.level;
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
    static NSString *CellTableIdentifier = @"ID";
    
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:
                             CellTableIdentifier];
    if (Cell==nil) {
        Cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTableIdentifier];
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 554/2.0*PNGSCALE, 83/2.0*PNGSCALE)];
        if (indexPath.section == 0) {
            Cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"temp"]];
        }
        
        if (indexPath.section == 1) {
            Cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"humidity"]];
        }
        
        if (indexPath.section == 2) {
            Cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"light"]];
        }
        
        if (indexPath.section == 3) {
            Cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noice"]];
        }
        
        if (indexPath.section == 4) {
            Cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UV"]];
        }
        
        if (indexPath.section == 5) {
            Cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pm25"]];
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
    
    UIImageView *image=(UIImageView*)[Cell.contentView viewWithTag:104];
    for(UIView * view in image.subviews){
        [view removeFromSuperview];
    }
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 80, 83/2.0*PNGSCALE)];
    title.textColor = [ACFunction colorWithHexString:@"#96999b"];
    title.font      = [UIFont fontWithName:@"Arial" size:13];
    title.text = item.title;
    
    UIImageView *levelImage = [[UIImageView alloc] initWithFrame:CGRectMake(image.frame.size.width-15-46/2.0*PNGSCALE, 9, 46/2.0*PNGSCALE, 41/2.0*PNGSCALE)];

    UILabel *weatherDetail = [[UILabel alloc]initWithFrame:CGRectMake(image.frame.size.width/2.0, 0, 50, image.frame.size.height)];
    weatherDetail.font = [UIFont fontWithName:@"Arial" size:13];
    weatherDetail.textAlignment = NSTextAlignmentCenter;
    weatherDetail.textColor = [ACFunction colorWithHexString:@"#96999b"];
    [image addSubview:title];
    [image addSubview:levelImage];
    [image addSubview:weatherDetail];
    [image setBackgroundColor:[UIColor clearColor]];
    if (item.detail.length>0)
    {
        int Condition = 0;
        if (indexPath.section == 0) {
            Condition = ENVIR_SUGGESTION_TYPE_TEMP;
        }
        else if (indexPath.section == 1)
        {
            Condition =ENVIR_SUGGESTION_TYPE_HUMI;
        }
        else if (indexPath.section == 2)
        {
            Condition =ENVIR_SUGGESTION_TYPE_LIGHT;
        }
        else if (indexPath.section == 3)
        {
            Condition =ENVIR_SUGGESTION_TYPE_NOICE;
        }
        else if (indexPath.section == 4)
        {
            Condition =ENVIR_SUGGESTION_TYPE_UV;
        }
        else if (indexPath.section == 5)
        {
            Condition =ENVIR_SUGGESTION_TYPE_PM25;
        }
        
            
        NSArray *arr = [EnvironmentAdviceDB selectSuggestionByCondition:Condition andValue:[NSNumber numberWithInt:[item.detail intValue]]];
        int level = 0;
        if ([arr count]>0) {
            AdviseLevel *al = [arr objectAtIndex:0];
            level = al.mLevel;
        }

        if (level == 0) {
            weatherDetail.text = @"暂无";
            [levelImage setImage:[UIImage imageNamed:@"icon_grey"]];
        }
        else
        {
            weatherDetail.text=item.detail;
            NSString *condition = @"";
            NSString *strLevel  = @"";
            switch (level)
            {
                case ENV_ADVISE_LEVEL_EXCELLENT:
                    strLevel = @"excellent";
                    break;
                case ENV_ADVISE_LEVEL_GOOD:
                    strLevel = @"good";
                    break;
                case ENV_ADVISE_LEVEL_BAD:
                    strLevel = @"bad";
                    break;
                default:
                    break;
            }
            
            switch (indexPath.section)
            {
                case 0:
                    condition = @"temp_level";
                    break;
                case 1:
                    condition = @"humi_level";
                    break;
                case 2:
                    condition = @"UV_level";
                    break;
                case 3:
                    condition = @"light_level";
                    break;
                case 4:
                    condition = @"noice_level";
                    break;
                case 5:
                    condition = @"pm25_level";
                    break;
                default:
                    break;
            }
            
            [levelImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%@", condition, strLevel]]];
        }
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
            case ENV_ADVISE_LEVEL_EXCELLENT:
                title = @"Excellent";
                break;
            case ENV_ADVISE_LEVEL_GOOD:
                title = @"Good";
                break;
            case ENV_ADVISE_LEVEL_BAD:
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
            case ENV_ADVISE_LEVEL_EXCELLENT:
                title = @"Excellent";
                break;
            case ENV_ADVISE_LEVEL_GOOD:
                title = @"Good";
                break;
            case ENV_ADVISE_LEVEL_BAD:
                title = @"Bad";
                break;
            default:
                break;
        }
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:title contentText:mAdHumi.mContent leftButtonTitle:nil rightButtonTitle:@"OK"];
        [alert show];
    }
}

-(AdviseData*)getTempAdviseData
{
    return mAdTemp;
}
-(AdviseData*)getHumiAdviseData
{
    return mAdHumi;
}
-(AdviseData*)getLightAdviseData
{
    return mAdLight;
}
-(AdviseData*)getNoiceAdviseData
{
    return mAdNoice;
}
-(AdviseData*)getUVAdviseData
{
    return  mAdUV;
}
-(AdviseData*)getPM25AdviseData
{
    return  mAdPM25;
}

@end
