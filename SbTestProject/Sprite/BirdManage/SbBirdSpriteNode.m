//
//  SbBirdSpriteNode.m
//  SbTestProject
//
//  Created by 李翔 on 2017/3/3.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import "SbBirdSpriteNode.h"

@interface SbBirdSpriteNode()
/**
 *跳跃纹理
 */
@property (strong, nonatomic) NSMutableArray *jumpTextureArray;
/**
 *站立 问题
 */
@property (strong, nonatomic) NSMutableArray *standTextureArray;

@end

@implementation SbBirdSpriteNode

- (void)updateAnimation
{
    [self removeAllActions];
    switch (_status) {
            
        case SbBirdNormal:
        {
            [self setStandAni];
        }
            break;
            
        default:
        {
            SKAction *animation = [SKAction animateWithTextures:_jumpTextureArray timePerFrame:0.02];
            SKAction *action = [SKAction repeatActionForever:animation];
            [self runAction:action];
        }
            break;
    }
}


- (void)setStandAni
{
    SKAction *animation = [SKAction animateWithTextures:_standTextureArray timePerFrame:0.08];
    SKAction *action = [SKAction repeatActionForever:animation];
    [self runAction:action];
}

- (void)setupDefaultTexture
{
    _standTextureArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 22; i ++) {
        SKTexture *textUre = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"chicken_stay_000%d",i]];
        [_standTextureArray addObject:textUre];
    }
    
    _jumpTextureArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 15; i ++) {
        SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"chicken_jump_000%d",i]];
        [_jumpTextureArray addObject:texture];
    }
//    SKAction *animation = [SKAction animateWithTextures:_standTextureArray timePerFrame:0.1];
//    SKAction *action = [SKAction repeatActionForever:animation];
//    [self runAction:action];
}

@end
