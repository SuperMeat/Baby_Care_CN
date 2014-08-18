//
//  TestHeaderView.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "TestHeaderView.h"
#import "TestQuestionModel.h"
@implementation TestHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = UIColorFromRGB(kColor_test_headBg);
    
    _imgView.layer.borderWidth = 2.0f;
    _imgView.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgView.layer.cornerRadius = 5.0f;
    [_imgView.layer setMasksToBounds:YES];
}

- (void)setDatas:(NSMutableArray *)datas
{
    _datas = datas;
    
    [self imgView:_datas];
    
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    
    [self imgView:_datas];
}

- (void)imgView:(NSMutableArray*)datas
{
    TestQuestionModel* model = _datas[_index];
    NSString* image = [NSString stringWithFormat:@"%@.jpg",model.image];
    _imgView.image = [UIImage imageNamed:image];
}

@end
