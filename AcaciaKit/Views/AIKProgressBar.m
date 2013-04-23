//
//  CHProgressBar.m
//  Kiwi
//
//  Created by Christian Hatch on 11/13/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "AIKProgressBar.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>
#import "AcaciaKit.h"

@interface AIKProgressBar ()

@property (nonatomic) CGFloat currentProgress;
@property (nonatomic, strong) UIImageView *progressBar;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UILabel *progressLabel;

@end

@implementation AIKProgressBar
@synthesize currentProgress = _currentProgress;
@synthesize progressBar = _progressBar;
@synthesize activity = _activity;
@synthesize showProgressLabel = _showProgressLabel;
@synthesize showActivityIndicator = _showActivityIndicator;
@synthesize progressLabel = _progressLabel;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
-(void)initialize{
    self.hidden = NO;
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    
    self.showActivityIndicator = YES;
    self.showProgressLabel = YES;

    [self addSubview:self.progressBar];
    [self insertSubview:self.activity aboveSubview:self.progressBar];
    [self insertSubview:self.progressLabel aboveSubview:self.progressBar];
}
#pragma mark - Getters
-(UIImageView *)progressBar{
    if (!_progressBar) {
        _progressBar = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, self.frame.size.height)];
        _progressBar.image = [UIImage stretchyImage:[UIImage imageNamed:@"progress_bg.png"] withCapInsets:UIEdgeInsetsMake(0, 2, 0, 2) useImageHeight:YES];
        _progressBar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _progressBar; 
}
-(UILabel *)progressLabel{
    if (!_progressLabel) {
        CGRect acframe = self.activity.frame;
        acframe.origin.x = acframe.origin.x;
        acframe.size.width = self.frame.size.width;
        acframe.size.height = 16;
        
        _progressLabel = [[UILabel alloc] initWithFrame:acframe];
        _progressLabel.center = CGPointMake(self.progressLabel.center.x, self.center.y);
        _progressLabel.backgroundColor = [UIColor clearColor];
        _progressLabel.textColor = [UIColor lightGrayColor];
        _progressLabel.shadowColor = [UIColor whiteColor];
        _progressLabel.shadowOffset = CGSizeMake(-.5, -.5);
        _progressLabel.textAlignment = NSTextAlignmentLeft;
        _progressLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    }
    return _progressLabel;
}
-(UIActivityIndicatorView *)activity{
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activity.frame = CGRectMake(10, self.center.y, 0, 0);
        if ([_activity respondsToSelector:@selector(setColor:)]){
            [_activity.layer setValue:[NSNumber numberWithFloat:0.7f] forKeyPath:@"transform.scale"];
            [_activity setColor:[UIColor whiteColor]];
        }
        _activity.hidesWhenStopped = YES;
    }
    return _activity; 
}
#pragma mark - Setters
-(void)setFrame:(CGRect)frame{
//    [UIView animateWithDuration:0.2 animations:^{
        self.activity.frame = CGRectMake(10, self.center.y, 0, 0);
        self.progressLabel.center = CGPointMake(self.progressLabel.center.x, self.center.y);
        self.progressBar.image = [UIImage stretchyImage:[UIImage imageNamed:@"progress_bg.png"] withCapInsets:UIEdgeInsetsMake(0, 2, 0, 2) useImageHeight:NO];
//    }];
    [super setFrame:frame];
}
-(void)setText:(CGFloat)text{
    CGFloat prog = text * 100;
    NSInteger texty = floor(prog);
    self.progressLabel.text = [NSString stringWithFormat:@"    %i%%", texty];
}
-(void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    self.currentProgress = progress;
    if (self.showProgressLabel) {
        if (self.currentProgress <= 0) {
            [self.progressLabel fadeOut];
        }else{
            [self.progressLabel fadeIn];
        }
        [self setText:self.currentProgress];
    }
    if (self.showActivityIndicator) {
        if (self.currentProgress <= 0) {
            [self.activity fadeIn]; 
            [self.activity startAnimating]; 
        }else{
            [self.activity fadeOut];
        }
    }
    if (animated) {
        [UIView animateWithDuration:KWAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect prog = self.progressBar.frame;
            prog.size.width = self.frame.size.width * self.currentProgress;
            self.progressBar.frame = prog;
        } completion:nil];
    }else{
        CGRect prog = self.progressBar.frame;
        prog.size.width = self.frame.size.width * self.currentProgress;
        self.progressBar.frame = prog;
    }
}
-(void)setCurrentProgress:(CGFloat)currentProgress{
    CGFloat theProgress = [self normalizeFloat:currentProgress];
    if (theProgress != _currentProgress) {
        _currentProgress = theProgress;
    }
}
-(void)setShowActivityIndicator:(BOOL)showActivityIndicator{
    if (showActivityIndicator != _showActivityIndicator) {
        _showActivityIndicator = showActivityIndicator;
        if (!_showActivityIndicator) {
            [self.activity fadeOutandRemoveFromSuperview];
        }
    }
}
-(void)setshowProgressLabel:(BOOL)showProgressLabel{
    if (showProgressLabel != _showProgressLabel) {
        _showProgressLabel = showProgressLabel;
        if (!_showProgressLabel) {
            [self.progressLabel fadeOutandRemoveFromSuperview];
        }
    }
}
#pragma mark - Utility Methods
-(CGFloat)normalizeFloat:(CGFloat)abnormal{
    return MIN(MAX(abnormal, 0), 1);
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
