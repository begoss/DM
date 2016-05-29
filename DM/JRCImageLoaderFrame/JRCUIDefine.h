//
//  JRCUIDefine.h
//  JRCImageLoder
//
//  Created by laojin on 14-8-18.
//  Copyright (c) 2014年 com.jrc. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com


static NSString * const regexStr =@"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?";

#define HOLDSIZE    @"holdSize"
#define KEEPSIZE    @"keepSize"
#define TIME        @"time"

#define PATH_TO_STORE_IMAGE [[NSHomeDirectory() stringByAppendingPathComponent:@"/Library"] stringByAppendingPathComponent:@"/Caches/image"]
#define PATH_TO_CACHE_IMAGE [[NSHomeDirectory() stringByAppendingPathComponent:@"/Library"] stringByAppendingPathComponent:@"/Caches/imagecache"]



