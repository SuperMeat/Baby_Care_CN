//
//  BabyBaseInfoView.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-4-14.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "BabyBaseInfoView.h"
#import "BabyDataDb.h"
#import "HomeTopView.h"

@implementation BabyBaseInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
        [self initData];
    }
    return self;
}

-(void)initData{
    NSDictionary *dict = [[BabyDataDB babyinfoDB]selectBabyInfoByBabyId:BABYID];
    if (dict) {
        //姓名
        if (![[dict objectForKey:@"nickname"] isEqual: @""]) {
            textNickname.text = [dict objectForKey:@"nickname"];
        }
        //生日
        if (![[dict objectForKey:@"birth"] intValue] == 0) {
            //时间戳转date
            NSDate *birthDate = [ACDate getDateFromTimeStamp:[[dict objectForKey:@"birth"] longValue]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat: @"yyyy-MM-dd"];
            textBirth.text = [dateFormatter stringFromDate:birthDate];
        }
        if ([[dict objectForKey:@"sex"]intValue] == 0) {
            buttonFemale.enabled = NO;
            buttonMale.enabled = YES;
        }
        else if ([[dict objectForKey:@"sex"]intValue] == 1) {
            buttonFemale.enabled = YES;
            buttonMale.enabled = NO;
        }
    }
}

-(void)initView{
    //标题
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 5,290, 30)];
    title.text=@"宝贝信息";
    title.textAlignment=NSTextAlignmentCenter;
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[UIColor grayColor];
    
    //宝贝姓名
    UILabel *nickname = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 100, 30)];
    nickname.textAlignment=NSTextAlignmentRight;
    nickname.backgroundColor      = [UIColor clearColor];
    nickname.textColor=[UIColor grayColor];
    nickname.text=@"宝宝昵称:";
    
    textNickname=[[UITextField alloc]initWithFrame:CGRectMake(115, 40, 150, 30)];
    textNickname.textColor=[UIColor grayColor];
    textNickname.delegate = self;
    [textNickname setBackground:[UIImage imageNamed:@"save_text.png"]];
    
    //生日
    UILabel *birth = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 100, 30)];
    birth.textAlignment=NSTextAlignmentRight;
    birth.backgroundColor      = [UIColor clearColor];
    birth.textColor=[UIColor grayColor];
    birth.text=@"出生日期:";
    
    textBirth=[[UITextField alloc]initWithFrame:CGRectMake(115, 80, 150, 30)];
    textBirth.textColor=[UIColor grayColor];
    textBirth.delegate = self;
    [textBirth setBackground:[UIImage imageNamed:@"save_text.png"]];
    
    //性别
    UILabel *sex = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, 100, 30)];
    sex.textAlignment=NSTextAlignmentRight;
    sex.backgroundColor      = [UIColor clearColor];
    sex.textColor=[UIColor grayColor];
    sex.text=@"宝宝性别:";
    
    buttonMale = [[UIButton alloc] initWithFrame:CGRectMake(115, 115, 60, 40)];
    buttonFemale = [[UIButton alloc] initWithFrame:CGRectMake(175, 115, 60, 40)];
    buttonMale.tag=11001;
    buttonFemale.tag=11002;
    [buttonMale setTitleColor:[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0] forState:UIControlStateNormal];
    [buttonFemale setTitleColor:[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0] forState:UIControlStateNormal];
    [buttonMale setTitle:@"男" forState:UIControlStateNormal];
    [buttonFemale setTitle:@"女" forState:UIControlStateNormal];
    buttonMale.contentMode=UIViewContentModeScaleAspectFit;
    buttonFemale.contentMode=UIViewContentModeScaleAspectFit;
    [buttonMale setImage:[UIImage imageNamed:@"radio.png"] forState:UIControlStateNormal];
    [buttonFemale setImage:[UIImage imageNamed:@"radio.png"] forState:UIControlStateNormal];
    [buttonFemale setImage:[UIImage imageNamed:@"radio_focus.png"] forState:UIControlStateDisabled];
    [buttonMale setImage:[UIImage imageNamed:@"radio_focus.png"] forState:UIControlStateDisabled];
    [buttonMale addTarget:self action:@selector(Radiobuttonselect:) forControlEvents:UIControlEventTouchUpInside];
    [buttonFemale addTarget:self action:@selector(Radiobuttonselect:) forControlEvents:UIControlEventTouchUpInside];
    
    //SaveButton
    buttonSave = [[UIButton alloc]initWithFrame:CGRectMake(42, 163, 94, 28)];
    [buttonSave setTitle:@"保存" forState:UIControlStateNormal];
    [buttonSave setBackgroundImage:[UIImage imageNamed:@"btn_setting.png"] forState:UIControlStateNormal];
    [buttonSave addTarget:self action:@selector(SaveBabyBaseInfo) forControlEvents:UIControlEventTouchUpInside];
    //cancelButton
    buttonCancel = [[UIButton alloc]initWithFrame:CGRectMake(152, 163, 94, 28)];
    [buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
    [buttonCancel setBackgroundImage:[UIImage imageNamed:@"btn_setting.png"] forState:UIControlStateNormal];
    [buttonCancel addTarget:self action:@selector(cancelSave) forControlEvents:UIControlEventTouchUpInside];
    
    //设置imageView
    imageview=[[UIImageView alloc]init];
    imageview.bounds=CGRectMake(0, 0, 290, 200);
    imageview.center=CGPointMake(160, (460-44-49)/2);
    imageview.backgroundColor=[UIColor clearColor];
    imageview.userInteractionEnabled=YES;
    imageview.image=[UIImage imageNamed:@"save_bg.png"];
    [self addSubview:imageview];
    
    [imageview addSubview:title];
    [imageview addSubview:nickname];
    [imageview addSubview:birth];
    [imageview addSubview:sex];
    
    [imageview addSubview:textNickname];
    [imageview addSubview:textBirth];
    [imageview addSubview:buttonMale];
    [imageview addSubview:buttonFemale];
    [imageview addSubview:buttonSave];
    [imageview addSubview:buttonCancel];
    
}

-(void)cancelSave{
    [self removeFromSuperview];
}

#pragma 存储宝贝基本信息
-(void)SaveBabyBaseInfo{
    if (![textBirth.text  isEqual: @""]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *birth = [formatter dateFromString:textBirth.text];
        [[BabyDataDB babyinfoDB] updateBabyBirth:[ACDate getTimeStampFromDate:birth] BabyId:BABYID];
    }
    if (![textNickname.text isEqual:@""]) {
        [[BabyDataDB babyinfoDB] updateBabyInfoName:textNickname.text BabyId:BABYID];
    }
    if (buttonMale.enabled == NO) {
        [[BabyDataDB babyinfoDB] updateBabySex:1 BabyId:BABYID];
    }
    else if (buttonFemale.enabled == NO) {
        [[BabyDataDB babyinfoDB] updateBabySex:0 BabyId:BABYID];
    }
    
    for(UIView *view in self.superview.subviews){
        if ([view isKindOfClass:[HomeTopView class]]) {
            HomeTopView *homeTopView = (HomeTopView*)view;
            [homeTopView initData];
        }
    }
    
    //TODO:信息完善后删除提醒
    [self removeFromSuperview];
}

#pragma 性别选择
- (void)Radiobuttonselect:(id)sender {
    UIButton *button=(UIButton*)sender;
    button.enabled=NO;
    button.titleLabel.textColor=[UIColor whiteColor];
    UIButton *another;
    
    if (button.tag==11001) {
        another=(UIButton*)[self viewWithTag:11002];
        
    }
    else
    {
        another=(UIButton*)[self viewWithTag:11001];
    }
    another.enabled=YES;
    another.titleLabel.textColor=[UIColor grayColor];
}

-(void)actionsheetShow
{
    action=[[UIActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    if (datepicker==nil) {
        datepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, textBirth.frame.origin.y+45+G_YADDONVERSION, 320, 100)];
        datepicker.datePickerMode=UIDatePickerModeDate;
        [datepicker addTarget:self action:@selector(updatebirsthday:) forControlEvents:UIControlEventValueChanged];
    }
    
    datepicker.frame=CGRectMake(0, 0, 320, 100);
    action.bounds=CGRectMake(0, 0, 320, 200);
    [action addSubview:datepicker];
    [action showInView:self.superview];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == action) {
        [self updatebirsthday:datepicker];
    }
}

-(void)updatebirsthday:(UIDatePicker*)sender{
    NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    textBirth.text=[dateFormater stringFromDate:sender.date];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == textBirth)
    {
        [self actionsheetShow];
        [textBirth resignFirstResponder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	switch (component) {
		case 0:
			return 0;
        default:
			return 1;
	}
}

@end
