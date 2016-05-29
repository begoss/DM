//
//  JRCImageView.h
//  JRCImageLoder
//
//  Created by laojin on 14-8-18.
//  Copyright (c) 2014年 com.jrc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRCImageView : UIImageView

//Bundle资源名称
@property (nonatomic ,copy)     NSString    * imageNamed;

//图片网络地址
@property (nonatomic ,copy)     NSString    * imageURL;

//是否需要断点续传，默认为NO
@property (nonatomic ,assign)   BOOL          allowResumeForFileDownloads;

/*
 参数：imageview的Frame，不解释了；_imgName:资源名称
 功能：返回一个加载好的imageview
 */
- (id)initWithFrame:(CGRect)frame andImageNamed:(NSString *)_imgName;

/*
 参数：imageview的Frame，不解释了；_imgURL:资源地址 holdImgName：默认图的资源名称  keepImgsize:是否需要按原图比例展示图片
 功能：返回一个加载网络图片的imageview
 */
- (id)initWithFrame:(CGRect)frame andImageURL:(NSString *)_imgURL andHoldImgNamed:(NSString *)holdImgName andKeepSize:(BOOL)keepImgsize;

/*
 参数：imageview的Frame，不解释了；_imgURL:资源地址 holdImgName：默认图的资源名称  _hsize:按照原图比例在一定范围内截取image展示
 功能：返回一个加载网络图片的imageview
 */
- (id)initWithFrame:(CGRect)frame andImageURL:(NSString *)_imgURL andHoldImgNamed:(NSString *)holdImgName andHodlSize:(CGSize)_hsize;



- (void)beginLoadImage;//网络请求时必须调用此函数才能开始请求加载过程

@end
