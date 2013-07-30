//
//  TutorialParentViewController.m
//  Wax
//
//  Created by Christian Hatch on 7/15/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

NSString *const kHasShownTutorialKey = @"com.wax.hasShownTutorial"; 

#define kMinTutorialIndex 0
#define kMaxTutorialIndex 4

#import "TutorialParentViewController.h"
#import "TutorialChildViewController.h"

@interface TutorialParentViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource> 
@property (nonatomic, strong) UIPageViewController *pageController;
@end

@implementation TutorialParentViewController

+(TutorialParentViewController *)tutorialViewController{
    return [[TutorialParentViewController alloc] init]; 
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor waxRedColor];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.delegate = self; 
    self.pageController.dataSource = self;
    self.pageController.view.frame = self.view.bounds;
    
    UIViewController *vc = [self viewControllerForIndex:0];
    [self.pageController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHasShownTutorialKey];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger currentIndex = [self indexForViewController:viewController];
    
    if (currentIndex == kMinTutorialIndex) {
        return nil;
    }
    
    currentIndex--;
    
    return [self viewControllerForIndex:currentIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger currentIndex = [self indexForViewController:viewController];
        
    if (currentIndex == kMaxTutorialIndex) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return nil;
    }
    
    currentIndex++;

    return [self viewControllerForIndex:currentIndex];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return kMaxTutorialIndex;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return kMinTutorialIndex;
}





#pragma mark - Helper Methods
-(UIViewController *)viewControllerForIndex:(NSInteger)index{
    return [TutorialChildViewController tutorialChildViewControllerForIndex:index];
}

-(NSUInteger)indexForViewController:(UIViewController *)vc{
    
    if (![vc respondsToSelector:@selector(index)]) {
        return 0; 
    }
    
    TutorialChildViewController *child = (TutorialChildViewController *)vc;
    NSUInteger index = child.index;
    return index;

}
















- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

}

@end
