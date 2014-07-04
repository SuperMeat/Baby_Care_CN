//
//  FrontiaViewController.h
//  frontiaDemo
//
//  Copyright (c) 2013 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Frontia/FrontiaAuthorizationDelegate.h>

@interface FrontiaViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)onButtonClicked:(id)sender;
- (IBAction)onQuotaClicked:(id)sender;
- (IBAction)onListClicked:(id)sender;
- (IBAction)onCreateDirClicked:(id)sender;
- (IBAction)onDownloadClicked:(id)sender;
- (IBAction)onUploadClicked:(id)sender;
- (IBAction)onStopDownload:(id)sender;
- (IBAction)onStopUpload:(id)sender;
- (IBAction)onMoveFileClicked:(id)sender;
- (IBAction)onCopyFileClicked:(id)sender;
- (IBAction)onMetaClicked:(id)sender;
- (IBAction)onDiffClicked:(id)sender;
- (IBAction)onStreamingUrlClicked:(id)sender;
- (IBAction)onAddCloudDownloadClicked:(id)sender;
- (IBAction)onCloudDownloadListClicked:(id)sender;
- (IBAction)onQueryCloudDownloadClicked:(id)sender;
- (IBAction)onCancelCloudDownloadClicked:(id)sender;
- (IBAction)onListRecycleClicked:(id)sender;
- (IBAction)onRestoreRecycleClicked:(id)sender;
- (IBAction)onCleanRecycleClicked:(id)sender;


- (IBAction)onBSSUploadClicked:(id)sender;
- (IBAction)onBSSDeleteClicked:(id)sender;
- (IBAction)onBSSUpdateClicked:(id)sender;
- (IBAction)onBSSQueryClicked:(id)sender;
- (IBAction)onBCSUploadClicked:(id)sender;
- (IBAction)onBCSDownloadClicked:(id)sender;
- (IBAction)onBCSListClicked:(id)sender;

- (IBAction)onBindClick:(id)sender;
- (IBAction)onDeleteTagClicked:(id)sender;
- (IBAction)onSendMessageClicked:(id)sender;

- (IBAction)onPCSDeleteClicked:(id)sender;
- (IBAction)onBCSDeletClicked:(id)sender;
- (IBAction)onListUserClicked:(id)sender;
- (IBAction)onAddRoleClicked:(id)sender;
- (IBAction)onDeleteRoleClicked:(id)sender;
- (IBAction)onFetchRoleClicked:(id)sender;
- (IBAction)onModifyRoleClicked:(id)sender;

- (IBAction)onCrontabMessageCreateClicked:(id)sender;
- (IBAction)onCrontabMessageDeleteClicked:(id)sender;
- (IBAction)onCrontabMessageReplaceClicked:(id)sender;
- (IBAction)onCrontabMessageListClicked:(id)sender;
- (IBAction)onCrontabMessageFetchClicked:(id)sender;

- (IBAction)onSetTagClicked:(id)sender;

- (IBAction)TextField_DidEndOnExit:(id)sender;
- (IBAction)onUserInfoClicked:(id)sender;

-(IBAction)logEventClick:(id)sender;
-(IBAction)logEventWithTime:(id)sender;
-(IBAction)logEventWithDurationTime:(id)sender;
-(IBAction)triggerEx:(id)sender;

-(IBAction)onLBSUploadButtonClicked:(id)sender;
-(IBAction)onLBSLocationButtonClicked:(id)sender;
-(IBAction)onLBSPOIButtonClicked:(id)sender;
-(IBAction)onLBSUserNearByButtonClicked:(id)sender;

-(IBAction)onShowShareMenuButtonClicked:(id)sender;
-(IBAction)onShowEditViewButtonClicked:(id)sender;
-(IBAction)onSingleShareButtonClicked:(id)sender;
-(IBAction)onMultiShareButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *bssResultIndicator;

@property (weak, nonatomic) IBOutlet UITextView *pcsResultIndicator;

@property (weak, nonatomic) IBOutlet UITextView *bcsResultIndicator;

@property (weak, nonatomic) IBOutlet UITextView *bindResultIndicator;

@property (weak, nonatomic) IBOutlet UITextView *crontabResultIndicator;

@property (weak, nonatomic) IBOutlet UITextView *userResultIndicator;

@property (weak, nonatomic) IBOutlet UITextView *lbsResultIndicator;

@property (weak, nonatomic) IBOutlet UITextView *recycleResultIndicator;

@property (weak, nonatomic) IBOutlet UITextView *cloudDownloadResultIndicator;

@property (nonatomic, retain) IBOutlet UITextField *tagsText;
@property (nonatomic, retain) IBOutlet UITextField *appidText;
@property (nonatomic, retain) IBOutlet UITextField *useridText;
@property (nonatomic, retain) IBOutlet UITextField *channelidText;

@end

