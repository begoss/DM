//
//  DMModel.h
//  DM
//
//  Created by OurEDA on 16/5/27.
//  Copyright (c) 2016年 OurEDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DMModel : NSObject


@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * icon;
@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong) NSString * userLevel;
@property(nonatomic,strong) NSNumber * createTime;
@property(nonatomic,assign) NSString * isManager;
@property(nonatomic,strong) NSString * up;
@property(nonatomic,strong) NSString * commentNum;
@property(nonatomic,strong) NSString * descrpt;
@property(nonatomic,strong) NSArray * picURL;

+ (instancetype)modelWithDict:(NSDictionary*)dict;

@end
