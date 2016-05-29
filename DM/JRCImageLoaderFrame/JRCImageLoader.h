//
//  JRCImageLoader.h
//  JRCImageLoder
//
//  Created by laojin on 14-8-18.
//  Copyright (c) 2014年 com.jrc. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <Foundation/Foundation.h>

typedef enum{
    load_default = 0,
    load_ing,
    load_scucess,
    load_fail
}JRCImageLoadState;

@class JRCImageLoader;
@protocol JRCImageLoaderDelegate <NSObject>

- (void)imageDidFoundFinishd:(JRCImageLoader *)loader   andTargetKey:(NSString *)key;

@end

//图片存储，下载类
@interface JRCImageLoader : NSObject

@property (nonatomic ,strong)   NSData                    * image;
@property (nonatomic ,retain)   NSString                  * imgPath;
@property (nonatomic ,retain)   NSDictionary              * imgInfo;
@property (nonatomic ,assign)   JRCImageLoadState           state;
@property (nonatomic ,assign)   id<JRCImageLoaderDelegate>  delegate;
//是否需要断点续传，默认为NO
@property (nonatomic ,assign)   BOOL                        allowResumeForFileDownloads;

//订阅者与被订阅者由这个方法产生的统一KEY关联起来
+ (NSString *)imagePathKeyWithImageInfo:(NSDictionary *)dictinfo andImageName:(NSString *)imagePath;


//配置完属性后调用此方法开始创建image
- (void)createImage;

- (void)cancel;
@end
