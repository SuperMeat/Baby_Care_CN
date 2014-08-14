//
//  UnTrainCell.h
//  BabyCalendar
//
//  Created by will on 14-5-28.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RTLabel;
@class TrainModel;
@interface UnTrainCell : UITableViewCell
{
    RTLabel* _rtLabel;
    __weak IBOutlet UILabel *_labTitle;
    __weak IBOutlet UIImageView *_selectedView;
    __weak IBOutlet UIImageView *_bg_title;
    
    __weak IBOutlet UIImageView *_bgView;
}
@property(nonatomic,retain)TrainModel* model;
@end
