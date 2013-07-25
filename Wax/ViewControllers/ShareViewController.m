//
//  ShareViewController.m
//  Wax
//
//  Created by Christian Hatch on 6/3/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#define kChooseCategoryPlaceholderText NSLocalizedString(@"required", @"category placeholder")
#define kTagFieldPlaceholderText NSLocalizedString(@"YourTagHere", @"competition tag field placeholder")

#define kTagFieldMaxCharacters 25

#import "ShareViewController.h"
#import "CategoryChooserViewController.h"

@interface ShareViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *tagFieldTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *sharingTitleLabel;

@property (strong, nonatomic) IBOutlet UITextField *tagField;
@property (strong, nonatomic) IBOutlet UIButton *categoryButton;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;

@property (strong, nonatomic) IBOutlet UISwitch *twitterSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *facebookSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *locationSwitch;

@property (strong, nonatomic) IBOutlet UILabel *twitterLabel;
@property (strong, nonatomic) IBOutlet UILabel *facebookLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

- (IBAction)twitterSwitchToggled:(id)sender;
- (IBAction)facebookSwitchToggled:(id)sender;
- (IBAction)chooseCategory:(id)sender;

@end

@implementation ShareViewController
@synthesize tagField, facebookLabel, twitterLabel, locationLabel, facebookSwitch, twitterSwitch, locationSwitch, categoryButton;

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

    self.view.backgroundColor = [UIColor waxTableViewCellSelectionColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Share", @"Share") style:UIBarButtonItemStyleDone target:self action:@selector(finish:)];

    //tagfield
    self.tagField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.tagField.spellCheckingType = UITextSpellCheckingTypeNo;
    self.tagField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.tagField.returnKeyType = UIReturnKeyDone; 
    self.tagField.delegate = self;
    self.tagField.font = [UIFont waxDefaultFont];
    self.tagField.textColor = [UIColor waxDefaultFontColor]; 
    
    UILabel *poundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 5, self.tagField.bounds.size.height)];
    poundLabel.text = @"#";
    [poundLabel setWaxDetailFontOfSize:13]; 
    poundLabel.backgroundColor = [UIColor clearColor];
    [poundLabel sizeToFit]; 
    self.tagField.leftView = poundLabel;
    self.tagField.leftViewMode = UITextFieldViewModeAlways;
    
    //share-to labels
    for (UILabel *lbl in @[self.facebookLabel, self.twitterLabel, self.locationLabel, self.categoryButton.titleLabel]) {
        [lbl setWaxDefaultFontOfSize:16];
        lbl.textAlignment = NSTextAlignmentLeft; 
    }
    
    [self.categoryButton setTitleColorForAllControlStates:[UIColor waxDefaultFontColor]];
    [self.categoryLabel setWaxDefaultFontOfSize:15 color:[UIColor waxDetailFontColor]]; 
    
    self.facebookLabel.text = NSLocalizedString(@"Facebook", @"Share to Facebook");
    self.twitterLabel.text = NSLocalizedString(@"Twitter", @"Share to Twitter");
    self.locationLabel.text = NSLocalizedString(@"Include Location", @"Include Location");
            
    [self.facebookSwitch setOn:([WaxUser currentUser].facebookAccountConnected && [[AIKFacebookManager sharedManager] canPublish]) animated:NO];
    [self.twitterSwitch setOn:[WaxUser currentUser].twitterAccountConnected animated:NO];
    
    //title labels
    [self.tagFieldTitleLabel setWaxDetailFontOfSize:13 color:[UIColor waxDefaultFontColor]];
    [self.sharingTitleLabel setWaxDetailFontOfSize:13 color:[UIColor waxDefaultFontColor]];
    
    if ([VideoUploadManager sharedManager].isInChallengeMode) {
        
        NSString *tag = [VideoUploadManager sharedManager].challengeVideoTag;
        
        self.tagField.text = [tag stringByReplacingOccurrencesOfString:@"#" withString:@""];
        self.categoryLabel.text = [VideoUploadManager sharedManager].challengeVideoCategory;
        
    }else{
        self.tagField.placeholder = kTagFieldPlaceholderText;
        self.categoryLabel.text = kChooseCategoryPlaceholderText;
    }

    self.locationLabel.hidden = YES;
    self.locationSwitch.hidden = YES;     
}

-(void)finish:(id)sender{
    if (![self verifyInputtedData]) {
        return;
    }
    
    [[VideoUploadManager sharedManager] addMetadataWithTag:self.tagField.text category:self.categoryLabel.text shareToFacebook:self.facebookSwitch.on sharetoTwitter:self.twitterSwitch.on shareLocation:self.locationSwitch.on];
    
    [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"kDidDismissSharePage" object:self];
    }];
}
- (IBAction)chooseCategory:(id)sender {
    [self.view endEditing:YES];
    [CategoryChooserViewController chooseCategoryWithCompletionBlock:^(NSString *category) {
        self.categoryLabel.text = category;
    } navigationController:self.navigationController];
}
- (IBAction)twitterSwitchToggled:(id)sender {
    if (![WaxUser currentUser].twitterAccountConnected) {
        [[WaxUser currentUser] chooseTwitterAccountWithCompletion:^(NSError *error) {
            [sender setOn:(error == nil) animated:YES];
            //TODO: handle error choosing twitter account
        }];
    }
}
- (IBAction)facebookSwitchToggled:(id)sender {
    if ([WaxUser currentUser].facebookAccountConnected) {
        [self requestFacebookPublishPermissionsWithSenderSwitch:sender];
    }else{
        [[WaxUser currentUser] connectFacebookWithCompletion:^(NSError *error) {
            if (!error) {
                [self requestFacebookPublishPermissionsWithSenderSwitch:sender]; 
            }
        }]; 
    }
}
#pragma mark - TextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([self testMaxCharacterLengthInTagFieldWithReplacementString:string andCharactersInRange:range]) {
        return NO;
    }
    if ([self testReplacementStringForNonAlphaNumericCharactersAndAlertUserWithReplacementString:string]) {
        return NO;
    }
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Internal Methods
-(void)requestFacebookPublishPermissionsWithSenderSwitch:(UISwitch *)sender{
    if (![[AIKFacebookManager sharedManager] canPublish]) {
        [[AIKFacebookManager sharedManager] requestPublishPermissionsWithCompletion:^(BOOL success, NSError *error) {
            if (error) {
                [sender setOn:NO animated:YES]; 
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
    }else if ([self.categoryLabel.text isEqualToString:kChooseCategoryPlaceholderText]){
        verified = NO;
        [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"No Category", @"No Category") message:NSLocalizedString(@"Please choose a category", @"Please choose a category") buttonHandler:^{
            [self chooseCategory:nil];
        } logError:NO];
    }
    
    return verified; 
}
-(BOOL)testReplacementStringForNonAlphaNumericCharactersAndAlertUserWithReplacementString:(NSString *)string{
    NSCharacterSet *blockedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    
    BOOL notAllowed = [string rangeOfCharacterFromSet:blockedCharacters].location != NSNotFound;
    
    if (notAllowed) [self notifyUserThatNonAlphaNumericCharactersNotAllowed];
    
    return notAllowed;
}

-(BOOL)testMaxCharacterLengthInTagFieldWithReplacementString:(NSString *)string andCharactersInRange:(NSRange)range{
    NSUInteger oldLength = self.tagField.text.length;
    NSUInteger replacementLength = string.length;
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString:@"\n"].location != NSNotFound;
    
    return !(newLength <= kTagFieldMaxCharacters || returnKey);
}
-(void)notifyUserThatNonAlphaNumericCharactersNotAllowed{
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Only letters and/or numbers are allowed", @"Please enter only letters and/or numbers")];
}



@end
