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
    
    UIImageView *_imageViewHeadPic;
    UIImageView *_imageViewBG;
    UIImageView *_imageViewDayBG;
    UILabel *_labelBabyName;
    UILabel *_labelDays;
    UIButton *_btnTips;
}


-(void)initData;  

@end
