//
//  ProfileViewController.m
//  Wax
//
//  Created by Christian Hatch on 5/25/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "ProfileViewController.h"
#import "SettingsViewController.h"

#import "CategoryTableViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize user = _user;

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
-(void)testerAction:(UIButton *)sender{
    [CategoryTableViewController chooseCategoryWithCompletionBlock:^(NSString *category) {
        DLog(@"cat %@", category);
    } sender:self.navigationController];
}

-(void)setUpView{
    [self.testerButton addTarget:self action:@selector(testerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.user) {
        
        self.navigationItem.title = [self isMe] ? NSLocalizedString(@"Me", @"Me") : self.user.username;
        
        if ([self isMe]) {
            UIBarButtonItem *settingsBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", @"Settings") style:UIBarButtonItemStylePlain target:self action:@selector(showSettings:)];
            self.navigationItem.rightBarButtonItem = settingsBtn;
        }
    }else{
        //this user does not exist!
    }
}
-(void)showSettings:(UIBarButtonItem *)sender{
    SettingsViewController *settings = initViewControllerWithIdentifier(@"SettingsVC");
    [self.navigationController pushViewController:settings animated:YES];
}









#pragma mark - Convenience Methods
-(BOOL)isMe{
    return [[WaxUser currentUser] userIDIsCurrentUser:self.user.userID];
}



-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

}

@end
