//
//  CategoryTableViewController.h
//  Wax
//
//  Created by Christian Hatch on 6/3/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


typedef void(^CategoryViewControllerCompletionBlock)(NSString *category);

#import <UIKit/UIKit.h>

@interface CategoryTableViewController : UITableViewController

+(void)chooseCategoryWithCompletionBlock:(CategoryViewControllerCompletionBlock)completion sender:(UINavigationController *)sender;

@property (nonatomic, assign) CategoryViewControllerCompletionBlock completionBlock; 


@end
