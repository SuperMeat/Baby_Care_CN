//
//  CustonTimeViewController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-19.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustonTimeViewControllerDelegate<NSObject>
@optional
-(void)sendSelected:(int)tag1 andbtn2tag:(int)tag2 andbtn3tag:(int)tag3 andbtn4tag:(int)tag4 andbtn5tag:(int)tag5 andbtn6tag:(int)tag6 andbtn7tag:(int)tag7;
@end

@interface CustonTimeViewController : UIViewController
{
    int _tag1;
    int _tag2;
    int _tag3;
    int _tag4;
    int _tag5;
    int _tag6;
    int _tag7;
}

@property (strong, nonatomic) IBOutlet UIButton *btn7;
@property (strong, nonatomic) IBOutlet UIButton *btn6;
@property (strong, nonatomic) IBOutlet UIButton *btn5;
@property (strong, nonatomic) IBOutlet UIButton *btn4;
@property (strong, nonatomic) IBOutlet UIButton *btn3;
@property (strong, nonatomic) IBOutlet UIButton *btn2;
@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) NSDate *createtime;

- (IBAction)selectbtn1:(UIButton *)sender;

- (IBAction)selectbtn2:(UIButton *)sender;

- (IBAction)selectbtn3:(UIButton *)sender;

- (IBAction)selectbtn4:(UIButton *)sender;

- (IBAction)selectbtn5:(UIButton *)sender;

- (IBAction)selectbtn6:(UIButton *)sender;

- (IBAction)selectbtn7:(UIButton *)sender;

-(void)setCreatetime:(NSDate *)createtime;
@property (strong, nonatomic) IBOutlet UIImageView *imageview1;
@property (strong, nonatomic) IBOutlet UIImageView *imageview2;
@property (strong, nonatomic) IBOutlet UIImageView *imageview3;
@property (strong, nonatomic) IBOutlet UIImageView *imageview4;
@property (strong, nonatomic) IBOutlet UIImageView *imageview5;
@property (strong, nonatomic) IBOutlet UIImageView *imageview6;
@property (strong, nonatomic) IBOutlet UIImageView *imageview7;

-(void)setSelected:(int)tag1 andbtn2tag:(int)tag2 andbtn3tag:(int)tag3 andbtn4tag:(int)tag4 andbtn5tag:(int)tag5 andbtn6tag:(int)tag6 andbtn7tag:(int)tag7;

@property (assign) id<CustonTimeViewControllerDelegate> custonTimedelegate;
@end
