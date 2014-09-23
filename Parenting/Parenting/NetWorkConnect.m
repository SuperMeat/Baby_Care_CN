//
//  NetWorkConnect.m
//
//  Copyright (c) 2013年 Thinktec. All rights reserved.
//

#import "NetWorkConnect.h"
#import "SBJson.h" 
#import "Reachability.h"

//ASIHTTPRequest *request;

@interface NetWorkConnect ()

@end

static NetWorkConnect * _instance;

#define request_timeout 5
#define retry_count 3

@implementation NetWorkConnect
@synthesize delegate;
@synthesize finishCallBackBlock;
@synthesize failCallBackBlock;
@synthesize showNetworkStatus;

+ (NetWorkConnect *)sharedRequest
{
	if (_instance == nil)
	{
		_instance = [[NetWorkConnect alloc] init];
	}
	
	return _instance;
}

//-(id)init
//{
//    self=[super init];
//    if (self) {
//        
//    }
//    return self;
//}

#pragma mark - 

-(void)httpRequestWithURL:(NSString*)str_url
                     data:(NSMutableDictionary*)dict
                     mode:(NSString*)mode  HUD:(MBProgressHUD*)hud
           didFinishBlock:(RequestDidFinishBlock)finishBlock
             didFailBlock:(RequestDidFail)failBlock
           isShowProgress:(BOOL)isShow
            isAsynchronic:(BOOL)isAsyn
            netWorkStatus:(BOOL)isShowNetWorkStatus
           viewController:(UIViewController*)viewController{
    
    if (isShow) {
        
        Reachability *astatus = [Reachability reachabilityForInternetConnection];
        if (![astatus currentReachabilityStatus]) {
            
            if (hud) {
                hud.labelText = http_error;
                [hud hide:YES afterDelay:1];
            }
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:http_error delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
    }
    
    NSArray *base_key = @[@"session",@"type",@"v",@"body"];
    NSMutableArray *postArray = [[NSMutableArray alloc]initWithObjects:@"",[NSNumber numberWithInt:BASEREQUEST_TYPE],PROVERSION,dict,nil];
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc]initWithObjects:postArray forKeys:base_key];
    
    self.finishCallBackBlock = finishBlock;
    self.failCallBackBlock = failBlock;
    self.showNetworkStatus = isShowNetWorkStatus;
    
    NSURL *url = [NSURL URLWithString:str_url];
    
    //解决__block retain cycle
    //__block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    __block ASIHTTPRequest *requestBlock = request;
    
    [request setURL:url];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableData *jsonMData = [NSMutableData dataWithData:jsonData];
    [request setPostBody:jsonMData];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"content-type" value:@"application/json"];
    [request setResponseEncoding:NSUTF8StringEncoding];
//    [request setDelegate:self];
    [request setRequestMethod:mode];
    [request setTimeOutSeconds:request_timeout];
    [request setNumberOfTimesToRetryOnTimeout:retry_count];
    
    [request setCompletionBlock:
     ^{
         if (finishCallBackBlock) {
             SBJsonParser *json = [[SBJsonParser alloc]init];
             NSData *data = [requestBlock responseData];
             NSDictionary *dict = [json objectWithData:data];
             if (finishCallBackBlock){
                 finishCallBackBlock (dict);
             }
         }
     }];
    
    [request setFailedBlock:
     ^{
         if (failCallBackBlock) {
             failCallBackBlock ([[requestBlock error] debugDescription]);
         }
     }];
    
    if (isAsyn) {
        [request startAsynchronous];
    }else
    {
        [request startSynchronous];
    }
}

- (void) requestStarted:(ASIHTTPRequest *) request {
    
}
- (void) requestFinished:(ASIHTTPRequest *)request {
    if (finishCallBackBlock) {
        SBJsonParser *json = [[SBJsonParser alloc]init];
        NSData *data = [request responseData];
        NSDictionary *dict = [json objectWithData:data];
        if (finishCallBackBlock){
            finishCallBackBlock (dict);
        }
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    if (failCallBackBlock) {
        failCallBackBlock ([[request error] debugDescription]);
    }
}

#pragma 检测远程文件是否存在
-(BOOL)remoteFileExist:(NSString*)str_url
{
    NSURL *url = [NSURL URLWithString:str_url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    int statusCode = [request responseStatusCode];
    if(statusCode==200){
        return YES;
    }
    return NO;
}

@end
