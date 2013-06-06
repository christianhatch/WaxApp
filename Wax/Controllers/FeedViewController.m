//
//  FeedViewController.m
//  Wax
//
//  Created by Christian Hatch on 5/27/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self enableSwipeToPopVC:YES];
    
    [self setUpView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[WaxAPIClient sharedClient] fetchHomeFeedWithInfiniteScrollingID:nil completion:^(NSMutableArray *list, NSError *error) {
//
//        if (!error) {
//            
//        }
//        
//    }];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}


-(void)setUpView{
    
}












-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

}

@end
