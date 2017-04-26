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
#import "GameScoreNode.h"



#define kRoadOffsetMinX 2.75
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
 *游戏分数
 **/
@property (assign, nonatomic) NSInteger GameScore;

/**
 *道路总长度
 */
@property (assign, nonatomic) CGFloat roadTotalLength;
/**
 *道路其实x
 */

/***************************************************添加按键实现动作*********************************/
@property (assign, nonatomic) CGFloat roadOriginX;

/**
 *按键进行行走
 **/
@property (assign, nonatomic) BOOL walkState;
/**
 *按键进行跳跃
 */
@property (assign, nonatomic) BOOL jumpState;

@end

@implementation GameScene {
     /**
      *手指点击粒子效果
      **/
    SKEmitterNode *touchEmitterNode;
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
    self.GameScore = 0;
    self.physicsWorld.gravity = CGVectorMake(0, - 0.6);
    //小鸟设置
    _birdNode = (SbBirdSpriteNode *)[self childNodeWithName:kBirdName];
    _birdNode.status = SbBirdStatic;
    [_birdNode setupDefaultTexture];
    
    [_birdNode runAction:[SKAction fadeAlphaTo:1 duration:1.0] completion:^{
        _birdNode.physicsBody.dynamic = YES;
        [_birdNode updateAnimation];
    }];
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
    
    [self alphaAnimationSetup];
    //    设置手势点击效果

    //手指touch粒子配置
    NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"EmitterFireFilesStar" ofType:@"sks"];
    touchEmitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
    touchEmitterNode.targetNode = self;
    [touchEmitterNode runAction:[SKAction sequence:@[[SKAction waitForDuration:0.95],
                                                     [SKAction removeFromParent],]]];
    
}

- (void)alphaAnimationSetup
{
    for (SKNode *node in self.children) {
        if (node != _birdNode || node != _roadBgNode) {
            [node runAction:[SKAction fadeAlphaTo:1.0 duration:1.0]];
        }
    }
}




#pragma mark - ContactDelegate
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (contact.bodyB.categoryBitMask == BirdCategory && contact.bodyA.categoryBitMask == RoadCategory) {
        NSLog(@"小鸟与道路碰撞了");
        
        if (contact.contactNormal.dx != 0 && contact.contactNormal.dy == 0 && _birdNode.status == SbBirdDrop) {//说明有横向碰撞，游戏结束
            _status = GameHorSideTouch;
            return;
        }else
        {
            SbRoadNode *roadNode;
            if ([[contact.bodyA node] isKindOfClass:[SbRoadNode class]]) {
                roadNode = (SbRoadNode *)[contact.bodyA node];
            }else
            {
                roadNode = (SbRoadNode *)[contact.bodyB node];
                
            }
            
            if (_birdNode.status == SbBirdStatic &&
                             _status == GameOver &&
                      roadNode.index == 0/*当前碰撞道路为第一个时*/) {
                _status = GameNormal;
                self.physicsWorld.gravity = CGVectorMake(0, - 4.5);
                _birdNode.alpha = 1;
                self.GameScore = 0;
            }
            else if(!roadNode.hasFinished && roadNode.index > 0)//避免重复添加分数
            {
                self.GameScore = _GameScore + [roadNode getScore];
                
           
                if (roadNode.isFinishRoad) {//到达终点
                    [self gameFinishWithLastRoad:roadNode];
                    return;
                }
            }
             self.physicsWorld.gravity = CGVectorMake(0, - 4.5);
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
    
    double volumeForce = 0;
    
    if (self.jumpState) {
        volumeForce = 3.5;
    }
    if (self.jumpState) {
        volumeForce = 10;
    }else if (self.walkState)
    {
        volumeForce = 2.5;
    }
    
    switch (_status) {
        case GameOver:
        {
            return;
        }
            break;
        case GameHorSideTouch:
        {
            if (volumeForce > 1 && _birdNode.physicsBody.affectedByGravity) {
                _birdNode.physicsBody.affectedByGravity = NO;
            }else if(!_birdNode.physicsBody.affectedByGravity || volumeForce <= 1){
                _birdNode.physicsBody.affectedByGravity = YES;
            }
            return;
        }
            break;
        default:
            break;
    }
    
    if (_birdNode.status == SbBirdStatic) {
        return;
    }
    
    if (volumeForce <= 1) {//声音过小，
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
            }else if (_birdNode.physicsBody.allContactedBodies.count > 0)//此时说明小鸟至少有一个碰撞体，则切换正常状态
            {
                _birdNode.status = SbBirdNormal;
                [_birdNode updateAnimation];
            }
        }
        _voiceToJumoTime = 0;
        return;
    }else if (volumeForce <= 3.5) { //表示行走状态
        CGFloat scrollForce = volumeForce/3 * kRoadOffsetMinX;
        if (_birdNode.status == SbBirdNormal ) {
            _birdNode.status = SbBirdWalking;
            [_birdNode updateAnimation];
        }
        [self roadScrollWithOffsetX:_roadBgNode.position.x - scrollForce];
        
    }else
    {
        if (_birdNode.status <= SbBirdJump) {
            NSLog(@"跳跃力量%f",MIN(kBirdJumpMaxForce, (volumeForce - 3.5) / 5 * kBirdJumpMaxForce));
            
            [_birdNode.physicsBody applyForce:CGVectorMake(0, MIN(kBirdJumpMaxForce, (volumeForce - 3.5) / 5 * kBirdJumpMaxForce))];
            _birdNode.status = SbBirdJump;
            [_birdNode updateAnimation];
        }
        [self roadScrollWithOffsetX:_roadBgNode.position.x - kRoadOffsetMinX];
        
    }
}

#pragma mark - SetMethod
- (void)setGameScore:(NSInteger)GameScore
{
    _GameScore = GameScore;
    SKLabelNode *scoreLabelNode = (SKLabelNode *)[self childNodeWithName:kGameScoreLabelName];
    scoreLabelNode.text = [NSString stringWithFormat:@"%ld",GameScore];
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
    GameOverNode *overNode = (GameOverNode *)[self childNodeWithName:kGameOverName];
    if (!overNode) {
        self.physicsWorld.gravity = CGVectorMake(0, - 0.6);
        overNode = [GameOverNode getDefaultOverNode:^(NSInteger index) {
            [self gameRefresh];
        }];
        overNode.size = self.size;
        [self addChild:overNode];
        
        overNode.name = kGameOverName;
        
    }
}
//游戏重新开始
- (void)gameRefresh
{
    _birdNode.physicsBody.dynamic = NO;
    [_birdNode resetTexture];
    _birdNode.alpha = 0;
    _birdNode.position = CGPointMake(-198.7, 81.9);
    self.GameScore = 0;
    _voiceToJumoTime = 0;
    _birdNode.status = SbBirdStatic;//此时静止直至落地后可操作
    [_birdNode runAction:[SKAction fadeAlphaTo:1 duration:0.6] completion:^{
        _birdNode.physicsBody.dynamic = YES;
        [_birdNode updateAnimation];
        _birdNode.physicsBody.collisionBitMask = ~MonsterCategory;
    }];
    
    SKSpriteNode *bird_sma = (SKSpriteNode *)[self childNodeWithName:kBird_smaName];
    bird_sma.position = CGPointMake(180, -164);
    SbRoadBgNode *roadBg = (SbRoadBgNode *)[self childNodeWithName:kRoadBgName];
    [roadBg runAction:[SKAction moveToX:-self.size.width/2.f duration:0.2]];
    [roadBg resetDefault];

}

//游戏胜利
- (void)gameFinishWithLastRoad:(SbRoadNode *)road
{
    _birdNode.status = SbBirdStatic;
    _status = GameOver;
   
    CGFloat offsetx = [_roadBgNode convertPoint:road.position toNode:self].x;
    [_birdNode gameSuccessWithOffsetX:offsetx];

    
}


#pragma mark - ClickAction
- (void)clickBackBtn:(SKNode *)node
{
    [self.view presentScene:self.sceneToReturn transition:[SKTransition crossFadeWithDuration:0.7]];
    [self runAction:[SKAction fadeAlphaTo:0 duration:1.0] completion:^{
        
        [self removeAllActions];
        [self removeFromParent];
    }];
}

#pragma mark - touchAction

- (void)touchDownAtPoint:(CGPoint)pos {
    SKEmitterNode *n = [touchEmitterNode copy];
    n.position = pos;
    n.particleTexture = [SKTexture textureWithImageNamed:@"SbStar4"];
    [n performSelector:@selector(setPaused:) withObject:@(YES) afterDelay:0.2];
    [self addChild:n];
}

- (void)touchMovedToPoint:(CGPoint)pos {
    SKEmitterNode *n = [touchEmitterNode copy];
    n.position = pos;
    [n performSelector:@selector(setPaused:) withObject:@(YES) afterDelay:0.2];
    [self addChild:n];
}

- (void)touchUpAtPoint:(CGPoint)pos {
    SKEmitterNode *n = [touchEmitterNode copy];
    n.position = pos;
    n.particleTexture = [SKTexture textureWithImageNamed:@"SbStar2"];
    [n performSelector:@selector(setPaused:) withObject:@(YES) afterDelay:0.2];
    [self addChild:n];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *t in touches) {
        SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:[t locationInNode:self]];
        if ([[touchedNode name] isEqualToString:@"jumpBtn"])
        {
            self.jumpState = YES;
        }else if ([[touchedNode name] isEqualToString:@"walkBtn"])
        {
            self.walkState = YES;
        }
        else if ([[touchedNode name] isEqualToString:kBackBtnName])
        {
            [self clickBackBtn:touchedNode];
        }else if ([[touchedNode name] isEqualToString:kGameRefreshName])
        {
            _status = GameOver;
            NSLog(@"游戏结束了");
            self.walkState = NO;
            self.jumpState = NO;
            self.physicsWorld.gravity = CGVectorMake(0, - 0.6);
            [self gameRefresh];
        }
        else
        {
            [self touchDownAtPoint:[t locationInNode:self]];
        }
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:[t locationInNode:self]];
        if ([[touchedNode name] isEqualToString:@"jumpBtn"])
        {
            self.jumpState = NO;
        }else if ([[touchedNode name] isEqualToString:@"walkBtn"])
        {
            self.walkState = NO;
        }else
        {
            [self touchUpAtPoint:[t locationInNode:self]];
        }
        
    }
    self.jumpState = NO;
    self.walkState = NO;
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}


-(void)update:(CFTimeInterval)currentTime {
    if (_status == GameOver) {
        return;
    }
    
    if (_birdNode.position.y <=  - self.size.height/2.f && _status != GameOver) {
        _status = GameOver;
        NSLog(@"游戏结束了");
        self.walkState = NO;
        self.jumpState = NO;
        [self gameOverWithPoint:_birdNode.position];
        return;
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
