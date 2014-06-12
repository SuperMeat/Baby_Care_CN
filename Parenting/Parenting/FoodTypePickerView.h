//
//  FoodTypePickerView.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-5-19.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FoodTypePickerViewDelegate<NSObject>
@optional
-(void)sendFeedTypeSaveChanged:(NSString*)type;
@end
@interface FoodTypePickerView : UIPickerView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *foodtypeList;
    int _type;
}

-(id)initWithFrame:(CGRect)frame Type:(NSString*)type;
@property (assign) id<FoodTypePickerViewDelegate> foodTypePickerViewDelegate;

@end
