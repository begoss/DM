//
//  JRCImageLoaderManager.h
//  JRCImageLoder
//
//  Created by laojin on 14-8-18.
//  Copyright (c) 2014年 com.jrc. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <Foundation/Foundation.h>
#import "JRCImageView.h"

@protocol JRCImageLoaderManagerDelegate <NSObject>
@required
- (void)imageDidFoundFinish:(NSData *)image;


@end


//图片分发中心
@interface JRCImageLoaderManager : NSObject

+ (JRCImageLoaderManager *)shareInstance;



- (void)getImageWithCache:(NSString *)imgPath andImgInfo:(NSDictionary *)dictInfo andTarget:(id<JRCImageLoaderManagerDelegate>)taget;
- (void)setTargetWithKey:(NSString  *)key andTarget:(JRCImageView *)target;
- (void)cleanClearObserver:(JRCImageView *)obj withKey:(NSString *)key;
@end
