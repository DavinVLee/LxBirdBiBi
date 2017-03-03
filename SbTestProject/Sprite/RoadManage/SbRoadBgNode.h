//
//  SbRoadBgNode.h
//  SbTestProject
//
//  Created by 李翔 on 2017/3/3.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SbRoadBgNode : SKNode
/**
 *初始化道路
 *@param index （道路类型，统一命名RoadMap -》index
 */
- (void)setupDefaultRoadWithMapIndex:(NSInteger)index;

@end
