//
//  MilestoneHeaderView.h
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitImageView.h"
#import "CustomIOS7AlertView.h"
@class MilestoneHeaderView;
@protocol MilestoneHeaderViewDelegate <NSObject>

- (void)MilestoneHeaderView_left;
- (void)MilestoneHeaderView_right;
- (void)PortraitImageView_changeImage:(MilestoneHeaderView*)headerView;
- (void)ShareToFriendByImage;
@end

@interface MilestoneHeaderView : UIView<PortraitImageViewDelegate,CustomIOS7AlertViewDelegate>
{
    CustomIOS7AlertView* _alertView;
    UIDatePicker* _datePicker;
}

@property(nonatomic,assign)id<MilestoneHeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet PortraitImageView *photoView;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;
@property (weak, nonatomic) IBOutlet UILabel *labWeekday;

- (IBAction)shareToFriends:(UIButton *)sender;

- (IBAction)leftAction:(id)sender;
- (IBAction)rightAction:(id)sender;
- (IBAction)selectDateAction:(id)sender;
@end
