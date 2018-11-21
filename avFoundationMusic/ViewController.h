//
//  ViewController.h
//  avFoundationMusic
//
//  Created by MacBookPro on 10/11/2018.
//  Copyright © 2018 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//델리게이트 선언
@interface ViewController : UIViewController <AVAudioPlayerDelegate>
- (IBAction)playPauseAudio:(id)sender;
- (IBAction)stopAudio:(id)sender;
- (IBAction)adjustVolume:(id)sender;
- (IBAction)progressSliderChanged:(id)sender;



@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;


@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *durationLabel;


@property (strong,nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) NSTimer *sliderTimer;

-(NSString *)stringFromInterval : (NSTimeInterval)interval;
-(void) updateSlider;
@end

