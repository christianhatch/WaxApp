//
//  SendChallengeTopCell.m
//  Wax
//
//  Created by Christian Hatch on 7/17/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "SendChallengeCell.h"
#import <MessageUI/MessageUI.h>

@interface SendChallengeCell () <MFMessageComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;

@property (nonatomic, strong) NSString *challengeTag;
@property (nonatomic, strong) NSURL *challengeShareURL;
@end

@implementation SendChallengeCell
@synthesize cellType = _cellType, challengeShareURL, challengeTag, iconView, textLabel; 

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.textLabel setWaxDefaultFontOfSize:14];
}
-(void)setUpView{
    switch (self.cellType) {
        case SendChallengeCellTypeContacts:{
            self.textLabel.text = NSLocalizedString(@"Send challenge via text message", @"challenge via text string");
            self.iconView.image = [UIImage imageNamed:@"sms_icon"];
            self.iconView.highlightedImage = [UIImage imageNamed:@"sms_icon_onClick"];
        }break;
        case SendChallengeCellTypeFacebook:{
            
        }break;
        case SendChallengeCellTypeTwitter:{
            
        }break; 
    }    
}
-(void)setCellType:(SendChallengeCellType)cellType{
    if (_cellType != cellType){
        _cellType = cellType;
        [self setUpView];
    }
}
-(void)setChallengeTag:(NSString *)tag shareURL:(NSURL *)shareURL{
    self.challengeTag = tag;
    self.challengeShareURL = shareURL;
}

-(void)didSelect{
    switch (self.cellType) {
        case SendChallengeCellTypeContacts:{
            [self sendViaText]; 
        }break;
        case SendChallengeCellTypeFacebook:{
            
        }break;
        case SendChallengeCellTypeTwitter:{
            
        }break;
    }
}

-(void)sendViaText{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *texter = [[MFMessageComposeViewController alloc] init];
        
        texter.body = [NSString sharingTextFromCompetitionTag:self.challengeTag andShareURL:self.challengeShareURL];

        texter.messageComposeDelegate = self;
        
        [self.nearestViewController presentViewController:texter animated:YES completion:nil];
        
    }else{
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Cannot Send Text", @"Cannot Send Text") message:NSLocalizedString(@"Messaging is not available on this device at this time.", @"Messaging is not available on this device at this time.") cancelButtonItem:[RIButtonItem randomDismissalButton] otherButtonItems:nil, nil] show];
    }
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    switch (result) {
        case MessageComposeResultCancelled:
            [AIKErrorManager logMessageToAllServices:@"user canceled challenging via text message"];
            [controller dismissViewControllerAnimated:YES completion:nil];
            break;
        case MessageComposeResultFailed:
            [AIKErrorManager logMessageToAllServices:@"sending challenge via text failed"];
            [controller dismissViewControllerAnimated:YES completion:nil];
            break;
        case MessageComposeResultSent:
            [AIKErrorManager logMessageToAllServices:@"user challenged via text message"];
            [controller dismissViewControllerAnimated:YES completion:^{
                [self.nearestNavigationController popViewControllerAnimated:YES];
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:NSLocalizedString(@"Sent %@ via text!", @"Sent tag success message"), self.challengeTag]];
            }];
            break;
    }
}






@end
