//
//  ACTypeListPickerView.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-8-6.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ACTypeListPickerViewDelegate<NSObject>
@optional
-(void)sendTypeListSaveChanged:(NSString*)type;
@end
@interface ACTypeListPickerView : UIPickerView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *typelist;
}

-(id)initWithFrame:(CGRect)frame TypeList:(NSArray*)list;
@property (assign) id<ACTypeListPickerViewDelegate> typeListPickerViewDelegate;
@end
