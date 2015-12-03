//
//  AlbumsViewController.m
//  MediaTest
//
//  Created by wxdtan on 15/12/3.
//  Copyright © 2015年 com.qianjiyuntong. All rights reserved.
//

#import "AlbumsViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface AlbumsViewController ()<MPMediaPickerControllerDelegate>


@property (nonatomic,strong) MPMediaPickerController * mediaPicker;
@property (nonatomic,strong) MPMusicPlayerController * musicPlayer;

@property (nonatomic,strong) IBOutlet UIButton * selectBtn;
@property (nonatomic,strong) IBOutlet UIButton * playBtn;
@property (nonatomic,strong) IBOutlet UIButton * pauseBtn;
@property (nonatomic,strong) IBOutlet UIButton * preBtn;
@property (nonatomic,strong) IBOutlet UIButton * nxtBtn;



- (IBAction)selectClick:(UIButton *)sender;
- (IBAction)playClick:(UIButton *)sender;
- (IBAction)puaseClick:(UIButton *)sender;
- (IBAction)stopClick:(UIButton *)sender;
- (IBAction)nextClick:(UIButton *)sender;
- (IBAction)prevClick:(UIButton *)sender;



@end

@implementation AlbumsViewController
- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"will push");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}
- (void)dealloc{
    [self.musicPlayer endGeneratingPlaybackNotifications];
}

/**
 *  获得音乐播放器
 *
 *  @return 音乐播放器
 */
-(MPMusicPlayerController *)musicPlayer{
    if (!_musicPlayer) {
        _musicPlayer=[MPMusicPlayerController systemMusicPlayer];
        [_musicPlayer beginGeneratingPlaybackNotifications];//开启通知，否则监控不到MPMusicPlayerController的通知
        [self addNotification];//添加通知
        //如果不使用MPMediaPickerController可以使用如下方法获得音乐库媒体队列
        //[_musicPlayer setQueueWithItemCollection:[self getLocalMediaItemCollection]];
    }
    return _musicPlayer;
}

/**
 *  创建媒体选择器
 *
 *  @return 媒体选择器
 */
-(MPMediaPickerController *)mediaPicker{
    if (!_mediaPicker) {
        //初始化媒体选择器，这里设置媒体类型为音乐，其实这里也可以选择视频、广播等
        //        _mediaPicker=[[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeMusic];
        _mediaPicker=[[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeAny];
        _mediaPicker.allowsPickingMultipleItems=YES;//允许多选
        //        _mediaPicker.showsCloudItems=YES;//显示icloud选项
        _mediaPicker.prompt=@"请选择要播放的音乐";
        _mediaPicker.delegate=self;//设置选择器代理
    }
    return _mediaPicker;
}

/**
 *  取得媒体队列
 *
 *  @return 媒体队列
 */
-(MPMediaQuery *)getLocalMediaQuery{
    MPMediaQuery *mediaQueue=[MPMediaQuery songsQuery];
    for (MPMediaItem *item in mediaQueue.items) {
        NSLog(@"标题：%@,%@",item.title,item.albumTitle);
    }
    return mediaQueue;
}

/**
 *  取得媒体集合
 *
 *  @return 媒体集合
 */
-(MPMediaItemCollection *)getLocalMediaItemCollection{
    MPMediaQuery *mediaQueue=[MPMediaQuery songsQuery];
    NSMutableArray *array=[NSMutableArray array];
    for (MPMediaItem *item in mediaQueue.items) {
        [array addObject:item];
        NSLog(@"标题：%@,%@",item.title,item.albumTitle);
    }
    MPMediaItemCollection *mediaItemCollection=[[MPMediaItemCollection alloc]initWithItems:[array copy]];
    return mediaItemCollection;
}

#pragma mark - MPMediaPickerController代理方法
//选择完成
-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    MPMediaItem *mediaItem=[mediaItemCollection.items firstObject];//第一个播放音乐
    //注意很多音乐信息如标题、专辑、表演者、封面、时长等信息都可以通过MPMediaItem的valueForKey:方法得到,但是从iOS7开始都有对应的属性可以直接访问
    //    NSString *title= [mediaItem valueForKey:MPMediaItemPropertyAlbumTitle];
    //    NSString *artist= [mediaItem valueForKey:MPMediaItemPropertyAlbumArtist];
    //    MPMediaItemArtwork *artwork= [mediaItem valueForKey:MPMediaItemPropertyArtwork];
    //UIImage *image=[artwork imageWithSize:CGSizeMake(100, 100)];//专辑图片
    NSLog(@"标题：%@,表演者：%@,专辑：%@",mediaItem.title ,mediaItem.artist,mediaItem.albumTitle);
    [self.musicPlayer setQueueWithItemCollection:mediaItemCollection];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//取消选择
-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 通知
/**
 *  添加通知
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(playbackStateChange:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
}

/**
 *  播放状态改变通知
 *
 *  @param notification 通知对象
 */
-(void)playbackStateChange:(NSNotification *)notification{
    switch (self.musicPlayer.playbackState) {
        case MPMusicPlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMusicPlaybackStatePaused:
            NSLog(@"播放暂停.");
            break;
        case MPMusicPlaybackStateStopped:
            NSLog(@"播放停止.");
            break;
        default:
            break;
    }
}




#pragma mark - UI事件
- (void)selectClick:(UIButton *)sender {
    [self presentViewController:self.mediaPicker animated:YES completion:nil];
}

- (void)playClick:(UIButton *)sender {
    [self.musicPlayer play];
}

- (void)puaseClick:(UIButton *)sender {
    [self.musicPlayer pause];
}

- (void)stopClick:(UIButton *)sender {
    [self.musicPlayer stop];
}

- (void)nextClick:(UIButton *)sender {
    [self.musicPlayer skipToNextItem];
}

- (void)prevClick:(UIButton *)sender {
    [self.musicPlayer skipToPreviousItem];
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
