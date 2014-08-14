//
//  PhotoView.h
//  BabyCalendar
//
//  Created by will on 14-5-27.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitImageView.h"

@class NoteModel;
@interface PhotoView : UIView<PortraitImageViewDelegate,UIAlertViewDelegate>
{
    UIImageView* _scaleView;
    UIButton* _btnDelete;
}

@property(nonatomic,retain)NoteModel* model;

@property (weak, nonatomic) IBOutlet UIImageView *photoView1;
@property (weak, nonatomic) IBOutlet UIImageView *photoView2;
@property (weak, nonatomic) IBOutlet UIImageView *photoView3;

@property (nonatomic,retain)PortraitImageView* portraitImageView;

@end
