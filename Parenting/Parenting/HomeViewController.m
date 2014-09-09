/*
 *  2014/08/25 - 时间轴内容
 *
 *  0:系统消息 
 *
 *  **** 提醒根据时间节点判断进行添删 ****
 *  key:-1代表该提醒事项未完成 1代表该提醒事项已经完成
 *  1:用户自定义提醒
 *  10:疫苗提醒
 *  11:评测提醒
 *  12:日志提醒
 *  20:生理-身高记录提醒
 *  21:生理-体重记录提醒
 *  22:生理-头围记录提醒
 *
 *  **** 贴士推送 ****
 *  key:代表该贴士ID
 *  99:贴士推送-（根据用户及贴士属性推送）
 *
 */

#import "HomeViewController.h"
#import "InitTimeLineData.h"
#import "NetWorkConnect.h"
#import "DataContract.h"
#import "InitBabyInfoViewController.h"

#define _SHOW_HEIGHT 170
#define _CELL_NORMAL_BASEHEIGHT 52.0f
#define _CELL_NORMAL_INSHEIGHT  18.0f
#define _CELL_TIPS_BASEHEIGHT 223.0f

#define _CELL_CHANGE_MAXLEN 17

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
} 

-(void)viewWillAppear:(BOOL)animated    {
    //未初始化宝宝基本信息时跳转 
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kBabyNickname"] == nil) { 
        InitBabyInfoViewController *ctr = [[InitBabyInfoViewController alloc]init];
        ctr.initBabyInfoDelegate = self;
        [self.navigationController pushViewController:ctr animated:NO];
        return;
    }
    else{
        [self initData];
    }
    [MobClick beginLogPageView:@"首页"];
    self.navigationController.navigationBarHidden = YES;
}

-(void)initHomeData{
    [self initData];
}

-(void)initView{
    _photoAreaView = [[[NSBundle mainBundle] loadNibNamed:@"PhotoAreaView" owner:self options:nil] lastObject];
    _photoAreaView.top = _SHOW_HEIGHT - _photoAreaView.height;
    
    [_mainScrollView addSubview:_photoAreaView];
    
    _timeLineTableView.top = _SHOW_HEIGHT;
    _timeLineTableView.scrollEnabled = NO;
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.frame = CGRectMake(10,_photoAreaView.height - 25, 20.0f, 20.0f);
    [_photoAreaView addSubview:_activityView];
}

-(void)initData{
    [_photoAreaView initData];
    
    //加载数据源
    [self checkTips];
    _data = [InitTimeLineData getTimeLineData];
    
    //计算表格高度
    double dTableHeight = 0;
    for (int i = 0; i<[_data count];i++ ) {
        if ([[[_data objectAtIndex:i] objectAtIndex:0] intValue] != 9) {
            int tLen = [[[_data objectAtIndex:i] objectAtIndex:1] length];
            if (tLen <= _CELL_CHANGE_MAXLEN) {
                dTableHeight = dTableHeight + _CELL_NORMAL_BASEHEIGHT;
            }
            else {
                dTableHeight = dTableHeight + _CELL_NORMAL_BASEHEIGHT + _CELL_NORMAL_INSHEIGHT;
            }
        }
        else{
            dTableHeight = dTableHeight + _CELL_TIPS_BASEHEIGHT;
        }
    }
    
    _timeLineTableView.height = dTableHeight;
    _mainScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,_SHOW_HEIGHT + _timeLineTableView.height);
}

#pragma tableView datasource Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //labelTitle 如果大于_CELL_CHANGE_MAXLEN个字需要换行
    if ([[[_data objectAtIndex:indexPath.row] objectAtIndex:0] intValue] != 9) {
        int tLen = [[[_data objectAtIndex:indexPath.row] objectAtIndex:1] length];
        
        if (tLen <= _CELL_CHANGE_MAXLEN) {
            return _CELL_NORMAL_BASEHEIGHT ;
        }
        else {
            return _CELL_NORMAL_BASEHEIGHT + _CELL_NORMAL_INSHEIGHT;
        }
        
    }
    else{
        return _CELL_TIPS_BASEHEIGHT;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *curData = [_data objectAtIndex:indexPath.row];
    
    if ([[curData objectAtIndex:0]intValue] != 9) {
        
        /** init cell view **/
        UIImageView *imageViewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [cell addSubview:imageViewIcon];
        
        UIImageView *imageViewContentBg = [[UIImageView alloc] init];
        [cell addSubview:imageViewContentBg];
        
        UILabel *labelContent = [[UILabel alloc] init];
        labelContent.font = [UIFont systemFontOfSize:HOME_TIPSTEXT];
        labelContent.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
        [imageViewContentBg addSubview:labelContent];
        
        UILabel *labelTime = [[UILabel alloc] init];
        labelTime.font = [UIFont systemFontOfSize:SMALLTEXT];
        labelTime.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
        [imageViewContentBg addSubview:labelTime];
        
        /** init cell data **/
        switch ([[curData objectAtIndex:0]intValue]) {
            case 0:
                imageViewIcon.image = [UIImage imageNamed:@"icon_news.png"];
                break;
            case 1:
                imageViewIcon.image = [UIImage imageNamed:@"icon_alarm.png"];
                break;
            case 10:
                imageViewIcon.image = [UIImage imageNamed:@"icon_alerm_vaccine.png"];
                break;
            case 11:
                imageViewIcon.image = [UIImage imageNamed:@"icon_alerm_milstone.png"];
                break;
            case 12:
                imageViewIcon.image = [UIImage imageNamed:@"icon_alerm_dialy.png"];
                break;
            case 20:
                imageViewIcon.image = [UIImage imageNamed:@"icon_height.png"];
                break;
            case 21:
                imageViewIcon.image = [UIImage imageNamed:@"icon_weight.png"];
                break;
            default:
                imageViewIcon.image = [UIImage imageNamed:@"icon_news.png"];
                break;
        }
        
        //根据标题长度判断是否需要拉升
        if ([[curData objectAtIndex:1] length] <= _CELL_CHANGE_MAXLEN) {
            imageViewContentBg.frame = CGRectMake(57, 6, 246, 40);
            imageViewContentBg.image = [UIImage imageNamed:@"input_word.png"];
            labelContent.frame = CGRectMake(10, 5, 230, 16);
            labelTime.frame = CGRectMake(198, 22, 48, 15);
        }
        else {
            imageViewContentBg.frame = CGRectMake(57, 6, 246, 58);
            imageViewContentBg.image = [[UIImage imageNamed:@"input_word.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:30];
            labelContent.frame = CGRectMake(10, 5, 230, 36);
            labelContent.lineBreakMode = NSLineBreakByWordWrapping;
            labelContent.numberOfLines = 0;
            labelTime.frame = CGRectMake(198, 40, 48, 15);
        }
        
        labelContent.text = [curData objectAtIndex:1];
        labelTime.text = [ACDate getMsgTimeSinceDate:[ACDate getDateFromTimeStamp:[[curData objectAtIndex:4]longValue]]];
    }
    else {
        /** init cell view **/
        UIImageView *imageViewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [cell addSubview:imageViewIcon];
        
        UIImageView *imageViewContentBg = [[UIImageView alloc] init];
        imageViewContentBg.frame = CGRectMake(57, 6, 246, 211);
        imageViewContentBg.image = [[UIImage imageNamed:@"input_word.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:30];
        [cell addSubview:imageViewContentBg];
        
        UILabel *labelContent = [[UILabel alloc] init];
        labelContent.frame = CGRectMake(10, 5, 230, 16);
        labelContent.font = [UIFont systemFontOfSize:HOME_TIPSTEXT];
        labelContent.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
        [imageViewContentBg addSubview:labelContent];
        
        UIImageView *imagePic = [[UIImageView alloc] init];
        imagePic.frame = CGRectMake(10, 26, 230, 161);
        imagePic.image = [UIImage imageNamed:@"tip_demo.jpg"];
        [imageViewContentBg addSubview:imagePic];
        
        UILabel *labelTime = [[UILabel alloc] init];
        labelTime.frame = CGRectMake(198, 192, 48, 15);
        labelTime.font = [UIFont systemFontOfSize:SMALLTEXT];
        labelTime.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
        [imageViewContentBg addSubview:labelTime];
        
        /** init cell data **/
        imageViewIcon.image = [UIImage imageNamed:@"icon_remind.png"];
        labelContent.text = [curData objectAtIndex:1];
        labelTime.text = @"45分钟前";
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"小喵喵要开始打疫苗啦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alert show];
}

#pragma scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < -50 && !_activityView.isAnimating) {
        /** TODO 加载数据 **/
//        [_activityView startAnimating];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 同步贴士
/** 检测贴士推送:99 **/
-(void)checkTips{
    [[SyncController syncController] getTipsHome:ACCOUNTUID
                                  LastCreateTime:2
                                      BabyMonths:2
                                             HUD:_hud
                                    SyncFinished:^(NSArray *retArr){
                                        //取出获取到数据的ids
                                        if ([retArr count] ==0){
                                            //
                                        }
                                        
                                    }
                                  ViewController:self];
}

@end
