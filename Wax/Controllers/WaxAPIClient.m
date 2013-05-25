//
//  KiwiNetClient.m
//  Kiwi
//
//  Created by Christian Michael Hatch on 6/13/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "WaxAPIClient.h"
#import <AFAmazonS3Client/AFAmazonS3Client.h>

@interface WaxAPIClient ()
@property (nonatomic) dispatch_queue_t jsonProcessingQueue;
@end

@implementation WaxAPIClient
@synthesize jsonProcessingQueue; 

#pragma mark - Alloc & Init
+ (WaxAPIClient *)sharedClient{
    static WaxAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ 
        _sharedClient = [[WaxAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kWaxAPIBaseURL]];
    }); 
    return _sharedClient;
}
- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.jsonProcessingQueue = dispatch_queue_create("com.wax.api.jsonprocessingqueue", NULL);
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setParameterEncoding:AFJSONParameterEncoding];
    
    return self;
}
-(NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters{

    NSDictionary *finalParameters = nil;
    if (parameters) {
        NSMutableDictionary *authentication = [NSMutableDictionary dictionaryWithDictionary:@{@"token":[[WaxUser currentUser] token], @"userid":[[WaxUser currentUser] userID]}];
        [authentication addEntriesFromDictionary:parameters];
        finalParameters = [NSDictionary dictionaryWithDictionary:authentication];
    }else{
        finalParameters = @{@"token":[[WaxUser currentUser] token], @"userid":[[WaxUser currentUser] userID]};
    }
    
    return [super requestWithMethod:method path:path parameters:finalParameters];
}

#pragma mark - Public API -

#pragma mark - Logins
-(void)createAccountWithUsername:(NSString *)username fullName:(NSString *)fullName email:(NSString *)email passwordOrFacebookID:(NSString *)passwordOrFacebookID completion:(WaxAPIClientCompletionBlockTypeLogin)completion{
    if (username && fullName && email && passwordOrFacebookID) {
       
        [self postPath:@"logins/signup" parameters:@{@"username":username, @"name":fullName, @"email":email, ([[AIKFacebookManager sharedManager] sessionIsActive] ? @"facebookid" : @"password"):passwordOrFacebookID} modelClass:[LoginObject class] completionBlock:^(id model, NSError *error) {
            if (completion) {
                completion(model, error);
            }
        }];

    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke this method with nil paramaters"];
    }
}
-(void)loginWithFacebookID:(NSString *)facebookID fullName:(NSString *)fullName email:(NSString *)email completion:(WaxAPIClientCompletionBlockTypeLogin)completion{
    if (facebookID && fullName && email) {
        
        [self postPath:@"logins/facebook" parameters:@{@"name":fullName, @"email":email, @"facebookid":facebookID} modelClass:[LoginObject class] completionBlock:^(id model, NSError *error) {
            if (completion) {
                completion(model, error);
            }
        }];

    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke this method with nil paramaters"];
    }
}
-(void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(WaxAPIClientCompletionBlockTypeLogin)completion{
    if (username && password) {
        
        [self postPath:@"logins/login" parameters:@{@"username":username, @"password":password} modelClass:[LoginObject class] completionBlock:^(id model, NSError *error) {
            if (completion) {
                completion(model, error);
            }
        }];
        
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke this method with nil paramaters"];
    }
}

#pragma mark - Feeds
-(void)fetchFeedForUser:(NSString *)personID infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientCompletionBlockTypeList)completion{
    if (personID) {
        [self fetchFeedFromPath:@"feeds/user" tagOrPersonID:personID infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
            if (completion) {
                completion(list, error); 
            }
        }];
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke this method with nil paramaters"];
    }
}
-(void)fetchHomeFeedWithInfiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientCompletionBlockTypeList)completion{
    if ([[WaxUser currentUser] isLoggedIn]) {
        [self fetchFeedFromPath:@"feeds/home" tagOrPersonID:[[WaxUser currentUser] userID] infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
            if (completion) {
                completion(list, error);
            }
        }];
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke this method with nil paramaters"];
    }
}
-(void)fetchFeedForTag:(NSString *)tag sortedBy:(WaxAPIClientTagSortType)sortedBy infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientCompletionBlockTypeList)completion{
    if (tag && sortedBy) {
        switch (sortedBy) {
            case WaxAPIClientTagSortTypeRank:{
                [self fetchFeedFromPath:@"feeds/tag" tagOrPersonID:tag infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
                    if (completion) {
                        completion(list, error);
                    }
                }];
            }break;
            case WaxAPIClientTagSortTypeRecent:{
                [self fetchFeedFromPath:@"feeds/tag_recent" tagOrPersonID:tag infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
                    if (completion) {
                        completion(list, error);
                    }
                }];
            }break;
        }
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke this method with nil paramaters"];
    }
}

#pragma mark - Users
-(void)toggleFollowUser:(NSString *)personID completion:(WaxAPIClientCompletionBlockTypeSimple)completion{
    if (personID) {
        
        [self postPath:@"users/put" parameters:@{@"personid":personID} modelClass:[PersonObject class] completionBlock:^(id model, NSError *error) {
            if (completion) {
                completion((error == nil), error);
            }
        }];

    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke this method with nil paramaters"];
    }
}
-(void)fetchProfileInformationForUser:(NSString *)personID completion:(WaxAPIClientCompletionBlockTypeUser)completion{
    if (personID) {
        
        [self postPath:@"users/profile" parameters:@{@"personid": personID} modelClass:[PersonObject class] completionBlock:^(id model, NSError *error) {
            if (completion) {
                completion(model, error);
            }
        }];
        
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke this method with nil paramaters"];
    }
}
-(void)fetchFollowersForUser:(NSString *)personID infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientCompletionBlockTypeList)completion{
    if (personID) {
        [self fetchPeopleFromPath:@"users/followers" personId:personID infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
            if (completion) {
                completion(list, error);
            }
        }];
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke this method with nil paramaters"];
    }
}
-(void)fetchFollowingForUser:(NSString *)personID infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientCompletionBlockTypeList)completion{
    if (personID) {
        [self fetchPeopleFromPath:@"users/following" personId:personID infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
            if (completion) {
                completion(list, error);
            }
        }];
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke this method with nil paramaters"];
    }
}
-(void)searchForUser:(NSString *)searchTerm infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientCompletionBlockTypeList)completion{
    if (searchTerm) {
        [self fetchPeopleFromPath:@"users/search" personId:searchTerm infiniteScrollingID:infiniteScrollingID completion:^(NSMutableArray *list, NSError *error) {
            if (completion) {
                completion(list, error);
            }
        }];
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke this method with nil paramaters"];
    }
}
-(void)syncFacebookProfilePictureWithCompletion:(WaxAPIClientCompletionBlockTypeSimple)completion{
    [self postPath:@"users/fbprofilepic" parameters:nil modelClass:nil completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion((model == nil), error); 
        }
    }];
}
#pragma mark - Videos
-(void)uploadVideoMetadata:(NSString *)videoLink videoLength:(NSNumber *)videoLength tag:(NSString *)tag category:(NSString *)category caption:(NSString *)caption location:(CLLocation *)location completion:(WaxAPIClientCompletionBlockTypeVideoUpload)completion{
    
}
-(void)fetchMetadataForVideo:(NSString *)videoID completion:(WaxAPIClientCompletionBlockTypeVideo)completion{
    if (videoID) {
        [self postPath:@"videos/put" parameters:@{@"videoid":videoID} modelClass:[VideoObject class] completionBlock:^(id model, NSError *error) {
            if (completion) {
                completion(model, error); 
            }
        }];
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke this method with nil paramaters"];
    }
}
-(void)voteUpVideo:(NSString *)videoID ofUser:(NSString *)personID completion:(WaxAPIClientCompletionBlockTypeSimple)completion{
    if (videoID && personID) {
        [self postPath:@"videos/vote" parameters:@{@"videoid":videoID, @"personid":personID} modelClass:nil completionBlock:^(id model, NSError *error) {
            if (completion) {
                completion((error == nil), error);
            }
        }];
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke this method with nil paramaters"];
    }
}
-(void)performAction:(WaxAPIClientVideoActionType)actionType onVideoID:(NSString *)videoID completion:(WaxAPIClientCompletionBlockTypeSimple)completion{
    
    if (actionType && videoID) {
        
        NSString *path = @"videos/";
        
        switch (actionType) {
            case WaxAPIClientVideoActionTypeView:{
                path = [path stringByAppendingString:@"view"]; 
            }break;
            case WaxAPIClientVideoActionTypeReport:{
                path = [path stringByAppendingString:@"flag"];
            }break;
            case WaxAPIClientVideoActionTypeDelete:{
                path = [path stringByAppendingString:@"delete"];
            }break;
        }
        [self postPath:path parameters:@{@"videoid": videoID} modelClass:nil completionBlock:^(id model, NSError *error) {
            if (completion) {
                completion((error == nil), error);
            }
        }];

    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke this method with nil paramaters"];
    }
}

#pragma mark - Settings
-(void)fetchSettingsWithCompletion:(WaxAPIClientCompletionBlockTypeSettings)completion{
    [self postPath:@"settings/get" parameters:nil modelClass:[SettingsObject class] completionBlock:^(id model, NSError *error) {
        if (completion) {
            completion(model, error); 
        }
    }];
}
-(void)updateSettings:(NSString *)email fullName:(NSString *)fullName pushSettings:(NSDictionary *)pushSettings completion:(WaxAPIClientCompletionBlockTypeSettings)completion{
    if (email && fullName && pushSettings) {
        [self postPath:@"settings/update" parameters:@{@"email":email, @"name":fullName, @"pushsettings":pushSettings} modelClass:[SettingsObject class] completionBlock:^(id model, NSError *error) {
            if (completion) {
                completion(model, error);
            }
        }];

    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot invoke this method with nil paramaters"];
    }
}


#pragma mark - Internal Methods
-(void)fetchFeedFromPath:(NSString *)path tagOrPersonID:(NSString *)tagOrPersonID infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientCompletionBlockTypeList)completion{

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:tagOrPersonID, @"feedid", infiniteScrollingID, @"lastitem", nil];
    
    [self postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObject:responseObject forArrayOfModelClass:[VideoObject class] withCompletionBlock:^(NSMutableArray *processedResponse, NSError *error) {
            if (completion) {
                completion(processedResponse, error);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error); 
        }
    }];
}

-(void)fetchPeopleFromPath:(NSString *)path personId:(NSString *)personId infiniteScrollingID:(NSNumber *)infiniteScrollingID completion:(WaxAPIClientCompletionBlockTypeList)completion{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:personId, @"personid", infiniteScrollingID, @"lastitem", nil];
    
    [self postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObject:responseObject forArrayOfModelClass:[PersonObject class] withCompletionBlock:^(NSMutableArray *processedResponse, NSError *error) {
            if (completion) {
                completion(processedResponse, error);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}
-(void)postPath:(NSString *)path parameters:(NSDictionary *)parameters modelClass:(Class)modelClass completionBlock:(void (^)(id model, NSError *error))completion{
    if (path) {
        [self postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processResponseObject:responseObject forModelClass:modelClass withCompletionBlock:^(id model, NSError *error) {
                if (completion) {
                    completion(model, error);
                }
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (completion) {
                completion(nil, error);
            }
        }];
    }else{
        [NSException raise:NSInvalidArgumentException format:@"Cannot post without a path!"];
    }
}
-(void)processResponseObject:(id)responseObject forArrayOfModelClass:(Class)modelClass withCompletionBlock:(void (^)(NSMutableArray *processedResponse, NSError *error))completion{
    
    dispatch_async(self.jsonProcessingQueue, ^{
        
        id validated = [self validateResponseObject:responseObject];
        
        if ([validated isKindOfClass:[NSError class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil, validated);
                }
            });
        }else{
            NSArray *rawDictionaries = validated;
            NSMutableArray *modelObjectArray = [NSMutableArray arrayWithCapacity:rawDictionaries.count];
            
            for(NSDictionary *dictionary in modelObjectArray) {
                id modelObject = [[modelClass alloc] initWithDictionary:dictionary];
                [modelObjectArray addObject:modelObject];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(modelObjectArray, nil);
                }
            });
        }
    });
}
-(void)processResponseObject:(id)responseObject forModelClass:(Class)modelClass withCompletionBlock:(void (^)(id model, NSError *error))completion{

    dispatch_async(self.jsonProcessingQueue, ^{
        
        id validated = [self validateResponseObject:responseObject];
        
        if ([validated isKindOfClass:[NSError class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil, validated);
                }
            });
        }else{
            id modelObject = nil; 
            if (modelClass) {
                modelObject = [[modelClass alloc] initWithDictionary:validated];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(modelObject, nil);
                }
            });
        }
    });
}
//this method checks that the request was completed and returns the raw response object or error. also handles logging user out when getting a token error (error 9999)
-(id)validateResponseObject:(id)responseObject{
    
    id returnObject = nil;
    
    if (responseObject) {
        if ([[[responseObject objectForKeyOrNil:kWaxAPIJSONKey] objectForKeyOrNil:@"complete"] boolValue]) {
            returnObject = [[responseObject objectForKeyOrNil:kWaxAPIJSONKey] objectForKeyOrNil:@"data"];
        }else{
            NSError *error = [NSError waxAPIErrorFromResponse:[[responseObject objectForKeyOrNil:kWaxAPIJSONKey] objectForKeyOrNil:@"error"]];
            if (error.code == 9999) {
                [[WaxUser currentUser] logOut];
            }else{
                returnObject = error;
            }
        }
    }

    return returnObject;

//
//    
//    
//    
//    
//    
//    
//    
//    
//    id returnObject = responseObject;
//    
//    if (responseObject) {
//        
//        if ([[[[responseObject objectForKeyOrNil:kWaxAPIJSONKey] objectAtIndexOrNil:0] objectForKeyOrNil:kWaxAPIJSONKey] isEqualToString:kFalseString]) {
//#ifdef DEBUG
//            DLog(@"LOGGED OUT DUE TO INVALID TOKEN");
//#else
//            [[WaxUser currentUser] logOut];
//#endif
//            [[AIKErrorManager sharedManager] logMessageToAllServices:[NSString stringWithFormat:@"response object failed validation and logged user out %@", responseObject]];
//            
//            returnObject = nil;
//            
//        }else if ([[[responseObject objectForKeyOrNil:kWaxAPIJSONKey] objectAtIndexOrNil:0] objectForKeyOrNil:@"error"]){
//            NSError *error = [NSError waxAPIErrorFromResponse:[[[responseObject objectForKeyOrNil:kWaxAPIJSONKey] objectAtIndexOrNil:0] objectForKeyOrNil:@"error"]];
//            
//            returnObject = error;
//        }
//    }
//    return returnObject;
}
























@end