//
//  NotificationsViewController.m
//  Wax
//
//  Created by Christian Hatch on 6/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "NotificationsViewController.h"

@interface NotificationsViewController ()
@property (nonatomic, strong) NotificationsTableView *noteTableView;
@end

@implementation NotificationsViewController
@synthesize noteTableView = _noteTableView;

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
    
}

-(void)setUpView{
    self.navigationItem.title = NSLocalizedString(@"Notifications", @"Notifications");
    [self.view addSubview:self.noteTableView]; 
}

#pragma mark - Getters
-(NotificationsTableView *)noteTableView{
    if (!_noteTableView) {
        _noteTableView = [NotificationsTableView notificationsTableViewWithFrame:self.view.bounds];
    }
    return _noteTableView; 
}



- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
