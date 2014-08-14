//
//  VaccineListView.h
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "BaseView.h"

@interface VaccineListView : BaseView<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *_tableView;
    
    NSInteger _row;
    
}
@property(nonatomic,retain)NSMutableArray* SQLDatas;
@end
