//
//  GameScene.m
//  SbSpriteProject
//
//  Created by 李翔 on 2017/3/2.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()

@property (strong, nonatomic) NSMutableArray *roadArray;

@end

@implementation GameScene {
    SKShapeNode *_spinnyNode;
//    SKLabelNode *_label;
    /**
     *小鸟精灵
     */
    SKSpriteNode *_birdNode;
    /**
     *道路父视图（负责滚动效果)
     */
    SKNode *_roadBgNode;
}

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    _birdNode = (SKSpriteNode *)[self childNodeWithName:@"bird"];
    _birdNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_birdNode.size.width, _birdNode.size.height)];
    _birdNode.physicsBody.dynamic = YES;
    _birdNode.physicsBody.linearDamping = 1.0;
    _birdNode.physicsBody.allowsRotation = NO;
    _birdNode.physicsBody.affectedByGravity = YES;
    

    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    // Get label node from scene and store it for use later
    //设置道路背景
    _roadBgNode = [SKNode node];
    
//    
    CGFloat w = (self.size.width + self.size.height) * 0.05;
//
//    // Create shape node to use during mouse interaction
    _spinnyNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w, w) cornerRadius:w * 0.3];
    _spinnyNode.lineWidth = 2.5;
    
    [_spinnyNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:1]]];
    [_spinnyNode runAction:[SKAction sequence:@[
                                                [SKAction waitForDuration:0.5],
                                                [SKAction fadeOutWithDuration:0.5],
                                                [SKAction removeFromParent],
                                                ]]];
    
    
    //小鸟设置
   
}


- (void)updateActionWithVoiceForce:(double)force
{
    NSLog(@"force = %f",force);
    if (force > 4) {
       [_birdNode.physicsBody applyForce:CGVectorMake(1000, 0)];
    }
}

#pragma mark - touchAction


- (void)touchDownAtPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor greenColor];
    [self addChild:n];
    
    
    
}

- (void)touchMovedToPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor blueColor];
    [self addChild:n];
}

- (void)touchUpAtPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor redColor];
    [self addChild:n];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Run 'Pulse' action from 'Actions.sks'
    //[_label runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
    
    for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
