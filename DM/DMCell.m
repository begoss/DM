//
//  DMCell.m
//  DM
//
//  Created by OurEDA on 16/5/27.
//  Copyright (c) 2016年 OurEDA. All rights reserved.
//

#import "DMCell.h"
@interface DMCell()


@end
@implementation DMCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //得到屏幕尺寸
        CGRect rect = [[UIScreen mainScreen] bounds];
        screenW = rect.size.width;
        screenH = rect.size.height;
        
        // 头像
        JRCImageView *iconImageView = [[JRCImageView alloc] init];
        iconImageView.allowResumeForFileDownloads = YES;
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        // 名称
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        //等级
        UILabel *levelLabel = [[UILabel alloc] init];
        levelLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:levelLabel];
        self.level_label = levelLabel;
        
        //版主
        UILabel *imLabel = [[UILabel alloc] init];
        imLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:imLabel];
        self.is_manager_label = imLabel;

        //创建时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:10];
        [timeLabel setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:timeLabel];
        self.time_label = timeLabel;
        
        //点赞数
        UILabel *upLabel = [[UILabel alloc] init];
        upLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:upLabel];
        self.up_label = upLabel;
        
        UILabel *upLabelW = [[UILabel alloc] initWithFrame:CGRectMake(screenW-77, 11, 16, 12)];
        upLabelW.font = [UIFont systemFontOfSize:11];
        upLabelW.text = @"赞:";
        [self.contentView addSubview:upLabelW];

        //评论数
        UILabel *commentNumLabel = [[UILabel alloc] init];
        commentNumLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:commentNumLabel];
        self.comment_num_label = commentNumLabel;

        UILabel *commentNumLabelW = [[UILabel alloc] initWithFrame:CGRectMake(screenW-39, 11, 16, 12)];
        commentNumLabelW.font = [UIFont systemFontOfSize:11];
        commentNumLabelW.text = @"评:";
        [self.contentView addSubview:commentNumLabelW];
        
        // 标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [self.contentView addSubview:titleLabel];
        self.title_label = titleLabel;
        
        // 描述
        UILabel *descriptionLabel = [[UILabel alloc] init];
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:descriptionLabel];
        self.description_label = descriptionLabel;
        
        //配图
        UIView *picV = [[UIView alloc] init];
        [picV setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:picV];
        self.picView = picV;
    }
    return  self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    _iconImageView.frame = _frameModel.iconFrame;
    _title_label.frame = _frameModel.titleFrame;
    _nameLabel.frame = _frameModel.nameFrame;
    _picView.frame = _frameModel.pictureFrame;
    _level_label.frame = _frameModel.levelFrame;
    _up_label.frame = _frameModel.upFrame;
    _comment_num_label.frame = _frameModel.commentNumFrame;
    _description_label.frame = _frameModel.descriptionFrame;
    _is_manager_label.frame = _frameModel.isManagerFrame;
    _time_label.frame = _frameModel.timeFrame;
}


-(void)setModel:(DMModel *)model{
    _model = model;
    _nameLabel.text = _model.name;
    _title_label.text = _model.title;
    
    _iconImageView.imageURL = _model.icon;
    [_iconImageView beginLoadImage];
    
    _time_label.text = [NSString stringWithFormat:@"%@",_model.createTime];
    
    _level_label.text = _model.userLevel;
    _up_label.text = _model.up;
    _comment_num_label.text = _model.commentNum;
    _description_label.text = _model.descrpt;
    _is_manager_label.text = _model.isManager;
    [_is_manager_label setTextColor:[UIColor redColor]];

    
    //设置图片
    for (UIView *subView in _picView.subviews) {
        [subView removeFromSuperview];
    }
    for (int i=0; i<[_model.picURL count]; i++) {
        
        float d = (screenW-270)/4.0;

        JRCImageView * imageView = (JRCImageView *)[self.contentView viewWithTag:i+10];
        if(!imageView){
            imageView = [[JRCImageView alloc] initWithFrame:CGRectMake(d+(i%3)*(d+90), 5+((int)(i/3))*120, 90, 110) andImageURL:nil andHoldImgNamed:nil andKeepSize:YES];
            imageView.allowResumeForFileDownloads = YES;
            imageView.tag = i+10;
            [_picView addSubview:imageView];
        }
        imageView.imageURL = [model.picURL objectAtIndex:i];
        [imageView beginLoadImage];
        
    }
    
}

-(NSString *)setTime:(NSNumber *)time{
    NSString *result;
    NSTimeInterval nowTime=[[NSDate date] timeIntervalSince1970];
    int createT = [time intValue];
    int timeSub = nowTime-createT;
    if (timeSub<60) {
        result = [NSString stringWithFormat:@"%d秒前",timeSub];
    }else if (timeSub<3600) {
        int t = timeSub%60;
        result = [NSString stringWithFormat:@"%d分钟前",t];
    }else if (timeSub<86400) {
        int t = timeSub%3600;
        result = [NSString stringWithFormat:@"%d小时前",t];
    }else {
        int t = timeSub%86400;
        result = [NSString stringWithFormat:@"%d天前",t];
    }
    return result;
    
}

@end
