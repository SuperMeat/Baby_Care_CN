//
//  CalendarCell.m
//  BabyCalendar
//
//  Created by will on 14-5-21.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "CalendarCell.h"
#import "CalendarModel.h"
#import "CKCalendarModel.h"
#import "MilestoneModel.h"
#import "NoteModel.h"
#import "VaccineModel.h"
#import "TrainModel.h"
#import "TestModel.h"
#import "NoteInfoView.h"
@implementation CalendarCell

- (void)awakeFromNib
{
    // Initialization code
    _noteInfoView = [[[NSBundle mainBundle] loadNibNamed:@"NoteInfoView" owner:self options:nil] lastObject];
    

    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 57)];
    v.backgroundColor = UIColorFromRGB(kColor_cal_selectedDate);
    self.selectedBackgroundView = v;
    
    _labDetail.font = [UIFont fontWithName:kFont size:12];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _noteInfoView.left = 160;
    [self.contentView addSubview:_noteInfoView];

    
}

- (void)setRow:(NSInteger)row
{
    _row = row;
    
    NSString* imageName = [NSString stringWithFormat:@"cell_bg_%d",_row];
    NSString* imageSelectedName = [NSString stringWithFormat:@"cell_bg_%d",_row];
//    NSString* selectedImageName = [NSString stringWithFormat:@"cell_bg_selected_%d",_row];
    [_btnCell setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [_btnCell setImage:[UIImage imageNamed:imageSelectedName] forState:UIControlStateSelected];
    
//    [_btnCell setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateHighlighted];
    _btnCell.userInteractionEnabled = NO;
    
    NSArray* colors = @[UIColorFromRGB(kColor_cal_note),UIColorFromRGB(kColor_cal_mileastone),UIColorFromRGB(kColor_cal_val),UIColorFromRGB(kColor_cal_train),UIColorFromRGB(kColor_cal_test),UIColorFromRGB(kColor_cal_set)];
    _labDetail.textColor = colors[_row];
    
    if (_row > 5) {
        _bgCellView.image = [UIImage imageNamed:@"bg_cell_no_buttom.jpg"];
    }else
    {
        _bgCellView.image = [UIImage imageNamed:@"bg_cell_buttom.jpg"];
    }
    
    // point
    NSString* pointImageStr = [NSString stringWithFormat:@"point_%d",_row];
    _pointView.image = [UIImage imageNamed:pointImageStr];
    

}
- (void)setModel:(CalendarModel *)model
{
    _model = model;
    
    _labDetail.text = _model.detail;
    _labDetail.hidden = NO;
    _noteInfoView.hidden = YES;
    _pointView.hidden = NO;
    
    if (_row == 0 && _ckModel.noteModel != nil) {
        _noteInfoView.hidden = NO;
        _noteInfoView.model = _ckModel.noteModel;
        _pointView.hidden = YES;
    }
    
    if (_row == 1 && [_ckModel.milestone boolValue]) {
        _labDetail.text = _ckModel.milestoneModel.title;
        _pointView.hidden = YES;
    }
    if (_row == 2 && [_ckModel.vaccine boolValue]) {
        NSString* andsoText = @"";
        if (_ckModel.vaccineNum > 1)
        {
            andsoText = @" 等";
        }
        
        _labDetail.text = [NSString stringWithFormat:@"%@%@",_ckModel.vaccineModel.vaccine,andsoText];
        _pointView.hidden = YES;
    }
    if (_row == 3 && [_ckModel.train boolValue]) {
        _labDetail.text = @"已完成";
        _pointView.hidden = YES;
    }
    if (_row == 4 && [_ckModel.test boolValue]) {
        _labDetail.text = [NSString stringWithFormat:@"%@,%@ 分",_ckModel.testModel.date,_ckModel.testModel.score];
        _pointView.hidden = YES;
    }
    
    
}

@end
