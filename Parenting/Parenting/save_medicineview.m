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
