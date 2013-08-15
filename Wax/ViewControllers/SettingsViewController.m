//
//  SettingsViewController.m
//  Wax
//
//  Created by Christian Hatch on 5/25/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "SettingsViewController.h"
#import <MessageUI/MessageUI.h>


#define SectionSocialAccounts       0
#define SectionGeneralSettings      1
//#define SectionNotifications        0
//#define SectionPersonalInformation  1


@interface SettingsViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *facebookLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterLabel;

@property (strong, nonatomic) IBOutlet UISwitch *cameraRollSwitch;
- (IBAction)cameraRollSwitchValueChanged:(id)sender;

@end

@implementation SettingsViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self enableSwipeToPopVC:YES];
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    [self setUpView];
    self.navigationItem.title = NSLocalizedString(@"Settings", @"Settings"); 
}

-(void)setUpView{
    [self.cameraRollSwitch setOn:[WaxUser currentUser].shouldSaveVideosToCameraRoll animated:NO];

    if ([WaxUser currentUser].facebookAccountConnected) {
        self.facebookLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Facebook: %@", @"facebook connected"), [WaxUser currentUser].fullName];
    }
    
    if ([WaxUser currentUser].twitterAccountConnected) {
        self.twitterLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Twitter: %@", @"twitter connected"), [WaxUser currentUser].twitterAccountName];
    }
    
}
- (IBAction)cameraRollSwitchValueChanged:(id)sender {
    [WaxUser currentUser].shouldSaveVideosToCameraRoll = self.cameraRollSwitch.on;
}


#pragma mark - Table view delegate
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL should = NO;
    
    BOOL generalSettingsHighlight = (indexPath.section == SectionGeneralSettings) && (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3);
    
    if (generalSettingsHighlight) {
        should = YES;
    }
    
    return should;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == SectionSocialAccounts) {
        if (indexPath.row == 0) { //fb
            
        }else if (indexPath.row == 1){ //twitter
            
        }
    }
    
    if (indexPath.section == SectionGeneralSettings) {
        if (indexPath.row == 1){ //submit feedback
            [self sendFeedback];
        }else if (indexPath.row == 2){ //logout
            
            RIButtonItem *yes = [RIButtonItem itemWithLabel:NSLocalizedString(@"Log Out", @"Log Out")];
            yes.action = ^{
                [[WaxUser currentUser] logOut];
            };
            
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Log Out?", @"Log Out?") message:NSLocalizedString(@"Are you sure you want to log out?", @"Are you sure you want to log out?") cancelButtonItem:[RIButtonItem cancelButton] otherButtonItems:yes, nil] show];
        }
    }

}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
  
    NSString *title = nil;
    
    if (section == SectionGeneralSettings) {
        title = NSLocalizedString(@"General", @"General");
    }else if (section == SectionSocialAccounts){
        title = NSLocalizedString(@"Profile", @"Profile");
    }
    
    return title;
}

#pragma mark - Internal Methods
-(void)sendFeedback{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailie = [[MFMailComposeViewController alloc] init];
        
        [mailie setSubject:[NSString stringWithFormat:@"Feedback for %@", [NSString appNameVersionAndBuildString]]];
        [mailie setToRecipients:@[@"dev@wax.li"]];
        [mailie setMessageBody:[NSString stringWithFormat:@"\n\n\n\n\n\n%@\n%@", [NSString appNameVersionAndBuildString], [NSString deviceModelAndVersionString]] isHTML:NO];
        [mailie setMailComposeDelegate:self];
        [self presentViewController:mailie animated:YES completion:nil];
        
    }else{
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Cannot Send Email", @"Cannot Send Email") message:NSLocalizedString(@"Messaging is not available on this device at this time.", @"Messaging is not available on this device at this time.") cancelButtonItem:[RIButtonItem randomDismissalButton] otherButtonItems:nil, nil] show];
    }
}


#pragma mark - MailComposeDelegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    switch (result) {
        case MFMailComposeResultSent:{
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Thank you!", @"Thank you!")];
        }break;
        case MFMailComposeResultSaved:{
            
        }break;
        case MFMailComposeResultCancelled:{
            
        }break;
        case MFMailComposeResultFailed:{
            
        }break;
    }
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
