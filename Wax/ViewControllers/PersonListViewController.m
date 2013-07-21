//
//  PersonListViewController.m
//  Wax
//
//  Created by Christian Hatch on 6/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "PersonListViewController.h"
#import "PersonTableView.h"
#import "ProfileViewController.h"


@interface PersonListViewController () <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, readwrite) PersonTableViewType tableViewType;
@property (nonatomic, strong) PersonTableView *tableView; 
@end

@implementation PersonListViewController
@synthesize userID = _userID, tableViewType = _tableViewType, tableView; 

+(PersonListViewController *)personListViewControllerForFollowersFromUserID:(NSString *)userID{
    PersonListViewController *plvc = [[PersonListViewController alloc] init];
    plvc.tableViewType = PersonTableViewTypeFollowers;
    plvc.userID = userID; 
    return plvc;
}
+(PersonListViewController *)personListViewControllerForFollowingFromUserID:(NSString *)userID{
    PersonListViewController *plvc = [[PersonListViewController alloc] init];
    plvc.tableViewType = PersonTableViewTypeFollowing;
    plvc.userID = userID;
    return plvc;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self enableSwipeToPopVC:YES];
    
    [self setUpView];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.tableView.pullToRefreshView stopAnimating];
}

#pragma mark - Setters
-(void)setUserID:(NSString *)userID{

    NSParameterAssert(userID);
    
    if (_userID != userID) {
        _userID = userID;
        [self setUpView];
    }
}

-(void)setUpView{
    PersonTableViewDidSelectPersonBlock selectBlock = ^(PersonObject *person) {
        ProfileViewController *pvc = [ProfileViewController profileViewControllerFromPersonObject:person];
        [self.navigationController pushViewController:pvc animated:YES];
    };
    
    if (self.tableViewType == PersonTableViewTypeFollowing) {
        self.navigationItem.title = NSLocalizedString(@"Following", @"Following");
        self.tableView = [PersonTableView personTableViewForFollowingWithUserID:self.userID didSelectBlock:selectBlock frame:self.view.bounds]; 
    }else if (self.tableViewType == PersonTableViewTypeFollowers){
        self.navigationItem.title = NSLocalizedString(@"Followers", @"Followers");
        self.tableView = [PersonTableView personTableViewForFollowersWithUserID:self.userID didSelectBlock:selectBlock frame:self.view.bounds]; 
    }

    [self.view addSubview:self.tableView];
}



@end
