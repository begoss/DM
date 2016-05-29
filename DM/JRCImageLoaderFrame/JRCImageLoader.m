//
//  JRCImageLoader.m
//  JRCImageLoder
//
//  Created by laojin on 14-8-18.
//  Copyright (c) 2014年 com.jrc. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "JRCImageLoader.h"
#import "UIImage+JRCImage.h"
#import "JRCUIDefine.h"

@interface JRCImageLoader()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSString * imageName;
    NSMutableData   * receiveData;
    NSURLConnection  *connection;
}
@end

@implementation JRCImageLoader

@synthesize imgInfo = _imgInfo,image = _image,imgPath = _imgPath;

- (void)dealloc
{
    [connection cancel];
    connection = nil;
    receiveData = nil;
    self.delegate = nil;
}

+ (NSString *)imagePathKeyWithImageInfo:(NSDictionary *)dictinfo andImageName:(NSString *)imagePath;
{
    NSMutableString * key = [NSMutableString string];
    if([dictinfo objectForKey:HOLDSIZE]){
        CGSize size = [[dictinfo objectForKey:HOLDSIZE] CGSizeValue];
        [key appendFormat:@"%.0f*%.0f",size.width,size.height];
    }
    
    if([JRCImageLoader isValidateStr:imagePath]){
        [key appendFormat:@"imageCache_%@",[imagePath lastPathComponent]];
    }else{
        NSArray * array = [imagePath componentsSeparatedByString:@"/"];
        [key appendFormat:@"bundle_%@",[array lastObject]];
    }
    return key;
}

+ (NSString *)imageCachePathWithPath:(NSString *)_pathString
{
    NSString * path = nil;
    NSMutableString * key = [NSMutableString string];
    NSArray * array = [_pathString componentsSeparatedByString:@"/"];
    [key appendFormat:@"cache_%@",[array lastObject]];
    path = [PATH_TO_STORE_IMAGE stringByAppendingPathComponent:key];//未被处理存储过的image地址
    return path;
}


+ (BOOL)isValidateStr:(NSString *)str
{
    if (!str || 0 == str.length || !regexStr || 0 == regexStr) return NO;
    
    NSPredicate *strPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [strPredicate evaluateWithObject:str];
}

- (id)init
{
    if(self = [super init]){
        self.state = load_default;
    }
    return self;
}

- (void)createImage
{
    if(self.state == load_ing || self.state == load_scucess || self.image){
        return;
    }
    self.state = load_ing;
    if(!imageName){
        imageName = [JRCImageLoader imagePathKeyWithImageInfo:_imgInfo andImageName:_imgPath];
    }
    if(![JRCImageLoader isValidateStr:_imgPath]){//如果是本地资源
        [self getImageFromBundle];//本地资源
    }else{
        [self downLoadImageFromNetWork];//走网络请求途径了
    }
}

#pragma mark 本地资源

- (void)getImageFromBundle
{
//    if(!self.image){
//        self.image = [NSData dataWithContentsOfFile:_imgPath];
//    }
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void)
//    {
//        [self fireImageFactory];
//        dispatch_async(dispatch_get_main_queue(),
//        ^(void){
//            [self imageReadySend];//发送图片
//            });
//        });
}

#pragma mark 网络请求图片
- (void)downLoadImageFromNetWork
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
    //do something
        [self getImageFromCache];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
        //回到主线程
            if(self.state == load_scucess && self.image){//拿到图片了且还没有被处理过
                [self imageReadySend];//发送图片
            }else{
                [self getImageFromServers];//找服务器要
            }
        });
    });
}

- (BOOL)getImageFromCache
{
    BOOL hadImg = NO;
    
    NSString * path = [PATH_TO_STORE_IMAGE stringByAppendingPathComponent:imageName];//被处理过的image存储地址
    if(![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        path = [JRCImageLoader imageCachePathWithPath:self.imgPath];
        if([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            [self getImageFromCachePath:path];
            [self cacheImageWithKey:[PATH_TO_STORE_IMAGE stringByAppendingPathComponent:imageName]];//按照客户需求改变名称另外缓存，下次直接就取了不用再对image做处理
            self.state = load_scucess;//拿到image了
            hadImg = YES;
        }
    }else{
        [self getImageFromCachePath:path];//这里取的image不用做任何的处理了
        self.state = load_scucess;//拿到image了
        hadImg = YES;
    }
    return hadImg;
}

- (void)getImageFromCachePath:(NSString *)path
{
    NSData * data = [NSData dataWithContentsOfFile:path];
    self.image = data;
}

- (void)cancel
{
    if(connection){
        [connection cancel];
        connection = nil;
        receiveData = nil;
        self.image = nil;
    }
}

#pragma mark OK，这里image已经拿到手再调用这个方法

- (void)imageReadySend
{
    NSString * key = imageName;
    if(self.delegate && [self.delegate respondsToSelector:@selector(imageDidFoundFinishd:andTargetKey:)]){
        [_delegate imageDidFoundFinishd:self andTargetKey:key];
    }
}


#pragma mark 在沙河中没找到根图也没找到子图就开始走网络了

- (void)getImageFromServers
{
    connection = nil;
    receiveData = nil;
    if(!receiveData){
        receiveData = [[NSMutableData alloc] init];
    }
    
    NSURL * url = [NSURL URLWithString:self.imgPath];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
//    [request setValue:@"bytes=20000-" forHTTPHeaderField:@"Range"];
    if(self.allowResumeForFileDownloads){
        if([[NSFileManager defaultManager] fileExistsAtPath:[PATH_TO_CACHE_IMAGE stringByAppendingPathComponent:imageName]]){
          long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:[PATH_TO_CACHE_IMAGE stringByAppendingPathComponent:imageName] error:nil] fileSize];
            [request setValue:[NSString stringWithFormat:@"bytes=%llu-",fileSize] forHTTPHeaderField:@"Range"];
            [receiveData appendData:[NSData dataWithContentsOfFile:[PATH_TO_CACHE_IMAGE stringByAppendingPathComponent:imageName]]];
        }
    }
    
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [receiveData appendData:data];
    if(self.allowResumeForFileDownloads){
        [receiveData writeToFile:[PATH_TO_CACHE_IMAGE stringByAppendingPathComponent:imageName] atomically:YES];
    }
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    receiveData = nil;
    self.state = load_fail;
    self.image = nil;
    
    NSLog(@"///////////////////////////////////图片下载失败/////////////////////////////////\n%@",self.imgPath);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)_connection
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
    //do something
        NSString * path = [JRCImageLoader imageCachePathWithPath:self.imgPath];
        [receiveData writeToFile:path atomically:YES];
        [[NSFileManager defaultManager] removeItemAtPath:[PATH_TO_CACHE_IMAGE stringByAppendingPathComponent:imageName] error:nil];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        //回到主线程
        [self downLoadImageFromNetWork];
    });
});

}

#pragma mark 图片处理

- (void)cacheImageWithKey:(NSString *)path
{
    if(_image){
        [self fireImageFactory];
        [self.image writeToFile:path atomically:YES];
    }
}

- (void)fireImageFactory//图片压缩处理 等比例
{
    if(self.state == load_scucess){
        return;
    }
    self.state = load_scucess;
    
    UIImage * img = [UIImage imageWithData:self.image];
    
    
    if([_imgInfo objectForKey:HOLDSIZE]&&img){
        CGSize size = [[_imgInfo objectForKey:HOLDSIZE] CGSizeValue];
        size.width = size.width*2;
        size.height = size.height*2;
        CGSize imageSize = img.size;
        
        CGSize scalesize = CGSizeZero;
        
        CGFloat imageScale = imageSize.width/imageSize.height;
        CGFloat sizeScale = size.width/size.height;
        
        if(sizeScale>=imageScale){
            scalesize.width = imageSize.width;
            scalesize.height = imageSize.width/sizeScale;
        }else if(sizeScale<imageScale){
            scalesize.height = imageSize.height;
            scalesize.width = imageSize.height*sizeScale;
        }
        
        CGRect rect = CGRectMake((imageSize.width-scalesize.width)/2, (imageSize.height-scalesize.height)/2, scalesize.width, scalesize.height);
        CGImageRef sourceImageRef = [img CGImage];
        CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
        UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
        
        UIGraphicsBeginImageContext(size);
        [newImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.image = UIImagePNGRepresentation(reSizeImage);
    }
}

@end
