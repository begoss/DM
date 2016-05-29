//
//  DMModel.m
//  DM
//
//  Created by OurEDA on 16/5/27.
//  Copyright (c) 2016年 OurEDA. All rights reserved.
//

#import "DMModel.h"

@implementation DMModel

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    DMModel*vi = [[DMModel alloc] init];

    
    NSEnumerator * enumerator = [dict keyEnumerator];
    id object;
    while(object = [enumerator nextObject])
    {
        NSString *cn = object;
        if ([cn isEqualToString:@"up"]) {
            NSNumber *objectValue = [dict objectForKey:object];
            if ([objectValue intValue] == 1) {
                vi.up = @"1";
            }else {
                vi.up = @"0";
            }
        }
        if ([cn isEqualToString:@"title"]) {
            id objectValue = [dict objectForKey:object];
            if(objectValue != nil)
            {
                vi.title = objectValue;
            }
        }
        if ([cn isEqualToString:@"comment_num"]) {
            NSNumber *objectValue = [dict objectForKey:object];
            if(objectValue != nil)
            {
                vi.commentNum = [NSString stringWithFormat:@"%@",objectValue];
                NSLog(@"comecoemcoemcoem:%@",vi.commentNum);
            }
        }
        if ([cn isEqualToString:@"create_at"]) {
            NSNumber *objectValue = [dict objectForKey:object];
            if(objectValue != nil)
            {
                vi.createTime = objectValue;
            }
        }
        if ([cn isEqualToString:@"description"]) {
            id objectValue = [dict objectForKey:object];
            if(objectValue != nil)
            {
                vi.descrpt = objectValue;
            }
        }
        if ([cn isEqualToString:@"imgs"]) {
            id objectValue = [dict objectForKey:object];
            if(objectValue != nil)
            {
                vi.picURL = objectValue;
                NSLog(@"pic:::::%@",vi.picURL);
            }
        }
        if ([cn isEqualToString:@"user"]) {
            NSDictionary *objectValue = [dict objectForKey:object];
            NSEnumerator * enumerator2 = [objectValue keyEnumerator];
            id object2;
            while(object2 = [enumerator2 nextObject])
            {
                NSString *obj = object2;
                if ([obj isEqualToString:@"avartar"]) {
                    id objectV = [objectValue objectForKey:object2];
                    if(objectV != nil)
                    {
                        vi.icon = objectV;
                    }
                }
                if ([obj isEqualToString:@"username"]) {
                    id objectV = [objectValue objectForKey:object2];
                    if(objectV != nil)
                    {
                        vi.name = objectV;
                    }
                }
                if ([obj isEqualToString:@"is_bbs_manager"]) {
                    NSNumber *objectV = [objectValue objectForKey:object2];
                    if ([objectV intValue] == 1) {
                        vi.isManager = @"版主";
                    }else {
                        vi.isManager = @"";
                    }

                }
                if ([obj isEqualToString:@"bbs_level"]) {
                    NSDictionary *objectV = [objectValue objectForKey:object2];
                    NSEnumerator * enumerator3 = [objectV keyEnumerator];
                    id object3;
                    while(object3 = [enumerator3 nextObject])
                    {
                        NSString *obj2 = object3;
                        if ([obj2 isEqualToString:@"title"]) {
                            id objectV2 = [objectV objectForKey:object3];
                            if(objectV2 != nil)
                            {
                                vi.userLevel = objectV2;
                                NSLog(@"vi.userLevel:%@",vi.userLevel);
                            }
                        }
                    }
                }
            }
        }
    }
    return vi;
}

@end
