//
//  SbRoadNode.h
//  SbTestProject
//
//  Created by 李翔 on 2017/3/3.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameDefines.h"
/**
 *道路类型
 */
typedef NS_ENUM(NSInteger,SbRoadType){
    SbRoadType1 = 1,
    SbRoadType2,
    SbRoadType3,
};
@interface SbRoadNode : SKSpriteNode
/**
 *道路获取实例方法
 */
+ (SbRoadNode *)nodeWithType:(SbRoadType)type;
/**
 *道路刚体设置
 */
- (void)nodePhysicsBodySetup;
/**
 *获取当前道路通过分数
 **/
- (NSInteger)getScore;

/**
 *道路类型
 */
@property (assign, nonatomic) SbRoadType type;
/**
 *布置后横向位移下一个道路距离（相对于屏幕宽度的比例）
 */
@property (assign, nonatomic) float nextRoadOffsetXscale;
/**
 *道路索引
 **/
@property (assign, nonatomic) NSInteger index;
/**
 *是否已经通过并添加分数
 **/
@property (assign, nonatomic) BOOL hasFinished;
/**
 *是否终点道路
 **/
@property (assign, nonatomic)BOOL isFinishRoad;

@end
