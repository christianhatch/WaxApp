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
@end

@implementation ProfileViewController
@synthesize person = _user, userID = _userID;

#pragma mark - Alloc & Init
+(ProfileViewController *)profileViewControllerFromUserID:(NSString *)userID{
    ProfileViewController *pvc = [[ProfileViewController alloc] initWithUserID:userID];
    return pvc; 
}
+(ProfileViewController *)profileViewControllerFromPersonObject:(PersonObject *)person{
    ProfileViewController *pvc = [[ProfileViewController alloc] initWithPerson:person];
    return pvc; 
}
-(instancetype)initWithUserID:(NSString *)userID{
    
    NSParameterAssert(userID);
    
    self = [super init];
    if (self) {
        self.userID = userID; 
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
        [self.view addSubview:[FeedTableView feedTableViewForUserID:self.person.userID frame:self.view.bounds]];
        
        if (self.person.isMe) {
            self.navigationItem.title = NSLocalizedString(@"Me", @"Me"); 
            UIBarButtonItem *settingsBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", @"Settings") style:UIBarButtonItemStylePlain target:self action:@selector(showSettings:)];
            self.navigationItem.rightBarButtonItem = settingsBtn;
            [self.view addSubview:[FeedTableView feedTableViewForMeWithFrame:self.view.bounds]];
        }
    }else{
        self.navigationItem.title = self.person.username;
        [self.view addSubview:[FeedTableView feedTableViewForUserID:self.userID frame:self.view.bounds]];
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
