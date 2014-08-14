//
//  TestHeaderView.h
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestHeaderView : UIView
{
    
    __weak IBOutlet UIImageView *_imgView;
}
@property(nonatomic,retain)NSMutableArray* datas;
@property(nonatomic,assign)NSInteger index;
@end
