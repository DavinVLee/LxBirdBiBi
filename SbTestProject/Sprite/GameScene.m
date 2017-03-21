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
#import "GameOverNode.h"

#define kRoadOffsetMinX 2.5
#define kBirdJumpMaxForce 1700  //default = 7000
@interface GameScene ()<SKPhysicsContactDelegate>

@property (strong, nonatomic) NSMutableArray *roadArray;

@property (assign, nonatomic) NSTimeInterval voiceToJumoTime;


@property (assign, nonatomic) NSTimeInterval currentTime;
/**
 *游戏状态
 */
@property (assign, nonatomic) GameStatus status;

/**
 *道路总长度
 */
@property (assign, nonatomic) CGFloat roadTotalLength;
/**
 *道路其实x
 */
@property (assign, nonatomic) CGFloat roadOriginX;

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
    /**
     *进度小鸟
     */
    SKSpriteNode *_bird_smaNode;
}

- (void)didMoveToView:(SKView *)view {
    
    _status = GameOver;
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0, -4.5);
     //小鸟设置
    _birdNode = (SbBirdSpriteNode *)[self childNodeWithName:kBirdName];
//    _birdNode.physicsBody = [SKPhysicsBody bodyWithTexture:_birdNode.texture size:_birdNode.texture.size];
    _birdNode.physicsBody.dynamic = NO;
    _birdNode.physicsBody.linearDamping = 1.0;//移动时的摩擦
    _birdNode.physicsBody.allowsRotation = NO;//允许旋转
    _birdNode.physicsBody.restitution = 0;//从另一个物体弹出时剩余多少能量
    _birdNode.physicsBody.density = 1.0;//密度的倍数默认为1；
    _birdNode.physicsBody.affectedByGravity = YES;
    _birdNode.physicsBody.contactTestBitMask = RoadCategory | MonsterCategory;
    _birdNode.physicsBody.categoryBitMask = BirdCategory;
    _birdNode.physicsBody.collisionBitMask = ~MonsterCategory;
    _birdNode.status = SbBirdDrop;
    [_birdNode setupDefaultTexture];
    _birdNode.status = SbBirdNormal;
    [_birdNode updateAnimation];
    //进度条
    _bird_smaNode = (SKSpriteNode *)[self childNodeWithName:kBird_smaName];
    
    
      _voiceToJumoTime = 0;
    //设置道路背景
    _roadBgNode = (SbRoadBgNode *)[self childNodeWithName:kRoadBgName];
    _roadBgNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(10, 10)];
    _roadBgNode.physicsBody.affectedByGravity = NO;
    _roadBgNode.physicsBody.dynamic = YES;
    _roadTotalLength = [_roadBgNode setupDefaultRoadWithMapIndex:1];
    _roadOriginX = _roadBgNode.position.x;
    
    
//    设置手势点击效果
    
    CGFloat w = (self.size.width + self.size.height) * 0.05;
    _spinnyNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w, w) cornerRadius:w * 0.3];
    _spinnyNode.lineWidth = 2.5;
    
    [_spinnyNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:1]]];
    [_spinnyNode runAction:[SKAction sequence:@[
                                                [SKAction waitForDuration:0.5],
                                                [SKAction fadeOutWithDuration:0.5],
                                                [SKAction removeFromParent],
                                                ]]];
    
//    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    but.backgroundColor = [UIColor redColor];
//    but.userInteractionEnabled = YES;
//    [but addTarget:self action:@selector(leftButClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:but];
    [self beginAnimation];
//    self.view.userInteractionEnabled = YES;
//}
//
//- (void)leftButClick:(UIButton *)but
//{
//    NSLog(@"点击了左边按钮");
}

- (void)beginAnimation
{
    SKNode *beginBg = [self childNodeWithName:kBeginAniTitleName];
    beginBg.xScale = 0;
    beginBg.yScale = 0;
    [beginBg runAction:[SKAction rotateToAngle:M_PI * 2 * 2 duration:0.8]];
    [beginBg runAction:[SKAction scaleTo:1 duration:0.8] completion:^{
//        _birdNode.alpha = 1;
//        _birdNode.physicsBody.dynamic = YES;
        SKSpriteNode *PlayBtn = (SKSpriteNode *)[self childNodeWithName:kPlayBtnName];
        [PlayBtn runAction:[SKAction fadeAlphaTo:1 duration:0.4]];
    }];
}


#pragma mark - ContactDelegate
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (contact.bodyB.categoryBitMask == BirdCategory && contact.bodyA.categoryBitMask == RoadCategory) {
        NSLog(@"小鸟与道路碰撞了");
        if (contact.contactNormal.dx != 0 && contact.contactNormal.dy == 0 && _birdNode.status == SbBirdDrop) {//说明有横向碰撞，游戏结束
            _status = GameHorSideTouch;
            return;
        }
    }else if (contact.bodyA.categoryBitMask == BirdCategory && contact.bodyB.categoryBitMask == MonsterCategory)//小鸟碰撞怪兽，游戏结束
    {
        if (_status != GameOver) {
            _birdNode.physicsBody.collisionBitMask =  ~RoadCategory & ~MonsterCategory;
            _status = GameOver;
            [self gameOverWithPoint:_birdNode.position];
        }
        
        return;
    }
    
    
    NSLog(@"小鸟碰撞向量x = %f,y = %f",contact.contactNormal.dx,contact.contactNormal.dy);
    _birdNode.status = SbBirdNormal;
    [_birdNode updateAnimation];
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    
}

/**
 *在每一次的音频回调中分发事件
 **/
- (void)updateActionWithVoiceForce:(double)force
{
//    NSLog(@"force = %f",force);
    switch (_status) {
        case GameOver:
        {
            return;
        }
            break;
         case GameHorSideTouch:
        {
            if (force > 1 && _birdNode.physicsBody.affectedByGravity) {
              _birdNode.physicsBody.affectedByGravity = NO;
            }else if(!_birdNode.physicsBody.affectedByGravity || force <= 1){
                _birdNode.physicsBody.affectedByGravity = YES;
            }
            return;
        }
            break;
        default:
            break;
    }
    
    
    
    if (force <= 1) {//声音过小，
        if (_birdNode.status > SbBirdNormal) {
            if (_birdNode.status == SbBirdJump) {
                _birdNode.status = SbBirdDrop;//上一步骤是跳跃，所以此处为下落开始
                 [_birdNode updateAnimation];
            }else if (_birdNode.status == SbBirdWalking)
            {
                _birdNode.status = SbBirdNormal;
                 [_birdNode updateAnimation];
            }else if(_birdNode.speed == 0)
            {
                _birdNode.status = SbBirdNormal;
                [_birdNode updateAnimation];
            }
        }
        _voiceToJumoTime = 0;
        return;
    }else if (force <= 3.5) { //表示行走状态
        CGFloat scrollForce = force/3 * kRoadOffsetMinX;
        if (_birdNode.status == SbBirdNormal ) {
            _birdNode.status = SbBirdWalking;
            [_birdNode updateAnimation];
        }
        [self roadScrollWithOffsetX:_roadBgNode.position.x - scrollForce];
        
    }else
    {
        if (_birdNode.status <= SbBirdJump) {
            NSLog(@"跳跃力量%f",MIN(kBirdJumpMaxForce, (force - 3.5) / 5 * kBirdJumpMaxForce));
        
           [_birdNode.physicsBody applyForce:CGVectorMake(0, MIN(kBirdJumpMaxForce, (force - 3.5) / 5 * kBirdJumpMaxForce))];
            _birdNode.status = SbBirdJump;
            [_birdNode updateAnimation];
        }
        [self roadScrollWithOffsetX:_roadBgNode.position.x - kRoadOffsetMinX];
       
    }
}

#pragma mark - FUCTION
/**
 *道路移动
 */
- (void)roadScrollWithOffsetX:(CGFloat)offset_x
{
    if (_status == GameOver) {
        return;
    }
     _roadBgNode.position = CGPointMake(offset_x, _roadBgNode.position.y);
    _bird_smaNode.position = CGPointMake(180 + ( _roadOriginX - offset_x) / _roadTotalLength  * 125,_bird_smaNode.position.y);

}

/**
 *游戏结束时UI操作
 */
- (void)gameOverWithPoint:(CGPoint)point
{
    _status = GameOver;
    GameOverNode *overNode = [GameOverNode getDefaultOverNode:^(NSInteger index) {
        [self gameRefresh];
    }];
    overNode.size = self.size;
    [self addChild:overNode];
    
    overNode.name = kGameOverName;
}

- (void)gameRefresh
{
   
    _birdNode.position = CGPointMake(-198.7, 81.9);
    _birdNode.status = SbBirdNormal;
    [_birdNode updateAnimation];
    _voiceToJumoTime = 0;
    _birdNode.physicsBody.collisionBitMask = ~MonsterCategory;
    SKSpriteNode *bird_sma = (SKSpriteNode *)[self childNodeWithName:kBird_smaName];
    bird_sma.position = CGPointMake(180, -164);
    SKNode *roadBg = [self childNodeWithName:kRoadBgName];
    roadBg.position = CGPointMake(-self.size.width/2.f, self.size.height/2.f);
     _status = GameNormal;
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
    
    for (UITouch *t in touches) {
        SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:[t locationInNode:self]];
        if ([[touchedNode name] isEqualToString:kPlayBtnName] && touchedNode.alpha == 1)   {
             SKNode *beginBg = [self childNodeWithName:kBeginAniTitleName];
            [beginBg runAction:[SKAction fadeAlphaTo:0 duration:0.1] completion:^{
                [beginBg removeFromParent];
            }];
            [touchedNode removeFromParent];
            _birdNode.alpha = 1;
            _birdNode.physicsBody.dynamic = YES;
            _status = GameNormal;
        }else
        {
          [self touchDownAtPoint:[t locationInNode:self]];
        }
    }
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
//    CGPoint birdPosition = _birdNode.position;
//    birdPosition.x = -198.7;
//    _birdNode.position = birdPosition;
    if (_status == GameOver) {
        return;
    }
    
    if (_birdNode.position.y <=  - self.size.height/2.f) {
        NSLog(@"游戏结束了");
        
        [self gameOverWithPoint:_birdNode.position];
    } else if (_birdNode.status == SbBirdJump) {
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
