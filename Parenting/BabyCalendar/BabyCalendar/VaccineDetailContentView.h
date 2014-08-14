//
//  VaccineDetailContentView.h
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "BaseView.h"

@class RTLabel;
@interface VaccineDetailContentView : BaseView
{
    __weak IBOutlet UIScrollView *_scrollView;
    RTLabel* _contentView;
    
}
@end
