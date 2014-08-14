//
//  CreatMilestoneAddphotoView.h
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PortraitImageView;
@class MilestoneModel;
@interface CreatMilestoneAddphotoView : UIView

@property(nonatomic,retain)MilestoneModel* model;
@property (weak, nonatomic) IBOutlet PortraitImageView *addPhotoView;

@end
