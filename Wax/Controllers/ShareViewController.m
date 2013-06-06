//
//  ShareViewController.m
//  Wax
//
//  Created by Christian Hatch on 6/3/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "ShareViewController.h"
#import "CategoryTableViewController.h"

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
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)setUpView{
    self.instructionsLabel.text = NSLocalizedString(@"Choose a competition tag", @"Choose a competition tag");
    self.facebookLabel.text = NSLocalizedString(@"Share to Facebook", @"Share to Facebook");
    self.twitterLabel.text = NSLocalizedString(@"Share to Twitter", @"Share to Twitter");
    self.locationLabel.text = NSLocalizedString(@"Include Location", @"Include Location");
    [self.categoryButton setTitle:NSLocalizedString(@"Choose Category", @"Choose Category") forState:UIControlStateNormal];
    self.navigationItem.title = NSLocalizedString(@"Share", @"Share");

    [self.facebookSwitch addTarget:self action:@selector(facebookSwitchToggled:) forControlEvents:UIControlEventValueChanged];
    [self.twitterSwitch addTarget:self action:@selector(twitterSwitchToggled:) forControlEvents:UIControlEventValueChanged];
    [self.categoryButton addTarget:self action:@selector(chooseCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finish:)];
    
    [self.facebookSwitch setOn:[[WaxUser currentUser] facebookAccountConnected] animated:NO];
    [self.twitterSwitch setOn:[[WaxUser currentUser] twitterAccountConnected] animated:NO];
}
-(void)finish:(id)sender{
    if ([self verifyInputtedData]) {
        [[VideoUploadManager sharedManager] addMetadataWithTag:self.tagField.text category:@"cat" shareToFacebook:self.facebookSwitch.on sharetoTwitter:self.twitterSwitch.on shareLocation:self.locationSwitch.on completion:nil];
        
        [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)facebookSwitchToggled:(UISwitch *)sender{
    //authorize facebook

}
-(void)twitterSwitchToggled:(UISwitch *)sender{
    //authorizetwitter
    
    [[WaxUser currentUser] chooseTwitterAccountWithCompletion:^(NSError *error) {
        [sender setOn:(error == nil) animated:YES];
    }];
}
-(void)chooseCategory:(UIButton *)sender{
    [CategoryTableViewController chooseCategoryWithCompletionBlock:^(NSString *category) {
        [self.categoryButton setTitle:category forState:UIControlStateNormal]; 
    } sender:self.navigationController]; 
}
-(BOOL)verifyInputtedData{
    BOOL verified = YES;
    
    if (!self.tagField.text.length) {
        verified = NO;
        [[AIKErrorManager sharedManager] showAlertWithTitle:NSLocalizedString(@"No Competition", @"No Competition") message:NSLocalizedString(@"Please enter a competition tag", @"Please enter a competition tag") buttonHandler:^{
            [self.tagField becomeFirstResponder]; 
        }];
    }else if ([self.categoryButton.titleLabel.text isEqualToString:NSLocalizedString(@"Choose Category", @"Choose Category")]){
        verified = NO;
        [[AIKErrorManager sharedManager] showAlertWithTitle:NSLocalizedString(@"No Category", @"No Category") message:NSLocalizedString(@"Please choose a category", @"Please choose a category") buttonHandler:^{
            [self.tagField becomeFirstResponder];
        }];
    }
    
    return verified; 
}



@end
