//
//  TrainList.h
//  BabyCalendar
//
//  Created by will on 14-5-28.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "BaseView.h"

@interface TrainList : BaseView<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *_tableView;
    
}
@property(nonatomic,retain)NSMutableArray* datas;

@end
