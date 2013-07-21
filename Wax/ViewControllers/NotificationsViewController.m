//
//  NotificationsViewController.m
//  Wax
//
//  Created by Christian Hatch on 6/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "NotificationsViewController.h"

@interface NotificationsViewController ()
@property (nonatomic, strong) NotificationsTableView *tableView;
@end

@implementation NotificationsViewController
@synthesize tableView = _noteTableView;

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
    
}
-(void)setUpView{
    self.navigationItem.title = NSLocalizedString(@"Notifications", @"Notifications");
    [self.view addSubview:self.tableView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([WaxDataManager sharedManager].notificationCount.intValue > 0) {
        [self.tableView triggerPullToRefresh]; 
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.tableView.pullToRefreshView stopAnimating];
}


#pragma mark - Getters
-(NotificationsTableView *)tableView{
    if (!_noteTableView) {
        _noteTableView = [NotificationsTableView notificationsTableViewWithFrame:self.view.bounds];
    }
    return _noteTableView; 
}



- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
