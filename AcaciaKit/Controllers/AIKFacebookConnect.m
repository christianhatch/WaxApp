//
//  KWFacebookConnect.m
//  Kiwi
//
//  Created by Christian Hatch on 1/28/13.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "AIKFacebookConnect.h"
#import <FacebookSDK/FacebookSDK.h>


NSString *const kAIKNotificationFacebookFriendsAvailable = @"aikContactsAvailableDidChangeNotification";
NSString *const kAIKNotificationFacebookFriendsMatchedAvailable = @"aikContactsMatchedDidChangeNotification";


@interface AIKFacebookConnect ()
@property (nonatomic, strong) FBSession *facebookSession;
@property (nonatomic, strong) NSMutableArray *unsortedFriends;
@property (nonatomic) dispatch_queue_t fbprocessingQ; 
@end

@implementation AIKFacebookConnect
@synthesize facebookSession = _facebookSession, fbFriendsOnKiwi = _fbFriendsOnKiwi, fbFriends = _fbFriends, unsortedFriends = _unsortedFriends, fbprocessingQ = _fbprocessingQ, searchResults = _searchResults; 

+ (AIKFacebookConnect *)sharedFB{
    static AIKFacebookConnect *sharedID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedID = [[AIKFacebookConnect alloc] init];
    });
    return sharedID;
}
-(id)init{
    self = [super init];
    if (self) {
        [[FBSession activeSession] closeAndClearTokenInformation];
        [FBSession setActiveSession:self.facebookSession]; 
    }
    return self;
}
-(BOOL)handleOpenURL:(NSURL *)url{
    return [self.facebookSession handleOpenURL:url];
}
-(void)handleAppDidBecomeActive{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.facebookSession handleDidBecomeActive];
    }); 
}
-(NSString *)accessToken{
    return self.facebookSession.accessTokenData.accessToken;
}
-(BOOL)sessionIsActive{
    return self.facebookSession.isOpen;
}
-(BOOL)canPublish{
    return ([self.facebookSession.permissions indexOfObject:@"publish_actions"] != NSNotFound && [self sessionIsActive]);
}
-(void)loginWithFacebook{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.facebookSession.isOpen) {
            [self initializeSession];
        }else{
            if (![[WaxUser currentUser] isLoggedIn]) {
                [self getAndSaveUserInfoForLogin];
            }else{
                [self getUserInfo];
            }
        }
    });
}
-(void)logoutFacebook{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.facebookSession closeAndClearTokenInformation];
        self.facebookSession = nil;
        
        [[WaxAPIClient sharedClient] postPath:kUpdateFacebookURL parameters:@{@"facebookid": [[WaxUser currentUser] facebookAccountId], @"facebook" : @"0"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
            [[WaxUser currentUser] saveFacebookAccountId:@"false"];
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:KWFacebookAccountChangedNotification object:self userInfo:@{@"loggedin": @"false"}];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:@"Error logging out of Facebook. Please try again!" error:error andShowAlertWithButtonHandler:nil];
        }];
    });
}
-(void)initializeSession{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.facebookSession openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            
            [self sessionStateChanged:session state:status error:error];
            
        }];
    }); 
}
-(void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.facebookSession = session;
        [FBSession setActiveSession:self.facebookSession];
        
        switch (state) {
            case FBSessionStateOpen:
                if (!error) {
                    if (![[WaxUser currentUser] isLoggedIn]) {
                        [self getAndSaveUserInfoForLogin];
                    }else{
                        [self getUserInfo];
                    }
                }break;
            case FBSessionStateClosed:
            case FBSessionStateClosedLoginFailed:
                self.facebookSession = nil;
                break;
            default:
                break;
        }
        if (error) {
            self.facebookSession = nil;
            [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:@"Error Logging in With Facebook" error:error andShowAlertWithButtonHandler:^{
                [SVProgressHUD dismiss];
            }];
        }
    });
}
-(void)getAndSaveUserInfoForLogin{
    dispatch_async(dispatch_get_main_queue(), ^{
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id <FBGraphUser> fbuser, NSError *error) {
            if (error) {
                [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:@"Error getting your information from Facebook" error:error andShowAlertWithButtonHandler:^{
                    [SVProgressHUD dismiss];
                }];
            }else{
                [[WaxUser currentUser] saveFacebookAccountId:[fbuser id]];
                [[WaxUser currentUser] saveFirstname:fbuser.first_name];
                [[WaxUser currentUser] saveLastname:fbuser.last_name];
                [[WaxUser currentUser] saveEmail:[fbuser objectForKey:@"email"]];
                
                [[WaxAPIClient sharedClient] postPath:kFBLoginURL parameters:@{@"email":[[WaxUser currentUser] email], @"firstname":[[WaxUser currentUser] firstname], @"lastname":[[WaxUser currentUser] lastname], @"facebookid":[[WaxUser currentUser] facebookAccountId]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
                   
                    NSDictionary *response = [[validated objectForKeyNotNull:kKeyForJSON] objectAtIndexNotNull:0];
                    
                    DLog(@"response %@", response);
                    
                    if ([[response objectForKeyNotNull:@"complete"] isEqualToString:@"true"]) {
                        [SVProgressHUD dismiss];
                        [[WaxUser currentUser] logInWithResponse:response];
                        [[WaxUser currentUser] fetchFacebookProfilePictureAndShowUser:NO];
                        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:KWFacebookAccountChangedNotification object:self userInfo:@{@"loggedin": @"true"}];
                    }else if ([[response objectForKeyNotNull:@"complete"] isEqualToString:@"false"]) {
                        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:KWFacebookAccountChangedNotification object:self userInfo:@{@"loggedin": @"false"}];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:@"Error getting your information from Facebook. Please try again!" error:error andShowAlertWithButtonHandler:^{
                        [SVProgressHUD dismiss];
                    }];
                }];
            }
        }];
    }); 
}
-(void)getUserInfo{
    dispatch_async(dispatch_get_main_queue(), ^{
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id <FBGraphUser> fbuser, NSError *error) {
            if (error) {
                [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:@"Error getting your information from Facebook" error:error andShowAlertWithButtonHandler:^{
                    [SVProgressHUD dismiss];
                }];
            }else{
                [[WaxUser currentUser] saveFacebookAccountId:[fbuser id]];
                
                [[WaxAPIClient sharedClient] postPath:kUpdateFacebookURL parameters:@{@"facebookid": [[WaxUser currentUser] facebookAccountId], @"facebook" : @"1"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                    id validated = [[KiwiModel sharedModel] validateResponseObject:responseObject];
                    NSDictionary *response = [[validated objectForKeyNotNull:kKeyForJSON] objectAtIndexNotNull:0];
                   
                    if ([[response objectForKeyNotNull:@"complete"] isEqualToString:@"true"]) {
                        [SVProgressHUD dismiss];
                        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:KWFacebookAccountChangedNotification object:self userInfo:@{@"loggedin": @"true"}];
                    }

                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:@"Error logging out of Facebook. Please try again!" error:error andShowAlertWithButtonHandler:^{
                        [SVProgressHUD dismiss];
                    }];
                }];                
            }
        }];
    }); 
}
-(void)requestPublishPermissions{
    if (![self canPublish]) {
        [self.facebookSession requestNewPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kWaxNotificationFacebookAccountDidChange object:self userInfo:@{@"publish": @"true"}];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kWaxNotificationFacebookAccountDidChange object:self userInfo:@{@"publish": @"false"}];
                [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:@"Error requesting Facebook publish permissions" error:error andShowAlertWithButtonHandler:nil];
            }
        }];
    }
}

-(void)postStatus:(NSString *)status{
    if ([self canPublish]) {
        [FBRequestConnection startForPostStatusUpdate:status completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (error) {
                [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:@"Silent Facebook Post Error" error:error];
            }else{
                [[AIKErrorUtilities sharedUtilities] logMessageToAllServices:@"Shared Via Facebook from Share Page"];
            }
        }];
    }else{
        [self requestPublishPermissions]; 
    }
}
-(void)prefetchKiwiFriends{
    if ([self sessionIsActive]) {
        [[WaxAPIClient sharedClient] loadPeopleListWithPath:kFacebookFriendsURL personid:[[WaxUser currentUser] userid] lastTimeStamp:nil sender:self];
    }
}

-(void)prefetchAllFBFriends{
    [self prefetchAllFBFriendsWithNextURL:nil]; 
}
-(void)prefetchAllFBFriendsWithNextURL:(NSURL *)nextURL{
    if ([self sessionIsActive]) {
        if (!nextURL) {
            [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (error) {
                    [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:@"Error requesting FB Friends" error:error];
                }else{
                    [self parseAndSetFBFriends:result];
                }
            }];
        }else{
            [FBRequestConnection startWithGraphPath:@"me/friends" parameters:@{<#key#>: <#object, ...#>} HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                
                if (error) {
                    [[AIKErrorUtilities sharedUtilities] logErrorWithMessage:@"Error requesting FB Friends" error:error];
                }else{
                    [self parseAndSetFBFriends:result];
                }

            }];
            FBRequest *request = [[FBRequest alloc] initWithSession:self.facebookSession graphPath:nil];
            FBRequestConnection *connection = [[FBRequestConnection alloc] init];
            [connection addRequest:request completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                DLog(@"error %@", error);
                [self parseAndSetFBFriends:result];
                DLog(@"another request! result %@", result); 
            }];
            connection.urlRequest = [NSMutableURLRequest requestWithURL:nextURL];
            [connection start];
        }
    }
}
-(void)parseAndSetFBFriends:(id)result{
    dispatch_async(self.fbprocessingQ, ^{
        NSArray *rawFriends = [result objectForKeyNotNull:@"data"];
        NSMutableArray *friends = [NSMutableArray arrayWithCapacity:rawFriends.count];
        for (id <FBGraphUser> user in rawFriends) {
            PersonObject *person = [[PersonObject alloc] initWithFBGraphUser:user];
            [friends addObject:person];
        }
        if (self.unsortedFriends.count == 0) {
            self.unsortedFriends = friends;
        }else{
            [self.unsortedFriends addObjectsFromArray:friends];
        }
        
//        DLog(@"unsorted friends %@", self.unsortedFriends);
        
        [self sortFriendsIntoSections];
                
//        DLog(@"sorted friends %@", self.fbFriends);
        
    });
}
-(void)connectionSuccess:(id)response forPath:(NSString *)path{
    if ([path isEqualToString:kFacebookFriendsURL]) {
        self.fbFriendsOnKiwi = response;
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:KWFacebookKiwiFriendsAvailableNotification object:self];
    }
}
-(void)connectionError:(NSError *)error forPath:(NSString *)path{
    [SVProgressHUD showErrorWithStatus:@"Error loading Facebook friends on Kiwi :( Please try again!"];
}

-(void)sortFriendsIntoSections{
    dispatch_async(self.fbprocessingQ, ^{
        NSMutableDictionary *sorted = [NSMutableDictionary dictionaryWithCapacity:[NSArray alphabet].count];
            NSMutableArray *nonLetters = [NSMutableArray array];
            for (NSString *letter in [NSArray alphabet]) {
                NSMutableArray *section = [NSMutableArray array];
                for (PersonObject *person in self.unsortedFriends) {
                    NSString *firstname = person.firstname;
                    if (![firstname startsWithAlphabeticalLetter]){
                        [nonLetters addObject:person];
                    }else if ([firstname hasPrefix:letter]) {
                        [section addObject:person];
                    }
                }
                [sorted setObject:section forKey:letter];
            }
            [sorted setObject:nonLetters forKey:@"#"];
        self.fbFriends = sorted;
        
        DLog(@"fbfriends %@", self.fbFriends);
        
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:KWFacebookFBFriendsAvailableNotification object:self];
    });
}
-(void)searchFriendsWithString:(NSString *)searchTerm{
    if (searchTerm == nil) {
        [self.searchResults removeAllObjects];
    }else{
        NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:@"(firstname BEGINSWITH[cd] $SEARCH_TERM) OR (lastname BEGINSWITH[cd] $SEARCH_TERM)"];
        
        NSPredicate *predicate = [predicateTemplate predicateWithSubstitutionVariables:[NSDictionary dictionaryWithObject:searchTerm forKey:@"SEARCH_TERM"]];
        
        self.searchResults = [NSMutableArray arrayWithArray:[self.unsortedFriends filteredArrayUsingPredicate:predicate]];
        
        DLog(@"search results %@", self.searchResults);
    }
}

#pragma mark - Setters and Getters
-(FBSession *)facebookSession{
    if (!_facebookSession) {
        NSArray *permissions = @[@"email"];
        _facebookSession = [[FBSession alloc] initWithAppID:kThirdPartyFacebookAppID permissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone urlSchemeSuffix:nil tokenCacheStrategy:nil];
        [FBSession setActiveSession:_facebookSession];
    }
    return _facebookSession;
}
-(NSMutableDictionary *)fbFriends{
    if (!_fbFriends) {
        _fbFriends = [NSMutableDictionary dictionary]; 
    }
    return _fbFriends; 
}
-(dispatch_queue_t)fbprocessingQ{
    if (!_fbprocessingQ) {
        _fbprocessingQ = dispatch_queue_create("com.acacia.fb.jsonprocessingqueue", NULL); 
    }
    return _fbprocessingQ; 
}

@end
