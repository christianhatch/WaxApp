//
//  CategoryChooserViewController.h
//  Wax
//
//  Created by Christian Hatch on 6/3/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CategoryTableView.h"

@interface CategoryChooserViewController : UIViewController

+(void)chooseCategoryWithCompletionBlock:(CategoryTableViewDidSelectCategoryBlock)completion navigationController:(UINavigationController *)sender;


@end
