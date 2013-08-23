//
//  ProfileViewController.m
//  Wax
//
//  Created by Christian Hatch on 5/25/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "ProfileViewController.h"
#import "SettingsViewController.h"
#import "FeedTableView.h"

@interface ProfileViewController ()
@property (nonatomic, strong) FeedTableView *tableView; 
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *username; 
@end

@implementation ProfileViewController
@synthesize person = _person, userID = _userID, username = _username, tableView = _tableView; 

#pragma mark - Alloc & Init
+(ProfileViewController *)profileViewControllerFromUserID:(NSString *)userID username:(NSString *)username{
    ProfileViewController *pvc = [[ProfileViewController alloc] initWithUserID:userID username:username];
    return pvc; 
}
+(ProfileViewController *)profileViewControllerFromPersonObject:(PersonObject *)person{
    ProfileViewController *pvc = [[ProfileViewController alloc] initWithPerson:person];
    return pvc; 
}
-(instancetype)initWithUserID:(NSString *)userID username:(NSString *)username{
    
    NSParameterAssert(userID);
    NSParameterAssert(username);
    
    self = [super init];
    if (self) {
        self.userID = userID;
        self.username = username; 
    }
    return self;
}
-(instancetype)initWithPerson:(PersonObject *)person{
    
    NSParameterAssert(person); 
    
    self = [super init];
    if (self) {
        self.person = person; 
    }
    return self;
}
#pragma mark - View LifeCycle
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetForLogOut:) name:WaxUserDidLogOutNotification object:nil];
    
    [self enableSwipeToPopVC:YES];
        
    [self setUpView];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.tableView.pullToRefreshView stopAnimating];
    [self.tableView resetVideoPlayers];
}

-(void)setUpView{
    [self setNavBarTitle];
    [self setProfileTableView];
    [self addProfileTableViewAsSubviewIfNecessary];
}

#pragma mark - View Setup
-(void)setNavBarTitle{
    self.navigationItem.title = self.username;
}
-(void)setProfileTableView{
    if ([self isMyProfile]) {
        self.tableView = [FeedTableView feedTableViewForMyProfileWithFrame:self.view.bounds];
    }else{
        self.tableView = [FeedTableView feedTableViewForProfileWithUserID:self.userID frame:self.view.bounds];
    }
}
-(void)addProfileTableViewAsSubviewIfNecessary{
    
    if (![self viewContainsProfileTableView]) {
        [self.view addSubview:self.tableView];
    }
}





#pragma mark - Setters
-(void)setPerson:(PersonObject *)person{
    _person = person;
    self.userID = person.userID;
    self.username = person.username;
    
    if (![self viewContainsProfileTableView]) {
        [self setUpView];
    }
}

#pragma mark - Getters
-(NSString *)userID{
    if (!_userID && self.person != nil) {
        _userID = self.person.userID;
    }
    return _userID; 
}
-(NSString *)username{
    if (!_username && self.person != nil) {
        _username = self.person.username;
    }
    return _username; 
}

#pragma mark - Internal Methods
-(void)resetForLogOut:(NSNotification *)note{
    DDLogVerbose(@"logged out");
    [self clearPersonUserIDAndUsername];
    self.tableView = nil;
}


#pragma mark - Utility Methods
-(BOOL)isMyProfile{
    return ([WaxUser userIDIsCurrentUser:self.userID] || self.person.isMe);
}
-(BOOL)viewContainsProfileTableView{
    return [self.view.subviews containsObject:self.tableView];
}
-(void)clearPersonUserIDAndUsername{
    self.person = nil;
    self.username = nil;
    self.userID = nil;
}


-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


@end
