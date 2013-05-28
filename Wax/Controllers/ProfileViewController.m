//
//  ProfileViewController.m
//  Wax
//
//  Created by Christian Hatch on 5/25/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "ProfileViewController.h"
#import "SettingsViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize user = _user;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self enableSwipeToPopVC:YES];
        
    [self setUpView];
    
    [self.profPicBtn addTarget:self action:@selector(chooseNewPic) forControlEvents:UIControlEventTouchUpInside];
    [self.uploadBtn addTarget:self action:@selector(uploadPic) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)chooseNewPic{
    [[WaxUser currentUser] chooseNewprofilePicture:self completion:^(UIImage *profilePicture, NSError *error) {
        
        [self.profPicBtn setBackgroundImage:profilePicture forState:UIControlStateNormal animated:YES];
        
        DLog(@"error choosing %@", error);
        
    }];
}
-(void)uploadPic{
    [[WaxUser currentUser] updateProfilePictureOnServer:[self.profPicBtn backgroundImageForState:UIControlStateNormal] andShowUICallbacks:YES completion:^(NSError *error) {
        
        DLog(@"error uploading %@", error);
        
    }];
}
-(void)setUpView{
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
