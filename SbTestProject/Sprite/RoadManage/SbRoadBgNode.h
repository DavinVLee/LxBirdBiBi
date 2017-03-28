//
//  SbRoadBgNode.h
//  SbTestProject
//
//  Created by 李翔 on 2017/3/3.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SbRoadNode.h"
#import "SbMonsterNode.h"

@interface SbRoadBgNode : SKSpriteNode
/**
 *初始化道路
 *@param index （道路类型，统一命名RoadMap -》index
 *@return 道路总长度
 */
- (CGFloat)setupDefaultRoadWithMapIndex:(NSInteger)index;
/**
 *道路重置
 **/
- (void)resetDefault;

@end
