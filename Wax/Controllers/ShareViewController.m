//
//  ShareViewController.m
//  Wax
//
//  Created by Christian Hatch on 6/3/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "ShareViewController.h"
#import "CategoryChooserViewController.h"

@implementation ShareViewController
@synthesize tagField, facebookLabel, twitterLabel, locationLabel, facebookSwitch, twitterSwitch, locationSwitch, instructionsLabel, categoryButton;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self enableSwipeToPopVC:YES];
    [self enableTapToDismissKeyboard:YES];
    
    [self setUpView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)setUpView{
    self.navigationItem.title = NSLocalizedString(@"Share", @"Share");

    self.instructionsLabel.text = NSLocalizedString(@"Choose a competition tag", @"Choose a competition tag");
    self.facebookLabel.text = NSLocalizedString(@"Share to Facebook", @"Share to Facebook");
    self.twitterLabel.text = NSLocalizedString(@"Share to Twitter", @"Share to Twitter");
    self.locationLabel.text = NSLocalizedString(@"Include Location", @"Include Location");

    [self.facebookSwitch addTarget:self action:@selector(facebookSwitchToggled:) forControlEvents:UIControlEventValueChanged];
    [self.twitterSwitch addTarget:self action:@selector(twitterSwitchToggled:) forControlEvents:UIControlEventValueChanged];
    [self.categoryButton addTarget:self action:@selector(chooseCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Share", @"Share") style:UIBarButtonItemStyleDone target:self action:@selector(finish:)];
    
    [self.facebookSwitch setOn:([[WaxUser currentUser] facebookAccountConnected] && [[AIKFacebookManager sharedManager] canPublish]) animated:NO];
    [self.twitterSwitch setOn:[[WaxUser currentUser] twitterAccountConnected] animated:NO];
    
    [self setUpTagAndCategoryFields];
}
-(void)setUpTagAndCategoryFields{
    if ([[VideoUploadManager sharedManager] isInChallengeMode]) {
        self.tagField.text = [[VideoUploadManager sharedManager] challengeVideoTag];
        self.tagField.enabled = NO;
        [self.categoryButton setTitleForAllControlStates:[[VideoUploadManager sharedManager] challengeVideoCategory]];
        self.categoryButton.enabled = NO; 
    }else{
        self.tagField.enabled = YES;
        self.tagField.placeholder = NSLocalizedString(@"competition tag", @"competition tag");
        [self.categoryButton setTitleForAllControlStates:NSLocalizedString(@"Choose Category", @"Choose Category")];
        self.categoryButton.enabled = YES; 
    }
}
-(void)finish:(id)sender{
    if ([self verifyInputtedData]) {
        [[VideoUploadManager sharedManager] addMetadataWithTag:self.tagField.text category:self.categoryButton.titleLabel.text shareToFacebook:self.facebookSwitch.on sharetoTwitter:self.twitterSwitch.on shareLocation:self.locationSwitch.on completion:nil];
        
        [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)facebookSwitchToggled:(UISwitch *)sender{
    if (![[WaxUser currentUser] facebookAccountConnected]) {
        [[WaxUser currentUser] connectFacebookWithCompletion:^(NSError *error) {
            if (!error) {
                [self requestFacebookPublishPermissionsWithSenderSwitch:sender];
            }else{
                //handle error connecting to fb 
            }
        }];
    }else{
        [self requestFacebookPublishPermissionsWithSenderSwitch:sender]; 
    }
}
-(void)twitterSwitchToggled:(UISwitch *)sender{
    if (![[WaxUser currentUser] twitterAccountConnected]) {
        [[WaxUser currentUser] chooseTwitterAccountWithCompletion:^(NSError *error) {
            [sender setOn:(error == nil) animated:YES];
        }];
    }
}
-(void)chooseCategory:(UIButton *)sender{
    [self.view endEditing:YES]; 
    [CategoryChooserViewController chooseCategoryWithCompletionBlock:^(NSString *category) {
        [self.categoryButton setTitle:category forState:UIControlStateNormal]; 
    } navigationController:self.navigationController]; 
}

#pragma mark - Internal Methods
-(void)requestFacebookPublishPermissionsWithSenderSwitch:(UISwitch *)sender{
    if (![[AIKFacebookManager sharedManager] canPublish]) {
        [[AIKFacebookManager sharedManager] requestPublishPermissionsWithCompletion:^(BOOL success, NSError *error) {
            if (!error) {
                [sender setOn:success animated:YES];
            }else{
                //handle error requesting permissions
            }
        }];
    }
}
-(BOOL)verifyInputtedData{
    BOOL verified = YES;
    
    if (!self.tagField.text.length) {
        verified = NO;
        [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"No Competition", @"No Competition") message:NSLocalizedString(@"Please enter a competition tag", @"Please enter a competition tag") buttonHandler:^{
            [self.tagField becomeFirstResponder]; 
        } logError:NO];
    }else if ([self.categoryButton.titleLabel.text isEqualToString:NSLocalizedString(@"Choose Category", @"Choose Category")]){
        verified = NO;
        [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"No Category", @"No Category") message:NSLocalizedString(@"Please choose a category", @"Please choose a category") buttonHandler:^{
            [self.tagField becomeFirstResponder];
        } logError:NO];
    }
    
    return verified; 
}



@end
