//
//  SbBirdSpriteNode.m
//  SbTestProject
//
//  Created by 李翔 on 2017/3/3.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import "SbBirdSpriteNode.h"
#import "GameDefines.h"

@interface SbBirdSpriteNode()
/**
 *跳跃纹理
 */
@property (strong, nonatomic) NSMutableArray *jumpTextureArray;
/**
 *站立 问题
 */
@property (strong, nonatomic) NSMutableArray *standTextureArray;
/**
 *行走纹理
 */
@property (strong, nonatomic) NSMutableArray *walkTextureArray;

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
            case SbBirdWalking:
        {
            SKAction *animation = [SKAction animateWithTextures:_jumpTextureArray timePerFrame:0.04];
            SKAction *action = [SKAction repeatActionForever:animation];
            [self runAction:action];
        }
            break;
            case SbBirdStatic:
        {
            SKAction *animation = [SKAction animateWithTextures:_jumpTextureArray timePerFrame:0.03];
            SKAction *action = [SKAction repeatActionForever:animation];
            [self runAction:action];

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
    self.physicsBody.linearDamping = 1.0;//移动时的摩擦
    self.physicsBody.allowsRotation = NO;//允许旋转
    self.physicsBody.restitution = 0;//从另一个物体弹出时剩余多少能量
    self.physicsBody.density = 1.0;//密度的倍数默认为1；
    self.physicsBody.affectedByGravity = YES;
    self.physicsBody.contactTestBitMask = RoadCategory | MonsterCategory;
    self.physicsBody.categoryBitMask = BirdCategory;
    self.physicsBody.collisionBitMask = ~MonsterCategory;
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
    
//    self.walkTextureArray = [NSMutableArray arrayWithArray:@[[SKTexture textureWithImageNamed:@"chicken_walk1"],
//                                                             [SKTexture textureWithImageNamed:@"chicken_walk2"]]];

}

#pragma mark - CallFunction
- (void)gameSuccess
{
    [self removeAllActions];
    SKSpriteNode *successBg = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"SbGameFinishBg"]];
    [self addChild:successBg];
    
    self.texture = [SKTexture textureWithImageNamed:@"chicken_success"];
    
}

- (void)resetTexture
{
    [self runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"chicken_stay_0000"]] completion:^{
        
    }];
    [self removeAllChildren];
}



@end
