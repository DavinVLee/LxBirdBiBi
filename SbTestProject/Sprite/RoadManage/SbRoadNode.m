//
//  SbRoadNode.m
//  SbTestProject
//
//  Created by 李翔 on 2017/3/3.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import "SbRoadNode.h"

@implementation SbRoadNode

+ (SbRoadNode *)nodeWithType:(SbRoadType)type
{
    SbRoadNode *node = [SbRoadNode nodeWithFileNamed:[NSString stringWithFormat:@"SbRoad%ld",type]];
    node.type = type;
    return node;
}

@end
