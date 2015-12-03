//
//  SoundsViewController.m
//  MediaTest
//
//  Created by wxdtan on 15/12/2.
//  Copyright © 2015年 com.qianjiyuntong. All rights reserved.
//

#import "SoundsViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


#define kMusicPath @"/Users/wxdtan/Desktop/ios Documentation/Demo/MediaTest/Res/js.mp3"
#define kMusicAuthor @"王力宏"
#define kMusicName @"脚本"
#define kMusicPic @"wlh.jpg"



@interface SoundsViewController ()<AVAudioPlayerDelegate>{
    
    
    
}

@property (nonatomic,strong) AVAudioPlayer * audioPlayer;//player
@property (nonatomic,weak) IBOutlet UILabel * controlPanel;
@property (nonatomic,weak) IBOutlet UIProgressView * playProgress;
@property (nonatomic,weak) IBOutlet UILabel * musicSinger;
@property (nonatomic,weak) IBOutlet UIButton * playOrPause;

@property (nonatomic,weak) NSTimer * timer;
@end

@implementation SoundsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    
    
    
    
}
#pragma mark - long
- (void)singClicked:(id)sender{
    NSLog(@"sing push .");
    
    
}























#pragma mark - short
- (void)playClicked:(id)sender{
    NSLog(@"play start .");
    [self playSoundEffect:@"msg.wav"];
    
}
void soundCompleteCallback(SystemSoundID soundID,void * clientData){
    
    NSLog(@"play end ...");
}

- (void)playSoundEffect:(NSString *)name{
    
    NSString * audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL * fileUrl = [NSURL fileURLWithPath:audioFile];
    
    SystemSoundID soundID = 0;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileUrl, &soundID);
    
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    
    AudioServicesPlaySystemSound(soundID);
    
}















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
