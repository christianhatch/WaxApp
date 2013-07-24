//
//  ShareViewController.m
//  Wax
//
//  Created by Christian Hatch on 6/3/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#define kChooseCategoryPlaceHolderText NSLocalizedString(@"tap to choose category", @"tap to choose category")
#define kTagFieldMaxCharacters 25

#import "ShareViewController.h"
#import "CategoryChooserViewController.h"

@interface ShareViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *tagField;
@property (strong, nonatomic) IBOutlet WaxRoundButton *categoryButton;

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

    self.tagField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.tagField.spellCheckingType = UITextSpellCheckingTypeNo;
    self.tagField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.tagField.returnKeyType = UIReturnKeyDone; 
    self.tagField.delegate = self;
   
    UILabel *poundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 5, self.tagField.bounds.size.height)];
    poundLabel.text = @"#";
    poundLabel.font = self.tagField.font;
    poundLabel.backgroundColor = [UIColor clearColor];
    [poundLabel sizeToFit]; 
    self.tagField.leftView = poundLabel;
    self.tagField.leftViewMode = UITextFieldViewModeAlways;
    
    
    for (UILabel *lbl in @[self.facebookLabel, self.twitterLabel, self.locationLabel]) {
        [lbl setWaxDefaultFont];
        lbl.textAlignment = NSTextAlignmentLeft; 
    }
    
    self.facebookLabel.text = NSLocalizedString(@"Share to Facebook", @"Share to Facebook");
    self.twitterLabel.text = NSLocalizedString(@"Share to Twitter", @"Share to Twitter");
    self.locationLabel.text = NSLocalizedString(@"Include Location", @"Include Location");
            
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Share", @"Share") style:UIBarButtonItemStyleDone target:self action:@selector(finish:)];
    
    [self.facebookSwitch setOn:([WaxUser currentUser].facebookAccountConnected && [[AIKFacebookManager sharedManager] canPublish]) animated:NO];
    [self.twitterSwitch setOn:[WaxUser currentUser].twitterAccountConnected animated:NO];
    
    [self setUpTagAndCategoryFields];

    self.locationLabel.hidden = YES;
    self.locationSwitch.hidden = YES;     
}
-(void)setUpTagAndCategoryFields{
    if ([VideoUploadManager sharedManager].isInChallengeMode) {
        
        NSString *tag = [VideoUploadManager sharedManager].challengeVideoTag;
        self.tagField.text = [tag stringByReplacingOccurrencesOfString:@"#" withString:@""];
        
        [self.categoryButton styleAsWaxRoundButtonBlueWithTitle:[VideoUploadManager sharedManager].challengeVideoCategory];
        
    }else{
        self.tagField.placeholder = NSLocalizedString(@"ExampleCompetitionTag", @"competition tag field placeholder");
        [self.categoryButton styleAsWaxRoundButtonBlueWithTitle:kChooseCategoryPlaceHolderText];
    }
}
-(void)finish:(id)sender{
    if (![self verifyInputtedData]) {
        return;
    }
    
    [[VideoUploadManager sharedManager] addMetadataWithTag:self.tagField.text category:self.categoryButton.titleLabel.text shareToFacebook:self.facebookSwitch.on sharetoTwitter:self.twitterSwitch.on shareLocation:self.locationSwitch.on];
    
    [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"kDidDismissSharePage" object:self];
    }];
}
- (IBAction)chooseCategory:(id)sender {
    [self.view endEditing:YES];
    [CategoryChooserViewController chooseCategoryWithCompletionBlock:^(NSString *category) {
        [self.categoryButton setTitle:category forState:UIControlStateNormal];
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
    }else if ([self.categoryButton.titleLabel.text isEqualToString:kChooseCategoryPlaceHolderText]){
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
