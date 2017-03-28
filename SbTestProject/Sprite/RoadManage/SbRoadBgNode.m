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
@property (strong, nonatomic) NSMutableArray <SbRoadNode *>*roadNodeArray;


@end

@implementation SbRoadBgNode

#pragma mark - CallFunction
- (CGFloat)setupDefaultRoadWithMapIndex:(NSInteger)index
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
    SKTexture *monsterTexture = [SKTexture textureWithImageNamed:@"SbMonster"];
    NSInteger roadIndex = 0;
    for (NSDictionary *roadInfo in mapInfo) {
        
        SbRoadNode *roadNode = [SbRoadNode nodeWithType:[roadInfo[@"SbroadType"] integerValue]];
        roadNode.index = roadIndex;
        roadIndex ++;
        if (roadIndex == mapInfo.count) {
            roadNode.isFinishRoad = YES;//当前道路为终点
        }
        [self addChild:roadNode];
        roadNode.anchorPoint = CGPointMake(0.5, 0.5);
        CGSize roadSize = roadNode.frame.size;
       //暂时1 3类型的道路向下位移20，出图问题
        float offsety = [roadInfo[@"SbroadType"] integerValue] == 1 ? 0 : 20;
        
        
        roadNode.position = CGPointMake(offsetX + roadSize.width/2.f, - superNodeSize.height + roadSize.height/2.f - offsety);
        offsetX += roadSize.width;//道路位置设置
        offsetX += [roadInfo[@"nextRoadOffsetXscale"] floatValue] * superNodeSize.width;
        [_roadNodeArray addObject:roadNode];
        
        if ([roadInfo[@"Monster"] boolValue] == YES) {
            SbMonsterNode *monster = [SbMonsterNode spriteNodeWithTexture:monsterTexture];
            monster.physicsBody = [SKPhysicsBody bodyWithTexture:monsterTexture size:monsterTexture.size];
            monster.physicsBody.restitution = 0;
            monster.physicsBody.dynamic = YES;
            monster.physicsBody.affectedByGravity =YES;
            monster.physicsBody.categoryBitMask = MonsterCategory;
            monster.physicsBody.contactTestBitMask = BirdCategory;
            monster.physicsBody.collisionBitMask = ~BirdCategory;
            monster.position = CGPointMake(roadNode.size.width/2.f - monster.size.width/2.f, roadNode.size.height/2.f + 20);
            
            //此处怪物动作，后去需优化
            SKAction *action = [SKAction repeatAction:
                                [SKAction sequence:@[[SKAction moveToX:-(roadNode.size.width - monster.size.width)/2.f duration:3],
                                                                           [SKAction moveToX:(roadNode.size.width - monster.size.width)/2.f duration:3]]]
                                                count:NSNotFound]; ;
            [monster runAction:action];
            [roadNode addChild:monster];
        }

        
        //道路刚体设置
        [roadNode nodePhysicsBodySetup];
    }
    
    
    return offsetX;
    
}

- (void)resetDefault
{
    for (SbRoadNode *roadNode in self.roadNodeArray) {
        roadNode.hasFinished = NO;
    }
}

#pragma mark - GetMethod


@end
