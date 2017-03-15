//
//  GameOverNode.h
//  SbTestProject
//
//  Created by 李翔 on 2017/3/9.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
typedef void(^GameOverBlock)(NSInteger index);
@interface GameOverNode : SKSpriteNode

@property (copy, nonatomic) GameOverBlock block;

/**
 *获取初始node
 */
+ (GameOverNode *)getDefaultOverNode:(GameOverBlock)block;

@end
