//
//  HomeViewController.m
//  Wax
//
//  Created by Christian Hatch on 6/8/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "HomeViewController.h"
#import "FeedTableView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
}

-(void)setUpView{
    self.navigationItem.title = NSLocalizedString(@"Home", @"Home");
    [self.view addSubview:[FeedTableView feedTableViewForHomeWithFrame:self.view.bounds]];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

}

@end
