//
//  DiscoverViewController.m
//  Wax
//
//  Created by Christian Hatch on 6/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "DiscoverViewController.h"
#import "CategoryTableView.h"
#import "FeedViewController.h"

@interface DiscoverViewController ()
@property (nonatomic, strong) CategoryTableView *tableView;
@end

@implementation DiscoverViewController
@synthesize tableView = _tableView;

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
}

-(void)setUpView{
    self.navigationItem.title = NSLocalizedString(@"Discover", @"Discover");
    [self.view addSubview:self.tableView];
}

#pragma mark - Getters
-(CategoryTableView *)tableView{
    if (!_tableView) {
        _tableView = [CategoryTableView categoryTableViewForDiscoverWithFrame:self.view.bounds didSelectCategoryBlock:^(NSString *category) {
            [self.navigationController pushViewController:[FeedViewController feedViewControllerWithCategory:category] animated:YES];
        }];
        _tableView.automaticallyDeselectRow = YES; 
    }
    return _tableView;
}




- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
