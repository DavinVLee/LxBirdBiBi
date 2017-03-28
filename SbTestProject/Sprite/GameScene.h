//
//  GameScene.h
//  SbSpriteProject
//
//  Created by 李翔 on 2017/3/2.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene

/**
 *需要返回到的场景
 */
@property (weak, nonatomic) SKScene *sceneToReturn;

- (void)updateActionWithVoiceForce:(double)force;

@end
