//
//  SingLineControlViewController.m
//  MediaTest
//
//  Created by wxdtan on 15/12/2.
//  Copyright © 2015年 com.qianjiyuntong. All rights reserved.
//
//http://www.cnblogs.com/kenshincui/p/4186022.html


#import "SingLineControlViewController.h"
#import <AVFoundation/AVFoundation.h>


#define kMusicPath @"js"
#define kMusicAuthor @"王力宏"
#define kMusicName @"脚本"
#define kMusicPic @"wlh.jpg"

@interface SingLineControlViewController ()<AVAudioPlayerDelegate>{
    
    
    
}

@property (nonatomic,strong) AVAudioPlayer * audioPlayer;//player
@property (nonatomic,weak) IBOutlet UILabel * controlPanel;
@property (nonatomic,weak) IBOutlet UIProgressView * playProgress;
@property (nonatomic,weak) IBOutlet UILabel * musicSinger;
@property (nonatomic,weak) IBOutlet UIButton * playOrPause;

- (IBAction)playClicked:(UIButton *)button;


@property (nonatomic,weak) NSTimer * timer;




@end

@implementation SingLineControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playOrPause.layer.masksToBounds = YES;
    self.playOrPause.layer.cornerRadius = 5;
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //first responder
    
//    [self becomeFirstResponder];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
//    [self resignFirstResponder];
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:true];
    }
    return _timer;
}


/////////////////////////////////
/*
- (AVAudioPlayer *)audioPlayer{
    if (!self.audioPlayer) {
 NSString *urlStr=[[NSBundle mainBundle]pathForResource:@"js" ofType:@".mp3"];
 NSURL * url = [NSURL fileURLWithPath:urlStr];
 NSError  *error = nil;
 //此处只支持本地路径的文件 不支持http url
 _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
 
 //property
 _audioPlayer.numberOfLoops = 0;
 _audioPlayer.delegate = self;
 [_audioPlayer prepareToPlay];//加载文件到缓存
 if (error) {
 NSLog(@"初始化播放器过程中发生错误，错误信息：%@",error.localizedDescription);
 return  nil;
 }
 //设置后台播放模式
 AVAudioSession * audioSession = [AVAudioSession sharedInstance];
 [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
 //        [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
 [audioSession setActive:YES error:nil];
 //添加通知 拔出耳机后暂停播放
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];

    }

    return _audioPlayer;
}*/
-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        NSString *urlStr=[[NSBundle mainBundle]pathForResource:@"js" ofType:@".mp3"];
        NSURL *url=[NSURL fileURLWithPath:urlStr];
        NSError *error=nil;
        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        //设置播放器属性
        _audioPlayer.numberOfLoops=1000000;//设置为0不循环
        _audioPlayer.delegate=self;
        [_audioPlayer prepareToPlay];//加载音频文件到缓存
        if(error){
            NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
            return nil;
        }
        //设置后台播放模式
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        //        [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
        [audioSession setActive:YES error:nil];
        //添加通知 拔出耳机后暂停播放
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    }
    
    return _audioPlayer;
}

/*
 *
 *播放音频
 *
 */
- (void)play{
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
        self.timer.fireDate = [NSDate distantPast];//恢复定时器
    }
}
/*
 *
 *暂停播放
 *
 */
- (void)pause{
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer pause];
        
        self.timer.fireDate = [NSDate distantFuture];
        
    }
    
}
/*
 *
 *点击播放/暂停按钮
 *
 *
 *@param sender 播放/暂停按钮
 *
 */

static bool isPlay = NO;
- (void)playClicked:(UIButton *)button{
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
 *
 *
 *
 *
 *更新播放进度
 *
 *
 *
 *
 */
- (void)updateProgress{
    
    float progress = self.audioPlayer.currentTime / self.audioPlayer.duration;
    
    [self.playProgress setProgress:progress animated:1];
}

/**
 *
 *
 *一旦输出改变则执行此方法
 *
 *
 *@prama notification 输出改变通知对象
 *
 *
 *
 */

- (void)routeChange:(NSNotification *)notification{
    NSDictionary  *dic = notification.userInfo;
    
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            [self pause];
        }
    }

    //    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    //        NSLog(@"%@:%@",key,obj);
    //    }];
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}

#pragma mark - 播放器代理方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"音乐播放完成...");
    //根据实际情况播放完成可以将会话关闭，其他音频应用继续播放
//    [[AVAudioSession sharedInstance]setActive:NO error:nil];
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
