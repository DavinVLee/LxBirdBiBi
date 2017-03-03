//
//  SbRoadBgNode.m
//  SbTestProject
//
//  Created by 李翔 on 2017/3/3.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import "SbRoadBgNode.h"

@interface SbRoadBgNode ()
/**
 *道路容器
 */
@property (strong, nonatomic) NSMutableArray *roadNodeArray;


@end

@implementation SbRoadBgNode

#pragma mark - CallFunction
- (void)setupDefaultRoadWithMapIndex:(NSInteger)index
{
    NSDictionary *rootInfoDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"RoadManageInfo" ofType:@"plist"]];
    NSArray *mapInfo = rootInfoDic[[NSString stringWithFormat:@"RoadMap%ld",index]];
    
}

@end
