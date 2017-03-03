//
//  AudioManageBridge.m
//  SbTestProject
//
//  Created by 李翔 on 2017/3/2.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import "AudioManage.h"

AudioManage *manage = nil;
extern "C"
{
    void ManageInit()
    {
        if (!manage)
            manage = [[AudioManage alloc] init];
        [manage startAudioColloect:^(double rms) {
           //此处实时传入音频大小，以个位数为单位，，向unity发送数据 double 类型
        }];
    }

    
    void stopAudio()
    {
        [manage stopAudioCollect];
    }
    
    
}
