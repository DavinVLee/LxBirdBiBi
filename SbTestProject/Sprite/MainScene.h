//
//  MainScene.h
//  SbTestProject
//
//  Created by 李翔 on 2017/3/24.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"
@protocol MainSceneDelegate <NSObject>

@optional

/**
 *在每次推出游戏视图时赋值、
 */
- (void)gameSceneSet:(GameScene *)scene;

@end

@interface MainScene : SKScene

/**
 *主视图代理
 **/
@property (weak, nonatomic) id<MainSceneDelegate> GsSetdelegate;

@end
