//
//  DiaperPickerView.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-5-8.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DiaperPickerViewDelegate<NSObject>
@optional
-(void)sendDiaperSaveChanged:(int)type NewStatus:(NSString*)newstatus;
@end
@interface DiaperPickerView : UIPickerView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *backgroundColorList;
    NSMutableArray *descripeList;
    int _type;
}
-(id)initWithFrame:(CGRect)frame Type:(int)type Option:(int)option;
@property (assign) id<DiaperPickerViewDelegate> diaperPickerViewDelegate;
@end
