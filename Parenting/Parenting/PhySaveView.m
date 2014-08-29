//
//  PhySaveView.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-14.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "PhySaveView.h"

@implementation PhySaveView

- (id)initWithFrame:(CGRect)frame Type:(int)type OpType:(NSString *)operateType CreateTime:(long)create_time
{
    self = [super initWithFrame:frame];
    if (self) {
        itemType = type;
        switch (itemType) {
            case 0:
                itemName = @"身高";
                itemUnit = @"CM";
                break;
            case 1:
                itemName = @"体重";
                itemUnit = @"KG";
                break;
            case 3:
                itemName = @"头围";
                itemUnit = @"CM";
                break;
            default:
                break;
        }

        opType = operateType;
        [self initView];
        if ([opType isEqual:@"UPDATE"]) {
            createTime = create_time;
            [self initData];
        }
    }
    return self;
}

-(void)initView{
    //标题
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 5,290, 30)];
    title.text = [NSString stringWithFormat:@"%@详情",itemName];
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
    labelValue.text = [NSString stringWithFormat:@"记录%@:",itemName];
    
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
    NSDictionary *dict = [[BabyDataDB babyinfoDB] selectBabyPhysiologyDetail:itemType CreateTime:createTime];
    measureTime = [ACDate getDateFromTimeStamp:[[dict objectForKey:@"measure_time"] longValue]];
    textRecordDate.text=[ACDate dateDetailFomatdate3:measureTime];
    textValue.text = [NSString stringWithFormat:@"%0.1f",[[dict objectForKey:@"value"] doubleValue]];
}

-(void)saveRecord{
    if ([textRecordDate.text  isEqual: @""] || [textValue.text  isEqual: @""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"提交异常,请填写记录时间及数值哦!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ([opType isEqualToString:@"SAVE"]) {
        if ([[BabyDataDB babyinfoDB] insertBabyPhysiology:[ACDate getTimeStampFromDate:[ACDate date]] UpdateTime:[ACDate getTimeStampFromDate:[ACDate date]] MeasureTime:[ACDate getTimeStampFromDate:[datepicker date]] Type:itemType Value:[textValue.text doubleValue]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"添加成功!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self.PhySaveDelegate sendPhyReloadData];
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
            [self.PhySaveDelegate sendPhyReloadData];
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

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == textRecordDate){
        [self actionsheetShow];
        [textField resignFirstResponder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == textValue && ![self isPureFloat:textValue.text]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@数值异常,必须为数字!",itemName]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        textValue.text = @"";
        return NO;
    }
    else if (textField == textValue && ![self isLegal:textValue.text]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@数值异常,%@必须在正常范围内!",itemName,itemName]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
    switch (itemType) {
        case 0:
            if (value < 30 || value > 110) {
                return NO;
            }
            break;
        case 1:
            if (value < 2 || value > 16) {
                return NO;
            }
            break;
        case 3:
            if (value < 25 || value > 60) {
                return NO;
            }
            break;
        default:
            break;
    }
    return YES;
}

-(void)actionsheetShow
{
    action=[[UIActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    if (datepicker==nil) {
        datepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, textRecordDate.frame.origin.y+45+G_YADDONVERSION, 320, 162)];
        datepicker.datePickerMode=UIDatePickerModeDate;
        [datepicker addTarget:self action:@selector(updateRecordDate:) forControlEvents:UIControlEventValueChanged];
    }
    
    datepicker.frame=CGRectMake(0, 0, 320, 162);
    action.bounds=CGRectMake(0, 0, 320, 200);
    [action addSubview:datepicker];
    [action showInView:self.superview];
}

-(void)updateRecordDate:(UIDatePicker*)sender{
    measureTime = sender.date;
    textRecordDate.text= [ACDate dateDetailFomatdate3:measureTime];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == action) {
        [self updateRecordDate:datepicker];
    }
}


@end
