//
//  MainScene.m
//  SbTestProject
//
//  Created by 李翔 on 2017/3/24.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import "MainScene.h"
#import "GameDefines.h"

@implementation MainScene

- (void)didMoveToView:(SKView *)view
{
    [self beginAnimation];
}

#pragma mark - Function
- (void)beginAnimation
{
    SKNode *beginBg = [self childNodeWithName:kBeginAniTitleName];
    SKSpriteNode *PlayBtn = (SKSpriteNode *)[self childNodeWithName:kPlayBtnName];
    beginBg.xScale = 0;
    beginBg.yScale = 0;
    beginBg.alpha = 1;
    PlayBtn.alpha = 0;
    [beginBg runAction:[SKAction rotateByAngle:M_PI * 2 * 2 duration:0.8]];
    [beginBg runAction:[SKAction scaleTo:1 duration:0.8] completion:^{
        [PlayBtn runAction:[SKAction repeatActionForever:[SKAction fadeAlphaTo:1.0 duration:1.0]]];
    }];
}


#pragma mark - TouchMethod
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches) {
        SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:[t locationInNode:self]];
        if ([[touchedNode name] isEqualToString:kPlayBtnName] && touchedNode.alpha == 1) {
            SKNode *beginBg = [self childNodeWithName:kBeginAniTitleName];
             [touchedNode runAction:[SKAction fadeAlphaTo:0 duration:0.1]];
            [beginBg runAction:[SKAction fadeAlphaTo:0 duration:0.1] completion:^{
                [self newGameSetupDefault];
            }];
           
        }
    }
}

#pragma mark - Function
- (void)newGameSetupDefault
{
    GameScene *game = (GameScene *)[SKScene  nodeWithFileNamed:@"GameScene"];
    game.scaleMode = SKSceneScaleModeAspectFill;
    game.sceneToReturn = self;
    
    if ([_GsSetdelegate respondsToSelector:@selector(gameSceneSet:)]) {
        [_GsSetdelegate gameSceneSet:game];
    }
    [self.view presentScene:game];
    //[self.view presentScene:game transition:[SKTransition crossFadeWithDuration:0]];
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
