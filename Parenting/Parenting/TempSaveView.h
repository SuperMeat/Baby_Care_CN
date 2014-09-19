//
//  TempSaveView.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-11.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TempSaveViewDelegate<NSObject>
@optional
-(void)sendTempReloadData;
@end

@interface TempSaveView : UIView<UITextFieldDelegate,CustomIOS7AlertViewDelegate>
{
    NSString *opType;
    int itemType;
    long createTime;
    NSDate* measureTime;
    
    UIImageView *imageview;
    UITextField *textRecordDate;
    UITextField *textValue;
    UIButton *buttonSave;
    UIButton *buttonCancel;
    
    UIDatePicker *datepicker;
    CustomIOS7AlertView *action;
}

- (id)initWithFrame:(CGRect)frame Type:(NSString *)type CreateTime:(long)create_time;

@property (assign) id<TempSaveViewDelegate> TempSaveDelegate;
@end
