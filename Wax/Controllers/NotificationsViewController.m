//
//  NotificationsViewController.m
//  Wax
//
//  Created by Christian Hatch on 6/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "NotificationsViewController.h"

@interface NotificationsViewController ()
@end

@implementation NotificationsViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
    
}

-(void)setUpView{
    self.navigationItem.title = NSLocalizedString(@"Notifications", @"Notifications");

}

#pragma mark - Getters




- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
