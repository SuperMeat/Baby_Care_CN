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
        self.bounds=CGRectMake(0, 0, 275, 100);
        
        UIImageView *suggestionimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 275, 100)];
        suggestionimage.layer.cornerRadius = 8.0f;
        suggestionimage.userInteractionEnabled = YES;
        self.backgroundColor=[UIColor clearColor];
        UITextView *suggestionlable=[[UITextView alloc]initWithFrame:CGRectMake(10, 0, 245, 100)];
        suggestionlable.text=suggestion;
        suggestionlable.textAlignment = NSTextAlignmentCenter;
        CGSize size = [suggestionlable.text sizeWithFont: [UIFont boldSystemFontOfSize:15]
                                 constrainedToSize: CGSizeMake(245, 9999999.0f)
                                     lineBreakMode: NSLineBreakByClipping];
        suggestionlable.scrollEnabled = YES;
        suggestionlable.autoresizingMask
        = UIViewAutoresizingFlexibleHeight;
        [suggestionlable setContentSize:size];
        if (suggestionlable.contentSize.height <= suggestionlable.frame.size.height)
        {
            [suggestionlable setUserInteractionEnabled:NO];
        }
        
        suggestionlable.textColor=[ACFunction colorWithHexString:@"#6599a2"];
        suggestionlable.backgroundColor=[UIColor clearColor];
        suggestionlable.editable = NO;
        suggestionlable.font = [UIFont systemFontOfSize:15];
        suggestionlable.userInteractionEnabled = YES;
        [suggestionimage addSubview:suggestionlable];
        [self addSubview:suggestionimage];
    }
    return self;
}

@end
