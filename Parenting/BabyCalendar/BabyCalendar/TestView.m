 //
//  TestView.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "TestView.h"
#import "TestHeaderView.h"
#import "TestMiddleView.h"
#import "TestQuestionModel.h"
@implementation TestView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initViews];
    }
    return self;
}

- (void)_initViews
{
    _scrollView = [[UIScrollView alloc] init];
    
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"TestHeaderView" owner:self options:nil] lastObject];
    _middleView = [[[NSBundle mainBundle] loadNibNamed:@"TestMiddleView" owner:self options:nil] lastObject];
    _middleView.delegate = self;
    _footView = [[[NSBundle mainBundle] loadNibNamed:@"TestFootView" owner:self options:nil] lastObject];
    _footView.delegate = self;
}

- (void)setMonth:(NSInteger)month
{
    _month = month;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"TestData" ofType:@"plist"];
    NSArray* testDatas = [NSArray arrayWithContentsOfFile:path];
    NSArray* testData = testDatas[_month];
    NSMutableArray* questions = [NSMutableArray array];
    for (NSDictionary* dic in testData) {
        TestQuestionModel* model = [[TestQuestionModel alloc] init];
        model.type = [dic objectForKey:@"type"];
        model.content = [dic objectForKey:@"content"];
        model.image = [dic objectForKey:@"image"];
        model.answer = [NSNumber numberWithInteger:0];
        [questions addObject:model];
        
    }
    
    _middleView.datas = questions;
    _headerView.datas = questions;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _scrollView.frame = self.bounds;
    _scrollView.height = self.height-_footView.height;
    [_scrollView addSubview:_headerView];
    
    _middleView.top = _headerView.bottom;
    [_scrollView addSubview:_middleView];
    
    _footView.top = _scrollView.bottom;
    [self addSubview:_footView];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, _middleView.bottom);
    [self addSubview:_scrollView];
}

- (void)selectAction:(NSInteger)answer
{
    TestQuestionModel* model = _middleView.datas[_middleView.index];
    model.answer = [NSNumber numberWithInt:answer];
    [_middleView.datas replaceObjectAtIndex:_middleView.index withObject:model];
}

#pragma mark - TestMiddleView delegate
- (void)testMiddleView_back:(NSInteger)index
{
    _headerView.index = index;
    _footView.index = index;
    _footView.model = _middleView.datas[index];
}
- (void)testMiddleView_next:(NSInteger)index
{
    _headerView.index = index;
    _footView.index = index;
    _footView.model = _middleView.datas[index];
}

#pragma mark - TestFootViewDelegate

- (void)testFootView_can:(NSInteger)index
{
    [self selectAction:kAnswer_can];
}
- (void)testFootView_cannot:(NSInteger)index
{
     [self selectAction:kAnswer_cannot];
}
- (void)testFootView_unclear:(NSInteger)index
{
     [self selectAction:kAnswer_unclear];
}
@end
