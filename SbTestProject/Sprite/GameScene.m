//
//  GameScene.m
//  SbSpriteProject
//
//  Created by 李翔 on 2017/3/2.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import "GameScene.h"
#import "SbRoadBgNode.h"
#import "SbBirdSpriteNode.h"


#define kRoadOffsetMinX 2.5
#define kBirdJumpMaxForce 1700  //default = 7000
@interface GameScene ()<SKPhysicsContactDelegate>

@property (strong, nonatomic) NSMutableArray *roadArray;

@property (assign, nonatomic) NSTimeInterval voiceToJumoTime;


@property (assign, nonatomic) NSTimeInterval currentTime;

@end

@implementation GameScene {
    SKShapeNode *_spinnyNode;
//    SKLabelNode *_label;
    /**
     *小鸟精灵
     */
    SbBirdSpriteNode *_birdNode;
    /**
     *道路父视图（负责滚动效果)
     */
    SbRoadBgNode *_roadBgNode;
}

- (void)didMoveToView:(SKView *)view {
    
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0, -4.5);
    // Setup your scene here
    _birdNode = (SbBirdSpriteNode *)[self childNodeWithName:@"bird"];
    _birdNode.physicsBody = [SKPhysicsBody bodyWithTexture:_birdNode.texture size:_birdNode.texture.size];
    _birdNode.physicsBody.dynamic = YES;
    _birdNode.physicsBody.linearDamping = 1.0;//移动时的摩擦
    _birdNode.physicsBody.allowsRotation = NO;//允许旋转
    _birdNode.physicsBody.restitution = 0;//从另一个物体弹出时剩余多少能量
    _birdNode.physicsBody.density = 1.0;//密度的倍数默认为1；
    _birdNode.physicsBody.affectedByGravity = YES;
    _birdNode.physicsBody.contactTestBitMask = 2;
    _birdNode.physicsBody.categoryBitMask = 1;
    _birdNode.physicsBody.collisionBitMask = 3;
    [_birdNode setupDefaultTexture];
    _birdNode.status = SbBirdNormal;
    [_birdNode updateAnimation];
    
    
      _voiceToJumoTime = 0;
    
    
//    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    // Get label node from scene and store it for use later
    //设置道路背景
    _roadBgNode = (SbRoadBgNode *)[self childNodeWithName:@"RoadBg"];
    _roadBgNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(10, 10)];
    _roadBgNode.physicsBody.affectedByGravity = NO;
    _roadBgNode.physicsBody.dynamic = YES;
    [_roadBgNode setupDefaultRoadWithMapIndex:1];
//    
    CGFloat w = (self.size.width + self.size.height) * 0.05;
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
#pragma mark - ContactDelegate
- (void)didBeginContact:(SKPhysicsContact *)contact
{
//    _birdNode.status = SbBirdNormal;
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    
}


- (void)updateActionWithVoiceForce:(double)force
{
//    NSLog(@"force = %f",force);
    if (force <= 1) {//声音过小，
        if (_birdNode.status > SbBirdNormal) {
           _birdNode.status = SbBirdNormal;
            [_birdNode updateAnimation];
        }
        
        _voiceToJumoTime = 0;
        return;
    }else if (force <= 3.5) { //表示行走状态
        CGFloat scrollForce = force/3 * kRoadOffsetMinX;
        if (_birdNode.status != SbBirdWalking) {
            _birdNode.status = SbBirdWalking;
            [_birdNode updateAnimation];
        }
        _roadBgNode.position = CGPointMake(_roadBgNode.position.x - scrollForce, _roadBgNode.position.y);
        
    }else
    {
        if (_birdNode.status <= SbBirdJump) {
            NSLog(@"跳跃力量%f",MIN(kBirdJumpMaxForce, (force - 3.5) / 5 * kBirdJumpMaxForce));
           [_birdNode.physicsBody applyForce:CGVectorMake(0, MIN(kBirdJumpMaxForce, (force - 3.5) / 5 * kBirdJumpMaxForce))];
            _birdNode.status = SbBirdJump;
            [_birdNode updateAnimation];
        }
        
        _roadBgNode.position = CGPointMake(_roadBgNode.position.x - kRoadOffsetMinX, _roadBgNode.position.y);
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
    
    if (_birdNode.status == SbBirdJump) {
        self.voiceToJumoTime += currentTime - self.currentTime;
        if (self.voiceToJumoTime >= 0.09) {
            _birdNode.status = SbBirdDrop;
            [_birdNode updateAnimation];
            _voiceToJumoTime = 0;
        }
    }
    self.currentTime = currentTime;
}

@end
