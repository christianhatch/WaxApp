//
//  TutorialChildViewController.m
//  Wax
//
//  Created by Christian Hatch on 7/15/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "TutorialChildViewController.h"

@interface TutorialChildViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) NSInteger index;

@end

@implementation TutorialChildViewController

#pragma mark - Public Factory
+(TutorialChildViewController *)tutorialChildViewControllerForIndex:(NSUInteger)index{
    TutorialChildViewController *child = initViewControllerWithIdentifier(@"TutorialChildVC");
    child.index = index;
    return child; 
}

#pragma mark - View LifeCycle
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
    
    [self configureViewForIndex:self.index]; 
}
-(void)setUpView{
    self.view.backgroundColor = [UIColor waxRedColor];
    
    [self.titleLabel setWaxHeaderItalicsFontOfSize:15 color:[UIColor whiteColor]];
    [self.detailLabel setWaxDefaultFontOfSize:14 color:[UIColor whiteColor]];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.textAlignment = NSTextAlignmentCenter; 
}


#pragma mark - Internal Methods
-(void)configureViewForIndex:(NSUInteger)index{
    self.imageView.image = [self imageForIndex:index];
    self.detailLabel.text = [self detailLabelTextForIndex:index];
    self.titleLabel.text = [self titleLabelTextForIndex:index]; 
}






-(NSString *)detailLabelTextForIndex:(NSUInteger)index{
    
    NSString *text = nil;
    
    switch (index) {
        case 0:
            text = NSLocalizedString(@"Wax allows you to make a competition out of anything by simply capturing video", @"Tutorial 1 text");
            break;
        case 1:
            text = NSLocalizedString(@"Tap the rebound button to record your own video and show everyone who's boss!", @"Tutorial 2 text");
            break;
        case 2:
            text = NSLocalizedString(@"Tap the forward button to challenge your friends to join a competition!", @"Tutorial 3 text");
            break;
        case 3:
            text = NSLocalizedString(@"The video with the most votes is #1 for its competition tag!", @"Tutorial 4 text");
            break;
    }
    
    return text;
}

-(NSString *)titleLabelTextForIndex:(NSUInteger)index{
    
    NSString *text = nil;
    
    switch (index) {
        case 0:
            text = NSLocalizedString(@"Wax", @"Tutorial 1 title");
            break;
        case 1:
            text = NSLocalizedString(@"Think you can do better?", @"Tutorial 2 title");
            break;
        case 2:
            text = NSLocalizedString(@"Know someone who can do better?", @"Tutorial 3 title");
            break;
        case 3:
            text = NSLocalizedString(@"Vote on videos you think are the best!", @"Tutorial 4 title");
            break;
    }
    
    return text;
}


-(UIImage *)imageForIndex:(NSUInteger)anIndex{
    
    UIImage *image = nil;
    
    switch (anIndex) {
        case 0:
            image = [UIImage imageNamed:@"tutorial_screen1"]; 
            break;
        case 1:
            image = [UIImage imageNamed:@"tutorial_screen2"];
            break;
        case 2:
            image = [UIImage imageNamed:@"tutorial_screen3"];
            break;
        case 3:
            image = [UIImage imageNamed:@"tutorial_screen4"];
            break;
    }
    
    return image; 
}











- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
