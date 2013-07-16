//
//  TutorialChildViewController.h
//  Wax
//
//  Created by Christian Hatch on 7/15/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialChildViewController : UIViewController

+(TutorialChildViewController *)tutorialChildViewControllerForIndex:(NSUInteger)index; 

@property (nonatomic, readonly) NSInteger index;

@end
