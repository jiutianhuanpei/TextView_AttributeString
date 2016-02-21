//
//  SHBInputVifew.m
//  TextView
//
//  Created by 沈红榜 on 16/2/20.
//  Copyright © 2016年 沈红榜. All rights reserved.
//

#import "SHBInputView.h"
#import "UIColor+SHBHex.h"
#import <AVFoundation/AVFoundation.h>
#import <DACircularProgressView.h>

CGFloat inputViewH = 196;

CGFloat recordBtnW = 90;
CGFloat progressW = 94;
@interface SHBInputView ()<AVAudioPlayerDelegate>

@property (nonatomic, assign) SHBInputStyle style;

@property (nonatomic, strong) AVAudioSession    *session;
@property (nonatomic, strong) AVAudioRecorder   *recorder;
@property (nonatomic, strong) AVAudioPlayer     *player;

@end

@implementation SHBInputView {
    NSArray     *_images;
    
    UILabel     *_title;
    UIButton    *_recordBtn;
    UIButton    *_cancelBtn;
    UIButton    *_sureBtn;
    
    DACircularProgressView  *_progress;
    
    NSString            *_path;
    NSDateFormatter     *_formatter;
    
    NSTimer             *_timer;
}

//@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.886 green:0.886 blue:0.922 alpha:1.000];
        _images = @[@"a-audio-record-white-circle", @"a-audio-record-red-circle", @"a-audio-record-go", @"a-audio-record-play"];
        
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.translatesAutoresizingMaskIntoConstraints = false;
        _title.font = [UIFont systemFontOfSize:13];
        _title.text = @"点击录音";
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor shbColorWithHexString:@"9f9f9f"];
        [self addSubview:_title];
        
        
        _progress = [[DACircularProgressView alloc] initWithFrame:CGRectZero];
        _progress.translatesAutoresizingMaskIntoConstraints = NO;
        _progress.trackTintColor = [UIColor shbColorWithHexString:@"d4d4d4"];
        _progress.progressTintColor = [UIColor colorWithRed:0.612 green:0.604 blue:0.745 alpha:1.000];
        _progress.innerTintColor = [UIColor whiteColor];
        _progress.thicknessRatio = 0.05;
        _progress.hidden = YES;
        [self addSubview:_progress];
        
        _recordBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _recordBtn.translatesAutoresizingMaskIntoConstraints = false;
        [_recordBtn setBackgroundImage:[UIImage imageNamed:_images[0]] forState:UIControlStateNormal];
        [_recordBtn setImage:[[UIImage imageNamed:_images[1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(clickedRecordBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_recordBtn];
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.translatesAutoresizingMaskIntoConstraints = false;
        _cancelBtn.hidden = YES;
        _cancelBtn.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        _cancelBtn.layer.borderColor = [UIColor shbColorWithHexString:@"d4d4d4"].CGColor;
        _cancelBtn.backgroundColor = [UIColor shbColorWithHexString:@"fafafc"];
        [_cancelBtn setTitleColor:[UIColor shbColorWithHexString:@"adaccb"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(clickedCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelBtn];
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _sureBtn.translatesAutoresizingMaskIntoConstraints = NO;
        _sureBtn.hidden = YES;
        _sureBtn.frame = CGRectZero;
        _sureBtn.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        _sureBtn.layer.borderColor = [UIColor shbColorWithHexString:@"d4d4d4"].CGColor;
        _sureBtn.backgroundColor = _cancelBtn.backgroundColor;
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_sureBtn setTitleColor:[UIColor shbColorWithHexString:@"adaccb"] forState:UIControlStateNormal];
        [_sureBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(clickedSureBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sureBtn];
        
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_title, _recordBtn, _cancelBtn, _sureBtn, _progress);
        NSDictionary *metrics = @{@"rW" : @(recordBtnW), @"one" : @(-1 / [UIScreen mainScreen].scale), @"pw" : @(progressW)};
        
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_title]-15-[_recordBtn(rW)]-(>=0)-[_cancelBtn(40)]|" options:0 metrics:metrics views:views]];
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_sureBtn(40)]|" options:0 metrics:nil views:views]];
//        
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:_recordBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:recordBtnW]];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:_recordBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-one-[_cancelBtn]-one-[_sureBtn(_cancelBtn)]-one-|" options:0 metrics:metrics views:views]];
        
        //  ******************

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_title]-15-[_progress(pw)]-(>=0)-[_cancelBtn(40)]|" options:0 metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_sureBtn(40)]|" options:0 metrics:metrics views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_title]|" options:0 metrics:nil views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_progress(pw)]" options:0 metrics:metrics views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_progress attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-one-[_cancelBtn]-one-[_sureBtn(_cancelBtn)]-one-|" options:0 metrics:metrics views:views]];
        
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_recordBtn(rW)]" options:0 metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_recordBtn(rW)]" options:0 metrics:metrics views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_recordBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_progress attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_recordBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_progress attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        
        
        [self initRecord];
        
    }
    return self;
}

- (void)initRecord {
    _path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"record.caf"];
    
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"mm:ss"];
    
    _session = [AVAudioSession sharedInstance];
    [_session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    
}

- (void)startRecord {
    [_session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [self.recorder prepareToRecord];
    [_recorder record];
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:true];
    }
}

- (void)timerAction {
    switch (_style) {
        case SHBInputStyleDefault: {
            _title.text = @"点击录音";
            break;
        }
        case SHBInputStyleRecord: {
            NSString *time = [_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_recorder.currentTime]];
            _title.text = time;
            [_progress setProgress:_recorder.currentTime / 60. animated:true];
            break;
        }
        case SHBInputStyleStop: {
            
            break;
        }
        case SHBInputStylePlay: {
            NSString *time = [_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_player.currentTime]];
            _title.text = time;
            [_progress setProgress:_player.currentTime / _player.duration animated:true];
            break;
        }
        case SHBInputStylePause: {
            
            break;
        }
    }
}

- (void)startPlay {
    [_session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.player prepareToPlay];
    [_player play];
}

- (AVAudioRecorder *)recorder {
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    if (!_recorder) {
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:_path] settings:recordSetting error:nil];
    }
    return _recorder;
}

- (AVAudioPlayer *)player {
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:_path] error:nil];
        _player.volume = 1;
        _player.delegate = self;
    return _player;
}

- (void)clickedRecordBtn:(UIButton *)btn {
    switch (_style) {
        case SHBInputStyleDefault: {
            
            if ([_session respondsToSelector:@selector(requestRecordPermission:)]) {
                [_session requestRecordPermission:^(BOOL granted) {
                    if (granted) {
                        self.style = SHBInputStyleRecord;
                        _title.text = @"00:00";
                        [_recorder deleteRecording];
                        NSFileManager *manager = [NSFileManager defaultManager];
                        if ([manager fileExistsAtPath:_path]) {
                            [manager removeItemAtPath:_path error:nil];
                        }
                        
                        [_session setActive:true error:nil];
                        
                        [self startRecord];
                        
                    } else {
                        if ([_delegate respondsToSelector:@selector(inputViewHasNoPower)]) {
                            [_delegate inputViewHasNoPower];
                        }
                    }
                }];
            }
            break;
        }
        case SHBInputStyleRecord: {
            
            self.style = SHBInputStyleStop;
            
            [_recorder stop];
            
            break;
        }
        case SHBInputStyleStop: {
            
            self.style = SHBInputStylePlay;
            _title.text = @"00:00";
            [self startPlay];
            
            break;
        }
        case SHBInputStylePlay: {
            
            self.style = SHBInputStylePause;
            
            [_player pause];
            
            break;
        }
        case SHBInputStylePause: {
            
            self.style = SHBInputStylePlay;
            
            [_player play];
            
            break;
        }
    }
    
    
}

- (void)setStyle:(SHBInputStyle)style {
    _style = style;
    
    UIImage *image = nil;
    _progress.hidden = false;
    switch (_style) {
        case SHBInputStyleDefault: {
            _title.text = @"点击录音";
            _progress.hidden = true;
            [_recordBtn setBackgroundImage:[UIImage imageNamed:_images[0]] forState:UIControlStateNormal];
            image = [[UIImage imageNamed:_images[1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            _cancelBtn.hidden = _sureBtn.hidden = true;
            break;
        }
        case SHBInputStyleRecord: {
            image = [[UIImage imageNamed:_images[2]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            _cancelBtn.hidden = _sureBtn.hidden = false;
            break;
        }
        case SHBInputStyleStop: {
            image = [[UIImage imageNamed:_images[3]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            break;
        }
        case SHBInputStylePlay: {
            image = [[UIImage imageNamed:_images[2]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [_progress setProgress:0 animated:false];
            break;
        }
        case SHBInputStylePause: {
            image = [[UIImage imageNamed:_images[3]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            break;
        }
    }
    
    [_recordBtn setImage:image forState:UIControlStateNormal];
}

- (void)clickedCancelBtn:(UIButton *)btn {
    self.style = SHBInputStyleDefault;
    [self stopAllFunction];
    if ([_delegate respondsToSelector:@selector(inputViewCancel)]) {
        [_delegate inputViewCancel];
    }
}

- (void)clickedSureBtn:(UIButton *)btn {
    self.style = SHBInputStyleDefault;
    [self stopAllFunction];
    if ([_delegate respondsToSelector:@selector(inputViewSure:)]) {
        [_delegate inputViewSure:_path];
    }
}

- (void)stopAllFunction {
    [_progress setProgress:0 animated:false];
    _progress.hidden = true;
    [_recorder stop];
    [_player stop];
    [_timer invalidate];
    _timer = nil;
    [_session setActive:false error:nil];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"%s", __FUNCTION__);
    self.style = SHBInputStyleStop;
    [_progress setProgress:1 animated:true];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    NSLog(@"%s", __FUNCTION__);
}

@end
