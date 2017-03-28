//
//  SbBirdSpriteNode.h
//  SbTestProject
//
//  Created by 李翔 on 2017/3/3.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger, SbBirdStatus){
    SbBirdNormal,//表示静止状态
    SbBirdWalking,//表示行走状态
    SbBirdJump,//表示跳跃状态
    SbBirdDrop,//表示下落状态
    SbBirdStatic,//表示静止，不做任何操作
};

@interface SbBirdSpriteNode : SKSpriteNode
/**
 *小鸟运动状态
 */
@property (assign, nonatomic) SbBirdStatus status;


/**
 *初始化纹理
 */
- (void)setupDefaultTexture;

- (void)updateAnimation;
/**
 *重置纹理
 **/
- (void)resetTexture;


/**
 *小鸟成功动画
 **/
- (void)gameSuccess;

@end
