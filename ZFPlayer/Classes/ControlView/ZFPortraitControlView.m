//
//  ZFPortraitControlView.m
//  ZFPlayer
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFPortraitControlView.h"
#import "UIView+ZFFrame.h"
#import "ZFUtilities.h"
#if __has_include(<ZFPlayer/ZFPlayer.h>)
#import <ZFPlayer/ZFPlayer.h>
#else
#import "ZFPlayer.h"
#endif

@interface ZFPortraitControlView () <ZFSliderViewDelegate>
/// 底部工具栏
@property (nonatomic, strong) UIView *bottomToolView;
/// 顶部工具栏
@property (nonatomic, strong) UIView *topToolView;
/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 播放或暂停按钮
@property (nonatomic, strong) UIButton *playOrPauseBtn;
/// 播放的当前时间
@property (nonatomic, strong) UILabel *currentTimeLabel;
/// 滑杆
@property (nonatomic, strong) ZFSliderView *slider;
/// 视频总时间
@property (nonatomic, strong) UILabel *totalTimeLabel;
/// 全屏按钮
@property (nonatomic, strong) UIButton *fullScreenBtn;

@property (nonatomic, assign) BOOL isShow;

@end

@implementation ZFPortraitControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加子控件
        [self addSubview:self.topToolView];
        [self addSubview:self.bottomToolView];
        [self addSubview:self.playOrPauseBtn];
        [self addSubview:self.tvBtn];
        [self.topToolView addSubview:self.backBtn];
        [self.topToolView addSubview:self.titleLabel];
        [self.bottomToolView addSubview:self.playOrPauseBtn];
        [self.bottomToolView addSubview:self.currentTimeLabel];
        [self.bottomToolView addSubview:self.slider];
        [self.bottomToolView addSubview:self.totalTimeLabel];
        [self.bottomToolView addSubview:self.fullScreenBtn];
        [self.bottomToolView addSubview:self.barrageBtn];
        [self.bottomToolView addSubview:self.refreshBtn];

        // 设置子控件的响应事件
        [self makeSubViewsAction];
        
        [self resetControlView];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    CGFloat min_margin = 9;
    
    min_x = 0;
    min_y = 0;
    min_w = min_view_w;
    min_h = 40;
    self.topToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = min_margin;
    min_y = 5;
    min_w = 40;
    min_h = 40;
    self.backBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.backBtn.zf_right + 5;
    min_y = 5;
    min_w = min_view_w - min_x - 15;
    min_h = 30;
    self.titleLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_h = 40;
    min_x = 0;
    min_y = min_view_h - min_h;
    min_w = min_view_w;
    self.bottomToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_w = 45;
    min_h = 45;
    self.playOrPauseBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.playOrPauseBtn.zf_centerX = self.backBtn.zf_centerX;
    self.playOrPauseBtn.zf_centerY = self.bottomToolView.zf_height/2;
    
    min_x = 0;
    min_y = 0;
    self.tvBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.tvBtn.zf_centerY = self.backBtn.zf_centerY;
    self.tvBtn.zf_right = self.zf_right - min_margin;
    
    min_x = self.playOrPauseBtn.zf_right + 4;
    min_w = 62;
    min_h = 28;
    min_y = (self.bottomToolView.zf_height - min_h)/2;
    self.currentTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    
    
    min_w = 44;
    min_h = min_w;
    min_x = self.bottomToolView.zf_width - min_w - min_margin;
    min_y = 0;
    self.fullScreenBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.fullScreenBtn.zf_centerY = self.currentTimeLabel.zf_centerY;
    self.fullScreenBtn.zf_centerX = self.tvBtn.zf_centerX;
    
    min_w = 62;
    min_h = 28;
    min_x = self.fullScreenBtn.zf_left - min_w - 4;
    min_y = 0;
    self.totalTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.totalTimeLabel.zf_centerY = self.currentTimeLabel.zf_centerY;
    
    min_x = self.currentTimeLabel.zf_right + 4;
    min_y = 0;
    min_w = self.totalTimeLabel.zf_left - min_x - 4;
    min_h = 30;
    self.slider.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.slider.zf_centerY = self.currentTimeLabel.zf_centerY;
    
    
    min_w = 50;
    min_h = 50;
    min_x = self.fullScreenBtn.zf_left - min_w - 4;
    min_y = 0;
    self.barrageBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.barrageBtn.zf_centerY = self.currentTimeLabel.zf_centerY;

    min_x = self.barrageBtn.zf_left - min_w - 4;
    self.refreshBtn.frame = CGRectMake(min_x, 0, min_w, min_h);
    self.refreshBtn.zf_centerY = self.barrageBtn.zf_centerY;
    
    if (self.player.currentPlayerManager.isLive){
        self.refreshBtn.alpha = 1;
        self.barrageBtn.alpha = 1;
        self.slider.alpha = 0;
        self.totalTimeLabel.alpha = 0;
        self.currentTimeLabel.alpha = 0;
    }else{
        self.refreshBtn.alpha = 0;
        self.barrageBtn.alpha = 0;
        self.slider.alpha = 1;
        self.totalTimeLabel.alpha = 1;
        self.currentTimeLabel.alpha = 1;
    }
    
    if (!self.isShow) {
        self.topToolView.zf_y = -self.topToolView.zf_height;
        self.bottomToolView.zf_y = self.zf_height;
        self.playOrPauseBtn.alpha = 0;
    } else {
        self.topToolView.zf_y = 0;
        self.bottomToolView.zf_y = self.zf_height - self.bottomToolView.zf_height;
        self.playOrPauseBtn.alpha = 1;
    }
}

- (void)makeSubViewsAction {
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tvBtn addTarget:self action:@selector(tvBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)backBtnClickAction:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZFPlayerBack" object:nil];
}

- (void)tvBtnClickAction:(UIButton *)sender {
    [self.player.currentPlayerManager pause];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZFPlayerTvClick" object:nil];
}


#pragma mark - action

- (void)playPauseButtonClickAction:(UIButton *)sender {
    [self playOrPause];
}

- (void)fullScreenButtonClickAction:(UIButton *)sender {
    [self.player enterFullScreen:YES animated:YES];
}

/// 根据当前播放状态取反
- (void)playOrPause {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
    self.playOrPauseBtn.isSelected? [self.player.currentPlayerManager play]: [self.player.currentPlayerManager pause];
}

- (void)playBtnSelectedState:(BOOL)selected {
    self.playOrPauseBtn.selected = selected;
}

#pragma mark - ZFSliderViewDelegate

- (void)sliderTouchBegan:(float)value {
    self.slider.isdragging = YES;
}

- (void)sliderTouchEnded:(float)value {
    if (self.player.totalTime > 0) {
        self.slider.isdragging = YES;
        if (self.sliderValueChanging) self.sliderValueChanging(value, self.slider.isForward);
        @weakify(self)
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
            if (finished) {
                self.slider.isdragging = NO;
                if (self.sliderValueChanged) self.sliderValueChanged(value);
            }
        }];
        if (self.seekToPlay) {
            [self.player.currentPlayerManager play];
        }
    } else {
        self.slider.isdragging = NO;
        self.slider.value = 0;
    }
}

- (void)sliderValueChanged:(float)value {
    if (self.player.totalTime == 0) {
        self.slider.value = 0;
        return;
    }
    self.slider.isdragging = YES;
    NSString *currentTimeString = [ZFUtilities convertTimeSecond:self.player.totalTime*value];
    self.currentTimeLabel.text = currentTimeString;
    if (self.sliderValueChanging) self.sliderValueChanging(value,self.slider.isForward);
}

- (void)sliderTapped:(float)value {
    [self sliderTouchEnded:value];
    NSString *currentTimeString = [ZFUtilities convertTimeSecond:self.player.totalTime*value];
    self.currentTimeLabel.text = currentTimeString;
}

#pragma mark - public method

/** 重置ControlView */
- (void)resetControlView {
    self.bottomToolView.alpha        = 1;
    self.slider.value                = 0;
    self.slider.bufferValue          = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.backgroundColor             = [UIColor clearColor];
    self.playOrPauseBtn.selected     = YES;
    self.titleLabel.text             = @"";
}

- (void)showControlView {
    self.topToolView.alpha           = 1;
    self.bottomToolView.alpha        = 1;
    self.tvBtn.alpha                 = 1;
    self.isShow                      = YES;
    self.topToolView.zf_y            = 0;
    self.bottomToolView.zf_y         = self.zf_height - self.bottomToolView.zf_height;
    self.playOrPauseBtn.alpha        = 1;
    self.player.statusBarHidden      = NO;
}

- (void)hideControlView {
    self.isShow                      = NO;
    self.topToolView.zf_y            = -self.topToolView.zf_height;
    self.bottomToolView.zf_y         = self.zf_height;
    self.player.statusBarHidden      = NO;
    self.playOrPauseBtn.alpha        = 0;
    self.topToolView.alpha           = 0;
    self.bottomToolView.alpha        = 0;
    self.tvBtn.alpha                 = 0;
}

- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(ZFPlayerGestureType)type touch:(nonnull UITouch *)touch {
    CGRect sliderRect = [self.bottomToolView convertRect:self.slider.frame toView:self];
    if (CGRectContainsPoint(sliderRect, point)) {
        return NO;
    }
    return YES;
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    if (!self.slider.isdragging) {
        NSString *currentTimeString = [ZFUtilities convertTimeSecond:currentTime];
        self.currentTimeLabel.text = currentTimeString;
        NSString *totalTimeString = [ZFUtilities convertTimeSecond:totalTime];
        self.totalTimeLabel.text = totalTimeString;
        self.slider.value = videoPlayer.progress;
    }
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime {
    self.slider.bufferValue = videoPlayer.bufferProgress;
}

- (void)showTitle:(NSString *)title fullScreenMode:(ZFFullScreenMode)fullScreenMode {
    self.titleLabel.text = title;
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
}

/// 调节播放进度slider和当前时间更新
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSString *)timeString {
    self.slider.value = value;
    self.currentTimeLabel.text = timeString;
    self.slider.isdragging = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

/// 滑杆结束滑动
- (void)sliderChangeEnded {
    self.slider.isdragging = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - getter

- (UIButton *)barrageBtn{
    if (!_barrageBtn){
        _barrageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_barrageBtn eiImageName2x:@"GQP_barrage_open" forState:UIControlStateNormal];
        [_barrageBtn eiImageName2x:@"GQP_barrage_close" forState:UIControlStateSelected];
    }
    return _barrageBtn;

}

- (UIButton *)refreshBtn {
    if (!_refreshBtn) {
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshBtn eiImageName2x:@"GQP_play_refresh" forState:UIControlStateNormal];
    }
    return _refreshBtn;
}

- (UIView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_top_shadow");
        _topToolView.layer.contents = (id)image.CGImage;
    }
    return _topToolView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn eiImageName:@"GQP_cancel1" forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:13.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_bottom_shadow");
        _bottomToolView.layer.contents = (id)image.CGImage;
    }
    return _bottomToolView;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn eiImageName:@"GQP_pause" forState:UIControlStateNormal];
        [_playOrPauseBtn eiImageName:@"GQP_play" forState:UIControlStateSelected];
    }
    return _playOrPauseBtn;
}

- (UIButton *)tvBtn {
    if (!_tvBtn) {
        _tvBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tvBtn eiImageName2x:@"GQP_play_tv" forState:UIControlStateNormal];
    }
    return _tvBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (ZFSliderView *)slider {
    if (!_slider) {
        _slider = [[ZFSliderView alloc] init];
        _slider.delegate = self;
        _slider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        _slider.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _slider.minimumTrackTintColor = [UIColor colorWithHexString:@"#CB8656"];
        ZFSliderView *slider = _slider;
        [UIImage loadWithBlock2x:@"GQP_play_slider" Image:^(UIImage * _Nonnull imageBlock) {
            [slider setThumbImage:imageBlock forState:UIControlStateNormal];
        }];
        _slider.sliderHeight = 2;
    }
    return _slider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn eiImageName:@"GQP_full" forState:UIControlStateNormal];
    }
    return _fullScreenBtn;
}

- (void)setIsHiddenBackBtn:(BOOL)isHiddenBackBtn {
    self.backBtn.hidden = isHiddenBackBtn;
    _isHiddenBackBtn = isHiddenBackBtn;
}

@end
