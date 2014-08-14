//
//  AddMilestoneView.h
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "BaseView.h"

@interface AddMilestoneView : BaseView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_completedTable;
    UITableView* _uncompletedTable;
    
    UIButton* _btnSeeCompleted;
    UIButton* _btnSeeUncompleted;
    
    __weak IBOutlet UIScrollView *_scrollView;
    
}
@property(nonatomic,retain)NSMutableArray* completedDatas;
@property(nonatomic,retain)NSMutableArray* uncompletedDatas;


@end
