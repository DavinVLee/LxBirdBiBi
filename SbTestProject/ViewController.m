//
//  ViewController.m
//  SbTestProject
//
//  Created by 李翔 on 2017/2/28.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import "ViewController.h"
#import "EZAudio.h"
#import "MacroDefine.h"
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>
#import "GameScene.h"

@interface ViewController () <EZMicrophoneDelegate,
                              UIPickerViewDataSource,
                              UIPickerViewDelegate>\

/**
 *游戏场景
 */
@property (strong, nonatomic) GameScene *scene;



/************************音频部分****************/
/**
 *音谱绘图设备
 */
@property (weak, nonatomic) IBOutlet EZAudioPlot *audioPlot;
/**
 *所有输入设备
 */

@property (nonatomic, strong) NSArray *inputs;

/*
 *采样设备
 */
@property (nonatomic, strong) EZMicrophone *microphone;
@end

@implementation ViewController

#pragma  mark - init

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self gameScenceSetupDefault];
    [self audioSetupDefault];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setupDefault
{

}

- (void)audioSetupDefault
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
    }
    [session setActive:YES error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
    }
    
//    self.audioPlot.backgroundColor = [UIColor greenColor];
    self.audioPlot.backgroundColor = [UIColor clearColor];
    //音谱类型
    self.audioPlot.plotType = EZPlotTypeRolling;
    self.audioPlot.shouldFill = YES;
    self.audioPlot.shouldMirror = YES;
    [self.view addSubview:self.audioPlot];
    //
    // Background color
    //
   // self.audioPlot.backgroundColor = [UIColor colorWithRed:0.984 green:0.471 blue:0.525 alpha:1.0];
    
    //
    // Waveform color
    //
    self.audioPlot.color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];

    
    
    //
    // Create the microphone
    //
    self.microphone = [EZMicrophone microphoneWithDelegate:self];
    
    //
    // Set up the microphone input UIPickerView items to select
    // between different microphone inputs. Here what we're doing behind the hood
    // is enumerating the available inputs provided by the AVAudioSession.
    //
    self.inputs = [EZAudioDevice inputDevices];

    
    //
    // Start the microphone
    //
    [self.microphone startFetchingAudio];

}

- (void)gameScenceSetupDefault
{
    // Load the SKScene from 'GameScene.sks'
    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    
    // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKView *skView = (SKView *)self.view;
    
    // Present the scene
    [skView presentScene:scene];
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    self.scene = scene;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UIPickerViewDataSource
//------------------------------------------------------------------------------

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//------------------------------------------------------------------------------

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    EZAudioDevice *device = self.inputs[row];
    return device.name;
}

//------------------------------------------------------------------------------

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView
             attributedTitleForRow:(NSInteger)row
                      forComponent:(NSInteger)component
{
    EZAudioDevice *device = self.inputs[row];
    UIColor *textColor = [device isEqual:self.microphone.device] ? self.audioPlot.backgroundColor : [UIColor blackColor];
    return  [[NSAttributedString alloc] initWithString:device.name
                                            attributes:@{ NSForegroundColorAttributeName : textColor }];
}

//------------------------------------------------------------------------------

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.inputs.count;
}

//------------------------------------------------------------------------------

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    EZAudioDevice *device = self.inputs[row];
    [self.microphone setDevice:device];
}

#pragma mark - EZMicrophoneDelegate
#warning Thread Safety
//
// Note that any callback that provides streamed audio data (like streaming
// microphone input) happens on a separate audio thread that should not be
// blocked. When we feed audio data into any of the UI components we need to
// explicity create a GCD block on the main thread to properly get the UI
// to work.
//
- (void)microphone:(EZMicrophone *)microphone
  hasAudioReceived:(float **)buffer
    withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels
{
    //
    //     Getting audio data as an array of float buffer arrays. What does that mean?
    //     Because the audio is coming in as a stereo signal the data is split into
    //     a left and right channel. So buffer[0] corresponds to the float* data
    //     for the left channel while buffer[1] corresponds to the float* data
    //     for the right channel.
    //
    //
    //
    //     See the Thread Safety warning above, but in a nutshell these callbacks
    //     happen on a separate audio thread. We wrap any UI updating in a GCD block
    //     on the main thread to avoid blocking that audio flow.
    //
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        //
        //         All the audio plot needs is the buffer data (float*) and the size.
        //         Internally the audio plot will handle all the drawing related code,
        //         history management, and freeing its own resources.
        //         Hence, one badass line of code gets you a pretty plot :)
        //
        //        NSLog(@"buffer 0 = %f  bufferSize = %u",**buffer,(unsigned int)bufferSize);
        float rms = [weakSelf.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
        [self.scene updateActionWithVoiceForce:rms/10000.f];
    });
}

//------------------------------------------------------------------------------

- (void)microphone:(EZMicrophone *)microphone hasAudioStreamBasicDescription:(AudioStreamBasicDescription)audioStreamBasicDescription
{
    //
    // The AudioStreamBasicDescription of the microphone stream. This is useful
    // when configuring the EZRecorder or telling another component what
    // audio format type to expect.
    //
    [EZAudioUtilities printASBD:audioStreamBasicDescription];
}

//------------------------------------------------------------------------------

- (void)microphone:(EZMicrophone *)microphone
     hasBufferList:(AudioBufferList *)bufferList
    withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels
{
    //
    // Getting audio data as a buffer list that can be directly fed into the
    // EZRecorder or EZOutput. Say whattt...
    //
}

//------------------------------------------------------------------------------

- (void)microphone:(EZMicrophone *)microphone changedDevice:(EZAudioDevice *)device
{
    NSLog(@"Microphone changed device: %@", device.name);
    
    //
    // Called anytime the microphone's device changes
    //
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *name = device.name;
        NSString *tapText = @" (Tap To Change)";
        NSString *microphoneInputToggleButtonText = [NSString stringWithFormat:@"%@%@", device.name, tapText];
        NSRange rangeOfName = [microphoneInputToggleButtonText rangeOfString:name];
        NSMutableAttributedString *microphoneInputToggleButtonAttributedText = [[NSMutableAttributedString alloc] initWithString:microphoneInputToggleButtonText];
        [microphoneInputToggleButtonAttributedText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13.0f] range:rangeOfName];

        
        //
        // Reset the device list (a device may have been plugged in/out)
        //
        weakSelf.inputs = [EZAudioDevice inputDevices];
    });
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
