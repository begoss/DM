//
//  DMFrameModel.h
//  DM
//
//  Created by OurEDA on 16/5/27.
//  Copyright (c) 2016年 OurEDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DMModel.h"

@interface DMFrameModel : NSObject

@property(nonatomic,assign)CGRect nameFrame;

@property(nonatomic,assign)CGRect iconFrame;

@property(nonatomic,assign)CGRect titleFrame;

@property(nonatomic,assign)CGRect pictureFrame;

@property(nonatomic,assign)CGRect levelFrame;

@property(nonatomic,assign)CGRect upFrame;

@property(nonatomic,assign)CGRect commentNumFrame;

@property(nonatomic,assign)CGRect timeFrame;

@property(nonatomic,assign)CGRect isManagerFrame;

@property(nonatomic,assign)CGRect descriptionFrame;


//---------------------------
@property(nonatomic,assign)CGFloat cellHeight;
/**
 *  model
 */
@property(nonatomic,strong)DMModel * model;

+ (NSMutableArray*)frameModelWithArray:(NSMutableArray*)arr;

+ (instancetype)frameModelWithModel:(DMModel*)model;


@end
