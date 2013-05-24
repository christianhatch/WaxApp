//
//  WaxUser.m
//  Kiwi
//
//  Created by Christian Hatch on 1/21/13.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "WaxUser.h"
#import "Lockbox.h"
#import <Accounts/Accounts.h>
#import <Crashlytics/Crashlytics.h>
#import <AcaciaKit/Flurry.h>


NSString *const WaxUserDidLogInNotification = @"WaxUserLoggedIn";
NSString *const WaxUserDidLogOutNotification = @"WaxUserLoggedOut"; 


@interface WaxUser ()
@end

@implementation WaxUser

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
    if ([NSString isEmptyOrNil:securityToken]) {
        return kFalseString; 
    }else{
        NSInteger time = [[NSDate date] timeIntervalSince1970]/300;
        NSString *hashed = [[NSString stringWithFormat:@"%@%i%@", securityToken, time, kWaxAPISalt] MD5];
        return hashed;
    }
}
-(NSString *)userID{
    NSString *userIdentification = [Lockbox stringForKey:kUserIDKey];
    if ([NSString isEmptyOrNil:userIdentification]){
        return kFalseString;
    }else{
        return userIdentification;
    }
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
        return kFalseString;
    }else{
        return fbid;
    }
}
-(NSString *)twitterAccountID{
    NSString *twid = [Lockbox stringForKey:kUserTwitterAccountIDKey];
    if ([NSString isEmptyOrNil:twid]) {
        return kFalseString;
    }else{
        return twid;
    }
}
-(NSString *)twitterAccountName{
    NSString *name = @"none";
    if ([Lockbox stringForKey:kUserTwitterAccountIDKey]) {
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccount *twitter = [accountStore accountWithIdentifier:[self twitterAccountID]];
        name = [NSString stringWithFormat:@"@%@",twitter.username];
    }
    return name;
}

#pragma mark - User Information Setters
-(void)saveToken:(NSString *)token{
    if ([NSString isEmptyOrNil:token]){
//        [[AIKErrorUtilities sharedUtilities] didEncounterError:[NSString stringWithFormat:@"SETTING Token isEmptyOrNull. Token = %@", token]];
        [self logOut];
    }else{
        [Lockbox setString:token forKey:kUserTokenKey];
    }
}
-(void)saveUserID:(NSString *)userID{
    if ([NSString isEmptyOrNil:userID]){
//        [[AIKErrorUtilities sharedUtilities] didEncounterError:[NSString stringWithFormat:@"SETTING Userid isEmptyOrNull. Userid = %@", userid]];
        [self logOut];
    }else{
        [Lockbox setString:userID forKey:kUserIDKey];
    }
}

-(void)saveUserame:(NSString *)username{
    [Lockbox setString:username forKey:kUserNameKey];
}
-(void)saveFullName:(NSString *)fullName{
    [Lockbox setString:fullName forKey:kUserFirstNameKey];
}
-(void)saveEmail:(NSString *)email{
    [Lockbox setString:email forKey:kUserEmailKey];
}

-(void)saveFacebookAccountID:(NSString *)facebookAccountID{
    if ([NSString isEmptyOrNil:facebookAccountID]){
//        [[AIKErrorUtilities sharedUtilities] didEncounterError:[NSString stringWithFormat:@"SETTING facebook account isEmptyOrNull. facebook accountID = %@", facebookAccountId]];
    }else{
        [Lockbox setString:facebookAccountID forKey:kUserFacebookAccountIDKey];
    }
}
-(void)saveTwitterAccountID:(NSString *)twitterAccountID{
    if ([NSString isEmptyOrNil:twitterAccountID]){
//        [[AIKErrorUtilities sharedUtilities] didEncounterError:[NSString stringWithFormat:@"SETTING twitter account isEmptyOrNull. twitter accountID = %@", twitterAccountId]];
    }else{
        [Lockbox setString:twitterAccountID forKey:kUserTwitterAccountIDKey];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kWaxNotificationTwitterAccountDidChange object:self];
    }
}


#pragma mark - Signup/Login/Logout/Update Pic
-(void)createAccountWithUsername:(NSString *)username fullName:(NSString *)fullName email:(NSString *)email passwordOrFacebookID:(NSString *)passwordOrFacebookID completion:(WaxUserCompletionBlock)completion{
    //sign up on server and save returned data
    [[WaxAPIClient sharedClient] createAccountWithUsername:username fullName:fullName email:email passwordOrFacebookID:passwordOrFacebookID completion:^(LoginObject *loginResponse, NSError *error) {
        if (!error) {
            [self finishLoggingInAndSaveUserInformation:loginResponse]; 
        }else{
            [[AIKErrorManager sharedManager] logErrorWithMessage:NSLocalizedString(@"Problem Creating Account", @"Problem Creating Account") error:error andShowAlertWithButtonHandler:^{
                [SVProgressHUD dismiss];
            }];
        }
    }];
}
-(void)loginWithFacebookID:(NSString *)facebookID fullName:(NSString *)fullName email:(NSString *)email completion:(WaxUserCompletionBlock)completion{
    [[WaxAPIClient sharedClient] loginWithFacebookID:facebookID fullName:fullName email:email completion:^(LoginObject *loginResponse, NSError *error) {
        if (!error) {
            [self finishLoggingInAndSaveUserInformation:loginResponse];
        }else{
            [[AIKErrorManager sharedManager] logErrorWithMessage:NSLocalizedString(@"Problem Logging in via Facebook", @"Problem Logging in via Facebook") error:error andShowAlertWithButtonHandler:^{
                [SVProgressHUD dismiss];
            }];
        }
    }];
}
-(void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(WaxUserCompletionBlock)completion{
    [[WaxAPIClient sharedClient] loginWithUsername:username password:password completion:^(LoginObject *loginResponse, NSError *error) {
        if (!error) {
            [self finishLoggingInAndSaveUserInformation:loginResponse];
        }else{
            [[AIKErrorManager sharedManager] logErrorWithMessage:NSLocalizedString(@"Problem Logging in via Email", @"Problem Logging in via Email") error:error andShowAlertWithButtonHandler:^{
                [SVProgressHUD dismiss];
            }];
        }
    }];    
}
-(void)finishLoggingInAndSaveUserInformation:(LoginObject *)loginResponse{
    [self saveToken:loginResponse.token];
    [self saveUserID:loginResponse.userID];
    
    [self saveUserame:loginResponse.username];
    [self saveFullName:loginResponse.fullName];
    [self saveEmail:loginResponse.email];
    
    [self saveFacebookAccountID:loginResponse.facebookID];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)];
    
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:WaxUserDidLogInNotification object:self];
}

-(void)chooseNewprofilePictureWithCompletion:(void (^)(NSError *, UIImage *))completion{
    /*
    present action sheet:
    1) (if fb is logged in) sync fb pro pic
        call 'syncfbpropic' method
    2) take new picture
        present uiimagepickercontroller
        call 'update profile picture' method at the end
    3) choose new picture
        present uiimagepickercontroller
        call 'update profile picture' method at the end
     
    */
}
-(void)updateProfilePicture:(UIImage *)profilePicture completion:(WaxUserCompletionBlock)completion{
    //crop to square
    //resize to like 150x150
    //reduce quality
    //convert to jpg data
    //upload to s3
}
-(void)syncFacebookProfilePictureWithCompletion:(WaxUserCompletionBlock)completion{
    //should be a single call to stu's script
}
-(void)logOut{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [[[WaxAPIClient sharedClient] operationQueue] cancelAllOperations];
    [[AIKFacebookManager sharedManager] logoutFacebookWithCompletion:nil];
    [self resetForInitialLaunch];
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:WaxUserDidLogOutNotification object:self]; 
}

#pragma mark - Utility Methods
-(BOOL)isLoggedIn{
    return ((![[self userID] isEqualToString:kFalseString]) && (![[self token] isEqualToString:kFalseString]));
}
-(BOOL)twitterAccountConnected{
    return (![[self twitterAccountID] isEqualToString:kFalseString]);
}
-(BOOL)facebookAccountConnected{
    return (![[self facebookAccountID] isEqualToString:kFalseString]);
}
-(BOOL)userIDIsCurrentUser:(NSString *)userID{
    return [[self userID] isEqualToString:userID];
}
-(void)chooseTwitterAccountWithCompletion:(WaxUserCompletionBlock)completion{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(granted) {
                NSArray *twitterAccounts = [accountStore accountsWithAccountType:twitterAccountType];
                switch(twitterAccounts.count) {
                    case 0:{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Twitter Accounts", @"No Twitter Accounts") message:NSLocalizedString(@"You haven't setup a Twitter account yet. Please add one by going through the Settings App > Twitter", @"You haven't setup a Twitter account yet. Please add one by going through the Settings App > Twitter") delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"Dismiss") otherButtonTitles:nil];
                        [alertView show];
                    }break;
                    case 1:{
                        ACAccount *account = [twitterAccounts objectAtIndexOrNil:0];
                        RIButtonItem *delete = [RIButtonItem item];
                        delete.label = @"Disconnect Twitter";
                        delete.action = ^{
                            [self saveTwitterAccountID:kFalseString];
                        };
                        RIButtonItem *actbtn = [RIButtonItem item];
                        actbtn.label = account.username;
                        actbtn.action = ^{
                            [self saveTwitterAccountID:account.identifier];
                        };
                        UIActionSheet *chooser = [[UIActionSheet alloc] initWithTitle:@"Which Twitter account would you like to use with Wax?" cancelButtonItem:[RIButtonItem cancelButton] destructiveButtonItem:delete otherButtonItems:actbtn, nil];
                        [chooser showInView:mainWindowView];
                    }break;
                    default:{
                        UIActionSheet *chooser = nil;
                        if ([self twitterAccountConnected]) {
                            RIButtonItem *delete = [RIButtonItem item];
                            delete.label = @"Disconnect Twitter";
                            delete.action = ^{
                                [self saveTwitterAccountID:kFalseString];
                            };
                            chooser = [[UIActionSheet alloc] initWithTitle:@"Which Twitter account would you like to use with Wax?" cancelButtonItem:nil destructiveButtonItem:delete otherButtonItems:nil, nil];
                        }else{
                            chooser = [[UIActionSheet alloc] initWithTitle:@"Which Twitter account would you like to use with Wax?" cancelButtonItem:nil destructiveButtonItem:nil otherButtonItems:nil, nil];
                        }
                        for (ACAccount *account in twitterAccounts) {
                            RIButtonItem *button = [RIButtonItem item];
                            button.label = [NSString stringWithFormat:@"@%@", account.username];
                            button.action = ^{
                                [self saveTwitterAccountID:account.identifier];
                            };
                            [chooser addButtonItem:button];
                        }
                        [chooser setCancelButtonIndex:[chooser addButtonItem:[RIButtonItem cancelButton]]];
                        [chooser showInView:mainWindowView];
                        }break;
                    }
                } else {
                    [self showNoTwitterAccessAlert];
                }
            });
        }
    ];
}
-(void)resetForInitialLaunch{
    [self saveToken:kFalseString];
    [self saveUserID:kFalseString];
    
    [self saveUserame:kFalseString];
    [self saveFullName:kFalseString];
    [self saveEmail:kFalseString];
    
    [self saveTwitterAccountID:kFalseString];
    [self saveFacebookAccountID:kFalseString];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserSaveToCameraRollKey];
}
















/*
-(void)saveUserInformation:(NSDictionary *)info{
    [self saveToken:[info objectForKeyOrNil:@"token"]];
    [self saveUserid:[info objectForKeyOrNil:@"userid"]];
    [self saveUserame:[info objectForKeyOrNil:@"username"]];
    [self saveEmail:[info objectForKeyOrNil:@"email"]];
    [self saveFirstname:[info objectForKeyOrNil:@"firstname"]];
    
    [Flurry setUserID:[[WaxUser currentUser] username]];
    [Crashlytics setUserIdentifier:[self userid]];
    [Crashlytics setUserName:[self username]];
    [Crashlytics setUserEmail:[self email]];
    [Crashlytics setObjectValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"version_preference"] forKey:@"Version"];
    [Crashlytics setObjectValue:[self userid] forKey:@"userid"];
    [Crashlytics setObjectValue:[self username] forKey:@"username"];
    [Crashlytics setObjectValue:[self email] forKey:@"email"];
}
-(void)logInWithResponse:(NSDictionary *)response{
    [self saveUserInformation:response];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)];
}
-(void)signedUpWithResponse:(NSDictionary *)response andProfilePic:(UIImage *)profilePicture{
    [self logInWithResponse:response];
    if (profilePicture) {
//        [[WaxAPIClient sharedClient] uploadProfilePicture:profilePicture uploadType:KWProfilePictureRequestTypeInitialSignup];
    }else{
        [self fetchFacebookProfilePictureAndShowUser:NO];
    }
}
-(void)fetchFacebookProfilePictureAndShowUser:(BOOL)showUser{
    if ([[AIKFacebookManager sharedManager] sessionIsActive] && [self isLoggedIn]) {
        [FBRequestConnection startWithGraphPath:@"me?fields=picture.type(large)" completionHandler:^(FBRequestConnection *connection, id <FBGraphObject> result, NSError *error) {
            NSURL *url = [NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
            AFImageRequestOperation *proPic = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:url] success:^(UIImage *image) {
//                [[WaxAPIClient sharedClient] uploadProfilePicture:image uploadType:showUser ? KWProfilePictureRequestTypeChange : KWProfilePictureRequestTypeFacebook];
            }];
            [proPic start];
        }];
    }else{
//        [[AIKFacebookManager sharedManager] loginWithFacebook];
    }
}
-(void)uploadNewProfilePicture:(UIImage *)profilePicture{
//    [[WaxAPIClient sharedClient] uploadProfilePicture:profilePicture uploadType:KWProfilePictureRequestTypeChange];
//    [[WaxAPIClient sharedClient] loadMyFeedWithLastTimeStamp:nil];
//    [[WaxDataManager sharedManager] setFriendsFeed:[NSMutableArray array]];
//    [[WaxDataManager sharedManager] setTrendsFeed:[NSMutableArray array]]; 
}
-(void)logOut:(BOOL)fromTokenError{
    [self saveToken:kFalseString];
    [self saveUserid:kFalseString];
    [self saveUserame:kFalseString];
    [self saveEmail:kFalseString];
    [self saveFirstname:kFalseString];
    [self saveLastname:kFalseString];
    [self saveTwitterAccountId:kFalseString];
    [[AIKFacebookManager sharedManager] logoutFacebookWithCompletion:nil];
    
//#ifndef RELEASE
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KWSuperUserModeEnableKey];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KWSuperUserModeEnableKey];
//#endif
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIImageView clearAFImageCache];
//    [UIButton clearAFImageCache];
    
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [[[WaxAPIClient sharedClient] operationQueue] cancelAllOperations];
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"Logout" object:self];
    
    if (fromTokenError) {
//        UIAlertView *loggedOut = [[UIAlertView alloc] initWithTitle:@"You have been logged out" message:@"For security reasons, your session has expired and you've been logged out. \n \nPlease login again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [loggedOut show];
        [[AIKErrorUtilities sharedUtilities] logMessageToAllServices:@"User logged out from token error (or perhaps not, unclear..)"];
    }
}
*/

#pragma mark - Internal Methods
-(void)showNoTwitterAccessAlert{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Access to Twitter", @"No Access to Twitter") message:NSLocalizedString(@"To share to Twitter, Wax requires access to your Twitter Accounts. Please grant access through the Settings App and going to Twitter", @"To sign in with Twitter the App requires access to your Twitter Accounts. Please grant access through the Settings App and going to Twitter") delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"Dismiss") otherButtonTitles:nil];
    [alertView show];
}

//#ifndef RELEASE
//
//#define KWChristianSuperUserID      @"c0601e7ceda37593447c7525dea3070c"
//#define KWStuSuperUserID            @"9e194145c13551e4160e8377fcb47a51"
//#define KWJaymeSuperUserID          @"624bf3ceca5c86f33fe06fc31e80bce8"
//
//-(BOOL)isSuperUser{
//    if (([[self userid] isEqualToString:KWJaymeSuperUserID] || [[self userid] isEqualToString:KWStuSuperUserID] || [[self userid] isEqualToString:KWChristianSuperUserID]) && [[NSUserDefaults standardUserDefaults] boolForKey:KWSuperUserModeEnableKey]) {
//        return YES;
//    }else{
//        return NO; 
//    }
//}
//
//#endif



@end
