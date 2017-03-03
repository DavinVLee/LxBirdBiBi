//
//  SbRoadNode.h
//  SbTestProject
//
//  Created by 李翔 on 2017/3/3.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
/**
 *道路类型
 */
typedef NS_ENUM(NSInteger,SbRoadType){
    SbRoadType1 = 1,
    SbRoadType2,
    SbRoadType3,
};
@interface SbRoadNode : SKNode
/**
 *道路获取实例方法
 */
+ (SbRoadNode *)nodeWithType:(SbRoadType)type;

/**
 *道路类型
 */
@property (assign, nonatomic) SbRoadType type;

@end
