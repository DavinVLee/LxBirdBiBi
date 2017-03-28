//
//  GameDefines.h
//  SbTestProject
//
//  Created by 李翔 on 2017/3/8.
//  Copyright © 2017年 李翔. All rights reserved.
//

#ifndef GameDefines_h
#define GameDefines_h

/**
 *碰撞物体类型
 */
static const uint32_t BirdCategory = 0x1;
static const uint32_t RoadCategory = 0x1 << 1;
static const uint32_t MonsterCategory = 0x1 <<2;

//游戏进行状态
typedef NS_ENUM(NSInteger, GameStatus){
    GameNormal,//游戏进行中，发声进行跳跃
    GameHorSideTouch,//小鸟与道路横向接触时，发声则停滞空中，不发生则下落
    GameOver,//游戏结束，不进行动作
};

/**
 *节点name
 */
#define kBirdName @"bird"//小鸟
#define kBackGroundSunName @"BackGroundSunName"//太阳
#define kGameScoreLabelName @"GameScoreLabelName"//分数显示
#define kRoadBgName @"RoadBg"//道路背景
#define kBird_smaName @"bird_sma"//进度条小鸟
#define kPlayBtnName  @"startBtn"//开始按钮
#define kBeginAniTitleName @"BeginAnimationBg"//开始页面标题
#define kGameOverName @"gameOver" //游戏结束页面


#define kBackBtnName @"backBtnName"//回退按钮
#define kGameRefreshName @"GameRefresh"//刷新按钮


#define kDefaultFontName @"HYLeMiaoTiW"//默认喵体字体

/*******************8关于位置及UI大小信息*******************/
#define kBirdOriginalPosition



#endif /* GameDefines_h */
