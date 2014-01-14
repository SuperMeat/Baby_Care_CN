//
//  SuggestView.m
//  Parenting
//
//  Created by user on 13-5-21.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "SuggestView.h"

@implementation SuggestView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
    }
    return self;
}
-(id)initWithTitle:(NSString*)title Suggestion:(NSString*)suggestion Center:(CGPoint)center;
{
    self=[super init];
    if (self) {
        
        self.center=center;
        self.bounds=CGRectMake(0, 0, 275, 190);
    UIImageView *titleimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 275, 23)];
    titleimage.image=[UIImage imageNamed:@"title_orange.png"];
    
    UIImageView *suggestionimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 23, 275, 168)];
    suggestionimage.image=[UIImage imageNamed:@"bg_advice.png"];
    
    self.backgroundColor=[UIColor clearColor];
    UILabel *titlelable=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 265, 23)];
    titlelable.textAlignment=NSTextAlignmentCenter;
    titlelable.text=title;
    titlelable.backgroundColor=[UIColor clearColor];
        titlelable.textColor=[UIColor colorWithRed:0xFF/255.0 green:0xFF/255.0 blue:0xFF/255.0 alpha:0xFF/255.0];
        
    UITextView *suggestionlable=[[UITextView alloc]initWithFrame:CGRectMake(15, 0, 245, 163)];
    suggestionlable.text=suggestion;
    //suggestionlable.numberOfLines=0;
    suggestionlable.textColor=[UIColor colorWithRed:0x97/255.0 green:0x97/255.0 blue:0x97/255.0 alpha:0xFF/255.0];

    suggestionlable.backgroundColor=[UIColor clearColor];
        suggestionlable.editable = NO;
    //    suggestionlable.lineBreakMode=NSLineBreakByTruncatingMiddle;
    [titleimage addSubview:titlelable];
    [suggestionimage addSubview:suggestionlable];
    
    [self addSubview:titleimage];
    [self addSubview:suggestionimage];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
