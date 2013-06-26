//
//  CategoryChooserViewController.m
//  Wax
//
//  Created by Christian Hatch on 6/3/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "CategoryChooserViewController.h"

@interface CategoryChooserViewController ()
@property (nonatomic, strong) CategoryTableViewDidSelectCategoryBlock completion;
@end

@implementation CategoryChooserViewController
@synthesize completion = _completion;

#pragma mark - Alloc & Init
+(void)chooseCategoryWithCompletionBlock:(CategoryTableViewDidSelectCategoryBlock)completion navigationController:(UINavigationController *)sender{
    CategoryChooserViewController *cats = [[CategoryChooserViewController alloc] init]; 
    cats.completion = completion;
    [sender pushViewController:cats animated:YES];
}
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark - View Lifecycle
-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
}
-(void)setUpView{
    self.navigationItem.title = NSLocalizedString(@"Choose Category", @"Choose Category");
    [self.view addSubview:[CategoryTableView categoryTableViewForCategoriesWithFrame:self.view.bounds didSelectCategoryBlock:^(NSString *category) {
        if (self.completion) {
            [self.navigationController popViewControllerAnimated:YES]; 
            self.completion(category); 
        }
    }]];
}




@end
