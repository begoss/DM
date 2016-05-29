//
//  DMModelGroup.m
//  DM
//
//  Created by OurEDA on 16/5/27.
//  Copyright (c) 2016年 OurEDA. All rights reserved.
//

#import "DMModelGroup.h"

@implementation DMModelGroup
+ (NSMutableArray *)groupWithNameOfContent:(NSString *)name{
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:0];

    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:name ofType:nil];

    NSData *data2=[[NSData alloc] initWithContentsOfFile:jsonPath];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableLeaves error:&error];

    NSMutableArray *infoArray = [json objectForKey:@"result"];

    
    
    for (NSDictionary*dic  in infoArray) {
        
        DMModel *mo = [DMModel modelWithDict:dic];
        [dataArr addObject: mo];
        
    }
    
    return dataArr;
}
@end
