//
//  WaxUser.m
//  Kiwi
//
//  Created by Christian Hatch on 1/21/13.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "WaxUser.h"
#import "Lockbox.h"
#import <Crashlytics/Crashlytics.h>
#import <AcaciaKit/Flurry.h>

NSString *const WaxUserDidLogInNotification = @"WaxUserLoggedIn";
NSString *const WaxUserDidLogOutNotification = @"WaxUserLoggedOut"; 

@interface WaxUser () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) WaxUserCompletionBlockTypeProfilePicture profilePictureCompletion;

@end

@implementation WaxUser
@synthesize profilePictureCompletion;

+(WaxUser *)currentUser{
    static WaxUser *sharedID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedID = [[WaxUser alloc] init];
    });
    return sharedID;
}

#pragma mark - User Information Getters
-(NSString *)token{
   
    NSString *securityToken = [Lockbox stringForKey:kUserTokenKey];
    
    if ([NSString isEmptyOrNil:securityToken] || [securityToken isEqualToString:kFalseString]) {
        return kFalseString; 
    }
    
    NSInteger time = [[NSDate date] timeIntervalSince1970]/300;
    NSString *hashed = [[NSString stringWithFormat:@"%@%i%@", securityToken, time, kWaxAPISalt] MD5];
    return hashed;
}
-(NSString *)userID{
    NSString *userIdentification = [Lockbox stringForKey:kUserIDKey];
  
    if ([NSString isEmptyOrNil:userIdentification]){
        userIdentification = kFalseString;
    }
    
    return userIdentification;
}

-(NSString *)username{
    return [Lockbox stringForKey:kUserNameKey];
}
-(NSString *)fullName{
    return [Lockbox stringForKey:kUserFirstNameKey];
}
-(NSString *)email{
    return [Lockbox stringForKey:kUserEmailKey];
}

-(NSString *)facebookAccountID{
    NSString *fbid = [Lockbox stringForKey:kUserFacebookAccountIDKey];
    
    if ([NSString isEmptyOrNil:fbid]) {
        fbid = kFalseString;
    }
    
    return fbid;
}
-(NSString *)twitterAccountID{
    NSString *twid = [Lockbox stringForKey:kUserTwitterAccountIDKey];
    if ([NSString isEmptyOrNil:twid]) {
        twid = kFalseString;
    }
    return twid;
}
-(NSString *)twitterAccountName{
    NSString *name = @"none";
    if (self.twitterAccountConnected) {
        ACAccount *twitter = [[AIKTwitterManager sharedManager] accountForIdentifier:self.twitterAccountID];
        name = [NSString stringWithFormat:@"@%@",twitter.username];
    }
    return name;
}
-(BOOL)shouldSaveVideosToCameraRoll{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kShouldSaveToCameraRollKey]; 
}
-(BOOL)isLoggedIn{
    return ((![self.userID isEqualToString:kFalseString]) && (![self.token isEqualToString:kFalseString]));
}
-(BOOL)twitterAccountConnected{
    return (![self.twitterAccountID isEqualToString:kFalseString]);
}
-(BOOL)facebookAccountConnected{
    return (![self.facebookAccountID isEqualToString:kFalseString]);
}
-(PersonObject *)personObject{
    PersonObject *me = [[PersonObject alloc] init];
    me.userID = self.userID;
    me.username = self.username;
    me.fullName = self.fullName;
    return me;
}

#pragma mark - User Information Setters
-(void)setToken:(NSString *)token{
    if ([NSString isEmptyOrNil:token]){
        [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Internal Error", @"Internal Error") message:NSLocalizedString(@"Wax has encountered and internal error, and you have been logged out. Please log in again.", @"Wax has encountered and internal error, and you have been logged out Please log in again.") buttonTitle:NSLocalizedString(@"OK", @"OK") showsCancelButton:NO buttonHandler:^{
            [self logOut];
        } logError:YES];
    }else{
        [Lockbox setString:token forKey:kUserTokenKey];
    }
}
-(void)setUserID:(NSString *)userID{
    if ([NSString isEmptyOrNil:userID]){
        [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Internal Error", @"Internal Error") message:NSLocalizedString(@"Wax has encountered and internal error, and you have been logged out. Please log in again.", @"Wax has encountered and internal error, and you have been logged out Please log in again.") buttonTitle:NSLocalizedString(@"OK", @"OK") showsCancelButton:NO buttonHandler:^{
            [self logOut];
        } logError:YES];
    }else{
        [Lockbox setString:userID forKey:kUserIDKey];
    }
}

-(void)setUsername:(NSString *)username{
    [Lockbox setString:username forKey:kUserNameKey];
}
-(void)setFullName:(NSString *)fullName{
    [Lockbox setString:fullName forKey:kUserFirstNameKey];
}
-(void)setEmail:(NSString *)email{
    [Lockbox setString:email forKey:kUserEmailKey];
}

-(void)setFacebookAccountID:(NSString *)facebookAccountID{
    if (![NSString isEmptyOrNil:facebookAccountID]){
        [Lockbox setString:facebookAccountID forKey:kUserFacebookAccountIDKey];
    }
}
-(void)setTwitterAccountID:(NSString *)twitterAccountID{
    if ([NSString isEmptyOrNil:twitterAccountID]){
        [AIKErrorManager logMessageToAllServices:@"tried to save null twitter ID"];
    }else{
        [Lockbox setString:twitterAccountID forKey:kUserTwitterAccountIDKey];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kWaxNotificationTwitterAccountDidChange object:self];
    }
}
-(void)setShouldSaveVideosToCameraRoll:(BOOL)shouldSaveVideosToCameraRoll{
    [[NSUserDefaults standardUserDefaults] setBool:shouldSaveVideosToCameraRoll forKey:kShouldSaveToCameraRollKey];
    [[NSUserDefaults standardUserDefaults] synchronize]; 
}

#pragma mark - Signup/Login/Logout/Update Pic
-(void)createAccountWithUsername:(NSString *)username fullName:(NSString *)fullName email:(NSString *)email facebookID:(NSString *)facebookID completion:(WaxUserCompletionBlockTypeSimple)completion{
    
    [[WaxAPIClient sharedClient] createAccountWithUsername:username fullName:fullName email:email passwordOrFacebookID:facebookID isFacebookLogin:YES completion:^(LoginObject *loginResponse, NSError *error) {
        
        if (!error) {
            [self finishLoggingInAndSaveUserInformation:loginResponse completion:^(NSError *error) {
                if (!error) {
                    if (completion) {
                        completion(nil);
                    }
                }
            }];
        }else{
            [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Problem Creating Account", @"Problem Creating Account") error:error buttonHandler:nil logError:YES];
            if (completion) {
                completion(error);
            }
        }
    }];

}
-(void)createAccountWithUsername:(NSString *)username fullName:(NSString *)fullName email:(NSString *)email password:(NSString *)password profilePicture:(UIImage *)profilePicture completion:(WaxUserCompletionBlockTypeSimple)completion{
  
    [[WaxAPIClient sharedClient] createAccountWithUsername:username fullName:fullName email:email passwordOrFacebookID:password isFacebookLogin:NO completion:^(LoginObject *loginResponse, NSError *error) {
        
        if (!error) {
            [self finishLoggingInAndSaveUserInformation:loginResponse completion:^(NSError *error) {
                
                [self updateProfilePictureOnServer:profilePicture andShowUICallbacks:NO completion:^(NSError *error) {
                    if (!error) {
                        if (completion) {
                            completion(error);
                        }
                    }
                }];
                
            }];
        }else{
            [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Problem Creating Account", @"Problem Creating Account") error:error buttonHandler:nil logError:YES];
            if (completion) {
                completion(error);
            }
        }
    }];
}
-(void)loginWithFacebookID:(NSString *)facebookID fullName:(NSString *)fullName email:(NSString *)email completion:(WaxUserCompletionBlockTypeSimple)completion{
    
    [[WaxAPIClient sharedClient] loginWithFacebookID:facebookID fullName:fullName email:email completion:^(LoginObject *loginResponse, NSError *error) {
        if (!error) {
            [self finishLoggingInAndSaveUserInformation:loginResponse completion:completion];
        }else{
            [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Problem Logging in via Facebook", @"Problem Logging in via Facebook") error:error buttonHandler:nil logError:YES];

            if (completion) {
                completion(error);
            }
        }
    }];
}
-(void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(WaxUserCompletionBlockTypeSimple)completion{
    [[WaxAPIClient sharedClient] loginWithUsername:username password:password completion:^(LoginObject *loginResponse, NSError *error) {
        if (!error) {
            [self finishLoggingInAndSaveUserInformation:loginResponse completion:completion];
        }else{
            [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Problem Logging in via Email", @"Problem Logging in via Email") error:error buttonHandler:nil logError:YES];
            if (completion) {
                completion(error);
            }
        }
    }];
}
-(void)finishLoggingInAndSaveUserInformation:(LoginObject *)loginResponse completion:(WaxUserCompletionBlockTypeSimple)completion{

    self.token = loginResponse.token;
    self.userID = loginResponse.userID;

    self.username = loginResponse.username;
    self.fullName = loginResponse.fullName;
    self.email = loginResponse.email;

    self.facebookAccountID = loginResponse.facebookID;
    
    [WaxUser saveCurrentUserToVendorSolutions];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)];
    
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:WaxUserDidLogInNotification object:self];

    if (completion) {
        completion(nil);
    }
}

#pragma mark - Profile Picture
-(void)chooseNewprofilePictureFromViewController:(UIViewController *)sender completion:(WaxUserCompletionBlockTypeProfilePicture)completion{
    
    self.profilePictureCompletion = completion;
    
    UIActionSheet *proPicSheet = [[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:nil destructiveButtonItem:nil otherButtonItems:nil, nil];
    
    RIButtonItem *choosePic = [RIButtonItem itemWithLabel:NSLocalizedString(@"Choose Picture", @"Choose Picture")];
    choosePic.action = ^{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [sender presentViewController:picker animated:YES completion:nil];
    };
    RIButtonItem *takePic = [RIButtonItem itemWithLabel:NSLocalizedString(@"Take Picture", @"Take Picture")];
    takePic.action = ^{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [sender presentViewController:picker animated:YES completion:nil];
    };
    RIButtonItem *cancel = [RIButtonItem cancelButton];
    cancel.action = ^{
        if (completion) {
            completion(nil, nil);
        }
    };
    
    if (self.facebookAccountConnected) {
        RIButtonItem *fbook = [RIButtonItem itemWithLabel:NSLocalizedString(@"Use Facebook Profile Picture", @"Use Facebook Profile Picture")];
        fbook.action = ^{
            
            [self syncFacebookProfilePictureShowingUICallbacks:YES withCompletion:^(NSError *error) {
                if (error) {
                    [AIKErrorManager logMessage:@"failed to sync facebook profile picture" withError:error];
                }
            }];
            
            [[AIKFacebookManager sharedManager] fetchProfilePictureForFacebookID:self.facebookAccountID completion:^(NSError *error, UIImage *profilePic) {
                
                if (completion) {
                    completion(profilePic, error);
                }
                
            }];
        };
        
        [proPicSheet addButtonItem:fbook];
        [proPicSheet addButtonItem:takePic];
        [proPicSheet addButtonItem:choosePic];
    }else{
        [proPicSheet addButtonItem:takePic];
        [proPicSheet addButtonItem:choosePic];
    }
    
    [proPicSheet setCancelButtonIndex:[proPicSheet addButtonItem:[RIButtonItem cancelButton]]];
    [proPicSheet showInView:mainWindowView];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *profPic = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (self.isLoggedIn) {
        [self updateProfilePictureOnServer:profPic andShowUICallbacks:YES completion:^(NSError *error) {
            if (self.profilePictureCompletion) {
                self.profilePictureCompletion(profPic, error);
            }
        }];
    }else{
        if (self.profilePictureCompletion) {
            self.profilePictureCompletion(profPic, nil);
        }
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.profilePictureCompletion) {
        self.profilePictureCompletion(nil, nil);
    }
}

-(void)updateProfilePictureOnServer:(UIImage *)profilePicture andShowUICallbacks:(BOOL)showUICallbacks completion:(WaxUserCompletionBlockTypeSimple)completion{
    
    if (!self.isLoggedIn) {
        return;
    }
        
    if (showUICallbacks) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Updating Profile Picture...", @"Updating Profile Picture...")];
    }
    
    
    [[WaxAPIClient sharedClient] uploadProfilePicture:profilePicture progress:^(CGFloat percentage, NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
       
        if (showUICallbacks) {
            [SVProgressHUD showProgress:percentage status:NSLocalizedString(@"Updating Profile Picture...", @"Updating Profile Picture...")];
        }

    } completion:^(BOOL complete, NSError *error) {
        if (complete) {
            
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kWaxNotificationProfilePictureDidChange object:self];

            if (showUICallbacks) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Updated Profile Picture!", @"Updated Profile Picture!")];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error Updating Profile Picture", @"Error Updating Profile Picture")];
        }
        if (completion) {
            completion(error);
        }
    }];
}
-(void)syncFacebookProfilePictureShowingUICallbacks:(BOOL)showUICallbacks withCompletion:(WaxUserCompletionBlockTypeSimple)completion{
    
    if (showUICallbacks) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Syncing Facebook Profile Picture...", @"Syncing Facebook Profile Picture...")];
    }
    
    [[WaxAPIClient sharedClient] syncFacebookProfilePictureWithCompletion:^(BOOL complete, NSError *error) {
        
        if (complete) {
            
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kWaxNotificationProfilePictureDidChange object:self];

            if (showUICallbacks) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Synced Facebook Profile Picture!", @"Synced Facebook Profile Picture!")];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error Syncing Facebook Profile Picture", @"Error Syncing Facebook Profile Picture")];
        }
        
        if (completion) {
            completion(error); 
        }
        
    }];
}

-(void)logOut{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [[[WaxAPIClient sharedClient] operationQueue] cancelAllOperations];
    [[AIKFacebookManager sharedManager] logoutFacebookWithCompletion:nil];
    [WaxUser resetForInitialLaunch];
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:WaxUserDidLogOutNotification object:self]; 
}

#pragma mark - Social
-(void)chooseTwitterAccountWithCompletion:(WaxUserCompletionBlockTypeSimple)completion{
    [[AIKTwitterManager sharedManager] chooseTwitterAccountAlreadyConnected:self.twitterAccountConnected withCompletion:^(ACAccount *twitterAccount, NSError *error) {
        if (twitterAccount) {
            self.twitterAccountID = twitterAccount.identifier;
            if (completion) {
                completion(nil);
            }
        }else{
            self.twitterAccountID = kFalseString;
            if (completion) {
                completion(error);
            }
        }
    }];
}
-(void)connectFacebookWithCompletion:(WaxUserCompletionBlockTypeSimple)completion{
    [[AIKFacebookManager sharedManager] connectFacebookWithCompletion:^(id<FBGraphUser> user, NSError *error) {
        //TODO: (7.19.13) - check this out, previously it was if(!error) but that doesn't seem to make sense in context, so i switched it.. 
        if (error) {
            [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Error logging into Facebook", @"Error logging into Facebook") error:error buttonHandler:nil logError:NO];
        }else{
            [[WaxAPIClient sharedClient] connectFacebookAccountWithFacebookID:user.id completion:^(BOOL complete, NSError *error) {
                if (!error) {
                    self.facebookAccountID = user.id;
                }else{
                    [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Error Connecting Facebook to Wax", @"Error Connecting Facebook to Wax") error:error buttonHandler:nil logError:NO];
                }
                if (completion) {
                    completion(error); 
                }
            }];
        }
    }];
}
-(void)fetchMatchedContactsWithCompletion:(WaxUserCompletionBlockTypeList)completion{
    [[AIKContactsManager sharedManager] requestAccessToContactsWithCompletion:^(BOOL granted) {
        if (granted) {
            [[AIKContactsManager sharedManager] allContactsAsDictionariesForUploadingToServerWithCompletion:^(NSMutableArray *contacts) {
                [[WaxAPIClient sharedClient] fetchMatchedContactsOnWaxWithContacts:contacts completion:^(NSMutableArray *list, NSError *error) {

                    if (completion) {
                        completion(list, error);
                    }
                    
                }];
            }];
        }else{
            //TODO: handle not being granted access
        }
    }];
}
-(void)fetchMatchedFacebookFriendsWithCompletion:(WaxUserCompletionBlockTypeList)completion{
    if (self.facebookAccountConnected) {
        [[WaxAPIClient sharedClient] fetchMatchedFacebookFriendsOnWaxWithFacebookID:self.facebookAccountID facebookAccessToken:[[AIKFacebookManager sharedManager] accessToken] completion:^(NSMutableArray *list, NSError *error) {

            if (completion) {
                completion(list, error);
            }
            
        }];
    }else{
        //TODO: present alertview asking to connect to fb, making it so that if they click yes it'll connect to fb and then fetch the contacts 
    }
}

#pragma mark - Utility Methods
-(SettingsObject *)settingsObject{
    SettingsObject *settings = [[SettingsObject alloc] init];
    settings.username = self.username;
    settings.fullName = self.fullName;
    settings.email = self.email;
    settings.facebookID = self.facebookAccountID;
    settings.pushSettings = [NSDictionary dictionary];
    return settings; 
}
+(BOOL)userIDIsCurrentUser:(NSString *)userID{
    return [[WaxUser currentUser].userID isEqualToString:userID];
}

+(void)saveCurrentUserToVendorSolutions{
    if (![WaxUser currentUser].isLoggedIn) {
        return; 
    }
    
    [Flurry setUserID:[WaxUser currentUser].userID];
    
    [Crashlytics setUserIdentifier:[WaxUser currentUser].userID];
    [Crashlytics setUserName:[WaxUser currentUser].username];
    [Crashlytics setUserEmail:[WaxUser currentUser].email];
    
    [Crashlytics setObjectValue:[NSString versionAndBuildString] forKey:@"Version"];
    [Crashlytics setObjectValue:[WaxUser currentUser].userID forKey:@"userid"];
    [Crashlytics setObjectValue:[WaxUser currentUser].username forKey:@"username"];
    [Crashlytics setObjectValue:[WaxUser currentUser].email forKey:@"email"];
}

+(void)resetForInitialLaunch{
    [WaxUser currentUser].token = kFalseString;
    [WaxUser currentUser].userID = kFalseString;
    
    [WaxUser currentUser].username = kFalseString;
    [WaxUser currentUser].fullName = kFalseString;
    [WaxUser currentUser].email = kFalseString;
    
    [WaxUser currentUser].twitterAccountID = kFalseString;
    [WaxUser currentUser].facebookAccountID = kFalseString;
    
    [WaxUser currentUser].shouldSaveVideosToCameraRoll = YES; 
}


-(NSString *)description{
    NSString *descrippy = [NSString stringWithFormat:@"WaxUser Description: Token=%@ \nUserID=%@ \nUsername=%@ \nFullName=%@ \nEmail=%@ \nFacebookAccountID=%@ \nTwitterAccountID=%@ \nTwitterAccountName=%@ \nisLoggedIn=%@ \nTwitterAccountConnected=%@ \nFacebookAccountConnected=%@", self.token, self.userID, self.username, self.fullName, self.email, self.facebookAccountID, self.twitterAccountID, self.twitterAccountName, HumanReadableStringFromBool(self.isLoggedIn), HumanReadableStringFromBool(self.twitterAccountConnected), HumanReadableStringFromBool(self.facebookAccountConnected)];
    return descrippy;
}










@end
