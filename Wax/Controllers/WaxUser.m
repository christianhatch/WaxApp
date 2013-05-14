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
    if ([securityToken isEmptyOrNull]) {
        [[AIKErrorUtilities sharedUtilities] didEncounterError:[NSString stringWithFormat:@"Token isEmptyOrNull. Token = %@", securityToken]];
        [self logOut:YES];
    }
    NSInteger time = [[NSDate date] timeIntervalSince1970]/300;
    NSString *hashed = [[NSString stringWithFormat:@"%@%i%@", securityToken, time, kWaxAPISalt] MD5];
    return hashed;
}
-(NSString *)userid{
    NSString *userIdentification = [Lockbox stringForKey:kUserIDKey];
    if ([userIdentification isEmptyOrNull]){
        [[AIKErrorUtilities sharedUtilities] didEncounterError:[NSString stringWithFormat:@"GETTING Userid, isEmptyOrNull. Userid = %@", userIdentification]];
        [self logOut:YES];
    }
    return userIdentification;
}
-(NSString *)username{
    return [Lockbox stringForKey:kUserNameKey];
}
-(NSString *)email{
    return [Lockbox stringForKey:kUserEmailKey];
}
-(NSString *)firstname{
    return [Lockbox stringForKey:kUserFirstNameKey];
}
-(NSString *)lastname{
    return [Lockbox stringForKey:kUserLastNameKey];
}
-(NSString *)twitterAccountId{
    return [Lockbox stringForKey:kUserTwitterAccountIDKey];
}
-(NSString *)facebookAccountId{
    return [Lockbox stringForKey:kUserFacebookAccountIDKey];
}
-(NSString *)twitterAccountName{
    NSString *name = @"none";
    if ([Lockbox stringForKey:kUserTwitterAccountIDKey]) {
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccount *twitter = [accountStore accountWithIdentifier:[self twitterAccountId]];
        name = [NSString stringWithFormat:@"@%@",twitter.username];
    }
    return name;
}
//-(BOOL)hasNoFriends;

#pragma mark - User Information Setters
-(void)saveToken:(NSString *)token{
    if ([token isEmptyOrNull]){
        [[AIKErrorUtilities sharedUtilities] didEncounterError:[NSString stringWithFormat:@"SETTING Token isEmptyOrNull. Token = %@", token]];
        [self logOut:YES];
    }else{
        [Lockbox setString:token forKey:kUserTokenKey];
    }
}
-(void)saveUserid:(NSString *)userid{
    if ([userid isEmptyOrNull]){
        [[AIKErrorUtilities sharedUtilities] didEncounterError:[NSString stringWithFormat:@"SETTING Userid isEmptyOrNull. Userid = %@", userid]];
        [self logOut:YES];
    }else{
        [Lockbox setString:userid forKey:kUserIDKey];
    }
}
-(void)saveUserame:(NSString *)username{
    [Lockbox setString:username forKey:kUserNameKey];
}
-(void)saveEmail:(NSString *)email{
    [Lockbox setString:email forKey:kUserEmailKey];
}
-(void)saveFirstname:(NSString *)firstname{
    [Lockbox setString:firstname forKey:kUserFirstNameKey];
}
-(void)saveLastname:(NSString *)lastname{
    [Lockbox setString:lastname forKey:kUserLastNameKey];
}
-(void)saveTwitterAccountId:(NSString *)twitterAccountId{
    if ([twitterAccountId isEmptyOrNull]){
        [[AIKErrorUtilities sharedUtilities] didEncounterError:[NSString stringWithFormat:@"SETTING twitter account isEmptyOrNull. twitter accountID = %@", twitterAccountId]];
    }else{
        [Lockbox setString:twitterAccountId forKey:kUserTwitterAccountIDKey];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kWaxNotificationTwitterAccountDidChange object:self];
    }
}
-(void)saveFacebookAccountId:(NSString *)facebookAccountId{
    if ([facebookAccountId isEmptyOrNull]){
        [[AIKErrorUtilities sharedUtilities] didEncounterError:[NSString stringWithFormat:@"SETTING facebook account isEmptyOrNull. facebook accountID = %@", facebookAccountId]];
    }else{
        [Lockbox setString:facebookAccountId forKey:kUserFacebookAccountIDKey];
    }
}
//-(void)saveNoFriends:(BOOL)noFriends;


#pragma mark - Signup/Login/Logout/Update Pic
-(void)connectFacebookWithCompletion:(WaxUserCompletionBlock)completion{
    [[AIKFacebookManager sharedManager] connectFacebookWithCompletion:^(id<FBGraphUser> user, NSError *error) {
        if ([self isLoggedIn]) {
            //update this class's data and update data on server
        }else{
            //create account on server and then login to that account
        }
    }];
}

-(void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(WaxUserCompletionBlock)completion{
    //login to server and save returned data
}

-(void)signupWithUsername:(NSString *)username password:(NSString *)password fullName:(NSString *)fullName email:(NSString *)email picture:(UIImage *)picture completion:(WaxUserCompletionBlock)completion{
    //sign up on server and save returned data
}

-(void)updateProfilePicture:(UIImage *)profilePicture completion:(WaxUserCompletionBlock)completion{
    //update profile picture on AWS
}
-(void)syncFacebookProfilePictureWithCompletion:(WaxUserCompletionBlock)completion{
    //should be a single call to the server to get it all done there
}
-(void)logOut{
    //clear all information
}

#pragma mark - Utility Methods
-(BOOL)isLoggedIn{
    return ((![[self userid] isEqualToString:kFalseString]) && (![[self token] isEqualToString:kFalseString]));
}
-(BOOL)twitterAccountConnected{
    return (![[self twitterAccountId] isEqualToString:kFalseString]);
}
-(BOOL)facebookAccountConnected{
    return (![[self facebookAccountId] isEqualToString:kFalseString]);
}
-(BOOL)useridIsCurrentUser:(NSString *)userid{
    return [[self userid] isEqualToString:userid];
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
                        ACAccount *account = [twitterAccounts objectAtIndexNotNull:0];
                        RIButtonItem *delete = [RIButtonItem item];
                        delete.label = @"Disconnect Twitter";
                        delete.action = ^{
                            [self saveTwitterAccountId:kFalseString];
                        };
                        RIButtonItem *actbtn = [RIButtonItem item];
                        actbtn.label = account.username;
                        actbtn.action = ^{
                            [self saveTwitterAccountId:account.identifier];
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
                                [self saveTwitterAccountId:kFalseString];
                            };
                            chooser = [[UIActionSheet alloc] initWithTitle:@"Which Twitter account would you like to use with Wax?" cancelButtonItem:nil destructiveButtonItem:delete otherButtonItems:nil, nil];
                        }else{
                            chooser = [[UIActionSheet alloc] initWithTitle:@"Which Twitter account would you like to use with Wax?" cancelButtonItem:nil destructiveButtonItem:nil otherButtonItems:nil, nil];
                        }
                        for (ACAccount *account in twitterAccounts) {
                            RIButtonItem *button = [RIButtonItem item];
                            button.label = [NSString stringWithFormat:@"@%@", account.username];
                            button.action = ^{
                                [self saveTwitterAccountId:account.identifier];
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
    NSString *reset = kFalseString;
    [self saveToken:reset];
    [self saveUserid:reset];
    [self saveUserame:reset];
    [self saveEmail:reset];
    [self saveFirstname:reset];
    [self saveLastname:reset];
    [self saveTwitterAccountId:reset];
    [self saveFacebookAccountId:reset];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserSaveToCameraRollKey];
}

















-(void)saveUserInformation:(NSDictionary *)info{
    [self saveToken:[info objectForKeyNotNull:@"token"]];
    [self saveUserid:[info objectForKeyNotNull:@"userid"]];
    [self saveUserame:[info objectForKeyNotNull:@"username"]];
    [self saveEmail:[info objectForKeyNotNull:@"email"]];
    [self saveFirstname:[info objectForKeyNotNull:@"firstname"]];
    [self saveLastname:[info objectForKeyNotNull:@"lastname"]];
//    [self saveNoFriends:[[info objectForKeyNotNull:@"following"] boolValue]];
    
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
