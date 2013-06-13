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

@interface PersonListViewController ()
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, readwrite) PersonTableViewType tableViewType;

@end

@implementation PersonListViewController
@synthesize userID = _userID, tableViewType = _tableViewType;

+(PersonListViewController *)personListViewControllerForFollowersFromUserID:(NSString *)userID{
    PersonListViewController *plvc = [[PersonListViewController alloc] initWithUserID:userID];
    plvc.tableViewType = PersonTableViewTypeFollowers;
    return plvc; 
}
+(PersonListViewController *)personListViewControllerForFollowingFromUserID:(NSString *)userID{
    PersonListViewController *plvc = [[PersonListViewController alloc] initWithUserID:userID];
    plvc.tableViewType = PersonTableViewTypeFollowing;
    return plvc;
}
-(instancetype)initWithUserID:(NSString *)userID{
   
    NSParameterAssert(userID);
    
    self = [super init];
    if (self) {
        self.userID = userID; 
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self enableSwipeToPopVC:YES];
    
    [self setUpView];
}

-(void)setUpView{
    PersonTableViewDidSelectPersonBlock selectBlock = ^(PersonObject *person) {
        ProfileViewController *pvc = [ProfileViewController profileViewControllerFromPersonObject:person];
        [self.navigationController pushViewController:pvc animated:YES];
    };
    
    if (self.tableViewType == PersonTableViewTypeFollowing) {
        self.navigationItem.title = NSLocalizedString(@"Following", @"Following");
        [self.view addSubview:[PersonTableView personTableViewForFollowingWithUserID:self.userID didSelectBlock:selectBlock frame:self.view.bounds]];
    }else if (self.tableViewType == PersonTableViewTypeFollowers){
        self.navigationItem.title = NSLocalizedString(@"Followers", @"Followers");
        [self.view addSubview:[PersonTableView personTableViewForFollowwersWithUserID:self.userID didSelectBlock:selectBlock frame:self.view.bounds]];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}


@end
