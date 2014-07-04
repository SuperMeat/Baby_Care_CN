//
//  UIASYImageView.m
//  Created by carbon on 11-6-24.
//  Copyright (c) 2013年 Carbon. All rights reserved.
//

#import "UIASYImageView.h"

@implementation UIASYImageView
@synthesize asyFlag,needCut,needShowsAnimations;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImage *image = [UIImage imageNamed:@"header.png"];
        [self setAlpha:0.50];
        [self setImage:image];
        needShowsAnimations = YES;
    }
    return self;
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}


- (void)setShowsAnimations:(BOOL)animated
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.15f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    [self.layer removeAllAnimations];
    [self.layer addAnimation:animation forKey:@"animation"];
    [pool drain];
}


//获取图片路径
- (NSString*)get_image_save_file_path:(NSString*)imagePath
{
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@"://" withString:@"_"];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    NSArray *path_array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [path_array objectAtIndex:0];
    path_array = nil;
    NSString *path = [directory stringByAppendingPathComponent:imagePath];
    return path;
}


//用于显示图片
- (void)showImageWithPathStr:(NSString*)imagePath
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *contentsOfFile = [self get_image_save_file_path:imagePath];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:contentsOfFile];
    
    if (asyFlag)
    {
        CGSize imageSize = [image size];
        CGSize viewSize = self.frame.size;
        if (imageSize.width/imageSize.height != viewSize.width/viewSize.height)
        {
            CGRect rect = self.frame;
            if (imageSize.width > 70)
            {
                imageSize.height = 70*imageSize.height/imageSize.width;
                imageSize.width = 70;
            }
            if (imageSize.height > 70)
            {
                imageSize.width = 70*imageSize.width/imageSize.height;
                imageSize.height = 70;
            }
            
            rect = CGRectMake(rect.origin.x+(rect.size.width-imageSize.width)/2, rect.origin.y+(rect.size.height-imageSize.height)/2, imageSize.width, imageSize.height);
            [self setFrame:rect];
        }
    }
    
    if (needCut)
    {
        NSAutoreleasePool *pool_ = [[NSAutoreleasePool alloc] init];
//        UIImage *fitImage = [UIImage image:image fitInSize:self.frame.size];
        [self setImage:image];
        [pool_ drain];
    }
    else 
    {
        @try
        {
            if (image)
            {
                [self setImage:image];
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"exception reason is %@",[exception reason]);
        }
    }
    if (needShowsAnimations)
    {
        [self setShowsAnimations:needShowsAnimations];
    }
    [self layoutSubviews];
    NSLog(@"下载完成");
    [image release];
    image = nil;
    [pool drain];
}


//这个路径下是否存在此图片
- (BOOL)image_exists_at_file_path:(NSString *)image_path
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    image_path = [image_path stringByReplacingOccurrencesOfString:@"://" withString:@"_"];
    image_path = [image_path stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    NSFileManager *file_manager = [NSFileManager defaultManager];
    NSArray *path_array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [path_array objectAtIndex:0];
    NSString *path = [directory stringByAppendingPathComponent:image_path];
    BOOL exist = [file_manager fileExistsAtPath:path];
    [pool drain];
    return exist;
}



//加载网络图片，如果图片已经存在于本地，则直接显示
- (void)showImageWithUrl:(NSString*)url
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    [self setAlpha:1.0];
    BOOL exists = [self image_exists_at_file_path:url];
    if (!exists && url)
    {
        NSLog(@"开始下载……");
        [self performSelectorInBackground:@selector(downloadImageResourceInThread:) withObject:url];
    }
    else 
    {
        [self showImageWithPathStr:url];
    }
    [pool drain];
}


-(void)downloadImageResourceInThread:(NSString*)url
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSURL *src_url = [NSURL URLWithString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:src_url];
    [request setTimeOutSeconds:100];
    NSString *image_path = [[url stringByReplacingOccurrencesOfString:@"://" withString:@"_"] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSArray *path_array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [path_array objectAtIndex:0];
    NSString * path = [directory stringByAppendingPathComponent:image_path];
    [request setDownloadDestinationPath:path];
    [request startSynchronous];
    [self showImageWithPathStr:url];
    [request release];
    [pool drain];
}

- (void)dealloc
{
    [super dealloc];
}

@end
