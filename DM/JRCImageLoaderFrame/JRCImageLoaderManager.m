//
//  JRCImageLoaderManager.m
//  JRCImageLoder
//
//  Created by laojin on 14-8-18.
//  Copyright (c) 2014年 com.jrc. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "JRCImageLoaderManager.h"
#import "JRCImageLoader.h"
#import "JRCUIDefine.h"
#import <mach/mach.h>
#import <mach/mach_host.h>

static JRCImageLoaderManager * manager = nil;


@interface JRCImageLoaderManager()<JRCImageLoaderDelegate>
{
    NSMutableDictionary         * imageLoaderTargetList;
    NSMutableDictionary         * imageLoaderCache;
    NSMutableDictionary         * alreadyLoadingList;//已经加载image完成的loader记录
    CGFloat                       Memory;
}

@end

@implementation JRCImageLoaderManager

static float maxmemory = 20.0f;//大于20M时开始清除60S钟以前的缓存

+ (JRCImageLoaderManager *)shareInstance
{
    if(!manager){
        manager = [[JRCImageLoaderManager alloc] init];
        if(![[NSFileManager defaultManager] fileExistsAtPath:PATH_TO_STORE_IMAGE])//创建沙河缓存路径
        {
            NSError *error;
            NSFileManager *manager = [NSFileManager defaultManager];
            [manager createDirectoryAtPath:PATH_TO_STORE_IMAGE withIntermediateDirectories:YES attributes:nil error:&error];
        }
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:PATH_TO_CACHE_IMAGE])//创建沙河缓存路径
        {
            NSError *error;
            NSFileManager *manager = [NSFileManager defaultManager];
            [manager createDirectoryAtPath:PATH_TO_CACHE_IMAGE withIntermediateDirectories:YES attributes:nil error:&error];
        }
        
    }
    return manager;
}

- (void)checkMemoryForSize
{
    if(Memory>=maxmemory){
        [self clearCacheImageWithTime:60];
    }
}

- (void)clearCacheImageWithTime:(NSInteger)seconds//根据缓存时间删除image,可能会导致某些下载流失败，，慎用
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
    //do something
        if(!seconds){
            [imageLoaderCache removeAllObjects];
            [alreadyLoadingList removeAllObjects];
        }else{
            NSArray * array = [alreadyLoadingList.allValues sortedArrayUsingSelector:@selector(compare:)];
            long long nowtime = [[NSDate date] timeIntervalSince1970];
            for(int i = 0;i<array.count;i++){
                NSNumber * number = [array objectAtIndex:i];
                if(nowtime-number.longLongValue >=seconds){
                    NSArray * alkey = [alreadyLoadingList allKeysForObject:number];
                    for(id key in alkey){
                        [alreadyLoadingList removeObjectForKey:key];
                        [imageLoaderCache removeObjectForKey:key];
                    }
                }else{
                    break;
                }
            }
        }
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        //回到主线程
        
    });
});

}

- (id)init
{
    self = [super init];
    if(self){
        imageLoaderTargetList = [[NSMutableDictionary alloc] init];
        imageLoaderCache = [[NSMutableDictionary alloc] init];
        alreadyLoadingList = [[NSMutableDictionary alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        Memory = 0;
    }
    return self;
}

- (void)clearCache
{
    [imageLoaderTargetList removeAllObjects];
    [imageLoaderCache removeAllObjects];
    [alreadyLoadingList removeAllObjects];
    Memory = 0;
}

//订阅Image
- (void)getImageWithCache:(NSString *)imgPath andImgInfo:(NSDictionary *)dictInfo andTarget:(JRCImageView *)taget
{
    NSString * key = [JRCImageLoader imagePathKeyWithImageInfo:dictInfo andImageName:imgPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        //do something
        if(![imageLoaderCache objectForKey:key]){
            JRCImageLoader  * loader = [[JRCImageLoader alloc] init];
            loader.imgPath = imgPath;
            loader.imgInfo = dictInfo;
            loader.delegate = self;
            loader.allowResumeForFileDownloads = taget.allowResumeForFileDownloads;
            [imageLoaderCache setObject:loader forKey:key];
        }
        JRCImageLoader * loader = [imageLoaderCache objectForKey:key];
        if(loader.state == load_scucess && loader.image){//在缓存里面有这个图，则直接给，不走订阅的路子了
            [self cleanClearObserver:taget withKey:key];
            if([taget respondsToSelector:@selector(imageDidFoundFinish:)]){
                [taget performSelectorOnMainThread:@selector(imageDidFoundFinish:) withObject:loader.image waitUntilDone:YES];
            }
        }else{//加入订阅
            [self setTargetWithKey:key andTarget:taget];
            [loader createImage];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            //回到主线程
            
        });
    });
}

//添加订阅者
- (void)setTargetWithKey:(NSString  *)key andTarget:(JRCImageView *)target
{
    if([imageLoaderTargetList objectForKey:key]){
        NSMutableArray * targetArray = [imageLoaderTargetList objectForKey:key];
        [targetArray addObject:target];
    }else{
        NSMutableArray * targetArray = [NSMutableArray array];
        [targetArray addObject:target];
        [imageLoaderTargetList setObject:targetArray forKey:key];
    }
}

//清除订阅者
- (void)cleanClearObserver:(JRCImageView *)obj withKey:(NSString *)key
{
    if([imageLoaderCache objectForKey:key]){
        JRCImageLoader * loader = [imageLoaderCache objectForKey:key];
        [loader cancel];
        if(!loader.image){
            [imageLoaderCache removeObjectForKey:key];
        }
    }
    if([imageLoaderTargetList objectForKey:key]){
        NSMutableArray * targetArray = [imageLoaderTargetList objectForKey:key];
        if([targetArray containsObject:obj]){
            [targetArray removeObject:obj];
        }
        if(targetArray.count==0){
            [imageLoaderTargetList removeObjectForKey:key];
        }
    }
}

#pragma mark JRCImageLoaderDelegate
- (void)imageDidFoundFinishd:(JRCImageLoader *)loader andTargetKey:(NSString *)key
{
    if([imageLoaderTargetList objectForKey:key]){
        NSMutableArray * array = [imageLoaderTargetList objectForKey:key];
        if(loader.image){
            
            Memory = ((float)loader.image.length)/1024/1024 + Memory;
            [alreadyLoadingList setObject:[loader.imgInfo objectForKey:TIME] forKey:key];
            for(int i=0;i<array.count;i++){
                JRCImageView * view = [array objectAtIndex:i];
                if([view respondsToSelector:@selector(imageDidFoundFinish:)]){
                    [view performSelectorOnMainThread:@selector(imageDidFoundFinish:) withObject:loader.image waitUntilDone:YES];
                    [array removeObject:view];
                    i--;
                }
            }
            [imageLoaderTargetList removeObjectForKey:key];           
        }
    }
    [self checkMemoryForSize];
}


@end
