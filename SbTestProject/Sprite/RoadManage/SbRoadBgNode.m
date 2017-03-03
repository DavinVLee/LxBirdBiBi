//
//  SbRoadBgNode.m
//  SbTestProject
//
//  Created by 李翔 on 2017/3/3.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import "SbRoadBgNode.h"
#import "SbRoadNode.h"

@interface SbRoadBgNode ()
/**
 *道路容器
 */
@property (strong, nonatomic) NSMutableArray <SbRoadNode *>*roadNodeArray;


@end

@implementation SbRoadBgNode

#pragma mark - CallFunction
- (void)setupDefaultRoadWithMapIndex:(NSInteger)index
{
    if (_roadNodeArray) {
        for (SbRoadNode *road in self.roadNodeArray) {
            [road removeFromParent];
        }
        [_roadNodeArray removeAllObjects];
    }else
    {
        _roadNodeArray = [[NSMutableArray alloc] init];
    }
    
    
    NSDictionary *rootInfoDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"RoadManageInfo" ofType:@"plist"]];
    NSArray *mapInfo = rootInfoDic[[NSString stringWithFormat:@"RoadMap%ld",index]];
    
    CGSize superNodeSize = self.parent.frame.size;
    CGFloat offsetX = 0;
    for (NSDictionary *roadInfo in mapInfo) {
        
        SbRoadNode *roadNode = [SbRoadNode nodeWithType:[roadInfo[@"SbroadType"] integerValue]];
        [self addChild:roadNode];
        roadNode.anchorPoint = CGPointMake(0.5, 0.5);
        CGSize roadSize = roadNode.frame.size;
       //暂时1 3类型的道路向下位移20，出图问题
        float offsety = [roadInfo[@"SbroadType"] integerValue] == 1 ? 0 : 20;
        
        
        roadNode.position = CGPointMake(offsetX + roadSize.width/2.f, - superNodeSize.height + roadSize.height/2.f - offsety);
        offsetX += roadSize.width;//道路位置设置
        offsetX += [roadInfo[@"nextRoadOffsetXscale"] floatValue] * superNodeSize.width;
        [_roadNodeArray addObject:roadNode];
        
        

        
        //道路刚体设置
        [roadNode nodePhysicsBodySetup];
    }
    
    
}

#pragma mark - GetMethod


@end
