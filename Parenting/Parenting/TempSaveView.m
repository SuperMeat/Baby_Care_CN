//
//  TempSaveView.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-11.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "TempSaveView.h"

@implementation TempSaveView

- (id)initWithFrame:(CGRect)frame Type:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self) {
        strType = type;
        [self initView];
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
    labelRecordDate.text = @"日 期:";
    
    textRecordDate=[[UITextField alloc]initWithFrame:CGRectMake(115, 40, 150, 30)];
    textRecordDate.textColor=[UIColor grayColor];
    textRecordDate.delegate = self;
    [textRecordDate setBackground:[UIImage imageNamed:@"save_text.png"]];
    
    //记录时间
    UILabel *labelRecordTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 100, 30)];
    labelRecordTime.textAlignment = NSTextAlignmentRight;
    labelRecordTime.backgroundColor = [UIColor clearColor];
    labelRecordTime.textColor=[UIColor grayColor];
    labelRecordTime.text=@"时 间:";
    
    textRecordTime=[[UITextField alloc]initWithFrame:CGRectMake(115, 80, 150, 30)];
    textRecordTime.textColor=[UIColor grayColor];
    textRecordTime.delegate = self;
    [textRecordTime setBackground:[UIImage imageNamed:@"save_text.png"]];
    
    //数值
    UILabel *labelValue = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, 100, 30)];
    labelValue.textAlignment = NSTextAlignmentRight;
    labelValue.backgroundColor = [UIColor clearColor];
    labelValue.textColor=[UIColor grayColor];
    labelValue.text=@"记录体温:";
    
    textValue=[[UITextField alloc]initWithFrame:CGRectMake(115, 120, 150, 30)];
    textValue.textColor=[UIColor grayColor];
    textValue.delegate = self;
    textValue.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [textValue setBackground:[UIImage imageNamed:@"save_text.png"]];
    
    //saveButton
    buttonSave = [[UIButton alloc]initWithFrame:CGRectMake(42, 163, 94, 28)];
    [buttonSave setTitle:@"保存" forState:UIControlStateNormal];
    [buttonSave setBackgroundImage:[UIImage imageNamed:@"btn_setting.png"] forState:UIControlStateNormal];
    [buttonSave addTarget:self action:@selector(saveRecord) forControlEvents:UIControlEventTouchUpInside];
    //cancelButton
    buttonCancel = [[UIButton alloc]initWithFrame:CGRectMake(152, 163, 94, 28)];
    [buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
    [buttonCancel setBackgroundImage:[UIImage imageNamed:@"btn_setting.png"] forState:UIControlStateNormal];
    [buttonCancel addTarget:self action:@selector(cancelSave) forControlEvents:UIControlEventTouchUpInside];
    
    //设置imageView
    imageview=[[UIImageView alloc]init];
    imageview.bounds=CGRectMake(0, 0, 290, 200);
    imageview.center=CGPointMake(160, (460-44-49)/2 - 40);
    imageview.backgroundColor=[UIColor clearColor];
    imageview.userInteractionEnabled=YES;
    imageview.image=[UIImage imageNamed:@"save_bg.png"];
    [self addSubview:imageview];
    
    [imageview addSubview:title];
    [imageview addSubview:labelRecordDate];
    [imageview addSubview:labelRecordTime];
    [imageview addSubview:labelValue];
    [imageview addSubview:textRecordDate];
    [imageview addSubview:textRecordTime];
    [imageview addSubview:textValue];
    [imageview addSubview:buttonSave];
    [imageview addSubview:buttonCancel];
}

-(void)saveRecord{
    [self removeFromSuperview];
}

-(void)cancelSave{
    [self removeFromSuperview];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == textRecordDate){
        [self actionsheetShow];
        [textField resignFirstResponder];
    }
    else if (textField == textRecordTime){
        [self actionsheetTimeShow];
        [textField resignFirstResponder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (textField == textValue) {
//        return [self validateNumber:string];
//    }
//}

-(void)actionsheetShow
{
    action=[[UIActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    if (datepicker==nil) {
        datepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, textRecordTime.frame.origin.y+45+G_YADDONVERSION, 320, 162)];
        datepicker.datePickerMode=UIDatePickerModeDate;
        [datepicker addTarget:self action:@selector(updateRecordDate:) forControlEvents:UIControlEventValueChanged];
    }
    
    datepicker.frame=CGRectMake(0, 0, 320, 162);
    action.bounds=CGRectMake(0, 0, 320, 200);
    [action addSubview:datepicker];
    [action showInView:self.superview];
}

-(void)actionsheetTimeShow
{
    action2=[[UIActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    if (timepicker==nil) {
        timepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, textRecordTime.frame.origin.y+45, 320, 100)];
        timepicker.datePickerMode=UIDatePickerModeTime;
        [timepicker addTarget:self action:@selector(updateRecordTime:) forControlEvents:UIControlEventValueChanged];
    }
    
    timepicker.frame=CGRectMake(0, 0, 320, 100);
    
    action2.bounds=CGRectMake(0, 0, 320, 200);
    [action2 addSubview:timepicker];
    [action2 showInView:self.window];
}


-(void)updateRecordDate:(UIDatePicker*)sender{ 
    textRecordDate.text=[ACDate dateFomatdate:sender.date];
}

-(void)updateRecordTime:(UIDatePicker*)sender{
    textRecordTime.text = [ACDate getStarttimefromdate:sender.date];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == action) {
        [self updateRecordDate:datepicker];
    }
    else if (actionSheet == action2){
        [self updateRecordTime:timepicker];
    }
}

@end
