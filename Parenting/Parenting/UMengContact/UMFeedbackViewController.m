//
//  UMFeedbackViewController.m
//  UMeng Analysis
//
//  Created by liu yu on 7/12/12.
//  Copyright (c) 2012 Realcent. All rights reserved.
//

#import "UMFeedbackViewController.h"
#import "UMFeedbackTableViewCellLeft.h"
#import "UMFeedbackTableViewCellRight.h"
#import "UMContactViewController.h"

#define TOP_MARGIN 20.0f
#define kNavigationBar_ToolBarBackGroundColor  [UIColor colorWithRed:0.007843 green:0.619607 blue:0.737254 alpha:1.0]
#define kContactViewBackgroundColor  [UIColor colorWithRed:0.078 green:0.584 blue:0.97 alpha:1.0]

static UITapGestureRecognizer *tapRecognizer;

@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"nav_btn_bg"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end

@interface UMFeedbackViewController ()
@property(nonatomic, copy) NSString *mContactInfo;
@end

@implementation UMFeedbackViewController

@synthesize mTextField = _mTextField, mTableView = _mTableView, mToolBar = _mToolBar, mFeedbackData = _mFeedbackData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)customizeNavigationBar:(UINavigationBar *)bar {
    bar.clipsToBounds = YES;
    if ([bar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        UIImage *image = [self imageWithColor:kNavigationBar_ToolBarBackGroundColor];

        [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (void)setupTableView {
    _tableViewTopMargin = self.navigationController.navigationBar.frame.size.height;

    BOOL contactViewHide = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UMFB_ShowContactView"] boolValue];
    
//    contactViewHide = NO;
    
    if (!contactViewHide) {
        _tableViewTopMargin = 88.0f;
        UILabel *title = (UILabel *) [self.mContactView viewWithTag:11];
        title.text = NSLocalizedString(@"Your contact information", @"您的联系方式");
//        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"UMFB_ShowContactView"];
    } else {
        _tableViewTopMargin = 0;
        [self.mContactView removeFromSuperview];
        [self.ageAndsexView removeFromSuperview];
    }

    self.mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

- (void)setupEGORefreshTableHeaderView {
    if (_refreshHeaderView == nil) {

        UMEGORefreshTableHeaderView *view = [[UMEGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.mTableView.bounds.size.height, self.mTableView.frame.size.width, self.mTableView.bounds.size.height)];
        view.delegate = (id <UMEGORefreshTableHeaderDelegate>) self;
        [self.mTableView addSubview:view];
        _refreshHeaderView = view;
    }

    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)setupToolbar {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    button.frame = CGRectMake(256, 7, 57.0f, 30.0f);
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [button setTitle:NSLocalizedString(@"UMSend",nil) forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btn1.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btn1_focus.png"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(sendFeedback:) forControlEvents:UIControlEventTouchUpInside];

    [self.mToolBar addSubview:button];

    [self setupTextField];
}

- (void)setupTextField {
    _mTextField = [[UITextField alloc] initWithFrame:CGRectMake(6, 7, _mToolBar.frame.size.width - 74.0f, 30.0f)];
    _mTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _mTextField.backgroundColor = [UIColor whiteColor];
    _mTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _mTextField.textAlignment = NSTextAlignmentLeft;
    _mTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _mTextField.borderStyle = UITextBorderStyleRoundedRect;
    _mTextField.font = [UIFont systemFontOfSize:14.0f];

    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    _mTextField.leftView = paddingView;
    _mTextField.leftViewMode = UITextFieldViewModeAlways;
    _mTextField.delegate = (id <UITextFieldDelegate>) self;

    [self.mToolBar addSubview:_mTextField];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {

    UMContactViewController *contactViewController = [[UMContactViewController alloc] initWithNibName:@"UMContactViewController" bundle:nil];

    contactViewController.delegate = (id <UMContactViewControllerDelegate>) self;
    [self.navigationController pushViewController:contactViewController animated:YES];
    if ([self.mContactInfo length]) {
        contactViewController.textView.text = self.mContactInfo;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [_refreshHeaderView egoRefreshScrollViewShowLoadingManual:self.mTableView];
    [_refreshHeaderView egoRefreshScrollViewDataSourceStartManualLoading:self.mTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelBaseInfo.text =NSLocalizedString(@"UMBaseinfo", nil);
    self.ageText.text =NSLocalizedString(@"UMAge", nil);
    self.sexText.text =NSLocalizedString(@"UMSex", nil);
    self.navigationItem.title = NSLocalizedString(@"UMFeedback", nil);

    //set delegate
    _ageText.delegate=self;
    _sexText.delegate =self;
    
    [self setBackButton];
    [self setBackgroundColor];
    [self setupTableView];
    [self setupEGORefreshTableHeaderView];
    [self setupToolbar];
    [self customizeNavigationBar:self.navigationController.navigationBar];
    [self setFeedbackClient];
    [self updateTableView:nil];
    [self handleKeyboard];

    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleSingleTap:)];
    [self.mContactView addGestureRecognizer:singleFingerTap];

    _shouldScrollToBottom = YES;

}

-(void) actionsheetShow:(NSInteger)index
{
    if (index == 1){
    //绑定PickerView_age
    NSArray *array = [[NSArray alloc] initWithObjects:NSLocalizedString(@"UMUnder15", ni),@"15~20",@"21~25",@"26~30",@"31~35",@"36~40",@"41~45",@"46~50",@"51~55",@"56~60",NSLocalizedString(@"UMAbove61", ni),nil];

    _pickerDS_age = array;
    
    //Action_age
    action_age=[[UIActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    _picker_age = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    _picker_age.delegate = self;
    _picker_age.dataSource = self;
    _picker_age.showsSelectionIndicator = YES;
    _ageText.inputView  = _picker_age;
    [_picker_age selectRow:0 inComponent:0 animated:NO];
    _picker_age.frame=CGRectMake(0, 0, 320, 100);
    
    action_age.bounds=CGRectMake(0, 0, 320, 200);
    [action_age addSubview:_picker_age];
    [action_age showInView:self.view];
    }
    else{
    //Action_sex
        
        NSArray *array2 = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Female", ni),NSLocalizedString(@"Male", ni),nil];
    _pickerDS_sex = array2;
    action_sex=[[UIActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    _picker_sex = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    _picker_sex.delegate = self;
    _picker_sex.dataSource = self;
    _picker_sex.showsSelectionIndicator = YES;
    _sexText.inputView  = _picker_sex;
    [_picker_sex selectRow:0 inComponent:0 animated:NO];
    _picker_sex.frame=CGRectMake(0, 0, 320, 100);
    
    action_sex.bounds=CGRectMake(0, 0, 320, 200);
    [action_sex addSubview:_picker_sex];
        [action_sex showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (action_age == actionSheet) {
        NSInteger row = [_picker_age selectedRowInComponent:0];
        NSString *selected = [_pickerDS_age objectAtIndex:row];
        _ageText.text = [NSString stringWithFormat:@"%@", selected];
    }
    else if (action_sex == actionSheet) {
        NSInteger row = [_picker_sex selectedRowInComponent:0];
        NSString *selected = [_pickerDS_sex objectAtIndex:row];
        _sexText.text = [NSString stringWithFormat:@"%@", selected];

    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _ageText)
    {
        [self actionsheetShow:1];
        [_ageText resignFirstResponder];
    }
    else if (textField == _sexText)
    {
        [self actionsheetShow:2];
        [_sexText resignFirstResponder];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == _picker_sex) {
        return [_pickerDS_sex count];
    }else if (pickerView == _picker_age){
         return [_pickerDS_age count];
    }
    else{
        return 0;
    }
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == _picker_sex) {
        return [_pickerDS_sex objectAtIndex:row];
    }else if (pickerView == _picker_age){
        return [_pickerDS_age objectAtIndex:row];
    }
    else{
        return @"";
    }
}

//重画pickerview视图
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 35;
}

- (void)handleKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
}

- (void)setFeedbackClient {
    _mFeedbackData = [[NSArray alloc] init];
    feedbackClient = [UMFeedback sharedInstance];
    if ([self.appkey isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NO Umeng kUmengAppkey"
                                                        message:@"Please define UMENG_APPKEY macro!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [feedbackClient setAppkey:self.appkey delegate:(id <UMFeedbackDataDelegate>) self];

//    从缓存取topicAndReplies
    self.mFeedbackData = feedbackClient.topicAndReplies;
}

- (void)setBackgroundColor {
    self.mTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"messages_tableview_background"]];
    if ([self.mToolBar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
        UIImage *image = [self imageWithColor:kNavigationBar_ToolBarBackGroundColor];
        [self.mToolBar setBackgroundImage:image forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    } else {
        self.mToolBar.barStyle = UIBarStyleBlack;
    }
    self.mContactView.backgroundColor = kContactViewBackgroundColor;
}

- (void)setBackButton {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [backBtn addTarget:self action:@selector(backToPrevious) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 34, 28)];
    title.backgroundColor = [UIColor clearColor];
    
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.text = NSLocalizedString(@"navback", nil);
    title.font = [UIFont systemFontOfSize:14];
    [backBtn addSubview:title];

    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 51.0f, self.navigationController.navigationBar.frame.size.height * 0.7);
    backBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
}

- (void)didTapAnywhere:(UITapGestureRecognizer *)recognizer {
    [self.mTextField resignFirstResponder];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark keyboard notification

- (void)keyboardWillShow:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;

    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{

                         CGRect toolbarFrame = self.mToolBar.frame;
                         toolbarFrame.origin.y = self.view.bounds.size.height - keyboardHeight - toolbarFrame.size.height;
                         self.mToolBar.frame = toolbarFrame;

                         CGRect tableViewFrame = self.mTableView.frame;
                         tableViewFrame.size.height = self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height - keyboardHeight;
                         self.mTableView.frame = tableViewFrame;
                     }
                     completion:^(BOOL finished) {
                         if (_shouldScrollToBottom) {
                             [self scrollToBottom];
                         }
                     }
    ];

    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [UIView beginAnimations:@"bottomBarDown" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

    CGRect toolbarFrame = self.mToolBar.frame;
    toolbarFrame.origin.y = self.view.bounds.size.height - toolbarFrame.size.height;
    self.mToolBar.frame = toolbarFrame;

    CGRect tableViewFrame = self.mTableView.frame;
    tableViewFrame.size.height = self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height;
    self.mTableView.frame = tableViewFrame;

    [UIView commitAnimations];

    [self.view removeGestureRecognizer:tapRecognizer];
}

- (void)backToPrevious {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)sendFeedback:(id)sender {
    if ([self.mTextField.text length]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:self.mTextField.text forKey:@"content"];
        
        //传输年龄和性别
//        gender,     性别,      NSString, "1"或"male"为男 "0"或"female" 为女
//        age_group,  年龄段,    NSString, "1"..."8",对应表如下
//        "age_group" 取值和年龄段对照表
//        "1" 小于18岁
//        "2" 18～24岁
//        "3" 25～30岁
//        "4" 31～35岁
//        "5" 36～40岁
//        "6" 41～50岁
//        "7" 51～59岁
//        "8" 大于60岁
//        content,    反馈内容,  NSString,  长度不应超过255个字符
//        remark,   备注,      NSDictionary, 可以存放自定义的内容，比如评分等
        NSString *_age = @"";
        NSString *_sex = @"";
        if (![_ageText.text  isEqual: @"Age"] && ![_ageText.text isEqual:@"年龄"] ) {
             _age = _ageText.text;
        }
        if (![_sexText.text  isEqual: @"Gender"] && ![_sexText.text isEqual:@"性别"] ) {
            if ([_sexText.text isEqual:@"Female"]) {
                _sex = @"女";
            }else if ([_sexText.text isEqual:@"Male"]){
                _sex = @"男";
            }
            _sex = _sexText.text;
        }
        if (![_age  isEqual: @""] && ![_sex  isEqual:@""])
        {
            [dictionary setObject:_sex forKey:@"gender"];
            [dictionary setObject:_age forKey:@"age_group"];
            
            NSDictionary *remark = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"性别:%@ ,年龄:%@",_sex,_age] forKey:@"Info"];
            [dictionary setObject:remark forKey:@"remark"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"UMFB_ShowContactView"];
            [self.ageAndsexView removeFromSuperview];
        }

        if ([self.mContactInfo length]) {
            [dictionary setObject:[NSDictionary dictionaryWithObjectsAndKeys:self.mContactInfo, @"plain", nil] forKey:@"contact"];
        }
        
        //添加性别&年龄段

        [feedbackClient post:dictionary];
        [self.mTextField resignFirstResponder];
        _shouldScrollToBottom = YES;
    }
    
    
}

#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_mFeedbackData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *content = [[feedbackClient.topicAndReplies objectAtIndex:(NSUInteger) indexPath.row] objectForKey:@"content"];
    CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:14.0f]
                           constrainedToSize:CGSizeMake(226.0f, MAXFLOAT)
                               lineBreakMode:NSLineBreakByWordWrapping];
    return labelSize.height + 40 + TOP_MARGIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *L_CellIdentifier = @"L_UMFBTableViewCell";
    static NSString *R_CellIdentifier = @"R_UMFBTableViewCell";

    NSDictionary *data = [self.mFeedbackData objectAtIndex:(NSUInteger) indexPath.row];

    if ([[data valueForKey:@"type"] isEqualToString:@"dev_reply"]) {
        UMFeedbackTableViewCellLeft *cell = (UMFeedbackTableViewCellLeft *) [tableView dequeueReusableCellWithIdentifier:L_CellIdentifier];
        if (cell == nil) {
            cell = [[UMFeedbackTableViewCellLeft alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:L_CellIdentifier];
        }

        cell.textLabel.text = [data valueForKey:@"content"];
        cell.timestampLabel.text = [data valueForKey:@"datetime"];

        return cell;
    }
    else {

        UMFeedbackTableViewCellRight *cell = (UMFeedbackTableViewCellRight *) [tableView dequeueReusableCellWithIdentifier:R_CellIdentifier];
        if (cell == nil) {
            cell = [[UMFeedbackTableViewCellRight alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:R_CellIdentifier];
        }

        cell.textLabel.text = [data valueForKey:@"content"];
        cell.timestampLabel.text = [data valueForKey:@"datetime"];

        return cell;

    }
}

#pragma mark ContactViewController delegate method

- (void)updateContactInfo:(UMContactViewController *)controller contactInfo:(NSString *)info {
    if ([info length]) {
        self.mContactInfo = info;
        UILabel *title = (UILabel *) [self.mContactView viewWithTag:11];
        title.text = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"Your contact information", @"您的联系方式"), info];
    }
}

#pragma mark Umeng Feedback delegate

- (void)updateTableView:(NSError *)error {
    if ([self.mFeedbackData count]) {
        [self.mTableView reloadData];
    }
}

- (void)updateTextField:(NSError *)error {
    if (!error) {
        self.mTextField.text = @"";
        [feedbackClient get];
    }
}

- (void)getFinishedWithError:(NSError *)error {
    if (!error) {
        [self updateTableView:error];
    }

    if (_shouldScrollToBottom) {
        [self scrollToBottom];
    }

    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}

- (void)postFinishedWithError:(NSError *)error {
//    UIAlertView *alertView;
//    if (!error)
//    {
//        alertView = [[UIAlertView alloc] initWithTitle:@"感谢您的反馈!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    }
//    else
//    {
//        alertView = [[UIAlertView alloc] initWithTitle:@"发送失败!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    }
//    
//    [alertView show];

    [self updateTextField:error];
}

- (void)doneLoadingTableViewData {
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mTableView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollToBottom {
    if ([self.mTableView numberOfRowsInSection:0] > 1) {
        int lastRowNumber = [self.mTableView numberOfRowsInSection:0] - 1;
        NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
        [self.mTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)reloadTableViewDataSource {
    _reloading = YES;
    [feedbackClient get];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(UMEGORefreshTableHeaderView *)view {
    _shouldScrollToBottom = NO;
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(UMEGORefreshTableHeaderView *)view {
    return _reloading; // should return if data source model is reloading
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(UMEGORefreshTableHeaderView *)view {
    return [NSDate date]; // should return date data source was last changed
}

#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    return YES;
}

- (void)dealloc {

    feedbackClient.delegate = nil;
}

@end
