//
//  PhotoAreaView.h
//  时间轴_TimeLine
//
//  Created by CHEN WEIBIN on 14-8-22.
//  Copyright (c) 2014年 CHEN WEIBIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoAreaView : UIView<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>{
    UIImagePickerController *imagePicker;
    UIActionSheet *action;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeadPic;
@property (weak, nonatomic) IBOutlet UILabel *labelBabyName;
@property (weak, nonatomic) IBOutlet UILabel *labelDays;

-(void)initData; 
- (IBAction)goTips:(id)sender;

@end
