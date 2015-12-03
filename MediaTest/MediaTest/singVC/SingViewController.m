//
//  SingViewController.m
//  MediaTest
//
//  Created by wxdtan on 15/12/2.
//  Copyright © 2015年 com.qianjiyuntong. All rights reserved.
//

#import "SingViewController.h"
#import <AVFoundation/AVFoundation.h>


#define kMusicPath @"js"
#define kMusicAuthor @"王力宏"
#define kMusicName @"脚本"
#define kMusicPic @"wlh.jpg"

@interface SingViewController ()<AVAudioPlayerDelegate>{
    
    
    
}

@property (nonatomic,strong) AVAudioPlayer * audioPlayer;//player
@property (nonatomic,weak) IBOutlet UILabel * controlPanel;
@property (nonatomic,weak) IBOutlet UIProgressView * playProgress;
@property (nonatomic,weak) IBOutlet UILabel * musicSinger;
@property (nonatomic,weak) IBOutlet UIButton * playOrPause;

- (IBAction)playChoosed:(UIButton *)button;


@property (nonatomic,weak) NSTimer * timer;


@end

@implementation SingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playOrPause.layer.masksToBounds = YES;
    self.playOrPause.layer.cornerRadius = 5;
    
    
    
    
}

-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:true];
    }
    return _timer;
}
/**
 *  创建播放器
 *
 *  @return 音频播放器
 */
-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        NSString *urlStr=[[NSBundle mainBundle]pathForResource:@"js" ofType:@".mp3"];
        NSURL *url=[NSURL fileURLWithPath:urlStr];
        NSError *error=nil;
        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        //设置播放器属性
        _audioPlayer.numberOfLoops=0;//设置为0不循环
        _audioPlayer.delegate=self;
        [_audioPlayer prepareToPlay];//加载音频文件到缓存
        if(error){
            NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}
/**
 *  播放音频
 */
-(void)play{
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
        self.timer.fireDate=[NSDate distantPast];//恢复定时器
    }
}

/**
 *  暂停播放
 */
-(void)pause{
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer pause];
        self.timer.fireDate=[NSDate distantFuture];//暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复
        
    }
}

/**
 *  点击播放/暂停按钮
 *
 *  @param sender 播放/暂停按钮
 */
static bool isPlay = NO;
- (void)playChoosed:(UIButton *)button{
    isPlay = !isPlay;
    if (isPlay) {
        
        [button setTitle:@"pause" forState:UIControlStateNormal];
        [self play];
    }
    if (!isPlay) {
        
        
        [button setTitle:@"play" forState:UIControlStateNormal];
        [self pause];
    }

}


/**
 *  更新播放进度
 */
-(void)updateProgress{
    float progress= self.audioPlayer.currentTime /self.audioPlayer.duration;
    [self.playProgress setProgress:progress animated:true];
}

#pragma mark - 播放器代理方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"音乐播放完成...");
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
