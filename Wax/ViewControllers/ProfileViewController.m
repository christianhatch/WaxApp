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
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *username; 
@end

@implementation ProfileViewController
@synthesize person = _user, userID = _userID, username = _username; 

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

-(void)setUpView{    
    if (self.person) {
        
        self.navigationItem.title = self.person.username;
        [self.view addSubview:[FeedTableView feedTableViewForProfileWithUserID:self.person.userID frame:self.view.bounds]];
        
        if (self.person.isMe) {
            self.navigationItem.title = NSLocalizedString(@"Me", @"Me"); 
            [self.view addSubview:[FeedTableView feedTableViewForMyProfileWithFrame:self.view.bounds]];
        }
    }else{
        self.navigationItem.title = self.username;
        [self.view addSubview:[FeedTableView feedTableViewForProfileWithUserID:self.userID frame:self.view.bounds]];
    }
}
-(void)showSettings:(UIBarButtonItem *)sender{
    SettingsViewController *settings = initViewControllerWithIdentifier(@"SettingsVC");
    [self.navigationController pushViewController:settings animated:YES];
}










-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

}

@end
