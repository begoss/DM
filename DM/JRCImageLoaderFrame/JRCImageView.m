//
//  JRCImageView.m
//  JRCImageLoder
//
//  Created by laojin on 14-8-18.
//  Copyright (c) 2014年 com.jrc. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "JRCImageView.h"
#import "JRCImageLoaderManager.h"
#import "UIImage+JRCImage.h"
#import "JRCImageLoader.h"
#import "JRCUIDefine.h"

@interface JRCImageView()<JRCImageLoaderManagerDelegate>
{
    NSDictionary * imageInfo;
}

//网络图片请求时的默认图
@property (nonatomic ,copy)     NSString    * holdImageNamed;

//是否需要按照原图比例显示，默认为NO
@property (nonatomic ,assign)   BOOL          holdImageSize;

//保持一个SIZE，并按照原比例展示image，image默认截取中间部分，如果size的范围超过image，则自动选择范围，如果未设置此属性，则默认image全展示
@property (nonatomic ,assign)   CGSize        holdSize;

@end

@implementation JRCImageView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.image = nil;
}

- (id)initWithFrame:(CGRect)frame andImageNamed:(NSString *)_imgName
{
    self = [super initWithFrame:frame];
    if(self){
        self.imageNamed = _imgName;
        self.imageURL = [[NSBundle mainBundle] pathForAuxiliaryExecutable:self.imageNamed];
        self.holdSize = self.frame.size;
        [self beginLoadImage];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andImageURL:(NSString *)_imgURL andHoldImgNamed:(NSString *)holdImgName andKeepSize:(BOOL)keepImgsize
{
    self = [super initWithFrame:frame];
    if(self){
        if(holdImgName){
            self.holdImageNamed = holdImgName;
        }
        self.holdImageSize = YES;
        self.holdSize = self.frame.size;
        self.imageURL = _imgURL;
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andImageURL:(NSString *)_imgURL andHoldImgNamed:(NSString *)holdImgName andHodlSize:(CGSize)_hsize
{
    self = [self initWithFrame:frame andImageURL:_imgURL andHoldImgNamed:holdImgName andKeepSize:YES];
    if(self){
        self.holdSize = _hsize;
    }
    return self;
}

- (void)setImageURL:(NSString *)imageURL
{
    _imageURL = imageURL;
    self.image = nil;
}

- (void)beginLoadImage
{
    if(!_imageURL){
        return;
    }
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    if(_holdSize.width || _holdSize.height){
        [dict setObject:[NSValue valueWithCGSize:_holdSize] forKey:HOLDSIZE];
    }
    [dict setObject:[NSNumber numberWithBool:_holdImageSize] forKey:KEEPSIZE];
    long long time = [[NSDate date] timeIntervalSince1970];
    [dict setObject:[NSNumber numberWithLongLong:time] forKey:TIME];
    
    if(!imageInfo){
        imageInfo = dict;
    }
    NSString * key = [JRCImageLoader imagePathKeyWithImageInfo:imageInfo andImageName:_imageURL];
    [[JRCImageLoaderManager shareInstance] cleanClearObserver:self withKey:key];

    [[JRCImageLoaderManager shareInstance] getImageWithCache:_imageURL andImgInfo:dict andTarget:self];
}

- (void)removeFromSuperview
{
    NSString * key = [JRCImageLoader imagePathKeyWithImageInfo:imageInfo andImageName:_imageURL];
    [[JRCImageLoaderManager shareInstance] cleanClearObserver:self withKey:key];
    [super removeFromSuperview];
}

#pragma mark图片管理中心分发image

- (void)imageDidFoundFinish:(NSData *)imagedata
{
    self.image = [UIImage imageWithData:imagedata];
    [self setNeedsLayout];
    [[NSRunLoop mainRunLoop] runMode:NSRunLoopCommonModes beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];

}
@end
