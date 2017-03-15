//
//  GameOverNode.m
//  SbTestProject
//
//  Created by 李翔 on 2017/3/9.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import "GameOverNode.h"

@interface GameOverNode ()

@property (strong, nonatomic) SKSpriteNode *refreshBtnNode;

@end

@implementation GameOverNode

#pragma mark - GetMethod
+ (GameOverNode *)getDefaultOverNode:(GameOverBlock)block;
{
    GameOverNode *node = [GameOverNode spriteNodeWithColor:[SKColor colorWithWhite:0 alpha:0.4] size:CGSizeMake(0, 0)];
    node.anchorPoint = CGPointMake(0.5, 0.5);
    node.position = CGPointMake(0, 0);
    node.alpha = 0;
    node.block = [block copy];
    [node btnSetup];
    [node runAction:[SKAction fadeAlphaTo:1 duration:0.6]];
    return node;
}

- (void)btnSetup
{
    self.userInteractionEnabled = YES;
    
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithText:@"失败了"];
    titleLabel.fontSize = 25;
    titleLabel.fontColor = [SKColor whiteColor];
    titleLabel.position = CGPointMake(0, 40);
    [self addChild:titleLabel];
    
    
    self.refreshBtnNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"SbRefresh@2x"]];
    self.refreshBtnNode.anchorPoint = CGPointMake(0.5,0.5);
    self.refreshBtnNode.position = CGPointMake(0, -25);
    [self addChild:self.refreshBtnNode];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInNode:self];
        if (CGRectContainsPoint(self.refreshBtnNode.frame, point)) {
            if (self.block) {
                self.block(0);
                self.block = nil;
                [self runAction:[SKAction fadeAlphaTo:0 duration:0.7] completion:^{
                    [self removeFromParent];
                }];
            }
        }
    }
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
