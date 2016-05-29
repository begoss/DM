//
//  DMFrameModel.m
//  DM
//
//  Created by OurEDA on 16/5/27.
//  Copyright (c) 2016年 OurEDA. All rights reserved.
//

#import "DMFrameModel.h"

@implementation DMFrameModel

+ (instancetype)frameModelWithModel:(DMModel *)model{
    return [[self alloc] initWithModel:model];
}
+(NSMutableArray *)frameModelWithArray:(NSMutableArray *)arr{
    NSMutableArray*data = [NSMutableArray array];
    for (DMModel*mo in arr) {
        DMFrameModel*newM =  [self frameModelWithModel:mo];
        [data addObject:newM];
    }
    return data;
}
- (instancetype)initWithModel:(DMModel*)model{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}
-(CGFloat)cellHeight{
    //得到屏幕尺寸
    CGRect rect = [[UIScreen mainScreen] bounds];
    float screenW = rect.size.width;
    float screenH = rect.size.height;

    
    if (_cellHeight == 0) {
        CGFloat margin = 10;
        
        // 头像
        CGFloat iconX = margin;
        CGFloat iconY = margin;
        CGFloat iconWH = 30;
        self.iconFrame = CGRectMake(iconX, iconY, iconWH, iconWH);
        
        // 昵称(姓名)
        CGFloat nameY = iconY;
        CGFloat nameX = CGRectGetMaxX(self.iconFrame) + margin;
        // 计算文字所占据的尺寸
        NSDictionary *nameAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:17]};
        CGSize nameSize = [self.model.name sizeWithAttributes:nameAttrs];
        self.nameFrame = (CGRect){{nameX, nameY}, nameSize};
        
        
        // 等级
        CGFloat levelY = iconY+1;
        CGFloat levelX = CGRectGetMaxX(self.nameFrame) + margin;
        self.levelFrame = CGRectMake(levelX, levelY, 50,15);
        
        // 版主
        CGFloat mY = iconY+1;
        CGFloat mX = CGRectGetMaxX(self.levelFrame);
        self.isManagerFrame = CGRectMake(mX, mY, 30,15);
        
        // 点赞数
        CGFloat upY = iconY+1;
        CGFloat upX = screenW-62;
        self.upFrame = CGRectMake(upX, upY, 22,12);
        
        //评论数
        CGFloat commentNumY = iconY+1;
        CGFloat commentNumX = screenW-24;
        self.commentNumFrame = CGRectMake(commentNumX, commentNumY, 22,12);

        //时间
        CGFloat timeX = CGRectGetMaxX(self.iconFrame)+10;
        CGFloat timeY = CGRectGetMaxY(self.nameFrame)+2;
        self.timeFrame = CGRectMake(timeX, timeY, 65,11);
        
        // 标题
        CGFloat titleX = iconX;
        CGFloat titleY = CGRectGetMaxY(self.iconFrame) + margin;
        CGFloat titleW = [UIScreen mainScreen].bounds.size.width - 2 * titleX;
        CGSize titleMaxSize = CGSizeMake(titleW, MAXFLOAT);
        NSDictionary *titleAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
        CGFloat titleH = [self.model.title boundingRectWithSize:titleMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttrs context:nil].size.height;
        self.titleFrame = CGRectMake(titleX, titleY, titleW, titleH);
        
        // 描述
        CGFloat desX = iconX+2;
        CGFloat desY = CGRectGetMaxY(self.titleFrame)+2;
        CGFloat desW = [UIScreen mainScreen].bounds.size.width - 2 * titleX;
        CGSize desMaxSize = CGSizeMake(titleW, MAXFLOAT);
        NSDictionary *desAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
        CGFloat desH = [self.model.descrpt boundingRectWithSize:desMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:desAttrs context:nil].size.height;
        self.descriptionFrame = CGRectMake(desX, desY, desW, desH);

        
        // 配图
        if ([self.model.picURL count]!=0) {
            int floor = ([self.model.picURL count]-1)/3;
            floor++;
            CGFloat pictureWH = 120*floor;
            CGFloat pictureX = 0;
            CGFloat pictureY = CGRectGetMaxY(self.descriptionFrame)+2;
            self.pictureFrame = CGRectMake(pictureX, pictureY, screenW, pictureWH);
            _cellHeight = CGRectGetMaxY(self.pictureFrame);
        } else {
            _cellHeight = CGRectGetMaxY(self.descriptionFrame);
        }
        _cellHeight += margin;
    }
    return _cellHeight;
}


@end
