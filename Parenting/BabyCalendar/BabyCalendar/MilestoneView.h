//
//  MilestoneView.h
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "BaseView.h"
#import "MilestoneHeaderView.h"
#import "MilestoneContentView.h"
@class MilestoneContentView;
@protocol MilestoneViewDelegate <NSObject>
- (void)ShareToFriend;
@end
@interface MilestoneView : BaseView<MilestoneHeaderViewDelegate,MilestoneContentViewDelegate,UIAlertViewDelegate>
{
    
    
    
}

@property(nonatomic,retain)MilestoneHeaderView* headerView;
@property(nonatomic,retain)MilestoneContentView* contentView;
@property(nonatomic,retain)NSMutableArray* SQLDatas;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)id<MilestoneViewDelegate> delegate;
@end
