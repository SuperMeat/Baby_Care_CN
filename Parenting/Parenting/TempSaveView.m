//
//  TempSaveView.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-11.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "TempSaveView.h"
#import "BabyDataDB.h"
@implementation TempSaveView

- (id)initWithFrame:(CGRect)frame Type:(NSString *)type CreateTime:(long)create_time
{
    self = [super initWithFrame:frame];
    if (self) {
        itemType = 4;
        opType = type;
        [self initView];
        if ([type isEqual:@"UPDATE"]) {
            createTime = create_time;
            [self initData];
        }
    }
    return self;
}

-(void)initView{
    //标题
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 5,290, 30)];
    title.text=@"体温详情";
    title.textAlignment=NSTextAlignmentCenter;
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[UIColor grayColor];
    
    //记录日期
    UILabel *labelRecordDate = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 100, 30)];
    labelRecordDate.textAlignment = NSTextAlignmentRight;
    labelRecordDate.backgroundColor = [UIColor clearColor];
    labelRecordDate.textColor= [UIColor grayColor];
    labelRecordDate.text = @"记录时间:";
    
    textRecordDate=[[UITextField alloc]initWithFrame:CGRectMake(115, 40, 150, 30)];
    textRecordDate.textColor=[UIColor grayColor];
    textRecordDate.delegate = self;
    [textRecordDate setBackground:[UIImage imageNamed:@"save_text.png"]];
    
    //数值
    UILabel *labelValue = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 100, 30)];
    labelValue.textAlignment = NSTextAlignmentRight;
    labelValue.backgroundColor = [UIColor clearColor];
    labelValue.textColor=[UIColor grayColor];
    labelValue.text=@"记录体温:";
    
    textValue=[[UITextField alloc]initWithFrame:CGRectMake(115, 80, 150, 30)];
    textValue.textColor=[UIColor grayColor];
    textValue.delegate = self;
    textValue.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [textValue setBackground:[UIImage imageNamed:@"save_text.png"]];
    
    //saveButton
    buttonSave = [[UIButton alloc]initWithFrame:CGRectMake(42, 123, 94, 28)];
    [buttonSave setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    buttonSave.layer.cornerRadius = 5.0f;
    [buttonSave setTitle:NSLocalizedString(@"Save",nil) forState:UIControlStateNormal];
    [buttonSave addTarget:self action:@selector(saveRecord) forControlEvents:UIControlEventTouchUpInside];
    //cancelButton
    buttonCancel = [[UIButton alloc]initWithFrame:CGRectMake(152, 123, 94, 28)];
    [buttonCancel setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    buttonCancel.layer.cornerRadius = 5.0f;
    [buttonCancel setTitle:NSLocalizedString(@"Cancle",nil) forState:UIControlStateNormal];
    [buttonCancel addTarget:self action:@selector(cancelSave) forControlEvents:UIControlEventTouchUpInside];
    
    //设置imageView
    imageview=[[UIImageView alloc]init];
    imageview.bounds=CGRectMake(0, 0, 290, 160);
    imageview.center=CGPointMake(160, (460-44-49)/2 - 20);
    imageview.backgroundColor=[UIColor clearColor];
    imageview.userInteractionEnabled=YES;
    imageview.image=[UIImage imageNamed:@"save_bg.png"];
    [self addSubview:imageview];
    
    [imageview addSubview:title];
    [imageview addSubview:labelRecordDate];
    [imageview addSubview:labelValue];
    [imageview addSubview:textRecordDate];
    [imageview addSubview:textValue];
    [imageview addSubview:buttonSave];
    [imageview addSubview:buttonCancel];
}

-(void)initData{
    NSDictionary *dict = [[BabyDataDB babyinfoDB] selectBabyPhysiologyDetail:4 CreateTime:createTime];
    measureTime = [ACDate getDateFromTimeStamp:[[dict objectForKey:@"measure_time"] longValue]];
    textRecordDate.text=[ACDate dateDetailFomatdate:measureTime];
    textValue.text = [NSString stringWithFormat:@"%0.1f",[[dict objectForKey:@"value"] doubleValue]];
}

-(void)saveRecord{
    if ([opType isEqualToString:@"SAVE"]) {
        if ([[BabyDataDB babyinfoDB] insertBabyPhysiology:[ACDate getTimeStampFromDate:[ACDate date]] UpdateTime:[ACDate getTimeStampFromDate:[ACDate date]] MeasureTime:[ACDate getTimeStampFromDate:[datepicker date]] Type:itemType Value:[textValue.text doubleValue]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"添加成功!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self.TempSaveDelegate sendTempReloadData];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"添加失败!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else if ([opType isEqualToString:@"UPDATE"]){
        if ([[BabyDataDB babyinfoDB] updateBabyPhysiology:[textValue.text doubleValue] CreateTime:createTime UpdateTime:[ACDate getTimeStampFromDate:[ACDate date]] MeasureTime:[ACDate getTimeStampFromDate:measureTime]  Type:itemType]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"修改成功!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self.TempSaveDelegate sendTempReloadData];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"添加失败!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    textValue.text = @"";
    textRecordDate.text = @"";
    [self removeFromSuperview];
}

-(void)cancelSave{
    textValue.text = @"";
    textRecordDate.text = @"";
    [self removeFromSuperview];
}
  
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == textRecordDate){
        [self actionsheetShow];
        [textRecordDate resignFirstResponder];
        [textValue resignFirstResponder];
        return NO;
    }
    else{
        return YES;
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (id view in imageview.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == textValue && ![self isPureFloat:textValue.text]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"体温数值异常,必须为数字!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        textValue.text = @"";
        return NO;
    }
    else if (textField == textValue && ![self isLegal:textValue.text]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"体温数值异常,体温必须在正常范围内!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        textValue.text = @"";
        return NO;
    }
    else{
        [textField resignFirstResponder];
        return YES;
    }
}

#pragma 判断是否为浮点数
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

#pragma 判断是否为正确范围
-(BOOL)isLegal:(NSString*)string{
    double value = [string doubleValue];
    if (value < 30 || value > 45) {
        return NO;
    }
    return YES;
}

-(void)updateRecordDate:(UIDatePicker*)sender{
    measureTime = sender.date;
    textRecordDate.text=[ACDate dateDetailFomatdate:sender.date];
}

-(void)actionsheetShow
{
    if (action == nil) {
        action = [[CustomIOS7AlertView alloc] init];
        [action setContainerView:[self createDateView]];
        [action setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
        [action setDelegate:self];
    }
    datepicker.date = [NSDate date];
    [action show];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self updateRecordDate:datepicker];
    }
    
    [alertView close];
    
}

- (UIDatePicker*)createDateView
{
    if (datepicker==nil) {
        datepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, textRecordDate.frame.origin.y+45+G_YADDONVERSION, 320, 162)];
        datepicker.datePickerMode=UIDatePickerModeDateAndTime; 
    }
    
    datepicker.frame=CGRectMake(0, 0, 320, 162);
    
    return datepicker;
}
@end
