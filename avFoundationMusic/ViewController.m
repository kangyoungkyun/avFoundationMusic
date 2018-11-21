//
//  ViewController.m
//  avFoundationMusic
//
//  Created by MacBookPro on 10/11/2018.
//  Copyright © 2018 MacBookPro. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //mp3 경로
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"abc" ofType:@"mp3"]];
    NSError *error;
    
    //audioplayer 초기화
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (error) {
        NSLog(@"fehler : %@", error.localizedDescription);
    }else{
        
        //위임자는 자기자신
        self.audioPlayer.delegate= self;
        self.progressSlider.value = 0.0;
        self.volumeSlider.value = 0.5;
        //현재오디오 진행 시간을 보여주는 lable = [audioPlayer에서 보여주는 시간 가공해서 보여주기] 
        self.durationLabel.text = [self stringFromInterval:self.audioPlayer.duration];
        
        //mp3의 전체 길이가 1시간을 넘지 않는다면
        if (self.audioPlayer.duration <= 3600) {
            self.currentTimeLabel.text = [NSString stringWithFormat:@"00:00"];
        }else{
            self.currentTimeLabel.text = [NSString stringWithFormat:@"0:00:00"];
        }
        
        //준비완료
        [self.currentTimeLabel sizeToFit];
        [self.audioPlayer prepareToPlay];
    }

}


//audioPlayer.duration 을 가공해서 stirng으로 리턴
-(NSString *)stringFromInterval : (NSTimeInterval)interval{
    
    NSInteger ti = (NSInteger)interval;
    
    int sec = ti % 60;
    int min = (ti / 60) % 60;
    int hour = (ti / 3600);
    if (ti <= 3600) {
        return [NSString stringWithFormat:@"%02d:%02d",min,sec];
    }
    return [NSString stringWithFormat:@"%d:%02d:%02d",hour,min,sec];
    
}


-(void) updateSlider{
    self.progressSlider.value = self.audioPlayer.currentTime;
    self.currentTimeLabel.text = [self stringFromInterval:self.audioPlayer.currentTime];
    NSLog(@"updateSlider : %f  : %@" ,self.audioPlayer.currentTime ,[self stringFromInterval: self.audioPlayer.currentTime]);
}

- (IBAction)playPauseAudio:(id)sender {
     NSLog(@"self.audioPlayer.playing0 : %c", self.audioPlayer.playing);
    //플레이가 안되고 있으면
    if (!self.audioPlayer.playing) {
        NSLog(@"self.audioPlayer.playing1 : %c", self.audioPlayer.playing);
        self.progressSlider.maximumValue = self.audioPlayer.duration;
        //updateSlider 메서드를 1초간격으로 호출
        self.sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
        
        //오디오 진행바 변경됐을때 이벤트 감지
        [self.progressSlider addTarget:self action:@selector(progressSliderChanged:) forControlEvents:UIControlEventValueChanged];
        
        //실행
        [self.audioPlayer play];
        [self.playPauseButton setTitle:@"pause" forState:UIControlStateNormal];
    }else{
        //정지시키기
        NSLog(@"self.audioPlayer.playing2 : %c", self.audioPlayer.playing);
        [self.audioPlayer pause];
        [self.playPauseButton setTitle:@"play" forState:UIControlStateNormal];
    }
    
}

//정지 버튼
- (IBAction)stopAudio:(id)sender {
    //오디오가 플레이 중이면 정지시킨다
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer stop];
    }
    
    [self.audioPlayer setCurrentTime:0.0];
    [self.sliderTimer invalidate];
    self.progressSlider.value = 0.0;
    
    //오디오 총길이가 1시간보다 적을경우
    if (self.audioPlayer.duration <= 3600) {
        self.currentTimeLabel.text = [NSString stringWithFormat:@"00:00"];
    } else {
        self.currentTimeLabel.text = [NSString stringWithFormat:@"0:00:00"];
    }
    
    [self.currentTimeLabel sizeToFit];
    [self.playPauseButton setTitle:@"play" forState:normal];
    
}

//불륨 버튼
- (IBAction)adjustVolume:(id)sender {
    if (self.audioPlayer != nil) {
        self.audioPlayer.volume = self.volumeSlider.value;
    }
}

//진행바가 변경이 될때
- (IBAction)progressSliderChanged:(id)sender {
    [self.audioPlayer stop];  //오디오 정지
    [self.audioPlayer setCurrentTime:self.progressSlider.value];
    [self.audioPlayer prepareToPlay];   //준비
    [self.audioPlayer play];            //실행
}


-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag) {
        [self stopAudio:nil];
    }
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    
    NSLog(@"decodierfehler: %@" ,  error.localizedDescription);
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    //audio player wird unterbrochen
}


- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    if (flags == AVAudioSessionInterruptionOptionShouldResume && self.audioPlayer != nil) {
        [self.audioPlayer play];
    }
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
