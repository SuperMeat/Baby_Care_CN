//
//  FrontiaViewController.m
//  frontiaDemo
//
//  Copyright (c) 2013 Baidu. All rights reserved.
//
#import <Frontia/FrontiaAuthorization.h>
#import <Frontia/Frontia.h>
#import <Frontia/FrontiaStorage.h>
#import <Frontia/FrontiaStorageDelegate.h>
#import <Frontia/FrontiaPush.h>
#import <Frontia/FrontiaPersonalStorage.h>
#import <Frontia/FrontiaPersonalStorageDelegate.h>
#import <Frontia/FrontiaQuery.h>
#import <Frontia/FrontiaFile.h>
#import <Frontia/FrontiaData.h>
#import <Frontia/FrontiaUser.h>
#import <Frontia/FrontiaRole.h>
#import <Frontia/FrontiaACL.h>
#import <Frontia/FrontiaLBSDelegate.h>

#import "FrontiaViewController.h"

#import "JSONKit.h"

typedef NS_ENUM(NSInteger, CMDMessageFrom) {
    CMDMessageFromPCS,
    CMDMessageFromBCS,
    CMDMessageFromBSS,
    CMDMessageFromPUSH
};


@interface FrontiaViewController()
{
    NSString *accessToken;
    CMDMessageFrom messageFrom;
}
@end

static NSString* cursor;

@implementation FrontiaViewController

@synthesize bssResultIndicator;
@synthesize bcsResultIndicator;
@synthesize pcsResultIndicator;
@synthesize bindResultIndicator;
@synthesize crontabResultIndicator;
@synthesize userResultIndicator;
@synthesize lbsResultIndicator;
@synthesize recycleResultIndicator;
@synthesize cloudDownloadResultIndicator;
@synthesize tagsText;
@synthesize appidText;
@synthesize useridText;
@synthesize channelidText;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    accessToken = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View lifecycle

-(void) viewDidAppear:(BOOL)animated
{
    static int times = 0;
    times++;
    
    NSString* cName = [NSString stringWithFormat:@"%@",  self.navigationItem.title, nil];
    NSLog(@"current appear tab title %@", cName);
    [[Frontia getStatistics] pageviewStartWithName:cName];
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"%@", self.navigationItem.title, nil];
    NSLog(@"current disappear tab title %@", cName);
    [[Frontia getStatistics] pageviewEndWithName:cName];
}


- (IBAction)onButtonClicked:(id)sender {
    FrontiaAuthorization* authorization = [Frontia getAuthorization];
    
    if(authorization) {
        
        //授权取消回调函数
        FrontiaAuthorizationCancelCallback onCancel = ^(){
            NSLog(@"OnCancel: authorization is cancelled");
        };
        
        //授权失败回调函数
        FrontiaAuthorizationFailureCallback onFailure = ^(int errorCode, NSString *errorMessage){
            NSLog(@"OnFailure: %d  %@", errorCode, errorMessage);
        };
        
        //授权成功回调函数
        FrontiaAuthorizationResultCallback onResult = ^(FrontiaUser *result){
             NSLog(@"OnResult account name: %@ account id: %@", result.accountName, result.experidDate);
            accessToken = result.accessToken;
            
            //设置授权成功的账户为当前使用者账户
            [Frontia setCurrentAccount:result];
        };
        
        //设置授权权限
        NSMutableArray *scope = [[NSMutableArray alloc] init];
        [scope addObject:FRONTIA_PERMISSION_USER_INFO];
        [scope addObject:FRONTIA_PERMISSION_PCS];
        
        [authorization authorizeWithPlatform:FRONTIA_SOCIAL_PLATFORM_BAIDU scope:scope supportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait isStatusBarHidden:NO cancelListener:onCancel failureListener:onFailure resultListener:onResult];
    }

}


- (IBAction)onUserInfoClicked:(id)sender {
    FrontiaAuthorization* authorization = [Frontia getAuthorization];

    if(authorization) {
        //获取用户信息失败回调
        FrontiaUserInfoFailureCallback onFailure = ^(int errorCode, NSString *errorMessage){
            NSLog(@"get user detail info failed with ID: %d and message:%@", errorCode, errorMessage);
        };
        
        //获取用户信息成功回调
        FrontiaUserInfoResultCallback onUserResult = ^(FrontiaUserDetail *result) {
            NSLog(@"get user detail info success with userName: %@", result.accountName);
            
        };
        //传递授权返回的令牌信息
        [authorization getUserInfoWithPlatform:FRONTIA_SOCIAL_PLATFORM_BAIDU failureListener:onFailure resultListener:onUserResult];
    }
    
}

- (IBAction)onQuotaClicked:(id)sender{
    FrontiaPersonalStorage* pcsClient = [Frontia getPersonalStorage];
    
    if(pcsClient) {
        
        //配额信息结果回调
        FrontiaPersonalQuotaCallback quotaResult = ^(long long used, long long total){
            NSString *message = [[NSString alloc] initWithFormat:@"get quota used: %lld and total:%lld", used, total];
            [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
        };
        
        //配额信息失败回调
        FrontiaPersonalFailureCallback fail = ^(int errorCode, NSString* errorMessage){
            NSString *message = [[NSString alloc] initWithFormat:@"get quota fail with error id %d and error message %@", errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
        };
        
        [pcsClient quotaInfo:quotaResult failureListener:fail];
        
    }

}
- (IBAction)onListClicked:(id)sender{
    FrontiaPersonalStorage* psClient = [Frontia getPersonalStorage];
    if(psClient) {

        //list接口回调
        FrontiaPersonalListCallback callback = ^(NSArray* list){
            
            NSString* resultStr = [[NSString alloc] initWithFormat:@"personal storage list info:"];
            FrontiaPersonalFileInfo* filePtr = nil;
            for(int i=0; i<list.count; i++) {
                filePtr = (FrontiaPersonalFileInfo*) list[i];
                resultStr = [resultStr stringByAppendingString:filePtr.path];
                resultStr = [resultStr stringByAppendingString:@"\r\n"];
            }

            [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:resultStr waitUntilDone:NO];
        };
        
        //list接口调用失败的回调
        FrontiaPersonalFailureCallback fail = ^(int errorCode, NSString* errorMessage){
            NSString *message = [[NSString alloc] initWithFormat:@"personal storage list fail with error id %d and error message %@", errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
        };
        
        //path必须是有效的个人数据存储路径
        [psClient listWithPath:@"/apps/FrontiaDevDemo" by:@"name" order:@"asc" resultListener:callback failureListener:fail];
    }
}

- (IBAction)onCreateDirClicked:(id)sender{
    FrontiaPersonalStorage* psClient = [Frontia getPersonalStorage];
    
    if(psClient) {
        //path必须是有效的个人数据存储路径
        [psClient makeDirWithPath:@"/apps/FrontiaDevDemo/favorite" resultListener:^(NSString *fileName) {
            NSString* resultStr = [[NSString alloc] initWithFormat:@"personal storage make dir success with name %@", fileName];
            NSLog(@"%@", resultStr);
            [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:resultStr waitUntilDone:NO];
        } failureListener:^(int errorCode, NSString *errorMessage) {
            NSString *message = [[NSString alloc] initWithFormat:@"personal storage list fail with error id %d and error message %@", errorCode, errorMessage];
            NSLog(@"%@", message);
            [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
        }];
    }
}

- (IBAction)onDownloadClicked:(id)sender{
    FrontiaPersonalStorage* psClient = [Frontia getPersonalStorage];

    if(psClient) {
        //下载状态的回调
        FrontiaPersonalProgressCallback status = ^(NSString* fileName, long bytes, long total){
            NSString *message = [[NSString alloc] initWithFormat:@"personal storage download file status: %@ at %ld with total %ld", fileName, bytes, total];
            [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
                                 
        };
        
        //下载成功时的回调
        FrontiaPersonalDownloadCallback result = ^(NSString* target, NSData* data) {
            NSString *message = [[NSString alloc] initWithFormat:@"personal storage download file %@ success", target];
            [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
            UIImage *aimage = [UIImage imageWithData: data];
            UIImageWriteToSavedPhotosAlbum(aimage, nil, nil, nil);
            
        };
        
        //下载失败时候回调
        FrontiaPersonalFailureCallback fail = ^(int errorCode, NSString* errorMessage){
            NSString *message = [[NSString alloc] initWithFormat:@"personal storage download request fail with error id %d and error message %@", errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
        };

        [psClient downloadFileWithSource:@"/apps/FrontiaDevDemo/uploadpcs.jpg" statusListener:status resultListener:result failureListener:fail];
        
    }

}

- (IBAction)onUploadClicked:(id)sender {
    messageFrom = CMDMessageFromPCS;
    [self pickImage];
}

- (IBAction)onPCSDeleteClicked:(id)sender {
    FrontiaPersonalStorage* pcsClient = [Frontia getPersonalStorage];
    if(pcsClient) {
        //删除文件成功的回调
        FrontiaPersonalFileOperationCallBack result = ^(NSString* fileName) {
            NSString *message = [[NSString alloc] initWithFormat:@"personal storage delete file %@ success", fileName];
            [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
        };
        
        //删除文件失败的回调
        FrontiaPersonalFailureCallback fail = ^(int errorCode, NSString* errorMessage){
            NSString *message = [[NSString alloc] initWithFormat:@"personal storage delete request fail with error id %d and error message %@", errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
        };
        
        [pcsClient deleteFileWithPath:@"/apps/FrontiaDevDemo/uploadpcs.jpg" resultListener:result failureListener:fail];
        
    }
    
}

- (IBAction)onStopDownload:(id)sender {
    FrontiaPersonalStorage* pcsClient = [Frontia getPersonalStorage];

    if(pcsClient) {
        [pcsClient stopDownloadingWithSource:@"/apps/FrontiaDevDemo/uploadpcs.jpg"];
    }
}

- (IBAction)onStopUpload:(id)sender {
    FrontiaPersonalStorage* pcsClient = [Frontia getPersonalStorage];
    
    if(pcsClient) {
        [pcsClient stopUploadingWithTarget:@"/apps/FrontiaDevDemo/uploadpcs.jpg"];
    }

}

-(void)pickImage
{
    // launch the image picker
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                             
        picker.allowsEditing = YES;
        
        [self presentModalViewController:picker animated:YES];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(nil != info && nil != picker){
        
        [picker dismissModalViewControllerAnimated:YES];
        picker.delegate = nil;
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData* data = UIImageJPEGRepresentation(image, 1.0);
        if(data) {
            if(messageFrom == CMDMessageFromPCS) {
                FrontiaPersonalStorage* psClient = [Frontia getPersonalStorage];
                if(psClient) {
                    
                    //上传进度回调
                    FrontiaPersonalProgressCallback status = ^(NSString* fileName, long bytes, long total){
                        NSString *message = [[NSString alloc] initWithFormat:@"personal storage upload file status: %@ at %ld with total %ld", fileName, bytes, total];
                        [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
                        
                    };
                    
                    //上传成功回调
                    FrontiaPersonalUploadResultCallback result = ^ (NSString *target, FrontiaPersonalFileInfo *result){
                        NSString *message = [[NSString alloc] initWithFormat:@"personal storage upload file %@ success", target];
                        [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
                        
                    };
                    
                    //上传失败回调
                    FrontiaPersonalFailureCallback fail = ^(int errorCode, NSString* errorMessage){
                        NSString *message = [[NSString alloc] initWithFormat:@"PCS upload request fail with error id %i with error message %@", errorCode, errorMessage];
                        [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
                    };
                    
                    //上传文件需要指定目标名
                    [psClient uploadFileWithData:data target:@"/apps/FrontiaDevDemo/uploadpcs.jpg" statusListener:status resultListener:result failureListener:fail];
                }
                
            } else if(messageFrom == CMDMessageFromBCS) {

                FrontiaStorage *storage= [Frontia getStorage];
                if(storage) {
                    //上传文件失败回调
                    FrontiaStorageFailureCallback failureCallback = ^(int errorCode, NSString *errorMessage){
                        NSString *message = [[NSString alloc] initWithFormat:@"storage upload file failed with error code:%d and message: %@", errorCode, errorMessage];
                        
                        [self performSelectorOnMainThread:@selector(updateBCSDisplayMessage:) withObject:message waitUntilDone:NO];
                    };
                    //上传文件状态监听回调
                    FrontiaStorageProgressCallback statusListener = ^(NSString *file, long bytes, long total){
                        NSString *message = [[NSString alloc] initWithFormat:@"storage upload progress  file: %@  total: %ld  sent: %ld", file, total, bytes];
                        
                        [self performSelectorOnMainThread:@selector(updateBCSDisplayMessage:) withObject:message waitUntilDone:NO];
                    };
                    //上传文件成功回调
                    FrontiaStorageFileUploadCallback simpleCallback = ^(FrontiaFile* file){
                        NSString *message = [[NSString alloc] initWithFormat:@"storage upload file on server with name %@", file.fileName];
                        
                        [self performSelectorOnMainThread:@selector(updateBCSDisplayMessage:) withObject:message waitUntilDone:NO];

                    };
                    
                    FrontiaFile *file = [[FrontiaFile alloc] init];
                    file.fileName = @"test.jpg";
                    file.content = data;
                    
                    FrontiaAccount *result = [Frontia currentAccount];
                    FrontiaACL *acl = [[FrontiaACL alloc] init];
//                    [acl setPublicReadable:YES];
//                    [acl setPublicWritable:YES];
                    [acl setAccountReadable:result canRead:YES];
                    [acl setAccountWritable:result canWrite:NO];
                    BOOL flag = [acl isAccountReadable:result];
                    
                    file.acl = acl;

                    [storage uploadFile:file statusListener:statusListener resultListener:simpleCallback failureListener:failureCallback];
                }
            } else if(messageFrom == CMDMessageFromBSS) {
                
            }
        }
    }
}

- (IBAction)onMetaClicked:(id)sender {
    FrontiaPersonalStorage* pcsClient = [Frontia getPersonalStorage];
    
    if(pcsClient) {
        [pcsClient metaWithPath:@"/apps/FrontiaDevDemo/uploadpcs.jpg" resultListener:^(NSString *file, FrontiaPersonalFileInfo *result) {
            NSString *message = [[NSString alloc] initWithFormat:@"personal storage get meta info file:%@ with meta info path=%@ size=%d isdir=%@ hasSubfolder=%@ blockList=%@", file, result.path, result.size, result.isDir?@"YES":@"NO", result.hasSubFolder?@"YES":@"NO", result.blockList];
            [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
        } failureListener:^(int errorCode, NSString *errorMessage) {
            NSString *message = [[NSString alloc] initWithFormat:@"personal storage get meta failed with error code %d and error message %@", errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
        }];
    }

}

- (IBAction)onMoveFileClicked:(id)sender {
    FrontiaPersonalStorage* pcsClient = [Frontia getPersonalStorage];

    NSString* file = @"/apps/FrontiaDevDemo/uploadpcs.jpg";
    NSString* movedFile = @"/apps/FrontiaDevDemo/moveduploadpcs.jpg";
    
    FrontiaPersonalFileFromToInfo *info = [[FrontiaPersonalFileFromToInfo alloc] init];
    info.to = file;
    info.from = movedFile;
    
    NSArray *array = [[NSArray alloc] initWithObjects:info, nil];
    
    if(pcsClient) {
        [pcsClient moveFileWithList:array resultListener:^(NSArray *list) {
            
            NSString *message = @"personal storage move file result:";

            for(FrontiaPersonalFileFromToInfo *info in list) {
                message = [message stringByAppendingString:@"move file from:"];
                message = [message stringByAppendingString:info.from];
                message = [message stringByAppendingString:@"   to:"];
                message = [message stringByAppendingString:info.to];
            }
            
            [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
        } failureListener:^(int errorCode, NSString *errorMessage) {
            NSString *message = [[NSString alloc] initWithFormat:@"personal storage move file failed with error code %d and error message %@", errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
        }];
    }
}

- (IBAction)onCopyFileClicked:(id)sender {
    FrontiaPersonalStorage* pcsClient = [Frontia getPersonalStorage];
    
    NSString* file = @"/apps/FrontiaDevDemo/uploadpcs.jpg";
    NSString* copyedFile = @"/apps/FrontiaDevDemo/uploadpcs_copyed.jpg";
    
    FrontiaPersonalFileFromToInfo *info = [[FrontiaPersonalFileFromToInfo alloc] init];
    info.from = file;
    info.to = copyedFile;
    
    NSArray *array = [[NSArray alloc] initWithObjects:info, nil];
    
    if(pcsClient) {
        [pcsClient copyFileWithList:array resultListener:^(NSArray *list) {
            
            NSString *message = @"personal storage copy file result:";
            
            for(FrontiaPersonalFileFromToInfo *info in list) {
                message = [message stringByAppendingString:@"copy file from:"];
                message = [message stringByAppendingString:info.from];
                message = [message stringByAppendingString:@"   to:"];
                message = [message stringByAppendingString:info.to];
            }
            
            [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
        } failureListener:^(int errorCode, NSString *errorMessage) {
            NSString *message = [[NSString alloc] initWithFormat:@"personal storage copy file failed with error code %d and error message %@", errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
        }];
    }

}


- (IBAction)onDiffClicked:(id)sender {
    FrontiaPersonalStorage* pcsClient = [Frontia getPersonalStorage];
    
    FrontiaPersonalDiffCallback resultCallback = ^(FrontiaPersonalDiffResponse *result) {
        
        NSString *fileName = [[NSString alloc] initWithFormat:@"diff request hasMore:%@, isReset:%@, with file detail:", result.hasMore?@"YES":@"NO", result.isReseted?@"YES":@"NO"];
        for (FrontiaPersonalDifferEntryInfo *info in  result.entries) {
            fileName = [fileName stringByAppendingString:@"file Name:"];
            fileName = [fileName stringByAppendingString:info.commonFileInfo.path];
            fileName = [fileName stringByAppendingString:@", isDir:"];
            fileName = [fileName stringByAppendingString:info.commonFileInfo.isDir?@"YES":@"NO"];
            fileName = [fileName stringByAppendingString:@"\r\n"];
        }
        
        cursor = result.cursor;
        
        NSString *message = [[NSString alloc] initWithFormat:@"personal storage diff result cursor:%@ files%@", result.cursor, fileName];
        [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
    };

    FrontiaPersonalFailureCallback failure = ^(int errorCode, NSString *errorMessage) {
        NSString *message = [[NSString alloc] initWithFormat:@"personal storage diff request error code %d and error message %@", errorCode, errorMessage];
        [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
    };
    
    if(pcsClient) {
        if(cursor == nil) {
            [pcsClient diff:resultCallback failureListener:failure];
        } else {
            [pcsClient diff:cursor resultListener:resultCallback failureListener:failure];
        }
    }
}

- (IBAction)onStreamingUrlClicked:(id)sender {
    FrontiaPersonalStorage* pcsClient = [Frontia getPersonalStorage];
    
    FrontiaPersonalFailureCallback failure = ^(int errorCode, NSString *errorMessage) {
        NSString *message = [[NSString alloc] initWithFormat:@"personal storage stream url request error code %d and error message %@", errorCode, errorMessage];
        [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
    };
    
    FrontiaPersonalStreamingUrlCallback result = ^(NSString *url) {
        NSString *message = [[NSString alloc] initWithFormat:@"personal storage get streaming Url request response %@", url];
        NSLog(@"%@", url);
        [self performSelectorOnMainThread:@selector(updatePCSDisplayMessage:) withObject:message waitUntilDone:NO];
    };
     
    if(pcsClient) {
        [pcsClient streamingUrlWithPath:@"/apps/FrontiaDevDemo/我的视频.mp4" mediaType:@"M3U8_480_224" resultListener:result failureListener:failure];
    }
}

- (IBAction)onAddCloudDownloadClicked:(id)sender {
    FrontiaPersonalStorage* pcsClient = [Frontia getPersonalStorage];
    
    FrontiaPersonalFailureCallback failure = ^(int errorCode, NSString *errorMessage) {
        NSString *message = [[NSString alloc] initWithFormat:@"personal storage add cloud download task fail with error code %d and error message %@", errorCode, errorMessage];
        [self performSelectorOnMainThread:@selector(updateCloudDownladDisplayMessage:) withObject:message waitUntilDone:NO];
    };
    
    FrontiaPersonalAddCloudDownloadCallback result = ^(NSString *taskId) {
        NSString *message = [[NSString alloc] initWithFormat:@"personal storage add cloud download task success with id:%@", taskId];
        [self performSelectorOnMainThread:@selector(updateCloudDownladDisplayMessage:) withObject:message waitUntilDone:NO];
    };

    NSString *url = @"http://10.237.1.250:8080/test.zip";
    NSString *targetPath = @"/apps/FrontiaDevDemo";
    if(pcsClient) {
        [pcsClient addCloudDownloadWithUrl:url targetPath:targetPath resultListener:result failureListener:failure];
    }
}

- (IBAction)onCloudDownloadListClicked:(id)sender {
    FrontiaPersonalStorage* pcsClient = [Frontia getPersonalStorage];
    
    FrontiaPersonalFailureCallback failure = ^(int errorCode, NSString *errorMessage) {
        NSString *message = [[NSString alloc] initWithFormat:@"personal storage list cloud download task fail with error code %d and error message %@", errorCode, errorMessage];
        [self performSelectorOnMainThread:@selector(updateCloudDownladDisplayMessage:) withObject:message waitUntilDone:NO];
    };
    
    FrontiaPersonalCloudDownloadListCallback result = ^(FrontiaPersonalCloudDownloadTaskResponse *task) {
        NSString *message = @"personal storage list cloud download task success";
        
        for (FrontiaPersonalCloudDownloadTaskInfo *info in  task.taskList) {
            message = [message stringByAppendingString:@"task id:"];
            message = [message stringByAppendingString:info.taskId];
            message = [message stringByAppendingString:@", source url:"];
            message = [message stringByAppendingString:info.sourceUrl];
            message = [message stringByAppendingString:@", target path:"];
            message = [message stringByAppendingString:info.targetPath];
            message = [message stringByAppendingString:@", task status:"];
            message = [message stringByAppendingString:[[NSString alloc] initWithFormat:@"%d", info.status]];
            message = [message stringByAppendingString:@", task result:"];
            message = [message stringByAppendingString:[[NSString alloc] initWithFormat:@"%d", info.result]];
            message = [message stringByAppendingString:@"\r\n"];
        }

        [self performSelectorOnMainThread:@selector(updateCloudDownladDisplayMessage:) withObject:message waitUntilDone:NO];
    };
    
    if(pcsClient) {
        [pcsClient cloudDownloadTaskList:0 limit:100 asc:CloudDownloadOrder_ASC needTaskInfo:TRUE status:Cloud_Download_Status_Undefine resultListener:result failureListener:failure];
    }
    
}

- (IBAction)onQueryCloudDownloadClicked:(id)sender {
    NSString *taskId1 = @"20362131";
    NSString *taskId2 = @"20362015";
    NSString *taskId3 = @"20359433";
    NSString *taskId4 = @"11111111";
    NSString *taskId5 = @"123456789";

    NSArray *taskArray = [[NSArray alloc] initWithObjects:taskId1, taskId2, taskId3, taskId4, taskId5, nil];
    FrontiaPersonalStorage* pcsClient = [Frontia getPersonalStorage];
    
    FrontiaPersonalFailureCallback failure = ^(int errorCode, NSString *errorMessage) {
        NSString *message = [[NSString alloc] initWithFormat:@"personal storage query cloud download task fail with error code %d and error message %@", errorCode, errorMessage];
        [self performSelectorOnMainThread:@selector(updateCloudDownladDisplayMessage:) withObject:message waitUntilDone:NO];
    };
    
    FrontiaPersonalCloudDownloadListCallback result = ^(FrontiaPersonalCloudDownloadTaskResponse* task) {
        NSString *message = @"personal storage list cloud download task success";
        
        for (FrontiaPersonalCloudDownloadTaskInfo *info in  task.taskList) {
            message = [message stringByAppendingString:@"task id:"];
            message = [message stringByAppendingString:info.taskId];
            message = [message stringByAppendingString:[[NSString alloc]initWithFormat:@", source url:%@", info.sourceUrl]];
            message = [message stringByAppendingString:[[NSString alloc]initWithFormat:@", target path:%@", info.targetPath]];
            message = [message stringByAppendingString:[[NSString alloc]initWithFormat:@", task status:%d", info.status]];
            message = [message stringByAppendingString:[[NSString alloc]initWithFormat:@", task result:%d", info.result]];
            message = [message stringByAppendingString:@"\r\n"];
        }
        
        [self performSelectorOnMainThread:@selector(updateCloudDownladDisplayMessage:) withObject:message waitUntilDone:NO];
    };
    
    if(pcsClient) {
        [pcsClient queryCloudDownloadTaskWithIds:taskArray resultListener:result failureListener:failure];
    }

}

- (IBAction)onCancelCloudDownloadClicked:(id)sender {
    NSString *taskId = @"20359433";
    FrontiaPersonalStorage* pcsClient = [Frontia getPersonalStorage];
    
    FrontiaPersonalFailureCallback failure = ^(int errorCode, NSString *errorMessage) {
        NSString *message = [[NSString alloc] initWithFormat:@"personal storage cancel cloud download task fail with error code %d and error message %@", errorCode, errorMessage];
        [self performSelectorOnMainThread:@selector(updateCloudDownladDisplayMessage:) withObject:message waitUntilDone:NO];
    };
    
    FrontiaPersonalAddCloudDownloadCallback result = ^(NSString *taskId) {
        NSString *message = [[NSString alloc] initWithFormat:@"personal storage cancel cloud download task success with id:%@", taskId];
        [self performSelectorOnMainThread:@selector(updateCloudDownladDisplayMessage:) withObject:message waitUntilDone:NO];
    };
    
    if(pcsClient) {
        [pcsClient cancelCloudDownloadTaskWithId:taskId resultListener:result failureListener:failure];
    }

}

- (IBAction)onListRecycleClicked:(id)sender {
    FrontiaPersonalStorage* pcsClient = [Frontia getPersonalStorage];
    
    FrontiaPersonalRecycleListCallback result = ^(FrontiaPersonalListRecycleResponse *result) {
        
        NSString* resultStr = [[NSString alloc] initWithFormat:@"personal storage list recycle result:"];
        for (FrontiaPersonalFileInfo *file in result.fileList) {
            resultStr = [resultStr stringByAppendingString:@"file path:"];
            resultStr = [resultStr stringByAppendingString:file.path];
            resultStr = [resultStr stringByAppendingString:@", blocklist:"];
            resultStr = [resultStr stringByAppendingString:file.blockList];
            resultStr = [resultStr stringByAppendingString:@", fsId:"];
            resultStr = [resultStr stringByAppendingString:file.fs_id];
            resultStr = [resultStr stringByAppendingString:@"\r\n"];
        }
        
        [self performSelectorOnMainThread:@selector(updateRecycleDisplayMessage:) withObject:resultStr waitUntilDone:NO];
    };
    
    FrontiaPersonalFailureCallback failure = ^(int errorCode, NSString *errorMessage) {
        NSString *message = [[NSString alloc] initWithFormat:@"personal storage list recycle fail with error code %d and error message %@", errorCode, errorMessage];
        [self performSelectorOnMainThread:@selector(updateRecycleDisplayMessage:) withObject:message waitUntilDone:NO];
    };
    
    if(pcsClient) {
        [pcsClient listRecycle:result failureListener:failure];
    }
}

- (IBAction)onRestoreRecycleClicked:(id)sender {
    NSString *recycleFileId = @"1297328659";
    NSString *recycleFileId1 = @"0000000000";
    
    NSArray *array = [[NSArray alloc] initWithObjects:recycleFileId, recycleFileId1, nil];
    
    FrontiaPersonalStorage* pcsClient = [Frontia getPersonalStorage];

    FrontiaPersonalRecycleRestoreFailureCallback failure = ^(int errorCode, NSString *errorMessage, NSArray *array) {
        NSString *message = [[NSString alloc] initWithFormat:@"personal storage restore recycle fail with error code %d and error message %@", errorCode, errorMessage];
        if(array.count > 0) {
            message = [message stringByAppendingString:@"restore success files id:"];

            for (NSString *successFile in array) {
                message = [message stringByAppendingString:successFile];
                message = [message stringByAppendingString:@"\r\n"];
            }
        }
        [self performSelectorOnMainThread:@selector(updateRecycleDisplayMessage:) withObject:message waitUntilDone:NO];
    };

    FrontiaPersonalRecycleRestoreCallback result = ^(FrontiaPersonalRestoreRecycleResponse *result) {
        NSString* resultStr = [[NSString alloc] initWithFormat:@"personal storage restore recycle result:"];
        for (NSString *fileId in result.fileIds) {
            resultStr = [resultStr stringByAppendingString:@"file id:"];
            resultStr = [resultStr stringByAppendingString:fileId];
            resultStr = [resultStr stringByAppendingString:@"\r\n"];
        }
        
        [self performSelectorOnMainThread:@selector(updateRecycleDisplayMessage:) withObject:resultStr waitUntilDone:NO];
    };
    
    if(pcsClient) {
        [pcsClient restoreRecycleWithFileIds:array resultListener:result failureListener:failure];
    }

}

- (IBAction)onCleanRecycleClicked:(id)sender {
    FrontiaPersonalStorage* pcsClient = [Frontia getPersonalStorage];
    
    FrontiaPersonalFailureCallback failure = ^(int errorCode, NSString *errorMessage) {
        NSString *message = [[NSString alloc] initWithFormat:@"personal storage restore recycle fail with error code %d and error message %@", errorCode, errorMessage];
        [self performSelectorOnMainThread:@selector(updateRecycleDisplayMessage:) withObject:message waitUntilDone:NO];
    };
    
    FrontiaPersonalRecycleCleanCallback result = ^() {
        NSString* resultStr = @"personal storage clean recycle success";
        
        [self performSelectorOnMainThread:@selector(updateRecycleDisplayMessage:) withObject:resultStr waitUntilDone:NO];
    };
    
    if(pcsClient) {
        [pcsClient cleanRecycle:result failureListener:failure];
    }

}

- (IBAction)onBSSUploadClicked:(id)sender {

    FrontiaStorage *storage = [Frontia getStorage];
    if(storage) {
        
        FrontiaAccount *result = [Frontia currentAccount];
        [Frontia setCurrentAccount:result];        
        FrontiaData *data = [[FrontiaData alloc] init];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:@"100" forKey:@"jake"];
        [dic setValue:@"222" forKey:@"name"];
        
        [data setData:dic];
        
        FrontiaACL *acl = [[FrontiaACL alloc] init];
        //[acl setPublicReadable:NO];
        //[acl setPublicWritable:YES];
        [acl setAccountReadable:result canRead:YES];
        [acl setAccountWritable:result canWrite:NO];
        
        data.acl = acl;
        
        FrontiaStorage *storage = [Frontia getStorage];
        
        
        FrontiaDataInsertCallback insertCallback = ^(FrontiaData *result)
        {
            NSString *message = [[NSString alloc] initWithFormat:@"storage insert data call back response:%@", [result.data description]];
            [self performSelectorOnMainThread:@selector(updateBSSDisplayMessage:) withObject:message waitUntilDone:NO];
        };
        
        FrontiaStorageFailureCallback fCallback = ^(int errorCode, NSString* errorMessage)
        {
            NSString *message = [[NSString alloc] initWithFormat:@"storage insert data call back error code %d response: %@", errorCode, errorMessage];
            NSLog(@"%@", message);
        
            [self performSelectorOnMainThread:@selector(updateBSSDisplayMessage:) withObject:message waitUntilDone:NO];
        };
        
        [storage insertData:data resultListener:insertCallback failureListener:fCallback];
    }
    
}

- (IBAction)onBSSDeleteClicked:(id)sender {
    FrontiaStorage *storage = [Frontia getStorage];
    
    if(storage) {
        //删除数据成功的回调
        FrontiaDataModifyCallback result = ^(int modifyNumber) {
            NSString *message = [[NSString alloc] initWithFormat:@"storage delete data call back response:%i", modifyNumber];
            NSLog(@"%@", message);
            [self performSelectorOnMainThread:@selector(updateBSSDisplayMessage:) withObject:message waitUntilDone:NO];
        };
        
        //删除数据失败的回调
        FrontiaStorageFailureCallback fail = ^(int errorCode, NSString *errorMessage) {
            
            NSString *message = [[NSString alloc] initWithFormat:@"storage delete data call back response: %d with message:%@", errorCode, errorMessage];
            NSLog(@"%@", message);
            [self performSelectorOnMainThread:@selector(updateBSSDisplayMessage:) withObject:message waitUntilDone:NO];

        };
        
        //查询条件
        FrontiaQuery* query = [[FrontiaQuery alloc] init];
        [query equals:@"name" value:@"222"];
        
        [storage deleteData:query resultListener:result failureListener:fail];
    }
}

- (IBAction)onBCSDeletClicked:(id)sender {
    FrontiaStorage *storage = [Frontia getStorage];
    
    if(storage) {
        //删除文件失败回调
        FrontiaStorageFailureCallback failureCallback = ^(int errorCode, NSString* errorMessage){
            NSString *message = [[NSString alloc] initWithFormat:@"storage delete with error code: %d and message: %@", errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updateBCSDisplayMessage:) withObject:message waitUntilDone:NO];
            
        };
        
        //删除文件成功回调
        FrontiaStorageFileOperationCallBack resultCallback = ^(NSString *fileName){
            NSString *message = [[NSString alloc] initWithFormat:@"storage delete file with name: %@" , fileName];
            [self performSelectorOnMainThread:@selector(updateBCSDisplayMessage:) withObject:message waitUntilDone:NO];
            
        };
        
        FrontiaFile *file = [[FrontiaFile alloc] init];
        file.fileName = @"test.jpg";
        
        [storage deleteFile:file resultListener:resultCallback failureListener:failureCallback];
    }
    
}

- (IBAction)onListUserClicked:(id)sender {
    //新建查询条件
    FrontiaUserQuery *query = [[FrontiaUserQuery alloc] init];
    [query equalsSex:SEX_TYPE_MALE];
    //[query equalsUserId:@"3406100674"];
    
    //执行查询操作
    [FrontiaUser findUser:query resultListener:^(NSArray *result) {
        NSString* resultStr = [[NSString alloc] initWithFormat:@"user list info:"];
        FrontiaUser* filePointer = nil;
        for(int i=0; i< result.count; i++) {
            filePointer = (FrontiaUser*) result[i];
            resultStr = [resultStr stringByAppendingString:@" accout name:"];
            resultStr = [resultStr stringByAppendingString:filePointer.accountName];
            resultStr = [resultStr stringByAppendingString:@" account Id:"];
            resultStr = [resultStr stringByAppendingString:filePointer.accountId];
            resultStr = [resultStr stringByAppendingString:@"\r\n"];
        }
        [self performSelectorOnMainThread:@selector(updateUserDisplayMessage:) withObject:resultStr waitUntilDone:NO];

    } failureListener:^(int errorCode, NSString *errorMessage) {
        NSString *message = [[NSString alloc] initWithFormat:@"user list error response: %d and message:%@", errorCode, errorMessage];
        NSLog(@"%@", message);
        [self performSelectorOnMainThread:@selector(updateUserDisplayMessage:) withObject:message waitUntilDone:NO];
    }];
}

- (IBAction)onAddRoleClicked:(id)sender {
    //新建role对象
    FrontiaRole *role = [[FrontiaRole alloc] init];
    role.accountName = @"userA";
    //NSLog(@"set account name %@", role.accountName);
    
    FrontiaUser *result = (FrontiaUser*)[Frontia currentAccount];
    
    FrontiaACL *acl = [[FrontiaACL alloc] init];
    [acl setPublicReadable:NO];
    [acl setPublicWritable:YES];
    [acl setAccountReadable:result canRead:YES];
    [acl setAccountWritable:result canWrite:YES];
    //配置ACL信息
    role.acl = acl;

    [role create:^(NSString *roleId) {
        NSString *message = [[NSString alloc] initWithFormat:@"add role success with id:%@", roleId];
        NSLog(@"%@", message);
        [self performSelectorOnMainThread:@selector(updateUserDisplayMessage:) withObject:message waitUntilDone:NO];
    } failureListener:^(int errorCode, NSString *errorMessage) {
        NSString *message = [[NSString alloc] initWithFormat:@"add role fail with error: %d and message:%@", errorCode, errorMessage];
        NSLog(@"%@", message);
        [self performSelectorOnMainThread:@selector(updateUserDisplayMessage:) withObject:message waitUntilDone:NO];
    }];
}

- (IBAction)onDeleteRoleClicked:(id)sender {
    //创建role对象
    FrontiaRole *role = [[FrontiaRole alloc] init];
    role.accountId = @"userA";
    
    //执行删除操作
    [role delete:^(NSString *roleId) {
        NSString *message = [[NSString alloc] initWithFormat:@"delete role success with id:%@", roleId];
        NSLog(@"%@", message);
        [self performSelectorOnMainThread:@selector(updateUserDisplayMessage:) withObject:message waitUntilDone:NO];
    } failureListener:^(int errorCode, NSString *errorMessage) {
        NSString *message = [[NSString alloc] initWithFormat:@"delete role error response: %d and message:%@", errorCode, errorMessage];
        NSLog(@"%@", message);
        [self performSelectorOnMainThread:@selector(updateUserDisplayMessage:) withObject:message waitUntilDone:NO];
    }];

}

- (IBAction)onFetchRoleClicked:(id)sender {
    //创建组对象
    FrontiaRole *role = [[FrontiaRole alloc] init];
    role.accountName = @"userA";
    
    //执行获取组内容操作
    [role describe:^(FrontiaFetchRoleResponse *response) {
        NSString *message = [[NSString alloc] initWithFormat:@"fetch role success with id:%@", response.role.accountName];
        for (NSString *str in response.role.getMembers) {
            NSLog(@"get child %@", str);
        }
        NSLog([[response.role.acl toJSONObject] description]);
        NSLog(@"%@", message);
        [self performSelectorOnMainThread:@selector(updateUserDisplayMessage:) withObject:message waitUntilDone:NO];
    } failureListener:^(int errorCode, NSString *errorMessage) {
        NSString *message = [[NSString alloc] initWithFormat:@"fetch role error response: %d and message:%@", errorCode, errorMessage];
        NSLog(@"%@", message);
        [self performSelectorOnMainThread:@selector(updateUserDisplayMessage:) withObject:message waitUntilDone:NO];
    }];
}

- (IBAction)onModifyRoleClicked:(id)sender {

    //创建组对象,为其添加新的成员对象
    FrontiaRole *role = [[FrontiaRole alloc] init];
    role.accountId = @"userA";
    [role addRole:@"userB"];
    
    FrontiaUser *result = (FrontiaUser*)[Frontia currentAccount];
    
    FrontiaACL *acl = [[FrontiaACL alloc] init];
    [acl setPublicReadable:YES];
    [acl setPublicWritable:NO];
    [acl setAccountReadable:result canRead:YES];
    [acl setAccountWritable:result canWrite:YES];
    //配置ACL信息
    role.acl = acl;

    [role addUserId:[[Frontia currentAccount] accountId]];
    
    //执行修改操作
    [role update:^() {
        NSString *message = [[NSString alloc] initWithFormat:@"modify role success with id:%@", role.accountId];
        NSLog(@"%@", message);
        [self performSelectorOnMainThread:@selector(updateUserDisplayMessage:) withObject:message waitUntilDone:NO];
    } failureListener:^(int errorCode, NSString *errorMessage) {
        NSString *message = [[NSString alloc] initWithFormat:@"modify role error response: %d and message:%@", errorCode, errorMessage];
        NSLog(@"%@", message);
        [self performSelectorOnMainThread:@selector(updateUserDisplayMessage:) withObject:message waitUntilDone:NO];
    }];

}

- (IBAction)onBSSUpdateClicked:(id)sender {
    FrontiaStorage *storage = [Frontia getStorage];
    
    if(storage) {
        //修改数据成功的回调
        FrontiaDataModifyCallback result = ^(int modifyNumber) {
            NSString *message = [[NSString alloc] initWithFormat:@"storage update data call back response:%i", modifyNumber];
            NSLog(@"%@", message);
            [self performSelectorOnMainThread:@selector(updateBSSDisplayMessage:) withObject:message waitUntilDone:NO];
        };
        
        //修改数据失败后的回调
        FrontiaStorageFailureCallback fail = ^(int errorCode, NSString *errorMessage) {
            NSString *message = [[NSString alloc] initWithFormat:@"storage update data fail with error:%d and message:%@", errorCode, errorMessage];
            NSLog(@"%@", message);
            [self performSelectorOnMainThread:@selector(updateBSSDisplayMessage:) withObject:message waitUntilDone:NO];
        };
        FrontiaQuery* query = [[FrontiaQuery alloc] init];
        //[query equals:@"name" value:@"wanggang"];
        [query equals:@"name" value:@"222"];
        
        NSMutableDictionary *newData = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"lisi", @"name", nil];

        FrontiaAccount *account = [Frontia currentAccount];
        FrontiaData *data = [[FrontiaData alloc]init];
        data.data = newData;
        
        FrontiaACL *acl = [[FrontiaACL alloc] init];
        [acl setPublicReadable:NO];
        [acl setPublicWritable:YES];
        [acl setAccountReadable:account canRead:YES];
        [acl setAccountWritable:account canWrite:NO];
        
        data.acl = acl;

        
        [storage updateData:query newData:data resultListener:result failureListener:fail];
    }

}

- (IBAction)onBSSQueryClicked:(id)sender {
    FrontiaStorage *storage = [Frontia getStorage];
    
    if(storage) {
        //数据查询成功回调
        FrontiaDataQueryCallback result = ^(NSArray *response) {
            NSString *json =[[NSString alloc] init];
            for (FrontiaData *data in response) {
                json = [json stringByAppendingString:[[NSString alloc] initWithData:[data.data JSONData] encoding:NSUTF8StringEncoding]];
            }
            
            NSString *message = [[NSString alloc] initWithFormat:@"storage query data call back response:%@", json];
            NSLog(@"%@", message);
            [self performSelectorOnMainThread:@selector(updateBSSDisplayMessage:) withObject:message waitUntilDone:NO];

        };
        
        //数据查询失败回调
        FrontiaStorageFailureCallback fail = ^(int errorCode, NSString *errorMessage) {
            NSString *message = [[NSString alloc] initWithFormat:@"storage query data fail with error:%d and message:%@", errorCode, errorMessage];
            NSLog(@"%@", message);
            [self performSelectorOnMainThread:@selector(updateBSSDisplayMessage:) withObject:message waitUntilDone:NO];

        };
        
        
        FrontiaQuery* query = [[FrontiaQuery alloc] init];
        //[query equals:@"name" value:@"wanggang"];
        [query equals:@"name" value:@"222"];
        [query equals:@"jake" value:@"100"];
        
        [storage findData:query resultListener:result failureListener:fail];
    }

}

- (IBAction)onBCSUploadClicked:(id)sender {
    messageFrom = CMDMessageFromBCS;
    [self pickImage];
}

- (IBAction)onBCSDownloadClicked:(id)sender {
    FrontiaStorage *storage = [Frontia getStorage];
    
    if(storage) {
        //下载失败回调
        FrontiaStorageFailureCallback failureCallback = ^(int errorCode, NSString* errorMessage){
            NSString *message = [[NSString alloc] initWithFormat:@"storage download file with error code: %d error message: %@", errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updateBCSDisplayMessage:) withObject:message waitUntilDone:NO];
            
        };
        
        //下载成功回调
        FrontiaStorageDownloadCallback resultCallback = ^(FrontiaFile *file){
            NSString *message = [[NSString alloc] initWithFormat:@"storage download file with name: %@ and length: %d" , file.fileName, file.content.length];
            [self performSelectorOnMainThread:@selector(updateBCSDisplayMessage:) withObject:message waitUntilDone:NO];
            UIImage *aimage = [UIImage imageWithData: file.content];
            UIImageWriteToSavedPhotosAlbum(aimage, nil, nil, nil);
            
        };
        
        //下载状态监控回调
        FrontiaStorageProgressCallback statusCallback = ^(NSString* file, long bytes, long total){
            NSString *message = [[NSString alloc] initWithFormat:@"storage download file length: %ld with total length: %ld", bytes, total];
            [self performSelectorOnMainThread:@selector(updateBCSDisplayMessage:) withObject:message waitUntilDone:NO];
            
        };
        FrontiaFile *file = [[FrontiaFile alloc] init];
        file.fileName = @"test.jpg";
        
        [storage downloadFile:file statusListener:statusCallback resultListener:resultCallback failureListener:failureCallback];
    }
}

- (IBAction)onBCSListClicked:(id)sender {
    FrontiaStorage *storage = [Frontia getStorage];
    
    if(storage) {
        //list文件列表失败回调
        FrontiaStorageFailureCallback failureCallback = ^(int errorCode, NSString* errorMessage){
            NSString *message = [[NSString alloc] initWithFormat:@"storage list request result with error code: %d and message: %@", errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updateBCSDisplayMessage:) withObject:message waitUntilDone:NO];
            
        };
        //list文件列表成功回调
        FrontiaFileListCallback listResult = ^(NSArray *result) {
            NSString* resultStr = [[NSString alloc] initWithFormat:@"storage list info:"];
            FrontiaFile* filePointer = nil;
            for(int i=0; i< result.count; i++) {
                filePointer = (FrontiaFile*) result[i];
                resultStr = [resultStr stringByAppendingString:filePointer.fileName];
                resultStr = [resultStr stringByAppendingString:@" \r\n"];
            }
            [self performSelectorOnMainThread:@selector(updateBCSDisplayMessage:) withObject:resultStr waitUntilDone:NO];

        };
        
        [storage listFileWithResultListener:listResult failureListener:failureCallback];
    }
    
}

- (IBAction)onBindClick:(id)sender {
    FrontiaPush *push = [Frontia getPush];
    
    if(push) {
        [push bindChannel:^(NSString *appId, NSString *userId, NSString *channelId) {
            NSString *message = [[NSString alloc] initWithFormat:@"appid:%@ \nuserid:%@ \nchannelID:%@", appId, userId, channelId];
            
            self.appidText.text = appId;
            self.useridText.text = userId;
            self.channelidText.text = channelId;

            [self performSelectorOnMainThread:@selector(updateBindDisplayMessage:) withObject:message waitUntilDone:NO];

        } failureResult:^(NSString *action, int errorCode, NSString *errorMessage) {
            
            NSString *message = [[NSString alloc] initWithFormat:@"string is %@ error code : %d error message %@", action, errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updateBindDisplayMessage:) withObject:message waitUntilDone:NO];
        }];
    }
}

- (IBAction)onDeleteTagClicked:(id)sender {
    FrontiaPush *push = [Frontia getPush];
    
    if(push) {
        NSString *tags = tagsText.text;
        if (![@"" isEqualToString:tags]) {
            NSArray *tagArr = [tags componentsSeparatedByString:@";"];
            
            [push delTags:tagArr tagOpResult:^(int count, NSArray *failureTag) {
                NSString *message = [[NSString alloc] initWithFormat:@"delete tags success result: %d with failure tags %@", count, failureTag];
                [self performSelectorOnMainThread:@selector(updateBindDisplayMessage:) withObject:message waitUntilDone:NO];
                
            } failureResult:^(NSString *action, int errorCode, NSString *errorMessage) {
                NSString *message = [[NSString alloc] initWithFormat:@"delete tags failed with %@ error code : %d error message %@", action, errorCode, errorMessage];
                [self performSelectorOnMainThread:@selector(updateBindDisplayMessage:) withObject:message waitUntilDone:NO];
                
            }];
        }
        
    }
    

}


- (IBAction)onSendMessageClicked:(id)sender {
    FrontiaPush *push = [Frontia getPush];
    
    if(push) {
        
        FrontiaPushMessageContent *content = [[FrontiaPushMessageContent alloc] init];
        content.title = @"this is a title";
        content.description = @"come from mobile";
        
        FrontiaPushMessage *message = [[FrontiaPushMessage alloc] init];
        message.deployStatus = FrontiaPushMessageDeployType_DEV;
        message.msgKeys = @"just_a_test";
        message.messageContent = content;
        [message setNotification:content];
        
        FrontiaTimeTrigger *trigger = [[FrontiaTimeTrigger alloc] init];
        
//        NSString* timeStr = @"2013-07-19 15:44";
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateStyle:NSDateFormatterMediumStyle];
//        [formatter setTimeStyle:NSDateFormatterNoStyle];
//        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//        NSTimeZone* timeZone = [NSTimeZone localTimeZone /*timeZoneWithName:@"Asia/Beijing"*/];
//        [formatter setTimeZone:timeZone];
//        trigger.triggerDate = [formatter dateFromString:timeStr];


        
        [push pushMessage:message trigger:trigger sendMessageResult:^(NSString* pushId) {
            NSString *message = [[NSString alloc] initWithFormat:@"push message success result: %@", pushId];
            [self performSelectorOnMainThread:@selector(updateBindDisplayMessage:) withObject:message waitUntilDone:NO];
            
        } failureResult:^(NSString *action, int errorCode, NSString *errorMessage) {
            NSString *message = [[NSString alloc] initWithFormat:@"push message failed with %@ error code : %d error message %@", action, errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updateBindDisplayMessage:) withObject:message waitUntilDone:NO];
            
        }];
    }
}

- (IBAction)onSetTagClicked:(id)sender {
    FrontiaPush *push = [Frontia getPush];

    if(push) {

        NSString *tags = tagsText.text;
        if (![@"" isEqualToString:tags]) {
            NSArray *tagArr = [tags componentsSeparatedByString:@";"];

            [push setTags:tagArr tagOpResult:^(int count, NSArray *failureTag) {
                NSString *message = [[NSString alloc] initWithFormat:@"set tag success result: %d with failure tags %@", count, failureTag];
                [self performSelectorOnMainThread:@selector(updateBindDisplayMessage:) withObject:message waitUntilDone:NO];
                
            } failureResult:^(NSString *action, int errorCode, NSString *errorMessage) {
                NSString *message = [[NSString alloc] initWithFormat:@"set tag failed with %@ error code : %d error message %@", action, errorCode, errorMessage];
                [self performSelectorOnMainThread:@selector(updateBindDisplayMessage:) withObject:message waitUntilDone:NO];

            }];
        }

    }
}

- (IBAction)onCrontabMessageCreateClicked:(id)sender
{
    FrontiaPush *push = [Frontia getPush];

    if(push) {        
        //创建发送对象
        FrontiaPushMessageContent *content = [[FrontiaPushMessageContent alloc] init];
        content.title = @"get up earlier";
        content.description = @"come from iOS mobile";
        
        FrontiaPushMessage *message = [[FrontiaPushMessage alloc] init];
        message.deployStatus = FrontiaPushMessageDeployType_DEV;
        message.msgKeys = @"just a note";
        message.messageContent = content;
        [message setNotification:content];

        //创建消息触发器
        FrontiaTimeTrigger *trigger = [[FrontiaTimeTrigger alloc] init];
        NSString* timeStr = @"2013-08-26 15:44";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSTimeZone* timeZone = [NSTimeZone localTimeZone /*timeZoneWithName:@"Asia/Beijing"*/];
        [formatter setTimeZone:timeZone];
        //第一次触发时机
        trigger.triggerDate = [formatter dateFromString:timeStr];
        //每天早上八点定时发送
        trigger.triggerCrontab = @"0 8 * * *";
        
        //发送推送消息
        [push pushMessage:message trigger:trigger sendMessageResult:^(NSString* pushId) {
            NSString *message = [[NSString alloc] initWithFormat:@"push message success result: %@", pushId];
            [self performSelectorOnMainThread:@selector(updateCrontabDisplayMessage:) withObject:message waitUntilDone:NO];
            
        } failureResult:^(NSString *action, int errorCode, NSString *errorMessage) {
            NSString *message = [[NSString alloc] initWithFormat:@"push message failed with %@ error code : %d error message %@", action, errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updateCrontabDisplayMessage:) withObject:message waitUntilDone:NO];
            
        }];
    }

}

- (IBAction)onCrontabMessageDeleteClicked:(id)sender
{
    FrontiaPush *push = [Frontia getPush];

    if(push) {
                
        [push removeMessage:@"51ebd3e92f5d284308000001" removeMessageResult:^(NSString *pushId) {
            
            NSString *message = [[NSString alloc] initWithFormat:@"remove message result: %@", pushId];
            [self performSelectorOnMainThread:@selector(updateCrontabDisplayMessage:) withObject:message waitUntilDone:NO];
        } failureResult:^(NSString *action, int errorCode, NSString *errorMessage) {
            NSString *message = [[NSString alloc] initWithFormat:@"remove message failed with %@ error code : %d error message %@", action, errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updateCrontabDisplayMessage:) withObject:message waitUntilDone:NO];
        }];
    }

}

- (IBAction)onCrontabMessageReplaceClicked:(id)sender
{
    FrontiaPush *push = [Frontia getPush];
    
    if(push) {
        
        FrontiaPushMessageContent *content = [[FrontiaPushMessageContent alloc] init];
        content.title = @"this is a title";
        content.description = @"come from mobile";
        
        FrontiaPushMessage *message = [[FrontiaPushMessage alloc] init];
        message.deployStatus = FrontiaPushMessageDeployType_DEV;
        message.msgKeys = @"just_a_test";
        message.messageContent = content;
        [message setNotification:content];

        FrontiaTimeTrigger *trigger = [[FrontiaTimeTrigger alloc] init];
        
        NSString* timeStr = @"2013-08-24 15:44";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSTimeZone* timeZone = [NSTimeZone localTimeZone /*timeZoneWithName:@"Asia/Beijing"*/];
        [formatter setTimeZone:timeZone];
        trigger.triggerDate = [formatter dateFromString:timeStr];
        
        
        
        [push replaceMessage:@"51ebd3e92f5d284308000001" trigger:trigger pushMessage:message modifyMessageResult:^(NSString *pushId) {
            NSString *message = [[NSString alloc] initWithFormat:@"replace message result: %@", pushId];
            [self performSelectorOnMainThread:@selector(updateCrontabDisplayMessage:) withObject:message waitUntilDone:NO];
        } failureResult:^(NSString *action, int errorCode, NSString *errorMessage) {
            NSString *message = [[NSString alloc] initWithFormat:@"replace message failed with %@ error code : %d error message %@", action, errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updateCrontabDisplayMessage:) withObject:message waitUntilDone:NO];
        }];
    }

}

- (IBAction)onCrontabMessageListClicked:(id)sender
{
    FrontiaPush *push = [Frontia getPush];

    if(push) {
        FrontiaQuery * query = [[FrontiaQuery alloc] init];
        //[query equals:@"timer_id" value:@"51ebcc74ddb205e505000006"];
        
        [push listMessage:query listMessageResult:^(NSArray *pushMessages) {
            
            NSString *message = [[NSString alloc] initWithFormat:@"list message success result: %d", pushMessages.count];
            [self performSelectorOnMainThread:@selector(updateCrontabDisplayMessage:) withObject:message waitUntilDone:NO];
        } failureResult:^(NSString *action, int errorCode, NSString *errorMessage) {
            NSString *message = [[NSString alloc] initWithFormat:@"list message failed with %@ error code : %d error message %@", action, errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updateCrontabDisplayMessage:) withObject:message waitUntilDone:NO];
        }];
    }
   
}
- (IBAction)onCrontabMessageFetchClicked:(id)sender
{
    FrontiaPush *push = [Frontia getPush];
    
    if(push) {
        [push fetchMessage:@"51e7e85a101f6a9c63000015" fetchMessageResult:^(FrontiaPushTimerMessage *fetchMessage) {
            
            NSString *message = [[NSString alloc] initWithFormat:@"fetch message success result: %@", fetchMessage.messageContent.description];
            [self performSelectorOnMainThread:@selector(updateCrontabDisplayMessage:) withObject:message waitUntilDone:NO];
        } failureResult:^(NSString *action, int errorCode, NSString *errorMessage) {
            NSString *message = [[NSString alloc] initWithFormat:@"fetch message failed with %@ error code : %d error message %@", action, errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updateCrontabDisplayMessage:) withObject:message waitUntilDone:NO];
        }];
    }

}

-(IBAction)triggerEx:(id)sender
{
    NSString* a = @"";
    [(NSDictionary*)a allKeys];
}

-(IBAction)logEventWithDurationTime:(id)sender
{
    static Boolean isStart = false;
    if(isStart == false)
    {
        FrontiaStatistics* statTracker = [Frontia getStatistics];
        [statTracker eventStart:@"event2" eventLabel:@"time"];
        isStart = true;
        [(UIButton*) sender setTitle:@"event end" forState:UIControlStateNormal];
    }
    else{
        FrontiaStatistics* statTracker = [Frontia getStatistics];
        [statTracker eventEnd:@"event2" eventLabel:@"time"];
        isStart = false;
        [(UIButton*) sender setTitle:@"event start" forState:UIControlStateNormal];
    }
}

-(IBAction)logEventClick:(id)sender
{
    FrontiaStatistics* statTracker = [Frontia getStatistics];
    [statTracker logEvent:@"event1" eventLabel:@"label1"];
}

-(IBAction)logEventWithTime:(id)sender
{
    [[Frontia getStatistics] logEventWithDurationTime:@"event3" eventLabel:@"time" durationTime:43500];
}

-(IBAction)onLBSUploadButtonClicked:(id)sender {
    FrontiaLBS *lbs = [Frontia getLBS];
    
    if(lbs) {
        [lbs uploadLocation:^{
            NSString *message = [[NSString alloc] initWithFormat:@"upload location success"];
            NSLog(@"%@", message);
            [self performSelectorOnMainThread:@selector(updateLBSDisplayMessage:) withObject:message waitUntilDone:NO];
        } failureListener:^(int errorCode, NSString *errorMessage) {
            NSString *message = [[NSString alloc] initWithFormat:@"LBS upload location failed with error code : %d error message %@", errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updateLBSDisplayMessage:) withObject:message waitUntilDone:NO];
        }];
    }

}

-(IBAction)onLBSLocationButtonClicked:(id)sender {
    FrontiaLBS *lbs = [Frontia getLBS];
    
    if(lbs) {
        [lbs getCurrentLocation:^(FrontiaLocation *location) {
            NSString *message = [[NSString alloc] initWithFormat:@"get current location with country:%@ province:%@ district:%@ city:%@ street:%@ street number:%@ city code:%@", location.country, location.province, location.district, location.city, location.street, location.streetNumber, location.cityCode];
            [self performSelectorOnMainThread:@selector(updateLBSDisplayMessage:) withObject:message waitUntilDone:NO];
        } failureListener:^(int errorCode, NSString *errorMessage) {
            NSString *message = [[NSString alloc] initWithFormat:@"LBS get location failed with error code : %d error message %@", errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updateLBSDisplayMessage:) withObject:message waitUntilDone:NO];
        }];
    }

}

-(IBAction)onLBSPOIButtonClicked:(id)sender {
    FrontiaLBS *lbs = [Frontia getLBS];
    
    if(lbs) {
        [lbs getNearPOIs:^(NSArray *pois) {
            NSString *message = @"get pois info:";
            for (FrontiaPOI *poi in pois) {
                message = [message stringByAppendingString:poi.name];
                message = [message stringByAppendingString:@"\r\n"];
            }
            [self performSelectorOnMainThread:@selector(updateLBSDisplayMessage:) withObject:message waitUntilDone:NO];
        } failureListener:^(int errorCode, NSString *errorMessage) {
            NSString *message = [[NSString alloc] initWithFormat:@"LBS get location failed with error code : %d error message %@", errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updateLBSDisplayMessage:) withObject:message waitUntilDone:NO];
        }];
    }

}

-(IBAction)onLBSUserNearByButtonClicked:(id)sender {
    FrontiaLBS *lbs = [Frontia getLBS];
    
    if(lbs) {
        [lbs getNearFrontiaUsers:^(NSArray *users) {
            NSLog(@"resultStr = %d", users.count);
            NSString *resultStr = @"";
            FrontiaNearUser* userPtr = nil;
            for(int i=0; i<users.count; i++) {
                userPtr = (FrontiaNearUser*) users[i];
                resultStr = [resultStr stringByAppendingString:[[NSString alloc] initWithFormat:@"\r\nuser %d:", i]];
                resultStr = [resultStr stringByAppendingString:@"acocunt id:"];
                resultStr = [resultStr stringByAppendingString:userPtr.accountId];
                resultStr = [resultStr stringByAppendingString:@"   position lat:"];
                resultStr = [resultStr stringByAppendingString:[[NSString alloc] initWithFormat:@"%@", userPtr.point.lat]];
                resultStr = [resultStr stringByAppendingString:@"   country:"];
                resultStr = [resultStr stringByAppendingString:userPtr.location.country];
                resultStr = [resultStr stringByAppendingString:@"   province:"];
                resultStr = [resultStr stringByAppendingString:userPtr.location.province];
                resultStr = [resultStr stringByAppendingString:@"   street:"];
                resultStr = [resultStr stringByAppendingString:userPtr.location.street];
                resultStr = [resultStr stringByAppendingString:@"\r\n"];
                NSLog(@"resultStr = %@", resultStr);
            }

            
            NSString *message = [[NSString alloc] initWithFormat:@"get users: %@", resultStr];
            [self performSelectorOnMainThread:@selector(updateLBSDisplayMessage:) withObject:message waitUntilDone:NO];
        } failureListener:^(int errorCode, NSString *errorMessage) {
            NSString *message = [[NSString alloc] initWithFormat:@"LBS get location failed with error code : %d error message %@", errorCode, errorMessage];
            [self performSelectorOnMainThread:@selector(updateLBSDisplayMessage:) withObject:message waitUntilDone:NO];
        }];
    }

}
-(IBAction)onShowShareMenuButtonClicked:(id)sender {
    FrontiaShare *share = [Frontia getShare];
    
    [share registerQQAppId:@"100358052" enableSSO:NO];
    [share registerWeixinAppId:@"wx712df8473f2a1dbe"];
    
    //授权取消回调函数
    FrontiaShareCancelCallback onCancel = ^(){
        NSLog(@"OnCancel: share is cancelled");
    };
    
    //授权失败回调函数
    FrontiaShareFailureCallback onFailure = ^(int errorCode, NSString *errorMessage){
        NSLog(@"OnFailure: %d  %@", errorCode, errorMessage);
    };
    
    //授权成功回调函数
    FrontiaMultiShareResultCallback onResult = ^(NSDictionary *respones){
        NSLog(@"OnResult: %@", [respones description]);
    };
    
    FrontiaShareContent *content=[[FrontiaShareContent alloc] init];
    content.url = @"http://developer.baidu.com/soc/share";
    content.title = @"社会化分享";
    content.description = @"百度社会化分享组件封装了新浪微博、人人网、开心网、腾讯微博、QQ空间和贴吧等平台的授权及分享功能，也支持本地QQ好友分享、微信分享、邮件和短信发送等，同时提供了API接口调用及本地操作界面支持。组件集成简便，风格定制灵活，可轻松实现多平台分享功能。";
    content.imageObj = @"http://apps.bdimg.com/developer/static/04171450/developer/images/icon/terminal_adapter.png";
    
    NSArray *platforms = @[FRONTIA_SOCIAL_SHARE_PLATFORM_SINAWEIBO,FRONTIA_SOCIAL_SHARE_PLATFORM_QQWEIBO,FRONTIA_SOCIAL_SHARE_PLATFORM_QQ,FRONTIA_SOCIAL_SHARE_PLATFORM_RENREN,FRONTIA_SOCIAL_SHARE_PLATFORM_KAIXIN,FRONTIA_SOCIAL_SHARE_PLATFORM_EMAIL,FRONTIA_SOCIAL_SHARE_PLATFORM_SMS];
    
    [share showShareMenuWithShareContent:content displayPlatforms:platforms supportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait isStatusBarHidden:NO targetViewForPad:sender cancelListener:onCancel failureListener:onFailure resultListener:onResult];
}

-(IBAction)onShowEditViewButtonClicked:(id)sender
{
    FrontiaShare *share = [Frontia getShare];
    
    //授权取消回调函数
    FrontiaShareCancelCallback onCancel = ^(){
        NSLog(@"OnCancel: share is cancelled");
    };
    
    //授权失败回调函数
    FrontiaShareFailureCallback onFailure = ^(int errorCode, NSString *errorMessage){
        NSLog(@"OnFailure: %d  %@", errorCode, errorMessage);
    };
    
    //授权成功回调函数
    FrontiaMultiShareResultCallback onResult = ^(NSDictionary *respones){
        NSLog(@"OnResult: %@", [respones description]);
    };
    
    FrontiaShareContent *content=[[FrontiaShareContent alloc] init];
    content.url = @"http://developer.baidu.com/soc/share";
    content.title = @"社会化分享";
    content.description = @"百度社会化分享组件封装了新浪微博、人人网、开心网、腾讯微博、QQ空间和贴吧等平台的授权及分享功能，也支持本地QQ好友分享、微信分享、邮件和短信发送等，同时提供了API接口调用及本地操作界面支持。组件集成简便，风格定制灵活，可轻松实现多平台分享功能。";
    content.imageObj = @"http://apps.bdimg.com/developer/static/04171450/developer/images/icon/terminal_adapter.png";
    
    [share showEditViewWithPlatform:FRONTIA_SOCIAL_SHARE_PLATFORM_SINAWEIBO shareContent:content supportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait isStatusBarHidden:NO cancelListener:onCancel failureListener:onFailure resultListener:onResult];
}

-(IBAction)onSingleShareButtonClicked:(id)sender
{
    FrontiaShare *share = [Frontia getShare];
    
    //授权取消回调函数
    FrontiaShareCancelCallback onCancel = ^(){
        NSLog(@"OnCancel: share is cancelled");
    };
    
    //授权失败回调函数
    FrontiaShareFailureCallback onFailure = ^(int errorCode, NSString *errorMessage){
        NSLog(@"OnFailure: %d  %@", errorCode, errorMessage);
    };
    
    //授权成功回调函数
    FrontiaSingleShareResultCallback onResult = ^(){
        NSLog(@"OnResult: share success");
    };
    
    FrontiaShareContent *content=[[FrontiaShareContent alloc] init];
    content.url = @"http://developer.baidu.com/soc/share";
    content.title = @"社会化分享";
    content.description = @"百度社会化分享组件封装了新浪微博、人人网、开心网、腾讯微博、QQ空间和贴吧等平台的授权及分享功能，也支持本地QQ好友分享、微信分享、邮件和短信发送等，同时提供了API接口调用及本地操作界面支持。组件集成简便，风格定制灵活，可轻松实现多平台分享功能。";
    content.imageObj = @"http://apps.bdimg.com/developer/static/04171450/developer/images/icon/terminal_adapter.png";
    
    [share shareWithPlatform:FRONTIA_SOCIAL_SHARE_PLATFORM_RENREN content:content supportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait isStatusBarHidden:NO cancelListener:onCancel failureListener:onFailure resultListener:onResult];
}

-(IBAction)onMultiShareButtonClicked:(id)sender
{
    FrontiaShare *share = [Frontia getShare];
    
    //授权取消回调函数
    FrontiaShareCancelCallback onCancel = ^(){
        NSLog(@"OnCancel: share is cancelled");
    };
    
    //授权失败回调函数
    FrontiaShareFailureCallback onFailure = ^(int errorCode, NSString *errorMessage){
        NSLog(@"OnFailure: %d  %@", errorCode, errorMessage);
    };
    
    //授权成功回调函数
    FrontiaMultiShareResultCallback onResult = ^(NSDictionary *respones){
        NSLog(@"OnResult: %@", [respones description]);
    };
    
    FrontiaShareContent *content=[[FrontiaShareContent alloc] init];
    content.url = @"http://developer.baidu.com/soc/share";
    content.title = @"社会化分享";
    content.description = @"百度社会化分享组件封装了新浪微博、人人网、开心网、腾讯微博、QQ空间和贴吧等平台的授权及分享功能，也支持本地QQ好友分享、微信分享、邮件和短信发送等，同时提供了API接口调用及本地操作界面支持。组件集成简便，风格定制灵活，可轻松实现多平台分享功能。";
    content.imageObj = @"http://apps.bdimg.com/developer/static/04171450/developer/images/icon/terminal_adapter.png";
    
    NSArray *platforms = [NSArray arrayWithObjects:FRONTIA_SOCIAL_SHARE_PLATFORM_SINAWEIBO,FRONTIA_SOCIAL_SHARE_PLATFORM_RENREN,FRONTIA_SOCIAL_SHARE_PLATFORM_KAIXIN, nil];
    
    [share shareToCommunitiesWithPlatforms:platforms content:content cancelListener:onCancel failureListener:onFailure resultListener:onResult];
}

-(void)updateBSSDisplayMessage:(NSString*)message
{
    [bssResultIndicator setText:message];
}

-(void)updatePCSDisplayMessage:(NSString*)message
{
    [pcsResultIndicator setText:message];
}


-(void)updateBCSDisplayMessage:(NSString*)message
{
    [bcsResultIndicator setText:message];
}

-(void)updateBindDisplayMessage:(NSString*)message
{
    [bindResultIndicator setText:message];
}

-(void)updateCrontabDisplayMessage:(NSString*)message
{
    [crontabResultIndicator setText:message];
}

-(void)updateUserDisplayMessage:(NSString*)message
{
    [userResultIndicator setText:message];
}

-(void)updateLBSDisplayMessage:(NSString*)message
{
    [lbsResultIndicator setText:message];
}

-(void)updateCloudDownladDisplayMessage:(NSString*)message
{
    [cloudDownloadResultIndicator setText:message];
}

-(void)updateRecycleDisplayMessage:(NSString*)message
{
    [recycleResultIndicator setText:message];
}

- (IBAction)TextField_DidEndOnExit:(id)sender {
    // hide the keyboard
    [sender resignFirstResponder];
}

@end
