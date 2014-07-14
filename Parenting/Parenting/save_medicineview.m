//
//  save_medicineview.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-7-11.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "save_medicineview.h"

@implementation save_medicineview
-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       [self  makeSave];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame Select:(BOOL)select Start:(NSDate*)start UpdateTime:(long)updatetime CreateTime:(long)createtime
{
    self.start  = start;
    self.select = select;
    _createtime = createtime;
    _updatetime = updatetime;
    
    self=[self initWithFrame:frame];
    return self;
}

-(void)makeSave
{
//    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 290, 30)];
//    title.text=NSLocalizedString(@"吃药信息",nil);
//    title.textAlignment=NSTextAlignmentCenter;
//    title.backgroundColor=[UIColor clearColor];
//    title.textColor=[UIColor grayColor];
//    imageview=[[UIImageView alloc]init];
//    imageview.bounds=CGRectMake(0, 0, 290, 280+30+40);
//    imageview.center=CGPointMake(160, (480-64)/2+30+40);
//    [self addSubview:imageview];
//    [imageview addSubview:title];
//    
//    imageview.backgroundColor=[ACFunction colorWithHexString:@"#f4f4f4"];
//    //imageview.backgroundColor = [UIColor redColor];
//    imageview.layer.cornerRadius = 8.0f;
//    imageview.userInteractionEnabled=YES;
//    [imageview.image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
//    
//    UILabel *date = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 100, 30)];
//    
//    UILabel *starttime = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 100, 30)];
//    
//    UILabel *duration = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, 100, 30)];
//    
//    
//    
//    remark = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
//    
//   
//    date.backgroundColor      = [UIColor clearColor];
//    starttime.backgroundColor = [UIColor clearColor];
//    duration.backgroundColor  = [UIColor clearColor];
//    remark.backgroundColor    = [UIColor clearColor];
//    
//    date.textColor=[UIColor grayColor];
//    starttime.textColor=[UIColor grayColor];
//    duration.textColor=[UIColor grayColor];
//    remark.textColor=[UIColor grayColor];
//    
//    date.text=NSLocalizedString(@"Date:",nil);
//    starttime.text=NSLocalizedString(@"Start Time:",nil);
//    duration.text=NSLocalizedString(@"Duration:",nil);
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"metric"]==nil) {
//        [[NSUserDefaults standardUserDefaults]setObject:@"Oz:" forKey:@"metric" ];
//    }
//    
//    remark.text=NSLocalizedString(@"Comments:",nil);
//    date.textAlignment=NSTextAlignmentRight;
//    starttime.textAlignment=NSTextAlignmentRight;
//    duration.textAlignment=NSTextAlignmentRight;
//    remark.textAlignment=NSTextAlignmentRight;
//   
//    
//    [imageview addSubview:date];
//    [imageview addSubview:starttime];
//    [imageview addSubview:duration];
//    [imageview addSubview:remark];
//    
//    
//    starttimetext=[[UITextField alloc]initWithFrame:CGRectMake(115, 80, 150, 30)];
//    
//    starttimetext.textColor=[UIColor grayColor];
//    [starttimetext setBackground:[UIImage imageNamed:@"panels_input"]];
//    [imageview addSubview:starttimetext];
//    
//    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
//    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
//    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
//    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
//    //starttimetext.enabled=NO;
//    starttimetext.delegate  = self;
//    starttimetext.inputView = starttimepicker;
//    
//    
//    remarkbg=[[UIImageView alloc]initWithFrame:CGRectMake(115, 200, 150, 60)];
//    remarkbg.image=[UIImage imageNamed:@"panels_input"];
//    remarkbg.userInteractionEnabled=YES;
//    
//    remarktext=[[UITextView alloc]initWithFrame:CGRectMake(-2, 0, 160, 60)];
//    remarktext.backgroundColor=[UIColor clearColor];
//    remarktext.textColor=[UIColor grayColor];;
//    [remarkbg addSubview:remarktext];
//    [imageview addSubview:remarkbg];
//    remarktext.delegate=self;
//    [remarktext setFont:[UIFont systemFontOfSize:13]];
//    
//    UIButton *savebutton=[UIButton buttonWithType:UIButtonTypeCustom];
//    savebutton.frame=CGRectMake(200, 270+40, 70, 30);
//    [savebutton setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
//    savebutton.layer.cornerRadius = 5.0f;
//    [savebutton setTitle:NSLocalizedString(@"Save",nil) forState:UIControlStateNormal];
//    [savebutton addTarget:self action:@selector(Save) forControlEvents:UIControlEventTouchUpInside];
//    [imageview addSubview:savebutton];
//    
//    UIButton *canclebutton=[UIButton buttonWithType:UIButtonTypeCustom];
//    canclebutton.frame=CGRectMake(20, 270+40, 70, 30);
//    [canclebutton setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
//    canclebutton.layer.cornerRadius = 5.0f;
//    [canclebutton setTitle:NSLocalizedString(@"Cancle",nil) forState:UIControlStateNormal];
//    [canclebutton addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
//    [imageview addSubview:canclebutton];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShown:)
//                                                 name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHidden:)
//                                                 name:UIKeyboardWillHideNotification object:nil];
    [self addSubview:self.save_view];
}

-(void)loaddata
{
    if (self.select)
    {
        
        
    }
    else
    {
        
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    for (id key in imageview.subviews) {
        if ([key isKindOfClass:[UITextField class]]) {
            [key resignFirstResponder];
        }
        
        if ([key isKindOfClass:[UIButton class]]) {
            [key resignFirstResponder];
        }
    }
}

-(void)Save
{
    [self removeFromSuperview];
}

-(void)cancle:(UIButton*)sender
{
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancel" object:sender];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(void)keyboradshow
{
    if (!self.isshow) {
        NSTimeInterval animationDuration = 0.25f;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y-150, 320, 460-44-49);
        [UIView commitAnimations];
        self.isshow=YES;
    }
    
}

-(void)keyboradhidden
{
    if (self.isshow) {
        NSTimeInterval animationDuration = 0.25f;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y+150, 320, 460);
        [UIView commitAnimations];
        self.isshow=NO;
    }
    
}

- (void)keyboardWillShown:(NSNotification*)aNotification{
    [self keyboradshow];
}

-(void)keyboardWillHidden:(NSNotification*)aNotification
{
    [self keyboradhidden];
}

@end
