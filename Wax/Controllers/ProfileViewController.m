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

#import "CategoryChooserViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize person = _user;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self enableSwipeToPopVC:YES];
        
    [self setUpView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)setUpView{    
    if (self.person) {
        
        self.navigationItem.title = self.person.isMe ? NSLocalizedString(@"Me", @"Me") : self.person.username;
        
        if (self.person.isMe) {
            UIBarButtonItem *settingsBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", @"Settings") style:UIBarButtonItemStylePlain target:self action:@selector(showSettings:)];
            self.navigationItem.rightBarButtonItem = settingsBtn;
        }
        [self.view addSubview:[FeedTableView feedTableViewForMeWithFrame:self.view.bounds]];
        
    }else{
        //this user does not exist!
    }
}
-(void)showSettings:(UIBarButtonItem *)sender{
    SettingsViewController *settings = initViewControllerWithIdentifier(@"SettingsVC");
    [self.navigationController pushViewController:settings animated:YES];
//    [CategoryChooserViewController chooseCategoryWithCompletionBlock:^(NSString *category) {
//        [SVProgressHUD showSuccessWithStatus:category];
//    } navigationController:self.navigationController];
}










-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

}

@end
