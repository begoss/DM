//
//  ViewController.m
//  DM
//
//  Created by OurEDA on 16/5/27.
//  Copyright (c) 2016年 OurEDA. All rights reserved.
//

#import "ViewController.h"
#import "LXSegmentScrollView.h"

static NSString*IDD = @"AA";

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
/**
 *  数据源
 */
@property(nonatomic,strong)NSMutableArray * dataArray;
/**
 *  数据源对应cell高度
 */
@property(nonatomic,strong)NSMutableArray * frameArray;
/**
 *  tableView
 */
@property(nonatomic,weak)UITableView * tab;

@end

@implementation ViewController
#pragma mark ------------------ 获取数据源（模型数据源、模型高度数据源） ------------------
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [DMModelGroup groupWithNameOfContent:@"data.json"];
        _frameArray = [DMFrameModel frameModelWithArray:_dataArray];
    }
    return _dataArray;
}
#pragma mark ------------------ viewDidLoad ------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *array=[NSMutableArray array];
    
    UITableView*vi = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    vi.delegate = self;
    vi.dataSource = self;
    [self.view addSubview:vi];
    [vi registerClass:[DMCell class] forCellReuseIdentifier:IDD];
    self.tab = vi;
    
    [array addObject:self.tab];
    
    for (int i =0; i<2; i++) {
        UIView *view=[[UIView alloc] init];
        if (i==0) {
            view.backgroundColor=[UIColor yellowColor];
        }if (i==1) {
            view.backgroundColor=[UIColor greenColor];
        }
        [array addObject:view];
    }
    
    LXSegmentScrollView *scView=[[LXSegmentScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) titleArray:@[@"社区",@"新闻",@"竞猜"] contentViewArray:array];
    [self.view addSubview:scView];
}

#pragma mark ------------------ tableViewDelegate ------------------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DMCell *cell = [tableView dequeueReusableCellWithIdentifier:IDD ];
    if (cell == nil) {
        cell = [[DMCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: IDD];
    }
    
    DMModel *model = (self.dataArray)[indexPath.row];
    DMFrameModel *frameModel = (self.frameArray)[indexPath.row];
    
    cell.model = model;
    cell.frameModel = frameModel;
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DMFrameModel*mo = [_frameArray objectAtIndex:indexPath.row];
    return mo.cellHeight;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end

