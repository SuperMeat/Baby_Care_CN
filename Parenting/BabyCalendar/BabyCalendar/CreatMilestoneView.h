//
//  CreatMilestoneView.h
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "BaseView.h"
#import "CreatMilestoneHeaderView.h"
#import "CreatMilestoneContentView.h"

@class CreatMilestoneAddphotoView;
@class MilestoneModel;
@interface CreatMilestoneView : BaseView<CreatMilestoneHeaderViewDelegate,CreatMilestoneContentViewDelegate>
{
    
    
    float _disMoveH;

}
@property(nonatomic,retain)MilestoneModel* model;
@property(nonatomic,assign)creatMilestoneType type;
@property (nonatomic,retain)CreatMilestoneHeaderView* headerView;
@property (nonatomic,retain)CreatMilestoneContentView* contentView;
@property (nonatomic,retain)CreatMilestoneAddphotoView* addphotoView;
@end
