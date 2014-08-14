//
//  AddMilestoneCell.h
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MilestoneModel;
@interface AddMilestoneCell : UITableViewCell
{
    __weak IBOutlet UIImageView *_iconImgView;
    __weak IBOutlet UILabel *_labTitle;
    __weak IBOutlet UILabel *_labMonth;
    __weak IBOutlet UILabel *_labCompleted;
    __weak IBOutlet UILabel *_labDate;
    
    
}
@property(nonatomic,retain)MilestoneModel* model;
@property(nonatomic,assign)NSInteger row;
@end
