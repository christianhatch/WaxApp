//
//  WaxUser.m
//  Kiwi
//
//  Created by Christian Hatch on 1/21/13.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "WaxUser.h"
#import "Lockbox.h"
#import "AIKErrorUtilities.h"
#import "WaxAPIClient.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AIKFacebookConnect.h"
#import <Crashlytics/Crashlytics.h>
#import "Flurry.h"

@interface WaxUser ()
@end

@implementation WaxUser


+ (WaxUser *)currentUser{
    static WaxUser *sharedID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedID = [[WaxUser alloc] init];
    });
    return sharedID;
}

-(NSString *)userid {
    NSString *userIdentification = [Lockbox stringForKey:kUserIDKey];
    if ([userIdentification isEmptyOrNull]){
        [[AIKErrorUtilities sharedUtilities] didEncounterError:[NSString stringWithFormat:@"GETTING Userid, isEmptyOrNull. Userid = %@", userIdentification]];
        [self logOut:YES];
    }
    return userIdentification;
}
-(void)saveUserid:(NSString *)userid{
    if ([userid isEmptyOrNull]){
        [[AIKErrorUtilities sharedUtilities] didEncounterError:[NSString stringWithFormat:@"SETTING Userid isEmptyOrNull. Userid = %@", userid]];
        [self logOut:YES];
    }else{
        [Lockbox setString:userid forKey:kUserIDKey];
    }
}
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
-(void)saveToken:(NSString *)token{
    if ([token isEmptyOrNull]){
        [[AIKErrorUtilities sharedUtilities] didEncounterError:[NSString stringWithFormat:@"SETTING Token isEmptyOrNull. Token = %@", token]];
        [self logOut:YES];
    }else{
        [Lockbox setString:token forKey:kUserTokenKey];
    }
}
-(NSString *)username{
    return [Lockbox stringForKey:kUserNameKey];
}
-(void)saveUserame:(NSString *)username{
    [Lockbox setString:username forKey:kUserNameKey];
}
-(NSString *)email{
    return [Lockbox stringForKey:kUserEmailKey];
}
-(void)saveEmail:(NSString *)email{
    [Lockbox setString:email forKey:kUserEmailKey];
}
-(NSString *)firstname{
    return [Lockbox stringForKey:kUserFirstNameKey];
}
-(void)saveFirstname:(NSString *)firstname{
    [Lockbox setString:firstname forKey:kUserFirstNameKey];
}
-(NSString *)lastname{
    return [Lockbox stringForKey:kUserLastNameKey];
}
-(void)saveLastname:(NSString *)lastname{
    [Lockbox setString:lastname forKey:kUserLastNameKey];
}
//-(BOOL)hasNoFriends{
//    return [[NSUserDefaults standardUserDefaults] boolForKey:KWUserNoFriendsKey];
//}
//-(void)saveNoFriends:(BOOL)noFriends{
//    [[NSUserDefaults standardUserDefaults] setBool:!noFriends forKey:KWUserNoFriendsKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
-(void)saveTwitterAccountId:(NSString *)twitterAccountId{
    if ([twitterAccountId isEmptyOrNull]){
        [[AIKErrorUtilities sharedUtilities] didEncounterError:[NSString stringWithFormat:@"SETTING twitter account isEmptyOrNull. twitter accountID = %@", twitterAccountId]];
    }else{
        [Lockbox setString:twitterAccountId forKey:kUserTwitterAccountIDKey];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kWaxNotificationTwitterAccountDidChange object:self];
    }
}
-(NSString *)twitterAccountId{
    NSString *twitterAccount = [Lockbox stringForKey:kUserTwitterAccountIDKey];
    return twitterAccount;
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
-(BOOL)twitterAccountSaved{
    return ![[self twitterAccountId] isEqualToString:@"false"];
}
-(void)saveFacebookAccountId:(NSString *)facebookAccountId{
    if ([facebookAccountId isEmptyOrNull]){
        [[AIKErrorUtilities sharedUtilities] didEncounterError:[NSString stringWithFormat:@"SETTING facebook account isEmptyOrNull. facebook accountID = %@", facebookAccountId]];
    }else{
        [Lockbox setString:facebookAccountId forKey:kUserFacebookAccountIDKey];
    }
}
-(NSString *)facebookAccountId{
    NSString *facebookID = [Lockbox stringForKey:kUserFacebookAccountIDKey];
    return facebookID; 
}
-(BOOL)facebookAccountSaved{
    return ![[self facebookAccountId] isEqualToString:@"false"];
}

#pragma mark - Public API
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
    if ([[AIKFacebookConnect sharedFB] sessionIsActive] && [self isLoggedIn]) {
        [FBRequestConnection startWithGraphPath:@"me?fields=picture.type(large)" completionHandler:^(FBRequestConnection *connection, id <FBGraphObject> result, NSError *error) {
            NSURL *url = [NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
            AFImageRequestOperation *proPic = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:url] success:^(UIImage *image) {
//                [[WaxAPIClient sharedClient] uploadProfilePicture:image uploadType:showUser ? KWProfilePictureRequestTypeChange : KWProfilePictureRequestTypeFacebook];
            }];
            [proPic start];
        }];
    }else{
        [[AIKFacebookConnect sharedFB] loginWithFacebook];
    }
}
-(void)uploadNewProfilePicture:(UIImage *)profilePicture{
//    [[WaxAPIClient sharedClient] uploadProfilePicture:profilePicture uploadType:KWProfilePictureRequestTypeChange];
//    [[WaxAPIClient sharedClient] loadMyFeedWithLastTimeStamp:nil];
//    [[KiwiModel sharedModel] setFriendsFeed:[NSMutableArray array]];
//    [[KiwiModel sharedModel] setTrendsFeed:[NSMutableArray array]]; 
}
-(void)logOut:(BOOL)fromTokenError{
    [self saveToken:@"false"];
    [self saveUserid:@"false"];
    [self saveUserame:@"false"];
    [self saveEmail:@"false"];
    [self saveFirstname:@"false"];
    [self saveLastname:@"false"];
    [self saveTwitterAccountId:@"false"];
    [[AIKFacebookConnect sharedFB] logoutFacebook];
    
//#ifndef RELEASE
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KWSuperUserModeEnableKey];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KWSuperUserModeEnableKey];
//#endif
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIImageView clearAFImageCache];
    [UIButton clearAFImageCache];
    
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [[[WaxAPIClient sharedClient] operationQueue] cancelAllOperations];
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"Logout" object:self];
    
    if (fromTokenError) {
//        UIAlertView *loggedOut = [[UIAlertView alloc] initWithTitle:@"You have been logged out" message:@"For security reasons, your session has expired and you've been logged out. \n \nPlease login again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [loggedOut show];
        [[AIKErrorUtilities sharedUtilities] logMessageToAllServices:@"User logged out from token error (or perhaps not, unclear..)"];
    }
}
-(BOOL)isLoggedIn{
    return ((![[self userid] isEqualToString:@"false"]) && (![[self token] isEqualToString:@"false"]));
}
-(void)resetForInitialLaunch{
    [self saveToken:@"false"];
    [self saveUserid:@"false"];
    [self saveUserame:@"false"];
    [self saveEmail:@"false"];
    [self saveFirstname:@"false"];
    [self saveLastname:@"false"];
    [self saveTwitterAccountId:@"false"];
    [self saveFacebookAccountId:@"false"];
//    [self saveNoFriends:NO];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)useridIsCurrentUser:(NSString *)userid{
    return [[self userid] isEqualToString:userid]; 
}
-(void)chooseNewTwitterAccount{
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
                            [self saveTwitterAccountId:@"false"]; 
                        };
                        RIButtonItem *actbtn = [RIButtonItem item];
                        actbtn.label = account.username;
                        actbtn.action = ^{
                            [self saveTwitterAccountId:account.identifier];
                        };
                        UIActionSheet *chooser = [[UIActionSheet alloc] initWithTitle:@"Which Twitter account would you like to use with Kiwi?" cancelButtonItem:[RIButtonItem cancelButton] destructiveButtonItem:delete otherButtonItems:actbtn, nil];
                        [chooser showInView:mainWindowView];
                    }break;
                    default:{                        
                        UIActionSheet *chooser = nil;
                        if ([self twitterAccountSaved]) {
                            RIButtonItem *delete = [RIButtonItem item];
                            delete.label = @"Disconnect Twitter";
                            delete.action = ^{
                                [self saveTwitterAccountId:@"false"];
                            };
                            chooser = [[UIActionSheet alloc] initWithTitle:@"Which Twitter account would you like to use with Kiwi?" cancelButtonItem:nil destructiveButtonItem:delete otherButtonItems:nil, nil];
                        }else{
                            chooser = [[UIActionSheet alloc] initWithTitle:@"Which Twitter account would you like to use with Kiwi?" cancelButtonItem:nil destructiveButtonItem:nil otherButtonItems:nil, nil];
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
-(void)showNoTwitterAccessAlert{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Access to Twitter", @"No Access to Twitter") message:NSLocalizedString(@"To share to Twitter, Kiwi requires access to your Twitter Accounts. Please grant access through the Settings App and going to Twitter", @"To sign in with Twitter the App requires access to your Twitter Accounts. Please grant access through the Settings App and going to Twitter") delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"Dismiss") otherButtonTitles:nil];
    [alertView show];
}

//#ifndef RELEASE
//
//#define KWChristianSuperUserID      @"c0601e7ceda37593447c7525dea3070c"
//#define KWStuSuperUserID            @"9e194145c13551e4160e8377fcb47a51"
//#define KWJaymeSuperUserID          @"624bf3ceca5c86f33fe06fc31e80bce8"
//#define KWChristineSuperUserID      @"3cf4343a5fd58ff1d106e567bd32a433"
//
//-(BOOL)isSuperUser{
//    if (([[self userid] isEqualToString:KWJaymeSuperUserID] || [[self userid] isEqualToString:KWStuSuperUserID] || [[self userid] isEqualToString:KWChristianSuperUserID] || [[self userid] isEqualToString:KWChristineSuperUserID]) && [[NSUserDefaults standardUserDefaults] boolForKey:KWSuperUserModeEnableKey]) {
//        return YES;
//    }else{
//        return NO; 
//    }
//}
//
//#endif



@end
