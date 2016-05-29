//
//  DMCell.h
//  DM
//
//  Created by OurEDA on 16/5/27.
//  Copyright (c) 2016年 OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMModel.h"
#import "DMFrameModel.h"
#import "JRCImageView.h"
#import "JRCUIDefine.h"

@interface DMCell : UITableViewCell {
    float screenW;
    float screenH;
}


@property(nonatomic,strong)DMModel * model;

@property(nonatomic,strong)DMFrameModel * frameModel;

@property (nonatomic, weak) JRCImageView *iconImageView;

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *title_label;

@property (nonatomic, weak) UILabel *time_label;

@property (nonatomic, weak) UIView *picView;

@property (nonatomic, weak) UILabel *level_label;

@property (nonatomic, weak) UILabel *up_label;

@property (nonatomic, weak) UILabel *comment_num_label;

@property (nonatomic, weak) UILabel *description_label;

@property (nonatomic, weak) UILabel *is_manager_label;

@end
