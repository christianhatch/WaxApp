//
//  CHEmptyView.m
//  Kiwi
//
//  Created by Christian Hatch on 11/12/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "AIKEmptyView.h"
#import "AcaciaKit.h"

@interface AIKEmptyView ()
@property (nonatomic, strong) void (^actionHandler)(void);
@property (nonatomic) BOOL tappable;


@property (nonatomic, strong) UILabel *primaryLabel;
@property (nonatomic, strong) UILabel *secondaryLabel;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIButton *optionalButton;
@property (nonatomic, strong) NSString *primaryText;
@property (nonatomic, strong) NSString *secondaryText;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSString *buttonText;
@property (nonatomic, strong) UITapGestureRecognizer *tap; 
@property (nonatomic) CGFloat horizontalPadding;
@property (nonatomic) CGFloat verticalPadding;

@end

@implementation AIKEmptyView
@synthesize horizontalPadding, verticalPadding; 
@synthesize primaryLabel = _primaryLabel;
@synthesize secondaryLabel = _secondaryLabel;
@synthesize imageView = _imageView;
@synthesize actionHandler = _actionHandler;
@synthesize optionalButton = _optionalButton;
@synthesize buttonText = _buttonText;
@synthesize tappable = _tappable;
@synthesize tap = _tap;
@synthesize primaryText = _primaryText;
@synthesize secondaryText = _secondaryText; 

-(id)initWithMessage1:(NSString *)message1 message2:(NSString *)message2 image:(UIImage *)image buttonLabel:(NSString *)buttonLabel actionHandler:(void (^)(void))actionHandler{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.primaryText = message1;
        self.secondaryText = message2;
        self.backgroundImage = image;
        self.actionHandler = actionHandler;
        self.buttonText = buttonLabel;
        self.hidden = NO;
//        self.backgroundColor = [[UIColor lightGrayColor] colorWithNoiseWithOpacity:0.07];
//        self.backgroundColor = [UIColor feedTableBGNoiseColor];
        self.tappable = NO;
    }
    return self;
}
-(void)setTappable:(BOOL)tappable{
    if (tappable != _tappable) {
        _tappable = tappable;
        if (_tappable) {
            self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction)];
            [self addGestureRecognizer:self.tap];
        }else{
            [self removeGestureRecognizer:self.tap];
            self.tap = nil;
        }
    }
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    if ([newSuperview isKindOfClass:[UITableView class]]) {
        UITableView *supes = (UITableView *)newSuperview;
        supes.scrollEnabled = NO; 
        CGRect tableframe = supes.bounds;
        tableframe.size.height -= (supes.tableHeaderView.bounds.size.height); // + fabs(supes.contentOffset.y));
        tableframe.origin.y = supes.tableHeaderView.bounds.size.height;
        self.frame = tableframe;
    }else{
        self.frame = newSuperview.bounds;
    }
    [super willMoveToSuperview:newSuperview];
}
-(void)didMoveToSuperview{
    [self fadeIn];
    [super didMoveToSuperview];
}
-(void)removeFromSuperview{
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *supes = (UIScrollView *)self.superview;
        supes.scrollEnabled = YES;
    }
    [super removeFromSuperview];  
}
-(void)setFrame:(CGRect)aframe{
    self.horizontalPadding = aframe.size.width * .1;
    self.verticalPadding = aframe.size.height * .1;
    CGRect bframe = aframe;
    bframe.origin.x = MAX(0, aframe.origin.x);
    bframe.origin.y = MAX(0, aframe.origin.y);
    bframe.size.width = MIN(320, aframe.size.width);
    [super setFrame:bframe];
    [self layoutSubviews]; 
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.primaryLabel.text = self.primaryText;
    self.secondaryLabel.text = self.secondaryText;
    [self.primaryLabel sizeToFit];
    [self.secondaryLabel sizeToFit];
    
    CGRect imgfrm = CGRectInset(self.frame, self.horizontalPadding * 2, self.verticalPadding * 2);
    self.imageView.frame = imgfrm;
    self.imageView.center = CGPointMake(self.center.x, ((self.bounds.origin.y + self.imageView.frame.size.height/2) + 20));

    if (self.primaryLabel.frame.size.width >= self.superview.frame.size.width) {
        CGRect maxframe = self.primaryLabel.frame;
        maxframe.size.width = MIN(self.superview.frame.size.width, self.primaryLabel.frame.size.width);
        self.primaryLabel.frame = maxframe;
    }
    
    CGRect maxframe = self.secondaryLabel.frame;
    maxframe.size.width = self.superview.frame.size.width - 15;
    self.secondaryLabel.frame = maxframe;
    
    
    self.primaryLabel.center = CGPointMake(self.center.x, ((self.imageView.frame.size.height + (self.primaryLabel.frame.size.height/2)) + 20));
    self.secondaryLabel.center = CGPointMake(self.center.x, ((CGRectGetMinY(self.primaryLabel.frame) + (self.secondaryLabel.frame.size.height/2)) + 20));
    
    
    if (self.optionalButton) {
        CGRect btnfrm = self.frame;
        btnfrm.size.width = self.frame.size.width - self.horizontalPadding * 2;
        btnfrm.size.height = 36;
        btnfrm.origin.y = self.secondaryLabel.frame.size.height + self.secondaryLabel.frame.origin.y + 5;
        self.optionalButton.frame = btnfrm;
        self.optionalButton.center = CGPointMake(self.center.x, self.optionalButton.center.y);
    }
}
-(void)buttonAction{
    if (self.actionHandler) {
        self.actionHandler(); 
    }else{
        DLog(@"You must set an action handler for the button to function");
    }
}
#pragma mark - Setters and Getters
-(UILabel *)primaryLabel{
    if (!_primaryLabel) {
        _primaryLabel = [[UILabel alloc] init];
        _primaryLabel.font = [UIFont waxBoldOfSize:16];
        _primaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _primaryLabel.numberOfLines = 1;
        _primaryLabel.adjustsFontSizeToFitWidth = YES;
//        _primaryLabel.minimumFontSize = 10;
        _primaryLabel.textAlignment = NSTextAlignmentCenter;
        _primaryLabel.textColor = [UIColor colorWithWhite:(.2f) alpha:1];
        _primaryLabel.shadowColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _primaryLabel.shadowOffset = CGSizeMake(.5, .5);
        _primaryLabel.backgroundColor = [UIColor clearColor];
        _primaryLabel.hidden = NO;
        [self addSubview:_primaryLabel];
    }
    return _primaryLabel;
}
-(UILabel *)secondaryLabel{
    if (!_secondaryLabel) {
        _secondaryLabel = [[UILabel alloc] init];
        _secondaryLabel.font = [UIFont waxRegularOfSize:15];
        _secondaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _secondaryLabel.numberOfLines = 2;
        _secondaryLabel.adjustsFontSizeToFitWidth = YES;
//        _secondaryLabel.minimumFontSize = 10;
        _secondaryLabel.textAlignment = NSTextAlignmentCenter;
        _secondaryLabel.textColor = [UIColor darkGrayColor];
        _secondaryLabel.shadowColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _secondaryLabel.shadowOffset = CGSizeMake(.5, .5);
        _secondaryLabel.backgroundColor = [UIColor clearColor];
        _secondaryLabel.hidden = NO;
        [self addSubview:_secondaryLabel];
    }
    return _secondaryLabel; 
}
-(UIImage *)backgroundImage{
    if (!_backgroundImage) {
        _backgroundImage = [UIImage imageNamed:@"nokiwi.png"];
    }
    return _backgroundImage; 
}
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:self.backgroundImage];
        _imageView.hidden = NO;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self insertSubview:_imageView atIndex:0];
    }
    return _imageView; 
}
-(UIButton *)optionalButton{
    if (self.buttonText) {
        if (!_optionalButton) {
            _optionalButton = [UIButton whiteButtonWithTitle:nil];
            _optionalButton.titleLabel.textColor = [UIColor darkGrayColor];
            _optionalButton.titleLabel.font = [UIFont waxRegularOfSize:16];
            _optionalButton.hidden = NO;
            [_optionalButton setTitle:self.buttonText forState:UIControlStateNormal];
            [_optionalButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [_optionalButton setTitle:self.buttonText forState:UIControlStateHighlighted];
            [_optionalButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
            [_optionalButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_optionalButton];
        }
    }
    return _optionalButton;
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
