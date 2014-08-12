//
//  LocalNotifyCell.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-17.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import "LocalNotifyCell.h"

@implementation LocalNotifyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(9, 0, 302, 44);
    self.selectedBackgroundView.frame = CGRectMake(9, 0, 302, 44);
    _notifyswitch.onTintColor = [UIColor colorWithRed:1/255.0 green:161/255.0 blue:190/255.0 alpha:1.000];

}

- (NSString*)changeStr:(NSString*)str
{
    NSString *changeStr = @"";
    if ([str isEqual:@"日"]) {
        changeStr = @"0";
    }
    
    if ([str isEqual:@"一"]) {
        changeStr = @"1";
    }
    
    if ([str isEqual:@"二"]) {
        changeStr = @"2";
    }
    
    if ([str isEqual:@"三"]) {
        changeStr = @"3";
    }
    
    if ([str isEqual:@"四"]) {
        changeStr = @"4";
    }
    
    if ([str isEqual:@"五"]) {
        changeStr = @"5";
    }
    
    if ([str isEqual:@"六"]) {
        changeStr = @"6";
    }
    
    return changeStr;
}

- (IBAction)changeValue:(UISwitch *)sender
{
    if (sender.isOn)
    {
        NSString *str = [self.ln.redundant substringToIndex:([self.ln.redundant length]-1)];
        NSArray *array  = [str componentsSeparatedByString:@","];
        //再重新更新
        for (NSString *str in array) {
            NSString *key = [NSString stringWithFormat:@"%@%@", self.ln.createtime, [self changeStr:str] ];
            [ACFunction addLocalNotification:self.ln.title RepeatDay:str FireDate:self.ln.time AlarmKey:key];
        }

        [DataBase updateNotifyTimeStatus:self.ln.createtime andStatus:1];
        NSLog(@"on");
    }
    else
    {
        NSArray* delarray = [[NSArray alloc]initWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
        for (NSString *str in delarray) {
            NSString *key = [NSString stringWithFormat:@"%@%@", self.ln.createtime, [self changeStr:str]];
            [ACFunction deleteLocalNotification:key];
        }
        [DataBase updateNotifyTimeStatus:self.ln.createtime andStatus:0];
        NSLog(@"off");
    }

}
@end
