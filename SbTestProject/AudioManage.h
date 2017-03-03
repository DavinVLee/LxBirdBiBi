//
//  AudioManage.h
//  SbTestProject
//
//  Created by 李翔 on 2017/3/2.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AudioVolumeBlock)(double rms);

@interface AudioManage : NSObject
/**
 *音频采集回调
 */
@property (copy, nonatomic) AudioVolumeBlock block;

/**
 *开始采集音频
 */
- (void)startAudioColloect:(AudioVolumeBlock)block;
/**
 *停止音频采集
 */
- (void)stopAudioCollect;


@end
