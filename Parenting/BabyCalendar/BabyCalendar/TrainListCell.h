//
//  TrainListCell.h
//  BabyCalendar
//
//  Created by will on 14-5-28.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TrainListModel;
@interface TrainListCell : UITableViewCell
{
    IBOutlet UIImageView *_iconView;
    IBOutlet UILabel *_labTitle;
    
}
@property(nonatomic,retain)TrainListModel* model;
@end
