//
//  MyMapViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-4.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "MyMapViewController.h"

@interface MyMapViewController ()

@end

@implementation MyMapViewController

-(id)init
{
    self=[super init];
    if (self){
        // Custom initialization
        [self.view setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 100, 20)];
        titleView.backgroundColor=[UIColor clearColor];
        UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        titleText.backgroundColor = [UIColor clearColor];
        [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
        titleText.textColor = [UIColor whiteColor];
        [titleText setTextAlignment:NSTextAlignmentCenter];
        [titleText setText:NSLocalizedString(@"附近", nil)];
        [titleView addSubview:titleText];
        
        self.navigationItem.titleView = titleView;
        //self.title = NSLocalizedString(@"Copyright",nil);
        self.hidesBottomBarWhenPushed=YES;
        //self.automaticallyAdjustsScrollViewInsets = NO;
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ( IOS7_OR_LATER )
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    self.mapView=[[MAMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    
    self.mapView.frame = self.view.bounds;
    
    self.mapView.delegate = self;
    
     self.mapView.showsCompass= NO;         //关闭指南针
    self.mapView.showsScale= NO;         //关闭比例尺
    self.mapView.scaleOrigin= CGPointMake(220, 420);    //设置比例尺位置
    [self.view addSubview:self.mapView];

    //self.search.delegate = self;

    //[self searchPlaceByPolygon];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utility

- (void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    self.mapView.delegate = nil;
}

- (void)clearSearch
{
    self.search.delegate = nil;
}

#pragma mark - AMapSearchDelegate

- (void)search:(id)searchRequest error:(NSString *)errInfo
{
    NSLog(@"%s: searchRequest = %@, errInfo= %@", __func__, [searchRequest class], errInfo);
}

- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [self clearMapView];
    
    [self clearSearch];
}

- (void)searchPlaceByAround
{
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceAround;
    poiRequest.location = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
    poiRequest.keywords = @"中国银行";
    poiRequest.radius= 1000;
    [self.search AMapPlaceSearch: poiRequest];
}

- (void)searchPlaceByPolygon
{
    AMapPlaceSearchRequest * poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlacePolygon;
    AMapGeoPoint *l1 = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
    AMapGeoPoint *l2 = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.581476];
    AMapGeoPoint *l3 = [AMapGeoPoint locationWithLatitude:39.890459 longitude:116.581476];
    AMapGeoPoint *l4 = [AMapGeoPoint locationWithLatitude:39.890459 longitude:116.481476];
    NSArray *points = @[l1, l2, l3, l4];
    poiRequest.polygon = [AMapGeoPolygon polygonWithPoints:points];
    poiRequest.keywords = @"中国银行";
    [self.search AMapPlaceSearch: poiRequest];
}

- (void)searchPlaceByID
{
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceID;
    poiRequest.uid = @"B000A7ZQYC";
    [self.search AMapPlaceSearch: poiRequest];
}

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    NSString *strCount = [NSString stringWithFormat:@"count: %d",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
}

@end
