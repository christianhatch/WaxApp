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
    
    [self enableSwipeToPopVC:YES];
        
    [self setUpView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setUpView]; 
}
-(void)setUpView{
    self.navigationItem.title = self.username;
    if (![self.view.subviews containsObject:self.tableView]) {
        [self.view addSubview:self.tableView];
    }
}

-(void)showSettings:(UIBarButtonItem *)sender{
    SettingsViewController *settings = initViewControllerWithIdentifier(@"SettingsVC");
    [self.navigationController pushViewController:settings animated:YES];
}

#pragma mark - Setters
-(void)setPerson:(PersonObject *)person{
    _person = person;
    self.userID = person.userID;
    self.username = person.username;
    
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    
    [self setUpView]; 
}

#pragma mark - Getters
-(FeedTableView *)tableView{
    if (!_tableView) {
        _tableView = [FeedTableView feedTableViewForProfileWithUserID:self.userID frame:self.view.bounds]; 
    }
    return _tableView; 
}

-(NSString *)userID{
    if (!_userID) {
        if (self.person) {
            _userID = self.person.userID;
        }
    }
    return _userID; 
}
-(NSString *)username{
    if (!_username) {
        if (self.person) {
            _username = self.person.username;
        }
    }
    return _username; 
}





-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

}

@end
