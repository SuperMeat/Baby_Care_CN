//
//  NoteController.h
//  BabyCalendar
//
//  Created by will on 14-5-26.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "BaseViewController.h"

@interface NoteController : BaseViewController<UIScrollViewDelegate,UIAlertViewDelegate>
{
    UIScrollView* _scrollView;
    NSInteger _index;
    
    bool isNew;
}
@property(nonatomic,retain)NSMutableArray* datas;
@end
