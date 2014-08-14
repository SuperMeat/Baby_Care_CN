//
//  VaccineDetailView.h
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "BaseView.h"

@class VaccineDetailHeaderView;
@class VaccineDetailContentView;
@class VaccineModel;
@interface VaccineDetailView : BaseView
{
    
    VaccineDetailContentView* _contentView;
}
@property(nonatomic,retain)VaccineModel* model;
@property(nonatomic,retain)VaccineDetailHeaderView* headerView;
@end
