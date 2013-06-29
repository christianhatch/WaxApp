//
//  SettingsViewController.m
//  Wax
//
//  Created by Christian Hatch on 5/25/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "SettingsViewController.h"
#import <MessageUI/MessageUI.h>


#define SectionNotifications        0
#define SectionPersonalInformation  1
#define SectionSocialAccounts       2
#define SectionOtherSettings        0


@interface SettingsViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation SettingsViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setUpView];
    
}

-(void)setUpView{
    [self.cameraRollSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:kUserSaveToCameraRollKey] animated:NO];
    [self.cameraRollSwitch addTarget:self action:@selector(cameraRollSwitched:) forControlEvents:UIControlEventValueChanged];
}

-(void)cameraRollSwitched:(UISwitch *)sender{
    [[NSUserDefaults standardUserDefaults] setBool:self.cameraRollSwitch.on forKey:kUserSaveToCameraRollKey];
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
        UIAlertView *nomail = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Cannot Send Email", @"Cannot Send Email") message:NSLocalizedString(@"Messaging is not available on this device at this time.", @"Messaging is not available on this device at this time.") cancelButtonItem:[RIButtonItem randomDismissalButton] otherButtonItems:nil, nil];
        [nomail show];
    }
}



#pragma mark - Table view delegate
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL should = NO;
    
    if ((indexPath.section == SectionOtherSettings) && (indexPath.row == 1 || indexPath.row == 2)) {
        should = YES;
    }
    
    return should;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == SectionOtherSettings) {
        if (indexPath.row == 1){ //submit feedback
            [self sendFeedback];
        }else if (indexPath.row == 2){ //logout
            
            RIButtonItem *yes = [RIButtonItem item];
            yes.label = NSLocalizedString(@"Log Out", @"Log Out");
            yes.action = ^{
                [[WaxUser currentUser] logOut];
            };
            
            UIAlertView *sure = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Log Out?", @"Log Out?") message:NSLocalizedString(@"Are you sure you want to log out?", @"Are you sure you want to log out?") cancelButtonItem:[RIButtonItem cancelButton] otherButtonItems:yes, nil];
            [sure show]; 
        }
    }

}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title = nil;
    
    if (section == SectionOtherSettings) {
        NSLocalizedString(@"General Settings", @"General Settings"); 
    }
    return title;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    NSString *title = nil;
    if (section == SectionOtherSettings) {
        title = [NSString stringWithFormat:NSLocalizedString(@"%@\nCopyright \u00A9 2013 Acacia Interactive", @"%@\nCopyright \u00A9 2013 Acacia Interactive"), [NSString appNameVersionAndBuildString]];
    }
    return title;
}


#pragma mark - MailComposeDelegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MFMailComposeResultSent:{
            RIButtonItem *item = [RIButtonItem itemWithLabel:NSLocalizedString(@"You're Welcome!", @"You're Welcome!")];
            item.action = nil;
            UIAlertView *nomail = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Thanks So Much!", @"Thanks So Much!") message:NSLocalizedString(@"Thanks for the feedback, we'll read it right away!", @"Thanks for the feedback, we'll read it right away!") cancelButtonItem:item otherButtonItems:nil, nil];
            [nomail show];
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