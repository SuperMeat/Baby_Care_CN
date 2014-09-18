//
//  VaccineListCell.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "VaccineListCell.h"
#import "VaccineModel.h"
@implementation VaccineListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _labDate.font = [UIFont fontWithName:kFont size:9];
    _labVaccine.textColor = UIColorFromRGB(kColor_val_cell_title);
    _labTimes.textColor = UIColorFromRGB(kColor_val_cell_title);
    _labVaccine.font = [UIFont fontWithName:kFont size:12.0f];
    _labCompleted.font = [UIFont fontWithName:kFont size:12.0f];
    _labCompleted.textColor = UIColorFromRGB(kColor_testReport_month);
    _labInplan.font = [UIFont fontWithName:kFont size:12.f];

}

- (void)setModel:(VaccineModel *)model
{
    _model = model;
    
    _labVaccine.text = [NSString stringWithFormat:@"%@",_model.vaccine];
    _labTimes.text = [NSString stringWithFormat:@"(%@)",_model.times];
    
    if ([_model.inplan boolValue]) {
        _labInplan.textColor = UIColorFromRGB(kColor_inplan);
        _labInplan.text = @"第一类";
    }else
    {
        _labInplan.textColor = UIColorFromRGB(kColor_outplan);
        _labInplan.text = @"第二类";
    }
    
    if ([_model.completed boolValue]) {
        _labCompleted.hidden = NO;
        _labDate.text = _model.completedDate;
    }else
    {
        _labCompleted.hidden = YES;
        _labDate.text = _model.willDate;
        
    }
    
    
    
}
@end
