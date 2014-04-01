//
//  NetWorkConnect.h 
//
//  Copyright (c) 2013年 Thinktec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"

@protocol NetWorkConnectDelegate

@required

@optional

@end

typedef void(^RequestDidFinishBlock)(NSDictionary *dict);
typedef void(^RequestDidFail)(NSString *strErrorMesg);



@interface NetWorkConnect : NSObject<ASIHTTPRequestDelegate> {
    id <NetWorkConnectDelegate> __delegate;
    
}

// 请求成功返回后执行的 block
@property (copy, nonatomic) RequestDidFinishBlock   finishCallBackBlock;
// 请求失败返回后执行的 block
@property (copy, nonatomic) RequestDidFail          failCallBackBlock;
// 请求失败返回后执行的 block
@property (assign, nonatomic) BOOL          showNetworkStatus;
 
#pragma mark request参数:WCF地址/封装请求数据/请求方法(POST,GET,PUT,DELETE)/HUD/请求结束回调/请求失败回调/标示/异步or同步/显示网络状态/调用的ViewController
-(void)httpRequestWithURL:(NSString*)str_url
                     data:(NSMutableDictionary*)dict
                     mode:(NSString*)mode
                      HUD:(MBProgressHUD*)hud
           didFinishBlock:(RequestDidFinishBlock)finishBlock
             didFailBlock:(RequestDidFail)failBlock
           isShowProgress:(BOOL)isShow
            isAsynchronic:(BOOL)isAsyn
            netWorkStatus:(BOOL)isShowNetWorkStatus
           viewController:(UIViewController*)viewController;

@property(nonatomic, assign) id<NetWorkConnectDelegate> delegate;

+ (NetWorkConnect *)sharedRequest;


@end
